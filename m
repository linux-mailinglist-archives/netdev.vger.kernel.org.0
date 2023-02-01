Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50768694B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjBAO7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBAO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCABD6B990
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:05 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZc-0002re-1H; Wed, 01 Feb 2023 15:58:56 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZX-001w1S-1S; Wed, 01 Feb 2023 15:58:50 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hW9-EV; Wed, 01 Feb 2023 15:58:47 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v4 11/23] net: phy: at803x: implement ethtool access to SmartEEE functionality
Date:   Wed,  1 Feb 2023 15:58:33 +0100
Message-Id: <20230201145845.2312060-12-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201145845.2312060-1-o.rempel@pengutronix.de>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
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

If AR8035 PHY is used with a MAC without EEE support
(iMX6, etc), then we need to process ethtool_eee::tx_lpi_timer and
tx_lpi_enabled by the PHY driver. So, add get/set_eee support for this
functionality.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 109 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 22f4458274aa..9eb4439b0afc 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -166,8 +166,18 @@
 
 #define AT803X_MMD3_SMARTEEE_CTL1		0x805b
 #define AT803X_MMD3_SMARTEEE_CTL2		0x805c
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_LOW	GENMASK(15, 0)
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_15_0	GENMASK(15, 0)
 #define AT803X_MMD3_SMARTEEE_CTL3		0x805d
 #define AT803X_MMD3_SMARTEEE_CTL3_LPI_EN	BIT(8)
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH	GENMASK(7, 0)
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_23_16	GENMASK(23, 16)
+/* Tx LPI timer resolution */
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS	163840
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_MAX_US	\
+	((GENMASK(23, 0) * AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS) / \
+	       NSEC_PER_USEC)
+#define AT803X_MMD3_SMARTEEE_LPI_TIME_DEF_US	335544
 
 #define ATH9331_PHY_ID				0x004dd041
 #define ATH8030_PHY_ID				0x004dd076
@@ -951,17 +961,26 @@ static int at803x_get_features(struct phy_device *phydev)
 	return 0;
 }
 
-static int at803x_smarteee_config(struct phy_device *phydev)
+static int at803x_smarteee_config(struct phy_device *phydev, bool enable,
+				  u32 tx_lpi_timer_us)
 {
 	struct at803x_priv *priv = phydev->priv;
+	u64 tx_lpi_timer_raw;
+	u64 tx_lpi_timer_ns;
 	u16 mask = 0, val = 0;
 	int ret;
 
-	if (priv->flags & AT803X_DISABLE_SMARTEEE)
+	if (priv->flags & AT803X_DISABLE_SMARTEEE || !enable)
 		return phy_modify_mmd(phydev, MDIO_MMD_PCS,
 				      AT803X_MMD3_SMARTEEE_CTL3,
 				      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN, 0);
 
+	if (tx_lpi_timer_us > AT803X_MMD3_SMARTEEE_LPI_TIME_MAX_US) {
+		phydev_err(phydev, "Max LPI timer is %lu microsecs\n",
+			   AT803X_MMD3_SMARTEEE_LPI_TIME_MAX_US);
+		return -EINVAL;
+	}
+
 	if (priv->smarteee_lpi_tw_1g) {
 		mask |= 0xff00;
 		val |= priv->smarteee_lpi_tw_1g << 8;
@@ -978,9 +997,27 @@ static int at803x_smarteee_config(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	tx_lpi_timer_ns = tx_lpi_timer_us * NSEC_PER_USEC;
+	tx_lpi_timer_raw =
+		DIV_ROUND_CLOSEST_ULL(tx_lpi_timer_ns,
+				      AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS);
+	val = FIELD_PREP(AT803X_MMD3_SMARTEEE_LPI_TIME_LOW,
+			 FIELD_GET(AT803X_MMD3_SMARTEEE_LPI_TIME_15_0,
+				   tx_lpi_timer_raw));
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_MMD3_SMARTEEE_CTL2,
+			    val);
+	if (ret)
+		return ret;
+
+	val = AT803X_MMD3_SMARTEEE_CTL3_LPI_EN |
+		FIELD_PREP(AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH,
+			   FIELD_GET(AT803X_MMD3_SMARTEEE_LPI_TIME_23_16,
+				     tx_lpi_timer_raw));
+
 	return phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_MMD3_SMARTEEE_CTL3,
-			      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN,
-			      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+			      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN |
+			      AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH, val);
 }
 
 static int at803x_clk_out_config(struct phy_device *phydev)
@@ -1067,7 +1104,8 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	ret = at803x_smarteee_config(phydev);
+	ret = at803x_smarteee_config(phydev, true,
+				     AT803X_MMD3_SMARTEEE_LPI_TIME_DEF_US);
 	if (ret < 0)
 		return ret;
 
@@ -1612,6 +1650,65 @@ static int at803x_cable_test_start(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
+{
+	struct at803x_priv *priv = phydev->priv;
+	u32 tx_timer_raw;
+	u64 tx_timer_ns;
+	int ret;
+
+	/* If SmartEEE is not enabled, it is expected that tx_lpi_* fields
+	 * are processed by the MAC driver.
+	 */
+	if (priv->flags & AT803X_DISABLE_SMARTEEE)
+		return genphy_c45_ethtool_get_eee(phydev, data);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS,
+			   AT803X_MMD3_SMARTEEE_CTL2);
+	tx_timer_raw = FIELD_PREP(AT803X_MMD3_SMARTEEE_LPI_TIME_15_0,
+				  FIELD_GET(AT803X_MMD3_SMARTEEE_LPI_TIME_LOW,
+					    ret));
+	if (ret < 0)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS,
+			   AT803X_MMD3_SMARTEEE_CTL3);
+	if (ret < 0)
+		return ret;
+
+	tx_timer_raw |= FIELD_PREP(AT803X_MMD3_SMARTEEE_LPI_TIME_23_16,
+				   FIELD_GET(AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH,
+					     ret));
+	tx_timer_ns = tx_timer_raw * AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS;
+	data->tx_lpi_timer = DIV_ROUND_CLOSEST_ULL(tx_timer_ns, NSEC_PER_USEC);
+
+	data->tx_lpi_enabled = !!(ret & AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+
+	return genphy_c45_ethtool_get_eee(phydev, data);
+}
+
+static int at803x_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
+{
+	struct at803x_priv *priv = phydev->priv;
+	int ret;
+
+	/* If SmartEEE is not enabled, it is expected that tx_lpi_* fields
+	 * are processed by the MAC driver.
+	 */
+	if (priv->flags & AT803X_DISABLE_SMARTEEE)
+		return genphy_c45_ethtool_set_eee(phydev, data);
+
+	/* Changing Tx LPI on/off or Tx LPI timer settings
+	 * do not require link reset.
+	 */
+	ret = at803x_smarteee_config(phydev, data->tx_lpi_enabled,
+				     data->tx_lpi_timer);
+	if (ret)
+		return ret;
+
+	return genphy_c45_ethtool_set_eee(phydev, data);
+}
+
 static int qca83xx_config_init(struct phy_device *phydev)
 {
 	u8 switch_revision;
@@ -2038,6 +2135,8 @@ static struct phy_driver at803x_driver[] = {
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
+	.get_eee		= at803x_get_eee,
+	.set_eee		= at803x_set_eee,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
-- 
2.30.2

