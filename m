Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88071C386C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgEDLis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728401AbgEDLir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:38:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9391CC061A0E;
        Mon,  4 May 2020 04:38:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r4so8338523pgg.4;
        Mon, 04 May 2020 04:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9I6FEysHYMGxr5dFBfKURMBs6YqpPVw6QHSnNB4bxHs=;
        b=Txh2ZQ8eLsIRHinCteSaiP6ADxPPXQrcyfObVwIfn1+vaD5RojHfFcy/pD52AoqHFF
         JxRR+A6OGFE+fFDNp7vp0g+gmxkLRrhlNbLctJmJzEbaZ2BpGsGWjl59A1v2ZGtSmLsn
         4PmdpilkHUUR0FxePjhNW8L16ve4kC6jQ/Rnp5whsviylAgOwZ4HR38CRWKlDrcFRSt4
         vScmApVLQ9ZB4Gf2lO+GesqAkL6RN8D6bl/fX3QjEHA51vTK267aAP25QI6U7epq2Y5S
         YAlE+OAAntiOzJGxq9JljGuV1kIJrZlb6IIE3RAgvLAocSHBoA6+O9bh5oZAOMbNtL5p
         acaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9I6FEysHYMGxr5dFBfKURMBs6YqpPVw6QHSnNB4bxHs=;
        b=Db7L0lNYaDBA0nXgxniGV1HSYsEJpejPfj9Zs1+fHNs6ZI85DP774GDlJCUaqdcSv4
         zYjwr3FqmO0i3m9q/4cPA7K+OPzvsMkCBWQ/bMwkFeZ4YTys8I6lh7+OHPpBwCBU5b0w
         zmkCTJYkYRsCYPa2ZE14vGWsBfZzqaNRJXe5cis4o7rjvLWA0Spp64DBgQWQDozle/aV
         1LMJYGj5GUuxNamlo67EoPwQLQXFN7GX10ZV7y3kqmvjKKtPrF44cOXtkiH1wC7zb3oG
         2K2ap6Frp9u+vpPTE3yt0GhGB7jYaY0933W81V7vrGQfK93X0al1qDrP2N3TWoWcG0J2
         o3RA==
X-Gm-Message-State: AGi0PuZnISEejPk2/enc/5HWfa3zySeRoTXMnjheFdoa/Oo3gUOiN84z
        qMNxz3883f6i6+v6+g4xiEI=
X-Google-Smtp-Source: APiQypI/CZQrO5t/UbYCAfTjcjuzeezRCq3GdS9QmRNdXifmHnpf0F+QmHNtKlt9GE3EkJUrUuchtQ==
X-Received: by 2002:aa7:810a:: with SMTP id b10mr10658874pfi.22.1588592325759;
        Mon, 04 May 2020 04:38:45 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:38:45 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 11/13] xsk: remove MEM_TYPE_ZERO_COPY and corresponding code
Date:   Mon,  4 May 2020 13:37:13 +0200
Message-Id: <20200504113716.7930-12-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200504113716.7930-1-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

There are no users of MEM_TYPE_ZERO_COPY. Remove all corresponding
code, including the "handle" member of struct xdp_sock.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/hyperv/netvsc_bpf.c |   1 -
 include/net/xdp.h               |   9 +--
 include/net/xdp_sock.h          |  45 -----------
 include/net/xdp_sock_drv.h      | 139 --------------------------------
 include/trace/events/xdp.h      |   1 -
 net/core/xdp.c                  |  42 ++--------
 net/xdp/xdp_umem.c              |  56 +------------
 net/xdp/xsk.c                   |  48 +----------
 net/xdp/xsk_buff_pool.c         |   7 ++
 net/xdp/xsk_queue.c             |  62 --------------
 net/xdp/xsk_queue.h             | 105 ------------------------
 11 files changed, 15 insertions(+), 500 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index b86611041db6..9f78f774041b 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -49,7 +49,6 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &nvchan->xdp_rxq;
-	xdp->handle = 0;
 
 	memcpy(xdp->data, data, len);
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 83173e4d306c..1495ffb7a642 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -37,7 +37,6 @@ enum xdp_mem_type {
 	MEM_TYPE_PAGE_SHARED = 0, /* Split-page refcnt based model */
 	MEM_TYPE_PAGE_ORDER0,     /* Orig XDP full page model */
 	MEM_TYPE_PAGE_POOL,
-	MEM_TYPE_ZERO_COPY,
 	MEM_TYPE_XSK_BUFF_POOL,
 	MEM_TYPE_MAX,
 };
