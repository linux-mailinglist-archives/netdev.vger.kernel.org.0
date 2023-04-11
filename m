Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB26DE0B3
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjDKQMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjDKQLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B2D59E7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681229403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arPLIYOMzcdUPWLjuF22tHo0vP4jVzFFThikgCzP+CE=;
        b=TLfy06G7+4XmPtA9pv/QcfpLk8AaMjieTXdznN+SUqZhF8irFn9jCIne2sq6HItzbuBCfe
        D5tv8CMj1Q0cI9797cidfn2grrAseR16Mk9PaaHBMUgEs9BqXivHM7LrzZemR0jbEgjsSs
        xdWGN6VvroUKgsRQF21c4yiPAvPN3I0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-FiOc-vDHMJaCmdO7Voy_uA-1; Tue, 11 Apr 2023 12:10:01 -0400
X-MC-Unique: FiOc-vDHMJaCmdO7Voy_uA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FEBC38149AF;
        Tue, 11 Apr 2023 16:09:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75192C15BB8;
        Tue, 11 Apr 2023 16:09:56 +0000 (UTC)
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
        linux-mm@kvack.org
Subject: [PATCH net-next v6 16/18] udp: Convert udp_sendpage() to use MSG_SPLICE_PAGES
Date:   Tue, 11 Apr 2023 17:09:00 +0100
Message-Id: <20230411160902.4134381-17-dhowells@redhat.com>
In-Reply-To: <20230411160902.4134381-1-dhowells@redhat.com>
References: <20230411160902.4134381-1-dhowells@redhat.com>
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

Convert udp_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather than
directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: David Ahern <dsahern@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---

Notes:
    ver #6)
     - udp_sendpage() shouldn't lock the socket around udp_sendpage().
     - udp_sendpage() should only set MSG_MORE if MSG_SENDPAGE_NOTLAST is set.

 net/ipv4/udp.c | 51 ++++++--------------------------------------------
 1 file changed, 6 insertions(+), 45 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa32afd871ee..2879dc6d66ea 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1332,54 +1332,15 @@ EXPORT_SYMBOL(udp_sendmsg);
 int udp_sendpage(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags)
 {
-	struct inet_sock *inet = inet_sk(sk);
-	struct udp_sock *up = udp_sk(sk);
-	int ret;
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES };
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
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
-
-	lock_sock(sk);
+		msg.msg_flags |= MSG_MORE;
 
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
-	release_sock(sk);
-	return ret;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return udp_sendmsg(sk, &msg, size);
 }
 
 #define UDP_SKB_IS_STATELESS 0x80000000

