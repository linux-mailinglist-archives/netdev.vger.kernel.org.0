Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEC0225080
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 10:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgGSIFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 04:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGSIFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 04:05:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7778CC0619D4
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 01:05:43 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jx4KG-0001EV-Ab; Sun, 19 Jul 2020 10:05:36 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jx4KB-0006Mt-J3; Sun, 19 Jul 2020 10:05:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v1] net: phy: at803x: add mdix configuration support for AR9331 and AR8035
Date:   Sun, 19 Jul 2020 10:05:30 +0200
Message-Id: <20200719080530.24370-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
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

This patch add MDIX configuration ability for AR9331 and AR8035. Theoretically
it should work on other Atheros PHYs, but I was able to test only this
two.

Since I have no certified reference HW able to detect or configure MDIX, this
functionality was confirmed by oscilloscope.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 78 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 96c61aa75bd7..101651b2de54 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -21,6 +21,17 @@
 #include <linux/regulator/consumer.h>
 #include <dt-bindings/net/qca-ar803x.h>
 
+#define AT803X_SPECIFIC_FUNCTION_CONTROL	0x10
+#define AT803X_SFC_ASSERT_CRS			BIT(11)
+#define AT803X_SFC_FORCE_LINK			BIT(10)
+#define AT803X_SFC_MDI_CROSSOVER_MODE_M		GENMASK(6, 5)
+#define AT803X_SFC_AUTOMATIC_CROSSOVER		0x3
+#define AT803X_SFC_MANUAL_MDIX			0x1
+#define AT803X_SFC_MANUAL_MDI			0x0
+#define AT803X_SFC_SQE_TEST			BIT(2)
+#define AT803X_SFC_POLARITY_REVERSAL		BIT(1)
+#define AT803X_SFC_DISABLE_JABBER		BIT(0)
+
 #define AT803X_SPECIFIC_STATUS			0x11
 #define AT803X_SS_SPEED_MASK			(3 << 14)
 #define AT803X_SS_SPEED_1000			(2 << 14)
@@ -703,6 +714,12 @@ static int at803x_read_status(struct phy_device *phydev)
 		return ss;
 
 	if (ss & AT803X_SS_SPEED_DUPLEX_RESOLVED) {
+		int sfc;
+
+		sfc = phy_read(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL);
+		if (sfc < 0)
+			return sfc;
+
 		switch (ss & AT803X_SS_SPEED_MASK) {
 		case AT803X_SS_SPEED_10:
 			phydev->speed = SPEED_10;
@@ -718,10 +735,23 @@ static int at803x_read_status(struct phy_device *phydev)
 			phydev->duplex = DUPLEX_FULL;
 		else
 			phydev->duplex = DUPLEX_HALF;
+
 		if (ss & AT803X_SS_MDIX)
 			phydev->mdix = ETH_TP_MDI_X;
 		else
 			phydev->mdix = ETH_TP_MDI;
+
+		switch (FIELD_GET(AT803X_SFC_MDI_CROSSOVER_MODE_M, sfc)) {
+		case AT803X_SFC_MANUAL_MDI:
+			phydev->mdix_ctrl = ETH_TP_MDI;
+			break;
+		case AT803X_SFC_MANUAL_MDIX:
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+			break;
+		case AT803X_SFC_AUTOMATIC_CROSSOVER:
+			phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+			break;
+		}
 	}
 
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
@@ -730,6 +760,50 @@ static int at803x_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_config_mdix(struct phy_device *phydev, u8 ctrl)
+{
+	u16 val;
+
+	switch (ctrl) {
+	case ETH_TP_MDI:
+		val = AT803X_SFC_MANUAL_MDI;
+		break;
+	case ETH_TP_MDI_X:
+		val = AT803X_SFC_MANUAL_MDIX;
+		break;
+	case ETH_TP_MDI_AUTO:
+		val = AT803X_SFC_AUTOMATIC_CROSSOVER;
+		break;
+	default:
+		return 0;
+	}
+
+	return phy_modify_changed(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL,
+			  AT803X_SFC_MDI_CROSSOVER_MODE_M,
+			  FIELD_PREP(AT803X_SFC_MDI_CROSSOVER_MODE_M, val));
+}
+
+static int at803x_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = at803x_config_mdix(phydev, phydev->mdix_ctrl);
+	if (ret < 0)
+		return ret;
+
+	/* Changes of the midx bits are disruptive to the normal operation;
+	 * therefore any changes to these registers must be followed by a
+	 * software reset to take effect.
+	 */
+	if (ret == 1) {
+		ret = genphy_soft_reset(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	return genphy_config_aneg(phydev);
+}
+
 static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
 {
 	int val;
@@ -979,6 +1053,7 @@ static struct phy_driver at803x_driver[] = {
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
+	.config_aneg		= at803x_config_aneg,
 	.config_init		= at803x_config_init,
 	.soft_reset		= genphy_soft_reset,
 	.set_wol		= at803x_set_wol,
@@ -1061,6 +1136,9 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= &at803x_config_intr,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
+	.read_status		= at803x_read_status,
+	.soft_reset		= genphy_soft_reset,
+	.config_aneg		= at803x_config_aneg,
 } };
 
 module_phy_driver(at803x_driver);
-- 
2.27.0

