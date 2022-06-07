Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891C453FB07
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240833AbiFGKR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240813AbiFGKRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:17:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCBE10FDA
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:17:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nyWGv-0008Do-Lg; Tue, 07 Jun 2022 12:17:13 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyWGw-006yMz-2v; Tue, 07 Jun 2022 12:17:12 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyWGt-00BtGh-VU; Tue, 07 Jun 2022 12:17:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 2/3] net: phy: dp83td510: add cable testing support
Date:   Tue,  7 Jun 2022 12:17:09 +0200
Message-Id: <20220607101710.2833332-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220607101710.2833332-1-o.rempel@pengutronix.de>
References: <20220607101710.2833332-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cable testing was tested in different HW configurations and cables:
- SJA1105 + DP83TD510
- ASIX + DP83TD510
- STM32MP1 + DP83TD510

Results provided by this PHY should be interpreted with grain of sold.
For example testing unshielded and shielded twisted pair may give
different results. Nevertheless, it still can be usable.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/dp83td510.c | 161 ++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
index 441f77bfc9f2..d0229f3b0181 100644
--- a/drivers/net/phy/dp83td510.c
+++ b/drivers/net/phy/dp83td510.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
@@ -24,6 +25,52 @@
 #define DP83TD510E_INT1_LINK			BIT(13)
 #define DP83TD510E_INT1_LINK_EN			BIT(5)
 
+#define DP83TD510E_TDR_CFG			0x1e
+#define DP83TD510E_TDR_START			BIT(15)
+#define DP83TD510E_TDR_DONE			BIT(1)
+#define DP83TD510E_TDR_FAIL			BIT(0)
+
+#define DP83TD510E_TDR_CFG1			0x300
+
+#define DP83TD510E_TDR_CFG2			0x301
+#define DP83TD510E_TDR_END_TAP_INDEX_1		GENMASK(14, 8)
+#define DP83TD510E_TDR_START_TAP_INDEX_1	GENMASK(6, 0)
+
+#define DP83TD510E_TDR_CFG3			0x302
+#define DP83TD510E_TDR_TX_DURATION_US		GENMASK(15, 0)
+
+#define DP83TD510E_TDR_FAULT_CFG1		0x303
+#define DP83TD510E_TDR_FLT_LOC_OFFSET_1		GENMASK(14, 8)
+#define DP83TD510E_TDR_FLT_INIT_1		GENMASK(7, 0)
+
+#define DP83TD510E_TDR_FAULT_CFG2		0x304
+#define DP83TD510E_TDR_FLT_SLOPE_1		GENMASK(7, 0)
+
+#define DP83TD510E_TDR_FAULT_STAT1		0x305
+#define DP83TD510E_TDR_FAULT_STAT2		0x306
+#define DP83TD510E_TDR_FAULT_STAT3		0x307
+#define DP83TD510E_TDR_FAULT_STAT4		0x308
+#define DP83TD510E_TDR_FAULT_STAT5		0x309
+#define DP83TD510E_TDR_FAULT_STAT6		0x30a
+
+#define DP83TD510E_TDR_FAULT_STAT		0x30c
+#define DP83TD510E_TDR_PEAK_DETECT		BIT(11)
+#define DP83TD510E_TDR_PEAK_SIGN		BIT(10)
+#define DP83TD510E_TDR_PEAK_LOCATION		GENMASK(9, 0)
+
+
+/* Not documented registers and values but recommended according to
+ * "DP83TD510E Cable Diagnostics Toolkit"
+ */
+#define DP83TD510E_UNKN_030D			0x30d
+#define DP83TD510E_030D_VAL			0x5f25
+#define DP83TD510E_UNKN_030E			0x30e
+#define DP83TD510E_030E_VAL			0x0536
+#define DP83TD510E_UNKN_030F			0x30f
+#define DP83TD510E_030F_VAL			0x0008
+#define DP83TD510E_UNKN_0310			0x310
+#define DP83TD510E_0310_VAL			0x0036
+
 #define DP83TD510E_AN_STAT_1			0x60c
 #define DP83TD510E_MASTER_SLAVE_RESOL_FAIL	BIT(15)
 
