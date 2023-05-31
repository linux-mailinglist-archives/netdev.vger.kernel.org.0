Return-Path: <netdev+bounces-6794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5701371803D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E67641C20EB9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC9514285;
	Wed, 31 May 2023 12:46:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E20DC2FD
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:46:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69817132
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685537159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jiNOYIAVcjsuvSMtZGlGjCJlFKnRRxqCgJAQxTqAqH0=;
	b=Ssonray9XxJGi49NtGuYeKH7U4FjozggGJbmWq9/ZRziM48WHzS6SxaJQuHT6ppzeTNilC
	Zq5Ltvyw4CY6g8KZfoq/ejIx/17U677TG2ARaCPhFgtttT0WUimKUG0MbTMtj81ZY+xqA9
	ipqVT9iKlGkgcBpkPVsl1kb8AkzclnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-cKdTb43SN-mmwECm3okGRg-1; Wed, 31 May 2023 08:45:54 -0400
X-MC-Unique: cKdTb43SN-mmwECm3okGRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AE7B8032E4;
	Wed, 31 May 2023 12:45:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F12040C6EC4;
	Wed, 31 May 2023 12:45:51 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/6] tls/device: Convert tls_device_sendpage() to use MSG_SPLICE_PAGES
Date: Wed, 31 May 2023 13:45:28 +0100
Message-ID: <20230531124528.699123-7-dhowells@redhat.com>
In-Reply-To: <20230531124528.699123-1-dhowells@redhat.com>
References: <20230531124528.699123-1-dhowells@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
 net/tls/tls_device.c | 84 +++++++++++---------------------------------
 1 file changed, 20 insertions(+), 64 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 221fb30cba51..684171363dd9 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -422,16 +422,10 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
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
@@ -499,22 +493,13 @@ static int tls_push_data(struct sock *sk,
 		record = ctx->open_record;
 
 		copy = min_t(size_t, size, max_open_record_len - record->len);
-		if (copy && zc_page) {
-			struct page_frag zc_pfrag;
-
-			zc_pfrag.page = zc_page;
-			zc_pfrag.offset = iter_offset.offset;
-			zc_pfrag.size = copy;
-			tls_append_frag(record, &zc_pfrag, copy);
-
-			iter_offset.offset += copy;
-		} else if (copy && (flags & MSG_SPLICE_PAGES)) {
+		if (copy && (flags & MSG_SPLICE_PAGES)) {
 			struct page_frag zc_pfrag;
 			struct page **pages = &zc_pfrag.page;
 			size_t off;
 
-			rc = iov_iter_extract_pages(iter_offset.msg_iter,
-						    &pages, copy, 1, 0, &off);
+			rc = iov_iter_extract_pages(iter, &pages,
+						    copy, 1, 0, &off);
 			if (rc <= 0) {
 				if (rc == 0)
 					rc = -EIO;
@@ -523,7 +508,7 @@ static int tls_push_data(struct sock *sk,
 			copy = rc;
 
 			if (WARN_ON_ONCE(!sendpage_ok(zc_pfrag.page))) {
-				iov_iter_revert(iter_offset.msg_iter, copy);
+				iov_iter_revert(iter, copy);
 				rc = -EIO;
 				goto handle_error;
 			}
@@ -536,7 +521,7 @@ static int tls_push_data(struct sock *sk,
 
 			rc = tls_device_copy_data(page_address(pfrag->page) +
 						  pfrag->offset, copy,
-						  iter_offset.msg_iter);
+						  iter);
 			if (rc)
 				goto handle_error;
 			tls_append_frag(record, pfrag, copy);
@@ -591,7 +576,6 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	union tls_iter_offset iter;
 	int rc;
 
 	if (!tls_ctx->zerocopy_sendfile)
@@ -606,8 +590,8 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto out;
 	}
 
-	iter.msg_iter = &msg->msg_iter;
-	rc = tls_push_data(sk, iter, size, msg->msg_flags, record_type, NULL);
+	rc = tls_push_data(sk, &msg->msg_iter, size, msg->msg_flags,
+			   record_type);
 
 out:
 	release_sock(sk);
@@ -618,44 +602,18 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return tls_device_sendmsg(sk, &msg, size);
 }
 
 struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
@@ -720,12 +678,10 @@ EXPORT_SYMBOL(tls_get_record);
 
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


