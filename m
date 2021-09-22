Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C09414302
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhIVH6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhIVH6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:15 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB9DC061574;
        Wed, 22 Sep 2021 00:56:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d21so3982709wra.12;
        Wed, 22 Sep 2021 00:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MJNafatx7RrTirtphFXZlo9MPvtBW/BJEv6djGLPQtQ=;
        b=ioS8PFhebb1mqDMcV7udMJSkM1A3qZIVp9+ooAFd/GAlHumbdx+6V4xPUoPmR9oLfE
         npYqZLJzSRpZM8ot40sFcOhEh+a75F754+/wx1ku+5OmhOek9TcC749MT9tKzOsaU2ap
         CI7QCwBFBAy3KuDOkds5fiMfa+uEir+wEKFHEXxf3QcIwpAZF+y+QPfGNOBR2O9RH9o0
         UHeGf78TeMT6GH/H/pUC1blChk7erDn3OcqQhbEzoZdyRteDpy1KwDU1R2RelISQLgu6
         B/RiUMcAKQJpgNWMXrMyOyGVEBOMumH0Hts7zlYL6plGQswE0H2gIuMAwyGPAS2Us1ON
         afDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MJNafatx7RrTirtphFXZlo9MPvtBW/BJEv6djGLPQtQ=;
        b=rlYBb6YySV7scrvIciGofJ3G3cNhKA13qLx0NzeHPz9UKV5R5iqkoJVqiUQbvwXUWj
         8LVRE4gFWrZST+yCCqNeHanFvglJWMCo1M+cUVyFh+zRCScWRmdArGURs3sIWQMsb7J6
         Ojw3I1J7baSRPt5d4IyX0O2tyh9lhk8IKiu/ZH9r8b7C+MysnvmGxZLE2X6p9mv6nBS6
         OFNeONs2jMuf7OVyj1SSxik5NToQqL7x0oXQ0HSrjA90QAi81RcyGmom+mNpbxfIVNtg
         Aa/63eIxP2jn7Xe7nUv0qf5EQPHwCml04+BmKDMVQLeaEEBRk6HypKUnPcXvAug0js5n
         +GQQ==
X-Gm-Message-State: AOAM532H40zcmAjaOfLENzsrVyMbzqppm4oY6HhQoIuas5mXzk/pKIXr
        OSnXg/e1VS5IY9KomLtBarc=
X-Google-Smtp-Source: ABdhPJz6v29/7HuU/vRPQ1EhJTvYpK/1CwZpZXsGR8BMUkaxKoVOCz5sNp4cL9W8vPD9qp6mTevqbg==
X-Received: by 2002:adf:f187:: with SMTP id h7mr22069158wro.115.1632297404479;
        Wed, 22 Sep 2021 00:56:44 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:44 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 02/13] xsk: batched buffer allocation for the pool
Date:   Wed, 22 Sep 2021 09:56:02 +0200
Message-Id: <20210922075613.12186-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a new driver interface xsk_buff_alloc_batch() offering batched
buffer allocations to improve performance. The new interface takes
three arguments: the buffer pool to allocated from, a pointer to an
array of struct xdp_buff pointers which will contain pointers to the
allocated xdp_buffs, and an unsigned integer specifying the max number
of buffers to allocate. The return value is the actual number of
buffers that the allocator managed to allocate and it will be in the
range 0 <= N <= max, where max is the third parameter to the function.

u32 xsk_buff_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp,
                         u32 max);

A second driver interface is also introduced that need to be used in
conjunction with xsk_buff_alloc_batch(). It is a helper that sets the
size of struct xdp_buff and is used by the NIC Rx irq routine when
receiving a packet. This helper sets the three struct members data,
data_meta, and data_end. The two first ones is in the xsk_buff_alloc()
case set in the allocation routine and data_end is set when a packet
is received in the receive irq function. This unfortunately leads to
worse performance since the xdp_buff is touched twice with a long time
period in between leading to an extra cache miss. Instead, we fill out
the xdp_buff with all 3 fields at one single point in time in the
driver, when the size of the packet is known. Hence this helper. Note
that the driver has to use this helper (or set all three fields
itself) when using xsk_buff_alloc_batch(). xsk_buff_alloc() works as
before and does not require this.

void xsk_buff_set_size(struct xdp_buff *xdp, u32 size);

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock_drv.h  | 22 ++++++++++
 include/net/xsk_buff_pool.h |  1 +
 net/xdp/xsk_buff_pool.c     | 87 +++++++++++++++++++++++++++++++++++++
 net/xdp/xsk_queue.h         | 12 +++--
 4 files changed, 118 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4e295541e396..443d45951564 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -77,6 +77,12 @@ static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 	return xp_alloc(pool);
 }
 
+/* Returns as many entries as possible up to max. 0 <= N <= max. */
+static inline u32 xsk_buff_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
+{
+	return xp_alloc_batch(pool, xdp, max);
+}
+
 static inline bool xsk_buff_can_alloc(struct xsk_buff_pool *pool, u32 count)
 {
 	return xp_can_alloc(pool, count);
@@ -89,6 +95,13 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	xp_free(xskb);
 }
 
