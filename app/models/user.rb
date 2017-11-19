# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  #
  #

  validates :login, uniqueness: true, presence: true

  ROLES = %w[super_admin admin contributor publisher librarian].freeze

  after_create :set_default_role

  has_many :edits
  has_many :new_items

  belongs_to :language, optional: true
  belongs_to :publisher, optional: true
  belongs_to :library, optional: true

  def role?(key)
    role == key.to_s
  end

  def set_as_super_admin(language)
    self.role        = 'super_admin'
    self.language_id = language.id

    save
  end

  def is_an_admin?
    %w[super_admin admin].include? role
  end

  private

  def set_default_role
    update_attribute :role, 'contributor' unless role
  end
end
