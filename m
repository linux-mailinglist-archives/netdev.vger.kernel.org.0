Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240686BD396
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjCPP2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCPP2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:28:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EF3B254B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0tjSspNdCEV0klTPAiqijmVmAHGr/T2RpULqY6WmgRo=;
        b=UlqCVnMQGGCzcpIIY5OdBeFer1r0Xb5yh3UATK+TXlc92B+KMdO5ncsXvrS4ffq99o+wNl
        g5LW15MGcLx1VVP9T80E4w4h5CnSWYRqdpmTNzIgmduYB3yAP8VtLH29ydn0CCLk5q6cG6
        v3KBOrH5jhxgAW1nbo6FPXwkp4GmoeA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-pxJorDNpMoumBCRZt3rTBA-1; Thu, 16 Mar 2023 11:26:55 -0400
X-MC-Unique: pxJorDNpMoumBCRZt3rTBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C928228237DA;
        Thu, 16 Mar 2023 15:26:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A22240C6F87;
        Thu, 16 Mar 2023 15:26:52 +0000 (UTC)
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH 12/28] af_unix: Support MSG_SPLICE_PAGES
Date:   Thu, 16 Mar 2023 15:26:02 +0000
Message-Id: <20230316152618.711970-13-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make AF_UNIX sendmsg() support MSG_SPLICE_PAGES, splicing in pages from the
source iterator if given and if ITER_BVEC and copying the data in
otherwise.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/unix/af_unix.c | 84 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 68 insertions(+), 16 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 347122c3575e..6f3454db9c53 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2151,6 +2151,44 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 }
 #endif
 
+/*
+ * Extract pages from a BVEC-type iterator and add them to the socket buffer.
+ */
+static ssize_t unix_extract_bvec_to_skb(struct sk_buff *skb,
+					struct iov_iter *iter, ssize_t maxsize)
+{
+	const struct bio_vec *bv = iter->bvec;
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
+		if (skb_append_pagefrags(skb, bv->bv_page, off, len) < 0)
+			break;
+
+		ret += len;
+		maxsize -= len;
+		if (maxsize <= 0)
+			break;
+		start = 0;
+	}
+
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
 static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 			       size_t len)
 {
@@ -2194,19 +2232,25 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	while (sent < len) {
 		size = len - sent;
 
-		/* Keep two messages in the pipe so it schedules better */
-		size = min_t(int, size, (sk->sk_sndbuf >> 1) - 64);
+		if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES)) {
+			skb = sock_alloc_send_pskb(sk, 0, 0,
+						   msg->msg_flags & MSG_DONTWAIT,
+						   &err, 0);
+		} else {
+			/* Keep two messages in the pipe so it schedules better */
+			size = min_t(int, size, (sk->sk_sndbuf >> 1) - 64);
 
-		/* allow fallback to order-0 allocations */
-		size = min_t(int, size, SKB_MAX_HEAD(0) + UNIX_SKB_FRAGS_SZ);
+			/* allow fallback to order-0 allocations */
+			size = min_t(int, size, SKB_MAX_HEAD(0) + UNIX_SKB_FRAGS_SZ);
 
-		data_len = max_t(int, 0, size - SKB_MAX_HEAD(0));
+			data_len = max_t(int, 0, size - SKB_MAX_HEAD(0));
 
-		data_len = min_t(size_t, size, PAGE_ALIGN(data_len));
+			data_len = min_t(size_t, size, PAGE_ALIGN(data_len));
 
-		skb = sock_alloc_send_pskb(sk, size - data_len, data_len,
-					   msg->msg_flags & MSG_DONTWAIT, &err,
-					   get_order(UNIX_SKB_FRAGS_SZ));
+			skb = sock_alloc_send_pskb(sk, size - data_len, data_len,
+						   msg->msg_flags & MSG_DONTWAIT, &err,
+						   get_order(UNIX_SKB_FRAGS_SZ));
+		}
 		if (!skb)
 			goto out_err;
 
@@ -2218,13 +2262,21 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		}
 		fds_sent = true;
 
-		skb_put(skb, size - data_len);
-		skb->data_len = data_len;
-		skb->len = size;
-		err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, size);
-		if (err) {
-			kfree_skb(skb);
-			goto out_err;
+		if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES)) {
+			size = unix_extract_bvec_to_skb(skb, &msg->msg_iter, size);
+			skb->data_len += size;
+			skb->len += size;
+			skb->truesize += size;
+			refcount_add(size, &sk->sk_wmem_alloc);
+		} else {
+			skb_put(skb, size - data_len);
+			skb->data_len = data_len;
+			skb->len = size;
+			err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, size);
+			if (err) {
+				kfree_skb(skb);
+				goto out_err;
+			}
 		}
 
 		unix_state_lock(other);

