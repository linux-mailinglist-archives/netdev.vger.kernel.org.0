Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497FA42249D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhJELJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:09:06 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:11860 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234360AbhJELJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:09:04 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96182800"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 05 Oct 2021 20:07:13 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 085D84001B5F;
        Tue,  5 Oct 2021 20:07:09 +0900 (JST)
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
Subject: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Date:   Tue,  5 Oct 2021 12:06:37 +0100
Message-Id: <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_rx_gbeth() function to support RZ/G2L.

This patch also renames ravb_rcar_rx to ravb_rx_rcar to be
consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC changes:
 * renamed "rxtop_skb" to "rx_1st_skb" and moved near to rx_skb.
 * removed parameter q from "ravb_get_skb_gbeth"
 * renamed ravb_rcar_rx to ravb_rx_rcar
---
 drivers/net/ethernet/renesas/ravb.h      |   1 +
 drivers/net/ethernet/renesas/ravb_main.c | 167 ++++++++++++++++++++++-
 2 files changed, 163 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 35710da808a6..8c7b2569c7dd 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1081,6 +1081,7 @@ struct ravb_private {
 	struct ravb_ex_rx_desc *rx_ring[NUM_RX_QUEUE];
 	struct ravb_tx_desc *tx_ring[NUM_TX_QUEUE];
 	void *tx_align[NUM_TX_QUEUE];
+	struct sk_buff *rx_1st_skb;
 	struct sk_buff **rx_skb[NUM_RX_QUEUE];
 	struct sk_buff **tx_skb[NUM_TX_QUEUE];
 	u32 rx_over_errors;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 37164a983156..42573eac82b9 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -720,6 +720,23 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
 	}
 }
 
+static void ravb_rx_csum_gbeth(struct sk_buff *skb)
+{
+	u8 *hw_csum;
+
+	/* The hardware checksum is contained in sizeof(__sum16) (2) bytes
+	 * appended to packet data
+	 */
+	if (unlikely(skb->len < sizeof(__sum16)))
+		return;
+	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
+
+	if (*hw_csum == 0)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	else
+		skb->ip_summed = CHECKSUM_NONE;
+}
+
 static void ravb_rx_csum(struct sk_buff *skb)
 {
 	u8 *hw_csum;
@@ -735,15 +752,155 @@ static void ravb_rx_csum(struct sk_buff *skb)
 	skb_trim(skb, skb->len - sizeof(__sum16));
 }
 
