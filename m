Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C70DF76AA
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKKOnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:43:00 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:44432 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbfKKOm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:42:59 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 70152C0E0E;
        Mon, 11 Nov 2019 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573483379; bh=OCh1D547y/ayETMzIo+QdmplbDDiqGFplipLwIl0zCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CB2IXLhVsqkG7Upl+6dfOsinDVyVVQ1KnspNHR0ExRMVHt32EqiAKmCbiIHcSW5lT
         HUIPmJN/HljDz7QT0CGsTROsS6LRDcsUvy6LHUgPI4mTW+1KUdhSgizaiz9kWIc8NK
         fSm0DCQkzfuz7wqqcUptYw7AGnwrLLb9F1m9NwoszeZql+z3OMXPwIXXPvYTcUoGAG
         F8C/kOen/G3uK2Pa2h3DJt/eRIrT7/AqAMasVOI7PnHwqp6r2NhczxBHik7mWDFPCg
         HZOz5Avax6RJUIYlIg/2o8g4IhoEf68oPYRaK29tr5ooD60mb147qp3+8ywClNrauK
         Y9hwd+ByylpZQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 28168A0257;
        Mon, 11 Nov 2019 14:42:57 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: stmmac: Rework stmmac_rx()
Date:   Mon, 11 Nov 2019 15:42:38 +0100
Message-Id: <c475850fdb0e71cbf6e0b7559bf1546d27996ed4.1573482991.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This looks over-engineered. Let's use some helpers to get the buffer
length and hereby simplify the stmmac_rx() function. No performance drop
was seen with the new implementation.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 146 ++++++++++++++--------
 1 file changed, 94 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5f40fbb67bac..a2fac7772666 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3443,6 +3443,55 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 	stmmac_set_rx_tail_ptr(priv, priv->ioaddr, rx_q->rx_tail_addr, queue);
 }
 
+static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
+				       struct dma_desc *p,
+				       int status, unsigned int len)
+{
+	int ret, coe = priv->hw->rx_csum;
+	unsigned int plen = 0, hlen = 0;
+
+	/* Not first descriptor, buffer is always zero */
+	if (priv->sph && len)
+		return 0;
+
+	/* First descriptor, get split header length */
+	ret = stmmac_get_rx_header_len(priv, p, &hlen);
+	if (priv->sph && hlen) {
+		priv->xstats.rx_split_hdr_pkt_n++;
+		return hlen;
+	}
+
+	/* First descriptor, not last descriptor and not split header */
+	if (status & rx_not_ls)
+		return priv->dma_buf_sz;
+
+	plen = stmmac_get_rx_frame_len(priv, p, coe);
+
+	/* First descriptor and last descriptor and not split header */
+	return min_t(unsigned int, priv->dma_buf_sz, plen);
+}
+
+static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
+				       struct dma_desc *p,
+				       int status, unsigned int len)
+{
+	int coe = priv->hw->rx_csum;
+	unsigned int plen = 0;
+
+	/* Not split header, buffer is not available */
+	if (!priv->sph)
+		return 0;
+
+	/* Not last descriptor */
+	if (status & rx_not_ls)
+		return priv->dma_buf_sz;
+
+	plen = stmmac_get_rx_frame_len(priv, p, coe);
+
+	/* Last descriptor */
+	return plen - len;
+}
+
 /**
  * stmmac_rx - manage the receive process
  * @priv: driver private structure
@@ -3472,11 +3521,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_display_ring(priv, rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
-		unsigned int hlen = 0, prev_len = 0;
+		unsigned int buf1_len = 0, buf2_len = 0;
 		enum pkt_hash_types hash_type;
 		struct stmmac_rx_buffer *buf;
 		struct dma_desc *np, *p;
-		unsigned int sec_len;
 		int entry;
 		u32 hash;
 
@@ -3495,7 +3543,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 
 read_again:
-		sec_len = 0;
+		buf1_len = 0;
+		buf2_len = 0;
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
 
@@ -3520,7 +3569,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			np = rx_q->dma_rx + next_entry;
 
 		prefetch(np);
-		prefetch(page_address(buf->page));
 
 		if (priv->extend_desc)
 			stmmac_rx_extended_status(priv, &priv->dev->stats,
@@ -3537,69 +3585,61 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			goto read_again;
 		if (unlikely(error)) {
 			dev_kfree_skb(skb);
+			skb = NULL;
 			count++;
 			continue;
 		}
 
 		/* Buffer is good. Go on. */
 
