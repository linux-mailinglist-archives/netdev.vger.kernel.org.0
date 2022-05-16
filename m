Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5548C5289B5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245666AbiEPQIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245660AbiEPQIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5764387A0;
        Mon, 16 May 2022 09:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4210FB81262;
        Mon, 16 May 2022 16:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA39C385AA;
        Mon, 16 May 2022 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717298;
        bh=bqRrGEoslTKGIdX7RJMT09747G7fzI1Rh0bOJoh3Q94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyoAfymV59aKkCKNMxWb91/2uG5v/nBOuBGQaHvxNnMADxvW8Gvxt5PI4HSliYqnr
         jPX6zoUBCHwjDrheI6M8uMsQOsHgKIGV57lVgBNE64OoK20jeTMw3w35m8Wkc84I4h
         p1Ut6A18lcbqvt7poYRPowHN9Zg89O1cDn4+XBrkLSE2/q2TQ/M2gzMYZOlegSAmoV
         Nockx1yiwKfWtZ3A4Ts5mAxM2vm6qGiH/989RDV+lfeMLqR/DqZVsSW4p02o4CWIm4
         j3wRlVHv3PEWA62pN+ElzUvO19ajU35lzzyw46ldY7AK5mnkZGSIqtyBpvcEIfa2oK
         Ou5sI4+RCFZaA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 12/15] net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support
Date:   Mon, 16 May 2022 18:06:39 +0200
Message-Id: <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce MTK_NETSYS_V2 support. MTK_NETSYS_V2 defines 32B TX/RX DMA
descriptors.
This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 312 ++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 129 +++++++-
 2 files changed, 366 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4dfd43023d80..50ffdcb8d35a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -778,8 +778,8 @@ static inline int mtk_max_buf_size(int frag_size)
 	return buf_size;
 }
 
-static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
-				   struct mtk_rx_dma *dma_rxd)
+static bool mtk_rx_get_desc(struct mtk_eth *eth, struct mtk_rx_dma_v2 *rxd,
+			    struct mtk_rx_dma_v2 *dma_rxd)
 {
 	rxd->rxd2 = READ_ONCE(dma_rxd->rxd2);
 	if (!(rxd->rxd2 & RX_DMA_DONE))
@@ -788,6 +788,10 @@ static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd3 = READ_ONCE(dma_rxd->rxd3);
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		rxd->rxd5 = READ_ONCE(dma_rxd->rxd5);
+		rxd->rxd6 = READ_ONCE(dma_rxd->rxd6);
+	}
 
 	return true;
 }
@@ -821,7 +825,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	phy_ring_tail = eth->phy_scratch_ring + soc->txrx.txd_size * (cnt - 1);
 
 	for (i = 0; i < cnt; i++) {
-		struct mtk_tx_dma *txd;
+		struct mtk_tx_dma_v2 *txd;
 
 		txd = (void *)eth->scratch_ring + i * soc->txrx.txd_size;
 		txd->txd1 = dma_addr + i * MTK_QDMA_PAGE_SIZE;
@@ -831,6 +835,12 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 
 		txd->txd3 = TX_DMA_PLEN0(MTK_QDMA_PAGE_SIZE);
 		txd->txd4 = 0;
+		if (MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V2)) {
+			txd->txd5 = 0;
+			txd->txd6 = 0;
+			txd->txd7 = 0;
+			txd->txd8 = 0;
+		}
 	}
 
 	mtk_w32(eth, eth->phy_scratch_ring, MTK_QDMA_FQ_HEAD);
@@ -934,10 +944,12 @@ static void setup_tx_buf(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
 	}
 }
 
-static void mtk_tx_set_dma_desc(struct net_device *dev, struct mtk_tx_dma *desc,
-				struct mtk_tx_dma_desc_info *info)
+static void mtk_tx_set_dma_desc_v1(struct net_device *dev, void *txd,
+				   struct mtk_tx_dma_desc_info *info)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	struct mtk_tx_dma *desc = txd;
 	u32 data;
 
 	WRITE_ONCE(desc->txd1, info->addr);
@@ -961,6 +973,59 @@ static void mtk_tx_set_dma_desc(struct net_device *dev, struct mtk_tx_dma *desc,
 	WRITE_ONCE(desc->txd4, data);
 }
 
