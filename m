Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED4C4D5DDE
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiCKIve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241742AbiCKIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:51:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491AB56C28
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 00:50:28 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nSayY-0004ds-AX; Fri, 11 Mar 2022 09:50:18 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nSayV-005534-Oq; Fri, 11 Mar 2022 09:50:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: [PATCH net-next v2 4/4] net: usb: asix: suspend embedded PHY if external is used
Date:   Fri, 11 Mar 2022 09:50:14 +0100
Message-Id: <20220311085014.1210963-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311085014.1210963-1-o.rempel@pengutronix.de>
References: <20220311085014.1210963-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
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

In case external PHY is used, we need to take care of embedded PHY.
Since there are no methods to disable this PHY from the MAC side and
keeping RMII reference clock, we need to suspend it.

This patch will reduce electrical noise (PHY is continuing to send FLPs)
and power consumption by 0,22W.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v2:
- rename internal to embedded PHY
- add note about refclock dependency
---
 drivers/net/usb/asix.h         |  3 +++
 drivers/net/usb/asix_devices.c | 18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 072760d76a72..2c81236c6c7c 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -158,6 +158,8 @@
 #define AX_EEPROM_MAGIC		0xdeadbeef
 #define AX_EEPROM_LEN		0x200
 
+#define AX_EMBD_PHY_ADDR	0x10
+
 /* This structure cannot exceed sizeof(unsigned long [5]) AKA 20 bytes */
 struct asix_data {
 	u8 multi_filter[AX_MCAST_FILTER_SIZE];
@@ -183,6 +185,7 @@ struct asix_common_private {
 	struct asix_rx_fixup_info rx_fixup_info;
 	struct mii_bus *mdio;
 	struct phy_device *phydev;
+	struct phy_device *phydev_int;
 	u16 phy_addr;
 	bool embd_phy;
 	u8 chipcode;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 40046d23d986..4241852f392b 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -679,6 +679,22 @@ static int ax88772_init_phy(struct usbnet *dev)
 
 	phy_attached_info(priv->phydev);
 
+	if (priv->embd_phy)
+		return 0;
+
+	/* In case main PHY is not the embedded PHY and MAC is RMII clock
+	 * provider, we need to suspend embedded PHY by keeping PLL enabled
+	 * (AX_SWRESET_IPPD == 0).
+	 */
+	priv->phydev_int = mdiobus_get_phy(priv->mdio, AX_EMBD_PHY_ADDR);
+	if (!priv->phydev_int) {
+		netdev_err(dev->net, "Could not find internal PHY\n");
+		return -ENODEV;
+	}
+
+	priv->phydev_int->mac_managed_pm = 1;
+	phy_suspend(priv->phydev_int);
+
 	return 0;
 }
 
@@ -734,7 +750,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		return ret;
 
 	priv->phy_addr = ret;
-	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
+	priv->embd_phy = ((priv->phy_addr & 0x1f) == AX_EMBD_PHY_ADDR);
 
 	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1,
 			    &priv->chipcode, 0);
-- 
2.30.2

