Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33984ACB2C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiBGVUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238009AbiBGVUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:20:11 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD30C06173B
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 13:20:09 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHBQa-000HoW-37; Mon, 07 Feb 2022 21:20:04 +0000
Date:   Mon, 7 Feb 2022 21:20:04 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk
Subject: Re: [PATCH net-next] tls: cap the output scatter list to something
 reasonable
Message-ID: <YgGNBMvSCcmLgTAJ@zeniv-ca.linux.org.uk>
References: <20220202222031.2174584-1-kuba@kernel.org>
 <YgFTsot6DUQptjWk@zeniv-ca.linux.org.uk>
 <20220207092619.08754453@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207092619.08754453@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 09:26:19AM -0800, Jakub Kicinski wrote:
> On Mon, 7 Feb 2022 17:15:30 +0000 Al Viro wrote:
> > On Wed, Feb 02, 2022 at 02:20:31PM -0800, Jakub Kicinski wrote:
> > > TLS recvmsg() passes user pages as destination for decrypt.
> > > The decrypt operation is repeated record by record, each
> > > record being 16kB, max. TLS allocates an sg_table and uses
> > > iov_iter_get_pages() to populate it with enough pages to
> > > fit the decrypted record.
> > > 
> > > Even though we decrypt a single message at a time we size
> > > the sg_table based on the entire length of the iovec.
> > > This leads to unnecessarily large allocations, risking
> > > triggering OOM conditions.
> > > 
> > > Use iov_iter_truncate() / iov_iter_reexpand() to construct
> > > a "capped" version of iov_iter_npages(). Alternatively we
> > > could parametrize iov_iter_npages() to take the size as
> > > arg instead of using i->count, or do something else..  
> > 
> > Er...  Would simply passing 16384/PAGE_SIZE instead of MAX_INT work
> > for your purposes?
> 
> The last arg is maxpages, I want maxbytes, no?

What's the point of pass maxpages as argument to that, seeing that
you ignore the value you've got?  I'm just trying to understand what
semantics do you really intend for that thing.

Another thing: looking at that bunch now, for pipe-backed ones
that won't work.  It's a bug, strictly speaking, even though
the actual primitives that grab those pages *will* honour the
truncation/reexpand.

Frankly, I wonder if we would be better off with making iov_iter_npages()
a wrapper for that one, passing SIZE_MAX as maxbytes.  How does the following
(completely untested) look for you?

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 1198a2bfc9bfc..07e4ebae7c6fa 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -236,11 +236,16 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
-int iov_iter_npages(const struct iov_iter *i, int maxpages);
+int __iov_iter_npages(const struct iov_iter *i, size_t maxsize, int maxpages);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
+static inline int iov_iter_npages(const struct iov_iter *i, int maxpages)
+{
+	return __iov_iter_npages(i, SIZE_MAX, maxpages);
+}
+
 static inline size_t iov_iter_count(const struct iov_iter *i)
 {
 	return i->count;
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index b0e0acdf96c15..35a86d68f7073 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1763,9 +1763,9 @@ size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 }
 EXPORT_SYMBOL(hash_and_copy_to_iter);
 
-static int iov_npages(const struct iov_iter *i, int maxpages)
+static int iov_npages(const struct iov_iter *i, size_t size, int maxpages)
 {
-	size_t skip = i->iov_offset, size = i->count;
+	size_t skip = i->iov_offset;
 	const struct iovec *p;
 	int npages = 0;
 
@@ -1783,9 +1783,9 @@ static int iov_npages(const struct iov_iter *i, int maxpages)
 	return npages;
 }
 
-static int bvec_npages(const struct iov_iter *i, int maxpages)
+static int bvec_npages(const struct iov_iter *i, size_t size, int maxpages)
 {
-	size_t skip = i->iov_offset, size = i->count;
+	size_t skip = i->iov_offset;
 	const struct bio_vec *p;
 	int npages = 0;
 
@@ -1801,36 +1801,43 @@ static int bvec_npages(const struct iov_iter *i, int maxpages)
 	return npages;
 }
 
-int iov_iter_npages(const struct iov_iter *i, int maxpages)
+int __iov_iter_npages(const struct iov_iter *i, size_t maxsize, int maxpages)
 {
-	if (unlikely(!i->count))
+	if (i->count < maxsize)
+		maxsize = i->count;
+	if (unlikely(!maxsize))
 		return 0;
 	/* iovec and kvec have identical layouts */
 	if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i)))
-		return iov_npages(i, maxpages);
+		return iov_npages(i, maxsize, maxpages);
 	if (iov_iter_is_bvec(i))
-		return bvec_npages(i, maxpages);
+		return bvec_npages(i, maxsize, maxpages);
 	if (iov_iter_is_pipe(i)) {
 		unsigned int iter_head;
 		int npages;
 		size_t off;
+		size_t n;
 
 		if (!sanity(i))
 			return 0;
 
 		data_start(i, &iter_head, &off);
+		n = DIV_ROUND_UP(off + maxsize, PAGE_SIZE);
+		if (maxpages > n)
+			maxpages = n;
+
 		/* some of this one + all after this one */
 		npages = pipe_space_for_user(iter_head, i->pipe->tail, i->pipe);
 		return min(npages, maxpages);
 	}
 	if (iov_iter_is_xarray(i)) {
 		unsigned offset = (i->xarray_start + i->iov_offset) % PAGE_SIZE;
-		int npages = DIV_ROUND_UP(offset + i->count, PAGE_SIZE);
+		int npages = DIV_ROUND_UP(offset + maxsize, PAGE_SIZE);
 		return min(npages, maxpages);
 	}
 	return 0;
 }
-EXPORT_SYMBOL(iov_iter_npages);
+EXPORT_SYMBOL(__iov_iter_npages);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 {