+static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
+{
+	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
+	xdp->data_meta = xdp->data;
+	xdp->data_end = xdp->data + size;
+}
+
 static inline dma_addr_t xsk_buff_raw_get_dma(struct xsk_buff_pool *pool,
 					      u64 addr)
 {
@@ -212,6 +225,11 @@ static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 	return NULL;
 }
 
+static inline u32 xsk_buff_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
+{
+	return 0;
+}
+
 static inline bool xsk_buff_can_alloc(struct xsk_buff_pool *pool, u32 count)
 {
 	return false;
@@ -221,6 +239,10 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 {
 }
 
+static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
+{
+}
+
 static inline dma_addr_t xsk_buff_raw_get_dma(struct xsk_buff_pool *pool,
 					      u64 addr)
 {
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index bcb29a10307f..b7068f97639f 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -104,6 +104,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	       unsigned long attrs, struct page **pages, u32 nr_pages);
 void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs);
 struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
+u32 xp_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max);
 bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count);
 void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr);
 dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8de01aaac4a0..884d95d70f5e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -507,6 +507,93 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 }
 EXPORT_SYMBOL(xp_alloc);
 
+static u32 xp_alloc_new_from_fq(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
+{
+	u32 i, cached_cons, nb_entries;
+
+	if (max > pool->free_heads_cnt)
+		max = pool->free_heads_cnt;
+	max = xskq_cons_nb_entries(pool->fq, max);
+
+	cached_cons = pool->fq->cached_cons;
+	nb_entries = max;
+	i = max;
+	while (i--) {
+		struct xdp_buff_xsk *xskb;
+		u64 addr;
+		bool ok;
+
+		__xskq_cons_read_addr_unchecked(pool->fq, cached_cons++, &addr);
+
+		ok = pool->unaligned ? xp_check_unaligned(pool, &addr) :
+			xp_check_aligned(pool, &addr);
+		if (unlikely(!ok)) {
+			pool->fq->invalid_descs++;
+			nb_entries--;
+			continue;
+		}
+
+		xskb = pool->free_heads[--pool->free_heads_cnt];
+		*xdp = &xskb->xdp;
+		xskb->orig_addr = addr;
+		xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
+		xskb->frame_dma = (pool->dma_pages[addr >> PAGE_SHIFT] &
+				   ~XSK_NEXT_PG_CONTIG_MASK) + (addr & ~PAGE_MASK);
+		xskb->dma = xskb->frame_dma + pool->headroom + XDP_PACKET_HEADROOM;
+		xdp++;
+	}
+
+	xskq_cons_release_n(pool->fq, max);
+	return nb_entries;
+}
+
+static u32 xp_alloc_reused(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 nb_entries)
+{
+	struct xdp_buff_xsk *xskb;
+	u32 i;
+
+	nb_entries = min_t(u32, nb_entries, pool->free_list_cnt);
+
+	i = nb_entries;
+	while (i--) {
+		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk, free_list_node);
+		list_del(&xskb->free_list_node);
+
+		*xdp = &xskb->xdp;
+		xdp++;
+	}
+	pool->free_list_cnt -= nb_entries;
+
+	return nb_entries;
+}
+
+u32 xp_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
+{
+	u32 nb_entries1 = 0, nb_entries2;
+
+	if (unlikely(pool->dma_need_sync)) {
+		/* Slow path */
+		*xdp = xp_alloc(pool);
+		return !!*xdp;
+	}
+
+	if (unlikely(pool->free_list_cnt)) {
+		nb_entries1 = xp_alloc_reused(pool, xdp, max);
+		if (nb_entries1 == max)
+			return nb_entries1;
+
+		max -= nb_entries1;
+		xdp += nb_entries1;
+	}
+
+	nb_entries2 = xp_alloc_new_from_fq(pool, xdp, max);
+	if (!nb_entries2)
+		pool->fq->queue_empty_descs++;
+
+	return nb_entries1 + nb_entries2;
+}
+EXPORT_SYMBOL(xp_alloc_batch);
+
 bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count)
 {
 	if (pool->free_list_cnt >= count)
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9ae13cccfb28..e9aa2c236356 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -111,14 +111,18 @@ struct xsk_queue {
 
 /* Functions that read and validate content from consumer rings. */
 
-static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
+static inline void __xskq_cons_read_addr_unchecked(struct xsk_queue *q, u32 cached_cons, u64 *addr)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
+	u32 idx = cached_cons & q->ring_mask;
 
-	if (q->cached_cons != q->cached_prod) {
-		u32 idx = q->cached_cons & q->ring_mask;
+	*addr = ring->desc[idx];
+}
 
-		*addr = ring->desc[idx];
+static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
+{
+	if (q->cached_cons != q->cached_prod) {
+		__xskq_cons_read_addr_unchecked(q, q->cached_cons, addr);
 		return true;
 	}
 
-- 
2.29.0

