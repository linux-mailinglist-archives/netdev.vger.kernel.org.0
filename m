Return-Path: <netdev+bounces-6415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94176716399
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 526042811A1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B701821CC5;
	Tue, 30 May 2023 14:18:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56D821072
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:18:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CAA19B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685456248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VjV1Ciimn6pzCandpdZtjXJYCOMjJSyNy1/qiT7b1Ng=;
	b=gq1NifFGfeSnQ88dECnhsZ/V91aVDGgXRIz7BgXCSlJ35DhEeejGYmdU13/3yLV4yhDyGG
	tO/aq8FslzbtmXXZDMVCe7NLexy0KypCDglkM59knj4d/fEKP155eJIDW1JYsWLfU4tDha
	priWmIj7254oAaiZpdoIl2TqS9J1rCk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-Ueeskx28ORyWEErMR7otWg-1; Tue, 30 May 2023 10:17:25 -0400
X-MC-Unique: Ueeskx28ORyWEErMR7otWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E901F8030CF;
	Tue, 30 May 2023 14:17:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 517B640C6EC4;
	Tue, 30 May 2023 14:17:15 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	linux-cachefs@redhat.com,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH net-next v2 04/10] Move netfs_extract_iter_to_sg() to lib/scatterlist.c
Date: Tue, 30 May 2023 15:16:28 +0100
Message-ID: <20230530141635.136968-5-dhowells@redhat.com>
In-Reply-To: <20230530141635.136968-1-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Move netfs_extract_iter_to_sg() to lib/scatterlist.c as it's going to be
used by more than just network filesystems (AF_ALG, for example).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: linux-cachefs@redhat.com
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 fs/netfs/iterator.c   | 267 -----------------------------------------
 include/linux/netfs.h |   4 -
 include/linux/uio.h   |   5 +
 lib/scatterlist.c     | 269 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 274 insertions(+), 271 deletions(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 9f09dc30ceb6..2ff07ba655a0 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -101,270 +101,3 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 	return npages;
 }
 EXPORT_SYMBOL_GPL(netfs_extract_user_iter);
