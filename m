Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7458C4160B1
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbhIWOKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:36 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:46334 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241656AbhIWOKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:32 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936106"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:09:00 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 222AE437F0B4;
        Thu, 23 Sep 2021 23:08:56 +0900 (JST)
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
Subject: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:07 +0100
Message-Id: <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car AVB-DMAC supports timestamp feature.
Add a timestamp hw feature bit to struct ravb_hw_info
to add this feature only for R-Car.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  2 +
 drivers/net/ethernet/renesas/ravb_main.c | 68 +++++++++++++++---------
 2 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index ab4909244276..2505de5d4a28 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1034,6 +1034,7 @@ struct ravb_hw_info {
 	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii selection */
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
 	unsigned rx_2k_buffers:1;	/* AVB-DMAC has Max 2K buf size on RX */
+	unsigned timestamp:1;		/* AVB-DMAC has timestamp */
 };
 
 struct ravb_private {
@@ -1089,6 +1090,7 @@ struct ravb_private {
 	unsigned int num_tx_desc;	/* TX descriptors per packet */
 
 	int duplex;
+	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
 
 	const struct ravb_hw_info *info;
 	struct reset_control *rstc;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9c0d35f4b221..2c375002ebcb 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -949,11 +949,14 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 
 static bool ravb_timestamp_interrupt(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	u32 tis = ravb_read(ndev, TIS);
 
 	if (tis & TIS_TFUF) {
 		ravb_write(ndev, ~(TIS_TFUF | TIS_RESERVED), TIS);
-		ravb_get_tx_tstamp(ndev);
+		if (info->timestamp)
+			ravb_get_tx_tstamp(ndev);
 		return true;
 	}
 	return false;
@@ -1071,16 +1074,24 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = napi->dev;
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
+	struct ravb_rx_desc *desc;
 	unsigned long flags;
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
+	unsigned int entry;
 
+	if (!info->timestamp) {
+		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->rgeth_rx_ring[q][entry];
+	}
 	/* Processing RX Descriptor Ring */
 	/* Clear RX interrupt */
 	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-	if (ravb_rx(ndev, &quota, q))
-		goto out;
+	if (info->timestamp || desc->die_dt != DT_FEMPTY) {
+		if (ravb_rx(ndev, &quota, q))
+			goto out;
+	}
 
 	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1689,6 +1700,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	unsigned int num_tx_desc = priv->num_tx_desc;
 	u16 q = skb_get_queue_mapping(skb);
 	struct ravb_tstamp_skb *ts_skb;
@@ -1765,28 +1777,30 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	desc->dptr = cpu_to_le32(dma_addr);
 
 	/* TX timestamp required */
-	if (q == RAVB_NC) {
-		ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
-		if (!ts_skb) {
-			if (num_tx_desc > 1) {
-				desc--;
-				dma_unmap_single(ndev->dev.parent, dma_addr,
-						 len, DMA_TO_DEVICE);
+	if (info->timestamp) {
+		if (q == RAVB_NC) {
+			ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
+			if (!ts_skb) {
+				if (num_tx_desc > 1) {
+					desc--;
+					dma_unmap_single(ndev->dev.parent, dma_addr,
+							 len, DMA_TO_DEVICE);
+				}
+				goto unmap;
 			}
-			goto unmap;
+			ts_skb->skb = skb_get(skb);
+			ts_skb->tag = priv->ts_skb_tag++;
+			priv->ts_skb_tag &= 0x3ff;
+			list_add_tail(&ts_skb->list, &priv->ts_skb_list);
+
+			/* TAG and timestamp required flag */
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
+			desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
 		}
-		ts_skb->skb = skb_get(skb);
-		ts_skb->tag = priv->ts_skb_tag++;
-		priv->ts_skb_tag &= 0x3ff;
-		list_add_tail(&ts_skb->list, &priv->ts_skb_list);
 
-		/* TAG and timestamp required flag */
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
-		desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
+		skb_tx_timestamp(skb);
 	}
-
-	skb_tx_timestamp(skb);
 	/* Descriptor type must be set after all the above writes */
 	dma_wmb();
 	if (num_tx_desc > 1) {
@@ -1897,10 +1911,12 @@ static int ravb_close(struct net_device *ndev)
 			   "device will be stopped after h/w processes are done.\n");
 
 	/* Clear the timestamp list */
-	list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
-		list_del(&ts_skb->list);
-		kfree_skb(ts_skb->skb);
-		kfree(ts_skb);
+	if (info->timestamp) {
+		list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
+			list_del(&ts_skb->list);
+			kfree_skb(ts_skb->skb);
+			kfree(ts_skb);
+		}
 	}
 
 	/* PHY disconnect */
@@ -2165,6 +2181,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.multi_tsrq = 1,
 	.magic_pkt = 1,
 	.rx_2k_buffers = 1,
+	.timestamp = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2186,6 +2203,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.multi_tsrq = 1,
 	.magic_pkt = 1,
 	.rx_2k_buffers = 1,
+	.timestamp = 1,
 };
 
 static const struct ravb_hw_info rgeth_hw_info = {
-- 
2.17.1

