Return-Path: <netdev+bounces-11717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF367340AF
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D58F1C20A40
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBBB8F6C;
	Sat, 17 Jun 2023 12:12:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239C6946C
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 12:12:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD1519A2
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 05:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687003944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+u30ziD9KgNs/SO68HcOpUwCa+4S9m3KYto4qjbvl9U=;
	b=eykWtD6E6OIU1C1iJ0sVwxX6DHj1MUh7/7qErr5nj4fFiLX2j254q16QOpiJ6qF4+C/dXV
	dd4NjagI6pw2iKWQX9Khoi7l0q4aYCM90r9pcXZxbllAoqGnQSB0CI7JwByf1NYxigqiM4
	zDtcnc3z7zVp0M5Fz5V0tuJGQgZPx3A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-OoK_dJyAPWWi4zKuB6nYXA-1; Sat, 17 Jun 2023 08:12:18 -0400
X-MC-Unique: OoK_dJyAPWWi4zKuB6nYXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AC0A8030B4;
	Sat, 17 Jun 2023 12:12:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A932940C2077;
	Sat, 17 Jun 2023 12:12:13 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next v2 02/17] net: Display info about MSG_SPLICE_PAGES memory handling in proc
Date: Sat, 17 Jun 2023 13:11:31 +0100
Message-ID: <20230617121146.716077-3-dhowells@redhat.com>
In-Reply-To: <20230617121146.716077-1-dhowells@redhat.com>
References: <20230617121146.716077-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Display information about the memory handling MSG_SPLICE_PAGES does to copy
slabbed data into page fragments.

For each CPU that has a cached folio, it displays the folio pfn, the offset
pointer within the folio and the size of the folio.

It also displays the number of pages refurbished and the number of pages
replaced.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Alexander Duyck <alexander.duyck@gmail.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: David Ahern <dsahern@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: Menglong Dong <imagedong@tencent.com>
cc: netdev@vger.kernel.org
---
 net/core/skbuff.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d962c93a429d..36605510a76d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -83,6 +83,7 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 #include <linux/textsearch.h>
+#include <linux/proc_fs.h>
 
 #include "dev.h"
 #include "sock_destructor.h"
@@ -6758,6 +6759,7 @@ nodefer:	__kfree_skb(skb);
 struct skb_splice_frag_cache {
 	struct folio	*folio;
 	void		*virt;
+	unsigned int	fsize;
 	unsigned int	offset;
 	/* we maintain a pagecount bias, so that we dont dirty cache line
 	 * containing page->_refcount every time we allocate a fragment.
@@ -6767,6 +6769,26 @@ struct skb_splice_frag_cache {
 };
 
 static DEFINE_PER_CPU(struct skb_splice_frag_cache, skb_splice_frag_cache);
+static atomic_t skb_splice_frag_replaced, skb_splice_frag_refurbished;
+
+static int skb_splice_show(struct seq_file *m, void *data)
+{
+	int cpu;
+
+	seq_printf(m, "refurb=%u repl=%u\n",
+		   atomic_read(&skb_splice_frag_refurbished),
+		   atomic_read(&skb_splice_frag_replaced));
+
+	for_each_possible_cpu(cpu) {
+		const struct skb_splice_frag_cache *cache =
+			per_cpu_ptr(&skb_splice_frag_cache, cpu);
+
+		seq_printf(m, "[%u] %lx %u/%u\n",
+			   cpu, folio_pfn(cache->folio),
+			   cache->offset, cache->fsize);
+	}
+	return 0;
+}
 
 /**
  * alloc_skb_frag - Allocate a page fragment for using in a socket
@@ -6803,17 +6825,21 @@ void *alloc_skb_frag(size_t fragsz, gfp_t gfp)
 
 insufficient_space:
 	/* See if we can refurbish the current folio. */
-	if (!folio || !folio_ref_sub_and_test(folio, cache->pagecnt_bias))
+	if (!folio)
 		goto get_new_folio;
+	if (!folio_ref_sub_and_test(folio, cache->pagecnt_bias))
+		goto replace_folio;
 	if (unlikely(cache->pfmemalloc)) {
 		__folio_put(folio);
-		goto get_new_folio;
+		goto replace_folio;
 	}
 
 	fsize = folio_size(folio);
 	if (unlikely(fragsz > fsize))
 		goto frag_too_big;
 
+	atomic_inc(&skb_splice_frag_refurbished);
+
 	/* OK, page count is 0, we can safely set it */
 	folio_set_count(folio, PAGE_FRAG_CACHE_MAX_SIZE + 1);
 
@@ -6822,6 +6848,8 @@ void *alloc_skb_frag(size_t fragsz, gfp_t gfp)
 	offset = fsize;
 	goto try_again;
 
+replace_folio:
+	atomic_inc(&skb_splice_frag_replaced);
 get_new_folio:
 	if (!spare) {
 		cache->folio = NULL;
@@ -6848,6 +6876,7 @@ void *alloc_skb_frag(size_t fragsz, gfp_t gfp)
 
 	cache->folio = spare;
 	cache->virt  = folio_address(spare);
+	cache->fsize = folio_size(spare);
 	folio = spare;
 	spare = NULL;
 
@@ -6858,7 +6887,7 @@ void *alloc_skb_frag(size_t fragsz, gfp_t gfp)
 
 	/* Reset page count bias and offset to start of new frag */
 	cache->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
-	offset = folio_size(folio);
+	offset = cache->fsize;
 	goto try_again;
 
 frag_too_big:
@@ -7007,3 +7036,10 @@ ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 	return spliced ?: ret;
 }
 EXPORT_SYMBOL(skb_splice_from_iter);
+
+static int skb_splice_init(void)
+{
+	proc_create_single("pagefrags", S_IFREG | 0444, NULL, &skb_splice_show);
+	return 0;
+}
+late_initcall(skb_splice_init);


