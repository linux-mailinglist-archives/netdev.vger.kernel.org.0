Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F75E4160AC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhIWOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:29 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:46334 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241670AbhIWOKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:25 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936097"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:53 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 653A5437F0B5;
        Thu, 23 Sep 2021 23:08:50 +0900 (JST)
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
Subject: [RFC/PATCH 10/18] ravb: Initialize GbEthernet E-MAC
Date:   Thu, 23 Sep 2021 15:08:05 +0100
Message-Id: <20210923140813.13541-11-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize GbEthernet E-MAC found on RZ/G2L SoC.
This patch also renames ravb_set_rate to ravb_set_rate_rcar and
ravb_rcar_emac_init to ravb_emac_init_rcar to be consistent with
the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 15 ++++--
 drivers/net/ethernet/renesas/ravb_main.c | 64 +++++++++++++++++++-----
 2 files changed, 62 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7f68f9b8349c..7532cb51d7b8 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -204,6 +204,7 @@ enum ravb_reg {
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
 	MAFCR	= 0x0778,
+	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
 };
 
 
@@ -814,10 +815,11 @@ enum ECMR_BIT {
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
 
@@ -827,6 +829,7 @@ enum ECSR_BIT {
 	ECSR_MPD	= 0x00000002,
 	ECSR_LCHNG	= 0x00000004,
 	ECSR_PHYI	= 0x00000008,
+	ECSR_PFRI	= 0x00000010,
 };
 
 /* ECSIPR */
@@ -861,9 +864,13 @@ enum MPR_BIT {
 
 /* GECMR */
 enum GECMR_BIT {
-	GECMR_SPEED	= 0x00000001,
-	GECMR_SPEED_100	= 0x00000000,
-	GECMR_SPEED_1000 = 0x00000001,
+	GECMR_SPEED		= 0x00000001,
+	GECMR_SPEED_100		= 0x00000000,
+	GECMR_SPEED_1000	= 0x00000001,
+	RGETH_GECMR_SPEED	= 0x00000030,
+	RGETH_GECMR_SPEED_10	= 0x00000000,
+	RGETH_GECMR_SPEED_100	= 0x00000010,
+	RGETH_GECMR_SPEED_1000	= 0x00000020,
 };
 
 /* The Ethernet AVB descriptor definitions. */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 04bff44b7660..7f06adbd00e1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -83,12 +83,24 @@ static int ravb_config(struct net_device *ndev)
 	return error;
 }
 
-static void ravb_rgeth_set_rate(struct net_device *ndev)
+static void ravb_set_rate_rgeth(struct net_device *ndev)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	switch (priv->speed) {
+	case 10:                /* 10BASE */
+		ravb_write(ndev, RGETH_GECMR_SPEED_10, GECMR);
+		break;
+	case 100:               /* 100BASE */
+		ravb_write(ndev, RGETH_GECMR_SPEED_100, GECMR);
+		break;
+	case 1000:              /* 1000BASE */
+		ravb_write(ndev, RGETH_GECMR_SPEED_1000, GECMR);
+		break;
+	}
 }
 
-static void ravb_set_rate(struct net_device *ndev)
+static void ravb_set_rate_rcar(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 
@@ -447,12 +459,38 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	return -ENOMEM;
 }
 
-static void ravb_rgeth_emac_init(struct net_device *ndev)
+static void ravb_emac_init_rgeth(struct net_device *ndev)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	/* Receive frame limit set register */
+	ravb_write(ndev, RGETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
+
+	/* PAUSE prohibition */
+	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
+			 ECMR_TE | ECMR_RE | ECMR_RCPT |
+			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
+
+	ravb_set_rate_rgeth(ndev);
+
+	/* Set MAC address */
+	ravb_write(ndev,
+		   (ndev->dev_addr[0] << 24) | (ndev->dev_addr[1] << 16) |
+		   (ndev->dev_addr[2] << 8)  | (ndev->dev_addr[3]), MAHR);
+	ravb_write(ndev, (ndev->dev_addr[4] << 8)  | (ndev->dev_addr[5]), MALR);
+
+	/* E-MAC status register clear */
+	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_PFRI, ECSR);
+	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
+
+	/* E-MAC interrupt enable register */
+	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
+
+	ravb_write(ndev, ravb_read(ndev, CXR31) & ~CXR31_SEL_LINK1, CXR31);
+	ravb_write(ndev, ravb_read(ndev, CXR31) | CXR31_SEL_LINK0, CXR31);
 }
 
-static void ravb_rcar_emac_init(struct net_device *ndev)
+static void ravb_emac_init_rcar(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
 	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
@@ -462,7 +500,7 @@ static void ravb_rcar_emac_init(struct net_device *ndev)
 		   (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
 		   ECMR_TE | ECMR_RE, ECMR);
 
-	ravb_set_rate(ndev);
+	ravb_set_rate_rcar(ndev);
 
 	/* Set MAC address */
 	ravb_write(ndev,
@@ -2110,10 +2148,10 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
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
@@ -2133,10 +2171,10 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
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
@@ -2153,10 +2191,10 @@ static const struct ravb_hw_info rgeth_hw_info = {
 	.rx_ring_format = ravb_rx_ring_format_rgeth,
 	.alloc_rx_desc = ravb_rgeth_alloc_rx_desc,
 	.receive = ravb_rgeth_rx,
-	.set_rate = ravb_rgeth_set_rate,
+	.set_rate = ravb_set_rate_rgeth,
 	.set_feature = ravb_set_features_rgeth,
 	.dmac_init = ravb_dmac_init_rgeth,
-	.emac_init = ravb_rgeth_emac_init,
+	.emac_init = ravb_emac_init_rgeth,
 	.aligned_tx = 1,
 	.tx_counters = 1,
 	.no_gptp = 1,
-- 
2.17.1