+static void mtk_tx_set_dma_desc_v2(struct net_device *dev, void *txd,
+				   struct mtk_tx_dma_desc_info *info)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_tx_dma_v2 *desc = txd;
+	struct mtk_eth *eth = mac->hw;
+	u32 data;
+
+	WRITE_ONCE(desc->txd1, info->addr);
+
+	data = TX_DMA_PLEN0(info->size);
+	if (info->last)
+		data |= TX_DMA_LS0;
+	WRITE_ONCE(desc->txd3, data);
+
+	if (!info->qid && mac->id)
+		info->qid = MTK_QDMA_GMAC2_QID;
+
+	data = (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
+	data |= TX_DMA_SWC_V2 | QID_BITS_V2(info->qid);
+	WRITE_ONCE(desc->txd4, data);
+
+	data = 0;
+	if (info->first) {
+		if (info->gso)
+			data |= TX_DMA_TSO_V2;
+		/* tx checksum offload */
+		if (info->csum)
+			data |= TX_DMA_CHKSUM_V2;
+	}
+	WRITE_ONCE(desc->txd5, data);
+
+	data = 0;
+	if (info->first && info->vlan)
+		data |= TX_DMA_INS_VLAN_V2 | info->vlan_tci;
+	WRITE_ONCE(desc->txd6, data);
+
+	WRITE_ONCE(desc->txd7, 0);
+	WRITE_ONCE(desc->txd8, 0);
+}
+
+static void mtk_tx_set_dma_desc(struct net_device *dev, void *txd,
+				struct mtk_tx_dma_desc_info *info)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		mtk_tx_set_dma_desc_v2(dev, txd, info);
+	else
+		mtk_tx_set_dma_desc_v1(dev, txd, info);
+}
+
 static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		      int tx_num, struct mtk_tx_ring *ring, bool gso)
 {
@@ -969,6 +1034,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		.gso = gso,
 		.csum = skb->ip_summed == CHECKSUM_PARTIAL,
 		.vlan = skb_vlan_tag_present(skb),
+		.qid = skb->mark & MTK_QDMA_TX_MASK,
 		.vlan_tci = skb_vlan_tag_get(skb),
 		.first = true,
 		.last = !skb_is_nonlinear(skb),
@@ -1028,7 +1094,9 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 			}
 
 			memset(&txd_info, 0, sizeof(struct mtk_tx_dma_desc_info));
-			txd_info.size = min(frag_size, MTK_TX_DMA_BUF_LEN);
+			txd_info.size = min_t(unsigned int, frag_size,
+					      soc->txrx.dma_max_len);
+			txd_info.qid = skb->mark & MTK_QDMA_TX_MASK;
 			txd_info.last = i == skb_shinfo(skb)->nr_frags - 1 &&
 					!(frag_size - txd_info.size);
 			txd_info.addr = skb_frag_dma_map(eth->dma_dev, frag,
@@ -1109,17 +1177,16 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	return -ENOMEM;
 }
 
-static inline int mtk_cal_txd_req(struct sk_buff *skb)
+static int mtk_cal_txd_req(struct mtk_eth *eth, struct sk_buff *skb)
 {
-	int i, nfrags;
+	int i, nfrags = 1;
 	skb_frag_t *frag;
 
-	nfrags = 1;
 	if (skb_is_gso(skb)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			frag = &skb_shinfo(skb)->frags[i];
 			nfrags += DIV_ROUND_UP(skb_frag_size(frag),
-						MTK_TX_DMA_BUF_LEN);
+					       eth->soc->txrx.dma_max_len);
 		}
 	} else {
 		nfrags += skb_shinfo(skb)->nr_frags;
@@ -1171,7 +1238,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
 		goto drop;
 
-	tx_num = mtk_cal_txd_req(skb);
+	tx_num = mtk_cal_txd_req(eth, skb);
 	if (unlikely(atomic_read(&ring->free_count) <= tx_num)) {
 		netif_stop_queue(dev);
 		netif_err(eth, tx_queued, dev,
@@ -1263,7 +1330,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 	int idx;
 	struct sk_buff *skb;
 	u8 *data, *new_data;
-	struct mtk_rx_dma *rxd, trxd;
+	struct mtk_rx_dma_v2 *rxd, trxd;
 	int done = 0, bytes = 0;
 
 	while (done < budget) {
@@ -1271,7 +1338,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		unsigned int pktlen;
 		dma_addr_t dma_addr;
 		u32 hash, reason;
-		int mac;
+		int mac = 0;
 
 		ring = mtk_get_rx_ring(eth);
 		if (unlikely(!ring))
@@ -1281,16 +1348,15 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		rxd = (void *)ring->dma + idx * eth->soc->txrx.rxd_size;
 		data = ring->data[idx];
 
-		if (!mtk_rx_get_desc(&trxd, rxd))
+		if (!mtk_rx_get_desc(eth, &trxd, rxd))
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) ||
-		    (trxd.rxd4 & RX_DMA_SPECIAL_TAG))
-			mac = 0;
-		else
-			mac = ((trxd.rxd4 >> RX_DMA_FPORT_SHIFT) &
-			       RX_DMA_FPORT_MASK) - 1;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			mac = RX_DMA_GET_SPORT_V2(trxd.rxd5) - 1;
+		else if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
+			 !(trxd.rxd4 & RX_DMA_SPECIAL_TAG))
+			mac = RX_DMA_GET_SPORT(trxd.rxd4) - 1;
 
 		if (unlikely(mac < 0 || mac >= MTK_MAC_COUNT ||
 			     !eth->netdev[mac]))
@@ -1333,7 +1399,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
 		skb_put(skb, pktlen);
-		if (trxd.rxd4 & eth->rx_dma_l4_valid)
+		if (trxd.rxd4 & eth->soc->txrx.rx_dma_l4_valid)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		else
 			skb_checksum_none_assert(skb);
@@ -1351,10 +1417,25 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			mtk_ppe_check_skb(eth->ppe, skb,
 					  trxd.rxd4 & MTK_RXD4_FOE_ENTRY);
 
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
-		    (trxd.rxd2 & RX_DMA_VTAG))
-			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-					       RX_DMA_VID(trxd.rxd3));
+		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+				if (trxd.rxd3 & RX_DMA_VTAG_V2)
+					__vlan_hwaccel_put_tag(skb,
+						htons(RX_DMA_VPID(trxd.rxd4)),
+						RX_DMA_VID(trxd.rxd4));
+			} else if (trxd.rxd2 & RX_DMA_VTAG) {
+				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+						       RX_DMA_VID(trxd.rxd3));
+			}
+
+			/* If the device is attached to a dsa switch, the special
+			 * tag inserted in VLAN field by hw switch can * be offloaded
+			 * by RX HW VLAN offload. Clear vlan info.
+			 */
+			if (netdev_uses_dsa(netdev))
+				__vlan_hwaccel_clear_tag(skb);
+		}
+
 		skb_record_rx_queue(skb, 0);
 		napi_gro_receive(napi, skb);
 
