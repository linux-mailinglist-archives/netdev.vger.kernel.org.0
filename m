Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7582CDB46
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgLCQbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:31:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgLCQbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:31:17 -0500
Date:   Thu, 3 Dec 2020 08:30:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607013037;
        bh=HBpDcc3kMTwN4zdWqa+G0O9mdWedSq3jLr1xMNO9H9U=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=r7kj1CybQUPY9xKgCTPqWTbBn/Mkj0JZGNoSOdqitGVBxtZvWTDgde3PqhGS3yi/7
         4VC6t9soQrrsizekVHZr4sLn8F/15fB/r/ygK7tOuT9IoSLqOPzStI85igbiWmZ7Rx
         ndrWsVualD+6v5Uo3W2khw3Cc1T1wsZgxBv3tJ4Nx0j0GLhYIvz8nwxwlBKUtDqH33
         cLLxzQ93/4YIjkKn8kPRFUt2zb5DyM9pLgswd8lV+p6Q84UoEgd0LPRVv1fQgcLKyD
         NFts/QEHh27NqqWuwZkUOLFFGKmPV79BaxMR3Vn/nthmlJu6uBlK/dmJgVY/0g6YP2
         zFYvaXwzvGbdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4] net/af_unix: don't create a path for a bound socket
Message-ID: <20201203083035.35b66fba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203081844.3205-1-kda@linux-powerpc.org>
References: <20201203081844.3205-1-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 11:18:44 +0300 Denis Kirjanov wrote:
> in the case of a socket which is already bound to an adress
> there is no sense to create a path in the next attempts

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 41c3303c3357..489d49a1739c 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1029,6 +1029,16 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  		goto out;
>  	}
>  
> +	/* check if we're already bound to a path */
> +	err = mutex_lock_interruptible(&u->bindlock);
> +	if (err)
> +		goto out;
> +	if (u->addr)
> +		err = -EINVAL;
> +	mutex_unlock(&u->bindlock);

This, like v1, is not atomic with the creation, two threads can pass
this check and then try to assign to u->addr.

Naive question - can't we add the removal of the unnecessary node in
the error path, in the kernel?

> +	if (err)
> +		goto out;
> +
>  	err = unix_mkname(sunaddr, addr_len, &hash);
>  	if (err < 0)
>  		goto out;
> @@ -1049,10 +1059,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  	if (err)
>  		goto out_put;
>  
> -	err = -EINVAL;
> -	if (u->addr)
> -		goto out_up;
> -
>  	err = -ENOMEM;
>  	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
>  	if (!addr)

