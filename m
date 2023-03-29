Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCC56CDC13
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjC2OTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjC2ORi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286025B85
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bb5tuF13A7AUAmGHrtoNc4Ue+Am7P92yBHtRqoRTTps=;
        b=hhYjQbJ1fkxa0DM66z+3KkqA+aFhTCJQUHPfdqj6Sh1z4JXTELHywAGR3ISLKgxpqfCixO
        IMF206hIGiKeUZSvuvLc/KIxdiXcoMe4U1yhoC6iDwJQ6NmECOHw8Y74PO3mnvddna2WM4
        3XOmaxFcC6mOl/BRd3Vlqk15G1e7lj4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-1vALR20tPYeGhBQuRt7gLg-1; Wed, 29 Mar 2023 10:14:42 -0400
X-MC-Unique: 1vALR20tPYeGhBQuRt7gLg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D8F81C0758E;
        Wed, 29 Mar 2023 14:14:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59D114020C82;
        Wed, 29 Mar 2023 14:14:39 +0000 (UTC)
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
Subject: [RFC PATCH v2 15/48] tcp: Fold do_tcp_sendpages() into tcp_sendpage_locked()
Date:   Wed, 29 Mar 2023 15:13:21 +0100
Message-Id: <20230329141354.516864-16-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fold do_tcp_sendpages() into its last remaining caller,
tcp_sendpage_locked().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/net/tcp.h |  2 --
 net/ipv4/tcp.c    | 26 ++++++++------------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..844bc8e6a714 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -333,8 +333,6 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
-ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
-		 size_t size, int flags);
 int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
 void tcp_push(struct sock *sk, int flags, int mss_now, int nonagle,
 	      int size_goal);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a1c5a6d9419c..a8f8ccaed10e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -971,14 +971,16 @@ static int tcp_wmem_schedule(struct sock *sk, int copy)
 	return min(copy, sk->sk_forward_alloc);
 }
 
-ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
-			 size_t size, int flags)
+int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
+			size_t size, int flags)
 {
 	struct bio_vec bvec;
-	struct msghdr msg = {
-		.msg_flags	= flags,
-		.msg_kflags	= MSG_SPLICE_PAGES,
-	};
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
+
+	if (!(sk->sk_route_caps & NETIF_F_SG))
+		return sock_no_sendpage_locked(sk, page, offset, size, flags);
+
+	tcp_rate_check_app_limited(sk);  /* is sending application-limited? */
 
 	bvec_set_page(&bvec, page, size, offset);
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
@@ -988,18 +990,6 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 
 	return tcp_sendmsg_locked(sk, &msg, size);
 }
-EXPORT_SYMBOL_GPL(do_tcp_sendpages);
-
-int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
-			size_t size, int flags)
-{
-	if (!(sk->sk_route_caps & NETIF_F_SG))
-		return sock_no_sendpage_locked(sk, page, offset, size, flags);
-
-	tcp_rate_check_app_limited(sk);  /* is sending application-limited? */
-
-	return do_tcp_sendpages(sk, page, offset, size, flags);
-}
 EXPORT_SYMBOL_GPL(tcp_sendpage_locked);
 
 int tcp_sendpage(struct sock *sk, struct page *page, int offset,