@@ -1366,7 +1447,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 			rxd->rxd2 = RX_DMA_LSO;
 		else
-			rxd->rxd2 = RX_DMA_PLEN0(ring->buf_size);
+			rxd->rxd2 = RX_DMA_PREP_PLEN0(ring->buf_size);
 
 		ring->calc_idx = idx;
 
@@ -1565,7 +1646,8 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
 	do {
 		int rx_done;
 
-		mtk_w32(eth, MTK_RX_DONE_INT, MTK_PDMA_INT_STATUS);
+		mtk_w32(eth, eth->soc->txrx.rx_irq_done_mask,
+			MTK_PDMA_INT_STATUS);
 		rx_done = mtk_poll_rx(napi, budget - rx_done_total, eth);
 		rx_done_total += rx_done;
 
@@ -1579,10 +1661,11 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
 		if (rx_done_total == budget)
 			return budget;
 
-	} while (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT);
+	} while (mtk_r32(eth, MTK_PDMA_INT_STATUS) &
+		 eth->soc->txrx.rx_irq_done_mask);
 
 	if (napi_complete_done(napi, rx_done_total))
-		mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
+		mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
 
 	return rx_done_total;
 }
@@ -1591,7 +1674,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 {
 	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
-	struct mtk_tx_dma *txd;
+	struct mtk_tx_dma_v2 *txd;
 	int i;
 
 	ring->buf = kcalloc(MTK_DMA_SIZE, sizeof(*ring->buf),
@@ -1613,13 +1696,19 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		txd->txd2 = next_ptr;
 		txd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		txd->txd4 = 0;
+		if (MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V2)) {
+			txd->txd5 = 0;
+			txd->txd6 = 0;
+			txd->txd7 = 0;
+			txd->txd8 = 0;
+		}
 	}
 
 	/* On MT7688 (PDMA only) this driver uses the ring->dma structs
 	 * only as the framework. The real HW descriptors are the PDMA
 	 * descriptors in ring->dma_pdma.
 	 */
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
 		ring->dma_pdma = dma_alloc_coherent(eth->dma_dev,
 				MTK_DMA_SIZE * soc->txrx.txd_size,
 				&ring->phys_pdma, GFP_ATOMIC);
@@ -1700,13 +1789,11 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 	struct mtk_rx_ring *ring;
 	int rx_data_len, rx_dma_size;
 	int i;
-	u32 offset = 0;
 
 	if (rx_flag == MTK_RX_FLAGS_QDMA) {
 		if (ring_no)
 			return -EINVAL;
 		ring = &eth->rx_ring_qdma;
-		offset = 0x1000;
 	} else {
 		ring = &eth->rx_ring[ring_no];
 	}
@@ -1739,7 +1826,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		struct mtk_rx_dma *rxd;
+		struct mtk_rx_dma_v2 *rxd;
 
 		dma_addr_t dma_addr = dma_map_single(eth->dma_dev,
 				ring->data[i] + NET_SKB_PAD + eth->ip_align,
@@ -1754,24 +1841,39 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 			rxd->rxd2 = RX_DMA_LSO;
 		else
-			rxd->rxd2 = RX_DMA_PLEN0(ring->buf_size);
+			rxd->rxd2 = RX_DMA_PREP_PLEN0(ring->buf_size);
 
 		rxd->rxd3 = 0;
 		rxd->rxd4 = 0;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+			rxd->rxd5 = 0;
+			rxd->rxd6 = 0;
+			rxd->rxd7 = 0;
+			rxd->rxd8 = 0;
+		}
 	}
 	ring->dma_size = rx_dma_size;
 	ring->calc_idx_update = false;
 	ring->calc_idx = rx_dma_size - 1;