@@ -53,10 +52,6 @@ struct xdp_mem_info {
 
 struct page_pool;
 
-struct zero_copy_allocator {
-	void (*free)(struct zero_copy_allocator *zca, unsigned long handle);
-};
-
 struct xdp_rxq_info {
 	struct net_device *dev;
 	u32 queue_index;
@@ -69,7 +64,6 @@ struct xdp_buff {
 	void *data_end;
 	void *data_meta;
 	void *data_hard_start;
-	unsigned long handle;
 	struct xdp_rxq_info *rxq;
 };
 
@@ -102,8 +96,7 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
 	int metasize;
 	int headroom;
 
-	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY ||
-	    xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
+	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
 		return xdp_convert_zc_to_xdp_frame(xdp);
 
 	/* Assure headroom is available for storing info */
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 117cc1e2ca38..6fda898308b6 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -17,26 +17,12 @@ struct net_device;
 struct xsk_queue;
 struct xdp_buff;
 
-struct xdp_umem_page {
-	void *addr;
-	dma_addr_t dma;
-};
-
-struct xdp_umem_fq_reuse {
-	u32 nentries;
-	u32 length;
-	u64 handles[];
-};
-
 struct xdp_umem {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
 	struct xsk_buff_pool *pool;
-	struct xdp_umem_page *pages;
-	u64 chunk_mask;
 	u64 size;
 	u32 headroom;
-	u32 chunk_size_nohr;
 	u32 chunk_size;
 	struct user_struct *user;
 	unsigned long address;
@@ -49,7 +35,6 @@ struct xdp_umem {
 	u8 flags;
 	int id;
 	struct net_device *dev;
-	struct xdp_umem_fq_reuse *fq_reuse;
 	bool zc;
 	spinlock_t xsk_list_lock;
 	struct list_head xsk_list;
@@ -110,21 +95,6 @@ static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
 	return xs;
 }
 
-static inline u64 xsk_umem_extract_addr(u64 addr)
-{
-	return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
-}
-
-static inline u64 xsk_umem_extract_offset(u64 addr)
-{
-	return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
-}
-
-static inline u64 xsk_umem_add_offset_to_addr(u64 addr)
-{
-	return xsk_umem_extract_addr(addr) + xsk_umem_extract_offset(addr);
-}
-
 #else
 
 static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
@@ -147,21 +117,6 @@ static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
 	return NULL;
 }
 
-static inline u64 xsk_umem_extract_addr(u64 addr)
-{
-	return 0;
-}
-
-static inline u64 xsk_umem_extract_offset(u64 addr)
-{
-	return 0;
-}
-
-static inline u64 xsk_umem_add_offset_to_addr(u64 addr)
-{
-	return 0;
-}
-
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 232f2e3f01ac..75c6cc390e86 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -11,16 +11,9 @@
 
 #ifdef CONFIG_XDP_SOCKETS
 
-bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
-bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
-void xsk_umem_release_addr(struct xdp_umem *umem);
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
 bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
 void xsk_umem_consume_tx_done(struct xdp_umem *umem);
-struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries);
-struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
-					  struct xdp_umem_fq_reuse *newq);
-void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
 struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
 void xsk_set_rx_need_wakeup(struct xdp_umem *umem);
 void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
@@ -28,75 +21,6 @@ void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
 void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
 bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
 
