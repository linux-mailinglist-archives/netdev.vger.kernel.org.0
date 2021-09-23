Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2DD41609B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbhIWOKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:02 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:55722 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241591AbhIWOKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:02 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94816069"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:29 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B7A7B437F0AD;
        Thu, 23 Sep 2021 23:08:26 +0900 (JST)
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
Subject: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
Date:   Thu, 23 Sep 2021 15:07:58 +0100
Message-Id: <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize GbEthernet dmac found on RZ/G2L SoC.
This patch also renames ravb_rcar_dmac_init to ravb_dmac_init_rcar
to be consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  4 ++
 drivers/net/ethernet/renesas/ravb_main.c | 84 +++++++++++++++++++++++-
 2 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 0ce0c13ef8cb..bee05e6fb815 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -81,6 +81,7 @@ enum ravb_reg {
 	RQC3	= 0x00A0,
 	RQC4	= 0x00A4,
 	RPC	= 0x00B0,
+	RTC	= 0x00B4,	/* RZ/G2L only */
 	UFCW	= 0x00BC,
 	UFCS	= 0x00C0,
 	UFCV0	= 0x00C4,
@@ -156,6 +157,7 @@ enum ravb_reg {
 	TIS	= 0x037C,
 	ISS	= 0x0380,
 	CIE	= 0x0384,	/* R-Car Gen3 only */
+	RIC3	= 0x0388,	/* RZ/G2L only */
 	GCCR	= 0x0390,
 	GMTT	= 0x0394,
 	GPTC	= 0x0398,
@@ -956,6 +958,8 @@ enum RAVB_QUEUE {
 
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
+#define RGETH_RX_BUFF_MAX 8192
+
 struct ravb_tstamp_skb {
 	struct list_head list;
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 2422e74d9b4f..54c4d31a6950 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -83,6 +83,11 @@ static int ravb_config(struct net_device *ndev)
 	return error;
 }
 
+static void ravb_rgeth_set_rate(struct net_device *ndev)
+{
+	/* Place holder */
+}
+
 static void ravb_set_rate(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -217,6 +222,11 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 	return free_num;
 }
 
+static void ravb_rx_ring_free_rgeth(struct net_device *ndev, int q)
+{
+	/* Place holder */
+}
+
 static void ravb_rx_ring_free(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -283,6 +293,11 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 	priv->tx_skb[q] = NULL;
 }
 
+static void ravb_rx_ring_format_rgeth(struct net_device *ndev, int q)
+{
+	/* Place holder */
+}
+
 static void ravb_rx_ring_format(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -356,6 +371,12 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	desc->dptr = cpu_to_le32((u32)priv->tx_desc_dma[q]);
 }
 
+static void *ravb_rgeth_alloc_rx_desc(struct net_device *ndev, int q)
+{
+	/* Place holder */
+	return NULL;
+}
+
 static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -426,6 +447,11 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	return -ENOMEM;
 }
 
+static void ravb_rgeth_emac_init(struct net_device *ndev)
+{
+	/* Place holder */
+}
+
 static void ravb_rcar_emac_init(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
@@ -461,7 +487,32 @@ static void ravb_emac_init(struct net_device *ndev)
 	info->emac_init(ndev);
 }
 
-static void ravb_rcar_dmac_init(struct net_device *ndev)
+static void ravb_dmac_init_rgeth(struct net_device *ndev)
+{
+	/* Set AVB RX */
+	ravb_write(ndev, 0x60000000, RCR);
+
+	/* Set Max Frame Length (RTC) */
+	ravb_write(ndev, 0x7ffc0000 | RGETH_RX_BUFF_MAX, RTC);
+
+	/* Set FIFO size */
+	ravb_write(ndev, 0x00222200, TGC);
+
+	ravb_write(ndev, 0, TCCR);
+
+	/* Frame receive */
+	ravb_write(ndev, RIC0_FRE0, RIC0);
+	/* Disable FIFO full warning */
+	ravb_write(ndev, 0x0, RIC1);
+	/* Receive FIFO full error, descriptor empty */
+	ravb_write(ndev, RIC2_QFE0 | RIC2_RFFE, RIC2);
+
+	ravb_write(ndev, 0x0, RIC3);
+
+	ravb_write(ndev, TIC_FTE0, TIC);
+}
+
+static void ravb_dmac_init_rcar(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
@@ -579,6 +630,14 @@ static void ravb_rx_csum(struct sk_buff *skb)
 	skb_trim(skb, skb->len - sizeof(__sum16));
 }
 
+/* Packet receive function for Gigabit Ethernet */
+static bool ravb_rgeth_rx(struct net_device *ndev, int *quota, int q)
+{
+	/* Place holder */
+	return true;
+}
+
+/* Packet receive function for Ethernet AVB */
 static bool ravb_rcar_rx(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -1918,6 +1977,13 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+static int ravb_set_features_rgeth(struct net_device *ndev,
+				   netdev_features_t features)
+{
+	/* Place holder */
+	return 0;
+}
+
 static int ravb_set_features_rcar(struct net_device *ndev,
 				  netdev_features_t features)
 {
@@ -2007,7 +2073,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
 	.set_feature = ravb_set_features_rcar,
-	.dmac_init = ravb_rcar_dmac_init,
+	.dmac_init = ravb_dmac_init_rcar,
 	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
@@ -2028,7 +2094,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
 	.set_feature = ravb_set_features_rcar,
-	.dmac_init = ravb_rcar_dmac_init,
+	.dmac_init = ravb_dmac_init_rcar,
 	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
@@ -2039,12 +2105,24 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.aligned_tx = 1,
 };
 
+static const struct ravb_hw_info rgeth_hw_info = {
+	.rx_ring_free = ravb_rx_ring_free_rgeth,
+	.rx_ring_format = ravb_rx_ring_format_rgeth,
+	.alloc_rx_desc = ravb_rgeth_alloc_rx_desc,
+	.receive = ravb_rgeth_rx,
+	.set_rate = ravb_rgeth_set_rate,
+	.set_feature = ravb_set_features_rgeth,
+	.dmac_init = ravb_dmac_init_rgeth,
+	.emac_init = ravb_rgeth_emac_init,
+};
+
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
+	{ .compatible = "renesas,rzg2l-gbeth", .data = &rgeth_hw_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);
-- 
2.17.1

