Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7956D2518
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjCaQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjCaQOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:14:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D86C24437
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nNsV/6c3ho01ZHWXYC82bpiErYX0eKAApSJsSVNmIO8=;
        b=gyN/xk+/mLVIvoXXTkzlHP8h4ZRCCEXtLzcYr3Ff+ZzxfZiiOb2YFuYOlgx/mTW9MFUukF
        Sz7oIjIVHWUL7wTkUUunNxwNUQWh6vFAekNWQ6RC9fo9RpVGnAvc3e0GwN69dMToLnDB3P
        6oJssVl5zWBFZPH6S3+tA4BtDzgI5l0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-CQ22tLM2M2iPd2GX0NVahQ-1; Fri, 31 Mar 2023 12:10:40 -0400
X-MC-Unique: CQ22tLM2M2iPd2GX0NVahQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19982101A54F;
        Fri, 31 Mar 2023 16:10:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08B612166B33;
        Fri, 31 Mar 2023 16:10:36 +0000 (UTC)
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
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 28/55] tls/device: Convert tls_device_sendpage() to use MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:47 +0100
Message-Id: <20230331160914.1608208-29-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert tls_device_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather
than directly splicing in the pages itself.  With that, the tls_iter_offset
union is no longer necessary and can be replaced with an iov_iter pointer
and the zc_page argument to tls_push_data() can also be removed.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/tls/tls_device.c | 79 ++++++++++----------------------------------
 1 file changed, 18 insertions(+), 61 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f5c3b56ac1ce..6cfd1577a212 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -424,16 +424,10 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
 	return 0;
 }
 
-union tls_iter_offset {
-	struct iov_iter *msg_iter;
-	int offset;
-};
-
 static int tls_push_data(struct sock *sk,
-			 union tls_iter_offset iter_offset,
+			 struct iov_iter *iter,
 			 size_t size, int flags,
-			 unsigned char record_type,
-			 struct page *zc_page)
+			 unsigned char record_type)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -501,19 +495,12 @@ static int tls_push_data(struct sock *sk,
 		record = ctx->open_record;
 
 		copy = min_t(size_t, size, max_open_record_len - record->len);
-		if (copy && zc_page) {
-			struct page_frag zc_pfrag;
-
-			zc_pfrag.page = zc_page;
-			zc_pfrag.offset = iter_offset.offset;
-			zc_pfrag.size = copy;
-			tls_append_frag(record, &zc_pfrag, copy);
-		} else if (copy && (flags & MSG_SPLICE_PAGES)) {
+		if (copy && (flags & MSG_SPLICE_PAGES)) {
 			struct page_frag zc_pfrag;
 			struct page **pages = &zc_pfrag.page;
 			size_t off;
 
-			rc = iov_iter_extract_pages(iter_offset.msg_iter, &pages,
+			rc = iov_iter_extract_pages(iter, &pages,
 						    copy, 1, 0, &off);
 			if (rc <= 0) {
 				if (rc == 0)
@@ -523,7 +510,7 @@ static int tls_push_data(struct sock *sk,
 			copy = rc;
 
 			if (!sendpage_ok(zc_pfrag.page)) {
-				iov_iter_revert(iter_offset.msg_iter, copy);
+				iov_iter_revert(iter, copy);
 				goto no_zcopy_this_page;
 			}
 
@@ -536,7 +523,7 @@ static int tls_push_data(struct sock *sk,
 
 			rc = tls_device_copy_data(page_address(pfrag->page) +
 						  pfrag->offset, copy,
-						  iter_offset.msg_iter);
+						  iter);
 			if (rc)
 				goto handle_error;
 			tls_append_frag(record, pfrag, copy);
@@ -591,7 +578,6 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	union tls_iter_offset iter;
 	int rc;
 
 	if (!tls_ctx->zerocopy_sendfile)
@@ -606,8 +592,7 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto out;
 	}
 
-	iter.msg_iter = &msg->msg_iter;
-	rc = tls_push_data(sk, iter, size, msg->msg_flags, record_type, NULL);
+	rc = tls_push_data(sk, &msg->msg_iter, size, msg->msg_flags, record_type);
 
 out:
 	release_sock(sk);
@@ -618,44 +603,18 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	union tls_iter_offset iter_offset;
-	struct iov_iter msg_iter;
-	char *kaddr;
-	struct kvec iov;
-	int rc;
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	mutex_lock(&tls_ctx->tx_lock);
-	lock_sock(sk);
+		msg.msg_flags |= MSG_MORE;
 
-	if (flags & MSG_OOB) {
-		rc = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (tls_ctx->zerocopy_sendfile) {
-		iter_offset.offset = offset;
-		rc = tls_push_data(sk, iter_offset, size,
-				   flags, TLS_RECORD_TYPE_DATA, page);
-		goto out;
-	}
-
-	kaddr = kmap(page);
-	iov.iov_base = kaddr + offset;
-	iov.iov_len = size;
-	iov_iter_kvec(&msg_iter, ITER_SOURCE, &iov, 1, size);
-	iter_offset.msg_iter = &msg_iter;
-	rc = tls_push_data(sk, iter_offset, size, flags, TLS_RECORD_TYPE_DATA,
-			   NULL);
-	kunmap(page);
+	if (flags & MSG_OOB)
+		return -EOPNOTSUPP;
 
-out:
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
-	return rc;
+	bvec_set_page(&bvec, page, offset, size);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return tls_device_sendmsg(sk, &msg, size);
 }
 
 struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
@@ -720,12 +679,10 @@ EXPORT_SYMBOL(tls_get_record);
 
 static int tls_device_push_pending_record(struct sock *sk, int flags)
 {
-	union tls_iter_offset iter;
-	struct iov_iter msg_iter;
+	struct iov_iter iter;
 
-	iov_iter_kvec(&msg_iter, ITER_SOURCE, NULL, 0, 0);
-	iter.msg_iter = &msg_iter;
-	return tls_push_data(sk, iter, 0, flags, TLS_RECORD_TYPE_DATA, NULL);
+	iov_iter_kvec(&iter, ITER_SOURCE, NULL, 0, 0);
+	return tls_push_data(sk, &iter, 0, flags, TLS_RECORD_TYPE_DATA);
 }
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)

