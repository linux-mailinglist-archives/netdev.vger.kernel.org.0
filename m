Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E4291280
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfHQSze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:55:34 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53910 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbfHQSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:54:58 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CA141C0E41;
        Sat, 17 Aug 2019 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068097; bh=V+C8SsVKAvdrGa7XpsHcFWBZbSyN9BqVUC7r5TWoAXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=cbv93HUjmvXIPHUSej/ebDXLmBVXPVi3WdEmNr705q+/vJWRmbe7oIH2Ch9Iaue9p
         l+v18wuVc1lu526xXR8Jp5VJvbdTr0FETcf3gFKDoldaHTXhtqDqgUpzxa3iuIDbcH
         bzdXFb23u1t+h5npcuNRj9p6AE0YCwUJOy7WWecrfGteyRcLymjM1b1QdymqMh3JT2
         cPhHWpeCbGZqEpS7Snhbk5Nu8MgpVRd2kKyGVGoN6iaxk6l3up/9mBO0M9+z7XOKvn
         67GN0BGEGYcU8xIJ0KLQczJ746iLXWE3z1u3+b43qbNlQKMhe6DiN0hzJKf4y+p59a
         z+jMng26vOqvw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6C42DA0065;
        Sat, 17 Aug 2019 18:54:55 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 02/12] net: stmmac: Prepare to add Split Header support
Date:   Sat, 17 Aug 2019 20:54:41 +0200
Message-Id: <20fb7dc55cc5ec27eff6b8ea3b2d81da6526b479.1566067802.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to add Split Header support, stmmac_rx() needs to take into
account that packet may be split accross multiple descriptors.

Refactor the logic of this function in order to support this scenario.

Changes from v2:
	- Fixup if condition detection (Jakub)
	- Don't stop NAPI with unfinished packet (Jakub)
	- Use napi_alloc_skb() (Jakub)

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |   6 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 149 +++++++++++++---------
 2 files changed, 95 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 80276587048a..56158e1448ac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -74,6 +74,12 @@ struct stmmac_rx_queue {
 	u32 rx_zeroc_thresh;
 	dma_addr_t dma_rx_phy;
 	u32 rx_tail_addr;
+	unsigned int state_saved;
+	struct {
+		struct sk_buff *skb;
+		unsigned int len;
+		unsigned int error;
+	} state;
 };
 
 struct stmmac_channel {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b2e5f4ecd551..05f0fa7a6f02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3353,9 +3353,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
+	unsigned int count = 0, error = 0, len = 0;
+	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
-	int coe = priv->hw->rx_csum;
-	unsigned int count = 0;
+	struct sk_buff *skb = NULL;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
@@ -3369,10 +3370,28 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_display_ring(priv, rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
+		enum pkt_hash_types hash_type;
 		struct stmmac_rx_buffer *buf;
+		unsigned int prev_len = 0;
 		struct dma_desc *np, *p;
-		int entry, status;
+		int entry;
+		u32 hash;
 
+		if (!count && rx_q->state_saved) {
+			skb = rx_q->state.skb;
+			error = rx_q->state.error;
+			len = rx_q->state.len;
+		} else {
+			rx_q->state_saved = false;
+			skb = NULL;
+			error = 0;
+			len = 0;
+		}
+
+		if (count >= limit)
+			break;
+
+read_again:
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
 
@@ -3407,28 +3426,24 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			page_pool_recycle_direct(rx_q->page_pool, buf->page);
 			priv->dev->stats.rx_errors++;
 			buf->page = NULL;
+			error = 1;
+		}
+
+		if (unlikely(error && (status & rx_not_ls)))
+			goto read_again;
+		if (unlikely(error)) {
+			if (skb)
+				dev_kfree_skb(skb);
+			continue;
+		}
+
+		/* Buffer is good. Go on. */
+
+		if (likely(status & rx_not_ls)) {
+			len += priv->dma_buf_sz;
 		} else {
-			enum pkt_hash_types hash_type;
-			struct sk_buff *skb;
-			unsigned int des;
-			int frame_len;
-			u32 hash;
-
-			stmmac_get_desc_addr(priv, p, &des);
-			frame_len = stmmac_get_rx_frame_len(priv, p, coe);
-
-			/*  If frame length is greater than skb buffer size
-			 *  (preallocated during init) then the packet is
-			 *  ignored
-			 */
-			if (frame_len > priv->dma_buf_sz) {
-				if (net_ratelimit())
-					netdev_err(priv->dev,
-						   "len %d larger than size (%d)\n",
-						   frame_len, priv->dma_buf_sz);
-				priv->dev->stats.rx_length_errors++;
-				continue;
-			}
+			prev_len = len;
+			len = stmmac_get_rx_frame_len(priv, p, coe);
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
 			 * Type frames (LLC/LLC-SNAP)
@@ -3439,57 +3454,71 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			 */
 			if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
 			    unlikely(status != llc_snap))
-				frame_len -= ETH_FCS_LEN;
-
-			if (netif_msg_rx_status(priv)) {
-				netdev_dbg(priv->dev, "\tdesc: %p [entry %d] buff=0x%x\n",
-					   p, entry, des);
-				netdev_dbg(priv->dev, "frame size %d, COE: %d\n",
-					   frame_len, status);
-			}
+				len -= ETH_FCS_LEN;
+		}
 
