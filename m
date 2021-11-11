Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D6144D7C8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhKKOHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhKKOH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:07:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B70E610CB;
        Thu, 11 Nov 2021 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636639480;
        bh=pgDoLydVad6OtF8Lu/bwZVoIn5pmTsMuCbI+UBIS9OY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IBnUGKRV5o3B9vk35+C9Hp8qApaRrLL3XyTMxaBYwgnAn/IfPB4Ayb2nVoQUFcgun
         goe/puLV3MymANz3GdvXC9GhqS5TpD+1VyUbj8t7TcZ6xEF9KCLzJhlWe46OXZZ9YU
         IJACx5eOW8KXdJV2SsqGAWRdOPKj/1RplD7btV8l4diZkGb4VRiFYFPyD5cjn4HNpr
         qS3/YoSrmZchSfwtlFa2YRNjl2fyfeG7EcH5zRe9tEPj7FqAKpKvpY/7WgkZdDnGJE
         VJIRIX/Xy8LqQ72JbD517wZxSCtBxnBIyF0YYzoZuRHWw6N3tEKZH31y5LT80h2czo
         3MgLgw3uhAA7g==
Date:   Thu, 11 Nov 2021 06:04:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0] hamradio: delete unnecessary free_netdev()
Message-ID: <20211111060439.7d34f189@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111140007.7244-1-linma@zju.edu.cn>
References: <20211111140007.7244-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 22:00:07 +0800 Lin Ma wrote:
> The former patch "defer 6pack kfree after unregister_netdev" adds
> free_netdev() function in sixpack_close(), which is a bad copy from the
> similar code in mkiss_close(). However, this free is unnecessary as the
> flag needs_free_netdev is set to true in sp_setup(), hence the
> unregister_netdev() will free the netdev automatically.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
>  drivers/net/hamradio/6pack.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> index bfdf89e54752..180c8f08169b 100644
> --- a/drivers/net/hamradio/6pack.c
> +++ b/drivers/net/hamradio/6pack.c
> @@ -677,8 +677,6 @@ static void sixpack_close(struct tty_struct *tty)
>  	/* Free all 6pack frame buffers after unreg. */
>  	kfree(sp->rbuff);
>  	kfree(sp->xbuff);
> -
> -	free_netdev(sp->dev);

sp is netdev_priv() tho, so this is now a UAF. I'd go for removing the
needs_free_netdev = true instead.

>  }
>  
>  /* Perform I/O control on an active 6pack channel. */

