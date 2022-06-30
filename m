Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E4560FC5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiF3DuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3DuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:50:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9FF2FFD8;
        Wed, 29 Jun 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D89BCE12CC;
        Thu, 30 Jun 2022 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A735C34115;
        Thu, 30 Jun 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561014;
        bh=JPEafwGbkT01ZireQUy4if9aNorRS7SSTX6HGDu0NUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TumKcmgOxp/Weth9ScUf8HZhBO8Iqw8JUF2hdWw0AlKmgYUROK7VCr7y4lw65qWMA
         Tnmj2CW1vxOy7Gw7sHp7Vu4VCUV1l5mgLzLd+a3LtLoNdpIuKcMyhQXyRIWBucwc5F
         SP5WL36dfRbbeseRwMvuELLEihbITMLKUi33PciE/CB99HDg0zvoH5vux0OQPeAO/w
         ow8zBGfbKxJZzzBkdMFkpNlnZM+jPzrOlfWUJvl5hlJkg44hN3EMBv96DXYBS3GU6z
         mTV/yHoGxFhwpi8TyUZR3Ta/EWT0o5+owsSHFlnvQHR1p2IWUXnqwYhSOCrcDXHGis
         +9sRUD9PDm4OQ==
Date:   Wed, 29 Jun 2022 20:50:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbnet: use each random address only once
Message-ID: <20220629205013.6a7db024@kernel.org>
In-Reply-To: <20220629142149.1298-1-oneukum@suse.com>
References: <20220629142149.1298-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 16:21:49 +0200 Oliver Neukum wrote:
> Even random MACs should be unique to a device.
> Get a new one each time it is used.
> 
> This bug is as old as the driver.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/usbnet.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 02b915b1e142..a90aece93f4a 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1797,8 +1797,11 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	}
>  
>  	/* let userspace know we have a random address */
> -	if (ether_addr_equal(net->dev_addr, node_id))
> +	if (ether_addr_equal(net->dev_addr, node_id)) {
>  		net->addr_assign_type = NET_ADDR_RANDOM;
> +		/* next device needs a new one*/
> +		eth_random_addr(node_id);
> +	}
>  
>  	if ((dev->driver_info->flags & FLAG_WLAN) != 0)
>  		SET_NETDEV_DEVTYPE(net, &wlan_type);

Why is that node_id thing even there, can we just delete it?

Leave the address as all-zero and check if driver filled it in with:

	if (!is_valid_ether_addr(net->dev_addr))
		eth_hw_addr_random(net->dev_addr);
