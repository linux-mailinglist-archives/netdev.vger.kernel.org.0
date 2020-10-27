Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5EC29C842
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829305AbgJ0TEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502069AbgJ0TEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 15:04:21 -0400
Received: from lore-desk.redhat.com (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 541CE21D41;
        Tue, 27 Oct 2020 19:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603825460;
        bh=3kPUBW3Z65xw9KZDG7WCBMPjdP8XVy7PKBgHAtt0ups=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anNXQyp+K7sbVEqrQoatkq0eqR2BqW1yrLzKml8alSfaHPOyVL7S8o7ntxZLabIRh
         JOaV7g0kRY7ZLbFVoZdH2JeJ/EXvD5h4jJk/2hTYUUQG57uUrPDfksSD6Mam8nJiHa
         2xTL7irgtM1uMN/O6prF+n3O5vdSfhhMiwrlPVtE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx return path
Date:   Tue, 27 Oct 2020 20:04:07 +0100
Message-Id: <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603824486.git.lorenzo@kernel.org>
References: <cover.1603824486.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bulking capability in xdp tx return path (XDP_REDIRECT).
xdp_return_frame is usually run inside the driver NAPI tx completion
loop so it is possible batch it.
Current implementation considers only page_pool memory model.
Convert mvneta driver to xdp_return_frame_bulk APIs.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c |  5 ++-
 include/net/xdp.h                     |  9 +++++
 net/core/xdp.c                        | 51 +++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..43ab8a73900e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1834,8 +1834,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 				 struct netdev_queue *nq, bool napi)
 {
 	unsigned int bytes_compl = 0, pkts_compl = 0;
+	struct xdp_frame_bulk bq;
 	int i;
 
+	bq.xa = NULL;
 	for (i = 0; i < num; i++) {
 		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_get_index];
 		struct mvneta_tx_desc *tx_desc = txq->descs +
@@ -1857,9 +1859,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
 				xdp_return_frame_rx_napi(buf->xdpf);
 			else
-				xdp_return_frame(buf->xdpf);
+				xdp_return_frame_bulk(buf->xdpf, &bq);
 		}
 	}
+	xdp_flush_frame_bulk(&bq);
 
 	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
 }
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3814fb631d52..9567110845ef 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -104,6 +104,12 @@ struct xdp_frame {
 	struct net_device *dev_rx; /* used by cpumap */
 };
 
+#define XDP_BULK_QUEUE_SIZE	16
+struct xdp_frame_bulk {
+	void *q[XDP_BULK_QUEUE_SIZE];
+	int count;
+	void *xa;
+};
 
 static inline struct skb_shared_info *
 xdp_get_shared_info_from_frame(struct xdp_frame *frame)
@@ -194,6 +200,9 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
+void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
+void xdp_return_frame_bulk(struct xdp_frame *xdpf,
+			   struct xdp_frame_bulk *bq);
 
 /* When sending xdp_frame into the network stack, then there is no
  * return point callback, which is needed to release e.g. DMA-mapping
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..93eabd789246 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -380,6 +380,57 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
+void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
+{
+	struct xdp_mem_allocator *xa = bq->xa;
+	int i;
+
+	if (unlikely(!xa))
+		return;
+
+	for (i = 0; i < bq->count; i++) {
+		struct page *page = virt_to_head_page(bq->q[i]);
+
+		page_pool_put_full_page(xa->page_pool, page, false);
+	}
+	bq->count = 0;
+}
+EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
+
+void xdp_return_frame_bulk(struct xdp_frame *xdpf,
+			   struct xdp_frame_bulk *bq)
+{
+	struct xdp_mem_info *mem = &xdpf->mem;
+	struct xdp_mem_allocator *xa, *nxa;
+
+	if (mem->type != MEM_TYPE_PAGE_POOL) {
+		__xdp_return(xdpf->data, &xdpf->mem, false);
+		return;
+	}
+
+	rcu_read_lock();
+
+	xa = bq->xa;
+	if (unlikely(!xa || mem->id != xa->mem.id)) {
+		nxa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
+		if (unlikely(!xa)) {
+			bq->count = 0;
+			bq->xa = nxa;
+			xa = nxa;
+		}
+	}
+
+	if (mem->id != xa->mem.id || bq->count == XDP_BULK_QUEUE_SIZE)
+		xdp_flush_frame_bulk(bq);
+
+	bq->q[bq->count++] = xdpf->data;
+	if (mem->id != xa->mem.id)
+		bq->xa = nxa;
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
+
 void xdp_return_buff(struct xdp_buff *xdp)
 {
 	__xdp_return(xdp->data, &xdp->rxq->mem, true);
-- 
2.26.2

