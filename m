Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A8D41F098
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355000AbhJAPJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:09:11 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:8350 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1355003AbhJAPJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:09:05 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671647"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:07:19 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 241A443DDFC5;
        Sat,  2 Oct 2021 00:07:15 +0900 (JST)
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
Subject: [PATCH 10/10] ravb: Initialize GbEthernet E-MAC
Date:   Fri,  1 Oct 2021 16:06:36 +0100
Message-Id: <20211001150636.7500-11-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize GbEthernet E-MAC found on RZ/G2L SoC.
This patch also renames ravb_set_rate to ravb_set_rate_rcar and
ravb_rcar_emac_init to ravb_emac_init_rcar to be consistent with
the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * Moved CSR0 intialization to later patch.
 * started using ravb_modify for initializing link registers.
---
 drivers/net/ethernet/renesas/ravb.h      | 20 +++++++--
 drivers/net/ethernet/renesas/ravb_main.c | 55 ++++++++++++++++++++----
 2 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index d83d3b4f3f5f..5dc1324786e0 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -188,6 +188,7 @@ enum ravb_reg {
 	PIR	= 0x0520,
 	PSR	= 0x0528,
 	PIPR	= 0x052c,
+	CXR31	= 0x0530,	/* RZ/G2L only */
 	MPR	= 0x0558,
 	PFTCR	= 0x055c,
 	PFRCR	= 0x0560,
@@ -811,10 +812,11 @@ enum ECMR_BIT {
 	ECMR_TXF	= 0x00010000,	/* Documented for R-Car Gen3 only */
 	ECMR_RXF	= 0x00020000,
 	ECMR_PFR	= 0x00040000,
-	ECMR_ZPF	= 0x00080000,	/* Documented for R-Car Gen3 only */
+	ECMR_ZPF	= 0x00080000,	/* Documented for R-Car Gen3 and RZ/G2L */
 	ECMR_RZPF	= 0x00100000,
 	ECMR_DPAD	= 0x00200000,
 	ECMR_RCSC	= 0x00800000,
+	ECMR_RCPT	= 0x02000000,	/* Documented for RZ/G2L only */
 	ECMR_TRCCM	= 0x04000000,
 };
 
@@ -824,6 +826,7 @@ enum ECSR_BIT {
 	ECSR_MPD	= 0x00000002,
 	ECSR_LCHNG	= 0x00000004,
 	ECSR_PHYI	= 0x00000008,
+	ECSR_PFRI	= 0x00000010,
 };
 
 /* ECSIPR */
@@ -858,9 +861,13 @@ enum MPR_BIT {
 
 /* GECMR */
 enum GECMR_BIT {
-	GECMR_SPEED	= 0x00000001,
-	GECMR_SPEED_100	= 0x00000000,
-	GECMR_SPEED_1000 = 0x00000001,
+	GECMR_SPEED		= 0x00000001,
+	GECMR_SPEED_100		= 0x00000000,
+	GECMR_SPEED_1000	= 0x00000001,
+	GBETH_GECMR_SPEED	= 0x00000030,
+	GBETH_GECMR_SPEED_10	= 0x00000000,
+	GBETH_GECMR_SPEED_100	= 0x00000010,
+	GBETH_GECMR_SPEED_1000	= 0x00000020,
 };
 
 /* The Ethernet AVB descriptor definitions. */
@@ -950,6 +957,11 @@ enum RAVB_QUEUE {
 	RAVB_NC,	/* Network Control Queue */
 };
 
+enum CXR31_BIT {
+	CXR31_SEL_LINK0	= 0x00000001,
+	CXR31_SEL_LINK1	= 0x00000008,
+};
+
 #define DBAT_ENTRY_NUM	22
 #define RX_QUEUE_OFFSET	4
 #define NUM_RX_QUEUE	2
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 3e694738e683..9a4888543384 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -85,10 +85,22 @@ static int ravb_config(struct net_device *ndev)
 
 static void ravb_set_rate_gbeth(struct net_device *ndev)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	switch (priv->speed) {
+	case 10:                /* 10BASE */
+		ravb_write(ndev, GBETH_GECMR_SPEED_10, GECMR);
+		break;
+	case 100:               /* 100BASE */
+		ravb_write(ndev, GBETH_GECMR_SPEED_100, GECMR);
+		break;
+	case 1000:              /* 1000BASE */
+		ravb_write(ndev, GBETH_GECMR_SPEED_1000, GECMR);
+		break;
+	}
 }
 
-static void ravb_set_rate(struct net_device *ndev)
+static void ravb_set_rate_rcar(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 
@@ -449,10 +461,35 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 
 static void ravb_emac_init_gbeth(struct net_device *ndev)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	/* Receive frame limit set register */
+	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
+
+	/* PAUSE prohibition */
+	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
+			 ECMR_TE | ECMR_RE | ECMR_RCPT |
+			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
+
+	ravb_set_rate_gbeth(ndev);
+
+	/* Set MAC address */
+	ravb_write(ndev,
+		   (ndev->dev_addr[0] << 24) | (ndev->dev_addr[1] << 16) |
+		   (ndev->dev_addr[2] << 8)  | (ndev->dev_addr[3]), MAHR);
+	ravb_write(ndev, (ndev->dev_addr[4] << 8)  | (ndev->dev_addr[5]), MALR);
+
+	/* E-MAC status register clear */
+	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_PFRI, ECSR);
+
+	/* E-MAC interrupt enable register */
+	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
+
+	ravb_modify(ndev, CXR31, CXR31_SEL_LINK1, 0);
+	ravb_modify(ndev, CXR31, CXR31_SEL_LINK0, CXR31_SEL_LINK0);
 }
 
-static void ravb_rcar_emac_init(struct net_device *ndev)
+static void ravb_emac_init_rcar(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
 	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
@@ -462,7 +499,7 @@ static void ravb_rcar_emac_init(struct net_device *ndev)
 		   (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
 		   ECMR_TE | ECMR_RE, ECMR);
 
-	ravb_set_rate(ndev);
+	ravb_set_rate_rcar(ndev);
 
 	/* Set MAC address */
 	ravb_write(ndev,
@@ -2140,10 +2177,10 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_format = ravb_rx_ring_format,
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
-	.set_rate = ravb_set_rate,
+	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
 	.dmac_init = ravb_dmac_init_rcar,
-	.emac_init = ravb_rcar_emac_init,
+	.emac_init = ravb_emac_init_rcar,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -2164,10 +2201,10 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_format = ravb_rx_ring_format,
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
-	.set_rate = ravb_set_rate,
+	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
 	.dmac_init = ravb_dmac_init_rcar,
-	.emac_init = ravb_rcar_emac_init,
+	.emac_init = ravb_emac_init_rcar,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

