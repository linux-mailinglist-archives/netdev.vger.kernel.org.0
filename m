Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0126A62303B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiKIQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiKIQe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:34:56 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE821AD85;
        Wed,  9 Nov 2022 08:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EhDIwEk9AdqphzChfLs32KwFNnnA0w6JRhWZG/P8w0E=; b=LRTyZVdDDVrbl3Gm2rRffU+hfh
        4Mmj8Rd2w/OjcCIQFqbXa1Rj52jT3/Z6zQx8TyfCP8AMBx0B1vIFt0H+76aix9RksvdFEWqm7pIYa
        tInDylsIKBTEY7u+euUDj8iNR2ZfH+h8SuEvL0HoigyBsTlkv9cNcVge1kJpXzr2+jYE=;
Received: from p200300daa72ee100054f3c61b16ef6e7.dip0.t-ipconnect.de ([2003:da:a72e:e100:54f:3c61:b16e:f6e7] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oso25-000l4N-Mt; Wed, 09 Nov 2022 17:34:33 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 04/12] net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues
Date:   Wed,  9 Nov 2022 17:34:18 +0100
Message-Id: <20221109163426.76164-5-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending traffic to multiple ports with different link speeds, queued
packets to one port can drown out tx to other ports.
In order to better handle transmission to multiple ports, use the hardware
shaper feature to implement weighted fair queueing between ports.
Weight and maximum rate are automatically adjusted based on the link speed
of the port.
The first 3 queues are unrestricted and reserved for non-DSA direct tx on
GMAC ports. The following queues are automatically assigned by the MTK DSA
tag driver based on the target port number.
The PPE offload code configures the queues for offloaded traffic in the same
way.
This feature is only supported on devices supporting QDMA. All queues still
share the same DMA ring and descriptor pool.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 281 ++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  26 +-
 2 files changed, 258 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9f607c80f49c..92bdd69eed2e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -54,6 +54,7 @@ static const struct mtk_reg_map mtk_reg_map = {
 	},
 	.qdma = {
 		.qtx_cfg	= 0x1800,
+		.qtx_sch	= 0x1804,
 		.rx_ptr		= 0x1900,
 		.rx_cnt_cfg	= 0x1904,
 		.qcrx_ptr	= 0x1908,
@@ -61,6 +62,7 @@ static const struct mtk_reg_map mtk_reg_map = {
 		.rst_idx	= 0x1a08,
 		.delay_irq	= 0x1a0c,
 		.fc_th		= 0x1a10,
+		.tx_sch_rate	= 0x1a14,
 		.int_grp	= 0x1a20,
 		.hred		= 0x1a44,
 		.ctx_ptr	= 0x1b00,
@@ -113,6 +115,7 @@ static const struct mtk_reg_map mt7986_reg_map = {
 	},
 	.qdma = {
 		.qtx_cfg	= 0x4400,
+		.qtx_sch	= 0x4404,
 		.rx_ptr		= 0x4500,
 		.rx_cnt_cfg	= 0x4504,
 		.qcrx_ptr	= 0x4508,
@@ -130,6 +133,7 @@ static const struct mtk_reg_map mt7986_reg_map = {
 		.fq_tail	= 0x4724,
 		.fq_count	= 0x4728,
 		.fq_blen	= 0x472c,
+		.tx_sch_rate	= 0x4798,
 	},
 	.gdm1_cnt		= 0x1c00,
 	.gdma_to_ppe		= 0x3333,
@@ -613,6 +617,75 @@ static void mtk_mac_link_down(struct phylink_config *config, unsigned int mode,
 	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
 }
 
+static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
+				int speed)
+{
+	const struct mtk_soc_data *soc = eth->soc;
+	u32 ofs, val;
+
+	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA))
+		return;
+
+	val = MTK_QTX_SCH_MIN_RATE_EN |
+	      /* minimum: 10 Mbps */
+	      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_MAN, 1) |
+	      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_EXP, 4) |
+	      MTK_QTX_SCH_LEAKY_BUCKET_SIZE;
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		val |= MTK_QTX_SCH_LEAKY_BUCKET_EN;
+
+	if (IS_ENABLED(CONFIG_SOC_MT7621)) {
+		switch (speed) {
+		case SPEED_10:
+			val |= MTK_QTX_SCH_MAX_RATE_EN |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 103) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 2) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
+			break;
+		case SPEED_100:
+			val |= MTK_QTX_SCH_MAX_RATE_EN |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 103) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 3);
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
+			break;
+		case SPEED_1000:
+			val |= MTK_QTX_SCH_MAX_RATE_EN |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 105) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 4) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 10);
+			break;
+		default:
+			break;
+		}
+	} else {
+		switch (speed) {
+		case SPEED_10:
+			val |= MTK_QTX_SCH_MAX_RATE_EN |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 1) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 4) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
+			break;
+		case SPEED_100:
+			val |= MTK_QTX_SCH_MAX_RATE_EN |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 1) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5);
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
+			break;
+		case SPEED_1000:
+			val |= MTK_QTX_SCH_MAX_RATE_EN |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 10) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5) |
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 10);
+			break;
+		default:
+			break;
+		}
+	}
+
+	ofs = MTK_QTX_OFFSET * idx;
+	mtk_w32(eth, val, soc->reg_map->qdma.qtx_sch + ofs);
+}
+
 static void mtk_mac_link_up(struct phylink_config *config,
 			    struct phy_device *phy,
 			    unsigned int mode, phy_interface_t interface,
@@ -638,6 +711,8 @@ static void mtk_mac_link_up(struct phylink_config *config,
 		break;
 	}
 
+	mtk_set_queue_speed(mac->hw, mac->id, speed);
+
 	/* Configure duplex */
 	if (duplex == DUPLEX_FULL)
 		mcr |= MAC_MCR_FORCE_DPX;
@@ -1099,7 +1174,8 @@ static void mtk_tx_set_dma_desc_v1(struct net_device *dev, void *txd,
 
 	WRITE_ONCE(desc->txd1, info->addr);
 
-	data = TX_DMA_SWC | TX_DMA_PLEN0(info->size);
+	data = TX_DMA_SWC | TX_DMA_PLEN0(info->size) |
+	       FIELD_PREP(TX_DMA_PQID, info->qid);
 	if (info->last)
 		data |= TX_DMA_LS0;
 	WRITE_ONCE(desc->txd3, data);
@@ -1133,9 +1209,6 @@ static void mtk_tx_set_dma_desc_v2(struct net_device *dev, void *txd,
 		data |= TX_DMA_LS0;
 	WRITE_ONCE(desc->txd3, data);
 
-	if (!info->qid && mac->id)
-		info->qid = MTK_QDMA_GMAC2_QID;
-
 	data = (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
 	data |= TX_DMA_SWC_V2 | QID_BITS_V2(info->qid);
 	WRITE_ONCE(desc->txd4, data);
@@ -1179,11 +1252,12 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		.gso = gso,
 		.csum = skb->ip_summed == CHECKSUM_PARTIAL,
 		.vlan = skb_vlan_tag_present(skb),
-		.qid = skb->mark & MTK_QDMA_TX_MASK,
+		.qid = skb_get_queue_mapping(skb),
 		.vlan_tci = skb_vlan_tag_get(skb),
 		.first = true,
 		.last = !skb_is_nonlinear(skb),
 	};
+	struct netdev_queue *txq;
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 	const struct mtk_soc_data *soc = eth->soc;
@@ -1191,8 +1265,10 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	struct mtk_tx_dma *itxd_pdma, *txd_pdma;
 	struct mtk_tx_buf *itx_buf, *tx_buf;
 	int i, n_desc = 1;
+	int queue = skb_get_queue_mapping(skb);
 	int k = 0;
 
+	txq = netdev_get_tx_queue(dev, queue);
 	itxd = ring->next_free;
 	itxd_pdma = qdma_to_pdma(ring, itxd);
 	if (itxd == ring->last_free)
@@ -1241,7 +1317,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 			memset(&txd_info, 0, sizeof(struct mtk_tx_dma_desc_info));
 			txd_info.size = min_t(unsigned int, frag_size,
 					      soc->txrx.dma_max_len);
-			txd_info.qid = skb->mark & MTK_QDMA_TX_MASK;
+			txd_info.qid = queue;
 			txd_info.last = i == skb_shinfo(skb)->nr_frags - 1 &&
 					!(frag_size - txd_info.size);
 			txd_info.addr = skb_frag_dma_map(eth->dma_dev, frag,
@@ -1280,7 +1356,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 			txd_pdma->txd2 |= TX_DMA_LS1;
 	}
 
-	netdev_sent_queue(dev, skb->len);
+	netdev_tx_sent_queue(txq, skb->len);
 	skb_tx_timestamp(skb);
 
 	ring->next_free = mtk_qdma_phys_to_virt(ring, txd->txd2);
@@ -1292,8 +1368,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	wmb();
 
 	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
-		if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)) ||
-		    !netdev_xmit_more())
+		if (netif_xmit_stopped(txq) || !netdev_xmit_more())
 			mtk_w32(eth, txd->txd2, soc->reg_map->qdma.ctx_ptr);
 	} else {
 		int next_idx;
@@ -1362,7 +1437,7 @@ static void mtk_wake_queue(struct mtk_eth *eth)
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
 		if (!eth->netdev[i])
 			continue;
-		netif_wake_queue(eth->netdev[i]);
+		netif_tx_wake_all_queues(eth->netdev[i]);
 	}
 }
 
