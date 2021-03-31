Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D6B34FC6A
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhCaJQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhCaJPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 05:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9367B619BB;
        Wed, 31 Mar 2021 09:15:48 +0000 (UTC)
Date:   Wed, 31 Mar 2021 11:15:45 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Xie Yongji <xieyongji@bytedance.com>, hch@infradead.org
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 01/10] file: Export receive_fd() to modules
Message-ID: <20210331091545.lr572rwpyvrnji3w@wittgenstein>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-2-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210331080519.172-2-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 04:05:10PM +0800, Xie Yongji wrote:
> Export receive_fd() so that some modules can use
> it to pass file descriptor between processes without
> missing any security stuffs.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---

Yeah, as I said in the other mail I'd be comfortable with exposing just
this variant of the helper.
Maybe this should be a separate patch bundled together with Christoph's
patch to split parts of receive_fd() into a separate helper.
This would also allow us to simplify a few other codepaths in drivers as
well btw. I just took a hasty stab at two of them:

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index c119736ca56a..3c716bf6d84b 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3728,8 +3728,9 @@ static int binder_apply_fd_fixups(struct binder_proc *proc,
        int ret = 0;

        list_for_each_entry(fixup, &t->fd_fixups, fixup_entry) {
-               int fd = get_unused_fd_flags(O_CLOEXEC);
+               int fd = receive_fd(fixup->file, O_CLOEXEC);

+               fd = receive_fd(fixup->file, O_CLOEXEC);
                if (fd < 0) {
                        binder_debug(BINDER_DEBUG_TRANSACTION,
                                     "failed fd fixup txn %d fd %d\n",
@@ -3741,7 +3742,7 @@ static int binder_apply_fd_fixups(struct binder_proc *proc,
                             "fd fixup txn %d fd %d\n",
                             t->debug_id, fd);
                trace_binder_transaction_fd_recv(t, fd, fixup->offset);
-               fd_install(fd, fixup->file);
+               fput(fixup->file);
                fixup->file = NULL;
                if (binder_alloc_copy_to_buffer(&proc->alloc, t->buffer,
                                                fixup->offset, &fd,
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5e2374580e27..c3a6b6abb7f4 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -629,12 +629,6 @@ int ptm_open_peer(struct file *master, struct tty_struct *tty, int flags)
        if (tty->driver != ptm_driver)
                return -EIO;

-       fd = get_unused_fd_flags(flags);
-       if (fd < 0) {
-               retval = fd;
-               goto err;
-       }
-
        /* Compute the slave's path */
        path.mnt = devpts_mntget(master, tty->driver_data);
        if (IS_ERR(path.mnt)) {
@@ -650,7 +644,8 @@ int ptm_open_peer(struct file *master, struct tty_struct *tty, int flags)
                goto err_put;
        }

-       fd_install(fd, filp);
+       fd = receive_fd(filp, flags);
+       fput(filp);
        return fd;

 err_put:

>  fs/file.c            | 6 ++++++
>  include/linux/file.h | 7 +++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index dab120b71e44..d7d957217576 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -1108,6 +1108,12 @@ int __receive_fd(int fd, struct file *file, int __user *ufd, unsigned int o_flag
>  	return new_fd;
>  }
>  
> +int receive_fd(struct file *file, unsigned int o_flags)
> +{
> +	return __receive_fd(-1, file, NULL, o_flags);
> +}
> +EXPORT_SYMBOL(receive_fd);
> +
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  {
>  	int err = -EBADF;
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 225982792fa2..4667f9567d3e 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
>  
>  extern int __receive_fd(int fd, struct file *file, int __user *ufd,
>  			unsigned int o_flags);
> +
> +extern int receive_fd(struct file *file, unsigned int o_flags);
> +
>  static inline int receive_fd_user(struct file *file, int __user *ufd,
>  				  unsigned int o_flags)
>  {
> @@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
>  		return -EFAULT;
>  	return __receive_fd(-1, file, ufd, o_flags);
>  }
> -static inline int receive_fd(struct file *file, unsigned int o_flags)
> -{
> -	return __receive_fd(-1, file, NULL, o_flags);
> -}
>  static inline int receive_fd_replace(int fd, struct file *file, unsigned int o_flags)
>  {
>  	return __receive_fd(fd, file, NULL, o_flags);
> -- 
> 2.11.0
> 
