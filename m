Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920354160A6
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241649AbhIWOKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:19 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:47424 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241642AbhIWOKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:18 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936092"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:46 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id AAA1B437F0B5;
        Thu, 23 Sep 2021 23:08:43 +0900 (JST)
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
Subject: [RFC/PATCH 08/18] ravb: Add mii_rgmii_selection to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:03 +0100
Message-Id: <20210923140813.13541-9-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

E-MAC on RZ/G2L supports MII/RGMII selection. Add a
mii_rgmii_selection feature bit to struct ravb_hw_info
to support this for RZ/G2L.
Currently only selecting RGMII is supported.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 17 +++++++++++++++++
 drivers/net/ethernet/renesas/ravb_main.c |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index bce480fadb91..dfaf3121da44 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -189,6 +189,8 @@ enum ravb_reg {
 	PIR	= 0x0520,
 	PSR	= 0x0528,
 	PIPR	= 0x052c,
+	CXR31	= 0x0530,	/* Documented for RZ/G2L only */
+	CXR35	= 0x0540,	/* Documented for RZ/G2L only */
 	MPR	= 0x0558,
 	PFTCR	= 0x055c,
 	PFRCR	= 0x0560,
@@ -951,6 +953,20 @@ enum RAVB_QUEUE {
 	RAVB_NC,	/* Network Control Queue */
 };
 
+enum CXR31_BIT {
+	CXR31_SEL_LINK0	= 0x00000001,
+	CXR31_SEL_LINK1	= 0x00000008,
+};
+
+enum CXR35_BIT {
+	CXR35_SEL_MODIN	= 0x00000100,
+};
+
+enum CSR0_BIT {
+	CSR0_TPE	= 0x00000010,
+	CSR0_RPE	= 0x00000020,
+};
+
 #define DBAT_ENTRY_NUM	22
 #define RX_QUEUE_OFFSET	4
 #define NUM_RX_QUEUE	2
@@ -1008,6 +1024,7 @@ struct ravb_hw_info {
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned multi_tsrq:1;		/* AVB-DMAC has MULTI TSRQ */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
+	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii selection */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 529364d8f7fb..5d18681582b9 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1128,6 +1128,7 @@ static int ravb_phy_init(struct net_device *ndev)
 {
 	struct device_node *np = ndev->dev.parent->of_node;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct phy_device *phydev;
 	struct device_node *pn;
 	phy_interface_t iface;
@@ -1173,6 +1174,10 @@ static int ravb_phy_init(struct net_device *ndev)
 		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
 	}
 
+	if (info->mii_rgmii_selection &&
+	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID)
+		ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);
+
 	/* 10BASE, Pause and Asym Pause is not supported */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
@@ -2132,6 +2137,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
 	.aligned_tx = 1,
 	.tx_counters = 1,
 	.no_gptp = 1,
+	.mii_rgmii_selection = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
-- 
2.17.1

