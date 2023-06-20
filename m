Return-Path: <netdev+bounces-12274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3557736F58
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 115531C20C09
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0EF171B2;
	Tue, 20 Jun 2023 14:56:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90138171AE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:56:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0480C1B4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687272990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xe+E3y9iF5WoqF9RAoI5mIYI7LZ4lxxn5w1KkKAWiNw=;
	b=gTFd7ETFpGGAVkTWAcqvW7+J36weYkPkAJo25XxQ8RCrDEVGOmBhc7fe2Q0A39Fjj8X4j7
	zdWTV/dUXHsH4p5Epxs59bbPu/IoLlnaAnjwCDSzlposgCkHopvhTqaFi761LWYPfD8uJI
	Vao2vKUKQwQ00Au8Hp1Nn+rW0MwI2Vo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-lKmh20CrMjqnzvPqQo7SgA-1; Tue, 20 Jun 2023 10:56:26 -0400
X-MC-Unique: lKmh20CrMjqnzvPqQo7SgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24F888E6CDA;
	Tue, 20 Jun 2023 14:53:45 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FEFB2166B26;
	Tue, 20 Jun 2023 14:53:43 +0000 (UTC)
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
Subject: [PATCH net-next v3 01/18] net: Copy slab data for sendmsg(MSG_SPLICE_PAGES)
Date: Tue, 20 Jun 2023 15:53:20 +0100
Message-ID: <20230620145338.1300897-2-dhowells@redhat.com>
In-Reply-To: <20230620145338.1300897-1-dhowells@redhat.com>
References: <20230620145338.1300897-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If sendmsg() is passed MSG_SPLICE_PAGES and is given a buffer that contains
some data that's resident in the slab, copy it rather than returning EIO.
This can be made use of by a number of drivers in the kernel, including:
iwarp, ceph/rds, dlm, nvme, ocfs2, drdb.  It could also be used by iscsi,
rxrpc, sunrpc, cifs and probably others.

skb_splice_from_iter() is given it's own fragment allocator as
page_frag_alloc_align() can't be used because it does no locking to prevent
parallel callers from racing.  alloc_skb_frag() uses a separate folio for
each cpu and locks to the cpu whilst allocating, reenabling cpu migration
around folio allocation.

This could allocate a whole page instead for each fragment to be copied, as
alloc_skb_with_frags() would do instead, but that would waste a lot of
space (most of the fragments look like they're going to be small).

This allows an entire message that consists of, say, a protocol header or
two, a number of pages of data and a protocol footer to be sent using a
single call to sock_sendmsg().

The callers could be made to copy the data into fragments before calling
sendmsg(), but that then penalises them if MSG_SPLICE_PAGES gets ignored.

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

Notes:
    ver #3)
     - Remove duplicate decl of skb_splice_from_iter().
    
    ver #2)
     - Fix parameter to put_cpu_ptr() to have an '&'.

 include/linux/skbuff.h |   2 +
 net/core/skbuff.c      | 171 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 170 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 91ed66952580..5f53bd5d375d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5037,6 +5037,8 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 #endif
 }
 
+void *alloc_skb_frag(size_t fragsz, gfp_t gfp);
+void *copy_skb_frag(const void *s, size_t len, gfp_t gfp);
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize, gfp_t gfp);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fee2b1c105fe..d962c93a429d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6755,6 +6755,145 @@ nodefer:	__kfree_skb(skb);
 		smp_call_function_single_async(cpu, &sd->defer_csd);
 }
 
