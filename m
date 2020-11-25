Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655ED2C4BA6
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbgKYX1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731837AbgKYX1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 18:27:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D052083E;
        Wed, 25 Nov 2020 23:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606346863;
        bh=2ORxzeYXD1/9dSUeQSNzq2Tm37TL5I/i9CHmroFYFY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yRk6sNrS/fKZbAx8tL5QbWN5DUII+Q9S96geIvRJz+nB3Rqr61+sLJB7kTuf6ZvqA
         vw/s9q5eqUTW5Uod4tQz06gzA/78RsjMbPscDLm59q+D67HvjE+ryIaRjEyZYKPcrC
         zWTGpVcBYtL0zWvDrPkDsD08qolRg3vBLsmuCSTQ=
Date:   Wed, 25 Nov 2020 15:27:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net/af_unix: don't create a path for a binded socket
Message-ID: <20201125152742.05800094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124122421.9859-1-kda@linux-powerpc.org>
References: <20201124122421.9859-1-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 15:24:21 +0300 Denis Kirjanov wrote:
> in the case of the socket which is bound to an adress
> there is no sense to create a path in the next attempts

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 41c3303c3357..fd76a8fe3907 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1021,7 +1021,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  
>  	err = -EINVAL;
>  	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
> -	    sunaddr->sun_family != AF_UNIX)
> +	    sunaddr->sun_family != AF_UNIX || u->addr)
>  		goto out;
>  
>  	if (addr_len == sizeof(short)) {
> @@ -1049,10 +1049,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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

Well, after your change the check on u->addr is no longer protected by
u->bindlock. Is that okay?
