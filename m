Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E79B698EB6
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBPIa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBPIa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:30:56 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1644743E;
        Thu, 16 Feb 2023 00:30:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VbntXyA_1676536247;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VbntXyA_1676536247)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 16:30:48 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v4] xsk: support use vaddr as ring
Date:   Thu, 16 Feb 2023 16:30:47 +0800
Message-Id: <20230216083047.93525-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
X-Git-Hash: d7a9e9804406
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we try to start AF_XDP on some machines with long running time, due
to the machine's memory fragmentation problem, there is no sufficient
contiguous physical memory that will cause the start failure.

If the size of the queue is 8 * 1024, then the size of the desc[] is
8 * 1024 * 8 = 16 * PAGE, but we also add struct xdp_ring size, so it is
16page+. This is necessary to apply for a 4-order memory. If there are a
lot of queues, it is difficult to these machine with long running time.

Here, that we actually waste 15 pages. 4-Order memory is 32 pages, but
we only use 17 pages.

This patch replaces __get_free_pages() by vmalloc() to allocate memory
to solve these problems.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       |  9 ++-------
 net/xdp/xsk_queue.c | 11 +++++------
 net/xdp/xsk_queue.h |  1 +
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9f0561b67c12..0a047a09a10f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1295,8 +1295,6 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	unsigned long size = vma->vm_end - vma->vm_start;
 	struct xdp_sock *xs = xdp_sk(sock->sk);
 	struct xsk_queue *q = NULL;
-	unsigned long pfn;
-	struct page *qpg;
 
 	if (READ_ONCE(xs->state) != XSK_READY)
 		return -EBUSY;
@@ -1319,13 +1317,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 
 	/* Matches the smp_wmb() in xsk_init_queue */
 	smp_rmb();
-	qpg = virt_to_head_page(q->ring);
-	if (size > page_size(qpg))
+	if (size > q->ring_vmalloc_size)
 		return -EINVAL;
 
-	pfn = virt_to_phys(q->ring) >> PAGE_SHIFT;
-	return remap_pfn_range(vma, vma->vm_start, pfn,
-			       size, vma->vm_page_prot);
+	return remap_vmalloc_range(vma, q->ring, 0);
 }
 
 static int xsk_notifier(struct notifier_block *this,
diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index 6cf9586e5027..f8905400ee07 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -6,6 +6,7 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/overflow.h>
+#include <linux/vmalloc.h>
 #include <net/xdp_sock_drv.h>
 
 #include "xsk_queue.h"
@@ -23,7 +24,6 @@ static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 {
 	struct xsk_queue *q;
-	gfp_t gfp_flags;
 	size_t size;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
@@ -33,17 +33,16 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 	q->nentries = nentries;
 	q->ring_mask = nentries - 1;
 
-	gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
-		    __GFP_COMP  | __GFP_NORETRY;
 	size = xskq_get_ring_size(q, umem_queue);
+	size = PAGE_ALIGN(size);
 
-	q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
-						      get_order(size));
+	q->ring = vmalloc_user(size);
 	if (!q->ring) {
 		kfree(q);
 		return NULL;
 	}
 
+	q->ring_vmalloc_size = size;
 	return q;
 }
 
@@ -52,6 +51,6 @@ void xskq_destroy(struct xsk_queue *q)
 	if (!q)
 		return;
 
-	page_frag_free(q->ring);
+	vfree(q->ring);
 	kfree(q);
 }
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index c6fb6b763658..bfb2a7e50c26 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -45,6 +45,7 @@ struct xsk_queue {
 	struct xdp_ring *ring;
 	u64 invalid_descs;
 	u64 queue_empty_descs;
+	size_t ring_vmalloc_size;
 };
 
 /* The structure of the shared state of the rings are a simple
-- 
2.32.0.3.g01195cf9f

