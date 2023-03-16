Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECAB6BD379
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCPP1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjCPP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EDB67011
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hvyVk2Tm5p69fLI8jM9sCOn8INezqsFYzfTdfGnmvK4=;
        b=JwxTFk+d2LnIJIRxrp2jNx8AQVkomOKQFjaTc8lDWrzxY2S4ty9fBbY0jiK6tUVM2JrgIj
        GBGMxyPAJ1Wr7qc3wVs48bsTDPZ9Qdt2IMv/IxFUG8GEyYzHY0toDWeerqj1OwIqoZ46Si
        NPHfAys7gjJ9R1R+I6BrgIs4is3SGaM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-Km8kakyRNF2yUKxaser2SQ-1; Thu, 16 Mar 2023 11:26:29 -0400
X-MC-Unique: Km8kakyRNF2yUKxaser2SQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADED738149BC;
        Thu, 16 Mar 2023 15:26:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7ACDF492B00;
        Thu, 16 Mar 2023 15:26:26 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org
Subject: [RFC PATCH 02/28] Add a special allocator for staging netfs protocol to MSG_SPLICE_PAGES
Date:   Thu, 16 Mar 2023 15:25:52 +0000
Message-Id: <20230316152618.711970-3-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a network protocol sendmsg() sees MSG_SPLICE_DATA, it expects that the
iterator is of ITER_BVEC type and that all the pages can have refs taken on
them with get_page() and discarded with put_page().  Bits of network
filesystem protocol data, however, are typically contained in slab memory
for which the cleanup method is kfree(), not put_page(), so this doesn't
work.

Provide a simple allocator, zcopy_alloc(), that allocates a page at a time
per-cpu and sequentially breaks off pieces and hands them out with a ref as
it's asked for them.  The caller disposes of the memory it was given by
calling put_page().  When a page is all parcelled out, it is abandoned by
the allocator and another page is obtained.  The page will get cleaned up
when the last skbuff fragment is destroyed.

A helper function, zcopy_memdup() is provided to call zcopy_alloc() and
copy the data it is given into it.

[!] I'm not sure this is the best way to do things.  A better way might be
    to make the network protocol look at the page and copy it if it's a
    slab object rather than taking a ref on it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Bernard Metzler <bmt@zurich.ibm.com>
cc: Tom Talpey <tom@talpey.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-rdma@vger.kernel.org
cc: netdev@vger.kernel.org
---
 include/linux/zcopy_alloc.h |  16 +++++
 mm/Makefile                 |   2 +-
 mm/zcopy_alloc.c            | 129 ++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/zcopy_alloc.h
 create mode 100644 mm/zcopy_alloc.c

diff --git a/include/linux/zcopy_alloc.h b/include/linux/zcopy_alloc.h
new file mode 100644
index 000000000000..8eb205678073
--- /dev/null
+++ b/include/linux/zcopy_alloc.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Defs for for zerocopy filler fragment allocator.
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#ifndef _LINUX_ZCOPY_ALLOC_H
+#define _LINUX_ZCOPY_ALLOC_H
+
+struct bio_vec;
+
+int zcopy_alloc(size_t size, struct bio_vec *bvec, gfp_t gfp);
+int zcopy_memdup(size_t size, const void *p, struct bio_vec *bvec, gfp_t gfp);
+
+#endif /* _LINUX_ZCOPY_ALLOC_H */
diff --git a/mm/Makefile b/mm/Makefile
index 8e105e5b3e29..3848f43751ee 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -52,7 +52,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o percpu.o slab_common.o \
-			   compaction.o \
+			   compaction.o zcopy_alloc.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o mmap_lock.o $(mmu-y)
 
