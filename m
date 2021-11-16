Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089904533C6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhKPOON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:14:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237192AbhKPOOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Iv5VSSC4Ecjd38Gxj8zVbUekr4ny9zT1QOc7h6DY/9M=; b=Lp
        dyPZRDf4N1S+OeIr/8LArYt6Zwoh1sWh2JxIXvl8YDsv8OjhPXAHk6u2l9YZfzY7hfp3U1V9e1TmX
        vlFxMJUzcfTB7TXFCtyt275rcY8Yjb6hxo6s41guBkWG5rg70RCGN6fg1+lxNZ0XWCvYV6vAcpP0L
        Ry+TeLkR3JH/SUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmzAw-00Deow-7e; Tue, 16 Nov 2021 15:11:06 +0100
Date:   Tue, 16 Nov 2021 15:11:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helge Deller <deller@gmx.de>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        parisc-linux@vger.kernel.org
Subject: Re: [PATCH] atm: firestream: avoid conversion error during build
Message-ID: <YZO7+mcaAJvZPqTU@lunn.ch>
References: <YZOmQf6PM+SXiTHX@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZOmQf6PM+SXiTHX@ls3530>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 01:38:25PM +0100, Helge Deller wrote:
> Although the firestream driver isn't relevant for the parisc
> architecture, but it generates this compile error when CONFIG_TEST is
> defined:
> 
>  drivers/atm/firestream.c: In function ‘top_off_fp’:
>  arch/parisc/include/asm/io.h:8:25: error: conversion from ‘long unsigned int’ to ‘u32’ {aka ‘unsigned int’} changes value
>      from ‘18446744072635809792’ to ‘3221225472’ [-Werror=overflow]
>  drivers/atm/firestream.c:1494:29: note: in expansion of macro ‘virt_to_bus’
>             ne->next  = virt_to_bus (NULL);
> 
> ne->next is of type u32, so this patch avoids the error by casting
> the return value of virt_to_bus() to u32.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> ---
> 
> diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
> index 3bc3c314a467..8148a4ea194c 100644
> --- a/drivers/atm/firestream.c
> +++ b/drivers/atm/firestream.c
> @@ -1491,7 +1491,7 @@ static void top_off_fp (struct fs_dev *dev, struct freepool *fp,
>  			    skb, ne, skb->data, skb->head);
>  		n++;
>  		ne->flags = FP_FLAGS_EPI | fp->bufsize;
> -		ne->next  = virt_to_bus (NULL);
> +		ne->next  = (u32)virt_to_bus (NULL);
>  		ne->bsa   = virt_to_bus (skb->data);
>  		ne->aal_bufsize = fp->bufsize;
>  		ne->skb = skb;

Does virt_to_bus() make any sense on NULL? Maybe just assign NULL?

     Andrew
