Return-Path: <netdev+bounces-2587-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 590537028EB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15088280D5C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E2FC140;
	Mon, 15 May 2023 09:35:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9221C8FC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:35:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26F6171E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684143301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sbDm+4sgaynAjmiQFVbDl+OyfXvG2vWGJtRH+IAST4=;
	b=BROK7wjIjZH1I1h6TMoNEVsU3oe3BP4pxq8ZGXJ8EYbQ1Xa7mgiGnCwMr7AHZHusvWkm4M
	UJeIaegG68w39BoqPTDB05SrbPncRely+RGFh2CVw+S0kqArK5cDZUTSaUcttTcOxzcB8D
	aGk7DLJS1F1QdoDH91Gyc4aO7k7Y+MI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-oLogL-wgMESbZ_pbZl0Txg-1; Mon, 15 May 2023 05:34:55 -0400
X-MC-Unique: oLogL-wgMESbZ_pbZl0Txg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE904185A79C;
	Mon, 15 May 2023 09:34:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E86781121314;
	Mon, 15 May 2023 09:34:51 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH net-next v7 15/16] af_unix: Support MSG_SPLICE_PAGES
Date: Mon, 15 May 2023 10:33:44 +0100
Message-Id: <20230515093345.396978-16-dhowells@redhat.com>
In-Reply-To: <20230515093345.396978-1-dhowells@redhat.com>
References: <20230515093345.396978-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make AF_UNIX sendmsg() support MSG_SPLICE_PAGES, splicing in pages from the
source iterator if possible and copying the data in otherwise.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Kuniyuki Iwashima <kuniyu@amazon.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---

Notes:
    ver #6)
     - Use common helper.

 net/unix/af_unix.c | 49 +++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dd55506b4632..976bc1c5e11b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2200,19 +2200,25 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
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
 
@@ -2224,13 +2230,24 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
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
+			err = skb_splice_from_iter(skb, &msg->msg_iter, size,
+						   sk->sk_allocation);
+			if (err < 0) {
+				kfree_skb(skb);
+				goto out_err;
+			}
+			size = err;
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