@@ -1386,7 +1461,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_num = mtk_cal_txd_req(eth, skb);
 	if (unlikely(atomic_read(&ring->free_count) <= tx_num)) {
-		netif_stop_queue(dev);
+		netif_tx_stop_all_queues(dev);
 		netif_err(eth, tx_queued, dev,
 			  "Tx Ring full when queue awake!\n");
 		spin_unlock(&eth->page_lock);
@@ -1412,7 +1487,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 
 	if (unlikely(atomic_read(&ring->free_count) <= ring->thresh))
-		netif_stop_queue(dev);
+		netif_tx_stop_all_queues(dev);
 
 	spin_unlock(&eth->page_lock);
 
@@ -1579,10 +1654,12 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
 	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
+	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_tx_dma_desc_info txd_info = {
 		.size	= xdpf->len,
 		.first	= true,
 		.last	= !xdp_frame_has_frags(xdpf),
+		.qid	= mac->id,
 	};
 	int err, index = 0, n_desc = 1, nr_frags;
 	struct mtk_tx_buf *htx_buf, *tx_buf;
@@ -1632,6 +1709,7 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 		memset(&txd_info, 0, sizeof(struct mtk_tx_dma_desc_info));
 		txd_info.size = skb_frag_size(&sinfo->frags[index]);
 		txd_info.last = index + 1 == nr_frags;
+		txd_info.qid = mac->id;
 		data = skb_frag_address(&sinfo->frags[index]);
 
 		index++;
@@ -1986,8 +2064,46 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 	return done;
 }
 