-
-/*
- * Extract and pin a list of up to sg_max pages from UBUF- or IOVEC-class
- * iterators, and add them to the scatterlist.
- */
-static ssize_t extract_user_to_sg(struct iov_iter *iter,
-				  ssize_t maxsize,
-				  struct sg_table *sgtable,
-				  unsigned int sg_max,
-				  iov_iter_extraction_t extraction_flags)
-{
-	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
-	struct page **pages;
-	unsigned int npages;
-	ssize_t ret = 0, res;
-	size_t len, off;
-
-	/* We decant the page list into the tail of the scatterlist */
-	pages = (void *)sgtable->sgl +
-		array_size(sg_max, sizeof(struct scatterlist));
-	pages -= sg_max;
-
-	do {
-		res = iov_iter_extract_pages(iter, &pages, maxsize, sg_max,
-					     extraction_flags, &off);
-		if (res < 0)
-			goto failed;
-
-		len = res;
-		maxsize -= len;
-		ret += len;
-		npages = DIV_ROUND_UP(off + len, PAGE_SIZE);
-		sg_max -= npages;
-
-		for (; npages > 0; npages--) {
-			struct page *page = *pages;
-			size_t seg = min_t(size_t, PAGE_SIZE - off, len);
-
-			*pages++ = NULL;
-			sg_set_page(sg, page, seg, off);
-			sgtable->nents++;
-			sg++;
-			len -= seg;
-			off = 0;
-		}
-	} while (maxsize > 0 && sg_max > 0);
-
-	return ret;
-
-failed:
-	while (sgtable->nents > sgtable->orig_nents)
-		put_page(sg_page(&sgtable->sgl[--sgtable->nents]));
-	return res;
-}
-
-/*
- * Extract up to sg_max pages from a BVEC-type iterator and add them to the
- * scatterlist.  The pages are not pinned.
- */
-static ssize_t extract_bvec_to_sg(struct iov_iter *iter,
-				  ssize_t maxsize,
-				  struct sg_table *sgtable,
-				  unsigned int sg_max,
-				  iov_iter_extraction_t extraction_flags)
-{
-	const struct bio_vec *bv = iter->bvec;
-	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
-	unsigned long start = iter->iov_offset;
-	unsigned int i;
-	ssize_t ret = 0;
-
-	for (i = 0; i < iter->nr_segs; i++) {
-		size_t off, len;
-
-		len = bv[i].bv_len;
-		if (start >= len) {
-			start -= len;
-			continue;
-		}
-
-		len = min_t(size_t, maxsize, len - start);
-		off = bv[i].bv_offset + start;
-
-		sg_set_page(sg, bv[i].bv_page, len, off);
-		sgtable->nents++;
-		sg++;
-		sg_max--;
-
-		ret += len;
-		maxsize -= len;
-		if (maxsize <= 0 || sg_max == 0)
-			break;
-		start = 0;
-	}
-
-	if (ret > 0)
-		iov_iter_advance(iter, ret);
-	return ret;
-}
-
-/*
- * Extract up to sg_max pages from a KVEC-type iterator and add them to the
- * scatterlist.  This can deal with vmalloc'd buffers as well as kmalloc'd or
- * static buffers.  The pages are not pinned.
- */
-static ssize_t extract_kvec_to_sg(struct iov_iter *iter,
-				  ssize_t maxsize,
-				  struct sg_table *sgtable,
-				  unsigned int sg_max,
-				  iov_iter_extraction_t extraction_flags)
-{
-	const struct kvec *kv = iter->kvec;
-	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
-	unsigned long start = iter->iov_offset;
-	unsigned int i;
-	ssize_t ret = 0;
-
-	for (i = 0; i < iter->nr_segs; i++) {
-		struct page *page;
-		unsigned long kaddr;
-		size_t off, len, seg;
-
-		len = kv[i].iov_len;
-		if (start >= len) {
-			start -= len;
-			continue;
-		}
-
-		kaddr = (unsigned long)kv[i].iov_base + start;
-		off = kaddr & ~PAGE_MASK;
-		len = min_t(size_t, maxsize, len - start);
-		kaddr &= PAGE_MASK;
-
-		maxsize -= len;
-		ret += len;
-		do {
-			seg = min_t(size_t, len, PAGE_SIZE - off);
-			if (is_vmalloc_or_module_addr((void *)kaddr))
-				page = vmalloc_to_page((void *)kaddr);
-			else
-				page = virt_to_page(kaddr);
-
-			sg_set_page(sg, page, len, off);
-			sgtable->nents++;
-			sg++;
-			sg_max--;
-
-			len -= seg;
-			kaddr += PAGE_SIZE;
-			off = 0;
-		} while (len > 0 && sg_max > 0);
-
-		if (maxsize <= 0 || sg_max == 0)
-			break;
-		start = 0;
-	}
-
-	if (ret > 0)
-		iov_iter_advance(iter, ret);
-	return ret;
-}
-
-/*
- * Extract up to sg_max folios from an XARRAY-type iterator and add them to
- * the scatterlist.  The pages are not pinned.
- */
-static ssize_t extract_xarray_to_sg(struct iov_iter *iter,
-				    ssize_t maxsize,
-				    struct sg_table *sgtable,
-				    unsigned int sg_max,
-				    iov_iter_extraction_t extraction_flags)
-{
-	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
-	struct xarray *xa = iter->xarray;
-	struct folio *folio;
-	loff_t start = iter->xarray_start + iter->iov_offset;
-	pgoff_t index = start / PAGE_SIZE;
-	ssize_t ret = 0;
-	size_t offset, len;
-	XA_STATE(xas, xa, index);
-
-	rcu_read_lock();
-
-	xas_for_each(&xas, folio, ULONG_MAX) {
-		if (xas_retry(&xas, folio))
-			continue;
-		if (WARN_ON(xa_is_value(folio)))
-			break;
-		if (WARN_ON(folio_test_hugetlb(folio)))
-			break;
-
-		offset = offset_in_folio(folio, start);
-		len = min_t(size_t, maxsize, folio_size(folio) - offset);
-
-		sg_set_page(sg, folio_page(folio, 0), len, offset);
-		sgtable->nents++;
-		sg++;
-		sg_max--;
-
-		maxsize -= len;
-		ret += len;
-		if (maxsize <= 0 || sg_max == 0)
-			break;
-	}
-
-	rcu_read_unlock();
-	if (ret > 0)
-		iov_iter_advance(iter, ret);
-	return ret;
-}
-
-/**
- * extract_iter_to_sg - Extract pages from an iterator and add to an sglist
- * @iter: The iterator to extract from
- * @maxsize: The amount of iterator to copy
- * @sgtable: The scatterlist table to fill in
- * @sg_max: Maximum number of elements in @sgtable that may be filled
- * @extraction_flags: Flags to qualify the request
- *
- * Extract the page fragments from the given amount of the source iterator and
- * add them to a scatterlist that refers to all of those bits, to a maximum
- * addition of @sg_max elements.
- *
- * The pages referred to by UBUF- and IOVEC-type iterators are extracted and
- * pinned; BVEC-, KVEC- and XARRAY-type are extracted but aren't pinned; PIPE-
- * and DISCARD-type are not supported.
- *
- * No end mark is placed on the scatterlist; that's left to the caller.
- *
- * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA
- * be allowed on the pages extracted.
- *
- * If successful, @sgtable->nents is updated to include the number of elements
- * added and the number of bytes added is returned.  @sgtable->orig_nents is
- * left unaltered.
- *
- * The iov_iter_extract_mode() function should be used to query how cleanup
- * should be performed.
- */
-ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
-			   struct sg_table *sgtable, unsigned int sg_max,
-			   iov_iter_extraction_t extraction_flags)
-{
-	if (maxsize == 0)
-		return 0;
-
-	switch (iov_iter_type(iter)) {
-	case ITER_UBUF:
-	case ITER_IOVEC:
-		return extract_user_to_sg(iter, maxsize, sgtable, sg_max,
-					  extraction_flags);
-	case ITER_BVEC:
-		return extract_bvec_to_sg(iter, maxsize, sgtable, sg_max,
-					  extraction_flags);
-	case ITER_KVEC:
-		return extract_kvec_to_sg(iter, maxsize, sgtable, sg_max,
-					  extraction_flags);
-	case ITER_XARRAY:
-		return extract_xarray_to_sg(iter, maxsize, sgtable, sg_max,
-					    extraction_flags);
-	default:
-		pr_err("%s(%u) unsupported\n", __func__, iov_iter_type(iter));
-		WARN_ON_ONCE(1);
-		return -EIO;
-	}
-}
-EXPORT_SYMBOL_GPL(extract_iter_to_sg);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 55e201c3a841..b11a84f6c32b 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -300,10 +300,6 @@ void netfs_stats_show(struct seq_file *);
 ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 				struct iov_iter *new,
 				iov_iter_extraction_t extraction_flags);
