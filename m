Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8C21D124A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbgEMMG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgEMMG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 08:06:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8DC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 05:06:57 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYqA1-0000Q8-An; Wed, 13 May 2020 14:06:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYq9y-0003lP-8i; Wed, 13 May 2020 14:06:50 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1] net: phy: at803x: add cable test support
Date:   Wed, 13 May 2020 14:06:48 +0200
Message-Id: <20200513120648.14415-1-o.rempel@pengutronix.de>
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

The cable test seems to be support by all of currently support Atherso
PHYs, so add support for all of them. This patch was tested only on
AR9331 PHY with following results:
- No cable is detected as short
- A 15m long cable connected only on one side is detected as 9m open.
- A cable test with active link partner will provide no usable results.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 141 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index f4fec5f644e91..03ec500defb34 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -7,11 +7,13 @@
  * Author: Matus Ujhelyi <ujhelyi.m@gmail.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/phy.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/of_gpio.h>
 #include <linux/bitfield.h>
 #include <linux/gpio/consumer.h>
@@ -48,6 +50,20 @@
 #define AT803X_SMART_SPEED_BYPASS_TIMER		BIT(1)
 #define AT803X_LED_CONTROL			0x18
 
+/* Cable Tester Contol Register */
+#define AT803X_CABLE_DIAG_CTRL			0x16
+#define AT803X_CABLE_DIAG_MDI_PAIR		GENMASK(9, 8)
+#define AT803X_CABLE_DIAG_EN			BIT(0)
+
+/* Cable Tester Status Register */
+#define AT803X_CABLE_DIAG_STATUS		0x1c
+#define AT803X_CABLE_DIAG_RESULT		GENMASK(9, 8)
+#define AT803X_CABLE_DIAG_RESULT_OK		0
+#define AT803X_CABLE_DIAG_RESULT_SHORT		1
+#define AT803X_CABLE_DIAG_RESULT_OPEN		2
+#define AT803X_CABLE_DIAG_RESULT_FAIL		3
+#define AT803X_CABLE_DIAG_DTIME			GENMASK(7, 0)
+
 #define AT803X_DEVICE_ADDR			0x03
 #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
 #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
@@ -122,6 +138,7 @@ MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
 struct at803x_priv {
+	struct phy_device *phydev;
 	int flags;
 #define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
 	u16 clk_25m_reg;
@@ -129,6 +146,9 @@ struct at803x_priv {
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
+	struct work_struct cable_test_work;
+	bool cable_test_finished;
+	int cable_test_ret;
 };
 
 struct at803x_context {
@@ -168,6 +188,113 @@ static int at803x_debug_reg_mask(struct phy_device *phydev, u16 reg,
 	return phy_write(phydev, AT803X_DEBUG_DATA, val);
 }
 
+
+static bool at803x_distance_valid(int result)
+{
+	switch (result) {
+	case AT803X_CABLE_DIAG_RESULT_OPEN:
+	case AT803X_CABLE_DIAG_RESULT_SHORT:
+		return true;
+	}
+	return false;
+}
+
+static int at803x_cable_test_report_trans(int result)
+{
+	switch (result) {
+	case AT803X_CABLE_DIAG_RESULT_OK:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case AT803X_CABLE_DIAG_RESULT_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case AT803X_CABLE_DIAG_RESULT_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static int at803x_cable_test_pair(struct phy_device *phydev, int pair)
+{
+	int result, dtime;
+	int ret, val;
+
+	val = FIELD_PREP(AT803X_CABLE_DIAG_MDI_PAIR, pair)
+		| AT803X_CABLE_DIAG_EN;
+
+	phy_write(phydev, AT803X_CABLE_DIAG_CTRL, val);
+
+	ret = phy_read_poll_timeout(phydev, AT803X_CABLE_DIAG_CTRL, val,
+				    !(val & AT803X_CABLE_DIAG_EN),
+				    50000, 600000, true);
+	if (ret) {
+		phydev_err(phydev, "waiting for cable test results filed\n");
+		return ret;
+	}
+
+	ret = phy_read(phydev, AT803X_CABLE_DIAG_STATUS);
+	if (ret < 0)
+		return ret;
+
+	result = FIELD_GET(AT803X_CABLE_DIAG_RESULT, ret);
+
+	ethnl_cable_test_result(phydev, pair,
+				at803x_cable_test_report_trans(result));
+
+	if (at803x_distance_valid(result)) {
+		dtime = FIELD_GET(AT803X_CABLE_DIAG_DTIME, ret) * 824 / 10;
+		ethnl_cable_test_fault_length(phydev, pair, dtime);
+	}
+
+	return 0;
+}
+
+static int at803x_cable_test_get_status(struct phy_device *phydev,
+					      bool *finished)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	*finished = priv->cable_test_finished;
+
+	return 0;
+}
+
+static void at803x_cable_test_work(struct work_struct *work)
+{
+	struct at803x_priv *priv = container_of(work, struct at803x_priv,
+						cable_test_work);
+	struct phy_device *phydev = priv->phydev;
+	int i, ret = 0, pairs = 4;
+
+	if (phydev->phy_id == ATH9331_PHY_ID)
+		pairs = 2;
+
+	for (i = 0; i < pairs; i++) {
+		ret = at803x_cable_test_pair(phydev, i);
+		if (ret)
+			break;
+	}
+
+	priv->cable_test_ret = ret;
+	priv->cable_test_finished = true;
+
+	phy_queue_state_machine(phydev, 0);
+}
+
+static int at803x_cable_test_start(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	if (!priv->cable_test_finished) {
+		phydev_err(phydev, "cable test is already running\n");
+		return -EIO;
+	}
+
+	priv->cable_test_finished = false;
+	schedule_work(&priv->cable_test_work);
+
+	return 0;
+}
+
 static int at803x_enable_rx_delay(struct phy_device *phydev)
 {
 	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0, 0,
@@ -492,7 +619,10 @@ static int at803x_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->phydev = phydev;
 	phydev->priv = priv;
+	priv->cable_test_finished = true;
+	INIT_WORK(&priv->cable_test_work, at803x_cable_test_work);
 
 	return at803x_parse_dt(phydev);
 }
@@ -814,6 +944,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= at803x_config_intr,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
@@ -830,6 +962,8 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	.phy_id			= ATH8031_PHY_ID,
@@ -850,6 +984,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= &at803x_config_intr,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* Qualcomm Atheros AR8032 */
 	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
@@ -865,15 +1001,20 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Qualcomm Atheros AR9331 built-in PHY",
+	.probe			= at803x_probe,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 } };
 
 module_phy_driver(at803x_driver);
-- 
2.26.2

