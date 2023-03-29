Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807766CDBC7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjC2OQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjC2OQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:16:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59459E3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKmPIBLTzwmxTywoQlbWhVqEAglt5Diim843HzqnLOY=;
        b=hBQpR6Bt84wr3e9vA9QALa3Zoga0PWs22MbfIserQehZSmB/4N2nEOF6HzC5TYmIbuTM+h
        /bYQpE6hSybDfrQ8emd9wuGndvitE4cuxS4IUDX9Y3+KC39yMgkZvgqYUjIKh0wJs9s3rt
        SA5EYhtU2+ytMSnvoVsRtkP6vDvD0EU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-y_B6QV2XMFK1PdJabznHmQ-1; Wed, 29 Mar 2023 10:14:09 -0400
X-MC-Unique: y_B6QV2XMFK1PdJabznHmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93F51381459A;
        Wed, 29 Mar 2023 14:14:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B2C718EC2;
        Wed, 29 Mar 2023 14:14:05 +0000 (UTC)
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
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org
Subject: [RFC PATCH v2 03/48] iov_iter: Add an iterator-of-iterators
Date:   Wed, 29 Mar 2023 15:13:09 +0100
Message-Id: <20230329141354.516864-4-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new I/O iterator type, ITER_ITERLIST, that allows iteration over a
series of I/O iterators, provided the iterators are all the same direction
(all ITER_SOURCE or all ITER_DEST) and none of them are themselves
ITER_ITERLIST (this function is recursive).

To make reversion possible, I've added an 'orig_count' member into the
iov_iter struct so that reversion of an ITER_ITERLIST can know when to go
move backwards through the iter list.  It might make more sense to make the
iterator list element, say:

	struct itervec {
		struct iov_iter iter;
		size_t orig_count;
	};

rather than expanding struct iov_iter itself and have iov_iter_iterlist()
set vec[i].orig_count from vec[i].iter->count.

Also, for the moment, I've only permitted its use with source iterators
(eg. sendmsg).

To use this, you allocate an array of iterators and point the list iterator
at it, e.g.:

	struct iov_iter iters[3];
	struct msghdr msg;

	iov_iter_bvec(&iters[0], ITER_SOURCE, &head_bv, 1,
		      sizeof(marker) + head->iov_len);
	iov_iter_xarray(&iters[1], ITER_SOURCE, xdr->pages,
			xdr->page_fpos, xdr->page_len);
	iov_iter_kvec(&iters[2], ITER_SOURCE, &tail_kv, 1,
		      tail->iov_len);
	iov_iter_iterlist(&msg.msg_iter, ITER_SOURCE, iters, 3, size);

This can be used by network filesystem protocols, such as sunrpc, to glue a
header and a trailer on to some data to form a message and then dump the
entire message onto the socket in a single go.

[!] Note: I'm not entirely sure that this is a good idea: the problem is
    that it's reasonably common practice to copy an iterator by direct
    assignment - and that works for the existing iterators... but not this
    one.  With the iterator-of-iterators, the list of iterators has to be
    modified if we recurse.  It's probably fine just for calling sendmsg()
    from network filesystems, but I'm not 100% sure of that.

Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <trond.myklebust@hammerspace.com>
cc: Anna Schumaker <anna@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: Alexander Viro <viro@zeniv.linux.org.uk>
cc: Jeff Layton <jlayton@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-nfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
cc: netdev@vger.kernel.org
---
 include/linux/uio.h |  13 ++-
 lib/iov_iter.c      | 254 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 260 insertions(+), 7 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2d8a70cb9b26..6c75c94566b8 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -27,6 +27,7 @@ enum iter_type {
 	ITER_XARRAY,
 	ITER_DISCARD,
 	ITER_UBUF,
+	ITER_ITERLIST,
 };
 
 #define ITER_SOURCE	1	// == WRITE
