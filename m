Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6B3A3A96
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhFKD6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhFKD6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:58:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A9C0617AD
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 20:56:21 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrYH6-0005B6-1C; Fri, 11 Jun 2021 05:56:04 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrYH3-0003Sc-4D; Fri, 11 Jun 2021 05:56:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jon Hunter <jonathanh@nvidia.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: usb: asix: ax88772: manage PHY PM from MAC
Date:   Fri, 11 Jun 2021 05:55:59 +0200
Message-Id: <20210611035559.13252-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take over PHY power management, otherwise PHY framework will try to
access ASIX MDIO bus before MAC resume was completed.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/net/usb/asix_devices.c | 43 ++++++++++------------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 8a477171e8f5..aec97b021a73 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -598,6 +598,9 @@ static void ax88772_suspend(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	u16 medium;
 
+	if (netif_running(dev->net))
+		phy_stop(priv->phydev);
+
 	/* Stop MAC operation */
 	medium = asix_read_medium_status(dev, 1);
 	medium &= ~AX_MEDIUM_RE;
@@ -605,14 +608,6 @@ static void ax88772_suspend(struct usbnet *dev)
 
 	netdev_dbg(dev->net, "ax88772_suspend: medium=0x%04x\n",
 		   asix_read_medium_status(dev, 1));
-
-	/* Preserve BMCR for restoring */
-	priv->presvd_phy_bmcr =
-		asix_mdio_read_nopm(dev->net, dev->mii.phy_id, MII_BMCR);
-
-	/* Preserve ANAR for restoring */
-	priv->presvd_phy_advertise =
-		asix_mdio_read_nopm(dev->net, dev->mii.phy_id, MII_ADVERTISE);
 }
 
 static int asix_suspend(struct usb_interface *intf, pm_message_t message)
@@ -626,39 +621,22 @@ static int asix_suspend(struct usb_interface *intf, pm_message_t message)
 	return usbnet_suspend(intf, message);
 }
 
-static void ax88772_restore_phy(struct usbnet *dev)
-{
-	struct asix_common_private *priv = dev->driver_priv;
-
-	if (priv->presvd_phy_advertise) {
-		/* Restore Advertisement control reg */
-		asix_mdio_write_nopm(dev->net, dev->mii.phy_id, MII_ADVERTISE,
-				     priv->presvd_phy_advertise);
-
-		/* Restore BMCR */
-		if (priv->presvd_phy_bmcr & BMCR_ANENABLE)
-			priv->presvd_phy_bmcr |= BMCR_ANRESTART;
-
-		asix_mdio_write_nopm(dev->net, dev->mii.phy_id, MII_BMCR,
-				     priv->presvd_phy_bmcr);
-
-		priv->presvd_phy_advertise = 0;
-		priv->presvd_phy_bmcr = 0;
-	}
-}
-
 static void ax88772_resume(struct usbnet *dev)
 {
+	struct asix_common_private *priv = dev->driver_priv;
 	int i;
 
 	for (i = 0; i < 3; i++)
 		if (!ax88772_hw_reset(dev, 1))
 			break;
-	ax88772_restore_phy(dev);
+
+	if (netif_running(dev->net))
+		phy_start(priv->phydev);
 }
 
 static void ax88772a_resume(struct usbnet *dev)
 {
+	struct asix_common_private *priv = dev->driver_priv;
 	int i;
 
 	for (i = 0; i < 3; i++) {
@@ -666,7 +644,8 @@ static void ax88772a_resume(struct usbnet *dev)
 			break;
 	}
 
-	ax88772_restore_phy(dev);
+	if (netif_running(dev->net))
+		phy_start(priv->phydev);
 }
 
 static int asix_resume(struct usb_interface *intf)
@@ -722,6 +701,8 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return ret;
 	}
 
+	priv->phydev->mac_managed_pm = 1;
+
 	phy_attached_info(priv->phydev);
 
 	return 0;
-- 
2.29.2

