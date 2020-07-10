Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4521B4B9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGJMJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgGJMJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:09:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD42C08E876
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 05:09:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpu-00080c-8F; Fri, 10 Jul 2020 14:09:02 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpq-0007Yx-O8; Fri, 10 Jul 2020 14:08:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 3/5] net: phy: micrel: ksz886x add MDI-X support
Date:   Fri, 10 Jul 2020 14:08:49 +0200
Message-Id: <20200710120851.28984-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710120851.28984-1-o.rempel@pengutronix.de>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MDI-X status and configuration

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 101 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 12106fbea565..ec409b2cb984 100644
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
@@ -58,6 +71,7 @@
 /* bitmap of PHY register to set interrupt mode */
 #define KSZPHY_CTRL_INT_ACTIVE_HIGH		BIT(9)
 #define KSZPHY_RMII_REF_CLK_SEL			BIT(7)
+#define KSZ886X_CTRL_MDIX_STAT			BIT(4)
 
 /* Write/read to/from extended registers */
 #define MII_KSZPHY_EXTREG                       0x0b
@@ -1010,6 +1024,91 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
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
@@ -1366,6 +1465,8 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
+	.config_aneg	= ksz886x_config_aneg,
+	.read_status	= ksz886x_read_status,
 	.suspend	= genphy_suspend,
 	.resume		= ksz886x_resume,
 }, {
-- 
2.27.0