-struct sg_table;
-ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t len,
-			   struct sg_table *sgtable, unsigned int sg_max,
-			   iov_iter_extraction_t extraction_flags);
 
 /**
  * netfs_inode - Get the netfs inode context from the inode
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 044c1d8c230c..0ccb983cf645 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -433,4 +433,9 @@ static inline bool iov_iter_extract_will_pin(const struct iov_iter *iter)
 	return user_backed_iter(iter);
 }
 
+struct sg_table;
+ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t len,
+			   struct sg_table *sgtable, unsigned int sg_max,
+			   iov_iter_extraction_t extraction_flags);
+
 #endif
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 8d7519a8f308..e97d7060329e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -9,6 +9,8 @@
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
 #include <linux/kmemleak.h>
+#include <linux/bvec.h>
+#include <linux/uio.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -1095,3 +1097,270 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 	return offset;
 }
 EXPORT_SYMBOL(sg_zero_buffer);
+
+/*
+ * Extract and pin a list of up to sg_max pages from UBUF- or IOVEC-class
+ * iterators, and add them to the scatterlist.
+ */
+static ssize_t extract_user_to_sg(struct iov_iter *iter,
+				  ssize_t maxsize,
+				  struct sg_table *sgtable,
+				  unsigned int sg_max,
+				  iov_iter_extraction_t extraction_flags)
+{
+	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
+	struct page **pages;
+	unsigned int npages;
+	ssize_t ret = 0, res;
+	size_t len, off;
+
+	/* We decant the page list into the tail of the scatterlist */
+	pages = (void *)sgtable->sgl +
+		array_size(sg_max, sizeof(struct scatterlist));
+	pages -= sg_max;
+
+	do {
+		res = iov_iter_extract_pages(iter, &pages, maxsize, sg_max,
+					     extraction_flags, &off);
+		if (res < 0)
+			goto failed;
+
+		len = res;
+		maxsize -= len;
+		ret += len;
+		npages = DIV_ROUND_UP(off + len, PAGE_SIZE);
+		sg_max -= npages;
+
+		for (; npages > 0; npages--) {
+			struct page *page = *pages;
+			size_t seg = min_t(size_t, PAGE_SIZE - off, len);
+
+			*pages++ = NULL;
+			sg_set_page(sg, page, seg, off);
+			sgtable->nents++;
+			sg++;
+			len -= seg;
+			off = 0;
+		}
+	} while (maxsize > 0 && sg_max > 0);
+
+	return ret;
+
+failed:
+	while (sgtable->nents > sgtable->orig_nents)
+		put_page(sg_page(&sgtable->sgl[--sgtable->nents]));
+	return res;
+}
+
+/*
+ * Extract up to sg_max pages from a BVEC-type iterator and add them to the
+ * scatterlist.  The pages are not pinned.
+ */
+static ssize_t extract_bvec_to_sg(struct iov_iter *iter,
+				  ssize_t maxsize,
+				  struct sg_table *sgtable,
+				  unsigned int sg_max,
+				  iov_iter_extraction_t extraction_flags)
+{
+	const struct bio_vec *bv = iter->bvec;
+	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
+	unsigned long start = iter->iov_offset;
+	unsigned int i;
+	ssize_t ret = 0;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		size_t off, len;
+
+		len = bv[i].bv_len;
+		if (start >= len) {
+			start -= len;
+			continue;
+		}
+
+		len = min_t(size_t, maxsize, len - start);
+		off = bv[i].bv_offset + start;
+
+		sg_set_page(sg, bv[i].bv_page, len, off);
+		sgtable->nents++;
+		sg++;
+		sg_max--;
+
+		ret += len;
+		maxsize -= len;
+		if (maxsize <= 0 || sg_max == 0)
+			break;
+		start = 0;
+	}
+
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
+/*
+ * Extract up to sg_max pages from a KVEC-type iterator and add them to the
+ * scatterlist.  This can deal with vmalloc'd buffers as well as kmalloc'd or
+ * static buffers.  The pages are not pinned.
+ */
+static ssize_t extract_kvec_to_sg(struct iov_iter *iter,
+				  ssize_t maxsize,
+				  struct sg_table *sgtable,
+				  unsigned int sg_max,
+				  iov_iter_extraction_t extraction_flags)
+{
+	const struct kvec *kv = iter->kvec;
+	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
+	unsigned long start = iter->iov_offset;
+	unsigned int i;
+	ssize_t ret = 0;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		struct page *page;
+		unsigned long kaddr;
+		size_t off, len, seg;
+
+		len = kv[i].iov_len;
+		if (start >= len) {
+			start -= len;
+			continue;
+		}
+
+		kaddr = (unsigned long)kv[i].iov_base + start;
+		off = kaddr & ~PAGE_MASK;
+		len = min_t(size_t, maxsize, len - start);
+		kaddr &= PAGE_MASK;
+
+		maxsize -= len;
+		ret += len;
+		do {
+			seg = min_t(size_t, len, PAGE_SIZE - off);
+			if (is_vmalloc_or_module_addr((void *)kaddr))
+				page = vmalloc_to_page((void *)kaddr);
+			else
+				page = virt_to_page(kaddr);
+
+			sg_set_page(sg, page, len, off);
+			sgtable->nents++;
+			sg++;
+			sg_max--;
+
+			len -= seg;
+			kaddr += PAGE_SIZE;
+			off = 0;
+		} while (len > 0 && sg_max > 0);
+
+		if (maxsize <= 0 || sg_max == 0)
+			break;
+		start = 0;
+	}
+
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
+/*
+ * Extract up to sg_max folios from an XARRAY-type iterator and add them to
+ * the scatterlist.  The pages are not pinned.
+ */
+static ssize_t extract_xarray_to_sg(struct iov_iter *iter,
+				    ssize_t maxsize,
+				    struct sg_table *sgtable,
+				    unsigned int sg_max,
+				    iov_iter_extraction_t extraction_flags)
+{
+	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
+	struct xarray *xa = iter->xarray;
+	struct folio *folio;
+	loff_t start = iter->xarray_start + iter->iov_offset;
+	pgoff_t index = start / PAGE_SIZE;
+	ssize_t ret = 0;
+	size_t offset, len;
+	XA_STATE(xas, xa, index);
+
+	rcu_read_lock();
+
+	xas_for_each(&xas, folio, ULONG_MAX) {
+		if (xas_retry(&xas, folio))
+			continue;
+		if (WARN_ON(xa_is_value(folio)))
+			break;
+		if (WARN_ON(folio_test_hugetlb(folio)))
+			break;
+
+		offset = offset_in_folio(folio, start);
+		len = min_t(size_t, maxsize, folio_size(folio) - offset);
+
+		sg_set_page(sg, folio_page(folio, 0), len, offset);
+		sgtable->nents++;
+		sg++;
+		sg_max--;
+
+		maxsize -= len;
+		ret += len;
+		if (maxsize <= 0 || sg_max == 0)
+			break;
+	}
+
+	rcu_read_unlock();
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
+/**
+ * extract_iter_to_sg - Extract pages from an iterator and add to an sglist
+ * @iter: The iterator to extract from
+ * @maxsize: The amount of iterator to copy
+ * @sgtable: The scatterlist table to fill in
+ * @sg_max: Maximum number of elements in @sgtable that may be filled
+ * @extraction_flags: Flags to qualify the request
+ *
+ * Extract the page fragments from the given amount of the source iterator and
+ * add them to a scatterlist that refers to all of those bits, to a maximum
+ * addition of @sg_max elements.
+ *
+ * The pages referred to by UBUF- and IOVEC-type iterators are extracted and
+ * pinned; BVEC-, KVEC- and XARRAY-type are extracted but aren't pinned; PIPE-
+ * and DISCARD-type are not supported.
+ *
+ * No end mark is placed on the scatterlist; that's left to the caller.
+ *
+ * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA
+ * be allowed on the pages extracted.
+ *
+ * If successful, @sgtable->nents is updated to include the number of elements
+ * added and the number of bytes added is returned.  @sgtable->orig_nents is
+ * left unaltered.
+ *
+ * The iov_iter_extract_mode() function should be used to query how cleanup
+ * should be performed.
+ */
+ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
+			   struct sg_table *sgtable, unsigned int sg_max,
+			   iov_iter_extraction_t extraction_flags)
+{
+	if (maxsize == 0)
+		return 0;
+
+	switch (iov_iter_type(iter)) {
+	case ITER_UBUF:
+	case ITER_IOVEC:
+		return extract_user_to_sg(iter, maxsize, sgtable, sg_max,
+					  extraction_flags);
+	case ITER_BVEC:
+		return extract_bvec_to_sg(iter, maxsize, sgtable, sg_max,
+					  extraction_flags);
+	case ITER_KVEC:
+		return extract_kvec_to_sg(iter, maxsize, sgtable, sg_max,
+					  extraction_flags);
+	case ITER_XARRAY:
+		return extract_xarray_to_sg(iter, maxsize, sgtable, sg_max,
+					    extraction_flags);
+	default:
+		pr_err("%s(%u) unsupported\n", __func__, iov_iter_type(iter));
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+}
+EXPORT_SYMBOL_GPL(extract_iter_to_sg);


