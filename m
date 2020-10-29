Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A30B29F533
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgJ2T3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgJ2T3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 15:29:32 -0400
Received: from lore-desk.redhat.com (unknown [151.66.29.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822CE20796;
        Thu, 29 Oct 2020 19:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603999740;
        bh=hDcWHAUde8Bu87cgNacUqUx/ZD7dajh8GlULMuqpcQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yw3LQAUthmqZsTA7pLD/bIe2K3tvKJfif4IPZzQAhsL2OPgx7APXxiG6uxl3RulbB
         f0ptTNHXbPYkewUPMWbSxZPzRwZhDDr7BdwffoHKBD7Hmnpj29PWRp6VRaYK65Djn8
         W/z4jSHrgdXGABqSk5cAlZIWp59XTW0DdHffQ4sE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v2 net-next 1/4] net: xdp: introduce bulking for xdp tx return path
Date:   Thu, 29 Oct 2020 20:28:44 +0100
Message-Id: <aaf417930ccfdd57ee3a7339e2fff59b8ad50409.1603998519.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603998519.git.lorenzo@kernel.org>
References: <cover.1603998519.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP bulk APIs introduce a defer/flush mechanism to return
pages belonging to the same xdp_mem_allocator object
(identified via the mem.id field) in bulk to optimize
I-cache and D-cache since xdp_return_frame is usually run
inside the driver NAPI tx completion loop.
The bulk queue size is set to 16 to be aligned to how
XDP_REDIRECT bulking works. The bulk is flushed when
it is full or when mem.id changes.
xdp_frame_bulk is usually stored/allocated on the function
call-stack to avoid locking penalties.
Current implementation considers only page_pool memory model.
Convert mvneta driver to xdp_return_frame_bulk APIs.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c |  5 ++-
 include/net/xdp.h                     |  9 ++++
 net/core/xdp.c                        | 61 +++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 1 deletion(-)

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
index 3814fb631d52..a1f48a73e6df 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -104,6 +104,12 @@ struct xdp_frame {
 	struct net_device *dev_rx; /* used by cpumap */
 };
 
+#define XDP_BULK_QUEUE_SIZE	16
+struct xdp_frame_bulk {
+	int count;
+	void *xa;
+	void *q[XDP_BULK_QUEUE_SIZE];
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
index 48aba933a5a8..66ac275a0360 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -380,6 +380,67 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
+/* XDP bulk APIs introduce a defer/flush mechanism to return
+ * pages belonging to the same xdp_mem_allocator object
+ * (identified via the mem.id field) in bulk to optimize
+ * I-cache and D-cache.
+ * The bulk queue size is set to 16 to be aligned to how
+ * XDP_REDIRECT bulking works. The bulk is flushed when
+ * it is full or when mem.id changes.
+ * xdp_frame_bulk is usually stored/allocated on the function
+ * call-stack to avoid locking penalties.
+ */
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
+	struct xdp_mem_allocator *xa;
+
+	if (mem->type != MEM_TYPE_PAGE_POOL) {
+		__xdp_return(xdpf->data, &xdpf->mem, false);
+		return;
+	}
+
+	rcu_read_lock();
+
+	xa = bq->xa;
+	if (unlikely(!xa)) {
+		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
+		bq->count = 0;
+		bq->xa = xa;
+	}
+
+	if (bq->count == XDP_BULK_QUEUE_SIZE)
+		xdp_flush_frame_bulk(bq);
+
+	if (mem->id != xa->mem.id) {
+		xdp_flush_frame_bulk(bq);
+		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
+	}
+
+	bq->q[bq->count++] = xdpf->data;
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

