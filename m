Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C52C390F90
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhEZEci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhEZEcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B38C06138B
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Ow-Bt; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002cg-MH; Wed, 26 May 2021 06:30:38 +0200
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
Subject: [PATCH net-next v3 6/9] net: phy: micrel: ksz8081 add MDI-X support
Date:   Wed, 26 May 2021 06:30:34 +0200
Message-Id: <20210526043037.9830-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210526043037.9830-1-o.rempel@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
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
 drivers/net/phy/micrel.c | 89 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index ac56e8159712..b6ce7bd66738 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -55,11 +55,17 @@
 
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
+#define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
 
 /* PHY Control 2 / PHY Control (if no PHY Control 1) */
 #define MII_KSZPHY_CTRL_2			0x1f
 #define MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
 /* bitmap of PHY register to set interrupt mode */
+#define KSZ8081_CTRL2_HP_MDIX			BIT(15)
+#define KSZ8081_CTRL2_MDI_MDI_X_SELECT		BIT(14)
+#define KSZ8081_CTRL2_DISABLE_AUTO_MDIX		BIT(13)
+#define KSZ8081_CTRL2_FORCE_LINK		BIT(11)
+#define KSZ8081_CTRL2_POWER_SAVING		BIT(10)
 #define KSZPHY_CTRL_INT_ACTIVE_HIGH		BIT(9)
 #define KSZPHY_RMII_REF_CLK_SEL			BIT(7)
 
@@ -422,6 +428,87 @@ static int ksz8081_config_init(struct phy_device *phydev)
 	return kszphy_config_init(phydev);
 }
 
+static int ksz8081_config_mdix(struct phy_device *phydev, u8 ctrl)
+{
+	u16 val;
+
+	switch (ctrl) {
+	case ETH_TP_MDI:
+		val = KSZ8081_CTRL2_DISABLE_AUTO_MDIX;
+		break;
+	case ETH_TP_MDI_X:
+		val = KSZ8081_CTRL2_DISABLE_AUTO_MDIX |
+			KSZ8081_CTRL2_MDI_MDI_X_SELECT;
+		break;
+	case ETH_TP_MDI_AUTO:
+		val = 0;
+		break;
+	default:
+		return 0;
+	}
+
+	return phy_modify(phydev, MII_KSZPHY_CTRL_2,
+			  KSZ8081_CTRL2_HP_MDIX |
+			  KSZ8081_CTRL2_MDI_MDI_X_SELECT |
+			  KSZ8081_CTRL2_DISABLE_AUTO_MDIX,
+			  KSZ8081_CTRL2_HP_MDIX | val);
+}
+
+static int ksz8081_config_aneg(struct phy_device *phydev)
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
+	return ksz8081_config_mdix(phydev, phydev->mdix_ctrl);
+}
+
+static int ksz8081_mdix_update(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_KSZPHY_CTRL_2);
+	if (ret < 0)
+		return ret;
+
+	if (ret & KSZ8081_CTRL2_DISABLE_AUTO_MDIX) {
+		if (ret & KSZ8081_CTRL2_MDI_MDI_X_SELECT)
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+		else
+			phydev->mdix_ctrl = ETH_TP_MDI;
+	} else {
+		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	}
+
+	ret = phy_read(phydev, MII_KSZPHY_CTRL_1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & KSZ8081_CTRL1_MDIX_STAT)
+		phydev->mdix = ETH_TP_MDI;
+	else
+		phydev->mdix = ETH_TP_MDI_X;
+
+	return 0;
+}
+
+static int ksz8081_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = ksz8081_mdix_update(phydev);
+	if (ret < 0)
+		return ret;
+
+	return genphy_read_status(phydev);
+}
+
 static int ksz8061_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -1410,6 +1497,8 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
 	.soft_reset	= genphy_soft_reset,
+	.config_aneg	= ksz8081_config_aneg,
+	.read_status	= ksz8081_read_status,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
-- 
2.29.2