+struct mtk_poll_state {
+    struct netdev_queue *txq;
+    unsigned int total;
+    unsigned int done;
+    unsigned int bytes;
+};
+
+static void
+mtk_poll_tx_done(struct mtk_eth *eth, struct mtk_poll_state *state, u8 mac,
+		 struct sk_buff *skb)
+{
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	unsigned int bytes = skb->len;
+
+	state->total++;
+	eth->tx_packets++;
+	eth->tx_bytes += bytes;
+
+	dev = eth->netdev[mac];
+	if (!dev)
+		return;
+
+	txq = netdev_get_tx_queue(dev, skb_get_queue_mapping(skb));
+	if (state->txq == txq) {
+		state->done++;
+		state->bytes += bytes;
+		return;
+	}
+
+	if (state->txq)
+		netdev_tx_completed_queue(state->txq, state->done, state->bytes);
+
+	state->txq = txq;
+	state->done = 1;
+	state->bytes = bytes;
+}
+
 static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
-			    unsigned int *done, unsigned int *bytes)
+			    struct mtk_poll_state *state)
 {
 	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
@@ -2019,12 +2135,9 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 			break;
 
 		if (tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
-			if (tx_buf->type == MTK_TYPE_SKB) {
-				struct sk_buff *skb = tx_buf->data;
+			if (tx_buf->type == MTK_TYPE_SKB)
+				mtk_poll_tx_done(eth, state, mac, tx_buf->data);
 
-				bytes[mac] += skb->len;
-				done[mac]++;
-			}
 			budget--;
 		}
 		mtk_tx_unmap(eth, tx_buf, &bq, true);
@@ -2043,7 +2156,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 }
 
 static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
