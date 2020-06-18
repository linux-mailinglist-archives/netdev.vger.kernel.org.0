Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2081FF166
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgFRMMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:12:05 -0400
Received: from gloria.sntech.de ([185.11.138.130]:53386 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgFRMLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:11:50 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jltOP-0007op-VG; Thu, 18 Jun 2020 14:11:42 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: [PATCH v5 1/3] net: phy: mscc: move shared probe code into a helper
Date:   Thu, 18 Jun 2020 14:11:37 +0200
Message-Id: <20200618121139.1703762-2-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618121139.1703762-1-heiko@sntech.de>
References: <20200618121139.1703762-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

The different probe functions share a lot of code, so move the
common parts into a helper to reduce duplication.

This moves the devm_phy_package_join below the general allocation
but as all components just allocate things, this should be ok.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mscc/mscc_main.c | 124 +++++++++++++++----------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 5ddc44f87eaf..5d2777522fb4 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1935,12 +1935,11 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
-static int vsc8514_probe(struct phy_device *phydev)
+static int vsc85xx_probe_helper(struct phy_device *phydev,
+				u32 *leds, int num_leds, u16 led_modes,
+				const struct vsc85xx_hw_stat *stats, int nstats)
 {
 	struct vsc8531_private *vsc8531;
-	u32 default_mode[4] = {VSC8531_LINK_1000_ACTIVITY,
-	   VSC8531_LINK_100_ACTIVITY, VSC8531_LINK_ACTIVITY,
-	   VSC8531_DUPLEX_COLLISION};
 
 	vsc8531 = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531), GFP_KERNEL);
 	if (!vsc8531)
@@ -1948,54 +1947,66 @@ static int vsc8514_probe(struct phy_device *phydev)
 
 	phydev->priv = vsc8531;
 
-	vsc8584_get_base_addr(phydev);
-	devm_phy_package_join(&phydev->mdio.dev, phydev,
-			      vsc8531->base_addr, 0);
-
-	vsc8531->nleds = 4;
-	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
-	vsc8531->hw_stats = vsc85xx_hw_stats;
-	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
+	vsc8531->nleds = num_leds;
+	vsc8531->supp_led_modes = led_modes;
+	vsc8531->hw_stats = stats;
+	vsc8531->nstats = nstats;
 	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
 				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
-	return vsc85xx_dt_led_modes_get(phydev, default_mode);
+	return vsc85xx_dt_led_modes_get(phydev, leds);
 }
 
-static int vsc8574_probe(struct phy_device *phydev)
+static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
+	int rc;
 	u32 default_mode[4] = {VSC8531_LINK_1000_ACTIVITY,
 	   VSC8531_LINK_100_ACTIVITY, VSC8531_LINK_ACTIVITY,
 	   VSC8531_DUPLEX_COLLISION};
 
-	vsc8531 = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531), GFP_KERNEL);
-	if (!vsc8531)
-		return -ENOMEM;
-
-	phydev->priv = vsc8531;
+	rc = vsc85xx_probe_helper(phydev, default_mode,
+				  ARRAY_SIZE(default_mode),
+				  VSC85XX_SUPP_LED_MODES,
+				  vsc85xx_hw_stats,
+				  ARRAY_SIZE(vsc85xx_hw_stats));
+	if (rc < 0)
+		return rc;
 
+	vsc8531 = phydev->priv;
 	vsc8584_get_base_addr(phydev);
-	devm_phy_package_join(&phydev->mdio.dev, phydev,
-			      vsc8531->base_addr, 0);
+	return devm_phy_package_join(&phydev->mdio.dev, phydev,
+				     vsc8531->base_addr, 0);
+}
 