@@ -218,6 +265,117 @@ static int dp83td510_get_sqi_max(struct phy_device *phydev)
 	return DP83TD510_SQI_MAX;
 }
 
+/* Configure the TDR circuitry within the PHY as described in
+ * "Application Report - DP83TD510E Cable Diagnostics Toolkit"
+ */
+static int dp83td510_tdr_init(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_CFG2,
+			    FIELD_PREP(DP83TD510E_TDR_END_TAP_INDEX_1, 36) |
+			    FIELD_PREP(DP83TD510E_TDR_START_TAP_INDEX_1, 4));
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_UNKN_030D,
+			    DP83TD510E_030D_VAL);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_FAULT_CFG1,
+			    FIELD_PREP(DP83TD510E_TDR_FLT_LOC_OFFSET_1, 0x5) |
+			    FIELD_PREP(DP83TD510E_TDR_FLT_INIT_1, 0x3e));
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_UNKN_030E,
+			    DP83TD510E_030E_VAL);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_FAULT_CFG2,
+			    FIELD_PREP(DP83TD510E_TDR_FLT_SLOPE_1, 0xa));
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_UNKN_030F,
+			    DP83TD510E_030F_VAL);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_CFG3,
+			    FIELD_PREP(DP83TD510E_TDR_TX_DURATION_US, 16000));
+	if (ret)
+		return ret;
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_UNKN_0310,
+			     DP83TD510E_0310_VAL);
+}
+
+static int dp83td510_cable_test_start(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = dp83td510_tdr_init(phydev);
+	if (ret)
+		return ret;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_CFG,
+				DP83TD510E_TDR_START);
+}
+
+static int dp83td510_cable_test_get_status(struct phy_device *phydev,
+					   bool *finished)
+{
+	int ret, stat;
+
+	*finished = false;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_CFG);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & DP83TD510E_TDR_DONE))
+		return 0;
+
+	if (!(ret & DP83TD510E_TDR_FAIL)) {
+		int location;
+
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
+				   DP83TD510E_TDR_FAULT_STAT);
+		if (ret < 0)
+			return ret;
+
+		if (ret & DP83TD510E_TDR_PEAK_DETECT) {
+			if (ret & DP83TD510E_TDR_PEAK_SIGN)
+				stat = ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+			else
+				stat = ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+
+			location = FIELD_GET(DP83TD510E_TDR_PEAK_LOCATION,
+					     ret) * 100;
+			ethnl_cable_test_fault_length(phydev,
+						      ETHTOOL_A_CABLE_PAIR_A,
+						      location);
+		} else {
+			stat = ETHTOOL_A_CABLE_RESULT_CODE_OK;
+		}
+	} else {
+		/* Most probably we have active link partner */
+		stat = ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+
+	*finished = true;
+
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A, stat);
+
+	/* Reset state machine, otherwise at least other TDR attempts may
+	 * provide not reliable results.
+	 */
+	return phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
+}
+
 static int dp83td510_get_features(struct phy_device *phydev)
 {
 	/* This PHY can't respond on MDIO bus if no RMII clock is enabled.
@@ -241,6 +399,7 @@ static struct phy_driver dp83td510_driver[] = {
 	PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
 	.name		= "TI DP83TD510E",
 
+	.flags          = PHY_POLL_CABLE_TEST,
 	.config_aneg	= dp83td510_config_aneg,
 	.read_status	= dp83td510_read_status,
 	.get_features	= dp83td510_get_features,
@@ -248,6 +407,8 @@ static struct phy_driver dp83td510_driver[] = {
 	.handle_interrupt = dp83td510_handle_interrupt,
 	.get_sqi	= dp83td510_get_sqi,
 	.get_sqi_max	= dp83td510_get_sqi_max,
+	.cable_test_start = dp83td510_cable_test_start,
+	.cable_test_get_status = dp83td510_cable_test_get_status,
 
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.30.2

