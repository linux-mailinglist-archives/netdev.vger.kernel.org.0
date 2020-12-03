Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0982CE168
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbgLCWMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:12:50 -0500
Received: from mx3.wp.pl ([212.77.101.10]:37531 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgLCWMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 17:12:50 -0500
Received: (wp-smtpd smtp.wp.pl 11723 invoked from network); 3 Dec 2020 23:05:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1607033117; bh=H0FgeHZC0EWlJhtdawwC6Ly3Ohyf6UIgJbkfOLNibLQ=;
          h=From:To:Cc:Subject;
          b=gYQNxvFqXv9/kGk3cfWrUzd5hr6cOZL54zxMSvHyZg811PVFAsmoNGd5GBZAh67EB
           dmtEiYKQHRms4Hyk8ifzse6J0CNIirFqKhgTiqmQKFzY5I0WuPUokEzvJobZ/5Rjt2
           nyHe4NyTbqpA23SQsSsqoCGNsAwQHIoUjGlKgBoY=
Received: from riviera.nat.student.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 3 Dec 2020 23:05:17 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
Date:   Thu,  3 Dec 2020 23:03:46 +0100
Message-Id: <20201203220347.13691-1-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: ff01465fd06e59ca9a76bab1cd74303d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [QZFs]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>

This patch allows you to use all phs on GRX300 and GRX330. The ARX300 has 3
and the GRX330 has 4 integrated PHYs connected to different ports compared
to VRX200.

Port configurations:

xRX200:
GMAC0: RGMII port
GMAC1: RGMII port
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
GMAC0: RGMII port
GMAC1: GPHY2 (GMII)
GMAC2: GPHY0 (GMII)
GMAC3: GPHY3 (GMII)
GMAC4: GPHY1 (GMII)
GMAC5: GPHY1 (MII) or RGMII port

Tested on D-Link DWR966 with OpenWRT.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/dsa/lantiq_gswip.c | 110 +++++++++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 09701c17f3f6..540cf99ad7fe 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -222,6 +222,7 @@
 struct gswip_hw_info {
 	int max_ports;
 	int cpu_port;
+	struct dsa_switch_ops *ops;
 };
 
 struct xway_gphy_match_data {
@@ -1409,9 +1410,9 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void gswip_phylink_validate(struct dsa_switch *ds, int port,
-				   unsigned long *supported,
-				   struct phylink_link_state *state)
+static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
+					  unsigned long *supported,
+					  struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
@@ -1471,7 +1472,70 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
 		phy_modes(state->interface), port);
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
+		    state->interface != PHY_INTERFACE_MODE_MII &&
+		    state->interface != PHY_INTERFACE_MODE_REVMII &&
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
+		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
+			goto unsupported;
+		break;
+	default:
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		dev_err(ds->dev, "Unsupported port: %i\n", port);
+		return;
+	}
+
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
 	return;
+
+unsupported:
+	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+		phy_modes(state->interface), port);
 }
 
 static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
@@ -1614,7 +1678,7 @@ static int gswip_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(gswip_rmon_cnt);
 }
 
-static const struct dsa_switch_ops gswip_switch_ops = {
+static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.get_tag_protocol	= gswip_get_tag_protocol,
 	.setup			= gswip_setup,
 	.port_enable		= gswip_port_enable,
@@ -1630,7 +1694,32 @@ static const struct dsa_switch_ops gswip_switch_ops = {
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
@@ -1892,7 +1981,7 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->dev = dev;
 	priv->ds->num_ports = priv->hw_info->max_ports;
 	priv->ds->priv = priv;
-	priv->ds->ops = &gswip_switch_ops;
+	priv->ds->ops = priv->hw_info->ops;
 	priv->dev = dev;
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
@@ -1973,10 +2062,19 @@ static int gswip_remove(struct platform_device *pdev)
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