diff --git a/mm/zcopy_alloc.c b/mm/zcopy_alloc.c
new file mode 100644
index 000000000000..7b219392e829
--- /dev/null
+++ b/mm/zcopy_alloc.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Allocator for zerocopy filler fragments
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Provide a facility whereby pieces of bufferage can be allocated for
+ * insertion into bio_vec arrays intended for zerocopying, allowing protocol
+ * stuff to be mixed in with data.
+ *
+ * Unlike objects allocated from the slab, the lifetime of these pieces of
+ * buffer are governed purely by the refcount of the page in which they reside.
+ */
+
+#include <linux/export.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/zcopy_alloc.h>
+#include <linux/bvec.h>
+
+struct zcopy_alloc_info {
+	struct folio	*folio;		/* Page currently being allocated from */
+	struct folio	*spare;		/* Spare page */
+	unsigned int	used;		/* Amount of folio used */
+	spinlock_t	lock;		/* Allocation lock (needs bh-disable) */
+};
+
+static struct zcopy_alloc_info __percpu *zcopy_alloc_info;
+
+static int __init zcopy_alloc_init(void)
+{
+	zcopy_alloc_info = alloc_percpu(struct zcopy_alloc_info);
+	if (!zcopy_alloc_info)
+		panic("Unable to set up zcopy_alloc allocator\n");
+	return 0;
+}
+subsys_initcall(zcopy_alloc_init);
+
+/**
+ * zcopy_alloc - Allocate some memory for use in zerocopy
+ * @size: The amount of memory (maximum 1/2 page).
+ * @bvec: Where to store the details of the memory
+ * @gfp: Allocation flags under which to make an allocation
+ *
+ * Allocate some memory for use with zerocopy where protocol bits have to be
+ * mixed in with spliced/zerocopied data.  Unlike memory allocated from the
+ * slab, this memory's lifetime is purely dependent on the folio's refcount.
+ *
+ * The way it works is that a folio is allocated and pieces are broken off
+ * sequentially and given to the allocators with a ref until it no longer has
+ * enough spare space, at which point the allocator's ref is dropped and a new
+ * folio is allocated.  The folio remains in existence until the last ref held
+ * by, say, a sk_buff is discarded and then the page is returned to the
+ * allocator.
+ *
+ * Returns 0 on success and -ENOMEM on allocation failure.  If successful, the
+ * details of the allocated memory are placed in *%bvec.
+ *
+ * The allocated memory should be disposed of with folio_put().
+ */
+int zcopy_alloc(size_t size, struct bio_vec *bvec, gfp_t gfp)
+{
+	struct zcopy_alloc_info *info;
+	struct folio *folio, *spare = NULL;
+	size_t full_size = round_up(size, 8);
+
+	if (WARN_ON_ONCE(full_size > PAGE_SIZE / 2))
+		return -ENOMEM; /* Allocate pages */
+
+try_again:
+	info = get_cpu_ptr(zcopy_alloc_info);
+
+	folio = info->folio;
+	if (folio && folio_size(folio) - info->used < full_size) {
+		folio_put(folio);
+		folio = info->folio = NULL;
+	}
+	if (spare && !info->spare) {
+		info->spare = spare;
+		spare = NULL;
+	}
+	if (!folio && info->spare) {
+		folio = info->folio = info->spare;
+		info->spare = NULL;
+		info->used = 0;
+	}
+	if (folio) {
+		bvec_set_folio(bvec, folio, size, info->used);
+		info->used += full_size;
+		if (info->used < folio_size(folio))
+			folio_get(folio);
+		else
+			info->folio = NULL;
+	}
+
+	put_cpu_ptr(zcopy_alloc_info);
+	if (folio) {
+		if (spare)
+			folio_put(spare);
+		return 0;
+	}
+
+	spare = folio_alloc(gfp, 0);
+	if (!spare)
+		return -ENOMEM;
+	goto try_again;
+}
+EXPORT_SYMBOL(zcopy_alloc);
+
+/**
+ * zcopy_memdup - Allocate some memory for use in zerocopy and fill it
+ * @size: The amount of memory to copy (maximum 1/2 page).
+ * @p: The source data to copy
+ * @bvec: Where to store the details of the memory
+ * @gfp: Allocation flags under which to make an allocation
+ */
+int zcopy_memdup(size_t size, const void *p, struct bio_vec *bvec, gfp_t gfp)
+{
+	void *q;
+
+	if (zcopy_alloc(size, bvec, gfp) < 0)
+		return -ENOMEM;
+
+	q = kmap_local_folio(page_folio(bvec->bv_page), bvec->bv_offset);
+	memcpy(q, p, size);
+	kunmap_local(q);
+	return 0;
+}
+EXPORT_SYMBOL(zcopy_memdup);

