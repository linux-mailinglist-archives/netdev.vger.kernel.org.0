Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EED2FC0DF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbhASUWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbhASUWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 114682312B;
        Tue, 19 Jan 2021 20:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087651;
        bh=wYcilxXfq5lFMwCFOPI6lGUmo/1e45Q8wUEYBB5EZcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2cCtbzily9udQwI/lKyVx4/MPe1vbRB5ftJSNsOW16s5ylFUTPFazZq37XKl3HFZ
         pEn4CIwoRMjHMwfTEDSd2yHMDtMRUyBZ/Z++rxEY0XsZ/d2ii5uRHKAvKUfgXNv6Or
         YGqmpJKlHeDEvAWenuGfM3Tae0ru2RiQjxByuxFKFGHDmXGLUAg7M+AqJO8ZnYJEjN
         FDvYnTYOjC11WiEJKqjyT9/QnBenj6MWUym1jXIUARLdh0VW83VyqZsTY3q+jBPANw
         XcxXNGtNTvObwhbT9ERFFWJtYaTQobGTU7HJRng3QLQYDC2odB2EjVtJYprLjcht1i
         Jsr/5VAm3ywtg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 5/8] net: mvneta: add multi buffer support to XDP_TX
Date:   Tue, 19 Jan 2021 21:20:11 +0100
Message-Id: <ce1756558511a52c4bfdc06d1b7607b17ff7f84f.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
References: <cover.1611086134.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to map non-linear xdp buffer running
mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 94 ++++++++++++++++-----------
 1 file changed, 56 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 3df0602239ad..c273e674e3de 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1857,8 +1857,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
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
@@ -2054,45 +2054,64 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
-			struct xdp_frame *xdpf, bool dma_map)
+			struct xdp_frame *xdpf, int *nxmit_byte, bool dma_map)
 {
-	struct mvneta_tx_desc *tx_desc;
-	struct mvneta_tx_buf *buf;
-	dma_addr_t dma_addr;
+	struct xdp_shared_info *xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+	int i, num_frames = xdpf->mb ? xdp_sinfo->nr_frags + 1 : 1;
+	struct mvneta_tx_desc *tx_desc = NULL;
+	struct page *page;
 
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
+
+		tx_desc->command = !i ? MVNETA_TXD_F_DESC : 0;
+		tx_desc->buf_phys_addr = dma_addr;
+		tx_desc->data_size = len;
+		*nxmit_byte += len;
 
-		dma_addr = page_pool_get_dma_addr(page) +
-			   sizeof(*xdpf) + xdpf->headroom;
-		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
-					   xdpf->len, DMA_BIDIRECTIONAL);
-		buf->type = MVNETA_TYPE_XDP_TX;
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
@@ -2103,8 +2122,8 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
+	int cpu, nxmit_byte = 0;
 	struct xdp_frame *xdpf;
-	int cpu;
 	u32 ret;
 
 	xdpf = xdp_convert_buff_to_frame(xdp);
@@ -2116,10 +2135,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
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
@@ -2158,10 +2177,9 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 
 	__netif_tx_lock(nq, cpu);
 	for (i = 0; i < num_frame; i++) {
-		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
-		if (ret == MVNETA_XDP_TX) {
-			nxmit_byte += frames[i]->len;
-		} else {
+		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], &nxmit_byte,
+					      true);
+		if (ret != MVNETA_XDP_TX) {
 			xdp_return_frame_rx_napi(frames[i]);
 			nxmit--;
 		}
-- 
2.29.2

