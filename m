Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE2518560
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiECN07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiECN04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:26:56 -0400
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE06377DF
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 06:23:23 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 8207010171323;
        Tue,  3 May 2022 15:23:21 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 61726630FA12;
        Tue,  3 May 2022 15:23:21 +0200 (CEST)
X-Mailbox-Line: From e6117cf857bea9af718d8c92d9d553c8f3a35e0a Mon Sep 17 00:00:00 2001
Message-Id: <e6117cf857bea9af718d8c92d9d553c8f3a35e0a.1651574194.git.lukas@wunner.de>
In-Reply-To: <cover.1651574194.git.lukas@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 3 May 2022 15:15:04 +0200
Subject: [PATCH net-next v2 4/7] usbnet: smsc95xx: Avoid link settings race on
 interrupt reception
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Note that the semicolon on a line by itself added in smsc95xx_status()
is a placeholder for a function call which will be added in a subsequent
commit.  That function call will actually handle the INT_ENP_PHY_INT_
interrupt.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
Changes since v1:
 * Silence "Error updating MAC full duplex mode" warning if it's
   caused by hot-removal. (Oleksij Rempel)
 * Explain in commit message why a semicolon on a line by itself is
   temporarily added in smsc95xx_status(). (Andrew Lunn)

 drivers/net/usb/smsc95xx.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 6c37c7adde1b..6309ff8e75de 100644
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
@@ -583,14 +583,16 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	spin_unlock_irqrestore(&pdata->mac_cr_lock, flags);
 
 	ret = smsc95xx_write_reg(dev, MAC_CR, pdata->mac_cr);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		if (ret != -ENODEV)
+			netdev_warn(dev->net,
+				    "Error updating MAC full duplex mode\n");
+		return;
+	}
 
 	ret = smsc95xx_phy_update_flowcontrol(dev);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error updating PHY flow control\n");
-
-	return ret;
 }
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
@@ -607,7 +609,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
 	if (intdata & INT_ENP_PHY_INT_)
-		usbnet_defer_kevent(dev, EVENT_LINK_RESET);
+		;
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
@@ -1070,6 +1072,7 @@ static void smsc95xx_handle_link_change(struct net_device *net)
 	struct usbnet *dev = netdev_priv(net);
 
 	phy_print_status(net->phydev);
+	smsc95xx_mac_update_fullduplex(dev);
 	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
 }
 
@@ -1975,7 +1978,6 @@ static const struct driver_info smsc95xx_info = {
 	.description	= "smsc95xx USB 2.0 Ethernet",
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
-	.link_reset	= smsc95xx_link_reset,
 	.reset		= smsc95xx_reset,
 	.check_connect	= smsc95xx_start_phy,
 	.stop		= smsc95xx_stop,
-- 
2.35.2