@@ -45,12 +46,14 @@ struct iov_iter {
 	bool user_backed;
 	size_t iov_offset;
 	size_t count;
+	size_t orig_count;
 	union {
 		const struct iovec *iov;
 		const struct kvec *kvec;
 		const struct bio_vec *bvec;
 		struct xarray *xarray;
 		void __user *ubuf;
+		struct iov_iter *iterlist;
 	};
 	union {
 		unsigned long nr_segs;
@@ -101,6 +104,11 @@ static inline bool iov_iter_is_xarray(const struct iov_iter *i)
 	return iov_iter_type(i) == ITER_XARRAY;
 }
 
+static inline bool iov_iter_is_iterlist(const struct iov_iter *i)
+{
+	return iov_iter_type(i) == ITER_ITERLIST;
+}
+
 static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 {
 	return i->data_source ? WRITE : READ;
@@ -235,6 +243,8 @@ void iov_iter_bvec(struct iov_iter *i, unsigned int direction, const struct bio_
 void iov_iter_discard(struct iov_iter *i, unsigned int direction, size_t count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
 		     loff_t start, size_t count);
+void iov_iter_iterlist(struct iov_iter *i, unsigned int direction, struct iov_iter *iterlist,
+		       unsigned long nr_segs, size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 		size_t maxsize, unsigned maxpages, size_t *start,
 		iov_iter_extraction_t extraction_flags);
@@ -342,7 +352,8 @@ static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direction,
 		.user_backed = true,
 		.data_source = direction,
 		.ubuf = buf,
-		.count = count
+		.count = count,
+		.orig_count = count,
 	};
 }
 /* Flags for iov_iter_get/extract_pages*() */
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index fad95e4cf372..8a9ae4af45fc 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -282,7 +282,8 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 		.iov = iov,
 		.nr_segs = nr_segs,
 		.iov_offset = 0,
-		.count = count
+		.count = count,
+		.orig_count = count,
 	};
 }
 EXPORT_SYMBOL(iov_iter_init);
@@ -364,6 +365,26 @@ size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 
+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied = 0;
+
+		while (bytes && i->count) {
+			size_t part = min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n = _copy_from_iter(addr, part, i->iterlist);
+			addr += n;
+			copied += n;
+			bytes -= n;
+			i->count -= n;
+			if (n < part || !bytes)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		return copied;
+	}
+
 	if (user_backed_iter(i))
 		might_fault();
 	iterate_and_advance(i, bytes, base, len, off,
@@ -380,6 +401,27 @@ size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 
+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied = 0;
+
+		while (bytes && i->count) {
+			size_t part = min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n = _copy_from_iter_nocache(addr, part,
+							    i->iterlist);
+			addr += n;
+			copied += n;
+			bytes -= n;
+			i->count -= n;
+			if (n < part || !bytes)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		return copied;
+	}
+
 	iterate_and_advance(i, bytes, base, len, off,
 		__copy_from_user_inatomic_nocache(addr + off, base, len),
 		memcpy(addr + off, base, len)
@@ -411,6 +453,27 @@ size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 
+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied = 0;
+
+		while (bytes && i->count) {
+			size_t part = min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n = _copy_from_iter_flushcache(addr, part,
+							       i->iterlist);
+			addr += n;
+			copied += n;
+			bytes -= n;
+			i->count -= n;
+			if (n < part || !bytes)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		return copied;
+	}
+
 	iterate_and_advance(i, bytes, base, len, off,
 		__copy_from_user_flushcache(addr + off, base, len),
 		memcpy_flushcache(addr + off, base, len)
@@ -514,7 +577,31 @@ EXPORT_SYMBOL(iov_iter_zero);
 size_t copy_page_from_iter_atomic(struct page *page, unsigned offset, size_t bytes,
 				  struct iov_iter *i)
 {
-	char *kaddr = kmap_atomic(page), *p = kaddr + offset;
+	char *kaddr, *p;
+
+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied = 0;
+
+		while (bytes && i->count) {
+			size_t part = min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n = copy_page_from_iter_atomic(page, offset, part,
+							       i->iterlist);
+			offset += n;
+			copied += n;
+			bytes -= n;
+			i->count -= n;
+			if (n < part || !bytes)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		return copied;
+	}
+
+	kaddr = kmap_atomic(page);
+	p = kaddr + offset;
 	if (!page_copy_sane(page, offset, bytes)) {
 		kunmap_atomic(kaddr);
 		return 0;
@@ -585,19 +672,49 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		iov_iter_bvec_advance(i, size);
 	} else if (iov_iter_is_discard(i)) {
 		i->count -= size;
+	}else if (iov_iter_is_iterlist(i)) {
+		i->count -= size;
+		for (;;) {
+			size_t part = min(size, i->iterlist->count);
+
+			if (part > 0)
+				iov_iter_advance(i->iterlist, part);
+			size -= part;
+			if (!size)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
 	}
 }
 EXPORT_SYMBOL(iov_iter_advance);
 
+static void iov_iter_revert_iterlist(struct iov_iter *i, size_t unroll)
+{
+	for (;;) {
+		size_t part = min(unroll, i->iterlist->orig_count - i->iterlist->count);
+
+		if (part > 0)
+			iov_iter_revert(i->iterlist, part);
+		unroll -= part;
+		if (!unroll)
+			break;
+		i->iterlist--;
+		i->nr_segs++;
+	}
+}
+
 void iov_iter_revert(struct iov_iter *i, size_t unroll)
 {
 	if (!unroll)
 		return;
-	if (WARN_ON(unroll > MAX_RW_COUNT))
+	if (WARN_ON(unroll > i->orig_count - i->count))
 		return;
 	i->count += unroll;
 	if (unlikely(iov_iter_is_discard(i)))
 		return;
+	if (unlikely(iov_iter_is_iterlist(i)))
+		return iov_iter_revert_iterlist(i, unroll);
 	if (unroll <= i->iov_offset) {
 		i->iov_offset -= unroll;
 		return;
@@ -641,6 +758,8 @@ EXPORT_SYMBOL(iov_iter_revert);
  */
 size_t iov_iter_single_seg_count(const struct iov_iter *i)
 {
+	if (iov_iter_is_iterlist(i))
+		i = i->iterlist;
 	if (i->nr_segs > 1) {
 		if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i)))
 			return min(i->count, i->iov->iov_len - i->iov_offset);
@@ -662,7 +781,8 @@ void iov_iter_kvec(struct iov_iter *i, unsigned int direction,
 		.kvec = kvec,
 		.nr_segs = nr_segs,
 		.iov_offset = 0,
-		.count = count
+		.count = count,
+		.orig_count = count,
 	};
 }
 EXPORT_SYMBOL(iov_iter_kvec);
@@ -678,7 +798,8 @@ void iov_iter_bvec(struct iov_iter *i, unsigned int direction,
 		.bvec = bvec,
 		.nr_segs = nr_segs,
 		.iov_offset = 0,
-		.count = count
+		.count = count,
+		.orig_count = count,
 	};
 }
 EXPORT_SYMBOL(iov_iter_bvec);
@@ -706,6 +827,7 @@ void iov_iter_xarray(struct iov_iter *i, unsigned int direction,
 		.xarray = xarray,
 		.xarray_start = start,
 		.count = count,
+		.orig_count = count,
 		.iov_offset = 0
 	};
 }
@@ -727,11 +849,47 @@ void iov_iter_discard(struct iov_iter *i, unsigned int direction, size_t count)
 		.iter_type = ITER_DISCARD,
 		.data_source = false,
 		.count = count,
+		.orig_count = count,
 		.iov_offset = 0
 	};
 }
 EXPORT_SYMBOL(iov_iter_discard);
 
