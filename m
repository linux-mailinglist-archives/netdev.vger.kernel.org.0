Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5E1FEE2F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgFRI5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:57:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45062 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgFRI4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:56:41 -0400
Received: from ip-109-41-0-102.web.vodafone.de ([109.41.0.102] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jlqLL-0003gc-FO; Thu, 18 Jun 2020 08:56:20 +0000
Date:   Thu, 18 Jun 2020 10:56:14 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 02/11] fs: Move __scm_install_fd() to
 __fd_install_received()
Message-ID: <20200618085614.fw3ynalpcipbplf3@wittgenstein>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200616032524.460144-3-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 08:25:15PM -0700, Kees Cook wrote:
> In preparation for users of the "install a received file" logic outside
> of net/ (pidfd and seccomp), relocate and rename __scm_install_fd() from
> net/core/scm.c to __fd_install_received() in fs/file.c, and provide a
> wrapper named fd_install_received_user(), as future patches will change
> the interface to __fd_install_received().
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/file.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/file.h |  8 ++++++++
>  include/net/scm.h    |  1 -
>  net/compat.c         |  2 +-
>  net/core/scm.c       | 32 +-----------------------------
>  5 files changed, 57 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index abb8b7081d7a..fcfddae0d252 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -11,6 +11,7 @@
>  #include <linux/export.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include <linux/net.h>
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
>  #include <linux/file.h>
> @@ -18,6 +19,8 @@
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> +#include <net/cls_cgroup.h>
> +#include <net/netprio_cgroup.h>
>  
>  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
>  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> @@ -931,6 +934,50 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  	return err;
>  }
>  
> +/**
> + * __fd_install_received() - Install received file into file descriptor table
> + *
> + * @fd: fd to install into (if negative, a new fd will be allocated)
> + * @file: struct file that was received from another process
> + * @ufd_required: true to use @ufd for writing fd number to userspace
> + * @ufd: __user pointer to write new fd number to
> + * @o_flags: the O_* flags to apply to the new fd entry
> + *
> + * Installs a received file into the file descriptor table, with appropriate
> + * checks and count updates. Optionally writes the fd number to userspace.
> + *
> + * Returns -ve on error.
> + */
> +int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_flags)
> +{
> +	struct socket *sock;
> +	int new_fd;
> +	int error;
> +
> +	error = security_file_receive(file);
> +	if (error)
> +		return error;
> +
> +	new_fd = get_unused_fd_flags(o_flags);
> +	if (new_fd < 0)
> +		return new_fd;
> +
> +	error = put_user(new_fd, ufd);
> +	if (error) {
> +		put_unused_fd(new_fd);
> +		return error;
> +	}
> +
> +	/* Bump the usage count and install the file. */
> +	sock = sock_from_file(file, &error);
> +	if (sock) {
> +		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> +		sock_update_classid(&sock->sk->sk_cgrp_data);
> +	}
> +	fd_install(new_fd, get_file(file));
> +	return 0;
> +}
> +
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  {
>  	int err = -EBADF;
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 122f80084a3e..fe18a1a0d555 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -91,6 +91,14 @@ extern void put_unused_fd(unsigned int fd);
>  
>  extern void fd_install(unsigned int fd, struct file *file);
>  
> +extern int __fd_install_received(struct file *file, int __user *ufd,
> +				 unsigned int o_flags);
> +static inline int fd_install_received_user(struct file *file, int __user *ufd,
> +					   unsigned int o_flags)
> +{
> +	return __fd_install_received(file, ufd, o_flags);
> +}

Shouldn't this be the other way around such that
fd_install_received_user() is the workhorse that has a "ufd" argument
and fd_install_received() is the static inline function that doesn't?

extern int fd_install_received_user(struct file *file, int __user *ufd, unsigned int o_flags)
static inline int fd_install_received(struct file *file, unsigned int o_flags)
{
	return fd_install_received_user(file, NULL, o_flags);
}

(So I'm on vacation this week some my reviews are selective and spotty
but I promise to be back next week. :))

Christian

> +
>  extern void flush_delayed_fput(void);
>  extern void __fput_sync(struct file *);
>  
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 581a94d6c613..1ce365f4c256 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -37,7 +37,6 @@ struct scm_cookie {
>  #endif
>  };
>  
> -int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags);
>  void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
>  void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
>  int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
> diff --git a/net/compat.c b/net/compat.c
> index 27d477fdcaa0..94f288e8dac5 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -298,7 +298,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
>  	int err = 0, i;
>  
>  	for (i = 0; i < fdmax; i++) {
> -		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> +		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
>  		if (err)
>  			break;
>  	}
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 6151678c73ed..df190f1fdd28 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -280,36 +280,6 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
>  }
>  EXPORT_SYMBOL(put_cmsg_scm_timestamping);
>  
> -int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> -{
> -	struct socket *sock;
> -	int new_fd;
> -	int error;
> -
> -	error = security_file_receive(file);
> -	if (error)
> -		return error;
> -
> -	new_fd = get_unused_fd_flags(o_flags);
> -	if (new_fd < 0)
> -		return new_fd;
> -
> -	error = put_user(new_fd, ufd);
> -	if (error) {
> -		put_unused_fd(new_fd);
> -		return error;
> -	}
> -
> -	/* Bump the usage count and install the file. */
> -	sock = sock_from_file(file, &error);
> -	if (sock) {
> -		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> -		sock_update_classid(&sock->sk->sk_cgrp_data);
> -	}
> -	fd_install(new_fd, get_file(file));
> -	return 0;
> -}
> -
>  static int scm_max_fds(struct msghdr *msg)
>  {
>  	if (msg->msg_controllen <= sizeof(struct cmsghdr))
> @@ -336,7 +306,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	}
>  
>  	for (i = 0; i < fdmax; i++) {
> -		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> +		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
>  		if (err)
>  			break;
>  	}
> -- 
> 2.25.1
> 
