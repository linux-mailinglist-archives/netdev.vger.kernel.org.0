Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D36DE0BC
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjDKQNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjDKQMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B8A5FD5
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681229411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUYtJHWQHrlxATmFk6Zj0PzfCOzptdZvrIQb9VoBGYI=;
        b=HnT+DotneCt7DR7al3+YPTg0/+0XYiczODYFIzdw7vSZ9OGn0dR6Z4gZX/Z+0ik17mevvk
        6o1sbsBHMTA4tcFw1NzMl1b00OBWsCE1VM11HePvDkbA8sgi3XAKXd2vVR8HpHwp4IYQpM
        0QV0007t7UuJ7n5/TL+vtDFNgLynf2k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-v6vTLpRuNC-A8BVR-fqWyA-1; Tue, 11 Apr 2023 12:10:05 -0400
X-MC-Unique: v6vTLpRuNC-A8BVR-fqWyA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EF7F101A551;
        Tue, 11 Apr 2023 16:10:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B5F52166B31;
        Tue, 11 Apr 2023 16:10:01 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH net-next v6 18/18] af_unix: Support MSG_SPLICE_PAGES
Date:   Tue, 11 Apr 2023 17:09:02 +0100
Message-Id: <20230411160902.4134381-19-dhowells@redhat.com>
In-Reply-To: <20230411160902.4134381-1-dhowells@redhat.com>
References: <20230411160902.4134381-1-dhowells@redhat.com>
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
index ea45dcc80232..e1f962180e55 100644
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

