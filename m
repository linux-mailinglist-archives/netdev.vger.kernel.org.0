Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8733139BA15
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhFDNo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhFDNop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 09:44:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC22C061766
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 06:42:58 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lpA63-00072n-H0; Fri, 04 Jun 2021 15:42:47 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lpA61-0000fU-Ix; Fri, 04 Jun 2021 15:42:45 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v1 3/7] net: usb/phy: asix: add support for ax88772A/C PHYs
Date:   Fri,  4 Jun 2021 15:42:40 +0200
Message-Id: <20210604134244.2467-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210604134244.2467-1-o.rempel@pengutronix.de>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for build-in x88772A/C PHYs

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/ax88796b.c | 74 +++++++++++++++++++++++++++++++++++++-
 drivers/net/usb/Kconfig    |  1 +
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
index 79bf7ef1fcfd..457896337505 100644
--- a/drivers/net/phy/ax88796b.c
+++ b/drivers/net/phy/ax88796b.c
@@ -10,6 +10,8 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 
+#define PHY_ID_ASIX_AX88772A		0x003b1861
+#define PHY_ID_ASIX_AX88772C		0x003b1881
 #define PHY_ID_ASIX_AX88796B		0x003b1841
 
 MODULE_DESCRIPTION("Asix PHY driver");
@@ -39,7 +41,75 @@ static int asix_soft_reset(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
-static struct phy_driver asix_driver[] = { {
+/* AX88772A is not working properly with some old switches (NETGEAR EN 108TP):
+ * after autoneg is done and the link status is reported as active, the MII_LPA
+ * register is 0. This issue is not reproducible on AX88772C.
+ */
+static int asix_ax88772a_read_status(struct phy_device *phydev)
+{
+	int ret, val;
+
+	ret = genphy_update_link(phydev);
+	if (ret)
+		return ret;
+
+	if (!phydev->link)
+		return 0;
+
+	/* If MII_LPA is 0, phy_resolve_aneg_linkmode() will fail to resolve
+	 * linkmode so use MII_BMCR as default values.
+	 */
+	val = phy_read(phydev, MII_BMCR);
+	if (val < 0)
+		return val;
+
+	if (val & BMCR_SPEED100)
+		phydev->speed = SPEED_100;
+	else
+		phydev->speed = SPEED_10;
+
+	if (val & BMCR_FULLDPLX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	ret = genphy_read_lpa(phydev);
+	if (ret < 0)
+		return ret;
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
+		phy_resolve_aneg_linkmode(phydev);
+
+	return 0;
+}
+
+static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
+{
+	/* Reset PHY, otherwise MII_LPA will provide outdated information.
+	 * This issue is reproducible only with some link partner PHYs
+	 */
+	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
+		phydev->drv->soft_reset(phydev);
+}
+
+static struct phy_driver asix_driver[] = {
+{
+	PHY_ID_MATCH_EXACT(PHY_ID_ASIX_AX88772A),
+	.name		= "Asix Electronics AX88772A",
+	.flags		= PHY_IS_INTERNAL,
+	.read_status	= asix_ax88772a_read_status,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
+	.soft_reset	= asix_soft_reset,
+	.link_change_notify	= asix_ax88772a_link_change_notify,
+}, {
+	PHY_ID_MATCH_EXACT(PHY_ID_ASIX_AX88772C),
+	.name		= "Asix Electronics AX88772C",
+	.flags		= PHY_IS_INTERNAL,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
+	.soft_reset	= asix_soft_reset,
+}, {
 	.phy_id		= PHY_ID_ASIX_AX88796B,
 	.name		= "Asix Electronics AX88796B",
 	.phy_id_mask	= 0xfffffff0,
@@ -50,6 +120,8 @@ static struct phy_driver asix_driver[] = { {
 module_phy_driver(asix_driver);
 
 static struct mdio_device_id __maybe_unused asix_tbl[] = {
+	{ PHY_ID_MATCH_EXACT(PHY_ID_ASIX_AX88772A) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_ASIX_AX88772C) },
 	{ PHY_ID_ASIX_AX88796B, 0xfffffff0 },
 	{ }
 };
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 179308782888..6f7be47974f6 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -164,6 +164,7 @@ config USB_NET_AX8817X
 	depends on USB_USBNET
 	select CRC32
 	select PHYLIB
+	select AX88796B_PHY
 	default y
 	help
 	  This option adds support for ASIX AX88xxx based USB 2.0
-- 
2.29.2