-static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
-{
-	unsigned long page_addr;
-
-	addr = xsk_umem_add_offset_to_addr(addr);
-	page_addr = (unsigned long)umem->pages[addr >> PAGE_SHIFT].addr;
-
-	return (char *)(page_addr & PAGE_MASK) + (addr & ~PAGE_MASK);
-}
-
-static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
-{
-	addr = xsk_umem_add_offset_to_addr(addr);
-
-	return umem->pages[addr >> PAGE_SHIFT].dma + (addr & ~PAGE_MASK);
-}
-
-/* Reuse-queue aware version of FILL queue helpers */
-static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (rq->length >= cnt)
-		return true;
-
-	return xsk_umem_has_addrs(umem, cnt - rq->length);
-}
-
-static inline bool xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (!rq->length)
-		return xsk_umem_peek_addr(umem, addr);
-
-	*addr = rq->handles[rq->length - 1];
-	return addr;
-}
-
-static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (!rq->length)
-		xsk_umem_release_addr(umem);
-	else
-		rq->length--;
-}
-
-static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	rq->handles[rq->length++] = addr;
-}
-
-/* Handle the offset appropriately depending on aligned or unaligned mode.
- * For unaligned mode, we store the offset in the upper 16-bits of the address.
- * For aligned mode, we simply add the offset to the address.
- */
-static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
-					 u64 offset)
-{
-	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
-		return address + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
-	else
-		return address + offset;
-}
-
 static inline u32 xsk_umem_get_rx_frame_size(struct xdp_umem *umem)
 {
 	return umem->chunk_size - umem->headroom - XDP_PACKET_HEADROOM;
@@ -170,20 +94,6 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xdp_umem *umem,
 
 #else
 
-static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
-{
-	return false;
-}
-
-static inline u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
-{
-	return NULL;
-}
-
-static inline void xsk_umem_release_addr(struct xdp_umem *umem)
-{
-}
-
 static inline void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
 {
 }
@@ -198,55 +108,12 @@ static inline void xsk_umem_consume_tx_done(struct xdp_umem *umem)
 {
 }
 
-static inline struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
-{
-	return NULL;
-}
-
-static inline struct xdp_umem_fq_reuse *xsk_reuseq_swap(
-	struct xdp_umem *umem, struct xdp_umem_fq_reuse *newq)
-{
-	return NULL;
-}
-
-static inline void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
-{
-}
-
 static inline struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev,
 						     u16 queue_id)
 {
 	return NULL;
 }
 
-static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
-{
-	return NULL;
-}
-
-static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
-{
-	return 0;
-}
-
-static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
-{
-	return false;
-}
-
-static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
-{
-	return NULL;
-}
-
-static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
-{
-}
-
-static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
-{
-}
-
 static inline void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
 {
 }
@@ -268,12 +135,6 @@ static inline bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
 	return false;
 }
 
-static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
-					 u64 offset)
-{
-	return 0;
-}
-
 static inline u32 xsk_umem_get_rx_frame_size(struct xdp_umem *umem)
 {
 	return 0;
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 48547a12fa27..b73d3e141323 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -287,7 +287,6 @@ TRACE_EVENT(xdp_devmap_xmit,
 	FN(PAGE_SHARED)		\
 	FN(PAGE_ORDER0)		\
 	FN(PAGE_POOL)		\
-	FN(ZERO_COPY)		\
 	FN(XSK_BUFF_POOL)
 
 #define __MEM_TYPE_TP_FN(x)	\
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 89053ef8333b..11273c976e19 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -109,27 +109,6 @@ static void mem_allocator_disconnect(void *allocator)
 	mutex_unlock(&mem_id_lock);
 }
 
-static void mem_id_disconnect(int id)
-{
-	struct xdp_mem_allocator *xa;
-
-	mutex_lock(&mem_id_lock);
-
-	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
-	if (!xa) {
-		mutex_unlock(&mem_id_lock);
-		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
-		return;
-	}
-
-	trace_mem_disconnect(xa);
-
-	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
-		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
-
-	mutex_unlock(&mem_id_lock);
-}
-
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 {
 	struct xdp_mem_allocator *xa;
@@ -143,9 +122,6 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 	if (id == 0)
 		return;
 
-	if (xdp_rxq->mem.type == MEM_TYPE_ZERO_COPY)
-		return mem_id_disconnect(id);
-
 	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
 		rcu_read_lock();
 		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
@@ -301,7 +277,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->mem.type = type;
 
 	if (!allocator) {
-		if (type == MEM_TYPE_PAGE_POOL || type == MEM_TYPE_ZERO_COPY)
+		if (type == MEM_TYPE_PAGE_POOL)
 			return -EINVAL; /* Setup time check page_pool req */
 		return 0;
 	}
@@ -361,7 +337,7 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
  * of xdp_frames/pages in those cases.
  */
 static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
-			 unsigned long handle, struct xdp_buff *xdp)
+			 struct xdp_buff *xdp)
 {
 	struct xdp_mem_allocator *xa;
 	struct page *page;
@@ -383,14 +359,6 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		page = virt_to_page(data); /* Assumes order0 page*/
 		put_page(page);
 		break;
-	case MEM_TYPE_ZERO_COPY:
-		/* NB! Only valid from an xdp_buff! */
-		rcu_read_lock();
-		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
-		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
-		xa->zc_alloc->free(xa->zc_alloc, handle);
-		rcu_read_unlock();
-		break;
 	case MEM_TYPE_XSK_BUFF_POOL:
 		/* NB! Only valid from an xdp_buff! */
 		xsk_buff_free(xdp);
@@ -403,19 +371,19 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, false, 0, NULL);
+	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, true, 0, NULL);
+	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
-	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle, xdp);
+	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
 }
 EXPORT_SYMBOL_GPL(xdp_return_buff);
 
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 0bc8a50d553f..ad4c81ba53de 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -179,37 +179,6 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 	umem->zc = false;
 }
 
