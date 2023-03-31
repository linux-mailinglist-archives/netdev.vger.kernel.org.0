Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1046D254F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjCaQTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjCaQSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49D222200
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLmy3QT3PxPcXOXP8Tmrcj7ottmHeL6VPbhO66kxXIU=;
        b=enhAX9fit+AQfG0clBTShXx+9B3wCCQBRFTRk9Jw5bbaAJ8Lfh+C4hPeJSp59jRX1ce0kY
        rd1RiHAMwrv5r8gDCtXv7fOj6han5qYaqud02JTRu6qrFpH+r7h4PO1MelW1NT42FnBpUT
        4pvBpvA8f3E4RNins/u4ZcoCeMcAflY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-Fj3IfQ9LOuGHr1f7veDhWA-1; Fri, 31 Mar 2023 12:11:18 -0400
X-MC-Unique: Fj3IfQ9LOuGHr1f7veDhWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30B60886065;
        Fri, 31 Mar 2023 16:11:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 072FE202701E;
        Fri, 31 Mar 2023 16:11:14 +0000 (UTC)
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
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Subject: [PATCH v3 42/55] tcp_bpf: Make tcp_bpf_sendpage() go through tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
Date:   Fri, 31 Mar 2023 17:09:01 +0100
Message-Id: <20230331160914.1608208-43-dhowells@redhat.com>
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

Translate tcp_bpf_sendpage() calls to tcp_bpf_sendmsg(MSG_SPLICE_PAGES).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Sitnicki <jakub@cloudflare.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: bpf@vger.kernel.org
cc: netdev@vger.kernel.org
---
 net/ipv4/tcp_bpf.c | 49 +++++++++-------------------------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7f17134637eb..de37a4372437 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -485,49 +485,18 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
 			    size_t size, int flags)
 {
-	struct sk_msg tmp, *msg = NULL;
-	int err = 0, copied = 0;
-	struct sk_psock *psock;
-	bool enospc = false;
-
-	psock = sk_psock_get(sk);
-	if (unlikely(!psock))
-		return tcp_sendpage(sk, page, offset, size, flags);
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags | MSG_SPLICE_PAGES,
+	};
 
-	lock_sock(sk);
-	if (psock->cork) {
-		msg = psock->cork;
-	} else {
-		msg = &tmp;
-		sk_msg_init(msg);
-	}
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-	/* Catch case where ring is full and sendpage is stalled. */
-	if (unlikely(sk_msg_full(msg)))
-		goto out_err;
-
-	sk_msg_page_add(msg, page, size, offset);
-	sk_mem_charge(sk, size);
-	copied = size;
-	if (sk_msg_full(msg))
-		enospc = true;
-	if (psock->cork_bytes) {
-		if (size > psock->cork_bytes)
-			psock->cork_bytes = 0;
-		else
-			psock->cork_bytes -= size;
-		if (psock->cork_bytes && !enospc)
-			goto out_err;
-		/* All cork bytes are accounted, rerun the prog. */
-		psock->eval = __SK_NONE;
-		psock->cork_bytes = 0;
-	}
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	err = tcp_bpf_send_verdict(sk, psock, msg, &copied, flags);
-out_err:
-	release_sock(sk);
-	sk_psock_put(sk, psock);
-	return copied ? copied : err;
+	return tcp_bpf_sendmsg(sk, &msg, size);
 }
 
 enum {

