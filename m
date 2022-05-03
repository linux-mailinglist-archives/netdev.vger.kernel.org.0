Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2EB518543
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiECNWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiECNWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:22:06 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F36032EFB;
        Tue,  3 May 2022 06:18:27 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id DBA87101E689E;
        Tue,  3 May 2022 15:18:25 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id A11DB630FA12;
        Tue,  3 May 2022 15:18:25 +0200 (CEST)
X-Mailbox-Line: From d921168f4838d5d033679452749d5e00b2672bac Mon Sep 17 00:00:00 2001
Message-Id: <d921168f4838d5d033679452749d5e00b2672bac.1651574194.git.lukas@wunner.de>
In-Reply-To: <cover.1651574194.git.lukas@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 3 May 2022 15:15:01 +0200
Subject: [PATCH net-next v2 1/7] usbnet: Run unregister_netdev() before
 unbind() again
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()")
sought to fix a use-after-free on disconnect of USB Ethernet adapters.

It turns out that a different fix is necessary to address the issue:
https://lore.kernel.org/netdev/18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de/

So the commit was not necessary.

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
in ->stop().

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: Martyn Welch <martyn.welch@collabora.com>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/usb/asix_devices.c | 6 +-----
 drivers/net/usb/smsc95xx.c     | 3 +--
 drivers/net/usb/usbnet.c       | 6 +++---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 38e47a93fb83..5b5eb630c4b7 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -795,11 +795,7 @@ static int ax88772_stop(struct usbnet *dev)
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
index 4ef61f6b85df..edf0492ad489 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1243,8 +1243,7 @@ static int smsc95xx_start_phy(struct usbnet *dev)
 
 static int smsc95xx_stop(struct usbnet *dev)
 {
-	if (dev->net->phydev)
-		phy_stop(dev->net->phydev);
+	phy_stop(dev->net->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 9a6450f796dc..36b24ec11650 100644
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
+		dev->driver_info->unbind(dev, intf);
+
 	usb_kill_urb(dev->interrupt);
 	usb_free_urb(dev->interrupt);
 	kfree(dev->padding_pkt);
-- 
2.35.2

