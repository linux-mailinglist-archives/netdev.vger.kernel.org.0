Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2BF54307F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiFHMdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiFHMcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:32:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95913251029
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:32:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nyurX-0007kw-4w; Wed, 08 Jun 2022 14:32:39 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyurX-007BML-Lv; Wed, 08 Jun 2022 14:32:38 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyurV-003KA6-AL; Wed, 08 Jun 2022 14:32:37 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: phy: dp83td510: disable cable test support for 1Vpp PHYs
Date:   Wed,  8 Jun 2022 14:32:36 +0200
Message-Id: <20220608123236.792405-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608123236.792405-1-o.rempel@pengutronix.de>
References: <20220608123236.792405-1-o.rempel@pengutronix.de>
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

Using 1Vpp pulse provides most unreliable results. So, disable cable
testing if PHY is bootstrapped to use 1Vpp-only mode.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/dp83td510.c | 52 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
index de32ab1a262d..1eaf2ceaca8c 100644
--- a/drivers/net/phy/dp83td510.c
+++ b/drivers/net/phy/dp83td510.c
@@ -31,6 +31,8 @@
 #define DP83TD510E_TDR_FAIL			BIT(0)
 
 #define DP83TD510E_TDR_CFG1			0x300
+/* TX_TYPE: Transmit voltage level for TDR. 0 = 1V, 1 = 2.4V */
+#define DP83TD510E_TDR_TX_TYPE			BIT(12)
 
 #define DP83TD510E_TDR_CFG2			0x301
 #define DP83TD510E_TDR_END_TAP_INDEX_1		GENMASK(14, 8)
@@ -71,6 +73,10 @@
 #define DP83TD510E_UNKN_0310			0x310
 #define DP83TD510E_0310_VAL			0x0036
 
+#define DP83TD510E_CHIP_SOR_1			0x467
+/* If LED_2 is set, blacklist 2.4V mode */
+#define DP83TD510E_SOR_LED_2			BIT(7)
+
 #define DP83TD510E_AN_STAT_1			0x60c
 #define DP83TD510E_MASTER_SLAVE_RESOL_FAIL	BIT(15)
 
@@ -78,6 +84,10 @@
 
 #define DP83TD510_SQI_MAX	7
 
+struct dp83td510_priv {
+	bool allow_v2_4_mode;
+};
+
 /* Register values are converted to SNR(dB) as suggested by
  * "Application Report - DP83TD510E Cable Diagnostics Toolkit":
  * SNR(dB) = -10 * log10 (VAL/2^17) - 1.76 dB.
@@ -308,12 +318,29 @@ static int dp83td510_tdr_init(struct phy_device *phydev)
 
 static int dp83td510_cable_test_start(struct phy_device *phydev)
 {
-	int ret;
+	struct dp83td510_priv *priv = phydev->priv;
+	int ret, cfg = 0;
+
+	/* Generate 2.4Vpp pulse if HW is allowed to do so */
+	if (priv->allow_v2_4_mode) {
+		cfg |= DP83TD510E_TDR_TX_TYPE;
+	} else {
+		/* This PHY do not provide usable results with 1Vpp pulse.
+		 * Potentially different dp83td510_tdr_init() values are
+		 * needed.
+		 */
+		return -EOPNOTSUPP;
+	}
 
 	ret = dp83td510_tdr_init(phydev);
 	if (ret)
 		return ret;
 
+	ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_CFG1,
+			     DP83TD510E_TDR_TX_TYPE, cfg);
+	if (ret)
+		return ret;
+
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_TDR_CFG,
 				DP83TD510E_TDR_START);
 }
@@ -369,6 +396,28 @@ static int dp83td510_cable_test_get_status(struct phy_device *phydev,
 	return phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
 }
 
+static int dp83td510_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct dp83td510_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_CHIP_SOR_1);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & DP83TD510E_SOR_LED_2))
+		priv->allow_v2_4_mode = true;
+
+	return 0;
+}
+
 static int dp83td510_get_features(struct phy_device *phydev)
 {
 	/* This PHY can't respond on MDIO bus if no RMII clock is enabled.
@@ -393,6 +442,7 @@ static struct phy_driver dp83td510_driver[] = {
 	.name		= "TI DP83TD510E",
 
 	.flags          = PHY_POLL_CABLE_TEST,
+	.probe		= dp83td510_probe,
 	.config_aneg	= dp83td510_config_aneg,
 	.read_status	= dp83td510_read_status,
 	.get_features	= dp83td510_get_features,
-- 
2.30.2

