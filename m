Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8403E6CA784
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjC0OZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjC0OYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:24:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3300F7D91
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:28 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Ho-L2; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjY-0076IX-RR; Mon, 27 Mar 2023 16:22:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00Fkjc-UV; Mon, 27 Mar 2023 16:22:02 +0200
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
Subject: [PATCH net-next v2 7/8] net: phy: at803x: Fix SmartEEE support for some link configurations
Date:   Mon, 27 Mar 2023 16:22:01 +0200
Message-Id: <20230327142202.3754446-8-o.rempel@pengutronix.de>
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

This commit fixes SmartEEE support for certain link configurations on the
AR8035 PHY. Before this patch, if AR8035 was running with SmartEEE enabled
(EEE and LPI are on), it would not be able to establish a 100BaseTX/Half or
1000BaseT/Half link. A similar issue would occur with 100BaseTX/Full and an
LPI TX timer configured to less than 80 msec.

To avoid this issue, we need to keep LPI disabled before the link is
established and enable it only when a supported link configuration is
detected. By implementing this fix, the at803x driver can now correctly
handle SmartEEE features for various link configurations, improving link
establishment, compatibility, and overall performance.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 4f65b3ebf806..5a12f778d675 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1014,10 +1014,15 @@ static int at803x_smarteee_config(struct phy_device *phydev)
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
@@ -1691,7 +1696,7 @@ static int at803x_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 	tx_timer_ns = tx_timer_raw * AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS;
 	data->tx_lpi_timer = DIV_ROUND_CLOSEST_ULL(tx_timer_ns, NSEC_PER_USEC);
 
-	data->tx_lpi_enabled = !!(ret & AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+	data->tx_lpi_enabled = priv->tx_lpi_on;
 
 	return genphy_c45_ethtool_get_eee(phydev, data);
 }
@@ -1725,6 +1730,28 @@ static int at803x_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 	return genphy_c45_ethtool_set_eee(phydev, data);
 }
 
+static void at8035_link_change_notify(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	if (phydev->mac_supports_eee || !phydev->is_smart_eee_phy)
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
@@ -2153,6 +2180,7 @@ static struct phy_driver at803x_driver[] = {
 	.cable_test_get_status	= at803x_cable_test_get_status,
 	.get_eee		= at803x_get_eee,
 	.set_eee		= at803x_set_eee,
+	.link_change_notify	= at8035_link_change_notify,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
-- 
2.30.2