+/**
+ * iov_iter_iterlist - Initialise an I/O iterator that is a list of iterators
+ * @iter: The iterator to initialise.
+ * @direction: The direction of the transfer.
+ * @iterlist: The list of iterators
+ * @nr_segs: The number of elements in the list
+ * @count: The size of the I/O buffer in bytes.
+ *
+ * Set up an I/O iterator that just discards everything that's written to it.
+ * It's only available as a source iterator (for WRITE), all the iterators in
+ * the list must be the same and none of them can be ITER_ITERLIST type.
+ */
+void iov_iter_iterlist(struct iov_iter *iter, unsigned int direction,
+		       struct iov_iter *iterlist, unsigned long nr_segs,
+		       size_t count)
+{
+	unsigned long i;
+
+	BUG_ON(direction != WRITE);
+	for (i = 0; i < nr_segs; i++) {
+		BUG_ON(iterlist[i].iter_type == ITER_ITERLIST);
+		BUG_ON(!iterlist[i].data_source);
+	}
+
+	*iter = (struct iov_iter){
+		.iter_type	= ITER_ITERLIST,
+		.data_source	= true,
+		.count		= count,
+		.orig_count	= count,
+		.iterlist	= iterlist,
+		.nr_segs	= nr_segs,
+	};
+}
+EXPORT_SYMBOL(iov_iter_iterlist);
+
 static bool iov_iter_aligned_iovec(const struct iov_iter *i, unsigned addr_mask,
 				   unsigned len_mask)
 {
@@ -879,6 +1037,15 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 	if (iov_iter_is_xarray(i))
 		return (i->xarray_start + i->iov_offset) | i->count;
 
+	if (iov_iter_is_iterlist(i)) {
+		unsigned long align = 0;
+		unsigned int j;
+
+		for (j = 0; j < i->nr_segs; j++)
+			align |= iov_iter_alignment(&i->iterlist[j]);
+		return align;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(iov_iter_alignment);
@@ -1078,6 +1245,18 @@ static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 	}
 	if (iov_iter_is_xarray(i))
 		return iter_xarray_get_pages(i, pages, maxsize, maxpages, start);
+	if (iov_iter_is_iterlist(i)) {
+		ssize_t size;
+
+		while (!i->iterlist->count) {
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		size = __iov_iter_get_pages_alloc(i->iterlist, pages, maxsize, maxpages,
+						  start, extraction_flags);
+		i->count -= size;
+		return size;
+	}
 	return -EFAULT;
 }
 
@@ -1126,6 +1305,31 @@ ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i,
 }
 EXPORT_SYMBOL(iov_iter_get_pages_alloc2);
 
