Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD02F41F099
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354928AbhJAPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:09:15 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:38307 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1355084AbhJAPJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:09:00 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671642"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:07:15 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 8A22E43DDFC5;
        Sat,  2 Oct 2021 00:07:12 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 09/10] ravb: Add half_duplex to struct ravb_hw_info
Date:   Fri,  1 Oct 2021 16:06:35 +0100
Message-Id: <20211001150636.7500-10-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L supports half duplex mode.
Add a half_duplex hw feature bit to struct ravb_hw_info for
supporting half duplex mode for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
RFC->v1:
 * Added Sergei's Rb tag.
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++
 drivers/net/ethernet/renesas/ravb_main.c | 36 ++++++++++++++++++------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index f0d9b7bc8c20..d83d3b4f3f5f 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1008,6 +1008,7 @@ struct ravb_hw_info {
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
+	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
 };
 
 struct ravb_private {
@@ -1062,6 +1063,8 @@ struct ravb_private {
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	unsigned int num_tx_desc;	/* TX descriptors per packet */
 
+	int duplex;
+
 	const struct ravb_hw_info *info;
 	struct reset_control *rstc;
 };
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 6fb11d4cfc57..3e694738e683 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1091,6 +1091,13 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	return budget - quota;
 }
 
+static void ravb_set_duplex_gbeth(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	ravb_modify(ndev, ECMR, ECMR_DM, priv->duplex > 0 ? ECMR_DM : 0);
+}
+
 /* PHY state control function */
 static void ravb_adjust_link(struct net_device *ndev)
 {
@@ -1107,6 +1114,12 @@ static void ravb_adjust_link(struct net_device *ndev)
 		ravb_rcv_snd_disable(ndev);
 
 	if (phydev->link) {
+		if (info->half_duplex && phydev->duplex != priv->duplex) {
+			new_state = true;
+			priv->duplex = phydev->duplex;
+			ravb_set_duplex_gbeth(ndev);
+		}
+
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
@@ -1121,6 +1134,8 @@ static void ravb_adjust_link(struct net_device *ndev)
 		new_state = true;
 		priv->link = 0;
 		priv->speed = 0;
+		if (info->half_duplex)
+			priv->duplex = -1;
 	}
 
 	/* Enable TX and RX right over here, if E-MAC change is ignored */
@@ -1143,6 +1158,7 @@ static int ravb_phy_init(struct net_device *ndev)
 {
 	struct device_node *np = ndev->dev.parent->of_node;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct phy_device *phydev;
 	struct device_node *pn;
 	phy_interface_t iface;
@@ -1150,6 +1166,7 @@ static int ravb_phy_init(struct net_device *ndev)
 
 	priv->link = 0;
 	priv->speed = 0;
+	priv->duplex = -1;
 
 	/* Try connecting to PHY */
 	pn = of_parse_phandle(np, "phy-handle", 0);
@@ -1188,15 +1205,17 @@ static int ravb_phy_init(struct net_device *ndev)
 		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
 	}
 
-	/* 10BASE, Pause and Asym Pause is not supported */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
+	if (!info->half_duplex) {
+		/* 10BASE, Pause and Asym Pause is not supported */
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
 
-	/* Half Duplex is not supported */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+		/* Half Duplex is not supported */
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	}
 
 	phy_attached_info(phydev);
 
@@ -2175,6 +2194,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.tsrq = TCCR_TSRQ0,
 	.aligned_tx = 1,
 	.tx_counters = 1,
+	.half_duplex = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
-- 
2.17.1

