Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9FD426B3A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbhJHMxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242139AbhJHMx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:53:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00D8361027;
        Fri,  8 Oct 2021 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633697494;
        bh=HddIyqOWMkFg+s2kvg3w48kwkE90pbSJjKqLTNa+mkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cijqaq2ZxKEiHUv5lEZGozEaSgCCsVUpUlARSp7JTBvbbwFlrtqNphHa3NDfWGvYG
         pzglZ8wgm7+BVslZVEsHP98BLnH5Y4p2Ljtz+LFpxqTCv8v+Gn45Awg7tZXBq3RuHM
         /8rEfZni64nafpwZzmNaMsaplajCR9QCnLb69h+3glGsiyXqgdPqAnT+X0yOXfIPV1
         sfD84auXHOg1l0XpaB9QQnqyDOW+DfKowE25G8piEW/0VhsowFKNRRckVhrA7ZCBRr
         eYRl2GiukgE2mFK/TSkmpxU8o6Q4lLLRtr5prnA7LBM81mh1ODol526e0VteeQVjtN
         beaYjzjc0tRYQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v15 bpf-next 08/18] net: mvneta: add multi buffer support to XDP_TX
Date:   Fri,  8 Oct 2021 14:49:46 +0200
Message-Id: <d9cce9ac7860900f17e4000c56007a2a74fbb7ef.1633697183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to map non-linear xdp buffer running
mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 112 +++++++++++++++++---------
 1 file changed, 76 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 3874302941bf..26b52ca8b5b6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1856,8 +1856,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			bytes_compl += buf->skb->len;
 			pkts_compl++;
 			dev_kfree_skb_any(buf->skb);
-		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
-			   buf->type == MVNETA_TYPE_XDP_NDO) {
+		} else if ((buf->type == MVNETA_TYPE_XDP_TX ||
+			    buf->type == MVNETA_TYPE_XDP_NDO) && buf->xdpf) {
 			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
 				xdp_return_frame_rx_napi(buf->xdpf);
 			else
@@ -2051,47 +2051,87 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
-			struct xdp_frame *xdpf, bool dma_map)
+			struct xdp_frame *xdpf, int *nxmit_byte, bool dma_map)
 {
-	struct mvneta_tx_desc *tx_desc;
-	struct mvneta_tx_buf *buf;
-	dma_addr_t dma_addr;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	struct device *dev = pp->dev->dev.parent;
+	struct mvneta_tx_desc *tx_desc = NULL;
+	int i, num_frames = 1;
+	struct page *page;
+
+	if (unlikely(xdp_frame_is_mb(xdpf)))
+		num_frames += sinfo->nr_frags;
 
-	if (txq->count >= txq->tx_stop_threshold)
+	if (txq->count + num_frames >= txq->size)
 		return MVNETA_XDP_DROPPED;
 
-	tx_desc = mvneta_txq_next_desc_get(txq);
+	for (i = 0; i < num_frames; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
+		skb_frag_t *frag = NULL;
+		int len = xdpf->len;
+		dma_addr_t dma_addr;
 
-	buf = &txq->buf[txq->txq_put_index];
-	if (dma_map) {
-		/* ndo_xdp_xmit */
-		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
-					  xdpf->len, DMA_TO_DEVICE);
-		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
-			mvneta_txq_desc_put(txq);
-			return MVNETA_XDP_DROPPED;
+		if (unlikely(i)) { /* paged area */
+			frag = &sinfo->frags[i - 1];
+			len = skb_frag_size(frag);
 		}
-		buf->type = MVNETA_TYPE_XDP_NDO;
-	} else {
-		struct page *page = virt_to_page(xdpf->data);
 
-		dma_addr = page_pool_get_dma_addr(page) +
-			   sizeof(*xdpf) + xdpf->headroom;
-		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
-					   xdpf->len, DMA_BIDIRECTIONAL);
-		buf->type = MVNETA_TYPE_XDP_TX;
+		tx_desc = mvneta_txq_next_desc_get(txq);
+		if (dma_map) {
+			/* ndo_xdp_xmit */
+			void *data;
+
+			data = unlikely(frag) ? skb_frag_address(frag)
+					      : xdpf->data;
+			dma_addr = dma_map_single(dev, data, len,
+						  DMA_TO_DEVICE);
+			if (dma_mapping_error(dev, dma_addr)) {
+				mvneta_txq_desc_put(txq);
+				goto unmap;
+			}
+
+			buf->type = MVNETA_TYPE_XDP_NDO;
+		} else {
+			page = unlikely(frag) ? skb_frag_page(frag)
+					      : virt_to_page(xdpf->data);
+			dma_addr = page_pool_get_dma_addr(page);
+			if (unlikely(frag))
+				dma_addr += skb_frag_off(frag);
+			else
+				dma_addr += sizeof(*xdpf) + xdpf->headroom;
+			dma_sync_single_for_device(dev, dma_addr, len,
+						   DMA_BIDIRECTIONAL);
+			buf->type = MVNETA_TYPE_XDP_TX;
+		}
+		buf->xdpf = unlikely(i) ? NULL : xdpf;
+
+		tx_desc->command = unlikely(i) ? 0 : MVNETA_TXD_F_DESC;
+		tx_desc->buf_phys_addr = dma_addr;
+		tx_desc->data_size = len;
+		*nxmit_byte += len;
+
+		mvneta_txq_inc_put(txq);
 	}
-	buf->xdpf = xdpf;
 
-	tx_desc->command = MVNETA_TXD_FLZ_DESC;
-	tx_desc->buf_phys_addr = dma_addr;
-	tx_desc->data_size = xdpf->len;
+	/*last descriptor */
+	if (likely(tx_desc))
+		tx_desc->command |= MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
 
-	mvneta_txq_inc_put(txq);
-	txq->pending++;
-	txq->count++;
+	txq->pending += num_frames;
+	txq->count += num_frames;
 
 	return MVNETA_XDP_TX;
+
+unmap:
+	for (i--; i >= 0; i--) {
+		mvneta_txq_desc_put(txq);
+		tx_desc = txq->descs + txq->next_desc_to_proc;
+		dma_unmap_single(dev, tx_desc->buf_phys_addr,
+				 tx_desc->data_size,
+				 DMA_TO_DEVICE);
+	}
+
+	return MVNETA_XDP_DROPPED;
 }
 
 static int
@@ -2100,8 +2140,8 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
+	int cpu, nxmit_byte = 0;
 	struct xdp_frame *xdpf;
-	int cpu;
 	u32 ret;
 
 	xdpf = xdp_convert_buff_to_frame(xdp);
@@ -2113,10 +2153,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	nq = netdev_get_tx_queue(pp->dev, txq->id);
 
 	__netif_tx_lock(nq, cpu);
-	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
+	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, &nxmit_byte, false);
 	if (ret == MVNETA_XDP_TX) {
 		u64_stats_update_begin(&stats->syncp);
-		stats->es.ps.tx_bytes += xdpf->len;
+		stats->es.ps.tx_bytes += nxmit_byte;
 		stats->es.ps.tx_packets++;
 		stats->es.ps.xdp_tx++;
 		u64_stats_update_end(&stats->syncp);
@@ -2155,11 +2195,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 
 	__netif_tx_lock(nq, cpu);
 	for (i = 0; i < num_frame; i++) {
-		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
+		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], &nxmit_byte,
+					      true);
 		if (ret != MVNETA_XDP_TX)
 			break;
 
-		nxmit_byte += frames[i]->len;
 		nxmit++;
 	}
 
-- 
2.31.1

