Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F72373758
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhEEJXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhEEJWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:22:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840E1C061362
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 02:20:40 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1leDhn-0005Xg-1r; Wed, 05 May 2021 11:20:31 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1leDhj-0002gL-Uh; Wed, 05 May 2021 11:20:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC PATCH v1 5/9] net: phy: micrel: ksz886x add MDI-X support
Date:   Wed,  5 May 2021 11:20:21 +0200
Message-Id: <20210505092025.8785-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210505092025.8785-1-o.rempel@pengutronix.de>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MDI-X status and configuration

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 101 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index f03188ed953a..ea30cd6bd7bc 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -28,6 +28,19 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 
+/* Device specific MII_BMCR (Reg 0) bits */
+/* 1 = HP Auto MDI/MDI-X mode, 0 = Microchip Auto MDI/MDI-X mode */
+#define KSZ886X_BMCR_HP_MDIX			BIT(5)
+/* 1 = Force MDI (transmit on RXP/RXM pins), 0 = Normal operation
+ * (transmit on TXP/TXM pins)
+ */
+#define KSZ886X_BMCR_FORCE_MDI			BIT(4)
+/* 1 = Disable auto MDI-X */
+#define KSZ886X_BMCR_DISABLE_AUTO_MDIX		BIT(3)
+#define KSZ886X_BMCR_DISABLE_FAR_END_FAULT	BIT(2)
+#define KSZ886X_BMCR_DISABLE_TRANSMIT		BIT(1)
+#define KSZ886X_BMCR_DISABLE_LED		BIT(0)
+
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
 #define KSZPHY_OMSO_FACTORY_TEST		BIT(15)
@@ -62,6 +75,7 @@
 /* bitmap of PHY register to set interrupt mode */
 #define KSZPHY_CTRL_INT_ACTIVE_HIGH		BIT(9)
 #define KSZPHY_RMII_REF_CLK_SEL			BIT(7)
+#define KSZ886X_CTRL_MDIX_STAT			BIT(4)
 
 /* Write/read to/from extended registers */
 #define MII_KSZPHY_EXTREG                       0x0b
@@ -1048,6 +1062,91 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz886x_config_mdix(struct phy_device *phydev, u8 ctrl)
+{
+	u16 val;
+
+	switch (ctrl) {
+	case ETH_TP_MDI:
+		val = KSZ886X_BMCR_DISABLE_AUTO_MDIX;
+		break;
+	case ETH_TP_MDI_X:
+		/* Note: The naming of the bit KSZ886X_BMCR_FORCE_MDI is bit
+		 * counter intuitive, the "-X" in "1 = Force MDI" in the data
+		 * sheet seems to be missing:
+		 * 1 = Force MDI (sic!) (transmit on RX+/RX- pins)
+		 * 0 = Normal operation (transmit on TX+/TX- pins)
+		 */
+		val = KSZ886X_BMCR_DISABLE_AUTO_MDIX | KSZ886X_BMCR_FORCE_MDI;
+		break;
+	case ETH_TP_MDI_AUTO:
+		val = 0;
+		break;
+	default:
+		return 0;
+	}
+
+	return phy_modify(phydev, MII_BMCR,
+			  KSZ886X_BMCR_HP_MDIX | KSZ886X_BMCR_FORCE_MDI |
+			  KSZ886X_BMCR_DISABLE_AUTO_MDIX,
+			  KSZ886X_BMCR_HP_MDIX | val);
+}
+
+static int ksz886x_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_config_aneg(phydev);
+	if (ret)
+		return ret;
+
+	/* The MDI-X configuration is automatically changed by the PHY after
+	 * switching from autoneg off to on. So, take MDI-X configuration under
+	 * own control and set it after autoneg configuration was done.
+	 */
+	return ksz886x_config_mdix(phydev, phydev->mdix_ctrl);
+}
+
+static int ksz886x_mdix_update(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+
+	if (ret & KSZ886X_BMCR_DISABLE_AUTO_MDIX) {
+		if (ret & KSZ886X_BMCR_FORCE_MDI)
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+		else
+			phydev->mdix_ctrl = ETH_TP_MDI;
+	} else {
+		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	}
+
+	ret = phy_read(phydev, MII_KSZPHY_CTRL);
+	if (ret < 0)
+		return ret;
+
+	if (ret & KSZ886X_CTRL_MDIX_STAT)
+		phydev->mdix = ETH_TP_MDI;
+	else
+		phydev->mdix = ETH_TP_MDI_X;
+
+	return 0;
+}
+
+static int ksz886x_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = ksz886x_mdix_update(phydev);
+	if (ret < 0)
+		return ret;
+
+	return genphy_read_status(phydev);
+}
+
 static int ksz886x_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -1420,6 +1519,8 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ8851 Ethernet MAC or KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
+	.config_aneg	= ksz886x_config_aneg,
+	.read_status	= ksz886x_read_status,
 	.suspend	= genphy_suspend,
 	.resume		= ksz886x_resume,
 }, {
-- 
2.29.2

