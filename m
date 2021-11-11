Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7128E44CF76
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhKKCIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233589AbhKKCIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 21:08:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 801B4601FF;
        Thu, 11 Nov 2021 02:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636596326;
        bh=Euo8pJf5r2nQ1RUa0eONcm78FdllQfuJ8l5c65xmtH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rSe5xIiRrvjz1iQWmSsWv1ycrJa3etMlHvpyMvXQuYE5Nfp1bd9noIKmfQkM+1ruQ
         mblGQfR2dHo65Yq1ZzF7CQwuOwST7rEKS53/bXvJ02llTY7N3x4Svv6jDrbTNn4iR/
         21KpLTcSRTcZtfUzqeaw4PLtCyc2bC0VVETLHKtVYjLtIB9tBveR1LDslXBZPxQKnw
         c95z3imdL9zSTf/Q5Y74kHw2eGAco/wwLjBWMNwl+F68B+EGgUc+XxJ7pTjii3hgVW
         Hz3N8NCIhBRmRfuIq5sMlPILLQX/jyDw5DU8flDPfmAYDcu7VAb8yIe3SsLNttC472
         XMqWy3WNJs0qQ==
Date:   Wed, 10 Nov 2021 18:05:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] hamradio: defer 6pack kfree after
 unregister_netdev
Message-ID: <20211110180525.20422f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211108103759.30541-1-linma@zju.edu.cn>
References: <20211108103721.30522-1-linma@zju.edu.cn>
        <20211108103759.30541-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Nov 2021 18:37:59 +0800 Lin Ma wrote:
> There is a possible race condition (use-after-free) like below
> 
>  (USE)                       |  (FREE)
>   dev_queue_xmit             |
>    __dev_queue_xmit          |
>     __dev_xmit_skb           |
>      sch_direct_xmit         | ...
>       xmit_one               |
>        netdev_start_xmit     | tty_ldisc_kill
>         __netdev_start_xmit  |  6pack_close
>          sp_xmit             |   kfree
>           sp_encaps          |
>                              |
> 
> According to the patch "defer ax25 kfree after unregister_netdev", this

This is the previous patch of the series? Maybe call it "previous
patch"?

> patch reorder the kfree after the unregister_netdev to avoid the possible
> UAF as the unregister_netdev() is well synchronized and won't return if
> there is a running routine.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

> diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> index 49f10053a794..bfdf89e54752 100644
> --- a/drivers/net/hamradio/6pack.c
> +++ b/drivers/net/hamradio/6pack.c
> @@ -672,11 +672,13 @@ static void sixpack_close(struct tty_struct *tty)
>  	del_timer_sync(&sp->tx_t);
>  	del_timer_sync(&sp->resync_t);
>  
> -	/* Free all 6pack frame buffers. */
> +	unregister_netdev(sp->dev);
> +
> +	/* Free all 6pack frame buffers after unreg. */
>  	kfree(sp->rbuff);
>  	kfree(sp->xbuff);
>  
> -	unregister_netdev(sp->dev);
> +	free_netdev(sp->dev);

You should mention in the commit message why you think it's safe to add
free_netdev() which wasn't here before...

This driver seems to be setting:

	dev->needs_free_netdev	= true;

so unregister_netdev() will free the netdev automatically.

That said I don't see a reason why this driver needs the automatic
cleanup.

You can either remove that setting and then you can call free_netdev()
like you do, or you need to move the cleanup to dev->priv_destructor.

>  }
>  
>  /* Perform I/O control on an active 6pack channel. */