-static void xdp_umem_unmap_pages(struct xdp_umem *umem)
-{
-	unsigned int i;
-
-	for (i = 0; i < umem->npgs; i++)
-		if (PageHighMem(umem->pgs[i]))
-			vunmap(umem->pages[i].addr);
-}
-
-static int xdp_umem_map_pages(struct xdp_umem *umem)
-{
-	unsigned int i;
-	void *addr;
-
-	for (i = 0; i < umem->npgs; i++) {
-		if (PageHighMem(umem->pgs[i]))
-			addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
-		else
-			addr = page_address(umem->pgs[i]);
-
-		if (!addr) {
-			xdp_umem_unmap_pages(umem);
-			return -ENOMEM;
-		}
-
-		umem->pages[i].addr = addr;
-	}
-
-	return 0;
-}
-
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
 	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
@@ -244,14 +213,9 @@ static void xdp_umem_release(struct xdp_umem *umem)
 		umem->cq = NULL;
 	}
 
-	xsk_reuseq_destroy(umem);
 	xp_destroy(umem->pool);
-	xdp_umem_unmap_pages(umem);
 	xdp_umem_unpin_pages(umem);
 
-	kvfree(umem->pages);
-	umem->pages = NULL;
-
 	xdp_umem_unaccount_pages(umem);
 	kfree(umem);
 }
@@ -386,11 +350,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 		return -EINVAL;
 
 	umem->address = (unsigned long)addr;
-	umem->chunk_mask = unaligned_chunks ? XSK_UNALIGNED_BUF_ADDR_MASK
-					    : ~((u64)chunk_size - 1);
 	umem->size = size;
 	umem->headroom = headroom;
-	umem->chunk_size_nohr = chunk_size - headroom;
 	umem->chunk_size = chunk_size;
 	umem->npgs = size / PAGE_SIZE;
 	umem->pgs = NULL;
@@ -409,29 +370,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (err)
 		goto out_account;
 
-	umem->pages = kvcalloc(umem->npgs, sizeof(*umem->pages),
-			       GFP_KERNEL_ACCOUNT);
-	if (!umem->pages) {
-		err = -ENOMEM;
-		goto out_pin;
-	}
-
-	err = xdp_umem_map_pages(umem);
-	if (err)
-		goto out_pages;
-
 	umem->pool = xp_create(umem->pgs, umem->npgs, chunks, chunk_size,
 			       headroom, size, unaligned_chunks);
 	if (!umem->pool) {
 		err = -ENOMEM;
-		goto out_unmap;
+		goto out_pin;
 	}
 	return 0;
 
-out_unmap:
-	xdp_umem_unmap_pages(umem);
-out_pages:
-	kvfree(umem->pages);
 out_pin:
 	xdp_umem_unpin_pages(umem);
 out_account:
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index df36c12236c3..bcd5faf82788 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -39,24 +39,6 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 		READ_ONCE(xs->umem->fq);
 }
 
-bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
-{
-	return xskq_cons_has_entries(umem->fq, cnt);
-}
-EXPORT_SYMBOL(xsk_umem_has_addrs);
-
-bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
-{
-	return xskq_cons_peek_addr(umem->fq, addr, umem);
-}
-EXPORT_SYMBOL(xsk_umem_peek_addr);
-
-void xsk_umem_release_addr(struct xdp_umem *umem)
-{
-	xskq_cons_release(umem->fq);
-}
-EXPORT_SYMBOL(xsk_umem_release_addr);
-
 void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
 {
 	if (umem->need_wakeup & XDP_WAKEUP_RX)
@@ -203,8 +185,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
 
 	len = xdp->data_end - xdp->data;
 
-	return xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY ||
-		xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ?
+	return xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ?
 		__xsk_rcv_zc(xs, xdp, len) :
 		__xsk_rcv(xs, xdp, len, explicit_free);
 }