-			skb = netdev_alloc_skb_ip_align(priv->dev, frame_len);
-			if (unlikely(!skb)) {
+		if (!skb) {
+			skb = napi_alloc_skb(&ch->rx_napi, len);
+			if (!skb) {
 				priv->dev->stats.rx_dropped++;
 				continue;
 			}
 
-			dma_sync_single_for_cpu(priv->device, buf->addr,
-						frame_len, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(priv->device, buf->addr, len,
+						DMA_FROM_DEVICE);
 			skb_copy_to_linear_data(skb, page_address(buf->page),
-						frame_len);
-			skb_put(skb, frame_len);
+						len);
+			skb_put(skb, len);
 
-			if (netif_msg_pktdata(priv)) {
-				netdev_dbg(priv->dev, "frame received (%dbytes)",
-					   frame_len);
-				print_pkt(skb->data, frame_len);
-			}
+			/* Data payload copied into SKB, page ready for recycle */
+			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			buf->page = NULL;
+		} else {
+			unsigned int buf_len = len - prev_len;
 
-			stmmac_get_rx_hwtstamp(priv, p, np, skb);
+			if (likely(status & rx_not_ls))
+				buf_len = priv->dma_buf_sz;
 
-			stmmac_rx_vlan(priv->dev, skb);
+			dma_sync_single_for_cpu(priv->device, buf->addr,
+						buf_len, DMA_FROM_DEVICE);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					buf->page, 0, buf_len,
+					priv->dma_buf_sz);
 
-			skb->protocol = eth_type_trans(skb, priv->dev);
+			/* Data payload appended into SKB */
+			page_pool_release_page(rx_q->page_pool, buf->page);
+			buf->page = NULL;
+		}
 
-			if (unlikely(!coe))
-				skb_checksum_none_assert(skb);
-			else
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+		if (likely(status & rx_not_ls))
+			goto read_again;
 
-			if (!stmmac_get_rx_hash(priv, p, &hash, &hash_type))
-				skb_set_hash(skb, hash, hash_type);
+		/* Got entire packet into SKB. Finish it. */
 
-			skb_record_rx_queue(skb, queue);
-			napi_gro_receive(&ch->rx_napi, skb);
+		stmmac_get_rx_hwtstamp(priv, p, np, skb);
+		stmmac_rx_vlan(priv->dev, skb);
+		skb->protocol = eth_type_trans(skb, priv->dev);
 
-			/* Data payload copied into SKB, page ready for recycle */
-			page_pool_recycle_direct(rx_q->page_pool, buf->page);
-			buf->page = NULL;
+		if (unlikely(!coe))
+			skb_checksum_none_assert(skb);
+		else
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-			priv->dev->stats.rx_packets++;
-			priv->dev->stats.rx_bytes += frame_len;
-		}
+		if (!stmmac_get_rx_hash(priv, p, &hash, &hash_type))
+			skb_set_hash(skb, hash, hash_type);
+
+		skb_record_rx_queue(skb, queue);
+		napi_gro_receive(&ch->rx_napi, skb);
+
+		priv->dev->stats.rx_packets++;
+		priv->dev->stats.rx_bytes += len;
+	}
+
+	if (status & rx_not_ls) {
+		rx_q->state_saved = true;
+		rx_q->state.skb = skb;
+		rx_q->state.error = error;
+		rx_q->state.len = len;
 	}
 
 	stmmac_rx_refill(priv, queue);
-- 
2.7.4

