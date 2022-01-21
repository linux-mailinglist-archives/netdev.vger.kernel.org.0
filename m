Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD48A495D61
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379904AbiAUKLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379918AbiAUKLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:11:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C927C061749;
        Fri, 21 Jan 2022 02:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF30F61A1B;
        Fri, 21 Jan 2022 10:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23662C340E9;
        Fri, 21 Jan 2022 10:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759876;
        bh=+CC3PqzCWjv29FJ/ovt/ti3PrS9aIzwNKpq2CuodI+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRmkgBsc4JKr0lHzNyDS7Y4lQMay8DuHPZTslbP+CdroszjHgpBGp6M2vkltW/dlL
         9+ybGdoAsnYnxW1RDlQEL47Uqfl5Ps9ZBTdyLJJ2ONrt71xNEkESmbN2Pu75PMhgc5
         KZhcYAnkD1kdZ51nv/rc8jFrvtO2vBbLQgD5qvR61bOLguXW+nvatChO1b6kvM1B0o
         rkmGMtNkF/rKQ9y2gNqaKPcuPMlxoD0HVban133ewzXYoiKNwT5hEpYMcuAfebyXUf
         juF+PkvQdbP2YWTx1mjmrcmRZbxB6n56D7p5cfOLwzB6L59mBL4xnasdTok+ozxSjq
         iGilU4K5kGKcw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 08/23] net: mvneta: add frags support to XDP_TX
Date:   Fri, 21 Jan 2022 11:09:51 +0100
Message-Id: <5d46ab63870ffe96fb95e6075a7ff0c81ef6424d.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to map non-linear xdp buffer running
mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 112 +++++++++++++++++---------
 1 file changed, 76 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f1fd93e89c73..c2248e23edcc 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1884,8 +1884,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
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
@@ -2079,47 +2079,87 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
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
+	if (unlikely(xdp_frame_has_frags(xdpf)))
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
@@ -2128,8 +2168,8 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
+	int cpu, nxmit_byte = 0;
 	struct xdp_frame *xdpf;
-	int cpu;
 	u32 ret;
 
 	xdpf = xdp_convert_buff_to_frame(xdp);
@@ -2141,10 +2181,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
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
@@ -2183,11 +2223,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 
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
2.34.1

