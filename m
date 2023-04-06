Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3C46D978F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbjDFNCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbjDFNCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:02:44 -0400
Received: from mail-wr1-x462.google.com (mail-wr1-x462.google.com [IPv6:2a00:1450:4864:20::462])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B432986A5
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:02:37 -0700 (PDT)
Received: by mail-wr1-x462.google.com with SMTP id h17so39426259wrt.8
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 06:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680786156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/ROD7131MwBHMPPqRLXQ5aAUzKN259IsnrnbB+7Li8=;
        b=dkP0nRIvJJiJrj+uzucMnSDpc5rlKcEtEsegnfJEXSLJXgAlGe5mKL6CMH2SdGoSkU
         MvDSz7uocd/o0IUlqp6jCrRfMtaUxRDdp/UC+Bqo1mfGY/HqHRWnQkxqjrIsyMWloKvd
         PVCP1VJ6XF3UA7wxpUH5zindtM3WtTBr5Zmig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680786156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a/ROD7131MwBHMPPqRLXQ5aAUzKN259IsnrnbB+7Li8=;
        b=rHYMw+pGsU9feENsBEr5CxopeQX/UaYXbaFUHzyvQrVb373tP7od9nRJJn+FgTuDEF
         Azz02EhExbzo2c0VQinYDRT/p6l1WeH39gXnSvOPYHgMzsrzIJGcotftSpqXDBK7P5+V
         PnEjf/RR2JbRS+li+mls0IfHyGPkvsQ4XdjmQAfdaY7W4xdoCYjEvGfHRXsEeAWL1oQV
         /t9/i9GZJMI5ke243s080pdS1YkzhRV+TlHqqs14y+obYDczluy+pa14etic9w6K27Wc
         veqswIqYjitkiXe/eZcvxgTstRycE2uqmlI/NFqhMTIGngrUUhLOWeCEAt1W9Jq3ZdvC
         0u+Q==
X-Gm-Message-State: AAQBX9cHeUoL0+gcVqqT+fNqEiS8KuF5DX6ZKTV8EpOll9zqrC3BsoRr
        YH0q/S4Np+64PCpFyRVYJVudYUU9Sx625z92cpQU9H7u2X4E
X-Google-Smtp-Source: AKy350ZAqXDwiy40pF/PvMYqU4QrkjbYPzikwSPls+OGE6BJ7AEmIyoUf55H8K5tsxrv8WhXRNAwRELvS8Bj
X-Received: by 2002:adf:e841:0:b0:2df:7c0a:df33 with SMTP id d1-20020adfe841000000b002df7c0adf33mr6617447wrn.30.1680786155238;
        Thu, 06 Apr 2023 06:02:35 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id s3-20020adfeb03000000b002e62dd5b3d6sm65625wrn.3.2023.04.06.06.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:02:35 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Thu,  6 Apr 2023 15:02:03 +0200
Message-Id: <20230406130205.49996-2-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406130205.49996-1-kal.conley@dectris.com>
References: <20230406130205.49996-1-kal.conley@dectris.com>
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
risk of impacting other code. Taking full advantage of hugepages for
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
| old |   -z | 3498 |  4000 |    320 |   16.0 |   40.9 |
| new |   -z | 3498 |  4000 |    320 |   16.0 |   40.9 |
+-----+------+------+-------+--------+--------+--------+
| old |   -z | 3498 |  4096 |    320 |   16.4 |   42.1 |
| new |   -z | 3498 |  4096 |    320 |   16.5 |   42.2 |
+-----+------+------+-------+--------+--------+--------+
| new |   -c | 3498 | 10240 |    320 |    6.1 |   15.6 |
+-----+------+------+-------+--------+--------+--------+
| new |   -S | 9000 | 10240 |   9000 |   0.37 |   26.9 |
+-----+------+------+-------+--------+--------+--------+

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 Documentation/networking/af_xdp.rst | 36 ++++++++++++--------
 include/net/xdp_sock.h              |  1 +
 include/net/xdp_sock_drv.h          | 12 +++++++
 include/net/xsk_buff_pool.h         |  3 +-
 net/xdp/xdp_umem.c                  | 51 ++++++++++++++++++++++++-----
 net/xdp/xsk_buff_pool.c             | 28 +++++++++++-----
 6 files changed, 99 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 247c6c4127e9..ea65cd882af6 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -105,12 +105,13 @@ with AF_XDP". It can be found at https://lwn.net/Articles/750845/.
 UMEM
 ----
 
-UMEM is a region of virtual contiguous memory, divided into
-equal-sized frames. An UMEM is associated to a netdev and a specific
-queue id of that netdev. It is created and configured (chunk size,
-headroom, start address and size) by using the XDP_UMEM_REG setsockopt
-system call. A UMEM is bound to a netdev and queue id, via the bind()
-system call.
+UMEM is a region of virtual contiguous memory divided into equal-sized
+frames. This is the area that contains all the buffers that packets can
+reside in. A UMEM is associated with a netdev and a specific queue id of
+that netdev. It is created and configured (start address, size,
+chunk size, and headroom) by using the XDP_UMEM_REG setsockopt system
+call. A UMEM is bound to a netdev and queue id via the bind() system
+call.
 
 An AF_XDP is socket linked to a single UMEM, but one UMEM can have
 multiple AF_XDP sockets. To share an UMEM created via one socket A,
