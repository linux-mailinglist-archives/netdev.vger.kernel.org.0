Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A776841430A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhIVH60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhIVH6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:21 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6654C061574;
        Wed, 22 Sep 2021 00:56:51 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q26so4085869wrc.7;
        Wed, 22 Sep 2021 00:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3t5veB220zYZE70cSKcxGubsSW7TFiEF2zf4SCZTIFM=;
        b=ZlKvcwRmptAAusziFGYWFZd6+0t56xD879ljwjHhOZP1eqZXfFq2gwfrj2hV23NfVe
         p28PJI4Oa8hU2KPbNvg8o9wCBJkU8SUYYH+ate3IAoVW4QW4lSjDLoEOeciNSjZRiXPP
         4Pgp8xFeOSzIfJigjkMLN+YftOe6lQMJFlp3uu2XFFtGWRIZDgiGK6FVnQyqjrNJJtdU
         N/mPew4zU81iFaYqrEfRAe5XEkex18huBI8JXHgQLwj8XGyW1L0YUBGVLddbrSNsMwH9
         oQcBVgh0cpsVagWLaxldUmteumHL8HUGN0KkAs33jDYUnEd0FAb6di5gj8spExiZnOOv
         9ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3t5veB220zYZE70cSKcxGubsSW7TFiEF2zf4SCZTIFM=;
        b=CFL3X8BNhjuHbrIp64jeSHyX/E/XmSzHKXadGTPwdMxCLy5i8bPjTkyJgo4cYNGuh9
         HIJqXKQLLtgD2pdjGiStIZXNA5HDMzS7WJr4QPaYujAF0nDF+VPJ9+hmXST6BrWmU5cr
         P/Byzzhc8Kgn2qtlHkJRD28+r4Mat4EfBDWiEvJWJNkHYe9GwW/vfVZW+9wq3rPtA/T9
         B+OHglQwMbb8ikiNCscDPu61AGP5t5VzfFZhIlfZ0k8StJ+QL/xo3rFIM1okD2b2Matf
         y7YIG6VDzEjqSNLzKer0wg+y9xNIlrsC+R+Uh/kSVemPAYKenbuzkqULoTuuro8laDLg
         QoqA==
X-Gm-Message-State: AOAM533Jo7MC0i49/yBPguJOPD/5ZtVLkCYeJK3egp6Cjs1mBknQ54rQ
        +yONLaQQIqMjE7bDyIaV4XQ=
X-Google-Smtp-Source: ABdhPJxT6ET/yIqZHeqn/uvG6e2gYACzWizjKJCqYXWifuv9GxZ5MSZIQgdox2jnKp0VQQZwQRy6kg==
X-Received: by 2002:a05:600c:3797:: with SMTP id o23mr8931742wmr.111.1632297410247;
        Wed, 22 Sep 2021 00:56:50 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:49 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 06/13] xsk: optimize for aligned case
Date:   Wed, 22 Sep 2021 09:56:06 +0200
Message-Id: <20210922075613.12186-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Optimize for the aligned case by precomputing the parameter values of
the xdp_buff_xsk and xdp_buff structures in the heads array. We can do
this as the heads array size is equal to the number of chunks in the
umem for the aligned case. Then every entry in this array will reflect
a certain chunk/frame and can therefore be prepopulated with the
correct values and we can drop the use of the free_heads stack. Note
that it is not possible to allocate more buffers than what has been
allocated in the aligned case since each chunk can only contain a
single buffer.

We can unfortunately not do this in the unaligned case as one chunk
might contain multiple buffers. In this case, we keep the old scheme
of populating a heads entry every time it is used and using
the free_heads stack.