-			    unsigned int *done, unsigned int *bytes)
+			    struct mtk_poll_state *state)
 {
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct mtk_tx_buf *tx_buf;
@@ -2061,12 +2174,8 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 			break;
 
 		if (tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
-			if (tx_buf->type == MTK_TYPE_SKB) {
-				struct sk_buff *skb = tx_buf->data;
-
-				bytes[0] += skb->len;
-				done[0]++;
-			}
+			if (tx_buf->type == MTK_TYPE_SKB)
+				mtk_poll_tx_done(eth, state, 0, tx_buf->data);
 			budget--;
 		}
 		mtk_tx_unmap(eth, tx_buf, &bq, true);
@@ -2088,26 +2197,15 @@ static int mtk_poll_tx(struct mtk_eth *eth, int budget)
 {
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct dim_sample dim_sample = {};
-	unsigned int done[MTK_MAX_DEVS];
-	unsigned int bytes[MTK_MAX_DEVS];
-	int total = 0, i;
-
-	memset(done, 0, sizeof(done));
-	memset(bytes, 0, sizeof(bytes));
+	struct mtk_poll_state state = {};
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
-		budget = mtk_poll_tx_qdma(eth, budget, done, bytes);
+		budget = mtk_poll_tx_qdma(eth, budget, &state);
 	else
-		budget = mtk_poll_tx_pdma(eth, budget, done, bytes);
+		budget = mtk_poll_tx_pdma(eth, budget, &state);
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->netdev[i] || !done[i])
-			continue;
-		netdev_completed_queue(eth->netdev[i], done[i], bytes[i]);
-		total += done[i];
-		eth->tx_packets += done[i];
-		eth->tx_bytes += bytes[i];
-	}
+	if (state.txq)
+		netdev_tx_completed_queue(state.txq, state.done, state.bytes);
 
 	dim_update_sample(eth->tx_events, eth->tx_packets, eth->tx_bytes,
 			  &dim_sample);
@@ -2117,7 +2215,7 @@ static int mtk_poll_tx(struct mtk_eth *eth, int budget)
 	    (atomic_read(&ring->free_count) > ring->thresh))
 		mtk_wake_queue(eth);
 
-	return total;
+	return state.total;
 }
 
 static void mtk_handle_status_irq(struct mtk_eth *eth)
@@ -2203,6 +2301,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	int i, sz = soc->txrx.txd_size;
 	struct mtk_tx_dma_v2 *txd;
 	int ring_size;
+	u32 ofs, val;
 
 	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA))
 		ring_size = MTK_QDMA_RING_SIZE;
@@ -2270,8 +2369,25 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 			ring->phys + ((ring_size - 1) * sz),
 			soc->reg_map->qdma.crx_ptr);
 		mtk_w32(eth, ring->last_free_ptr, soc->reg_map->qdma.drx_ptr);
-		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
-			soc->reg_map->qdma.qtx_cfg);
+
+		for (i = 0, ofs = 0; i < MTK_QDMA_NUM_QUEUES; i++) {
+			val = (QDMA_RES_THRES << 8) | QDMA_RES_THRES;
+			mtk_w32(eth, val, soc->reg_map->qdma.qtx_cfg + ofs);
+
+			val = MTK_QTX_SCH_MIN_RATE_EN |
+			      /* minimum: 10 Mbps */
+			      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_MAN, 1) |
+			      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_EXP, 4) |
+			      MTK_QTX_SCH_LEAKY_BUCKET_SIZE;
+			if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+				val |= MTK_QTX_SCH_LEAKY_BUCKET_EN;
+			mtk_w32(eth, val, soc->reg_map->qdma.qtx_sch + ofs);
+			ofs += MTK_QTX_OFFSET;
+		}
+		val = MTK_QDMA_TX_SCH_MAX_WFQ | (MTK_QDMA_TX_SCH_MAX_WFQ << 16);
+		mtk_w32(eth, val, soc->reg_map->qdma.tx_sch_rate);
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			mtk_w32(eth, val, soc->reg_map->qdma.tx_sch_rate + 4);
 	} else {
 		mtk_w32(eth, ring->phys_pdma, MT7628_TX_BASE_PTR0);
 		mtk_w32(eth, ring_size, MT7628_TX_MAX_CNT0);
@@ -2936,7 +3052,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
 			val |= MTK_MUTLI_CNT | MTK_RESV_BUF |
 			       MTK_WCOMP_EN | MTK_DMAD_WR_WDONE |
-			       MTK_CHK_DDONE_EN;
+			       MTK_CHK_DDONE_EN | MTK_LEAKY_BUCKET_EN;
 		else
 			val |= MTK_RX_BT_32DWORDS;
 		mtk_w32(eth, val, reg_map->qdma.glo_cfg);
@@ -2982,6 +3098,45 @@ static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
 	mtk_w32(eth, 0, MTK_RST_GL);
 }
 
