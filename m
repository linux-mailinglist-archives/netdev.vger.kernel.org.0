Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8126E44FFD3
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbhKOIPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229929AbhKOIPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 03:15:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831FB6108D;
        Mon, 15 Nov 2021 08:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636963933;
        bh=Qj7YaGcIIP2HcLMjkLqUqNHTsiCDawSQcqK/ooOr9Ik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mXhLcwyhqBqtkrEZ/0b51lvUtjd2qF+Qaa++H9RADtVtd7ZmYwMT8fsino3vDTJ0n
         nVBzfdVKJHy2t7ueFofbkN0y/VS6khi6LKkzWTtLSB3r+6r7+Ula818YGZBDCmyxqK
         8db8y3JL1tm5wZObr1bwdSA4DpSkr5TdFbn7+E2H8ZKKxE613VJjY/lFXT4fjZGK3c
         SgcURSA0wxki1TUZsrEs0eqDCD2I6ZdgKZcF+YH0YHx6GIW7wD2Y4KJoIgVFPnMFC/
         s6T6BUdXGATbJYQKqNST9thvfoRAPEXWx8dS7hCgSSDvg8oPeGiWMk/pwYDyP5vXWa
         6/PBiy2xknbAQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmX5r-0004x9-Mn; Mon, 15 Nov 2021 09:11:59 +0100
Date:   Mon, 15 Nov 2021 09:11:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: etas_es58x: fix error handling
Message-ID: <YZIWT9ATzN611n43@hovoldconsulting.com>
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
 <20211115075124.17713-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115075124.17713-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 10:51:24AM +0300, Pavel Skripkin wrote:
> When register_candev() fails there are 2 possible device states:
> NETREG_UNINITIALIZED and NETREG_UNREGISTERED. None of them are suitable
> for calling unregister_candev(), because of following checks in
> unregister_netdevice_many():
> 
> 	if (dev->reg_state == NETREG_UNINITIALIZED)
> 		WARN_ON(1);
> ...
> 	BUG_ON(dev->reg_state != NETREG_REGISTERED);
> 
> To avoid possible BUG_ON or WARN_ON let's free current netdev before
> returning from es58x_init_netdev() and leave others (registered)
> net devices for es58x_free_netdevs().
> 
> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes in v2:
> 	- Fixed Fixes: tag
> 	- Moved es58x_dev->netdev[channel_idx] initialization at the end
> 	  of the function
> 
> ---
>  drivers/net/can/usb/etas_es58x/es58x_core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
> index 96a13c770e4a..b3af8f2e32ac 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -2091,19 +2091,22 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
>  		return -ENOMEM;
>  	}
>  	SET_NETDEV_DEV(netdev, dev);
> -	es58x_dev->netdev[channel_idx] = netdev;
>  	es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
>  
>  	netdev->netdev_ops = &es58x_netdev_ops;
>  	netdev->flags |= IFF_ECHO;	/* We support local echo */
>  
>  	ret = register_candev(netdev);
> -	if (ret)
> +	if (ret) {
> +		free_candev(netdev);
>  		return ret;
> +	}
>  
>  	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
>  				       es58x_dev->param->dql_min_limit);
>  
> +	es58x_dev->netdev[channel_idx] = netdev;
> +

Just a drive-by comment: 

Are you sure about this move of the netdev[channel_idx] initialisation?
What happens if the registered can device is opened before you
initialise the pointer? NULL-deref in es58x_send_msg()?

You generally want the driver data fully initialised before you register
the device so this looks broken.

And either way it is arguably an unrelated change that should go in a
separate patch explaining why it is needed and safe.

>  	return ret;
>  }

Johan
