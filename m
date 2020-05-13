Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544061D12D0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgEMMfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732382AbgEMMe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 08:34:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4CDC061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 05:34:59 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYqb2-000383-OV; Wed, 13 May 2020 14:34:48 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYqb1-0000wt-HO; Wed, 13 May 2020 14:34:47 +0200
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
Subject: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Date:   Wed, 13 May 2020 14:34:40 +0200
Message-Id: <20200513123440.19580-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
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

Add initial cable testing support.
This PHY needs only 100usec for this test and it is recommended to run it
before the link is up. For now, provide at least ethtool support, so it
can be tested by more developers.

This patch was tested with TJA1102 PHY with following results:
- No cable, is detected as open
- 1m cable, with no connected other end and detected as open
- a 40m cable (out of spec, max lenght should be 15m) is detected as OK.

Current patch do not provide polarity test support. This test would
indicate not proper wire connection, where "+" wire of main phy is
connected to the "-" wire of the link partner.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 106 +++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index ca5f9d4dc57ed..8b743d25002b9 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -5,6 +5,7 @@
  */
 #include <linux/delay.h>
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/kernel.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
@@ -26,6 +27,7 @@
 #define MII_ECTRL_POWER_MODE_NO_CHANGE	(0x0 << 11)
 #define MII_ECTRL_POWER_MODE_NORMAL	(0x3 << 11)
 #define MII_ECTRL_POWER_MODE_STANDBY	(0xc << 11)
+#define MII_ECTRL_CABLE_TEST		BIT(5)
 #define MII_ECTRL_CONFIG_EN		BIT(2)
 #define MII_ECTRL_WAKE_REQUEST		BIT(0)
 
@@ -55,6 +57,11 @@
 #define MII_GENSTAT			24
 #define MII_GENSTAT_PLL_LOCKED		BIT(14)
 
+#define MII_EXTSTAT			25
+#define MII_EXTSTAT_SHORT_DETECT	BIT(8)
+#define MII_EXTSTAT_OPEN_DETECT		BIT(7)
+#define MII_EXTSTAT_POLARITY_DETECT	BIT(6)
+
 #define MII_COMMCFG			27
 #define MII_COMMCFG_AUTO_OP		BIT(15)
 
@@ -111,6 +118,11 @@ static int tja11xx_enable_link_control(struct phy_device *phydev)
 	return phy_set_bits(phydev, MII_ECTRL, MII_ECTRL_LINK_CONTROL);
 }
 
+static int tja11xx_disable_link_control(struct phy_device *phydev)
+{
+	return phy_clear_bits(phydev, MII_ECTRL, MII_ECTRL_LINK_CONTROL);
+}
+
 static int tja11xx_wakeup(struct phy_device *phydev)
 {
 	int ret;
@@ -536,6 +548,93 @@ static int tja11xx_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_INTEN, value);
 }
 
+static int tja11xx_cable_test_start(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_clear_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
+	if (ret)
+		return ret;
+
+	ret = tja11xx_wakeup(phydev);
+	if (ret < 0)
+		return ret;
+
+	ret = tja11xx_disable_link_control(phydev);
+	if (ret < 0)
+		return ret;
+
+	return phy_set_bits(phydev, MII_ECTRL, MII_ECTRL_CABLE_TEST);
+}
+
+/*
+ * | BI_DA+           | BI_DA-                 | Result
+ * | open             | open                   | open
+ * | + short to -     | - short to +           | short
+ * | short to Vdd     | open                   | open
+ * | open             | shot to Vdd            | open
+ * | short to Vdd     | short to Vdd           | short
+ * | shot to GND      | open                   | open
+ * | open             | shot to GND            | open
+ * | short to GND     | shot to GND            | short
+ * | connected to active link partner (master) | shot and open
+ */
+static int tja11xx_cable_test_report_trans(u32 result)
+{
+	u32 mask = MII_EXTSTAT_SHORT_DETECT | MII_EXTSTAT_OPEN_DETECT;
+
+	if ((result & mask) == mask) {
+		/* connected to active link partner (master) */
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	} else if ((result & mask) == 0) {
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	} else if (result & MII_EXTSTAT_SHORT_DETECT) {
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	} else if (result & MII_EXTSTAT_OPEN_DETECT) {
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	} else {
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static int tja11xx_cable_test_report(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_EXTSTAT);
+	if (ret < 0)
+		return ret;
+
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+				tja11xx_cable_test_report_trans(ret));
+
+	return 0;
+}
+
+static int tja11xx_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	int ret;
+
+	*finished = false;
+
+	ret = phy_read(phydev, MII_ECTRL);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & MII_ECTRL_CABLE_TEST)) {
+		*finished = true;
+
+		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
+		if (ret)
+			return ret;
+
+		return tja11xx_cable_test_report(phydev);
+	}
+
+	return 0;
+}
+
 static struct phy_driver tja11xx_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA1100),
@@ -572,6 +671,7 @@ static struct phy_driver tja11xx_driver[] = {
 	}, {
 		.name		= "NXP TJA1102 Port 0",
 		.features       = PHY_BASIC_T1_FEATURES,
+		.flags          = PHY_POLL_CABLE_TEST,
 		.probe		= tja1102_p0_probe,
 		.soft_reset	= tja11xx_soft_reset,
 		.config_aneg	= tja11xx_config_aneg,
@@ -587,10 +687,12 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_stats	= tja11xx_get_stats,
 		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
-
+		.cable_test_start = tja11xx_cable_test_start,
+		.cable_test_get_status = tja11xx_cable_test_get_status,
 	}, {
 		.name		= "NXP TJA1102 Port 1",
 		.features       = PHY_BASIC_T1_FEATURES,
+		.flags          = PHY_POLL_CABLE_TEST,
 		/* currently no probe for Port 1 is need */
 		.soft_reset	= tja11xx_soft_reset,
 		.config_aneg	= tja11xx_config_aneg,
@@ -606,6 +708,8 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_stats	= tja11xx_get_stats,
 		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
+		.cable_test_start = tja11xx_cable_test_start,
+		.cable_test_get_status = tja11xx_cable_test_get_status,
 	}
 };
 
-- 
2.26.2