+struct skb_splice_frag_cache {
+	struct folio	*folio;
+	void		*virt;
+	unsigned int	offset;
+	/* we maintain a pagecount bias, so that we dont dirty cache line
+	 * containing page->_refcount every time we allocate a fragment.
+	 */
+	unsigned int	pagecnt_bias;
+	bool		pfmemalloc;
+};
+
+static DEFINE_PER_CPU(struct skb_splice_frag_cache, skb_splice_frag_cache);
+
+/**
+ * alloc_skb_frag - Allocate a page fragment for using in a socket
+ * @fragsz: The size of fragment required
+ * @gfp: Allocation flags
+ */
+void *alloc_skb_frag(size_t fragsz, gfp_t gfp)
+{
+	struct skb_splice_frag_cache *cache;
+	struct folio *folio, *spare = NULL;
+	size_t offset, fsize;
+	void *p;
+
+	if (WARN_ON_ONCE(fragsz == 0))
+		fragsz = 1;
+
+	cache = get_cpu_ptr(&skb_splice_frag_cache);
+reload:
+	folio = cache->folio;
+	offset = cache->offset;
+try_again:
+	if (fragsz > offset)
+		goto insufficient_space;
+
+	/* Make the allocation. */
+	cache->pagecnt_bias--;
+	offset = ALIGN_DOWN(offset - fragsz, SMP_CACHE_BYTES);
+	cache->offset = offset;
+	p = cache->virt + offset;
+	put_cpu_ptr(&skb_splice_frag_cache);
+	if (spare)
+		folio_put(spare);
+	return p;
+
+insufficient_space:
+	/* See if we can refurbish the current folio. */
+	if (!folio || !folio_ref_sub_and_test(folio, cache->pagecnt_bias))
+		goto get_new_folio;
+	if (unlikely(cache->pfmemalloc)) {
+		__folio_put(folio);
+		goto get_new_folio;
+	}
+
+	fsize = folio_size(folio);
+	if (unlikely(fragsz > fsize))
+		goto frag_too_big;
+
+	/* OK, page count is 0, we can safely set it */
+	folio_set_count(folio, PAGE_FRAG_CACHE_MAX_SIZE + 1);
+
+	/* Reset page count bias and offset to start of new frag */
+	cache->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
+	offset = fsize;
+	goto try_again;
+
+get_new_folio:
+	if (!spare) {
+		cache->folio = NULL;
+		put_cpu_ptr(&skb_splice_frag_cache);
+
+#if PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE
+		spare = folio_alloc(gfp | __GFP_NOWARN | __GFP_NORETRY |
+				    __GFP_NOMEMALLOC,
+				    PAGE_FRAG_CACHE_MAX_ORDER);
+		if (!spare)
+#endif
+			spare = folio_alloc(gfp, 0);
+		if (!spare)
+			return NULL;
+
+		cache = get_cpu_ptr(&skb_splice_frag_cache);
+		/* We may now be on a different cpu and/or someone else may
+		 * have refilled it
+		 */
+		cache->pfmemalloc = folio_is_pfmemalloc(spare);
+		if (cache->folio)
+			goto reload;
+	}
+
+	cache->folio = spare;
+	cache->virt  = folio_address(spare);
+	folio = spare;
+	spare = NULL;
+
+	/* Even if we own the page, we do not use atomic_set().  This would
+	 * break get_page_unless_zero() users.
+	 */
+	folio_ref_add(folio, PAGE_FRAG_CACHE_MAX_SIZE);
+
+	/* Reset page count bias and offset to start of new frag */
+	cache->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
+	offset = folio_size(folio);
+	goto try_again;
+
+frag_too_big:
+	/* The caller is trying to allocate a fragment with fragsz > PAGE_SIZE
+	 * but the cache isn't big enough to satisfy the request, this may
+	 * happen in low memory conditions.  We don't release the cache page
+	 * because it could make memory pressure worse so we simply return NULL
+	 * here.
+	 */
+	cache->offset = offset;
+	put_cpu_ptr(&skb_splice_frag_cache);
+	if (spare)
+		folio_put(spare);
+	return NULL;
+}
+EXPORT_SYMBOL(alloc_skb_frag);
+
+/**
+ * copy_skb_frag - Copy data into a page fragment.
+ * @s: The data to copy
+ * @len: The size of the data
+ * @gfp: Allocation flags
+ */
+void *copy_skb_frag(const void *s, size_t len, gfp_t gfp)
+{
+	void *p;
+
+	p = alloc_skb_frag(len, gfp);
+	if (!p)
+		return NULL;
+
+	return memcpy(p, s, len);
+}
+EXPORT_SYMBOL(copy_skb_frag);
+
 static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
 				 size_t offset, size_t len)
 {
@@ -6808,17 +6947,43 @@ ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			break;
 		}
 
+		if (space == 0 &&
+		    !skb_can_coalesce(skb, skb_shinfo(skb)->nr_frags,
+				      pages[0], off)) {
+			iov_iter_revert(iter, len);
+			break;
+		}
+
 		i = 0;
 		do {
 			struct page *page = pages[i++];
 			size_t part = min_t(size_t, PAGE_SIZE - off, len);
-
-			ret = -EIO;
-			if (WARN_ON_ONCE(!sendpage_ok(page)))
+			bool put = false;
+
+			if (PageSlab(page)) {
+				const void *p;
+				void *q;
+
+				p = kmap_local_page(page);
+				q = copy_skb_frag(p + off, part, gfp);
+				kunmap_local(p);
+				if (!q) {
+					iov_iter_revert(iter, len);
+					ret = -ENOMEM;
+					goto out;
+				}
+				page = virt_to_page(q);
+				off = offset_in_page(q);
+				put = true;
+			} else if (WARN_ON_ONCE(!sendpage_ok(page))) {
+				ret = -EIO;
 				goto out;
+			}
 
 			ret = skb_append_pagefrags(skb, page, off, part,
 						   frag_limit);
+			if (put)
+				put_page(page);
 			if (ret < 0) {
 				iov_iter_revert(iter, len);
 				goto out;


