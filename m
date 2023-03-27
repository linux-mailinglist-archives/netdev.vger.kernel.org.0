Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0E6CA781
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjC0OZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjC0OYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:24:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9236B6E86
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:28 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Hk-Kt; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjY-0076IN-Cv; Mon, 27 Mar 2023 16:22:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00FkjT-Th; Mon, 27 Mar 2023 16:22:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 6/8] net: phy: at803x: Make SmartEEE support optional and configurable via ethtool
Date:   Mon, 27 Mar 2023 16:22:00 +0200
Message-Id: <20230327142202.3754446-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230327142202.3754446-1-o.rempel@pengutronix.de>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes SmartEEE support in the AR8035 PHY optional and
configurable through the ethtool eee_set/get interface. Before this
patch, SmartEEE was always enabled except when a device tree option was
preventing it. Since EEE support not only provides advantages in power
management, but can also uncover compatibility issues and other bugs, it
is beneficial to allow users to control this functionality.

By making SmartEEE support optional and configurable via ethtool, the
at803x driver can adapt to different MAC configurations and properly
handle EEE and LPI features. This flexibility empowers users to manage
the trade-offs between power management, compatibility, and overall
performance as needed.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 126 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 118 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 653d27a2e62b..4f65b3ebf806 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -165,8 +165,18 @@
 
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
@@ -302,6 +312,8 @@ struct at803x_priv {
 	u8 smarteee_lpi_tw_100m;
 	bool is_fiber;
 	bool is_1000basex;
+	bool tx_lpi_on;
+	u32 tx_lpi_timer;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
@@ -858,8 +870,12 @@ static int at803x_probe(struct phy_device *phydev)
 
 	if (phydev->drv->phy_id == ATH8035_PHY_ID ||
 	    phydev->drv->phy_id == ATH8031_PHY_ID) {
-		if (!(priv->flags & AT803X_DISABLE_SMARTEEE))
+		if (!(priv->flags & AT803X_DISABLE_SMARTEEE)) {
 			phydev->is_smart_eee_phy = true;
+			priv->tx_lpi_on = true;
+			priv->tx_lpi_timer =
+				AT803X_MMD3_SMARTEEE_LPI_TIME_DEF_US;
+		}
 	}
 
 	if (priv->vddio) {
@@ -959,10 +975,12 @@ static int at803x_get_features(struct phy_device *phydev)
 static int at803x_smarteee_config(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
+	u64 tx_lpi_timer_raw;
+	u64 tx_lpi_timer_ns;
 	u16 mask = 0, val = 0;
 	int ret;
 
-	if (priv->flags & AT803X_DISABLE_SMARTEEE)
+	if (!priv->tx_lpi_on)
 		return phy_modify_mmd(phydev, MDIO_MMD_PCS,
 				      AT803X_MMD3_SMARTEEE_CTL3,
 				      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN, 0);
@@ -983,9 +1001,27 @@ static int at803x_smarteee_config(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	tx_lpi_timer_ns = priv->tx_lpi_timer * NSEC_PER_USEC;
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
@@ -1072,10 +1108,6 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	ret = at803x_smarteee_config(phydev);
-	if (ret < 0)
-		return ret;
-
 	ret = at803x_clk_out_config(phydev);
 	if (ret < 0)
 		return ret;
@@ -1359,6 +1391,16 @@ static int at803x_config_aneg(struct phy_device *phydev)
 			return ret;
 	}
 
+	/* only after PHY is attached we will be able to see if MAC supports
+	 * EEE
+	 */
+	if (phydev->mac_supports_eee)
+		priv->tx_lpi_on = false;
+
+	ret = at803x_smarteee_config(phydev);
+	if (ret < 0)
+		return ret;
+
 	return __genphy_config_aneg(phydev, ret);
 }
 
@@ -1617,6 +1659,72 @@ static int at803x_cable_test_start(struct phy_device *phydev)
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
+	if (phydev->mac_supports_eee || !phydev->is_smart_eee_phy)
+		return genphy_c45_ethtool_set_eee(phydev, data);
+
+	if (data->tx_lpi_timer > AT803X_MMD3_SMARTEEE_LPI_TIME_MAX_US) {
+		phydev_err(phydev, "Max LPI timer is %lu microsecs\n",
+			   AT803X_MMD3_SMARTEEE_LPI_TIME_MAX_US);
+		return -EINVAL;
+	}
+
+	/* Changing Tx LPI on/off or Tx LPI timer settings
+	 * do not require link reset.
+	 */
+	priv->tx_lpi_timer = data->tx_lpi_timer;
+	priv->tx_lpi_on = data->tx_lpi_enabled;
+	ret = at803x_smarteee_config(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_c45_ethtool_set_eee(phydev, data);
+}
+
 static int qca83xx_config_init(struct phy_device *phydev)
 {
 	u8 switch_revision;
@@ -2043,6 +2151,8 @@ static struct phy_driver at803x_driver[] = {
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

