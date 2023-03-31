Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D096D251C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjCaQPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjCaQOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033C924AFC
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZJQb7iAop4LtoT19/C7V+Vk0vTB0ScTwxSGzzmAlmQ=;
        b=KqHg1Nvg+arQ+kR2Cxc418beuYylY+1nMRRWkfruo63zMvavLdNA02bh47RY9HHrnOZZ6x
        H+FmpqeyQdkFuinFrbRlEBrdfg/UXvm6+lFgppNX8cFooqXpDmM1rBZ4sZq3Pl8LTb62nN
        nv49nWvdKQfb4aqrCZw6m57YbE72ia0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-s0-9Da1IPNaVGNWY3Pu9-w-1; Fri, 31 Mar 2023 12:10:42 -0400
X-MC-Unique: s0-9Da1IPNaVGNWY3Pu9-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8BF029ABA1D;
        Fri, 31 Mar 2023 16:10:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7E464020C82;
        Fri, 31 Mar 2023 16:10:39 +0000 (UTC)
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
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 29/55] tls/sw: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:48 +0100
Message-Id: <20230331160914.1608208-30-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
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

Make TLS's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator if possible and copied the data if not.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/tls/tls_sw.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 782d3701b86f..ce0c289e68ca 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -929,6 +929,49 @@ static int tls_sw_push_pending_record(struct sock *sk, int flags)
 				   &copied, flags);
 }
 
+static int rls_sw_sendmsg_splice(struct sock *sk, struct msghdr *msg,
+				 struct sk_msg *msg_pl, size_t try_to_copy,
+				 ssize_t *copied)
+{
+	struct page *page, **pages = &page;
+
+	do {
+		ssize_t part;
+		size_t off;
+		bool put = false;
+
+		part = iov_iter_extract_pages(&msg->msg_iter, &pages,
+					      try_to_copy, 1, 0, &off);
+		if (part <= 0)
+			return part ?: -EIO;
+
+		if (!sendpage_ok(page)) {
+			const void *p = kmap_local_page(page);
+			void *q;
+
+			q = page_frag_memdup(NULL, p + off, part,
+					     sk->sk_allocation, ULONG_MAX);
+			kunmap_local(p);
+			if (!q) {
+				iov_iter_revert(&msg->msg_iter, part);
+				return -ENOMEM;
+			}
+			page = virt_to_page(q);
+			off = offset_in_page(q);
+			put = true;
+		}
+
+		sk_msg_page_add(msg_pl, page, part, off);
+		sk_mem_charge(sk, part);
+		if (put)
+			put_page(page);
+		*copied += part;
+		try_to_copy -= part;
+	} while (try_to_copy && !sk_msg_full(msg_pl));
+
+	return 0;
+}
+
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
@@ -1016,6 +1059,17 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			full_record = true;
 		}
 
+		if (try_to_copy && (msg->msg_flags & MSG_SPLICE_PAGES)) {
+			ret = rls_sw_sendmsg_splice(sk, msg, msg_pl,
+						    try_to_copy, &copied);
+			if (ret < 0)
+				goto send_end;
+			tls_ctx->pending_open_record_frags = true;
+			if (full_record || eor || sk_msg_full(msg_pl))
+				goto copied;
+			continue;
+		}
+
 		if (!is_kvec && (full_record || eor) && !async_capable) {
 			u32 first = msg_pl->sg.end;
 
@@ -1078,8 +1132,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		/* Open records defined only if successfully copied, otherwise
 		 * we would trim the sg but not reset the open record frags.
 		 */
-		tls_ctx->pending_open_record_frags = true;
 		copied += try_to_copy;
+copied:
+		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor) {
 			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
 						  record_type, &copied,