@@ -418,14 +419,21 @@ negatively impact performance.
 XDP_UMEM_REG setsockopt
 -----------------------
 
-This setsockopt registers a UMEM to a socket. This is the area that
-contain all the buffers that packet can reside in. The call takes a
-pointer to the beginning of this area and the size of it. Moreover, it
-also has parameter called chunk_size that is the size that the UMEM is
-divided into. It can only be 2K or 4K at the moment. If you have an
-UMEM area that is 128K and a chunk size of 2K, this means that you
-will be able to hold a maximum of 128K / 2K = 64 packets in your UMEM
-area and that your largest packet size can be 2K.
+This setsockopt registers a UMEM to a socket. The call takes a pointer
+to the beginning of this area and the size of it. Moreover, there is a
+parameter called chunk_size that is the size that the UMEM is divided
+into. The chunk size limits the maximum packet size that can be sent or
+received. For example, if you have a UMEM area that is 128K and a chunk
+size of 2K, then you will be able to hold a maximum of 128K / 2K = 64
+packets in your UMEM. In this case, the maximum packet size will be 2K.
+
+Valid chunk sizes range from 2K to 64K. However, in aligned mode, the
+chunk size must also be a power of two. Additionally, the chunk size
+must not exceed the size of a page (usually 4K). This limitation is
+relaxed for UMEM areas allocated with HugeTLB pages, in which case
+chunk sizes up to 64K are allowed. Note, this only works with hugepages
+allocated from the kernel's persistent pool. Using Transparent Huge
+Pages (THP) has no effect on the maximum chunk size.
 
 There is also an option to set the headroom of each single buffer in
 the UMEM. If you set this to N bytes, it means that the packet will
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e96a1151ec75..086fcf065656 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -30,6 +30,7 @@ struct xdp_umem {
 	u8 flags;
 	bool zc;
 	struct page **pgs;
+	u32 page_size;
 	int id;
 	struct list_head xsk_dma_list;
 	struct work_struct work;
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
index d318c769b445..6560d053ab88 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -75,6 +75,7 @@ struct xsk_buff_pool {
 	u32 chunk_size;
 	u32 chunk_shift;
 	u32 frame_len;
+	u32 page_size;
 	u8 cached_need_wakeup;
 	bool uses_need_wakeup;
 	bool dma_need_sync;
@@ -175,7 +176,7 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 						 u64 addr, u32 len)
 {
-	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
+	bool cross_pg = (addr & (pool->page_size - 1)) + len > pool->page_size;
 
 	if (likely(!cross_pg))
 		return false;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 4681e8e8ad94..cc07067f7f31 100644
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
@@ -91,6 +93,36 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
 	}
 }
 
+/* NOTE: The mmap_lock must be held by the caller. */
+static void xdp_umem_init_page_size(struct xdp_umem *umem, unsigned long address)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+	unsigned long end;
+
+	if (!IS_ALIGNED(address, HPAGE_SIZE))
+		goto no_hugetlb;
+
+	vma_iter_init(&vmi, current->mm, address);
+	end = address + umem->size;
+
+	for_each_vma_range(vmi, vma, end) {
+		if (!is_vm_hugetlb_page(vma))
+			goto no_hugetlb;
+		/* Hugepage sizes smaller than the default are not supported. */
+		if (huge_page_size(hstate_vma(vma)) < HPAGE_SIZE)
+			goto no_hugetlb;
+	}
+
+	umem->page_size = HPAGE_SIZE;
+	return;
+no_hugetlb:
+#endif
+	umem->page_size = PAGE_SIZE;
+}
+
+
 static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 {
 	unsigned int gup_flags = FOLL_WRITE;
@@ -102,8 +134,18 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 		return -ENOMEM;
 
 	mmap_read_lock(current->mm);
+
+	xdp_umem_init_page_size(umem, address);
+
+	if (umem->chunk_size > umem->page_size) {
+		mmap_read_unlock(current->mm);
+		err = -EINVAL;
+		goto out_pgs;
+	}
+
 	npgs = pin_user_pages(address, umem->npgs,
 			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+
 	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
@@ -156,15 +198,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
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
index b2df1e0f8153..f9e083fa5e6d 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -80,9 +80,10 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	pool->headroom = umem->headroom;
 	pool->chunk_size = umem->chunk_size;
 	pool->chunk_shift = ffs(umem->chunk_size) - 1;
-	pool->unaligned = unaligned;
 	pool->frame_len = umem->chunk_size - umem->headroom -
 		XDP_PACKET_HEADROOM;
+	pool->page_size = umem->page_size;
+	pool->unaligned = unaligned;
 	pool->umem = umem;
 	pool->addrs = umem->addrs;
 	INIT_LIST_HEAD(&pool->free_list);
@@ -369,16 +370,25 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
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
@@ -441,7 +451,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	}
 
 	if (pool->unaligned)
-		xp_check_dma_contiguity(dma_map);
+		xp_check_dma_contiguity(dma_map, pool->page_size);
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
-- 
2.39.2

