Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89A4216CF5
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 14:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgGGMi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 08:38:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39390 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGMi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 08:38:58 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jsmsB-0008IT-CA; Tue, 07 Jul 2020 12:38:55 +0000
Date:   Tue, 7 Jul 2020 14:38:54 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v6 5/7] fs: Expand __receive_fd() to accept existing fd
Message-ID: <20200707123854.wi4s2kzwkhkgieyv@wittgenstein>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200706201720.3482959-6-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 01:17:18PM -0700, Kees Cook wrote:
> Expand __receive_fd() with support for replace_fd() for the coming seccomp
> "addfd" ioctl(). Add new wrapper receive_fd_replace() for the new behavior
> and update existing wrappers to retain old behavior.
> 
> Thanks to Colin Ian King <colin.king@canonical.com> for pointing out an
> uninitialized variable exposure in an earlier version of this patch.
> 
> Reviewed-by: Sargun Dhillon <sargun@sargun.me>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Thanks!
(One tiny-nit below.)
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

>  fs/file.c            | 24 ++++++++++++++++++------
>  include/linux/file.h | 10 +++++++---
>  2 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 0efdcf413210..11313ff36802 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -937,6 +937,7 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  /**
>   * __receive_fd() - Install received file into file descriptor table
>   *
> + * @fd: fd to install into (if negative, a new fd will be allocated)
>   * @file: struct file that was received from another process
>   * @ufd: __user pointer to write new fd number to
>   * @o_flags: the O_* flags to apply to the new fd entry
> @@ -950,7 +951,7 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>   *
>   * Returns newly install fd or -ve on error.
>   */
> -int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> +int __receive_fd(int fd, struct file *file, int __user *ufd, unsigned int o_flags)
>  {
>  	struct socket *sock;
>  	int new_fd;
> @@ -960,18 +961,30 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
>  	if (error)
>  		return error;
>  
> -	new_fd = get_unused_fd_flags(o_flags);
> -	if (new_fd < 0)
> -		return new_fd;
> +	if (fd < 0) {
> +		new_fd = get_unused_fd_flags(o_flags);
> +		if (new_fd < 0)
> +			return new_fd;
> +	} else
> +		new_fd = fd;

This is nitpicky but coding style technically wants us to use braces
around both branches if one of them requires them. ;)

>  
>  	if (ufd) {
>  		error = put_user(new_fd, ufd);
>  		if (error) {
> -			put_unused_fd(new_fd);
> +			if (fd < 0)
> +				put_unused_fd(new_fd);
>  			return error;
>  		}
>  	}
>  
> +	if (fd < 0)
> +		fd_install(new_fd, get_file(file));
> +	else {
> +		error = replace_fd(new_fd, file, o_flags);
> +		if (error)
> +			return error;
> +	}
> +
>  	/*
>  	 * Bump the usage count and install the file. The resulting value of
>  	 * "error" is ignored here since we only need to take action when
> @@ -982,7 +995,6 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
>  		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
>  		sock_update_classid(&sock->sk->sk_cgrp_data);
>  	}
> -	fd_install(new_fd, get_file(file));
>  	return new_fd;
>  }
>  
> diff --git a/include/linux/file.h b/include/linux/file.h
> index d9fee9f5c8da..225982792fa2 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -92,18 +92,22 @@ extern void put_unused_fd(unsigned int fd);
>  
>  extern void fd_install(unsigned int fd, struct file *file);
>  
> -extern int __receive_fd(struct file *file, int __user *ufd,
> +extern int __receive_fd(int fd, struct file *file, int __user *ufd,
>  			unsigned int o_flags);
>  static inline int receive_fd_user(struct file *file, int __user *ufd,
>  				  unsigned int o_flags)
>  {
>  	if (ufd == NULL)
>  		return -EFAULT;
> -	return __receive_fd(file, ufd, o_flags);
> +	return __receive_fd(-1, file, ufd, o_flags);
>  }
>  static inline int receive_fd(struct file *file, unsigned int o_flags)
>  {
> -	return __receive_fd(file, NULL, o_flags);
> +	return __receive_fd(-1, file, NULL, o_flags);
> +}
> +static inline int receive_fd_replace(int fd, struct file *file, unsigned int o_flags)
> +{
> +	return __receive_fd(fd, file, NULL, o_flags);
>  }
>  
>  extern void flush_delayed_fput(void);
> -- 
> 2.25.1
> 
