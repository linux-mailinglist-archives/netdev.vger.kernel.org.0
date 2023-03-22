Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5986C537B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjCVSRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjCVSQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A25067008
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679508953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bAxnqs+Ogn6qo/OhRrl9BnE7xhQCbwUnC+atvsz6j8g=;
        b=c6fb8ZG1cggR7yDufSETARCPxAVqvwbg1Pe8cJ1CqGGaXK5v9RQ0xjuAgqMEq7G2oxLDlz
        j2JO6ClYEET1w3hgmPhsxoDFGDEz+ZUJcVkyLu/eEhKdz8IaWaqorz/JYw7IqaENOxUqiy
        lE/mkiF6KTV3ndBCDwuvxLeocVMLUTU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-nUwhuDkVOwezAETRkcIqyQ-1; Wed, 22 Mar 2023 14:15:49 -0400
X-MC-Unique: nUwhuDkVOwezAETRkcIqyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63FF48028B3;
        Wed, 22 Mar 2023 18:15:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C240A1121314;
        Wed, 22 Mar 2023 18:15:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com>
References: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com> <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com> <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com> <20230316152618.711970-1-dhowells@redhat.com> <20230316152618.711970-28-dhowells@redhat.com> <754534.1678983891@warthog.procyon.org.uk> <809995.1678990010@warthog.procyon.org.uk>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffrey Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Anna Schumaker <anna@kernel.org>,
        Charles Edward Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: [RFC PATCH] iov_iter: Add an iterator-of-iterators
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3416399.1679508945.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 22 Mar 2023 18:15:45 +0000
Message-ID: <3416400.1679508945@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trond Myklebust <trondmy@hammerspace.com> wrote:

> Add an enum iter_type for ITER_ITER ? :-)

Well, you asked for it...  It's actually fairly straightforward once
ITER_PIPE is removed.

---
iov_iter: Add an iterator-of-iterators

Provide an I/O iterator that takes an array of iterators and iterates over
them in turn.  Then make the sunrpc service code (and thus nfsd) use it.

In this particular instance, the svc_tcp_sendmsg() sets up an array of
three iterators: once for the marker+header, one for the body and one
optional one for the tail, then sets msg_iter to be an
iterator-of-iterators across them.

Signed-off-by: David Howells <dhowells@redhat.com>
---    =

 include/linux/uio.h  |   19 +++-
 lib/iov_iter.c       |  233 +++++++++++++++++++++++++++++++++++++++++++++=
++++--
 net/sunrpc/svcsock.c |   29 +++---
 3 files changed, 258 insertions(+), 23 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 74598426edb4..321381d3d616 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -27,6 +27,7 @@ enum iter_type {
 	ITER_XARRAY,
 	ITER_DISCARD,
 	ITER_UBUF,
+	ITER_ITERLIST,
 };
 =

 #define ITER_SOURCE	1	// =3D=3D WRITE
@@ -43,17 +44,17 @@ struct iov_iter {
 	bool nofault;
 	bool data_source;
 	bool user_backed;
-	union {
-		size_t iov_offset;
-		int last_offset;
-	};
+	bool spliceable;
+	size_t iov_offset;
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
@@ -104,6 +105,11 @@ static inline bool iov_iter_is_xarray(const struct io=
v_iter *i)
 	return iov_iter_type(i) =3D=3D ITER_XARRAY;
 }
 =

+static inline bool iov_iter_is_iterlist(const struct iov_iter *i)
+{
+	return iov_iter_type(i) =3D=3D ITER_ITERLIST;
+}
+
 static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 {
 	return i->data_source ? WRITE : READ;
@@ -238,6 +244,8 @@ void iov_iter_bvec(struct iov_iter *i, unsigned int di=
rection, const struct bio_
 void iov_iter_discard(struct iov_iter *i, unsigned int direction, size_t =
count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct x=
array *xarray,
 		     loff_t start, size_t count);
+void iov_iter_iterlist(struct iov_iter *i, unsigned int direction, struct=
 iov_iter *iterlist,
+		       unsigned long nr_segs, size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 		size_t maxsize, unsigned maxpages, size_t *start,
 		iov_iter_extraction_t extraction_flags);
@@ -345,7 +353,8 @@ static inline void iov_iter_ubuf(struct iov_iter *i, u=
nsigned int direction,
 		.user_backed =3D true,
 		.data_source =3D direction,
 		.ubuf =3D buf,
-		.count =3D count
+		.count =3D count,
+		.orig_count =3D count,
 	};
 }
 /* Flags for iov_iter_get/extract_pages*() */
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index fad95e4cf372..34ce3b958b6c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -282,7 +282,8 @@ void iov_iter_init(struct iov_iter *i, unsigned int di=
rection,
 		.iov =3D iov,
 		.nr_segs =3D nr_segs,
 		.iov_offset =3D 0,
-		.count =3D count
+		.count =3D count,
+		.orig_count =3D count,
 	};
 }
 EXPORT_SYMBOL(iov_iter_init);