-	vsc8531->nleds = 4;
-	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
-	vsc8531->hw_stats = vsc8584_hw_stats;
-	vsc8531->nstats = ARRAY_SIZE(vsc8584_hw_stats);
-	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
-				      sizeof(u64), GFP_KERNEL);
-	if (!vsc8531->stats)
-		return -ENOMEM;
+static int vsc8574_probe(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531;
+	int rc;
+	u32 default_mode[4] = {VSC8531_LINK_1000_ACTIVITY,
+	   VSC8531_LINK_100_ACTIVITY, VSC8531_LINK_ACTIVITY,
+	   VSC8531_DUPLEX_COLLISION};
+
+	rc = vsc85xx_probe_helper(phydev, default_mode,
+				  ARRAY_SIZE(default_mode),
+				  VSC8584_SUPP_LED_MODES,
+				  vsc8584_hw_stats,
+				  ARRAY_SIZE(vsc8584_hw_stats));
+	if (rc < 0)
+		return rc;
 
-	return vsc85xx_dt_led_modes_get(phydev, default_mode);
+	vsc8531 = phydev->priv;
+	vsc8584_get_base_addr(phydev);
+	return devm_phy_package_join(&phydev->mdio.dev, phydev,
+				     vsc8531->base_addr, 0);
 }
 
 static int vsc8584_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
+	int rc;
 	u32 default_mode[4] = {VSC8531_LINK_1000_ACTIVITY,
 	   VSC8531_LINK_100_ACTIVITY, VSC8531_LINK_ACTIVITY,
 	   VSC8531_DUPLEX_COLLISION};
@@ -2005,32 +2016,24 @@ static int vsc8584_probe(struct phy_device *phydev)
 		return -ENOTSUPP;
 	}
 
-	vsc8531 = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531), GFP_KERNEL);
-	if (!vsc8531)
-		return -ENOMEM;
-
-	phydev->priv = vsc8531;
+	rc = vsc85xx_probe_helper(phydev, default_mode,
+				  ARRAY_SIZE(default_mode),
+				  VSC8584_SUPP_LED_MODES,
+				  vsc8584_hw_stats,
+				  ARRAY_SIZE(vsc8584_hw_stats));
+	if (rc < 0)
+		return rc;
 
+	vsc8531 = phydev->priv;
 	vsc8584_get_base_addr(phydev);
-	devm_phy_package_join(&phydev->mdio.dev, phydev,
-			      vsc8531->base_addr, 0);
-
-	vsc8531->nleds = 4;
-	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
-	vsc8531->hw_stats = vsc8584_hw_stats;
-	vsc8531->nstats = ARRAY_SIZE(vsc8584_hw_stats);
-	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
-				      sizeof(u64), GFP_KERNEL);
-	if (!vsc8531->stats)
-		return -ENOMEM;
-
-	return vsc85xx_dt_led_modes_get(phydev, default_mode);
+	return devm_phy_package_join(&phydev->mdio.dev, phydev,
+				     vsc8531->base_addr, 0);
 }
 
 static int vsc85xx_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
-	int rate_magic;
+	int rate_magic, rc;
 	u32 default_mode[2] = {VSC8531_LINK_1000_ACTIVITY,
 	   VSC8531_LINK_100_ACTIVITY};
 
@@ -2038,23 +2041,18 @@ static int vsc85xx_probe(struct phy_device *phydev)
 	if (rate_magic < 0)
 		return rate_magic;
 
-	vsc8531 = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531), GFP_KERNEL);
-	if (!vsc8531)
-		return -ENOMEM;
-
-	phydev->priv = vsc8531;
+	rc = vsc85xx_probe_helper(phydev, default_mode,
+				  ARRAY_SIZE(default_mode),
+				  VSC85XX_SUPP_LED_MODES,
+				  vsc85xx_hw_stats,
+				  ARRAY_SIZE(vsc85xx_hw_stats));
+	if (rc < 0)
+		return rc;
 
+	vsc8531 = phydev->priv;
 	vsc8531->rate_magic = rate_magic;
-	vsc8531->nleds = 2;
-	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
-	vsc8531->hw_stats = vsc85xx_hw_stats;
-	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
-	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
-				      sizeof(u64), GFP_KERNEL);
-	if (!vsc8531->stats)
-		return -ENOMEM;
 
-	return vsc85xx_dt_led_modes_get(phydev, default_mode);
+	return 0;
 }
 
 /* Microsemi VSC85xx PHYs */
-- 
2.26.2