-	ring->crx_idx_reg = MTK_PRX_CRX_IDX_CFG(ring_no);
+	if (rx_flag == MTK_RX_FLAGS_QDMA)
+		ring->crx_idx_reg = MTK_QRX_CRX_IDX_CFG(ring_no);
+	else
+		ring->crx_idx_reg = MTK_PRX_CRX_IDX_CFG(ring_no);
 	/* make sure that all changes to the dma ring are flushed before we
 	 * continue
 	 */
 	wmb();
 
-	mtk_w32(eth, ring->phys, MTK_PRX_BASE_PTR_CFG(ring_no) + offset);
-	mtk_w32(eth, rx_dma_size, MTK_PRX_MAX_CNT_CFG(ring_no) + offset);
-	mtk_w32(eth, ring->calc_idx, ring->crx_idx_reg + offset);
-	mtk_w32(eth, MTK_PST_DRX_IDX_CFG(ring_no), MTK_PDMA_RST_IDX + offset);
+	if (rx_flag == MTK_RX_FLAGS_QDMA) {
+		mtk_w32(eth, ring->phys, MTK_QRX_BASE_PTR_CFG(ring_no));
+		mtk_w32(eth, rx_dma_size, MTK_QRX_MAX_CNT_CFG(ring_no));
+		mtk_w32(eth, MTK_PST_DRX_IDX_CFG(ring_no), MTK_QDMA_RST_IDX);
+	} else {
+		mtk_w32(eth, ring->phys, MTK_PRX_BASE_PTR_CFG(ring_no));
+		mtk_w32(eth, rx_dma_size, MTK_PRX_MAX_CNT_CFG(ring_no));
+		mtk_w32(eth, MTK_PST_DRX_IDX_CFG(ring_no), MTK_PDMA_RST_IDX);
+	}
+	mtk_w32(eth, ring->calc_idx, ring->crx_idx_reg);
 
 	return 0;
 }
@@ -2190,7 +2292,7 @@ static irqreturn_t mtk_handle_irq_rx(int irq, void *_eth)
 	eth->rx_events++;
 	if (likely(napi_schedule_prep(&eth->rx_napi))) {
 		__napi_schedule(&eth->rx_napi);
-		mtk_rx_irq_disable(eth, MTK_RX_DONE_INT);
+		mtk_rx_irq_disable(eth, eth->soc->txrx.rx_irq_done_mask);
 	}
 
 	return IRQ_HANDLED;