@@ -588,24 +569,6 @@ static struct socket *xsk_lookup_xsk_from_fd(int fd)
 	return sock;
 }
 
-/* Check if umem pages are contiguous.
- * If zero-copy mode, use the DMA address to do the page contiguity check
- * For all other modes we use addr (kernel virtual address)
- * Store the result in the low bits of addr.
- */
-static void xsk_check_page_contiguity(struct xdp_umem *umem, u32 flags)
-{
-	struct xdp_umem_page *pgs = umem->pages;
-	int i, is_contig;
-
-	for (i = 0; i < umem->npgs - 1; i++) {
-		is_contig = (flags & XDP_ZEROCOPY) ?
-			(pgs[i].dma + PAGE_SIZE == pgs[i + 1].dma) :
-			(pgs[i].addr + PAGE_SIZE == pgs[i + 1].addr);
-		pgs[i].addr += is_contig << XSK_NEXT_PG_CONTIG_SHIFT;
-	}
-}
-
 static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 {
 	struct sockaddr_xdp *sxdp = (struct sockaddr_xdp *)addr;
@@ -688,23 +651,14 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		goto out_unlock;
 	} else {
 		/* This xsk has its own umem. */
-		xskq_set_umem(xs->umem->fq, xs->umem->size,
-			      xs->umem->chunk_mask);
-		xskq_set_umem(xs->umem->cq, xs->umem->size,
-			      xs->umem->chunk_mask);
-
 		err = xdp_umem_assign_dev(xs->umem, dev, qid, flags);
 		if (err)
 			goto out_unlock;
-
-		xsk_check_page_contiguity(xs->umem, flags);
 	}
 
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
 	xs->queue_id = qid;
-	xskq_set_umem(xs->rx, xs->umem->size, xs->umem->chunk_mask);
-	xskq_set_umem(xs->tx, xs->umem->size, xs->umem->chunk_mask);
 	xdp_add_sk_umem(xs->umem, xs);
 
 out_unlock:
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 30cb2de77a03..30537220e8f2 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -7,6 +7,13 @@
 
 #include "xsk_queue.h"
 
+/* Masks for xdp_umem_page flags.
+ * The low 12-bits of the addr will be 0 since this is the page address, so we
+ * can use them for flags.
+ */
+#define XSK_NEXT_PG_CONTIG_SHIFT 0
+#define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
+
 struct xsk_buff_pool {
 	struct xsk_queue *fq;
 	struct list_head free_list;
diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index c90e9c1e3c63..c33b5d985b9b 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -9,15 +9,6 @@
 
 #include "xsk_queue.h"
 
-void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask)
-{
-	if (!q)
-		return;
-
-	q->size = size;
-	q->chunk_mask = chunk_mask;
-}
-
 static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
 {
 	struct xdp_umem_ring *umem_ring;
@@ -63,56 +54,3 @@ void xskq_destroy(struct xsk_queue *q)
 	page_frag_free(q->ring);
 	kfree(q);
 }
