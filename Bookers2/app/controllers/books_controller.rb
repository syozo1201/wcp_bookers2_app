class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user, {only: [:edit,:update,:destroy]}

  def create
        @book = Book.new(book_params)
        @book.user_id = current_user.id
        if @book.save
            flash[:notice] = "successfully."
            redirect_to book_path(@book)
        else
            flash[:notice] = "error"
            @books = Book.all
            @user = current_user
            render :index
        end
  end

  def index
      @books = Book.all
      @user = current_user
      @book = Book.new
  end

  def show
      @book = Book.new
		  @bookdetail = Book.find(params[:id])
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    flash[:destroy] = 'Book was successfully destroyed.'
    redirect_to books_path
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
    flash[:notice] = 'Book was successfully created.'
    redirect_to book_path(@book.id)
    else
      render 'edit'
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end

  def  ensure_current_user
      @book = Book.find(params[:id])
     if @book.user_id != current_user.id
        redirect_to books_path
     end
  end
end