@@ -364,6 +365,26 @@ size_t _copy_from_iter(void *addr, size_t bytes, stru=
ct iov_iter *i)
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 =

+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied =3D 0;
+
+		while (bytes && i->count) {
+			size_t part =3D min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n =3D _copy_from_iter(addr, part, i->iterlist);
+			addr +=3D n;
+			copied +=3D n;
+			bytes -=3D n;
+			i->count -=3D n;
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
@@ -380,6 +401,27 @@ size_t _copy_from_iter_nocache(void *addr, size_t byt=
es, struct iov_iter *i)
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 =

+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied =3D 0;
+
+		while (bytes && i->count) {
+			size_t part =3D min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n =3D _copy_from_iter_nocache(addr, part,
+							    i->iterlist);
+			addr +=3D n;
+			copied +=3D n;
+			bytes -=3D n;
+			i->count -=3D n;
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
@@ -411,6 +453,27 @@ size_t _copy_from_iter_flushcache(void *addr, size_t =
bytes, struct iov_iter *i)
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 =

+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied =3D 0;
+
+		while (bytes && i->count) {
+			size_t part =3D min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n =3D _copy_from_iter_flushcache(addr, part,
+							       i->iterlist);
+			addr +=3D n;
+			copied +=3D n;
+			bytes -=3D n;
+			i->count -=3D n;
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
 size_t copy_page_from_iter_atomic(struct page *page, unsigned offset, siz=
e_t bytes,
 				  struct iov_iter *i)
 {
-	char *kaddr =3D kmap_atomic(page), *p =3D kaddr + offset;
+	char *kaddr, *p;
+
+	if (unlikely(iov_iter_is_iterlist(i))) {
+		size_t copied =3D 0;
+
+		while (bytes && i->count) {
+			size_t part =3D min(bytes, i->iterlist->count), n;
+
+			if (part > 0)
+				n =3D copy_page_from_iter_atomic(page, offset, part,
+							       i->iterlist);
+			offset +=3D n;
+			copied +=3D n;
+			bytes -=3D n;
+			i->count -=3D n;
+			if (n < part || !bytes)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
+		return copied;
+	}
+
+	kaddr =3D kmap_atomic(page);
+	p =3D kaddr + offset;
 	if (!page_copy_sane(page, offset, bytes)) {
 		kunmap_atomic(kaddr);
 		return 0;
@@ -585,19 +672,49 @@ void iov_iter_advance(struct iov_iter *i, size_t siz=
e)
 		iov_iter_bvec_advance(i, size);
 	} else if (iov_iter_is_discard(i)) {
 		i->count -=3D size;
+	}else if (iov_iter_is_iterlist(i)) {
+		i->count -=3D size;
+		for (;;) {
+			size_t part =3D min(size, i->iterlist->count);
+
+			if (part > 0)
+				iov_iter_advance(i->iterlist, part);
+			size -=3D part;
+			if (!size)
+				break;
+			i->iterlist++;
+			i->nr_segs--;
+		}
 	}
 }
 EXPORT_SYMBOL(iov_iter_advance);
 =

+static void iov_iter_revert_iterlist(struct iov_iter *i, size_t unroll)
+{
+	for (;;) {
+		size_t part =3D min(unroll, i->iterlist->orig_count - i->iterlist->coun=
t);
+
+		if (part > 0)
+			iov_iter_revert(i->iterlist, part);
+		unroll -=3D part;
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
 	i->count +=3D unroll;
 	if (unlikely(iov_iter_is_discard(i)))
 		return;
+	if (unlikely(iov_iter_is_iterlist(i)))
+		return iov_iter_revert_iterlist(i, unroll);
 	if (unroll <=3D i->iov_offset) {
 		i->iov_offset -=3D unroll;
 		return;
@@ -641,6 +758,8 @@ EXPORT_SYMBOL(iov_iter_revert);
  */
 size_t iov_iter_single_seg_count(const struct iov_iter *i)
 {
+	if (iov_iter_is_iterlist(i))
+		i =3D i->iterlist;
 	if (i->nr_segs > 1) {
 		if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i)))
 			return min(i->count, i->iov->iov_len - i->iov_offset);
@@ -662,7 +781,8 @@ void iov_iter_kvec(struct iov_iter *i, unsigned int di=
rection,
 		.kvec =3D kvec,
 		.nr_segs =3D nr_segs,
 		.iov_offset =3D 0,
-		.count =3D count
+		.count =3D count,
+		.orig_count =3D count,
 	};
 }
 EXPORT_SYMBOL(iov_iter_kvec);
@@ -678,7 +798,8 @@ void iov_iter_bvec(struct iov_iter *i, unsigned int di=
rection,
 		.bvec =3D bvec,
 		.nr_segs =3D nr_segs,
 		.iov_offset =3D 0,
-		.count =3D count
+		.count =3D count,
+		.orig_count =3D count,
 	};
 }
 EXPORT_SYMBOL(iov_iter_bvec);
@@ -706,6 +827,7 @@ void iov_iter_xarray(struct iov_iter *i, unsigned int =
direction,
 		.xarray =3D xarray,
 		.xarray_start =3D start,
 		.count =3D count,
+		.orig_count =3D count,
 		.iov_offset =3D 0
 	};
 }
@@ -727,11 +849,47 @@ void iov_iter_discard(struct iov_iter *i, unsigned i=
nt direction, size_t count)
 		.iter_type =3D ITER_DISCARD,
 		.data_source =3D false,
 		.count =3D count,
+		.orig_count =3D count,
 		.iov_offset =3D 0
 	};
 }
 EXPORT_SYMBOL(iov_iter_discard);
 =

+/**
+ * iov_iter_iterlist - Initialise an I/O iterator that is a list of itera=
tors
+ * @iter: The iterator to initialise.
+ * @direction: The direction of the transfer.
+ * @iterlist: The list of iterators
+ * @nr_segs: The number of elements in the list
+ * @count: The size of the I/O buffer in bytes.
+ *
+ * Set up an I/O iterator that just discards everything that's written to=
 it.
+ * It's only available as a source iterator (for WRITE), all the iterator=
s in
+ * the list must be the same and none of them can be ITER_ITERLIST type.
+ */
+void iov_iter_iterlist(struct iov_iter *iter, unsigned int direction,
+		       struct iov_iter *iterlist, unsigned long nr_segs,
+		       size_t count)
+{
+	unsigned long i;
+
+	BUG_ON(direction !=3D WRITE);
+	for (i =3D 0; i < nr_segs; i++) {
+		BUG_ON(iterlist[i].iter_type =3D=3D ITER_ITERLIST);
+		BUG_ON(!iterlist[i].data_source);
+	}
+
+	*iter =3D (struct iov_iter){
+		.iter_type	=3D ITER_ITERLIST,
+		.data_source	=3D true,
+		.count		=3D count,
+		.orig_count	=3D count,
+		.iterlist	=3D iterlist,
+		.nr_segs	=3D nr_segs,
+	};
+}
+EXPORT_SYMBOL(iov_iter_iterlist);
+
 static bool iov_iter_aligned_iovec(const struct iov_iter *i, unsigned add=
r_mask,
 				   unsigned len_mask)
 {
@@ -879,6 +1037,15 @@ unsigned long iov_iter_alignment(const struct iov_it=
er *i)
 	if (iov_iter_is_xarray(i))
 		return (i->xarray_start + i->iov_offset) | i->count;
 =

+	if (iov_iter_is_iterlist(i)) {
+		unsigned long align =3D 0;
+		unsigned int j;
+
+		for (j =3D 0; j < i->nr_segs; j++)
+			align |=3D iov_iter_alignment(&i->iterlist[j]);
+		return align;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(iov_iter_alignment);
@@ -1078,6 +1245,18 @@ static ssize_t __iov_iter_get_pages_alloc(struct io=
v_iter *i,
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
+		size =3D __iov_iter_get_pages_alloc(i->iterlist, pages, maxsize, maxpag=
es,
+						  start, extraction_flags);
+		i->count -=3D size;
+		return size;
+	}
 	return -EFAULT;
 }
 =

@@ -1126,6 +1305,31 @@ ssize_t iov_iter_get_pages_alloc2(struct iov_iter *=
i,
 }
 EXPORT_SYMBOL(iov_iter_get_pages_alloc2);
 =

+static size_t csum_and_copy_from_iterlist(void *addr, size_t bytes, __wsu=
m *csum,
+					  struct iov_iter *i)
+{
+	size_t copied =3D 0, n;
+
+	while (i->count && i->nr_segs) {
+		struct iov_iter *j =3D i->iterlist;
+
+		if (j->count =3D=3D 0) {
+			i->iterlist++;
+			i->nr_segs--;
+			continue;
+		}
+
+		n =3D csum_and_copy_from_iter(addr, bytes - copied, csum, j);
+		addr +=3D n;
+		copied +=3D n;
+		i->count -=3D n;
+		if (n =3D=3D 0)
+			break;
+	}
+
+	return copied;
+}
+
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 			       struct iov_iter *i)
 {
@@ -1133,6 +1337,8 @@ size_t csum_and_copy_from_iter(void *addr, size_t by=
tes, __wsum *csum,
 	sum =3D *csum;
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
+	if (iov_iter_is_iterlist(i))
+		return csum_and_copy_from_iterlist(addr, bytes, csum, i);
 =

 	iterate_and_advance(i, bytes, base, len, off, ({
 		next =3D csum_and_copy_from_user(base, addr + off, len);
@@ -1236,6 +1442,21 @@ static int bvec_npages(const struct iov_iter *i, in=
t maxpages)
 	return npages;
 }
 =

+static int iterlist_npages(const struct iov_iter *i, int maxpages)
+{
+	ssize_t size =3D i->count;
+	const struct iov_iter *p;
+	int npages =3D 0;
+
+	for (p =3D i->iterlist; size; p++) {
+		size -=3D p->count;
+		npages +=3D iov_iter_npages(p, maxpages - npages);
+		if (unlikely(npages >=3D maxpages))
+			return maxpages;
+	}
+	return npages;
+}
+
 int iov_iter_npages(const struct iov_iter *i, int maxpages)
 {
 	if (unlikely(!i->count))
@@ -1255,6 +1476,8 @@ int iov_iter_npages(const struct iov_iter *i, int ma=
xpages)
 		int npages =3D DIV_ROUND_UP(offset + i->count, PAGE_SIZE);
 		return min(npages, maxpages);
 	}
+	if (iov_iter_is_iterlist(i))
+		return iterlist_npages(i, maxpages);
 	return 0;
 }
 EXPORT_SYMBOL(iov_iter_npages);
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 1d0f0f764e16..030a1fa5171b 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1073,11 +1073,13 @@ static int svc_tcp_sendmsg(struct socket *sock, st=
ruct xdr_buf *xdr,
 {
 	const struct kvec *head =3D xdr->head;
 	const struct kvec *tail =3D xdr->tail;
+	struct iov_iter iters[3];
+	struct bio_vec head_bv, tail_bv;
 	struct msghdr msg =3D {
-		.msg_flags	=3D MSG_SPLICE_PAGES,
+		.msg_flags	=3D 0, //MSG_SPLICE_PAGES,
 	};
-	void *m, *h, *t;
-	int ret, n =3D xdr_buf_pagecount(xdr), size;
+	void *m, *t;
+	int ret, n =3D 2, size;
 =

 	*sentp =3D 0;
 	ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
@@ -1089,27 +1091,28 @@ static int svc_tcp_sendmsg(struct socket *sock, st=
ruct xdr_buf *xdr,
 	if (!m)
 		return -ENOMEM;
 =

-	h =3D m + sizeof(marker);
-	t =3D h + head->iov_len;
+	memcpy(m, &marker, sizeof(marker));
+	if (head->iov_len)
+		memcpy(m + sizeof(marker), head->iov_base, head->iov_len);
+	bvec_set_virt(&head_bv, m, sizeof(marker) + head->iov_len);
+	iov_iter_bvec(&iters[0], ITER_SOURCE, &head_bv, 1,
+		      sizeof(marker) + head->iov_len);
 =

-	bvec_set_virt(&xdr->bvec[-1], m, sizeof(marker) + head->iov_len);
-	n++;
+	iov_iter_bvec(&iters[1], ITER_SOURCE, xdr->bvec,
+		      xdr_buf_pagecount(xdr), xdr->page_len);
 =

 	if (tail->iov_len) {
 		t =3D page_frag_alloc(NULL, tail->iov_len, GFP_KERNEL);
 		if (!t)
 			return -ENOMEM;
-		bvec_set_virt(&xdr->bvec[n],  t, tail->iov_len);
 		memcpy(t, tail->iov_base, tail->iov_len);
+		bvec_set_virt(&tail_bv,  t, tail->iov_len);
+		iov_iter_bvec(&iters[2], ITER_SOURCE, &tail_bv, 1, tail->iov_len);
 		n++;
 	}
 =

-	memcpy(m, &marker, sizeof(marker));
-	if (head->iov_len)
-		memcpy(h, head->iov_base, head->iov_len);
-
 	size =3D sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_len;
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec - 1, n, size);
+	iov_iter_iterlist(&msg.msg_iter, ITER_SOURCE, iters, n, size);
 =

 	ret =3D sock_sendmsg(sock, &msg);
 	if (ret < 0)

