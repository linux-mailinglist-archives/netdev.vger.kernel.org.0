Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4D6806FB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbjA3IIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbjA3IHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:07:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C535229E2D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:07:31 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMPCF-0003f6-N3; Mon, 30 Jan 2023 09:07:23 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMPCA-001Pvx-1U; Mon, 30 Jan 2023 09:07:17 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMPC7-000aKb-NN; Mon, 30 Jan 2023 09:07:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v3 11/15] net: phy: at803x: ar8035: fix EEE support for half duplex links
Date:   Mon, 30 Jan 2023 09:07:10 +0100
Message-Id: <20230130080714.139492-12-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230130080714.139492-1-o.rempel@pengutronix.de>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If AR8035 is running with enabled EEE and LPI, it will not be able to
establish an 100BaseTX/Half or 1000BaseT/Half link. Similar issue we
will have with 100BaseTX/Full and LPI TX timer configured to less then
80msec.

To avoid this issue, we need to keep LPI disabled before link is
establish and enable it only we detected supported link configuration.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 41 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 9eb4439b0afc..5ab43eb63581 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -313,6 +313,7 @@ struct at803x_priv {
 	u8 smarteee_lpi_tw_100m;
 	bool is_fiber;
 	bool is_1000basex;
+	bool tx_lpi_on;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
@@ -970,6 +971,8 @@ static int at803x_smarteee_config(struct phy_device *phydev, bool enable,
 	u16 mask = 0, val = 0;
 	int ret;
 
+	priv->tx_lpi_on = enable;
+
 	if (priv->flags & AT803X_DISABLE_SMARTEEE || !enable)
 		return phy_modify_mmd(phydev, MDIO_MMD_PCS,
 				      AT803X_MMD3_SMARTEEE_CTL3,
@@ -1010,10 +1013,15 @@ static int at803x_smarteee_config(struct phy_device *phydev, bool enable,
 	if (ret)
 		return ret;
 
-	val = AT803X_MMD3_SMARTEEE_CTL3_LPI_EN |
-		FIELD_PREP(AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH,
-			   FIELD_GET(AT803X_MMD3_SMARTEEE_LPI_TIME_23_16,
-				     tx_lpi_timer_raw));
+	val = FIELD_PREP(AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH,
+			 FIELD_GET(AT803X_MMD3_SMARTEEE_LPI_TIME_23_16,
+				   tx_lpi_timer_raw));
+
+	if (phydev->state == PHY_RUNNING &&
+	    phy_check_valid(phydev->speed, phydev->duplex,
+			    phydev->supported_eee)) {
+		val |= AT803X_MMD3_SMARTEEE_CTL3_LPI_EN;
+	}
 
 	return phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_MMD3_SMARTEEE_CTL3,
 			      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN |
@@ -1682,7 +1690,7 @@ static int at803x_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 	tx_timer_ns = tx_timer_raw * AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS;
 	data->tx_lpi_timer = DIV_ROUND_CLOSEST_ULL(tx_timer_ns, NSEC_PER_USEC);
 
-	data->tx_lpi_enabled = !!(ret & AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+	data->tx_lpi_enabled = priv->tx_lpi_on;
 
 	return genphy_c45_ethtool_get_eee(phydev, data);
 }
@@ -1709,6 +1717,28 @@ static int at803x_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 	return genphy_c45_ethtool_set_eee(phydev, data);
 }
 
+static void at8035_link_change_notify(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	if (priv->flags & AT803X_DISABLE_SMARTEEE)
+		return;
+
+	if (phydev->state == PHY_RUNNING) {
+		if (priv->tx_lpi_on && phy_check_valid(phydev->speed,
+						       phydev->duplex,
+						       phydev->supported_eee))
+			phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
+					 AT803X_MMD3_SMARTEEE_CTL3,
+					 AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+	} else {
+		if (priv->tx_lpi_on)
+			phy_clear_bits_mmd(phydev, MDIO_MMD_PCS,
+					   AT803X_MMD3_SMARTEEE_CTL3,
+					   AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+	}
+}
+
 static int qca83xx_config_init(struct phy_device *phydev)
 {
 	u8 switch_revision;
@@ -2137,6 +2167,7 @@ static struct phy_driver at803x_driver[] = {
 	.cable_test_get_status	= at803x_cable_test_get_status,
 	.get_eee		= at803x_get_eee,
 	.set_eee		= at803x_set_eee,
+	.link_change_notify	= at8035_link_change_notify,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
-- 
2.30.2

