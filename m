Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BBF390F8C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhEZEcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhEZEcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FC7C061761
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Ov-Bj; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002cX-L9; Wed, 26 May 2021 06:30:38 +0200
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
Subject: [PATCH net-next v3 5/9] net: phy/dsa micrel/ksz886x add MDI-X support
Date:   Wed, 26 May 2021 06:30:33 +0200
Message-Id: <20210526043037.9830-6-o.rempel@pengutronix.de>
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
 drivers/net/dsa/microchip/ksz8795.c |  5 ++
 drivers/net/phy/micrel.c            | 88 +++++++++++++++++++++++++++++
 include/linux/micrel_phy.h          |  2 +
 3 files changed, 95 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index cf81ae87544d..55da8ec175da 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -816,6 +816,11 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		if (data & ~LPA_SLCT)
 			data |= LPA_LPACK;
 		break;
+	case PHY_REG_PHY_CTRL:
+		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
+		if (link & PORT_MDIX_STATUS)
+			data |= KSZ886X_CTRL_MDIX_STAT;
+		break;
 	default:
 		processed = false;
 		break;
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index f03188ed953a..ac56e8159712 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1048,6 +1048,92 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
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
+	/* Same reverse logic as KSZ886X_BMCR_FORCE_MDI */
+	if (ret & KSZ886X_CTRL_MDIX_STAT)
+		phydev->mdix = ETH_TP_MDI_X;
+	else
+		phydev->mdix = ETH_TP_MDI;
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
@@ -1420,6 +1506,8 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ8851 Ethernet MAC or KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
+	.config_aneg	= ksz886x_config_aneg,
+	.read_status	= ksz886x_read_status,
 	.suspend	= genphy_suspend,
 	.resume		= ksz886x_resume,
 }, {
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index b03e2afcb53f..58370abd9f4f 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -58,4 +58,6 @@
 #define KSZ886X_BMCR_DISABLE_TRANSMIT		BIT(1)
 #define KSZ886X_BMCR_DISABLE_LED		BIT(0)
 
+#define KSZ886X_CTRL_MDIX_STAT			BIT(4)
+
 #endif /* _MICREL_PHY_H */
-- 
2.29.2

