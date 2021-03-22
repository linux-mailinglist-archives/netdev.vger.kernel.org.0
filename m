Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D2D3450EF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhCVUhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:37:51 -0400
Received: from mx4.wp.pl ([212.77.101.11]:18914 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCVUhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:37:36 -0400
Received: (wp-smtpd smtp.wp.pl 8425 invoked from network); 22 Mar 2021 21:37:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616445454; bh=/0Gremb1iXHXioQpdB6k08M6NvR06LKhz4tLTT1b4tg=;
          h=From:To:Cc:Subject;
          b=gfI6te2TP6YKgWm+F7ykJpDxfNRYsHsmy56TpVlHXPA1frAVvYU8BRxUnojWVEa43
           BIDCQc5ZWT2K27WKTA92ZLrLUfo8dJA8fO3sznRHaVQMgG4oMAD3n6802nTK6BqLGO
           o8kGNyhBb6//v88zlAPaxQu8gop9hqBfbB8SSqgY=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 22 Mar 2021 21:37:34 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v4 1/3] net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
Date:   Mon, 22 Mar 2021 21:37:15 +0100
Message-Id: <20210322203717.20616-2-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322203717.20616-1-olek2@wp.pl>
References: <20210322203717.20616-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: df493bb3743050fa064afee829d9b74c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [UWI2]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to use all PHYs on GRX300 and GRX330. The ARX300
has 3 and the GRX330 has 4 integrated PHYs connected to different
ports compared to VRX200. Each integrated PHY can work as single
Gigabit Ethernet PHY (GMII) or as double Fast Ethernet PHY (MII).

Allowed port configurations:

xRX200:
GMAC0: RGMII, MII, REVMII or RMII port
GMAC1: RGMII, MII, REVMII or RMII port
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
GMAC0: RGMII, GMII or RMII port
GMAC1: GPHY2 (GMII)
GMAC2: GPHY0 (GMII)
GMAC3: GPHY0 (MII) or GPHY3 (GMII)
GMAC4: GPHY1 (GMII)
GMAC5: GPHY1 (MII), RGMII or RMII port

Tested on D-Link DWR966 (xRX330) with OpenWRT.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 142 ++++++++++++++++++++++++++-------
 1 file changed, 113 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 52e865a3912c..4cab5cd26928 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Lantiq / Intel GSWIP switch driver for VRX200 SoCs
+ * Lantiq / Intel GSWIP switch driver for VRX200, xRX300 and xRX330 SoCs
  *
  * Copyright (C) 2010 Lantiq Deutschland
  * Copyright (C) 2012 John Crispin <john@phrozen.org>
@@ -100,6 +100,7 @@
 #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
 #define  GSWIP_MII_CFG_MODE_RMIIM	0x3
 #define  GSWIP_MII_CFG_MODE_RGMII	0x4
+#define  GSWIP_MII_CFG_MODE_GMII	0x9
 #define  GSWIP_MII_CFG_MODE_MASK	0xf
 #define  GSWIP_MII_CFG_RATE_M2P5	0x00
 #define  GSWIP_MII_CFG_RATE_M25	0x10
@@ -220,6 +221,7 @@
 struct gswip_hw_info {
 	int max_ports;
 	int cpu_port;
+	const struct dsa_switch_ops *ops;
 };
 
 struct xway_gphy_match_data {
@@ -1384,12 +1386,42 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void gswip_phylink_validate(struct dsa_switch *ds, int port,
-				   unsigned long *supported,
-				   struct phylink_link_state *state)
+static void gswip_phylink_set_capab(unsigned long *supported,
+				    struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
+	/* Allow all the expected bits */
+	phylink_set(mask, Autoneg);
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+
+	/* With the exclusion of MII, Reverse MII and Reduced MII, we
+	 * support Gigabit, including Half duplex
+	 */
+	if (state->interface != PHY_INTERFACE_MODE_MII &&
+	    state->interface != PHY_INTERFACE_MODE_REVMII &&
+	    state->interface != PHY_INTERFACE_MODE_RMII) {
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
@@ -1416,38 +1448,54 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
+	gswip_phylink_set_capab(supported, state);
 
-	/* With the exclusion of MII, Reverse MII and Reduced MII, we
-	 * support Gigabit, including Half duplex
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII &&
-	    state->interface != PHY_INTERFACE_MODE_RMII) {
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
@@ -1476,6 +1524,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
 		break;
+	case PHY_INTERFACE_MODE_GMII:
+		miicfg |= GSWIP_MII_CFG_MODE_GMII;
+		break;
 	default:
 		dev_err(ds->dev,
 			"Unsupported interface: %d\n", state->interface);
@@ -1588,7 +1639,7 @@ static int gswip_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(gswip_rmon_cnt);
 }
 
-static const struct dsa_switch_ops gswip_switch_ops = {
+static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.get_tag_protocol	= gswip_get_tag_protocol,
 	.setup			= gswip_setup,
 	.port_enable		= gswip_port_enable,
@@ -1603,7 +1654,31 @@ static const struct dsa_switch_ops gswip_switch_ops = {
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
@@ -1865,7 +1940,7 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->dev = dev;
 	priv->ds->num_ports = priv->hw_info->max_ports;
 	priv->ds->priv = priv;
-	priv->ds->ops = &gswip_switch_ops;
+	priv->ds->ops = priv->hw_info->ops;
 	priv->dev = dev;
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
@@ -1946,10 +2021,19 @@ static int gswip_remove(struct platform_device *pdev)
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