+static int mtk_device_event(struct notifier_block *n, unsigned long event, void *ptr)
+{
+	struct mtk_mac *mac = container_of(n, struct mtk_mac, device_notifier);
+	struct mtk_eth *eth = mac->hw;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct ethtool_link_ksettings s;
+	struct net_device *ldev;
+	struct list_head *iter;
+	struct dsa_port *dp;
+
+	if (event != NETDEV_CHANGE)
+		return NOTIFY_DONE;
+
+	netdev_for_each_lower_dev(dev, ldev, iter) {
+		if (netdev_priv(ldev) == mac)
+			goto found;
+	}
+
+	return NOTIFY_DONE;
+
+found:
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
+	if (__ethtool_get_link_ksettings(dev, &s))
+		return NOTIFY_DONE;
+
+	if (s.base.speed == 0 || s.base.speed == ((__u32)-1))
+		return NOTIFY_DONE;
+
+	dp = dsa_port_from_netdev(dev);
+	if (dp->index >= MTK_QDMA_NUM_QUEUES)
+		return NOTIFY_DONE;
+
+	mtk_set_queue_speed(eth, dp->index + 3, s.base.speed);
+
+	return NOTIFY_DONE;
+}
+
 static int mtk_open(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -3022,7 +3177,8 @@ static int mtk_open(struct net_device *dev)
 		refcount_inc(&eth->dma_refcnt);
 
 	phylink_start(mac->phylink);
-	netif_start_queue(dev);
+	netif_tx_start_all_queues(dev);
+
 	return 0;
 }
 
@@ -3538,8 +3694,12 @@ static int mtk_unreg_dev(struct mtk_eth *eth)
 	int i;
 
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
+		struct mtk_mac *mac;
 		if (!eth->netdev[i])
 			continue;
+		mac = netdev_priv(eth->netdev[i]);
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+			unregister_netdevice_notifier(&mac->device_notifier);
 		unregister_netdev(eth->netdev[i]);
 	}
 
@@ -3755,6 +3915,23 @@ static int mtk_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
+static u16 mtk_select_queue(struct net_device *dev, struct sk_buff *skb,
+			    struct net_device *sb_dev)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	unsigned int queue = 0;
+
+	if (netdev_uses_dsa(dev))
+		queue = skb_get_queue_mapping(skb) + 3;
+	else
+		queue = mac->id;
+
+	if (queue >= dev->num_tx_queues)
+		queue = 0;
+
+	return queue;
+}
+
 static const struct ethtool_ops mtk_ethtool_ops = {
 	.get_link_ksettings	= mtk_get_link_ksettings,
 	.set_link_ksettings	= mtk_set_link_ksettings,
@@ -3790,6 +3967,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 	.ndo_setup_tc		= mtk_eth_setup_tc,
 	.ndo_bpf		= mtk_xdp,
 	.ndo_xdp_xmit		= mtk_xdp_xmit,
+	.ndo_select_queue	= mtk_select_queue,
 };
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
@@ -3799,6 +3977,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	struct phylink *phylink;
 	struct mtk_mac *mac;
 	int id, err;
+	int txqs = 1;
 
 	if (!_id) {
 		dev_err(eth->dev, "missing mac id\n");
@@ -3816,7 +3995,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		return -EINVAL;
 	}
 
-	eth->netdev[id] = alloc_etherdev(sizeof(*mac));
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		txqs = MTK_QDMA_NUM_QUEUES;
+
+	eth->netdev[id] = alloc_etherdev_mqs(sizeof(*mac), txqs, 1);
 	if (!eth->netdev[id]) {
 		dev_err(eth->dev, "alloc_etherdev failed\n");
 		return -ENOMEM;
@@ -3913,6 +4095,11 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	else
 		eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH_2K - MTK_RX_ETH_HLEN;
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		mac->device_notifier.notifier_call = mtk_device_event;
+		register_netdevice_notifier(&mac->device_notifier);
+	}
+
 	return 0;
 
 free_netdev:
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 637d3c60507e..c6a39a249fb5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -22,6 +22,7 @@
 #include <linux/bpf_trace.h>
 #include "mtk_ppe.h"
 
+#define MTK_QDMA_NUM_QUEUES	16
 #define MTK_QDMA_PAGE_SIZE	2048
 #define MTK_MAX_RX_LENGTH	1536
 #define MTK_MAX_RX_LENGTH_2K	2048
