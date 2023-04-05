Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08E86D8468
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbjDEQ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDEQ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:57:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D03AAB
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DKKh1jysgamxWGpEyeqRE19EsYVOUgugB+w/Q3Uqtg=;
        b=YW8xJF4YLKHZzbcQlgLlzW/eqUkd4NWQgm3CPuzWgwr1AeApJm1BmvqvqLb8yepqL42P8N
        mzDud8ADD3vmAY2K77bKEEcHqH2Er9IiEMWEwssAFdHgyptGz06qOCYbW/4/xQmZIBeWJn
        48/Tjhzz33Mbpl+9EISxtRIrTnAg7eg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-cweTzd3XPYSIW2fcQ6DILQ-1; Wed, 05 Apr 2023 12:54:40 -0400
X-MC-Unique: cweTzd3XPYSIW2fcQ6DILQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B889885624;
        Wed,  5 Apr 2023 16:54:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54D9CC1602A;
        Wed,  5 Apr 2023 16:54:37 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH net-next v4 19/20] af_unix: Support MSG_SPLICE_PAGES
Date:   Wed,  5 Apr 2023 17:53:38 +0100
Message-Id: <20230405165339.3468808-20-dhowells@redhat.com>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make AF_UNIX sendmsg() support MSG_SPLICE_PAGES, splicing in pages from the
source iterator if possible and copying the data in otherwise.

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
 net/unix/af_unix.c | 93 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 16 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fb31e8a4409e..fee431a089d3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2157,6 +2157,53 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 }
 #endif
 
+/*
+ * Extract pages from an iterator and add them to the socket buffer.
+ */
+static ssize_t unix_extract_bvec_to_skb(struct sk_buff *skb,
+					struct iov_iter *iter, ssize_t maxsize)
+{
+	struct page *pages[8], **ppages = pages;
+	unsigned int i, nr;
+	ssize_t ret = 0;
+
+	while (iter->count > 0) {
+		size_t off, len;
+
+		nr = min_t(size_t, MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags,
+			   ARRAY_SIZE(pages));
+		if (nr == 0)
+			break;
+
+		len = iov_iter_extract_pages(iter, &ppages, maxsize, nr, 0, &off);
+		if (len <= 0) {
+			if (!ret)
+				ret = len ?: -EIO;
+			break;
+		}
+
+		i = 0;
+		do {
+			size_t part = min_t(size_t, PAGE_SIZE - off, len);
+
+			if (skb_append_pagefrags(skb, pages[i++], off, part) < 0) {
+				if (!ret)
+					ret = -EMSGSIZE;
+				goto out;
+			}
+			off = 0;
+			ret += part;
+			maxsize -= part;
+			len -= part;
+		} while (len > 0);
+		if (maxsize <= 0)
+			break;
+	}
+
+out:
+	return ret;
+}
+
 static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 			       size_t len)
 {
@@ -2200,19 +2247,25 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
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
 
@@ -2224,13 +2277,21 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
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