@@ -2213,8 +2315,10 @@ static irqreturn_t mtk_handle_irq(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
 
-	if (mtk_r32(eth, MTK_PDMA_INT_MASK) & MTK_RX_DONE_INT) {
-		if (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT)
+	if (mtk_r32(eth, MTK_PDMA_INT_MASK) &
+	    eth->soc->txrx.rx_irq_done_mask) {
+		if (mtk_r32(eth, MTK_PDMA_INT_STATUS) &
+		    eth->soc->txrx.rx_irq_done_mask)
 			mtk_handle_irq_rx(irq, _eth);
 	}
 	if (mtk_r32(eth, eth->tx_int_mask_reg) & MTK_TX_DONE_INT) {
@@ -2232,16 +2336,16 @@ static void mtk_poll_controller(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
-	mtk_rx_irq_disable(eth, MTK_RX_DONE_INT);
+	mtk_rx_irq_disable(eth, eth->soc->txrx.rx_irq_done_mask);
 	mtk_handle_irq_rx(eth->irq[2], dev);
 	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
-	mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
+	mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
 }
 #endif
 
 static int mtk_start_dma(struct mtk_eth *eth)
 {
-	u32 rx_2b_offset = (NET_IP_ALIGN == 2) ? MTK_RX_2B_OFFSET : 0;
+	u32 val, rx_2b_offset = (NET_IP_ALIGN == 2) ? MTK_RX_2B_OFFSET : 0;
 	int err;
 
 	err = mtk_dma_init(eth);
@@ -2251,12 +2355,18 @@ static int mtk_start_dma(struct mtk_eth *eth)
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
-		mtk_w32(eth,
-			MTK_TX_WB_DDONE | MTK_TX_DMA_EN |
-			MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
-			MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
-			MTK_RX_BT_32DWORDS,
-			MTK_QDMA_GLO_CFG);
+		val = mtk_r32(eth, MTK_QDMA_GLO_CFG);
+		val |= MTK_TX_DMA_EN | MTK_RX_DMA_EN |
+		       MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
+		       MTK_RX_2B_OFFSET | MTK_TX_WB_DDONE;
+
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			val |= MTK_MUTLI_CNT | MTK_RESV_BUF |
+			       MTK_WCOMP_EN | MTK_DMAD_WR_WDONE |
+			       MTK_CHK_DDONE_EN;
+		else
+			val |= MTK_RX_BT_32DWORDS;
+		mtk_w32(eth, val, MTK_QDMA_GLO_CFG);
 
 		mtk_w32(eth,
 			MTK_RX_DMA_EN | rx_2b_offset |
@@ -2328,7 +2438,7 @@ static int mtk_open(struct net_device *dev)
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
-		mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
+		mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
 		refcount_set(&eth->dma_refcnt, 1);
 	}
 	else
@@ -2380,7 +2490,7 @@ static int mtk_stop(struct net_device *dev)
 	mtk_gdm_config(eth, MTK_GDMA_DROP_ALL);
 
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
-	mtk_rx_irq_disable(eth, MTK_RX_DONE_INT);
+	mtk_rx_irq_disable(eth, eth->soc->txrx.rx_irq_done_mask);
 	napi_disable(&eth->tx_napi);
 	napi_disable(&eth->rx_napi);
 
@@ -2517,7 +2627,7 @@ static int mtk_hw_init(struct mtk_eth *eth)
 
 	if (eth->ethsys)
 		regmap_update_bits(eth->ethsys, ETHSYS_DMA_AG_MAP, dma_mask,
-				   of_dma_is_coherent(eth->dma_dev->of_node) * dma_mask);
+			of_dma_is_coherent(eth->dma_dev->of_node) * dma_mask);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
 		ret = device_reset(eth->dev);
@@ -2537,9 +2647,25 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	/* Non-MT7628 handling... */
-	ethsys_reset(eth, RSTCTRL_FE);
-	ethsys_reset(eth, RSTCTRL_PPE);
+	val = RSTCTRL_FE | RSTCTRL_PPE;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
+
+		val |= RSTCTRL_ETH;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+			val |= RSTCTRL_PPE1;
+	}
+
+	ethsys_reset(eth, val);
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
+			     0x3ffffff);
+
+		/* Set FE to PDMAv2 if necessary */
+		val = mtk_r32(eth, MTK_FE_GLO_MISC);
+		mtk_w32(eth,  val | BIT(4), MTK_FE_GLO_MISC);
+	}
 
 	if (eth->pctl) {
 		/* Set GE2 driving and slew rate */
@@ -2578,11 +2704,47 @@ static int mtk_hw_init(struct mtk_eth *eth)
 
 	/* FE int grouping */
 	mtk_w32(eth, MTK_TX_DONE_INT, MTK_PDMA_INT_GRP1);
-	mtk_w32(eth, MTK_RX_DONE_INT, MTK_PDMA_INT_GRP2);
+	mtk_w32(eth, eth->soc->txrx.rx_irq_done_mask, MTK_PDMA_INT_GRP2);
 	mtk_w32(eth, MTK_TX_DONE_INT, MTK_QDMA_INT_GRP1);
-	mtk_w32(eth, MTK_RX_DONE_INT, MTK_QDMA_INT_GRP2);
+	mtk_w32(eth, eth->soc->txrx.rx_irq_done_mask, MTK_QDMA_INT_GRP2);
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		/* PSE should not drop port8 and port9 packets */
+		mtk_w32(eth, 0x00000300, PSE_DROP_CFG);
+
+		/* PSE Free Queue Flow Control  */
+		mtk_w32(eth, 0x01fa01f4, PSE_FQFC_CFG2);
+
+		/* PSE config input queue threshold */
+		mtk_w32(eth, 0x001a000e, PSE_IQ_REV(1));
+		mtk_w32(eth, 0x01ff001a, PSE_IQ_REV(2));
+		mtk_w32(eth, 0x000e01ff, PSE_IQ_REV(3));
+		mtk_w32(eth, 0x000e000e, PSE_IQ_REV(4));
+		mtk_w32(eth, 0x000e000e, PSE_IQ_REV(5));
+		mtk_w32(eth, 0x000e000e, PSE_IQ_REV(6));
+		mtk_w32(eth, 0x000e000e, PSE_IQ_REV(7));
+		mtk_w32(eth, 0x000e000e, PSE_IQ_REV(8));
+
+		/* PSE config output queue threshold */
+		mtk_w32(eth, 0x000f000a, PSE_OQ_TH(1));
+		mtk_w32(eth, 0x001a000f, PSE_OQ_TH(2));
+		mtk_w32(eth, 0x000f001a, PSE_OQ_TH(3));
+		mtk_w32(eth, 0x01ff000f, PSE_OQ_TH(4));
+		mtk_w32(eth, 0x000f000f, PSE_OQ_TH(5));
+		mtk_w32(eth, 0x0006000f, PSE_OQ_TH(6));
+		mtk_w32(eth, 0x00060006, PSE_OQ_TH(7));
+		mtk_w32(eth, 0x00060006, PSE_OQ_TH(8));
+
+		/* GDM and CDM Threshold */
+		mtk_w32(eth, 0x00000004, MTK_GDM2_THRES);
+		mtk_w32(eth, 0x00000004, MTK_CDMW0_THRES);
+		mtk_w32(eth, 0x00000004, MTK_CDMW1_THRES);
+		mtk_w32(eth, 0x00000004, MTK_CDME0_THRES);
+		mtk_w32(eth, 0x00000004, MTK_CDME1_THRES);
+		mtk_w32(eth, 0x00000004, MTK_CDMM_THRES);
+	}
+
 	return 0;
 
 err_disable_pm:
