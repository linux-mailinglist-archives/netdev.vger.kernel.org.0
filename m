Return-Path: <netdev+bounces-2576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FF57028BC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 698BA1C20B17
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F2EC144;
	Mon, 15 May 2023 09:34:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC85C142
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:34:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA0E52
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684143256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZXfiar5CKohUwsPymjzwnCAT+wFqXG5Kam/6y6M8pg=;
	b=gbYYjQ9IZqy50Ie6ARlOMuDWgB0bCBCcEiV78Tb/RAn+S9RorosZE1t/LP1CmhvQ7XWNBc
	HXH0mj2ctWqXCQev6pfK4QNa3FO1WGVQ1L6Ct9aWwvsjiNptpWmBR0kMq0Z2eH+2ey0peO
	uJRBJwUiVfmYetsY0fbRx1GOVsNfiME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-QGYT3avTOnGhGIbiGpk5qg-1; Mon, 15 May 2023 05:34:09 -0400
X-MC-Unique: QGYT3avTOnGhGIbiGpk5qg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 360B3811E7C;
	Mon, 15 May 2023 09:34:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F615C15BA0;
	Mon, 15 May 2023 09:34:05 +0000 (UTC)
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
Subject: [PATCH net-next v7 04/16] tcp: Support MSG_SPLICE_PAGES
Date: Mon, 15 May 2023 10:33:33 +0100
Message-Id: <20230515093345.396978-5-dhowells@redhat.com>
In-Reply-To: <20230515093345.396978-1-dhowells@redhat.com>
References: <20230515093345.396978-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make TCP's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced or copied (if it cannot be spliced) from the source iterator.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: David Ahern <dsahern@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---

Notes:
    ver #7)
     - Missed a "zc = 1" in tcp_sendmsg_locked().
    
    ver #6)
     - Set zc to 0/MSG_ZEROCOPY/MSG_SPLICE_PAGES rather than 0/1/2.
     - Use common helper.

 net/ipv4/tcp.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a..026f483f42e3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1223,7 +1223,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int flags, err, copied = 0;
 	int mss_now = 0, size_goal, copied_syn = 0;
 	int process_backlog = 0;
-	bool zc = false;
+	int zc = 0;
 	long timeo;
 
 	flags = msg->msg_flags;
@@ -1234,17 +1234,22 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
 			net_zcopy_get(uarg);
-			zc = sk->sk_route_caps & NETIF_F_SG;
+			if (sk->sk_route_caps & NETIF_F_SG)
+				zc = MSG_ZEROCOPY;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
 			if (!uarg) {
 				err = -ENOBUFS;
 				goto out_err;
 			}
-			zc = sk->sk_route_caps & NETIF_F_SG;
-			if (!zc)
+			if (sk->sk_route_caps & NETIF_F_SG)
+				zc = MSG_ZEROCOPY;
+			else
 				uarg_to_msgzc(uarg)->zerocopy = 0;
 		}
+	} else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
+		if (sk->sk_route_caps & NETIF_F_SG)
+			zc = MSG_SPLICE_PAGES;
 	}
 
 	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
@@ -1307,7 +1312,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		goto do_error;
 
 	while (msg_data_left(msg)) {
-		int copy = 0;
+		ssize_t copy = 0;
 
 		skb = tcp_write_queue_tail(sk);
 		if (skb)
@@ -1348,7 +1353,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (!zc) {
+		if (zc == 0) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
@@ -1393,7 +1398,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
-		} else {
+		} else if (zc == MSG_ZEROCOPY)  {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
 			 */
@@ -1414,6 +1419,30 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (err < 0)
 				goto do_error;
 			copy = err;
+		} else if (zc == MSG_SPLICE_PAGES) {
+			/* Splice in data if we can; copy if we can't. */
+			if (tcp_downgrade_zcopy_pure(sk, skb))
+				goto wait_for_space;
+			copy = tcp_wmem_schedule(sk, copy);
+			if (!copy)
+				goto wait_for_space;
+
+			err = skb_splice_from_iter(skb, &msg->msg_iter, copy,
+						   sk->sk_allocation);
+			if (err < 0) {
+				if (err == -EMSGSIZE) {
+					tcp_mark_push(tp, skb);
+					goto new_segment;
+				}
+				goto do_error;
+			}
+			copy = err;
+
+			if (!(flags & MSG_NO_SHARED_FRAGS))
+				skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
+
+			sk_wmem_queued_add(sk, copy);
+			sk_mem_charge(sk, copy);
 		}
 
 		if (!copied)


