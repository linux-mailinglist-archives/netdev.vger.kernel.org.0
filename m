Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BB53583BA
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhDHMv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhDHMv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24AC761106;
        Thu,  8 Apr 2021 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886305;
        bh=GD1Yd6l1HfbPKjS5EFpnj4vzUY+UI2YwCTz8gpV16XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGsu12rAjFySlXtYxVVjvRJxNTEoyNd350zZbMhuriedKvPOQfrQrJo23yU2evNSv
         RbII019uhUVxYQWs4z94PDnHY4A+gydz4ez57vGE6VAa1WF0M5fgrBSatBDwakuwfY
         bf0IvPXouriKB29H7/xRtopFX8OXIt6SzhPvMm92X2HRFUiJlhXr1xT4clPwLPJ4tM
         RgK7btg/tohFaTVuJ1UCtq7pCkYa342F4tqd7BISwH7DIsYtz/whBJ10IGaQtlAUkr
         u/xF6uvZBwyqW9WUYWiMuWsi3RQBhxLyKQA+3/M6aa82NyVWE3u46jKEx8vkn0S+zG
         ZzzXGPrrz42Tg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 05/14] net: mvneta: add multi buffer support to XDP_TX
Date:   Thu,  8 Apr 2021 14:50:57 +0200
Message-Id: <9cd3048c42f686bd0f84378b7212d5e9f4a97abd.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to map non-linear xdp buffer running
mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 94 +++++++++++++++++----------
 1 file changed, 58 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 94e29cce693a..e95d8df0fcdb 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1860,8 +1860,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
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
@@ -2057,45 +2057,67 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
-			struct xdp_frame *xdpf, bool dma_map)
+			struct xdp_frame *xdpf, int *nxmit_byte, bool dma_map)
 {
-	struct mvneta_tx_desc *tx_desc;
-	struct mvneta_tx_buf *buf;
-	dma_addr_t dma_addr;
+	struct mvneta_tx_desc *tx_desc = NULL;
+	struct xdp_shared_info *xdp_sinfo;
+	struct page *page;
+	int i, num_frames;
+
+	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+	num_frames = xdpf->mb ? xdp_sinfo->nr_frags + 1 : 1;
 
-	if (txq->count >= txq->tx_stop_threshold)
+	if (txq->count + num_frames >= txq->size)
 		return MVNETA_XDP_DROPPED;
 
-	tx_desc = mvneta_txq_next_desc_get(txq);
+	for (i = 0; i < num_frames; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
+		skb_frag_t *frag = i ? &xdp_sinfo->frags[i - 1] : NULL;
+		int len = i ? xdp_get_frag_size(frag) : xdpf->len;
+		dma_addr_t dma_addr;
 
-	buf = &txq->buf[txq->txq_put_index];
-	if (dma_map) {
-		/* ndo_xdp_xmit */
-		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
-					  xdpf->len, DMA_TO_DEVICE);
-		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
-			mvneta_txq_desc_put(txq);
-			return MVNETA_XDP_DROPPED;
+		tx_desc = mvneta_txq_next_desc_get(txq);
+		if (dma_map) {
+			/* ndo_xdp_xmit */
+			void *data;
+
+			data = frag ? xdp_get_frag_address(frag) : xdpf->data;
+			dma_addr = dma_map_single(pp->dev->dev.parent, data,
+						  len, DMA_TO_DEVICE);
+			if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
+				for (; i >= 0; i--)
+					mvneta_txq_desc_put(txq);
+				return MVNETA_XDP_DROPPED;
+			}
+			buf->type = MVNETA_TYPE_XDP_NDO;
+		} else {
+			page = frag ? xdp_get_frag_page(frag)
+				    : virt_to_page(xdpf->data);
+			dma_addr = page_pool_get_dma_addr(page);
+			if (frag)
+				dma_addr += xdp_get_frag_offset(frag);
+			else
+				dma_addr += sizeof(*xdpf) + xdpf->headroom;
+			dma_sync_single_for_device(pp->dev->dev.parent,
+						   dma_addr, len,
+						   DMA_BIDIRECTIONAL);
+			buf->type = MVNETA_TYPE_XDP_TX;
 		}
-		buf->type = MVNETA_TYPE_XDP_NDO;
-	} else {
-		struct page *page = virt_to_page(xdpf->data);
+		buf->xdpf = i ? NULL : xdpf;
 
-		dma_addr = page_pool_get_dma_addr(page) +
-			   sizeof(*xdpf) + xdpf->headroom;
-		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
-					   xdpf->len, DMA_BIDIRECTIONAL);
-		buf->type = MVNETA_TYPE_XDP_TX;
+		tx_desc->command = !i ? MVNETA_TXD_F_DESC : 0;
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
+	tx_desc->command |= MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
 
-	mvneta_txq_inc_put(txq);
-	txq->pending++;
-	txq->count++;
+	txq->pending += num_frames;
+	txq->count += num_frames;
 
 	return MVNETA_XDP_TX;
 }
@@ -2106,8 +2128,8 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
+	int cpu, nxmit_byte = 0;
 	struct xdp_frame *xdpf;
-	int cpu;
 	u32 ret;
 
 	xdpf = xdp_convert_buff_to_frame(xdp);
@@ -2119,10 +2141,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
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
@@ -2161,11 +2183,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 
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
2.30.2