@@ -3154,12 +3316,8 @@ static int mtk_probe(struct platform_device *pdev)
 		eth->tx_int_status_reg = MTK_PDMA_INT_STATUS;
 	}
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
-		eth->rx_dma_l4_valid = RX_DMA_L4_VALID_PDMA;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 		eth->ip_align = NET_IP_ALIGN;
-	} else {
-		eth->rx_dma_l4_valid = RX_DMA_L4_VALID;
-	}
 
 	spin_lock_init(&eth->page_lock);
 	spin_lock_init(&eth->tx_irq_lock);
@@ -3395,6 +3553,10 @@ static const struct mtk_soc_data mt2701_data = {
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
+		.rx_irq_done_mask = MTK_RX_DONE_INT,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
@@ -3408,6 +3570,10 @@ static const struct mtk_soc_data mt7621_data = {
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
+		.rx_irq_done_mask = MTK_RX_DONE_INT,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
@@ -3422,6 +3588,10 @@ static const struct mtk_soc_data mt7622_data = {
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
+		.rx_irq_done_mask = MTK_RX_DONE_INT,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
@@ -3435,6 +3605,10 @@ static const struct mtk_soc_data mt7623_data = {
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
+		.rx_irq_done_mask = MTK_RX_DONE_INT,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
@@ -3448,6 +3622,10 @@ static const struct mtk_soc_data mt7629_data = {
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
+		.rx_irq_done_mask = MTK_RX_DONE_INT,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
@@ -3460,6 +3638,10 @@ static const struct mtk_soc_data rt5350_data = {
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
+		.rx_irq_done_mask = MTK_RX_DONE_INT,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID_PDMA,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 2b98f0812655..654ad3b00154 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -35,6 +35,7 @@ enum mtk_reg_base {
 #define MTK_MAX_RX_LENGTH	1536
 #define MTK_MAX_RX_LENGTH_2K	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
+#define MTK_TX_DMA_BUF_LEN_V2	0xffff
 #define MTK_DMA_SIZE		512
 #define MTK_MAC_COUNT		2
 #define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
@@ -92,6 +93,10 @@ enum mtk_reg_base {
 #define MTK_CDMQ_IG_CTRL	0x1400
 #define MTK_CDMQ_STAG_EN	BIT(0)
 
+/* CDMP Ingress Control Register */
+#define MTK_CDMP_IG_CTRL	0x400
+#define MTK_CDMP_STAG_EN	BIT(0)
+
 /* CDMP Exgress Control Register */
 #define MTK_CDMP_EG_CTRL	0x404
 
@@ -111,6 +116,28 @@ enum mtk_reg_base {
 /* Unicast Filter MAC Address Register - High */
 #define MTK_GDMA_MAC_ADRH(x)	(0x50C + (x * 0x1000))
 
+/* FE global misc reg*/
+#define MTK_FE_GLO_MISC         0x124
+
+/* PSE Free Queue Flow Control  */
+#define PSE_FQFC_CFG1		0x100
+#define PSE_FQFC_CFG2		0x104
+#define PSE_DROP_CFG		0x108
+
+/* PSE Input Queue Reservation Register*/
+#define PSE_IQ_REV(x)		(0x140 + (((x) - 1) << 2))
+
+/* PSE Output Queue Threshold Register*/
+#define PSE_OQ_TH(x)		(0x160 + (((x) - 1) << 2))
+
+/* GDM and CDM Threshold */
+#define MTK_GDM2_THRES		0x1530
+#define MTK_CDMW0_THRES		0x164c
+#define MTK_CDMW1_THRES		0x1650
+#define MTK_CDME0_THRES		0x1654
+#define MTK_CDME1_THRES		0x1658
+#define MTK_CDMM_THRES		0x165c
+
 /* PDMA RX Base Pointer Register */
 #define MTK_PRX_BASE_PTR0	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x100)
 #define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10))
@@ -131,9 +158,12 @@ enum mtk_reg_base {
 #define MTK_PDMA_LRO_CTRL_DW0		(eth->soc->reg_map[MTK_PDMA_LRO_CTRL])
 #define MTK_LRO_EN			BIT(0)
 #define MTK_L3_CKS_UPD_EN		BIT(7)
+#define MTK_L3_CKS_UPD_EN_V2		BIT(19)
 #define MTK_LRO_ALT_PKT_CNT_MODE	BIT(21)
 #define MTK_LRO_RING_RELINQUISH_REQ	(0x7 << 26)
+#define MTK_LRO_RING_RELINQUISH_REQ_V2	(0xf << 24)
 #define MTK_LRO_RING_RELINQUISH_DONE	(0x7 << 29)
+#define MTK_LRO_RING_RELINQUISH_DONE_V2	(0xf << 28)
 
 #define MTK_PDMA_LRO_CTRL_DW1	(eth->soc->reg_map[MTK_PDMA_LRO_CTRL] + 0x04)
 #define MTK_PDMA_LRO_CTRL_DW2	(eth->soc->reg_map[MTK_PDMA_LRO_CTRL] + 0x08)
@@ -158,6 +188,7 @@ enum mtk_reg_base {
 
 /* PDMA Global Configuration Register */
 #define MTK_PDMA_GLO_CFG	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x204)
+#define MTK_RX_DMA_LRO_EN	BIT(8)
 #define MTK_MULTI_EN		BIT(10)
 #define MTK_PDMA_SIZE_8DWORDS	(1 << 4)
 
@@ -261,6 +292,13 @@ enum mtk_reg_base {
 #define MTK_TX_DMA_EN		BIT(0)
 #define MTK_DMA_BUSY_TIMEOUT_US	1000000
 
+/* QDMA V2 Global Configuration Register */
+#define MTK_CHK_DDONE_EN	BIT(28)
+#define MTK_DMAD_WR_WDONE	BIT(26)
+#define MTK_WCOMP_EN		BIT(24)
+#define MTK_RESV_BUF		(0x40 << 16)
+#define MTK_MUTLI_CNT		(0x4 << 12)
+
 /* QDMA Reset Index Register */
 #define MTK_QDMA_RST_IDX	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x208)
 
@@ -288,6 +326,8 @@ enum mtk_reg_base {
 #define MTK_RX_DONE_INT		MTK_RX_DONE_DLY
 #define MTK_TX_DONE_INT		MTK_TX_DONE_DLY
 
+#define MTK_RX_DONE_INT_V2	BIT(14)
+
 /* QDMA Interrupt grouping registers */
 #define MTK_QDMA_INT_GRP1	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x220)
 #define MTK_QDMA_INT_GRP2	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x224)
@@ -340,6 +380,25 @@ enum mtk_reg_base {
 #define MTK_GDM1_TX_GPCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x38)
 #define MTK_STAT_OFFSET		0x40
 
+/* QDMA TX NUM */
+#define MTK_QDMA_TX_NUM		16
+#define MTK_QDMA_TX_MASK	(MTK_QDMA_TX_NUM - 1)
+#define QID_BITS_V2(x)		(((x) & 0x3f) << 16)
+#define MTK_QDMA_GMAC2_QID	8
+
+#define MTK_TX_DMA_BUF_SHIFT	8
+
+/* QDMA V2 descriptor txd6 */
+#define TX_DMA_INS_VLAN_V2	BIT(16)
+/* QDMA V2 descriptor txd5 */
+#define TX_DMA_CHKSUM_V2	(0x7 << 28)
+#define TX_DMA_TSO_V2		BIT(31)
+
+/* QDMA V2 descriptor txd4 */
+#define TX_DMA_FPORT_SHIFT_V2	8
+#define TX_DMA_FPORT_MASK_V2	0xf
+#define TX_DMA_SWC_V2		BIT(30)
+
 #define MTK_WDMA0_BASE		0x2800
 #define MTK_WDMA1_BASE		0x2c00
 
@@ -353,10 +412,9 @@ enum mtk_reg_base {
 /* QDMA descriptor txd3 */
 #define TX_DMA_OWNER_CPU	BIT(31)
 #define TX_DMA_LS0		BIT(30)
-#define TX_DMA_PLEN0(_x)	(((_x) & MTK_TX_DMA_BUF_LEN) << 16)
-#define TX_DMA_PLEN1(_x)	((_x) & MTK_TX_DMA_BUF_LEN)
+#define TX_DMA_PLEN0(_x)	(((_x) & eth->soc->txrx.dma_max_len) << eth->soc->txrx.dma_len_offset)
+#define TX_DMA_PLEN1(_x)	((_x) & eth->soc->txrx.dma_max_len)
 #define TX_DMA_SWC		BIT(14)
-#define TX_DMA_SDL(_x)		(((_x) & 0x3fff) << 16)
 
 /* PDMA on MT7628 */
 #define TX_DMA_DONE		BIT(31)
@@ -366,12 +424,14 @@ enum mtk_reg_base {
 /* QDMA descriptor rxd2 */
 #define RX_DMA_DONE		BIT(31)
 #define RX_DMA_LSO		BIT(30)
-#define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
-#define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
+#define RX_DMA_PREP_PLEN0(_x)	(((_x) & eth->soc->txrx.dma_max_len) << eth->soc->txrx.dma_len_offset)
+#define RX_DMA_GET_PLEN0(_x)	(((_x) >> eth->soc->txrx.dma_len_offset) & eth->soc->txrx.dma_max_len)
 #define RX_DMA_VTAG		BIT(15)
 
 /* QDMA descriptor rxd3 */
-#define RX_DMA_VID(_x)		((_x) & 0xfff)
+#define RX_DMA_VID(x)		((x) & VLAN_VID_MASK)
+#define RX_DMA_TCI(x)		((x) & (VLAN_PRIO_MASK | VLAN_VID_MASK))
+#define RX_DMA_VPID(x)		(((x) >> 16) & 0xffff)
 
 /* QDMA descriptor rxd4 */
 #define MTK_RXD4_FOE_ENTRY	GENMASK(13, 0)
@@ -382,10 +442,15 @@ enum mtk_reg_base {
 /* QDMA descriptor rxd4 */
 #define RX_DMA_L4_VALID		BIT(24)
 #define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
-#define RX_DMA_FPORT_SHIFT	19
-#define RX_DMA_FPORT_MASK	0x7
 #define RX_DMA_SPECIAL_TAG	BIT(22)
 
+#define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0xf)
+#define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0x7)
+
+/* PDMA V2 descriptor rxd3 */
+#define RX_DMA_VTAG_V2		BIT(0)
+#define RX_DMA_L4_VALID_V2	BIT(2)
+
 /* PHY Indirect Access Control registers */
 #define MTK_PHY_IAC		0x10004
 #define PHY_IAC_ACCESS		BIT(31)
@@ -508,6 +573,16 @@ enum mtk_reg_base {
 #define ETHSYS_TRGMII_MT7621_APLL	BIT(6)
 #define ETHSYS_TRGMII_MT7621_DDR_PLL	BIT(5)
 
+/* ethernet reset control register */
+#define ETHSYS_RSTCTRL			0x34
+#define RSTCTRL_FE			BIT(6)
+#define RSTCTRL_PPE			BIT(31)
+#define RSTCTRL_PPE1			BIT(30)
+#define RSTCTRL_ETH			BIT(23)
+
+/* ethernet reset check idle register */
+#define ETHSYS_FE_RST_CHK_IDLE_EN	0x28
+
 /* ethernet reset control register */
 #define ETHSYS_RSTCTRL		0x34
 #define RSTCTRL_FE		BIT(6)
@@ -592,6 +667,17 @@ struct mtk_rx_dma {
 	unsigned int rxd4;
 } __packed __aligned(4);
 
+struct mtk_rx_dma_v2 {
+	unsigned int rxd1;
+	unsigned int rxd2;
+	unsigned int rxd3;
+	unsigned int rxd4;
+	unsigned int rxd5;
+	unsigned int rxd6;
+	unsigned int rxd7;
+	unsigned int rxd8;
+} __packed __aligned(4);
+
 struct mtk_tx_dma {
 	unsigned int txd1;
 	unsigned int txd2;
@@ -599,6 +685,17 @@ struct mtk_tx_dma {
 	unsigned int txd4;
 } __packed __aligned(4);
 
+struct mtk_tx_dma_v2 {
+	unsigned int txd1;
+	unsigned int txd2;
+	unsigned int txd3;
+	unsigned int txd4;
+	unsigned int txd5;
+	unsigned int txd6;
+	unsigned int txd7;
+	unsigned int txd8;
+} __packed __aligned(4);
+
 struct mtk_eth;
 struct mtk_mac;
 
@@ -785,7 +882,9 @@ enum mkt_eth_capabilities {
 	MTK_SHARED_INT_BIT,
 	MTK_TRGMII_MT7621_CLK_BIT,
 	MTK_QDMA_BIT,
+	MTK_NETSYS_V2_BIT,
 	MTK_SOC_MT7628_BIT,
+	MTK_RSTCTRL_PPE1_BIT,
 
 	/* MUX BITS*/
 	MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT,
@@ -817,7 +916,9 @@ enum mkt_eth_capabilities {
 #define MTK_SHARED_INT		BIT(MTK_SHARED_INT_BIT)
 #define MTK_TRGMII_MT7621_CLK	BIT(MTK_TRGMII_MT7621_CLK_BIT)
 #define MTK_QDMA		BIT(MTK_QDMA_BIT)
+#define MTK_NETSYS_V2		BIT(MTK_NETSYS_V2_BIT)
 #define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
+#define MTK_RSTCTRL_PPE1	BIT(MTK_RSTCTRL_PPE1_BIT)
 
 #define MTK_ETH_MUX_GDM1_TO_GMAC1_ESW		\
 	BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT)
@@ -894,6 +995,7 @@ struct mtk_tx_dma_desc_info {
 	dma_addr_t addr;
 	u32 size;
 	u16 vlan_tci;
+	u16 qid;
 	u8 gso:1;
 	u8 csum:1;
 	u8 vlan:1;
@@ -913,7 +1015,11 @@ struct mtk_tx_dma_desc_info {
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
  * @txd_size			TX DMA descriptor size.
- * @rxd_size			RX DMA descriptor size.
+ * @rxd_size			Rx DMA descriptor size.
+ * @rx_irq_done_mask		Rx irq done register mask.
+ * @rx_dma_l4_valid		Rx DMA valid register mask.
+ * @dma_max_len			Max DMA tx/rx buffer length.
+ * @dma_len_offset		Tx/Rx DMA length field offset.
  */
 struct mtk_soc_data {
 	const u32	*reg_map;
@@ -926,6 +1032,10 @@ struct mtk_soc_data {
 	struct {
 		u32	txd_size;
 		u32	rxd_size;
+		u32	rx_irq_done_mask;
+		u32	rx_dma_l4_valid;
+		u32	dma_max_len;
+		u32	dma_len_offset;
 	} txrx;
 };
 
@@ -1046,7 +1156,6 @@ struct mtk_eth {
 
 	u32				tx_int_mask_reg;
 	u32				tx_int_status_reg;
-	u32				rx_dma_l4_valid;
 	int				ip_align;
 
 	struct mtk_ppe			*ppe;
-- 
2.35.3

