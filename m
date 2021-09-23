Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A3A4160AA
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbhIWOKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:25 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:38953 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241641AbhIWOKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:22 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94816100"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:49 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 16342437F0B4;
        Thu, 23 Sep 2021 23:08:46 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [RFC/PATCH 09/18] ravb: Add half_duplex to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:04 +0100
Message-Id: <20210923140813.13541-10-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L supports half duplex mode.
Add a half_duplex hw feature bit to struct ravb_hw_info for
supporting half duplex mode for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++
 drivers/net/ethernet/renesas/ravb_main.c | 40 +++++++++++++++++++-----
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index dfaf3121da44..7f68f9b8349c 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1025,6 +1025,7 @@ struct ravb_hw_info {
 	unsigned multi_tsrq:1;		/* AVB-DMAC has MULTI TSRQ */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii selection */
+	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
 };
 
 struct ravb_private {
@@ -1079,6 +1080,8 @@ struct ravb_private {
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	unsigned int num_tx_desc;	/* TX descriptors per packet */
 
+	int duplex;
+
 	const struct ravb_hw_info *info;
 	struct reset_control *rstc;
 };
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5d18681582b9..04bff44b7660 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1076,6 +1076,18 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	return budget - quota;
 }
 
+static void ravb_set_duplex_rgeth(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	u32 ecmr = ravb_read(ndev, ECMR);
+
+	if (priv->duplex > 0)	/* Full */
+		ecmr |=  ECMR_DM;
+	else			/* Half */
+		ecmr &= ~ECMR_DM;
+	ravb_write(ndev, ecmr, ECMR);
+}
+
 /* PHY state control function */
 static void ravb_adjust_link(struct net_device *ndev)
 {
@@ -1092,6 +1104,12 @@ static void ravb_adjust_link(struct net_device *ndev)
 		ravb_rcv_snd_disable(ndev);
 
 	if (phydev->link) {
+		if (info->half_duplex && phydev->duplex != priv->duplex) {
+			new_state = true;
+			priv->duplex = phydev->duplex;
+			ravb_set_duplex_rgeth(ndev);
+		}
+
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
@@ -1106,6 +1124,8 @@ static void ravb_adjust_link(struct net_device *ndev)
 		new_state = true;
 		priv->link = 0;
 		priv->speed = 0;
+		if (info->half_duplex)
+			priv->duplex = -1;
 	}
 
 	/* Enable TX and RX right over here, if E-MAC change is ignored */
@@ -1136,6 +1156,7 @@ static int ravb_phy_init(struct net_device *ndev)
 
 	priv->link = 0;
 	priv->speed = 0;
+	priv->duplex = -1;
 
 	/* Try connecting to PHY */
 	pn = of_parse_phandle(np, "phy-handle", 0);
@@ -1178,15 +1199,17 @@ static int ravb_phy_init(struct net_device *ndev)
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID)
 		ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);
 
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
 
@@ -2138,6 +2161,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
 	.tx_counters = 1,
 	.no_gptp = 1,
 	.mii_rgmii_selection = 1,
+	.half_duplex = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
-- 
2.17.1

