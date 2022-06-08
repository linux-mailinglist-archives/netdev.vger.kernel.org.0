Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15296543080
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbiFHMct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbiFHMcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:32:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FF364C8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:32:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nyurX-0007kb-4p; Wed, 08 Jun 2022 14:32:39 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyurX-007BME-A0; Wed, 08 Jun 2022 14:32:37 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyurV-003K9o-8u; Wed, 08 Jun 2022 14:32:37 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/3] net: phy: dp83td510: add SQI support
Date:   Wed,  8 Jun 2022 14:32:34 +0200
Message-Id: <20220608123236.792405-2-o.rempel@pengutronix.de>
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

Convert MSE (mean-square error) values to SNR and split it SQI (Signal Quality
Indicator) ranges. The used ranges are taken from "OPEN ALLIANCE - Advanced
diagnostic features for 100BASE-T1 automotive Ethernet PHYs"
specification.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/dp83td510.c | 49 +++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
index 1ae792b0daaa..3cd9a77f9532 100644
--- a/drivers/net/phy/dp83td510.c
+++ b/drivers/net/phy/dp83td510.c
@@ -27,6 +27,27 @@
 #define DP83TD510E_AN_STAT_1			0x60c
 #define DP83TD510E_MASTER_SLAVE_RESOL_FAIL	BIT(15)
 
+#define DP83TD510E_MSE_DETECT			0xa85
+
+#define DP83TD510_SQI_MAX	7
+
+/* Register values are converted to SNR(dB) as suggested by
+ * "Application Report - DP83TD510E Cable Diagnostics Toolkit":
+ * SNR(dB) = -10 * log10 (VAL/2^17) - 1.76 dB.
+ * SQI ranges are implemented according to "OPEN ALLIANCE - Advanced diagnostic
+ * features for 100BASE-T1 automotive Ethernet PHYs"
+ */
+static const u16 dp83td510_mse_sqi_map[] = {
+	0x0569, /* < 18dB */
+	0x044c, /* 18dB =< SNR < 19dB */
+	0x0369, /* 19dB =< SNR < 20dB */
+	0x02b6, /* 20dB =< SNR < 21dB */
+	0x0227, /* 21dB =< SNR < 22dB */
+	0x01b6, /* 22dB =< SNR < 23dB */
+	0x015b, /* 23dB =< SNR < 24dB */
+	0x0000  /* 24dB =< SNR */
+};
+
 static int dp83td510_config_intr(struct phy_device *phydev)
 {
 	int ret;
@@ -164,6 +185,32 @@ static int dp83td510_config_aneg(struct phy_device *phydev)
 	return genphy_c45_check_and_restart_aneg(phydev, changed);
 }
 
+static int dp83td510_get_sqi(struct phy_device *phydev)
+{
+	int sqi, ret;
+	u16 mse_val;
+
+	if (!phydev->link)
+		return 0;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_MSE_DETECT);
+	if (ret < 0)
+		return ret;
+
+	mse_val = 0xFFFF & ret;
+	for (sqi = 0; sqi < ARRAY_SIZE(dp83td510_mse_sqi_map); sqi++) {
+		if (mse_val >= dp83td510_mse_sqi_map[sqi])
+			return sqi;
+	}
+
+	return -EINVAL;
+}
+
+static int dp83td510_get_sqi_max(struct phy_device *phydev)
+{
+	return DP83TD510_SQI_MAX;
+}
+
 static int dp83td510_get_features(struct phy_device *phydev)
 {
 	/* This PHY can't respond on MDIO bus if no RMII clock is enabled.
@@ -192,6 +239,8 @@ static struct phy_driver dp83td510_driver[] = {
 	.get_features	= dp83td510_get_features,
 	.config_intr	= dp83td510_config_intr,
 	.handle_interrupt = dp83td510_handle_interrupt,
+	.get_sqi	= dp83td510_get_sqi,
+	.get_sqi_max	= dp83td510_get_sqi_max,
 
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.30.2

