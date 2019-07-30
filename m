Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CA07AF0E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbfG3RJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:09:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:33179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729655AbfG3RJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 13:09:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 10:09:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="183192551"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2019 10:09:43 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v4 04/11] xsk: add support to allow unaligned chunk placement
Date:   Tue, 30 Jul 2019 08:53:53 +0000
Message-Id: <20190730085400.10376-5-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730085400.10376-1-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, addresses are chunk size aligned. This means, we are very
restricted in terms of where we can place chunk within the umem. For
example, if we have a chunk size of 2k, then our chunks can only be placed
at 0,2k,4k,6k,8k... and so on (ie. every 2k starting from 0).

This patch introduces the ability to use unaligned chunks. With these
changes, we are no longer bound to having to place chunks at a 2k (or
whatever your chunk size is) interval. Since we are no longer dealing with
aligned chunks, they can now cross page boundaries. Checks for page
contiguity have been added in order to keep track of which pages are
followed by a physically contiguous page.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>

---
v2:
  - Add checks for the flags coming from userspace
  - Fix how we get chunk_size in xsk_diag.c
  - Add defines for masking the new descriptor format
  - Modified the rx functions to use new descriptor format
  - Modified the tx functions to use new descriptor format

v3:
  - Add helper function to do address/offset masking/addition

v4:
  - fixed page_start calculation in __xsk_rcv_memcpy().
  - move offset handling to the xdp_umem_get_* functions
  - modified the len field in xdp_umem_reg struct. We now use 16 bits from
    this for the flags field.
  - removed next_pg_contig field from xdp_umem_page struct. Using low 12
    bits of addr to store flags instead.
  - other minor changes based on review comments
---
 include/net/xdp_sock.h      | 40 ++++++++++++++++++-
 include/uapi/linux/if_xdp.h | 14 ++++++-
 net/xdp/xdp_umem.c          | 18 ++++++---
 net/xdp/xsk.c               | 79 +++++++++++++++++++++++++++++--------
 net/xdp/xsk_diag.c          |  2 +-
 net/xdp/xsk_queue.h         | 69 ++++++++++++++++++++++++++++----
 6 files changed, 188 insertions(+), 34 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 69796d264f06..a755e8ab6cac 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -16,6 +16,13 @@
 struct net_device;
 struct xsk_queue;
 
+/* Masks for xdp_umem_page flags.
+ * The low 12-bits of the addr will be 0 since this is the page address, so we
+ * can use them for flags.
+ */
+#define XSK_NEXT_PG_CONTIG_SHIFT 0
+#define XSK_NEXT_PG_CONTIG_MASK (1ULL << XSK_NEXT_PG_CONTIG_SHIFT)
+
 struct xdp_umem_page {
 	void *addr;
 	dma_addr_t dma;
@@ -48,6 +55,7 @@ struct xdp_umem {
 	bool zc;
 	spinlock_t xsk_list_lock;
 	struct list_head xsk_list;
+	u16 flags;
 };
 
 struct xdp_sock {
@@ -98,12 +106,21 @@ struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
 
 static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
 {
-	return umem->pages[addr >> PAGE_SHIFT].addr + (addr & (PAGE_SIZE - 1));
+	unsigned long page_addr;
+
+	addr += addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+	addr &= XSK_UNALIGNED_BUF_ADDR_MASK;
+	page_addr = (unsigned long)umem->pages[addr >> PAGE_SHIFT].addr;
+
+	return (char *)(page_addr & PAGE_MASK) + (addr & ~PAGE_MASK);
 }
 
 static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
 {
-	return umem->pages[addr >> PAGE_SHIFT].dma + (addr & (PAGE_SIZE - 1));
+	addr += addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+	addr &= XSK_UNALIGNED_BUF_ADDR_MASK;
+
+	return umem->pages[addr >> PAGE_SHIFT].dma + (addr & ~PAGE_MASK);
 }
 
 /* Reuse-queue aware version of FILL queue helpers */
@@ -144,6 +161,19 @@ static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
 
 	rq->handles[rq->length++] = addr;
 }
+
+/* Handle the offset appropriately depending on aligned or unaligned mode.
+ * For unaligned mode, we store the offset in the upper 16-bits of the address.
+ * For aligned mode, we simply add the offset to the address.
+ */
+static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
+					 u64 offset)
+{
+	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
+		return address + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+	else
+		return address + offset;
+}
 #else
 static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
@@ -241,6 +271,12 @@ static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
 {
 }
 
+static inline u64 xsk_umem_handle_offset(struct xdp_umem *umem, u64 handle,
+					 u64 offset)
+{
+	return 0;
+}
+
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index faaa5ca2a117..4a5490651b22 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -17,6 +17,10 @@
 #define XDP_COPY	(1 << 1) /* Force copy-mode */
 #define XDP_ZEROCOPY	(1 << 2) /* Force zero-copy mode */
 
