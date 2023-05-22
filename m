Return-Path: <netdev+bounces-4246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8997C70BD3F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D0DA1C209E9
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0457C13AF4;
	Mon, 22 May 2023 12:12:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F113AEF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:12:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42A8110
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684757539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=arPLIYOMzcdUPWLjuF22tHo0vP4jVzFFThikgCzP+CE=;
	b=gNEBrb2+7QCk6oqJRxymmU2zNQ1qUWvTbpjt4XQnlR97+GayVv49U4ZLO94yy6Vsxn0Vzu
	dE2e3/jN1bYNV+SXQaP9xlBlH8CLuLTQuILSXCI6aoz91yf3VxrPVhsHiucuIvd3uOMKf5
	Yv1TbqZ7ZCI65CYoXM8EpicRj6Whbgg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-eMUMHyWdN1qeVHDjTVvlzg-1; Mon, 22 May 2023 08:12:17 -0400
X-MC-Unique: eMUMHyWdN1qeVHDjTVvlzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF505185A78B;
	Mon, 22 May 2023 12:12:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4439120296C6;
	Mon, 22 May 2023 12:12:14 +0000 (UTC)
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
	linux-mm@kvack.org
Subject: [PATCH net-next v10 13/16] udp: Convert udp_sendpage() to use MSG_SPLICE_PAGES
Date: Mon, 22 May 2023 13:11:22 +0100
Message-Id: <20230522121125.2595254-14-dhowells@redhat.com>
In-Reply-To: <20230522121125.2595254-1-dhowells@redhat.com>
References: <20230522121125.2595254-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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


