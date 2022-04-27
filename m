Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732C951190B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiD0ODW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 10:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiD0ODV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 10:03:21 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id F0F7B48E6F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 07:00:09 -0700 (PDT)
Received: (qmail 874063 invoked by uid 1000); 27 Apr 2022 10:00:08 -0400
Date:   Wed, 27 Apr 2022 10:00:08 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net] usbnet: smsc95xx: Fix deadlock on runtime resume
Message-ID: <YmlMaE53+EhRz5it@rowland.harvard.edu>
References: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:41:49AM +0200, Lukas Wunner wrote:
> Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
> smsc95xx_resume() to call phy_init_hw().  That function waits for the
> device to runtime resume even though it is placed in the runtime resume
> path, causing a deadlock.
> 
> The problem is that phy_init_hw() calls down to smsc95xx_mdiobus_read(),
> which never uses the _nopm variant of usbnet_read_cmd().  Amend it to
> autosense that it's called from the runtime resume/suspend path and use
> the _nopm variant if so.

...

> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 4ef61f6b85df..82b8feaa5162 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -285,11 +285,21 @@ static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
>  	__smsc95xx_mdio_write(dev, pdata->phydev->mdio.addr, idx, regval, 1);
>  }
>  
> +static bool smsc95xx_in_pm(struct usbnet *dev)
> +{
> +#ifdef CONFIG_PM
> +	return dev->udev->dev.power.runtime_status == RPM_RESUMING ||
> +	       dev->udev->dev.power.runtime_status == RPM_SUSPENDING;
> +#else
> +	return false;
> +#endif
> +}

This does not do what you want.  You want to know if this function is 
being called in the resume pathway, but all it really tells you is 
whether the function is being called while a resume is in progress (and 
it doesn't even do that very precisely because the code does not use the 
runtime-pm spinlock).  The resume could be running in a different 
thread, in which case you most definitely _would_ want to want for it to 
complete.

Alan Stern
