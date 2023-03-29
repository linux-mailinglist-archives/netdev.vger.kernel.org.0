Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E496CF1DD
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjC2SIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjC2SIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:08:21 -0400
Received: from mail-ed1-x564.google.com (mail-ed1-x564.google.com [IPv6:2a00:1450:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BB06198
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:09 -0700 (PDT)
Received: by mail-ed1-x564.google.com with SMTP id w9so66833332edc.3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680113289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7rSsyMJhIvgvEQW89dfQdDTHZGh1oLI7Hpefw+WAVU=;
        b=R59Kk0GJpE83KDA9DIUGaItDiauF8CyOj1tg4deG3TtTvgbvt5OOiBUHLwylJ7IH2e
         OVtN4Xage71eE+hEJXhRz9Qzm31zVP0RvXDDi3YkAn7O1T9nf6LUEMH0DeacHIEVh4PK
         6tW/18UzaYRw3RkD7qryUbe/YLchwV69Oh+Gw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7rSsyMJhIvgvEQW89dfQdDTHZGh1oLI7Hpefw+WAVU=;
        b=4pzZlcBZyRvRy0rl1wraHMMAUgeWEEWkzZEGQB4A7zTA4FUzVM2ClffoNG20jyRiqN
         2fJxocXscAkRhCdIClNR3WgKZxhuoFQ0zChBr1Ei/emcbLEgy3zsbryTRjL+ZsBQ86FH
         0KTTDq060DsrEM5gw8YjbHfxthzCQ2uTxV2y0sMUFbM9UwFZ70iemeOz+dJqM3RA6mGp
         0+hCQKLA4jP0RZMZwgOeqUJg3fC3ZXknIYCV7UkqAIxq/0xI9xkCV6BxyVbkoaaSZ6gw
         sJSvu8A8876Hgt8H7aygMu54NlxE1+aV6ZDj9gW7cvtijVko46mogoANtTQVOA9ygRdK
         Q9/A==
X-Gm-Message-State: AAQBX9eFXyhexiAzJkGquVz63/84oAoV1ZcMwMY3fk0zQE01+wPj1wQV
        Af9ph6J/FFTHKLWtn2R0ulcxbFYQ4QaX+cjZWq9umcJlperP
X-Google-Smtp-Source: AKy350aCFppLVcsx2UG4SxMzUwOX+R16It3pDZAWiVCNoDFSVi59DzExtW/TRjeFVqXH+X7N6vYGypWecM8P
X-Received: by 2002:a17:906:5803:b0:878:5372:a34b with SMTP id m3-20020a170906580300b008785372a34bmr20501328ejq.45.1680113289583;
        Wed, 29 Mar 2023 11:08:09 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m10-20020a1709066d0a00b00920438f59b3sm12072998ejr.154.2023.03.29.11.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 11:08:09 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Wed, 29 Mar 2023 20:05:00 +0200
Message-Id: <20230329180502.1884307-9-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230329180502.1884307-1-kal.conley@dectris.com>
References: <20230329180502.1884307-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
enables sending/receiving jumbo ethernet frames up to the theoretical
maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
SKB mode is usable pending future driver work.

For consistency, check for HugeTLB pages during UMEM registration. This
implies that hugepages are required for XDP_COPY mode despite DMA not
being used. This restriction is desirable since it ensures user software
can take advantage of future driver support.

Even in HugeTLB mode, continue to do page accounting using order-0
(4 KiB) pages. This minimizes the size of this change and reduces the
risk of impacting driver code. Taking full advantage of hugepages for
accounting should improve XDP performance in the general case.

No significant change in RX/TX performance was observed with this patch.
A few data points are reproduced below:

Machine : Dell PowerEdge R940
CPU     : Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
NIC     : MT27700 Family [ConnectX-4]

+-----+------+------+-------+--------+--------+--------+
|     |      |      | chunk | packet | rxdrop | rxdrop |
|     | mode |  mtu |  size |   size | (Mpps) | (Gbps) |
+-----+------+------+-------+--------+--------+--------+
| old |   -z | 3498 |  4000 |    320 |   15.7 |   40.2 |
| new |   -z | 3498 |  4000 |    320 |   15.8 |   40.4 |
+-----+------+------+-------+--------+--------+--------+
| old |   -z | 3498 |  4096 |    320 |   16.4 |   42.0 |
| new |   -z | 3498 |  4096 |    320 |   16.3 |   41.7 |
+-----+------+------+-------+--------+--------+--------+
| new |   -c | 3498 | 10240 |    320 |    6.3 |   16.1 |
+-----+------+------+-------+--------+--------+--------+
| new |   -S | 9000 | 10240 |   9000 |   0.35 |   25.2 |
+-----+------+------+-------+--------+--------+--------+

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 Documentation/networking/af_xdp.rst | 19 +++++++----
 include/net/xdp_sock.h              |  3 ++
 include/net/xdp_sock_drv.h          | 12 +++++++
 include/net/xsk_buff_pool.h         | 15 ++++++++-
 net/xdp/xdp_umem.c                  | 50 ++++++++++++++++++++++++-----
 net/xdp/xsk_buff_pool.c             | 30 +++++++++++------
 6 files changed, 105 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 247c6c4127e9..0017f83c8fb8 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -419,13 +419,20 @@ XDP_UMEM_REG setsockopt
 -----------------------
 
 This setsockopt registers a UMEM to a socket. This is the area that
-contain all the buffers that packet can reside in. The call takes a
+contains all the buffers that packets can reside in. The call takes a
 pointer to the beginning of this area and the size of it. Moreover, it
-also has parameter called chunk_size that is the size that the UMEM is
-divided into. It can only be 2K or 4K at the moment. If you have an
-UMEM area that is 128K and a chunk size of 2K, this means that you
-will be able to hold a maximum of 128K / 2K = 64 packets in your UMEM
-area and that your largest packet size can be 2K.
+also has a parameter called chunk_size that is the size that the UMEM is
+divided into. For example, if you have an UMEM area that is 128K and a
+chunk size of 2K, this means that you will be able to hold a maximum of
+128K / 2K = 64 packets in your UMEM and that your largest packet size
+can be 2K.
+
+Valid chunk sizes range from 2K to 64K. However, the chunk size must not
+exceed the size of a page (often 4K). This limitation is relaxed for
+UMEM areas allocated with HugeTLB pages. In this case, chunk sizes up
+to the system default hugepage size are supported. Note, this only works
+with hugepages allocated from the kernel's persistent pool. Using
+Transparent Huge Pages (THP) has no effect on the maximum chunk size.
 
 There is also an option to set the headroom of each single buffer in
 the UMEM. If you set this to N bytes, it means that the packet will
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e96a1151ec75..ed88880d4b68 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -28,6 +28,9 @@ struct xdp_umem {
 	struct user_struct *user;
 	refcount_t users;
 	u8 flags;
+#ifdef CONFIG_HUGETLB_PAGE
+	bool hugetlb;
+#endif
 	bool zc;
 	struct page **pgs;
 	int id;
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 9c0d860609ba..83fba3060c9a 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -12,6 +12,18 @@
 #define XDP_UMEM_MIN_CHUNK_SHIFT 11
 #define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
 
+static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
+
+/* Allow chunk sizes up to the maximum size of an ethernet frame (64 KiB).
+ * Larger chunks are not guaranteed to fit in a single SKB.
+ */
+#ifdef CONFIG_HUGETLB_PAGE
+#define XDP_UMEM_MAX_CHUNK_SHIFT min(16, HPAGE_SHIFT)
+#else
+#define XDP_UMEM_MAX_CHUNK_SHIFT min(16, PAGE_SHIFT)
+#endif
+#define XDP_UMEM_MAX_CHUNK_SIZE (1 << XDP_UMEM_MAX_CHUNK_SHIFT)
+
 #ifdef CONFIG_XDP_SOCKETS
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index d318c769b445..bb32112aefea 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -75,6 +75,9 @@ struct xsk_buff_pool {
 	u32 chunk_size;
 	u32 chunk_shift;
 	u32 frame_len;
+#ifdef CONFIG_HUGETLB_PAGE
+	u32 page_size;
+#endif
 	u8 cached_need_wakeup;
 	bool uses_need_wakeup;
 	bool dma_need_sync;
@@ -165,6 +168,15 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 	xp_dma_sync_for_device_slow(pool, dma, size);
 }
 
+static inline u32 xp_get_page_size(struct xsk_buff_pool *pool)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	return pool->page_size;
+#else
+	return PAGE_SIZE;
+#endif
+}
+
 /* Masks for xdp_umem_page flags.
  * The low 12-bits of the addr will be 0 since this is the page address, so we
  * can use them for flags.
@@ -175,7 +187,8 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 						 u64 addr, u32 len)
 {
-	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
+	const u32 page_size = xp_get_page_size(pool);
+	bool cross_pg = (addr & (page_size - 1)) + len > page_size;
 
 	if (likely(!cross_pg))
 		return false;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 4681e8e8ad94..8ff687d7e735 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -10,6 +10,8 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/bpf.h>
+#include <linux/hugetlb.h>
+#include <linux/hugetlb_inline.h>
 #include <linux/mm.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -91,8 +93,37 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
 	}
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+
+/* Returns true if the UMEM contains HugeTLB pages exclusively, false otherwise.
+ *
+ * The mmap_lock must be held by the caller.
+ */
+static bool xdp_umem_is_hugetlb(struct xdp_umem *umem, unsigned long address)
+{
+	unsigned long end = address + umem->size;
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	vma_iter_init(&vmi, current->mm, address);
+	for_each_vma_range(vmi, vma, end) {
+		if (!is_vm_hugetlb_page(vma))
+			return false;
+		/* Hugepage sizes smaller than the default are not supported. */
+		if (huge_page_size(hstate_vma(vma)) < HPAGE_SIZE)
+			return false;
+	}
+
+	return true;
+}
+
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 {
+#ifdef CONFIG_HUGETLB_PAGE
+	bool need_hugetlb = umem->chunk_size > PAGE_SIZE;
+#endif
 	unsigned int gup_flags = FOLL_WRITE;
 	long npgs;
 	int err;
@@ -102,8 +133,18 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 		return -ENOMEM;
 
 	mmap_read_lock(current->mm);
+
+#ifdef CONFIG_HUGETLB_PAGE
+	umem->hugetlb = IS_ALIGNED(address, HPAGE_SIZE) && xdp_umem_is_hugetlb(umem, address);
+	if (need_hugetlb && !umem->hugetlb) {
+		mmap_read_unlock(current->mm);
+		err = -EINVAL;
+		goto out_pgs;
+	}
+#endif
 	npgs = pin_user_pages(address, umem->npgs,
 			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+
 	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
@@ -156,15 +197,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	unsigned int chunks, chunks_rem;
 	int err;
 
-	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
-		/* Strictly speaking we could support this, if:
-		 * - huge pages, or*
-		 * - using an IOMMU, or
-		 * - making sure the memory area is consecutive
-		 * but for now, we simply say "computer says no".
-		 */
+	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > XDP_UMEM_MAX_CHUNK_SIZE)
 		return -EINVAL;
-	}
 
 	if (mr->flags & ~XDP_UMEM_UNALIGNED_CHUNK_FLAG)
 		return -EINVAL;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index b2df1e0f8153..10933f78a5a2 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -80,9 +80,12 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	pool->headroom = umem->headroom;
 	pool->chunk_size = umem->chunk_size;
 	pool->chunk_shift = ffs(umem->chunk_size) - 1;
-	pool->unaligned = unaligned;
 	pool->frame_len = umem->chunk_size - umem->headroom -
 		XDP_PACKET_HEADROOM;
+#ifdef CONFIG_HUGETLB_PAGE
+	pool->page_size = umem->hugetlb ? HPAGE_SIZE : PAGE_SIZE;
+#endif
+	pool->unaligned = unaligned;
 	pool->umem = umem;
 	pool->addrs = umem->addrs;
 	INIT_LIST_HEAD(&pool->free_list);
@@ -369,16 +372,25 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 }
 EXPORT_SYMBOL(xp_dma_unmap);
 
-static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
+/* HugeTLB pools consider contiguity at hugepage granularity only. Hence, all
+ * order-0 pages within a hugepage have the same contiguity value.
+ */
+static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, u32 page_size)
 {
-	u32 i;
+	u32 stride = page_size >> PAGE_SHIFT; /* in order-0 pages */
+	u32 i, j;
 
-	for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
-		if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
-			dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
-		else
-			dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
+	for (i = 0; i + stride < dma_map->dma_pages_cnt;) {
+		if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + stride]) {
+			for (j = 0; j < stride; i++, j++)
+				dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
+		} else {
+			for (j = 0; j < stride; i++, j++)
+				dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
+		}
 	}
+	for (; i < dma_map->dma_pages_cnt; i++)
+		dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
 }
 
 static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
@@ -441,7 +453,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	}
 
 	if (pool->unaligned)
-		xp_check_dma_contiguity(dma_map);
+		xp_check_dma_contiguity(dma_map, xp_get_page_size(pool));
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
-- 
2.39.2

