Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A984ED6FA
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiCaJcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiCaJce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:32:34 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3281AAA72
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:30:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 0907A2804CB46;
        Thu, 31 Mar 2022 11:30:41 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id F153E32A73; Thu, 31 Mar 2022 11:30:40 +0200 (CEST)
Date:   Thu, 31 Mar 2022 11:30:40 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220331093040.GA20035@wunner.de>
References: <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de>
 <Yjh5Qz8XX1ltiRUM@lunn.ch>
 <20220326123929.GB31022@wunner.de>
 <Yj8L2Jl0yyHIyW1m@lunn.ch>
 <20220326130430.GD31022@wunner.de>
 <20220327083702.GC27264@pengutronix.de>
 <37ff78db-8de5-56c0-3da2-9effc17b4e41@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ff78db-8de5-56c0-3da2-9effc17b4e41@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 11:20:50AM +0200, Oliver Neukum wrote:
> I am afraid, putting my
> maintainer's hat on, I have to point on that we have a stable tree for
> which we will need some solution.
> 
> Nor can usbnet exclusively cater to device that expose their PHY
> over MDIO. (or at all really). Intuitively I must say that exactly reversing
> the order of probe() in disconnect() is kind of the default.
> If there is a need to deviate from that, of course we will acomodate that,
> but making this the exclusive order is another matter.
> 
> I really get that you want to discuss this matter exhaustively, but we
> need to
> come to some kind of conclusion.

I propose the below patch.  If you could provide more details on the
regressions you've reported (+ ideally bugzilla links), I'll be happy
to include them in the commit message.  Thanks!

-- >8 --
Subject: [PATCH] usbnet: Run unregister_netdev() before unbind() again

Oliver says he got bug reports that commit 2c9d6c2b871d ("usbnet: run
unbind() before unregister_netdev()") is causing regressions.

The commit made binding and unbinding of USB Ethernet asymmetrical:
Before, usbnet_probe() first invoked the ->bind() callback and then
register_netdev().  usbnet_disconnect() mirrored that by first invoking
unregister_netdev() and then ->unbind().

Since the commit, the order in usbnet_disconnect() is reversed and no
longer mirrors usbnet_probe().

One consequence is that a PHY disconnected (and stopped) in ->unbind()
is afterwards stopped once more by unregister_netdev() as it closes the
netdev before unregistering.  That necessitates a contortion in ->stop()
because the PHY may only be stopped if it hasn't already been
disconnected.

Reverting the commit allows making the call to phy_stop() unconditional
in ->stop() and also fixes the issues reported by Oliver.

Fixes: 2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()")
Link: https://lore.kernel.org/netdev/62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com/
Reported-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.14+
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Martyn Welch <martyn.welch@collabora.com>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/usb/asix_devices.c | 6 +-----
 drivers/net/usb/smsc95xx.c     | 3 +--
 drivers/net/usb/usbnet.c       | 6 +++---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 4514d35..7d569f0 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -794,11 +794,7 @@ static int ax88772_stop(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 
-	/* On unplugged USB, we will get MDIO communication errors and the
-	 * PHY will be set in to PHY_HALTED state.
-	 */
-	if (priv->phydev->state != PHY_HALTED)
-		phy_stop(priv->phydev);
+	phy_stop(priv->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 193635e..3dc6df6 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1280,8 +1280,7 @@ static int smsc95xx_start_phy(struct usbnet *dev)
 
 static int smsc95xx_stop(struct usbnet *dev)
 {
-	if (dev->net->phydev)
-		phy_stop(dev->net->phydev);
+	phy_stop(dev->net->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 9a6450f..e8b4a93 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1616,9 +1616,6 @@ void usbnet_disconnect (struct usb_interface *intf)
 		   xdev->bus->bus_name, xdev->devpath,
 		   dev->driver_info->description);
 
-	if (dev->driver_info->unbind)
-		dev->driver_info->unbind(dev, intf);
-
 	net = dev->net;
 	unregister_netdev (net);
 
@@ -1626,6 +1623,9 @@ void usbnet_disconnect (struct usb_interface *intf)
 
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
+	if (dev->driver_info->unbind)
+		dev->driver_info->unbind (dev, intf);
+
 	usb_kill_urb(dev->interrupt);
 	usb_free_urb(dev->interrupt);
 	kfree(dev->padding_pkt);
-- 
2.34.1

