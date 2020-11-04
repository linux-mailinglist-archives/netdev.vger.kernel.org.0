Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A82A617A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgKDKYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbgKDKXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 05:23:12 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9307A223BD;
        Wed,  4 Nov 2020 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604485391;
        bh=X5Mc+Xowr3ePOIVuzlQStIen+G2pUtVfjA5ze/fZwiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzE0SWU1+pgF3/8IkrzQ7usNWEznwSEzj+hsFd3za/yAsCSNMDAgy3bo7TFY0ek/M
         ArfgbNIaLIlH1rhWXDDEMchRLuXzazhh7cbLIyPXfmrc1mnCj1qHFTYl/yALsIYmJ8
         YsTtL9l4KDv8pVM7ADp8Fc66Vtg83pxHcgKfV+EU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v3 net-next 1/5] net: xdp: introduce bulking for xdp tx return path
Date:   Wed,  4 Nov 2020 11:22:54 +0100
Message-Id: <5ef0c2886518d8ae1577c8b60ea6ef55d031673e.1604484917.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604484917.git.lorenzo@kernel.org>
References: <cover.1604484917.git.lorenzo@kernel.org>
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

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h |  9 +++++++
 net/core/xdp.c    | 61 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

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