Also move xp_release() and xp_get_handle() to xsk_buff_pool.h. They
were for some reason in xsk.c even though they are buffer pool
operations.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xsk_buff_pool.h | 46 +++++++++++++++++++++++++++++-
 net/xdp/xsk.c               | 15 ----------
 net/xdp/xsk_buff_pool.c     | 56 ++++++++++++++++++++++---------------
 3 files changed, 79 insertions(+), 38 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index b7068f97639f..ddeefc4a1040 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -7,6 +7,7 @@
 #include <linux/if_xdp.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
+#include <linux/bpf.h>
 #include <net/xdp.h>
 
 struct xsk_buff_pool;
@@ -66,6 +67,7 @@ struct xsk_buff_pool {
 	u32 free_heads_cnt;
 	u32 headroom;
 	u32 chunk_size;
+	u32 chunk_shift;
 	u32 frame_len;
 	u8 cached_need_wakeup;
 	bool uses_need_wakeup;
@@ -80,6 +82,13 @@ struct xsk_buff_pool {
 	struct xdp_buff_xsk *free_heads[];
 };
 
+/* Masks for xdp_umem_page flags.
+ * The low 12-bits of the addr will be 0 since this is the page address, so we
+ * can use them for flags.
+ */
+#define XSK_NEXT_PG_CONTIG_SHIFT 0
+#define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
+
 /* AF_XDP core. */
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
@@ -88,7 +97,6 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 			 struct net_device *dev, u16 queue_id);
 void xp_destroy(struct xsk_buff_pool *pool);
-void xp_release(struct xdp_buff_xsk *xskb);
 void xp_get_pool(struct xsk_buff_pool *pool);
 bool xp_put_pool(struct xsk_buff_pool *pool);
 void xp_clear_dev(struct xsk_buff_pool *pool);
@@ -98,6 +106,21 @@ void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
 
+static inline void xp_init_xskb_addr(struct xdp_buff_xsk *xskb, struct xsk_buff_pool *pool,
+				     u64 addr)
+{
+	xskb->orig_addr = addr;
+	xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
+}
+
+static inline void xp_init_xskb_dma(struct xdp_buff_xsk *xskb, struct xsk_buff_pool *pool,
+				    dma_addr_t *dma_pages, u64 addr)
+{
+	xskb->frame_dma = (dma_pages[addr >> PAGE_SHIFT] & ~XSK_NEXT_PG_CONTIG_MASK) +
+		(addr & ~PAGE_MASK);
+	xskb->dma = xskb->frame_dma + pool->headroom + XDP_PACKET_HEADROOM;
+}
+
 /* AF_XDP ZC drivers, via xdp_sock_buff.h */
 void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq);
 int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
@@ -180,4 +203,25 @@ static inline u64 xp_unaligned_add_offset_to_addr(u64 addr)
 		xp_unaligned_extract_offset(addr);
 }
 
+static inline u32 xp_aligned_extract_idx(struct xsk_buff_pool *pool, u64 addr)
+{
+	return xp_aligned_extract_addr(pool, addr) >> pool->chunk_shift;
+}
+
+static inline void xp_release(struct xdp_buff_xsk *xskb)
+{
+	if (xskb->pool->unaligned)
+		xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
+}
+
+static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb)
+{
+	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
+
+	offset += xskb->pool->headroom;
+	if (!xskb->pool->unaligned)
+		return xskb->orig_addr + offset;
+	return xskb->orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+}
+
 #endif /* XSK_BUFF_POOL_H_ */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d6b500dc4208..f16074eb53c7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -134,21 +134,6 @@ int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
 	return 0;
 }
 