-		if (likely(status & rx_not_ls)) {
-			len += priv->dma_buf_sz;
-		} else {
-			prev_len = len;
-			len = stmmac_get_rx_frame_len(priv, p, coe);
-
-			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
-			 * Type frames (LLC/LLC-SNAP)
-			 *
-			 * llc_snap is never checked in GMAC >= 4, so this ACS
-			 * feature is always disabled and packets need to be
-			 * stripped manually.
-			 */
-			if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-			    unlikely(status != llc_snap))
-				len -= ETH_FCS_LEN;
+		prefetch(page_address(buf->page));
+		if (buf->sec_page)
+			prefetch(page_address(buf->sec_page));
+
+		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
+		len += buf1_len;
+		buf2_len = stmmac_rx_buf2_len(priv, p, status, len);
+		len += buf2_len;
+
+		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
+		 * Type frames (LLC/LLC-SNAP)
+		 *
+		 * llc_snap is never checked in GMAC >= 4, so this ACS
+		 * feature is always disabled and packets need to be
+		 * stripped manually.
+		 */
+		if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
+		    unlikely(status != llc_snap)) {
+			if (buf2_len)
+				buf2_len -= ETH_FCS_LEN;
+			else
+				buf1_len -= ETH_FCS_LEN;
+
+			len -= ETH_FCS_LEN;
 		}
 
 		if (!skb) {
-			int ret = stmmac_get_rx_header_len(priv, p, &hlen);
-
-			if (priv->sph && !ret && (hlen > 0)) {
-				sec_len = len;
-				if (!(status & rx_not_ls))
-					sec_len = sec_len - hlen;
-				len = hlen;
-
-				prefetch(page_address(buf->sec_page));
-				priv->xstats.rx_split_hdr_pkt_n++;
-			}
-
-			skb = napi_alloc_skb(&ch->rx_napi, len);
+			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
 			if (!skb) {
 				priv->dev->stats.rx_dropped++;
 				count++;
-				continue;
+				goto drain_data;
 			}
 
-			dma_sync_single_for_cpu(priv->device, buf->addr, len,
-						DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(priv->device, buf->addr,
+						buf1_len, DMA_FROM_DEVICE);
 			skb_copy_to_linear_data(skb, page_address(buf->page),
-						len);
-			skb_put(skb, len);
+						buf1_len);
+			skb_put(skb, buf1_len);
 
 			/* Data payload copied into SKB, page ready for recycle */
 			page_pool_recycle_direct(rx_q->page_pool, buf->page);
 			buf->page = NULL;
-		} else {
-			unsigned int buf_len = len - prev_len;
-
-			if (likely(status & rx_not_ls))
-				buf_len = priv->dma_buf_sz;
-
+		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
-						buf_len, DMA_FROM_DEVICE);
+						buf1_len, DMA_FROM_DEVICE);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-					buf->page, 0, buf_len,
+					buf->page, 0, buf1_len,
 					priv->dma_buf_sz);
 
 			/* Data payload appended into SKB */
@@ -3607,22 +3647,23 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			buf->page = NULL;
 		}
 
-		if (sec_len > 0) {
+		if (buf2_len) {
 			dma_sync_single_for_cpu(priv->device, buf->sec_addr,
-						sec_len, DMA_FROM_DEVICE);
+						buf2_len, DMA_FROM_DEVICE);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-					buf->sec_page, 0, sec_len,
+					buf->sec_page, 0, buf2_len,
 					priv->dma_buf_sz);
 
-			len += sec_len;
-
 			/* Data payload appended into SKB */
 			page_pool_release_page(rx_q->page_pool, buf->sec_page);
 			buf->sec_page = NULL;
 		}
 
+drain_data:
 		if (likely(status & rx_not_ls))
 			goto read_again;
+		if (!skb)
+			continue;
 
 		/* Got entire packet into SKB. Finish it. */
 
@@ -3640,13 +3681,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		skb_record_rx_queue(skb, queue);
 		napi_gro_receive(&ch->rx_napi, skb);
+		skb = NULL;
 
 		priv->dev->stats.rx_packets++;
 		priv->dev->stats.rx_bytes += len;
 		count++;
 	}
 
-	if (status & rx_not_ls) {
+	if (status & rx_not_ls || skb) {
 		rx_q->state_saved = true;
 		rx_q->state.skb = skb;
 		rx_q->state.error = error;
-- 
2.7.4

