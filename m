Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55335110EE
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357984AbiD0GNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357985AbiD0GNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:13:30 -0400
X-Greylist: delayed 347 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 23:10:18 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26703222BD;
        Tue, 26 Apr 2022 23:10:16 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id F07E910321188;
        Wed, 27 Apr 2022 08:04:25 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id C4D1861ABA99;
        Wed, 27 Apr 2022 08:04:25 +0200 (CEST)
X-Mailbox-Line: From 28fd5a3d53a401cdf8ae0a116108702a46d2c7a2 Mon Sep 17 00:00:00 2001
Message-Id: <28fd5a3d53a401cdf8ae0a116108702a46d2c7a2.1651037513.git.lukas@wunner.de>
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 07:48:04 +0200
Subject: [PATCH net-next 4/7] usbnet: smsc95xx: Avoid link settings race on
 interrupt reception
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a PHY interrupt is signaled, the SMSC LAN95xx driver updates the
MAC full duplex mode and PHY flow control registers based on cached data
in struct phy_device:

  smsc95xx_status()                 # raises EVENT_LINK_RESET
    usbnet_deferred_kevent()
      smsc95xx_link_reset()         # uses cached data in phydev

Simultaneously, phylib polls link status once per second and updates
that cached data:

  phy_state_machine()
    phy_check_link_status()
      phy_read_status()
        lan87xx_read_status()
          genphy_read_status()      # updates cached data in phydev

If smsc95xx_link_reset() wins the race against genphy_read_status(),
the registers may be updated based on stale data.

E.g. if the link was previously down, phydev->duplex is set to
DUPLEX_UNKNOWN and that's what smsc95xx_link_reset() will use, even
though genphy_read_status() may update it to DUPLEX_FULL afterwards.

PHY interrupts are currently only enabled on suspend to trigger wakeup,
so the impact of the race is limited, but we're about to enable them
perpetually.

Avoid the race by delaying execution of smsc95xx_link_reset() until
phy_state_machine() has done its job and calls back via
smsc95xx_handle_link_change().

Signaling EVENT_LINK_RESET on wakeup is not necessary because phylib
picks up link status changes through polling.  So drop the declaration
of a ->link_reset() callback.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/usb/smsc95xx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 6c37c7adde1b..36abfaeae3c6 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -566,7 +566,7 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev)
 	return smsc95xx_write_reg(dev, AFC_CFG, afc_cfg);
 }
 
-static int smsc95xx_link_reset(struct usbnet *dev)
+static void smsc95xx_mac_update_fullduplex(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
@@ -583,14 +583,14 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	spin_unlock_irqrestore(&pdata->mac_cr_lock, flags);
 
 	ret = smsc95xx_write_reg(dev, MAC_CR, pdata->mac_cr);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		netdev_warn(dev->net, "Error updating MAC full duplex mode\n");
+		return;
+	}
 
 	ret = smsc95xx_phy_update_flowcontrol(dev);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error updating PHY flow control\n");
-
-	return ret;
 }
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
@@ -607,7 +607,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
 	if (intdata & INT_ENP_PHY_INT_)
-		usbnet_defer_kevent(dev, EVENT_LINK_RESET);
+		;
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
@@ -1070,6 +1070,7 @@ static void smsc95xx_handle_link_change(struct net_device *net)
 	struct usbnet *dev = netdev_priv(net);
 
 	phy_print_status(net->phydev);
+	smsc95xx_mac_update_fullduplex(dev);
 	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
 }
 
@@ -1975,7 +1976,6 @@ static const struct driver_info smsc95xx_info = {
 	.description	= "smsc95xx USB 2.0 Ethernet",
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
-	.link_reset	= smsc95xx_link_reset,
 	.reset		= smsc95xx_reset,
 	.check_connect	= smsc95xx_start_phy,
 	.stop		= smsc95xx_stop,
-- 
2.35.2

