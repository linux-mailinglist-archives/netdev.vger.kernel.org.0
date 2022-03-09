Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FCA4D3134
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbiCIOqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiCIOqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:46:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F43A13CA02
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:45:35 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRxZ6-00016d-RG; Wed, 09 Mar 2022 15:45:24 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRxZ5-0001o8-Uy; Wed, 09 Mar 2022 15:45:23 +0100
Date:   Wed, 9 Mar 2022 15:45:23 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: Re: net: asix: best way to handle orphan PHYs
Message-ID: <20220309144523.GE15680@pengutronix.de>
References: <20220309121835.GA15680@pengutronix.de>
 <YiisJogt/WO5gLId@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YiisJogt/WO5gLId@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:34:30 up 88 days, 22:20, 90 users,  load average: 2.55, 1.39,
 0.69
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Mar 09, 2022 at 02:31:18PM +0100, Andrew Lunn wrote:
> On Wed, Mar 09, 2022 at 01:18:35PM +0100, Oleksij Rempel wrote:
> > Hello all,
> > 
> > I have ASIX based USB Ethernet adapter with two PHYs: internal and
> > external. The internal PHY is enabled by default and there seems to be
> > no way to disable internal PHY on the MAC level without affecting the
> > external PHY.
> > 
> > What is the preferred method to suspend internal PHY?
> > Currently I have following options:
> > - suspend PHY in the probe function of the PHY driver
> > - get the phydev in the MAC driver and call phy_suspend()
> > - whisper magic numbers from the MAC driver directly this the MDIO bus.
> > 
> > Are there other options?
> 
> Hi Oleksij
> 
> Can you unique identity this device? Does it have a custom VID:PID?

No, currently it has generic VID:PID.

> It seems like suspending it in the PHY driver would be messy. How do
> you identify the PHY is part of your devices and should be suspended?

EEPROM provides information, which PHY address should be used. If
address is 0x10, it is internal PHY. Different parts of ASIX driver use
this logic.

> Doing it from the MAC driver seems better, your identification
> information is close to hand.
> 
> I would avoid the magic numbers, since phy_suspend() makes it clear
> what you are doing.
> 
> Is there one MDIO bus with two devices, or two MDIO busses?  If there
> are two busses, you could maybe add an extra flag to the bus structure
> you pass to mdiobus_register() which indicates it should suspend all
> PHY it finds on the bus during enumeration of the bus. Generally we
> don't want this, if the PHY has link already we want to keep it, to
> avoid the 1.5s delay causes by autoneg. But if we know the PHYs on the
> bus are not going to be used, it would be a good point to suspend
> them.

It is one MDIO bus with multiple PHYs one of them is the internal PHY.
ax88772 seems to provide way to put the PHY to reset from one of MAC
register. See drivers/net/usb/asix_devices.c
ax88772_hw_reset()
  if (priv->embd_phy)
    ...
  else
    asix_sw_reset(dev, AX_SWRESET_IPPD | AX_SWRESET_PRL,

But this way is not working for the ax88772b variant.

Ok, so if phy_suspend() is the preffered way, I need to get phydev
without attaching it. Correct? Do we already have some helpers to do it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
