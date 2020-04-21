Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FED1B26C0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgDUMwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728856AbgDUMwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:52:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072ECC0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:52:32 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQsNz-0004N4-SG; Tue, 21 Apr 2020 14:52:23 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQsNx-0002HJ-8F; Tue, 21 Apr 2020 14:52:21 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v4 2/4] net: phy: tja11xx: add initial TJA1102 support
Date:   Tue, 21 Apr 2020 14:52:17 +0200
Message-Id: <20200421125219.8402-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421125219.8402-1-o.rempel@pengutronix.de>
References: <20200421125219.8402-1-o.rempel@pengutronix.de>
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

TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
Both PHYs are similar but have different amount of functionality. For
example PHY 1 has no PHY ID and no health monitor.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 91 +++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index b705d0bd798b..a064e4ab3616 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -15,6 +15,7 @@
 #define PHY_ID_MASK			0xfffffff0
 #define PHY_ID_TJA1100			0x0180dc40
 #define PHY_ID_TJA1101			0x0180dd00
+#define PHY_ID_TJA1102			0x0180dc80
 
 #define MII_ECTRL			17
 #define MII_ECTRL_LINK_CONTROL		BIT(15)
@@ -40,6 +41,10 @@
 #define MII_INTSRC_TEMP_ERR		BIT(1)
 #define MII_INTSRC_UV_ERR		BIT(3)
 
+#define MII_INTEN			22
+#define MII_INTEN_LINK_FAIL		BIT(10)
+#define MII_INTEN_LINK_UP		BIT(9)
+
 #define MII_COMMSTAT			23
 #define MII_COMMSTAT_LINK_UP		BIT(15)
 
@@ -190,6 +195,7 @@ static int tja11xx_config_init(struct phy_device *phydev)
 			return ret;
 		break;
 	case PHY_ID_TJA1101:
+	case PHY_ID_TJA1102:
 		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
 		if (ret)
 			return ret;
@@ -354,6 +360,55 @@ static int tja11xx_probe(struct phy_device *phydev)
 	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
 }
 
+static int tja1102_match_phy_device(struct phy_device *phydev, bool port0)
+{
+	int ret;
+
+	if ((phydev->phy_id & PHY_ID_MASK) != PHY_ID_TJA1102)
+		return 0;
+
+	ret = phy_read(phydev, MII_PHYSID2);
+	if (ret < 0)
+		return ret;
+
+	/* TJA1102 Port 1 has phyid 0 and doesn't support temperature
+	 * and undervoltage alarms.
+	 */
+	if (port0)
+		return ret ? 1 : 0;
+
+	return !ret;
+}
+
+static int tja1102_p0_match_phy_device(struct phy_device *phydev)
+{
+	return tja1102_match_phy_device(phydev, true);
+}
+
+static int tja1102_p1_match_phy_device(struct phy_device *phydev)
+{
+	return tja1102_match_phy_device(phydev, false);
+}
+
+static int tja11xx_ack_interrupt(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_INTSRC);
+
+	return (ret < 0) ? ret : 0;
+}
+
+static int tja11xx_config_intr(struct phy_device *phydev)
+{
+	int value = 0;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		value = MII_INTEN_LINK_FAIL | MII_INTEN_LINK_UP;
+
+	return phy_write(phydev, MII_INTEN, value);
+}
+
 static struct phy_driver tja11xx_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA1100),
@@ -385,6 +440,41 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
 		.get_stats	= tja11xx_get_stats,
+	}, {
+		.name		= "NXP TJA1102 Port 0",
+		.features       = PHY_BASIC_T1_FEATURES,
+		.probe		= tja11xx_probe,
+		.soft_reset	= tja11xx_soft_reset,
+		.config_init	= tja11xx_config_init,
+		.read_status	= tja11xx_read_status,
+		.match_phy_device = tja1102_p0_match_phy_device,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.set_loopback   = genphy_loopback,
+		/* Statistics */
+		.get_sset_count = tja11xx_get_sset_count,
+		.get_strings	= tja11xx_get_strings,
+		.get_stats	= tja11xx_get_stats,
+		.ack_interrupt	= tja11xx_ack_interrupt,
+		.config_intr	= tja11xx_config_intr,
+
+	}, {
+		.name		= "NXP TJA1102 Port 1",
+		.features       = PHY_BASIC_T1_FEATURES,
+		/* currently no probe for Port 1 is need */
+		.soft_reset	= tja11xx_soft_reset,
+		.config_init	= tja11xx_config_init,
+		.read_status	= tja11xx_read_status,
+		.match_phy_device = tja1102_p1_match_phy_device,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.set_loopback   = genphy_loopback,
+		/* Statistics */
+		.get_sset_count = tja11xx_get_sset_count,
+		.get_strings	= tja11xx_get_strings,
+		.get_stats	= tja11xx_get_stats,
+		.ack_interrupt	= tja11xx_ack_interrupt,
+		.config_intr	= tja11xx_config_intr,
 	}
 };
 
@@ -393,6 +483,7 @@ module_phy_driver(tja11xx_driver);
 static struct mdio_device_id __maybe_unused tja11xx_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1102) },
 	{ }
 };
 
-- 
2.25.1

