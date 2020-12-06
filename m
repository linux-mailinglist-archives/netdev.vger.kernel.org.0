Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636A32D0529
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgLFN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:29:23 -0500
Received: from mx3.wp.pl ([212.77.101.10]:19141 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgLFN3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 08:29:22 -0500
Received: (wp-smtpd smtp.wp.pl 27173 invoked from network); 6 Dec 2020 14:28:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1607261308; bh=ip09e7lwy6J+OiqXRxGpjYH/XrRcAjllum9QVs15JyQ=;
          h=From:To:Cc:Subject;
          b=wS1+r9jilLUUTUmKMRKImZth9PkqkM5elE7YvgmVe6iTPaV4/c200XgMC3tyIJrEn
           hz32NZc/cwOuEVw5YRqCeiVRhpjOwSMG3bcTHHrNxkvQ/0H1pAXwlly+OxlBG3j5i9
           CRuzerX0qvqHALaAz+81nPI8iTZOlAGl1KgoceUw=
Received: from riviera.nat.student.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 6 Dec 2020 14:28:28 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v2 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
Date:   Sun,  6 Dec 2020 14:27:12 +0100
Message-Id: <20201206132713.13452-2-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201206132713.13452-1-olek2@wp.pl>
References: <20201206132713.13452-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 261bf90280fb3613d99f1ab36dc8a1f7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [4XLF]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to use all PHYs on GRX300 and GRX330. The ARX300 has 3
and the GRX330 has 4 integrated PHYs connected to different ports compared
to VRX200.

Port configurations:

xRX200:
GMAC0: RGMII/MII/REVMII/RMII port
GMAC1: RGMII/MII/REVMII/RMII port
GMAC2: GPHY0 (GMII)
GMAC3: GPHY0 (MII)
GMAC4: GPHY1 (GMII)
GMAC5: GPHY1 (MII) or RGMII port

xRX300:
GMAC0: RGMII port
GMAC1: GPHY2 (GMII)
GMAC2: GPHY0 (GMII)
GMAC3: GPHY0 (MII)
GMAC4: GPHY1 (GMII)
GMAC5: GPHY1 (MII) or RGMII port

xRX330:
GMAC0: RGMII/GMII/RMII port
GMAC1: GPHY2 (GMII)
GMAC2: GPHY0 (GMII)
GMAC3: GPHY0 (MII) or GPHY3 (GMII)
GMAC4: GPHY1 (GMII)
GMAC5: GPHY1 (MII) or RGMII/RMII port

Tested on D-Link DWR966 with OpenWRT.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/dsa/lantiq_gswip.c | 170 +++++++++++++++++++++++++++------
 1 file changed, 141 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 09701c17f3f6..4c8f611ed397 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -94,6 +94,7 @@
 /* GSWIP MII Registers */
 #define GSWIP_MII_CFG0			0x00
 #define GSWIP_MII_CFG1			0x02
+#define GSWIP_MII_CFG3			0xc3
 #define GSWIP_MII_CFG5			0x04
 #define  GSWIP_MII_CFG_EN		BIT(14)
 #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
@@ -102,6 +103,7 @@
 #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
 #define  GSWIP_MII_CFG_MODE_RMIIM	0x3
 #define  GSWIP_MII_CFG_MODE_RGMII	0x4
+#define  GSWIP_MII_CFG_MODE_GMII	0x9
 #define  GSWIP_MII_CFG_MODE_MASK	0xf
 #define  GSWIP_MII_CFG_RATE_M2P5	0x00
 #define  GSWIP_MII_CFG_RATE_M25	0x10
@@ -222,6 +224,7 @@
 struct gswip_hw_info {
 	int max_ports;
 	int cpu_port;
+	struct dsa_switch_ops *ops;
 };
 
 struct xway_gphy_match_data {
@@ -392,12 +395,19 @@ static void gswip_mii_mask(struct gswip_priv *priv, u32 clear, u32 set,
 static void gswip_mii_mask_cfg(struct gswip_priv *priv, u32 clear, u32 set,
 			       int port)
 {
+	struct device_node *np = priv->ds->dev->of_node;
+
 	switch (port) {
 	case 0:
 		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG0);
 		break;
 	case 1:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
+		if (of_device_is_compatible(np, "lantiq,xrx200-gswip"))
+			gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
+		break;
+	case 3:
+		if (of_device_is_compatible(np, "lantiq,xrx330-gswip"))
+			gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG3);
 		break;
 	case 5:
 		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG5);
@@ -1409,12 +1419,40 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void gswip_phylink_validate(struct dsa_switch *ds, int port,
-				   unsigned long *supported,
-				   struct phylink_link_state *state)
+static void gswip_phylink_set_capab(unsigned long *supported, struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
+	/* Allow all the expected bits */
+	phylink_set(mask, Autoneg);
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+
+	/* With the exclusion of MII and Reverse MII, we support Gigabit,
+	 * including Half duplex
+	 */
+	if (state->interface != PHY_INTERFACE_MODE_MII &&
+	    state->interface != PHY_INTERFACE_MODE_REVMII) {
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseT_Half);
+	}
+
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
+					  unsigned long *supported,
+					  struct phylink_link_state *state)
+{
 	switch (port) {
 	case 0:
 	case 1:
@@ -1441,37 +1479,56 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
+	gswip_phylink_set_capab(supported, state);
 
-	/* With the exclusion of MII and Reverse MII, we support Gigabit,
-	 * including Half duplex
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
+	return;
+
+unsupported:
+	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+		phy_modes(state->interface), port);
+}
+
+static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int port,
+					  unsigned long *supported,
+					  struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	switch (port) {
+	case 0:
+		if (!phy_interface_mode_is_rgmii(state->interface) &&
+		    state->interface != PHY_INTERFACE_MODE_GMII &&
+		    state->interface != PHY_INTERFACE_MODE_RMII)
+			goto unsupported;
+		break;
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
+			goto unsupported;
+		break;
+	case 5:
+		if (!phy_interface_mode_is_rgmii(state->interface) &&
+		    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
+		    state->interface != PHY_INTERFACE_MODE_RMII)
+			goto unsupported;
+		break;
+	default:
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		dev_err(ds->dev, "Unsupported port: %i\n", port);
+		return;
 	}
 
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
+	gswip_phylink_set_capab(supported, state);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 	return;
 
 unsupported:
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
 		phy_modes(state->interface), port);
-	return;
 }
 
 static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
@@ -1500,6 +1557,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
 		break;
+	case PHY_INTERFACE_MODE_GMII:
+		miicfg |= GSWIP_MII_CFG_MODE_GMII;
+		break;
 	default:
 		dev_err(ds->dev,
 			"Unsupported interface: %d\n", state->interface);
@@ -1614,7 +1674,7 @@ static int gswip_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(gswip_rmon_cnt);
 }
 
-static const struct dsa_switch_ops gswip_switch_ops = {
+static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.get_tag_protocol	= gswip_get_tag_protocol,
 	.setup			= gswip_setup,
 	.port_enable		= gswip_port_enable,
@@ -1630,7 +1690,32 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.port_fdb_add		= gswip_port_fdb_add,
 	.port_fdb_del		= gswip_port_fdb_del,
 	.port_fdb_dump		= gswip_port_fdb_dump,
-	.phylink_validate	= gswip_phylink_validate,
+	.phylink_validate	= gswip_xrx200_phylink_validate,
+	.phylink_mac_config	= gswip_phylink_mac_config,
+	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
+	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
+	.get_strings		= gswip_get_strings,
+	.get_ethtool_stats	= gswip_get_ethtool_stats,
+	.get_sset_count		= gswip_get_sset_count,
+};
+
+static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
+	.get_tag_protocol	= gswip_get_tag_protocol,
+	.setup			= gswip_setup,
+	.port_enable		= gswip_port_enable,
+	.port_disable		= gswip_port_disable,
+	.port_bridge_join	= gswip_port_bridge_join,
+	.port_bridge_leave	= gswip_port_bridge_leave,
+	.port_fast_age		= gswip_port_fast_age,
+	.port_vlan_filtering	= gswip_port_vlan_filtering,
+	.port_vlan_prepare	= gswip_port_vlan_prepare,
+	.port_vlan_add		= gswip_port_vlan_add,
+	.port_vlan_del		= gswip_port_vlan_del,
+	.port_stp_state_set	= gswip_port_stp_state_set,
+	.port_fdb_add		= gswip_port_fdb_add,
+	.port_fdb_del		= gswip_port_fdb_del,
+	.port_fdb_dump		= gswip_port_fdb_dump,
+	.phylink_validate	= gswip_xrx300_phylink_validate,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
 	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
@@ -1859,7 +1944,7 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 static int gswip_probe(struct platform_device *pdev)
 {
 	struct gswip_priv *priv;
-	struct device_node *mdio_np, *gphy_fw_np;
+	struct device_node *np, *mdio_np, *gphy_fw_np;
 	struct device *dev = &pdev->dev;
 	int err;
 	int i;
@@ -1892,10 +1977,28 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->dev = dev;
 	priv->ds->num_ports = priv->hw_info->max_ports;
 	priv->ds->priv = priv;
-	priv->ds->ops = &gswip_switch_ops;
+	priv->ds->ops = priv->hw_info->ops;
 	priv->dev = dev;
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
+	np = dev->of_node;
+	switch (version) {
+	case GSWIP_VERSION_2_0:
+	case GSWIP_VERSION_2_1:
+		if (!of_device_is_compatible(np, "lantiq,xrx200-gswip"))
+			return -EINVAL;
+		break;
+	case GSWIP_VERSION_2_2:
+	case GSWIP_VERSION_2_2_ETC:
+		if (!of_device_is_compatible(np, "lantiq,xrx300-gswip") &&
+		    !of_device_is_compatible(np, "lantiq,xrx330-gswip"))
+			return -EINVAL;
+		break;
+	default:
+		dev_err(dev, "unknown GSWIP version: 0x%x", version);
+		return -ENOENT;
+	}
+
 	/* bring up the mdio bus */
 	gphy_fw_np = of_get_compatible_child(dev->of_node, "lantiq,gphy-fw");
 	if (gphy_fw_np) {
@@ -1973,10 +2076,19 @@ static int gswip_remove(struct platform_device *pdev)
 static const struct gswip_hw_info gswip_xrx200 = {
 	.max_ports = 7,
 	.cpu_port = 6,
+	.ops = &gswip_xrx200_switch_ops,
+};
+
+static const struct gswip_hw_info gswip_xrx300 = {
+	.max_ports = 7,
+	.cpu_port = 6,
+	.ops = &gswip_xrx300_switch_ops,
 };
 
 static const struct of_device_id gswip_of_match[] = {
 	{ .compatible = "lantiq,xrx200-gswip", .data = &gswip_xrx200 },
+	{ .compatible = "lantiq,xrx300-gswip", .data = &gswip_xrx300 },
+	{ .compatible = "lantiq,xrx330-gswip", .data = &gswip_xrx300 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, gswip_of_match);
-- 
2.20.1

