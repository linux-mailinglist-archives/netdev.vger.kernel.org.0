Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36106D8447
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjDEQ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbjDEQ4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193045BA1
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gNgTI4ct3B9VKtnPZ5NdE6sXYdaZCQGxwVn8DWUxWC8=;
        b=CUtIQW5RaYapkoFe6kEr07WJwagtS3QkHkDkFyUUQMnbelSzz2j261/k9b3InaxO9iapge
        ykmwTOvehpVe9vcfIkZiqmW+bLNqv92fUAqPrxUy5syAzQvgi0MiILwrE4b3gYUwpCQQmx
        0ek4Mo1NgCv0rs6007KyUYIuaEu25Lk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-HgV9LYxTO12prleccTyfZw-1; Wed, 05 Apr 2023 12:54:04 -0400
X-MC-Unique: HgV9LYxTO12prleccTyfZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CFB588904B;
        Wed,  5 Apr 2023 16:54:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53E15C1602A;
        Wed,  5 Apr 2023 16:54:01 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH net-next v4 06/20] tcp: Support MSG_SPLICE_PAGES
Date:   Wed,  5 Apr 2023 17:53:25 +0100
Message-Id: <20230405165339.3468808-7-dhowells@redhat.com>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
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

Make TCP's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/tcp.c | 67 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fd68d49490f2..510bacc7ce7b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1221,7 +1221,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int flags, err, copied = 0;
 	int mss_now = 0, size_goal, copied_syn = 0;
 	int process_backlog = 0;
-	bool zc = false;
+	int zc = 0;
 	long timeo;
 
 	flags = msg->msg_flags;
@@ -1232,17 +1232,22 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
 			net_zcopy_get(uarg);
-			zc = sk->sk_route_caps & NETIF_F_SG;
+			if (sk->sk_route_caps & NETIF_F_SG)
+				zc = 1;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
 			if (!uarg) {
 				err = -ENOBUFS;
 				goto out_err;
 			}
-			zc = sk->sk_route_caps & NETIF_F_SG;
-			if (!zc)
+			if (sk->sk_route_caps & NETIF_F_SG)
+				zc = 1;
+			else
 				uarg_to_msgzc(uarg)->zerocopy = 0;
 		}
+	} else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
+		if (sk->sk_route_caps & NETIF_F_SG)
+			zc = 2;
 	}
 
 	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
@@ -1305,7 +1310,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		goto do_error;
 
 	while (msg_data_left(msg)) {
-		int copy = 0;
+		ssize_t copy = 0;
 
 		skb = tcp_write_queue_tail(sk);
 		if (skb)
@@ -1346,7 +1351,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (!zc) {
+		if (zc == 0) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
@@ -1391,7 +1396,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
-		} else {
+		} else if (zc == 1)  {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
 			 */
@@ -1412,6 +1417,54 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (err < 0)
 				goto do_error;
 			copy = err;
+		} else if (zc == 2) {
+			/* Splice in data. */
+			struct page *page = NULL, **pages = &page;
+			size_t off = 0, part;
+			bool can_coalesce;
+			int i = skb_shinfo(skb)->nr_frags;
+
+			copy = iov_iter_extract_pages(&msg->msg_iter, &pages,
+						      copy, 1, 0, &off);
+			if (copy <= 0) {
+				err = copy ?: -EIO;
+				goto do_error;
+			}
+
+			can_coalesce = skb_can_coalesce(skb, i, page, off);
+			if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
+				tcp_mark_push(tp, skb);
+				iov_iter_revert(&msg->msg_iter, copy);
+				goto new_segment;
+			}
+			if (tcp_downgrade_zcopy_pure(sk, skb)) {
+				iov_iter_revert(&msg->msg_iter, copy);
+				goto wait_for_space;
+			}
+
+			part = tcp_wmem_schedule(sk, copy);
+			iov_iter_revert(&msg->msg_iter, copy - part);
+			if (!part)
+				goto wait_for_space;
+			copy = part;
+
+			if (can_coalesce) {
+				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+			} else {
+				get_page(page);
+				skb_fill_page_desc_noacc(skb, i, page, off, copy);
+			}
+			page = NULL;
+
+			if (!(flags & MSG_NO_SHARED_FRAGS))
+				skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
+
+			skb->len += copy;
+			skb->data_len += copy;
+			skb->truesize += copy;
+			sk_wmem_queued_add(sk, copy);
+			sk_mem_charge(sk, copy);
+
 		}
 
 		if (!copied)

