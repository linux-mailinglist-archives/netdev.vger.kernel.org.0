Return-Path: <netdev+bounces-11740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA72A7341A2
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 16:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD9BD1C209CC
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76413A934;
	Sat, 17 Jun 2023 14:24:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AED11117
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 14:24:47 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410991BF2
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:24:44 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id AWr1qVPAYtGgOAWr1qGHnt; Sat, 17 Jun 2023 16:24:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1687011882;
	bh=GIaDZ9qklWwCYGZElFRs429MfAWUnecD/VWmPgF+bfY=;
	h=From:To:Cc:Subject:Date;
	b=EsDt6VHU0nK0znr5mGgmD6crpCfBtSLB4BhR9Q6Lbaddn+iw4BjqZoPxyrr4JOLFq
	 McsQ/hEuurzNaffGGPzyrTNfaV+re3ifr9eOVkX/Wg8QPIK3hnkYmqVB+wdIsysXYs
	 FQPDsGA0+u+u44NQ/wApENDbTVXDOcgFwmQU8vA9n4G4wH+WLZfjJUjQNV1rUTUplJ
	 S8WZFIC+SmFudMIgCuMSgvJJ2cW7KWTF2i0cPPm+S3zcnljTwX79zHrFfOGj8hae1p
	 JX/lZ9ZUTbu0aJADDKIMMxXTcLhx6Y31jnd2aWOA25nayV9TeQZpF9XhAEjP/UjL5v
	 E0oO/fhSnUKlQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 17 Jun 2023 16:24:42 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: at803x: Use devm_regulator_get_enable_optional()
Date: Sat, 17 Jun 2023 16:24:37 +0200
Message-Id: <f5fdf1a50bb164b4f59409d3a70a2689515d59c9.1687011839.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use devm_regulator_get_enable_optional() instead of hand writing it. It
saves some line of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only.

If my reading is correct, regulator_disable() is still called in the same
order, should an error occur or the driver be removed.
---
 drivers/net/phy/at803x.c | 44 +++++++---------------------------------
 1 file changed, 7 insertions(+), 37 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 656136628ffd..c1f307d90518 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -304,7 +304,6 @@ struct at803x_priv {
 	bool is_1000basex;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
-	struct regulator *vddio;
 	u64 stats[ARRAY_SIZE(at803x_hw_stats)];
 };
 
@@ -824,11 +823,11 @@ static int at803x_parse_dt(struct phy_device *phydev)
 		if (ret < 0)
 			return ret;
 
-		priv->vddio = devm_regulator_get_optional(&phydev->mdio.dev,
-							  "vddio");
-		if (IS_ERR(priv->vddio)) {
+		ret = devm_regulator_get_enable_optional(&phydev->mdio.dev,
+							 "vddio");
+		if (ret) {
 			phydev_err(phydev, "failed to get VDDIO regulator\n");
-			return PTR_ERR(priv->vddio);
+			return ret;
 		}
 
 		/* Only AR8031/8033 support 1000Base-X for SFP modules */
@@ -856,12 +855,6 @@ static int at803x_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	if (priv->vddio) {
-		ret = regulator_enable(priv->vddio);
-		if (ret < 0)
-			return ret;
-	}
-
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
 		int mode_cfg;
@@ -869,10 +862,8 @@ static int at803x_probe(struct phy_device *phydev)
 			.wolopts = 0,
 		};
 
-		if (ccr < 0) {
-			ret = ccr;
-			goto err;
-		}
+		if (ccr < 0)
+			return ccr;
 		mode_cfg = ccr & AT803X_MODE_CFG_MASK;
 
 		switch (mode_cfg) {
@@ -890,25 +881,11 @@ static int at803x_probe(struct phy_device *phydev)
 		ret = at803x_set_wol(phydev, &wol);
 		if (ret < 0) {
 			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
-			goto err;
+			return ret;
 		}
 	}
 
 	return 0;
-
-err:
-	if (priv->vddio)
-		regulator_disable(priv->vddio);
-
-	return ret;
-}
-
-static void at803x_remove(struct phy_device *phydev)
-{
-	struct at803x_priv *priv = phydev->priv;
-
-	if (priv->vddio)
-		regulator_disable(priv->vddio);
 }
 
 static int at803x_get_features(struct phy_device *phydev)
@@ -2021,7 +1998,6 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm Atheros AR8035",
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.config_aneg		= at803x_config_aneg,
 	.config_init		= at803x_config_init,
 	.soft_reset		= genphy_soft_reset,
@@ -2043,7 +2019,6 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm Atheros AR8030",
 	.phy_id_mask		= AT8030_PHY_ID_MASK,
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
 	.set_wol		= at803x_set_wol,
@@ -2059,7 +2034,6 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm Atheros AR8031/AR8033",
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
 	.config_aneg		= at803x_config_aneg,
 	.soft_reset		= genphy_soft_reset,
@@ -2082,7 +2056,6 @@ static struct phy_driver at803x_driver[] = {
 	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
 	.name			= "Qualcomm Atheros AR8032",
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.flags			= PHY_POLL_CABLE_TEST,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
@@ -2100,7 +2073,6 @@ static struct phy_driver at803x_driver[] = {
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Qualcomm Atheros AR9331 built-in PHY",
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
@@ -2117,7 +2089,6 @@ static struct phy_driver at803x_driver[] = {
 	PHY_ID_MATCH_EXACT(QCA9561_PHY_ID),
 	.name			= "Qualcomm Atheros QCA9561 built-in PHY",
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
@@ -2183,7 +2154,6 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm QCA8081",
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
-	.remove			= at803x_remove,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
-- 
2.34.1


