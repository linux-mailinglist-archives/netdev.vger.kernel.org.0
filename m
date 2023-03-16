Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFDC6BD38F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjCPP2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjCPP2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:28:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEB3B1EF5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5bgiBObt8qBauZcUWYsV1T0v3n3OqeoexntQtIJIREA=;
        b=Uqwa77lIeckkN0ZQ6LXQSULwvxRVwxKZJDoMQtkdrdbtZ2Ge9/hlAOi7UkYxCRXfKb3/vW
        vt67dT8jjkgdQn4yGRXN5I7GiB6mCbBHwMNYl7PpuWnORWEqQ4n7WV0QxB3A8//L6D4sPC
        i4ZN6YfYohyJb1ZVCm7pIDk22F5APK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-a51AlkUUOb-NXl1w0lE3CA-1; Thu, 16 Mar 2023 11:26:53 -0400
X-MC-Unique: a51AlkUUOb-NXl1w0lE3CA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 568E3185A7A7;
        Thu, 16 Mar 2023 15:26:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D49BC492B02;
        Thu, 16 Mar 2023 15:26:49 +0000 (UTC)
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC PATCH 11/28] udp: Convert udp_sendpage() to use MSG_SPLICE_PAGES
Date:   Thu, 16 Mar 2023 15:26:01 +0000
Message-Id: <20230316152618.711970-12-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert udp_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather than
directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/udp.c | 50 +++++++++-----------------------------------------
 1 file changed, 9 insertions(+), 41 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..097feb92e215 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1332,52 +1332,20 @@ EXPORT_SYMBOL(udp_sendmsg);
 int udp_sendpage(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags)
 {
-	struct inet_sock *inet = inet_sk(sk);
-	struct udp_sock *up = udp_sk(sk);
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags | MSG_SPLICE_PAGES | MSG_MORE
+	};
 	int ret;
 
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-	if (!up->pending) {
-		struct msghdr msg = {	.msg_flags = flags|MSG_MORE };
-
-		/* Call udp_sendmsg to specify destination address which
-		 * sendpage interface can't pass.
-		 * This will succeed only when the socket is connected.
-		 */
-		ret = udp_sendmsg(sk, &msg, 0);
-		if (ret < 0)
-			return ret;
-	}
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
 	lock_sock(sk);
-
-	if (unlikely(!up->pending)) {
-		release_sock(sk);
-
-		net_dbg_ratelimited("cork failed\n");
-		return -EINVAL;
-	}
-
-	ret = ip_append_page(sk, &inet->cork.fl.u.ip4,
-			     page, offset, size, flags);
-	if (ret == -EOPNOTSUPP) {
-		release_sock(sk);
-		return sock_no_sendpage(sk->sk_socket, page, offset,
-					size, flags);
-	}
-	if (ret < 0) {
-		udp_flush_pending_frames(sk);
-		goto out;
-	}
-
-	up->len += size;
-	if (!(READ_ONCE(up->corkflag) || (flags&MSG_MORE)))
-		ret = udp_push_pending_frames(sk);
-	if (!ret)
-		ret = size;
-out:
+	ret = udp_sendmsg(sk, &msg, size);
 	release_sock(sk);
 	return ret;
 }

