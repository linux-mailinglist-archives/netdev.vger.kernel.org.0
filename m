Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0C6CDBED
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjC2OSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjC2ORQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:17:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB965591
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62BPou+xERgiMp9fd3+/fNOBk5TLUi4yt2oNbndQPtM=;
        b=F5oOB1ygMDRvgKz8WkQa5ScAeAsLpoXWJrOjNs5WQPBA0dyIp7cJwAgjLeYxTRiForsOw0
        o+aHo845j5LMDOpSib7aMWAz2niAZfkRzU1miGiv6DVOlD0lpaK8P/sbDfHcCxe5RzdtH4
        jeS6cTZIhN/Utkk3PmzY34lmkDKGFhY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-xczYM2jqMimXt-WLCPIA-g-1; Wed, 29 Mar 2023 10:14:23 -0400
X-MC-Unique: xczYM2jqMimXt-WLCPIA-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A6F1100DEAF;
        Wed, 29 Mar 2023 14:14:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 850CF14171BB;
        Wed, 29 Mar 2023 14:14:20 +0000 (UTC)
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
Subject: [RFC PATCH v2 08/48] tcp: Support MSG_SPLICE_PAGES
Date:   Wed, 29 Mar 2023 15:13:14 +0100
Message-Id: <20230329141354.516864-9-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
spliced from the source iterator if possible (the iterator must be
ITER_BVEC and the pages must be spliceable).

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
index 288693981b00..910b327c236e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1220,7 +1220,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int flags, err, copied = 0;
 	int mss_now = 0, size_goal, copied_syn = 0;
 	int process_backlog = 0;
-	bool zc = false;
+	int zc = 0;
 	long timeo;
 
 	flags = msg->msg_flags;
@@ -1231,17 +1231,22 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
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
@@ -1304,7 +1309,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		goto do_error;
 
 	while (msg_data_left(msg)) {
-		int copy = 0;
+		ssize_t copy = 0;
 
 		skb = tcp_write_queue_tail(sk);
 		if (skb)
@@ -1345,7 +1350,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (!zc) {
+		if (zc == 0) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
@@ -1390,7 +1395,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
-		} else {
+		} else if (zc == 1)  {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
 			 */
@@ -1411,6 +1416,54 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
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