-void xp_release(struct xdp_buff_xsk *xskb)
-{
-	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
-}
-
-static u64 xp_get_handle(struct xdp_buff_xsk *xskb)
-{
-	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
-
-	offset += xskb->pool->headroom;
-	if (!xskb->pool->unaligned)
-		return xskb->orig_addr + offset;
-	return xskb->orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
-}
-
 static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 884d95d70f5e..96b14e51ba7e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -44,12 +44,13 @@ void xp_destroy(struct xsk_buff_pool *pool)
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem)
 {
+	bool unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	struct xsk_buff_pool *pool;
 	struct xdp_buff_xsk *xskb;
-	u32 i;
+	u32 i, entries;
 
-	pool = kvzalloc(struct_size(pool, free_heads, umem->chunks),
-			GFP_KERNEL);
+	entries = unaligned ? umem->chunks : 0;
+	pool = kvzalloc(struct_size(pool, free_heads, entries),	GFP_KERNEL);
 	if (!pool)
 		goto out;
 
@@ -63,7 +64,8 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	pool->free_heads_cnt = umem->chunks;
 	pool->headroom = umem->headroom;
 	pool->chunk_size = umem->chunk_size;
-	pool->unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
+	pool->chunk_shift = ffs(umem->chunk_size) - 1;
+	pool->unaligned = unaligned;
 	pool->frame_len = umem->chunk_size - umem->headroom -
 		XDP_PACKET_HEADROOM;
 	pool->umem = umem;
@@ -81,7 +83,10 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		xskb = &pool->heads[i];
 		xskb->pool = pool;
 		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
-		pool->free_heads[i] = xskb;
+		if (pool->unaligned)
+			pool->free_heads[i] = xskb;
+		else
+			xp_init_xskb_addr(xskb, pool, i * pool->chunk_size);
 	}
 
 	return pool;
@@ -406,6 +411,12 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 
 	if (pool->unaligned)
 		xp_check_dma_contiguity(dma_map);
+	else
+		for (i = 0; i < pool->heads_cnt; i++) {
+			struct xdp_buff_xsk *xskb = &pool->heads[i];
+
+			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
+		}
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
@@ -448,8 +459,6 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
 	if (pool->free_heads_cnt == 0)
 		return NULL;
 
-	xskb = pool->free_heads[--pool->free_heads_cnt];
-
 	for (;;) {
 		if (!xskq_cons_peek_addr_unchecked(pool->fq, &addr)) {
 			pool->fq->queue_empty_descs++;
@@ -466,17 +475,17 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
 		}
 		break;
 	}
-	xskq_cons_release(pool->fq);
 
-	xskb->orig_addr = addr;
-	xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
-	if (pool->dma_pages_cnt) {
-		xskb->frame_dma = (pool->dma_pages[addr >> PAGE_SHIFT] &
-				   ~XSK_NEXT_PG_CONTIG_MASK) +
-				  (addr & ~PAGE_MASK);
-		xskb->dma = xskb->frame_dma + pool->headroom +
-			    XDP_PACKET_HEADROOM;
+	if (pool->unaligned) {
+		xskb = pool->free_heads[--pool->free_heads_cnt];
+		xp_init_xskb_addr(xskb, pool, addr);
+		if (pool->dma_pages_cnt)
+			xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
+	} else {
+		xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
 	}
+
+	xskq_cons_release(pool->fq);
 	return xskb;
 }
 
@@ -533,13 +542,16 @@ static u32 xp_alloc_new_from_fq(struct xsk_buff_pool *pool, struct xdp_buff **xd
 			continue;
 		}
 
-		xskb = pool->free_heads[--pool->free_heads_cnt];
+		if (pool->unaligned) {
+			xskb = pool->free_heads[--pool->free_heads_cnt];
+			xp_init_xskb_addr(xskb, pool, addr);
+			if (pool->dma_pages_cnt)
+				xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
+		} else {
+			xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
+		}
+
 		*xdp = &xskb->xdp;
-		xskb->orig_addr = addr;
-		xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
-		xskb->frame_dma = (pool->dma_pages[addr >> PAGE_SHIFT] &
-				   ~XSK_NEXT_PG_CONTIG_MASK) + (addr & ~PAGE_MASK);
-		xskb->dma = xskb->frame_dma + pool->headroom + XDP_PACKET_HEADROOM;
 		xdp++;
 	}
 
-- 
2.29.0

