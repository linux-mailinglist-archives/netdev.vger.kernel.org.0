Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300E76D255A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjCaQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjCaQUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:20:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5A32CAF1
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lLisHPaWAEED9gZclxyhbGIkHvgJDoUiXuyeeqOKByg=;
        b=NWRAUciix9RSL7EHhr7ULPI89kB6qNwW+fJsMh/tpfRnOld8NsBq3hwjWSJWsxNK7/QFdB
        16CTkKyD/8y/4Cc0EukETicAumcjJoiY2eKWnIQVNeozetlblJ4x0T2Rz6ErfEqDCAe5DO
        RaexwA/QV1Jif2l+gfSrYH+gAgLJXpk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-FA2oWpmKPhmcnajIovqg2A-1; Fri, 31 Mar 2023 12:11:20 -0400
X-MC-Unique: FA2oWpmKPhmcnajIovqg2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7A3129ABA1C;
        Fri, 31 Mar 2023 16:11:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4EDD2027040;
        Fri, 31 Mar 2023 16:11:17 +0000 (UTC)
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 43/55] net: Use sendmsg(MSG_SPLICE_PAGES) not sendpage in skb_send_sock()
Date:   Fri, 31 Mar 2023 17:09:02 +0100
Message-Id: <20230331160914.1608208-44-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use sendmsg() with MSG_SPLICE_PAGES rather than sendpage in
skb_send_sock().  This causes pages to be spliced from the source iterator
if possible (the iterator must be ITER_BVEC and the pages must be
spliceable).

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Note that this could perhaps be improved to fill out a bvec array with all
the frags and then make a single sendmsg call, possibly sticking the header
on the front also.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/core/skbuff.c | 49 ++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0506e4cf1ed9..3693b3526d33 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2919,32 +2919,32 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(skb_splice_bits);
 
-static int sendmsg_unlocked(struct sock *sk, struct msghdr *msg,
-			    struct kvec *vec, size_t num, size_t size)
+static int sendmsg_locked(struct sock *sk, struct msghdr *msg)
 {
 	struct socket *sock = sk->sk_socket;
+	size_t size = msg_data_left(msg);
 
 	if (!sock)
 		return -EINVAL;
-	return kernel_sendmsg(sock, msg, vec, num, size);
+
+	if (!sock->ops->sendmsg_locked)
+		return sock_no_sendmsg_locked(sk, msg, size);
+
+	return sock->ops->sendmsg_locked(sk, msg, size);
 }
 
-static int sendpage_unlocked(struct sock *sk, struct page *page, int offset,
-			     size_t size, int flags)
+static int sendmsg_unlocked(struct sock *sk, struct msghdr *msg)
 {
 	struct socket *sock = sk->sk_socket;
 
 	if (!sock)
 		return -EINVAL;
-	return kernel_sendpage(sock, page, offset, size, flags);
+	return sock_sendmsg(sock, msg);
 }
 
-typedef int (*sendmsg_func)(struct sock *sk, struct msghdr *msg,
-			    struct kvec *vec, size_t num, size_t size);
-typedef int (*sendpage_func)(struct sock *sk, struct page *page, int offset,
-			     size_t size, int flags);
+typedef int (*sendmsg_func)(struct sock *sk, struct msghdr *msg);
 static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
-			   int len, sendmsg_func sendmsg, sendpage_func sendpage)
+			   int len, sendmsg_func sendmsg)
 {
 	unsigned int orig_len = len;
 	struct sk_buff *head = skb;
@@ -2964,8 +2964,9 @@ static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
 		memset(&msg, 0, sizeof(msg));
 		msg.msg_flags = MSG_DONTWAIT;
 
-		ret = INDIRECT_CALL_2(sendmsg, kernel_sendmsg_locked,
-				      sendmsg_unlocked, sk, &msg, &kv, 1, slen);
+		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &kv, 1, slen);
+		ret = INDIRECT_CALL_2(sendmsg, sendmsg_locked,
+				      sendmsg_unlocked, sk, &msg);
 		if (ret <= 0)
 			goto error;
 
@@ -2996,11 +2997,17 @@ static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
 		slen = min_t(size_t, len, skb_frag_size(frag) - offset);
 
 		while (slen) {
-			ret = INDIRECT_CALL_2(sendpage, kernel_sendpage_locked,
-					      sendpage_unlocked, sk,
-					      skb_frag_page(frag),
-					      skb_frag_off(frag) + offset,
-					      slen, MSG_DONTWAIT);
+			struct bio_vec bvec;
+			struct msghdr msg = {
+				.msg_flags = MSG_SPLICE_PAGES | MSG_DONTWAIT,
+			};
+
+			bvec_set_page(&bvec, skb_frag_page(frag), slen,
+				      skb_frag_off(frag) + offset);
+			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, slen);
+
+			ret = INDIRECT_CALL_2(sendmsg, sendmsg_locked,
+					      sendmsg_unlocked, sk, &msg);
 			if (ret <= 0)
 				goto error;
 
@@ -3037,16 +3044,14 @@ static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
 int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 			 int len)
 {
-	return __skb_send_sock(sk, skb, offset, len, kernel_sendmsg_locked,
-			       kernel_sendpage_locked);
+	return __skb_send_sock(sk, skb, offset, len, sendmsg_locked);
 }
 EXPORT_SYMBOL_GPL(skb_send_sock_locked);
 
 /* Send skb data on a socket. Socket must be unlocked. */
 int skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset, int len)
 {
-	return __skb_send_sock(sk, skb, offset, len, sendmsg_unlocked,
-			       sendpage_unlocked);
+	return __skb_send_sock(sk, skb, offset, len, sendmsg_unlocked);
 }
 
 /**