@@ -203,8 +204,26 @@
 #define MTK_RING_MAX_AGG_CNT_H		((MTK_HW_LRO_MAX_AGG_CNT >> 6) & 0x3)
 
 /* QDMA TX Queue Configuration Registers */
+#define MTK_QTX_OFFSET		0x10
 #define QDMA_RES_THRES		4
 
+/* QDMA Tx Queue Scheduler Configuration Registers */
+#define MTK_QTX_SCH_TX_SEL		BIT(31)
+#define MTK_QTX_SCH_TX_SEL_V2		GENMASK(31, 30)
+
+#define MTK_QTX_SCH_LEAKY_BUCKET_EN	BIT(30)
+#define MTK_QTX_SCH_LEAKY_BUCKET_SIZE	GENMASK(29, 28)
+#define MTK_QTX_SCH_MIN_RATE_EN		BIT(27)
+#define MTK_QTX_SCH_MIN_RATE_MAN	GENMASK(26, 20)
+#define MTK_QTX_SCH_MIN_RATE_EXP	GENMASK(19, 16)
+#define MTK_QTX_SCH_MAX_RATE_WEIGHT	GENMASK(15, 12)
+#define MTK_QTX_SCH_MAX_RATE_EN		BIT(11)
+#define MTK_QTX_SCH_MAX_RATE_MAN	GENMASK(10, 4)
+#define MTK_QTX_SCH_MAX_RATE_EXP	GENMASK(3, 0)
+
+/* QDMA TX Scheduler Rate Control Register */
+#define MTK_QDMA_TX_SCH_MAX_WFQ		BIT(15)
+
 /* QDMA Global Configuration Register */
 #define MTK_RX_2B_OFFSET	BIT(31)
 #define MTK_RX_BT_32DWORDS	(3 << 11)
@@ -223,6 +242,7 @@
 #define MTK_WCOMP_EN		BIT(24)
 #define MTK_RESV_BUF		(0x40 << 16)
 #define MTK_MUTLI_CNT		(0x4 << 12)
+#define MTK_LEAKY_BUCKET_EN	BIT(11)
 
 /* QDMA Flow Control Register */
 #define FC_THRES_DROP_MODE	BIT(20)
@@ -251,8 +271,6 @@
 #define MTK_STAT_OFFSET		0x40
 
 /* QDMA TX NUM */
-#define MTK_QDMA_TX_NUM		16
-#define MTK_QDMA_TX_MASK	(MTK_QDMA_TX_NUM - 1)
 #define QID_BITS_V2(x)		(((x) & 0x3f) << 16)
 #define MTK_QDMA_GMAC2_QID	8
 
@@ -282,6 +300,7 @@
 #define TX_DMA_PLEN0(x)		(((x) & eth->soc->txrx.dma_max_len) << eth->soc->txrx.dma_len_offset)
 #define TX_DMA_PLEN1(x)		((x) & eth->soc->txrx.dma_max_len)
 #define TX_DMA_SWC		BIT(14)
+#define TX_DMA_PQID		GENMASK(3, 0)
 
 /* PDMA on MT7628 */
 #define TX_DMA_DONE		BIT(31)
@@ -940,6 +959,7 @@ struct mtk_reg_map {
 	} pdma;
 	struct {
 		u32	qtx_cfg;	/* tx queue configuration */
+		u32	qtx_sch;	/* tx queue scheduler configuration */
 		u32	rx_ptr;		/* rx base pointer */
 		u32	rx_cnt_cfg;	/* rx max count configuration */
 		u32	qcrx_ptr;	/* rx cpu pointer */
@@ -957,6 +977,7 @@ struct mtk_reg_map {
 		u32	fq_tail;	/* fq tail pointer */
 		u32	fq_count;	/* fq free page count */
 		u32	fq_blen;	/* fq free page buffer length */
+		u32	tx_sch_rate;	/* tx scheduler rate control registers */
 	} qdma;
 	u32	gdm1_cnt;
 	u32	gdma_to_ppe;
@@ -1148,6 +1169,7 @@ struct mtk_mac {
 	__be32				hwlro_ip[MTK_MAX_LRO_IP_CNT];
 	int				hwlro_ip_cnt;
 	unsigned int			syscfg0;
+	struct notifier_block		device_notifier;
 };
 
 /* the struct describing the SoC. these are declared in the soc_xyz.c files */
-- 
2.38.1