+static size_t csum_and_copy_from_iterlist(void *addr, size_t bytes, __wsum *csum,
+					  struct iov_iter *i)
+{
+	size_t copied = 0, n;
+
+	while (i->count && i->nr_segs) {
+		struct iov_iter *j = i->iterlist;
+
+		if (j->count == 0) {
+			i->iterlist++;
+			i->nr_segs--;
+			continue;
+		}
+
+		n = csum_and_copy_from_iter(addr, bytes - copied, csum, j);
+		addr += n;
+		copied += n;
+		i->count -= n;
+		if (n == 0)
+			break;
+	}
+
+	return copied;
+}
+
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 			       struct iov_iter *i)
 {
@@ -1133,6 +1337,8 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 	sum = *csum;
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
+	if (iov_iter_is_iterlist(i))
+		return csum_and_copy_from_iterlist(addr, bytes, csum, i);
 
 	iterate_and_advance(i, bytes, base, len, off, ({
 		next = csum_and_copy_from_user(base, addr + off, len);
@@ -1236,6 +1442,21 @@ static int bvec_npages(const struct iov_iter *i, int maxpages)
 	return npages;
 }
 
+static int iterlist_npages(const struct iov_iter *i, int maxpages)
+{
+	ssize_t size = i->count;
+	const struct iov_iter *p;
+	int npages = 0;
+
+	for (p = i->iterlist; size; p++) {
+		size -= p->count;
+		npages += iov_iter_npages(p, maxpages - npages);
+		if (unlikely(npages >= maxpages))
+			return maxpages;
+	}
+	return npages;
+}
+
 int iov_iter_npages(const struct iov_iter *i, int maxpages)
 {
 	if (unlikely(!i->count))
@@ -1255,6 +1476,8 @@ int iov_iter_npages(const struct iov_iter *i, int maxpages)
 		int npages = DIV_ROUND_UP(offset + i->count, PAGE_SIZE);
 		return min(npages, maxpages);
 	}
+	if (iov_iter_is_iterlist(i))
+		return iterlist_npages(i, maxpages);
 	return 0;
 }
 EXPORT_SYMBOL(iov_iter_npages);
@@ -1266,11 +1489,14 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 		return new->bvec = kmemdup(new->bvec,
 				    new->nr_segs * sizeof(struct bio_vec),
 				    flags);
-	else if (iov_iter_is_kvec(new) || iter_is_iovec(new))
+	if (iov_iter_is_kvec(new) || iter_is_iovec(new))
 		/* iovec and kvec have identical layout */
 		return new->iov = kmemdup(new->iov,
 				   new->nr_segs * sizeof(struct iovec),
 				   flags);
+	if (WARN_ON_ONCE(iov_iter_is_iterlist(old)))
+		/* Don't allow dup'ing of iterlist as the cleanup is complicated */
+		return NULL;
 	return NULL;
 }
 EXPORT_SYMBOL(dup_iter);
@@ -1759,6 +1985,22 @@ ssize_t iov_iter_extract_pages(struct iov_iter *i,
 		return iov_iter_extract_xarray_pages(i, pages, maxsize,
 						     maxpages, extraction_flags,
 						     offset0);
+	if (iov_iter_is_iterlist(i)) {
+		ssize_t size;
+
+		while (i->nr_segs && !i->iterlist->count) {
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		if (!i->nr_segs) {
+			WARN_ON_ONCE(i->count);
+			return 0;
+		}
+		size = iov_iter_extract_pages(i->iterlist, pages, maxsize, maxpages,
+					      extraction_flags, offset0);
+		i->count -= size;
+		return size;
+	}
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(iov_iter_extract_pages);

