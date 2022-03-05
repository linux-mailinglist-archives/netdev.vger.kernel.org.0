Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A362D4CE691
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 20:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiCETZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 14:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiCETZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 14:25:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414B06543E;
        Sat,  5 Mar 2022 11:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yrx8ht9NZcrQJYOC0V0Ca9xcir3qoFzCwITXJAjkwsU=; b=suFLYLG4rtdteEUBCP3FRM654e
        S8zjIUDXwxw3yNsjEGJjHHr0/9oNM5fbpK/4XIlRHiyne3GMz9GQraEW0b3MiI9zRbcav/dOcOVYI
        wKHscnXqYzCmWvvIYI81L+bjeLqVLVDZgHUOukgq7n5jjk/0NXZab0pASDh2KRHYcE78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQa1L-009PVt-GV; Sat, 05 Mar 2022 20:24:51 +0100
Date:   Sat, 5 Mar 2022 20:24:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, fntoth@gmail.com,
        martyn.welch@collabora.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH] smsc95xx: Ignore -ENODEV errors when device is unplugged
Message-ID: <YiO5Ayetj9aCRkmR@lunn.ch>
References: <20220305184503.2954013-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220305184503.2954013-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 03:45:03PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> According to Documentation/driver-api/usb/URB.rst when a device
> is unplugged usb_submit_urb() returns -ENODEV.
> 
> This error code propagates all the way up to usbnet_read_cmd() and
> usbnet_write_cmd() calls inside the smsc95xx.c driver during
> Ethernet cable unplug, unbind or reboot.
> 
> This causes the following errors to be shown on reboot, for example:
> 
> ci_hdrc ci_hdrc.1: remove, state 1
> usb usb2: USB disconnect, device number 1
> usb 2-1: USB disconnect, device number 2
> usb 2-1.1: USB disconnect, device number 3
> smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
> smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
> usb 2-1.4: USB disconnect, device number 4
> ci_hdrc ci_hdrc.1: USB bus 2 deregistered
> ci_hdrc ci_hdrc.0: remove, state 4
> usb usb1: USB disconnect, device number 1
> ci_hdrc ci_hdrc.0: USB bus 1 deregistered
> imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
> reboot: Restarting system
> 
> Ignore the -ENODEV errors inside __smsc95xx_mdio_read() and
> __smsc95xx_phy_wait_not_busy() and do not print error messages
> when -ENODEV is returned.
> 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Hi,
> 
> Tested on 5.10.102 and 5.17-rc6.

Please indicate what tree this patch is actually for. It should be
against net, since you want it backporting. Please see the netdev FAQ.
Please also include a Fixes: tag.

> @@ -84,7 +84,7 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
>  	ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
>  		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  		 0, index, &buf, 4);
> -	if (unlikely(ret < 0)) {
> +	if (ret < 0 && ret != -ENODEV) {
>  		netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
>  			    index, ret);
>  		return ret;

I suspect this will result in kasan warnings. The contents of buf is
probably undefined because of the error, yet you continue to set *data
to it. You probably need to explicitly handle the ENODEV case setting
*data to some value.

      Andrew