+/* Flags for xsk_umem_config flags */
+#define XDP_UMEM_UNALIGNED_CHUNK_FLAG_SHIFT 15
+#define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << XDP_UMEM_UNALIGNED_CHUNK_FLAG_SHIFT)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
@@ -49,8 +53,9 @@ struct xdp_mmap_offsets {
 #define XDP_OPTIONS			8
 
 struct xdp_umem_reg {
-	__u64 addr; /* Start of packet data area */
-	__u64 len; /* Length of packet data area */
+	__u64 addr;    /* Start of packet data area */
+	__u64 len:48;  /* Length of packet data area */
+	__u64 flags:16; /*Flags for umem */
 	__u32 chunk_size;
 	__u32 headroom;
 };
@@ -74,6 +79,11 @@ struct xdp_options {
 #define XDP_UMEM_PGOFF_FILL_RING	0x100000000ULL
 #define XDP_UMEM_PGOFF_COMPLETION_RING	0x180000000ULL
 
+/* Masks for unaligned chunks mode */
+#define XSK_UNALIGNED_BUF_OFFSET_SHIFT 48
+#define XSK_UNALIGNED_BUF_ADDR_MASK \
+	((1ULL << XSK_UNALIGNED_BUF_OFFSET_SHIFT) - 1)
+
 /* Rx/Tx descriptor */
 struct xdp_desc {
 	__u64 addr;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..5590ca7bbe15 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -299,6 +299,7 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
+	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	unsigned int chunks, chunks_per_page;
 	u64 addr = mr->addr, size = mr->len;
@@ -314,7 +315,10 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 		return -EINVAL;
 	}
 
-	if (!is_power_of_2(chunk_size))
+	if (mr->flags & ~XDP_UMEM_UNALIGNED_CHUNK_FLAG)
+		return -EINVAL;
+
+	if (!unaligned_chunks && !is_power_of_2(chunk_size))
 		return -EINVAL;
 
 	if (!PAGE_ALIGNED(addr)) {
@@ -331,9 +335,11 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (chunks == 0)
 		return -EINVAL;
 
-	chunks_per_page = PAGE_SIZE / chunk_size;
-	if (chunks < chunks_per_page || chunks % chunks_per_page)
-		return -EINVAL;
+	if (!unaligned_chunks) {
+		chunks_per_page = PAGE_SIZE / chunk_size;
+		if (chunks < chunks_per_page || chunks % chunks_per_page)
+			return -EINVAL;
+	}
 
 	headroom = ALIGN(headroom, 64);
 
@@ -342,13 +348,15 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 		return -EINVAL;
 
 	umem->address = (unsigned long)addr;
-	umem->chunk_mask = ~((u64)chunk_size - 1);
+	umem->chunk_mask = unaligned_chunks ? XSK_UNALIGNED_BUF_ADDR_MASK
+					    : ~((u64)chunk_size - 1);
 	umem->size = size;
 	umem->headroom = headroom;
 	umem->chunk_size_nohr = chunk_size - headroom;
 	umem->npgs = size / PAGE_SIZE;
 	umem->pgs = NULL;
 	umem->user = NULL;
+	umem->flags = mr->flags;
 	INIT_LIST_HEAD(&umem->xsk_list);
 	spin_lock_init(&umem->xsk_list_lock);
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 59b57d708697..9b834d54549e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL(xsk_umem_has_addrs);
 
 u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 {
-	return xskq_peek_addr(umem->fq, addr);
+	return xskq_peek_addr(umem->fq, addr, umem);
 }
 EXPORT_SYMBOL(xsk_umem_peek_addr);
 
@@ -55,21 +55,42 @@ void xsk_umem_discard_addr(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_umem_discard_addr);
 
+/* If a buffer crosses a page boundary, we need to do 2 memcpy's, one for
+ * each page. This is only required in copy mode.
+ */
+static void __xsk_rcv_memcpy(struct xdp_umem *umem, u64 addr, void *from_buf,
+			     u32 len, u32 metalen)
+{
+	void *to_buf = xdp_umem_get_data(umem, addr);
+
+	if (xskq_crosses_non_contig_pg(umem, addr, len + metalen)) {
+		void *next_pg_addr = umem->pages[(addr >> PAGE_SHIFT) + 1].addr;
+		u64 page_start = addr & ~(PAGE_SIZE - 1);
+		u64 first_len = PAGE_SIZE - (addr - page_start);
+
+		memcpy(to_buf, from_buf, first_len + metalen);
+		memcpy(next_pg_addr, from_buf + first_len, len - first_len);
+
+		return;
+	}
+
+	memcpy(to_buf, from_buf, len + metalen);
+}
+
 static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
-	void *to_buf, *from_buf;
+	u64 offset = xs->umem->headroom;
+	void *from_buf;
 	u32 metalen;
 	u64 addr;
 	int err;
 
-	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
+	if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
 		xs->rx_dropped++;
 		return -ENOSPC;
 	}
 
-	addr += xs->umem->headroom;
-
 	if (unlikely(xdp_data_meta_unsupported(xdp))) {
 		from_buf = xdp->data;
 		metalen = 0;
@@ -78,9 +99,10 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		metalen = xdp->data - xdp->data_meta;
 	}
 
-	to_buf = xdp_umem_get_data(xs->umem, addr);
-	memcpy(to_buf, from_buf, len + metalen);
-	addr += metalen;
+	__xsk_rcv_memcpy(xs->umem, addr + offset, from_buf, len, metalen);
+
+	offset += metalen;
+	addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
 	err = xskq_produce_batch_desc(xs->rx, addr, len);
 	if (!err) {
 		xskq_discard_addr(xs->umem->fq);
@@ -125,6 +147,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	u32 metalen = xdp->data - xdp->data_meta;
 	u32 len = xdp->data_end - xdp->data;
+	u64 offset = xs->umem->headroom;
 	void *buffer;
 	u64 addr;
 	int err;
@@ -136,17 +159,17 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 		goto out_unlock;
 	}
 
-	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
+	if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
 		err = -ENOSPC;
 		goto out_drop;
 	}
 
-	addr += xs->umem->headroom;
-
-	buffer = xdp_umem_get_data(xs->umem, addr);
+	buffer = xdp_umem_get_data(xs->umem, addr + offset);
 	memcpy(buffer, xdp->data_meta, len + metalen);
-	addr += metalen;
+	offset += metalen;
+
+	addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
 	err = xskq_produce_batch_desc(xs->rx, addr, len);
 	if (err)
 		goto out_drop;
@@ -190,7 +213,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
-		if (!xskq_peek_desc(xs->tx, desc))
+		if (!xskq_peek_desc(xs->tx, desc, umem))
 			continue;
 
 		if (xskq_produce_addr_lazy(umem->cq, desc->addr))
@@ -243,7 +266,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
-	while (xskq_peek_desc(xs->tx, &desc)) {
+	while (xskq_peek_desc(xs->tx, &desc, xs->umem)) {
 		char *buffer;
 		u64 addr;
 		u32 len;
@@ -262,6 +285,10 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 
 		skb_put(skb, len);
 		addr = desc.addr;
+		if (xs->umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
+			addr = (addr & XSK_UNALIGNED_BUF_ADDR_MASK) +
+				(addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
 		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
@@ -272,7 +299,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 		skb->dev = xs->dev;
 		skb->priority = sk->sk_priority;
 		skb->mark = sk->sk_mark;
-		skb_shinfo(skb)->destructor_arg = (void *)(long)addr;
+		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
 		err = dev_direct_xmit(skb, xs->queue_id);
@@ -412,6 +439,24 @@ static struct socket *xsk_lookup_xsk_from_fd(int fd)
 	return sock;
 }
 
+/* Check if umem pages are contiguous.
+ * If zero-copy mode, use the DMA address to do the page contiguity check
+ * For all other modes we use addr (kernel virtual address)
+ * Store the result in the low bits of addr.
+ */
+static void xsk_check_page_contiguity(struct xdp_umem *umem, u32 flags)
+{
+	struct xdp_umem_page *pgs = umem->pages;
+	int i, is_contig;
+
+	for (i = 0; i < umem->npgs - 1; i++) {
+		is_contig = (flags & XDP_ZEROCOPY) ?
+			(pgs[i].dma + PAGE_SIZE == pgs[i + 1].dma) :
+			(pgs[i].addr + PAGE_SIZE == pgs[i + 1].addr);
+		pgs[i].addr += is_contig << XSK_NEXT_PG_CONTIG_SHIFT;
+	}
+}
+
 static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 {
 	struct sockaddr_xdp *sxdp = (struct sockaddr_xdp *)addr;
@@ -500,6 +545,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		err = xdp_umem_assign_dev(xs->umem, dev, qid, flags);
 		if (err)
 			goto out_unlock;
+
+		xsk_check_page_contiguity(xs->umem, flags);
 	}
 
 	xs->dev = dev;
diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index d5e06c8e0cbf..9986a759fe06 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -56,7 +56,7 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
 	du.id = umem->id;
 	du.size = umem->size;
 	du.num_pages = umem->npgs;
-	du.chunk_size = (__u32)(~umem->chunk_mask + 1);
+	du.chunk_size = umem->chunk_size_nohr + umem->headroom;
 	du.headroom = umem->headroom;
 	du.ifindex = umem->dev ? umem->dev->ifindex : 0;
 	du.queue_id = umem->queue_id;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 909c5168ed0f..3d045c1c94b1 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -133,6 +133,17 @@ static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
 
 /* UMEM queue */
 
+static inline bool xskq_crosses_non_contig_pg(struct xdp_umem *umem, u64 addr,
+					      u64 length)
+{
+	bool cross_pg = (addr & (PAGE_SIZE - 1)) + length > PAGE_SIZE;
+	bool next_pg_contig =
+		(unsigned long)umem->pages[(addr >> PAGE_SHIFT)].addr &
+			XSK_NEXT_PG_CONTIG_MASK;
+
+	return cross_pg && !next_pg_contig;
+}
+
 static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
 {
 	if (addr >= q->size) {
@@ -143,23 +154,50 @@ static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
 	return true;
 }
 
-static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr)
+static inline bool xskq_is_valid_addr_unaligned(struct xsk_queue *q, u64 addr,
+						u64 length,
+						struct xdp_umem *umem)
+{
+	addr += addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+	addr &= XSK_UNALIGNED_BUF_ADDR_MASK;
+	if (addr >= q->size ||
+	    xskq_crosses_non_contig_pg(umem, addr, length)) {
+		q->invalid_descs++;
+		return false;
+	}
+
+	return true;
+}
+
+static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr,
+				      struct xdp_umem *umem)
 {
 	while (q->cons_tail != q->cons_head) {
 		struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
 		unsigned int idx = q->cons_tail & q->ring_mask;
 
 		*addr = READ_ONCE(ring->desc[idx]) & q->chunk_mask;
+
+		if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
+			if (xskq_is_valid_addr_unaligned(q, *addr,
+							 umem->chunk_size_nohr,
+							 umem))
+				return addr;
+			goto out;
+		}
+
 		if (xskq_is_valid_addr(q, *addr))
 			return addr;
 
+out:
 		q->cons_tail++;
 	}
 
 	return NULL;
 }
 
-static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr)
+static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr,
+				  struct xdp_umem *umem)
 {
 	if (q->cons_tail == q->cons_head) {
 		smp_mb(); /* D, matches A */
@@ -170,7 +208,7 @@ static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr)
 		smp_rmb();
 	}
 
