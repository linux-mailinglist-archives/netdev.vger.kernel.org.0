Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19EF2C94AD
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgLABan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgLABan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:30:43 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9FF520857;
        Tue,  1 Dec 2020 01:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606786202;
        bh=gIV/qoU4A9F6UBLwHtqRz/xiO+o/o9Q7MGlKLyPG3xQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZfXgopZLyuoZqeHhaH5QfC3dZ8wx1RyHUUksFcJYiN04eX+hb7S70rgAe2qpPIYk2
         1nY3g2C2QrwJze6W3oiuf5u5r6xCQu4LVB3ZRj2tAX1LN2EjSuFOEeZYMv+Swv/ecP
         pyds6B9lACocUmD9emZ9sdId/eIWyjeI+p+GCpng=
Date:   Mon, 30 Nov 2020 17:30:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] net/af_unix: don't create a path for a binded socket
Message-ID: <20201130173000.60acd3cc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130132747.29332-1-kda@linux-powerpc.org>
References: <20201130132747.29332-1-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 16:27:47 +0300 Denis Kirjanov wrote:
> in the case of the socket which is bound to an adress
> there is no sense to create a path in the next attempts
> 
> here is a program that shows the issue:
> 
> int main()
> {
>     int s;
>     struct sockaddr_un a;
> 
>     s = socket(AF_UNIX, SOCK_STREAM, 0);
>     if (s<0)
>         perror("socket() failed\n");
> 
>     printf("First bind()\n");
> 
>     memset(&a, 0, sizeof(a));
>     a.sun_family = AF_UNIX;
>     strncpy(a.sun_path, "/tmp/.first_bind", sizeof(a.sun_path));
> 
>     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
>         perror("bind() failed\n");
> 
>     printf("Second bind()\n");
> 
>     memset(&a, 0, sizeof(a));
>     a.sun_family = AF_UNIX;
>     strncpy(a.sun_path, "/tmp/.first_bind_failed", sizeof(a.sun_path));
> 
>     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
>         perror("bind() failed\n");
> }
> 
> kda@SLES15-SP2:~> ./test
> First bind()
> Second bind()
> bind() failed
> : Invalid argument
> 
> kda@SLES15-SP2:~> ls -la /tmp/.first_bind
> .first_bind         .first_bind_failed
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> 
> v2: move a new patch creation after the address assignment check.

It is a behavior change, but IDK if anyone can reasonably depend on
current behavior for anything useful. Otherwise LGTM.

Let's CC Al Viro, and maybe Christoph to get some more capable eyes 
on this.

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 41c3303c3357..ff2dd1d3536b 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1034,6 +1034,14 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  		goto out;
>  	addr_len = err;
>  
> +	err = mutex_lock_interruptible(&u->bindlock);
> +	if (err)
> +		goto out_put;
> +
> +	err = -EINVAL;
> +	if (u->addr)
> +		goto out_up;
> +
>  	if (sun_path[0]) {
>  		umode_t mode = S_IFSOCK |
>  		       (SOCK_INODE(sock)->i_mode & ~current_umask());
> @@ -1045,14 +1053,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  		}
>  	}
>  
> -	err = mutex_lock_interruptible(&u->bindlock);
> -	if (err)
> -		goto out_put;
> -
> -	err = -EINVAL;
> -	if (u->addr)
> -		goto out_up;
> -
>  	err = -ENOMEM;
>  	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
>  	if (!addr)