-
-struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
-{
-	struct xdp_umem_fq_reuse *newq;
-
-	/* Check for overflow */
-	if (nentries > (u32)roundup_pow_of_two(nentries))
-		return NULL;
-	nentries = roundup_pow_of_two(nentries);
-
-	newq = kvmalloc(struct_size(newq, handles, nentries), GFP_KERNEL);
-	if (!newq)
-		return NULL;
-	memset(newq, 0, offsetof(typeof(*newq), handles));
-
-	newq->nentries = nentries;
-	return newq;
-}
-EXPORT_SYMBOL_GPL(xsk_reuseq_prepare);
-
-struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
-					  struct xdp_umem_fq_reuse *newq)
-{
-	struct xdp_umem_fq_reuse *oldq = umem->fq_reuse;
-
-	if (!oldq) {
-		umem->fq_reuse = newq;
-		return NULL;
-	}
-
-	if (newq->nentries < oldq->length)
-		return newq;
-
-	memcpy(newq->handles, oldq->handles,
-	       array_size(oldq->length, sizeof(u64)));
-	newq->length = oldq->length;
-
-	umem->fq_reuse = newq;
-	return oldq;
-}
-EXPORT_SYMBOL_GPL(xsk_reuseq_swap);
-
-void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
-{
-	kvfree(rq);
-}
-EXPORT_SYMBOL_GPL(xsk_reuseq_free);
-
-void xsk_reuseq_destroy(struct xdp_umem *umem)
-{
-	xsk_reuseq_free(umem->fq_reuse);
-	umem->fq_reuse = NULL;
-}
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index db25da8fb2b9..16bf15864788 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -32,8 +32,6 @@ struct xdp_umem_ring {
 };
 
 struct xsk_queue {
-	u64 chunk_mask;
-	u64 size;
 	u32 ring_mask;
 	u32 nentries;
 	u32 cached_prod;
@@ -106,90 +104,6 @@ struct xsk_queue {
 
 /* Functions that read and validate content from consumer rings. */
 
-static inline bool xskq_cons_crosses_non_contig_pg(struct xdp_umem *umem,
-						   u64 addr,
-						   u64 length)
-{
-	bool cross_pg = (addr & (PAGE_SIZE - 1)) + length > PAGE_SIZE;
-	bool next_pg_contig =
-		(unsigned long)umem->pages[(addr >> PAGE_SHIFT)].addr &
-			XSK_NEXT_PG_CONTIG_MASK;
-
-	return cross_pg && !next_pg_contig;
-}
-
-static inline bool xskq_cons_is_valid_unaligned(struct xsk_queue *q,
-						u64 addr,
-						u64 length,
-						struct xdp_umem *umem)
-{
-	u64 base_addr = xsk_umem_extract_addr(addr);
-
-	addr = xsk_umem_add_offset_to_addr(addr);
-	if (base_addr >= q->size || addr >= q->size ||
-	    xskq_cons_crosses_non_contig_pg(umem, addr, length)) {
-		q->invalid_descs++;
-		return false;
-	}
-
-	return true;
-}
-
-static inline bool xskq_cons_is_valid_addr(struct xsk_queue *q, u64 addr)
-{
-	if (addr >= q->size) {
-		q->invalid_descs++;
-		return false;
-	}
-
-	return true;
-}
-
-static inline bool xskq_cons_read_addr(struct xsk_queue *q, u64 *addr,
-				       struct xdp_umem *umem)
-{
-	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-
-	while (q->cached_cons != q->cached_prod) {
-		u32 idx = q->cached_cons & q->ring_mask;
-
-		*addr = ring->desc[idx] & q->chunk_mask;
-
-		if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
-			if (xskq_cons_is_valid_unaligned(q, *addr,
-							 umem->chunk_size_nohr,
-							 umem))
-				return true;
-			goto out;
-		}
-
-		if (xskq_cons_is_valid_addr(q, *addr))
-			return true;
-
-out:
-		q->cached_cons++;
-	}
-
-	return false;
-}
-
-static inline bool xskq_cons_read_addr_aligned(struct xsk_queue *q, u64 *addr)
-{
-	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-
-	while (q->cached_cons != q->cached_prod) {
-		u32 idx = q->cached_cons & q->ring_mask;
-
-		*addr = ring->desc[idx];
-		if (xskq_cons_is_valid_addr(q, *addr))
-			return true;
-
-		q->cached_cons++;
-	}
-
-	return false;
-}
-
 static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
@@ -267,21 +181,6 @@ static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
 	return entries >= cnt;
 }
 
-static inline bool xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
-				       struct xdp_umem *umem)
-{
-	if (q->cached_prod == q->cached_cons)
-		xskq_cons_get_entries(q);
-	return xskq_cons_read_addr(q, addr, umem);
-}
-
-static inline bool xskq_cons_peek_addr_aligned(struct xsk_queue *q, u64 *addr)
-{
-	if (q->cached_prod == q->cached_cons)
-		xskq_cons_get_entries(q);
-	return xskq_cons_read_addr_aligned(q, addr);
-}
-
 static inline bool xskq_cons_peek_addr_unchecked(struct xsk_queue *q, u64 *addr)
 {
 	if (q->cached_prod == q->cached_cons)
@@ -410,11 +309,7 @@ static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
 	return q ? q->invalid_descs : 0;
 }
 
-void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue);
 void xskq_destroy(struct xsk_queue *q_ops);
 
-/* Executed by the core when the entire UMEM gets freed */
-void xsk_reuseq_destroy(struct xdp_umem *umem);
-
 #endif /* _LINUX_XSK_QUEUE_H */
-- 
2.25.1