-	return xskq_validate_addr(q, addr);
+	return xskq_validate_addr(q, addr, umem);
 }
 
 static inline void xskq_discard_addr(struct xsk_queue *q)
@@ -229,8 +267,21 @@ static inline int xskq_reserve_addr(struct xsk_queue *q)
 
 /* Rx/Tx queue */
 
-static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct xdp_desc *d)
+static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct xdp_desc *d,
+				      struct xdp_umem *umem)
 {
+	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
+		if (!xskq_is_valid_addr_unaligned(q, d->addr, d->len, umem))
+			return false;
+
+		if (d->len > umem->chunk_size_nohr || d->options) {
+			q->invalid_descs++;
+			return false;
+		}
+
+		return true;
+	}
+
 	if (!xskq_is_valid_addr(q, d->addr))
 		return false;
 
@@ -244,14 +295,15 @@ static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct xdp_desc *d)
 }
 
 static inline struct xdp_desc *xskq_validate_desc(struct xsk_queue *q,
-						  struct xdp_desc *desc)
+						  struct xdp_desc *desc,
+						  struct xdp_umem *umem)
 {
 	while (q->cons_tail != q->cons_head) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 		unsigned int idx = q->cons_tail & q->ring_mask;
 
 		*desc = READ_ONCE(ring->desc[idx]);
-		if (xskq_is_valid_desc(q, desc))
+		if (xskq_is_valid_desc(q, desc, umem))
 			return desc;
 
 		q->cons_tail++;
@@ -261,7 +313,8 @@ static inline struct xdp_desc *xskq_validate_desc(struct xsk_queue *q,
 }
 
 static inline struct xdp_desc *xskq_peek_desc(struct xsk_queue *q,
-					      struct xdp_desc *desc)
+					      struct xdp_desc *desc,
+					      struct xdp_umem *umem)
 {
 	if (q->cons_tail == q->cons_head) {
 		smp_mb(); /* D, matches A */
@@ -272,7 +325,7 @@ static inline struct xdp_desc *xskq_peek_desc(struct xsk_queue *q,
 		smp_rmb(); /* C, matches B */
 	}
 
-	return xskq_validate_desc(q, desc);
+	return xskq_validate_desc(q, desc, umem);
 }
 
 static inline void xskq_discard_desc(struct xsk_queue *q)
-- 
2.17.1