+static struct sk_buff *ravb_get_skb_gbeth(struct net_device *ndev, int entry,
+					  struct ravb_rx_desc *desc)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct sk_buff *skb;
+
+	skb = priv->rx_skb[RAVB_BE][entry];
+	priv->rx_skb[RAVB_BE][entry] = NULL;
+	dma_unmap_single(ndev->dev.parent, le32_to_cpu(desc->dptr),
+			 ALIGN(GBETH_RX_BUFF_MAX, 16), DMA_FROM_DEVICE);
+
+	return skb;
+}
+
 /* Packet receive function for Gigabit Ethernet */
 static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 {
-	/* Place holder */
-	return true;
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
+	struct net_device_stats *stats;
+	struct ravb_rx_desc *desc;
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	u8  desc_status;
+	int boguscnt;
+	u16 pkt_len;
+	u8  die_dt;
+	int entry;
+	int limit;
+
+	entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+	boguscnt = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
+	stats = &priv->stats[q];
+
+	boguscnt = min(boguscnt, *quota);
+	limit = boguscnt;
+	desc = &priv->gbeth_rx_ring[entry];
+	while (desc->die_dt != DT_FEMPTY) {
+		/* Descriptor type must be checked before all other reads */
+		dma_rmb();
+		desc_status = desc->msc;
+		pkt_len = le16_to_cpu(desc->ds_cc) & RX_DS;
+
+		if (--boguscnt < 0)
+			break;
+
+		/* We use 0-byte descriptors to mark the DMA mapping errors */
+		if (!pkt_len)
+			continue;
+
+		if (desc_status & MSC_MC)
+			stats->multicast++;
+
+		if (desc_status & (MSC_CRC | MSC_RFE | MSC_RTSF | MSC_RTLF | MSC_CEEF)) {
+			stats->rx_errors++;
+			if (desc_status & MSC_CRC)
+				stats->rx_crc_errors++;
+			if (desc_status & MSC_RFE)
+				stats->rx_frame_errors++;
+			if (desc_status & (MSC_RTLF | MSC_RTSF))
+				stats->rx_length_errors++;
+			if (desc_status & MSC_CEEF)
+				stats->rx_missed_errors++;
+		} else {
+			die_dt = desc->die_dt & 0xF0;
+			switch (die_dt) {
+			case DT_FSINGLE:
+				skb = ravb_get_skb_gbeth(ndev, entry, desc);
+				skb_put(skb, pkt_len);
+				skb->protocol = eth_type_trans(skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					ravb_rx_csum_gbeth(skb);
+				napi_gro_receive(&priv->napi[q], skb);
+				stats->rx_packets++;
+				stats->rx_bytes += pkt_len;
+				break;
+			case DT_FSTART:
+				priv->rx_1st_skb = ravb_get_skb_gbeth(ndev, entry, desc);
+				skb_put(priv->rx_1st_skb, pkt_len);
+				break;
+			case DT_FMID:
+				skb = ravb_get_skb_gbeth(ndev, entry, desc);
+				skb_copy_to_linear_data_offset(priv->rx_1st_skb,
+							       priv->rx_1st_skb->len,
+							       skb->data,
+							       pkt_len);
+				skb_put(priv->rx_1st_skb, pkt_len);
+				dev_kfree_skb(skb);
+				break;
+			case DT_FEND:
+				skb = ravb_get_skb_gbeth(ndev, entry, desc);
+				skb_copy_to_linear_data_offset(priv->rx_1st_skb,
+							       priv->rx_1st_skb->len,
+							       skb->data,
+							       pkt_len);
+				skb_put(priv->rx_1st_skb, pkt_len);
+				dev_kfree_skb(skb);
+				priv->rx_1st_skb->protocol =
+					eth_type_trans(priv->rx_1st_skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					ravb_rx_csum_gbeth(skb);
+				napi_gro_receive(&priv->napi[q],
+						 priv->rx_1st_skb);
+				stats->rx_packets++;
+				stats->rx_bytes += priv->rx_1st_skb->len;
+				break;
+			}
+		}
+
+		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
+		desc = &priv->gbeth_rx_ring[entry];
+	}
+
+	/* Refill the RX ring buffers. */
+	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
+		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->gbeth_rx_ring[entry];
+		desc->ds_cc = cpu_to_le16(GBETH_RX_DESC_DATA_SIZE);
+
+		if (!priv->rx_skb[q][entry]) {
+			skb = netdev_alloc_skb(ndev, info->max_rx_len);
+			if (!skb)
+				break;
+			ravb_set_buffer_align(skb);
+			dma_addr = dma_map_single(ndev->dev.parent,
+						  skb->data,
+						  GBETH_RX_BUFF_MAX,
+						  DMA_FROM_DEVICE);
+			skb_checksum_none_assert(skb);
+			/* We just set the data size to 0 for a failed mapping
+			 * which should prevent DMA  from happening...
+			 */
+			if (dma_mapping_error(ndev->dev.parent, dma_addr))
+				desc->ds_cc = cpu_to_le16(0);
+			desc->dptr = cpu_to_le32(dma_addr);
+			priv->rx_skb[q][entry] = skb;
+		}
+		/* Descriptor type must be set after all the above writes */
+		dma_wmb();
+		desc->die_dt = DT_FEMPTY;
+	}
+
+	*quota -= limit - (++boguscnt);
+
+	return boguscnt <= 0;
 }
 
 /* Packet receive function for Ethernet AVB */
-static bool ravb_rcar_rx(struct net_device *ndev, int *quota, int q)
+static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
@@ -2269,7 +2426,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_rcar,
 	.rx_ring_format = ravb_rx_ring_format_rcar,
 	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
-	.receive = ravb_rcar_rx,
+	.receive = ravb_rx_rcar,
 	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
 	.dmac_init = ravb_dmac_init_rcar,
@@ -2294,7 +2451,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_rcar,
 	.rx_ring_format = ravb_rx_ring_format_rcar,
 	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
-	.receive = ravb_rcar_rx,
+	.receive = ravb_rx_rcar,
 	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
 	.dmac_init = ravb_dmac_init_rcar,
-- 
2.17.1

