Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034496DE097
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjDKQLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjDKQLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:11:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C885243
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681229385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjJlYTxOmtT7wdKdf7S5Ju9QN7AtCPTA0VxjqyvYpeA=;
        b=MWqlIWRdPa0whDIiojxbX5C1Mh6VMOZoqXMUl6lgUg8x53UpXeNDRPlhn5S5Gs4y3S37zR
        sx5BF529E9ikm6waU//WxCVgJNJDmQ8wfPk76IS2ngEOyHOfyXc0IoAgySYEyd7c+U+qFW
        mqLlIAJtuwtmVTiY7V65hRz4/bocksU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-cmT0nmxaN_-wKHRfTU4xrw-1; Tue, 11 Apr 2023 12:09:39 -0400
X-MC-Unique: cmT0nmxaN_-wKHRfTU4xrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF7538149AF;
        Tue, 11 Apr 2023 16:09:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47A44C15BBA;
        Tue, 11 Apr 2023 16:09:35 +0000 (UTC)
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
        linux-mm@kvack.org, John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v6 09/18] tcp_bpf: Inline do_tcp_sendpages as it's now a wrapper around tcp_sendmsg
Date:   Tue, 11 Apr 2023 17:08:53 +0100
Message-Id: <20230411160902.4134381-10-dhowells@redhat.com>
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

do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
so inline it.  This is part of replacing ->sendpage() with a call to
sendmsg() with MSG_SPLICE_PAGES set.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Sitnicki <jakub@cloudflare.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: David Ahern <dsahern@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
cc: bpf@vger.kernel.org
---
 net/ipv4/tcp_bpf.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ebf917511937..24bfb885777e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -72,11 +72,13 @@ static int tcp_bpf_push(struct sock *sk, struct sk_msg *msg, u32 apply_bytes,
 {
 	bool apply = apply_bytes;
 	struct scatterlist *sge;
+	struct msghdr msghdr = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 	struct page *page;
 	int size, ret = 0;
 	u32 off;
 
 	while (1) {
+		struct bio_vec bvec;
 		bool has_tx_ulp;
 
 		sge = sk_msg_elem(msg, msg->sg.start);
@@ -88,16 +90,18 @@ static int tcp_bpf_push(struct sock *sk, struct sk_msg *msg, u32 apply_bytes,
 		tcp_rate_check_app_limited(sk);
 retry:
 		has_tx_ulp = tls_sw_has_ctx_tx(sk);
-		if (has_tx_ulp) {
-			flags |= MSG_SENDPAGE_NOPOLICY;
-			ret = kernel_sendpage_locked(sk,
-						     page, off, size, flags);
-		} else {
-			ret = do_tcp_sendpages(sk, page, off, size, flags);
-		}
+		if (has_tx_ulp)
+			msghdr.msg_flags |= MSG_SENDPAGE_NOPOLICY;
 
+		if (flags & MSG_SENDPAGE_NOTLAST)
+			msghdr.msg_flags |= MSG_MORE;
+
+		bvec_set_page(&bvec, page, size, off);
+		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, size);
+		ret = tcp_sendmsg_locked(sk, &msghdr, size);
 		if (ret <= 0)
 			return ret;
+
 		if (apply)
 			apply_bytes -= ret;
 		msg->sg.size -= ret;
@@ -404,7 +408,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	long timeo;
 	int flags;
 
-	/* Don't let internal do_tcp_sendpages() flags through */
+	/* Don't let internal sendpage flags through */
 	flags = (msg->msg_flags & ~MSG_SENDPAGE_DECRYPTED);
 	flags |= MSG_NO_SHARED_FRAGS;
 

