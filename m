Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A2128157C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbgJBOmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:42:42 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD1C20708;
        Fri,  2 Oct 2020 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649761;
        bh=DHwBCoNNncxM6JrG4uH+mEpyA4XxNAtuDwPzRels8lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeltZfKJhEb7loo6HXku7TettDBMYy+9Vdvf+oS2UpbUSloyQpI2cjzp1ugPazfXJ
         TR3q5xlgGqg0bJxYJ2JQ4kpzRKkN1Q14jDp4TvvUN4J58NKSuqepuNdfuQRtP80DUK
         JqefJe42vBXIJ9ZtDjBO4GGY2ZcGdqfdh6yq3bpk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 05/13] net: mvneta: add multi buffer support to XDP_TX
Date:   Fri,  2 Oct 2020 16:42:03 +0200
Message-Id: <983d6a55ddf2ef68b0269554ec2f0487271b4d12.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to map non-linear xdp buffer running
mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 79 +++++++++++++++++----------
 1 file changed, 49 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index a431e8478297..f709650974ea 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1852,8 +1852,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
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
@@ -2046,43 +2046,62 @@ static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 			struct xdp_frame *xdpf, bool dma_map)
 {
-	struct mvneta_tx_desc *tx_desc;
-	struct mvneta_tx_buf *buf;
-	dma_addr_t dma_addr;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	int i, num_frames = xdpf->mb ? sinfo->nr_frags + 1 : 1;
+	struct mvneta_tx_desc *tx_desc = NULL;
+	struct page *page;
 
-	if (txq->count >= txq->tx_stop_threshold)
+	if (txq->count + num_frames >= txq->tx_stop_threshold)
 		return MVNETA_XDP_DROPPED;
 
-	tx_desc = mvneta_txq_next_desc_get(txq);
+	for (i = 0; i < num_frames; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
+		skb_frag_t *frag = i ? &sinfo->frags[i - 1] : NULL;
+		int len = frag ? skb_frag_size(frag) : xdpf->len;
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
+			data = frag ? skb_frag_address(frag) : xdpf->data;
+			dma_addr = dma_map_single(pp->dev->dev.parent, data,
+						  len, DMA_TO_DEVICE);
+			if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
+				for (; i >= 0; i--)
+					mvneta_txq_desc_put(txq);
+				return MVNETA_XDP_DROPPED;
+			}
+			buf->type = MVNETA_TYPE_XDP_NDO;
+		} else {
+			page = frag ? skb_frag_page(frag)
+				    : virt_to_page(xdpf->data);
+			dma_addr = page_pool_get_dma_addr(page);
+			if (frag)
+				dma_addr += skb_frag_off(frag);
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
+		if (!i)
+			tx_desc->command = MVNETA_TXD_F_DESC;
+		tx_desc->buf_phys_addr = dma_addr;
+		tx_desc->data_size = len;
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
-- 
2.26.2

