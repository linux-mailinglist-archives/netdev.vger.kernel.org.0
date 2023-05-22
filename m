Return-Path: <netdev+bounces-4248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B796070BD42
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C09D1C20A7D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DA5D52D;
	Mon, 22 May 2023 12:12:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043AF14269
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:12:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4DB137
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684757544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVs0CsGrBKFATDm79TCVboT9gSnZlC7XDeXTGZfAJzM=;
	b=UbtONZjSlqYaw5tuOmwMSHGYPuwr1YMBexKN50cdDg6T8/pVj18TkMp/4oXFjpfwMKcjUu
	y/Qw8vbCO7XfjZ2dzZKy1xZ7LJHHXeymzKIRzhW55wotxif24l9lYxnIzh5CeucZGHMmtY
	sa16khsj8TPEJRJWRHVN90f9CFzmWCc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-LPYcjbL_PmKPilJ00U_9eQ-1; Mon, 22 May 2023 08:12:21 -0400
X-MC-Unique: LPYcjbL_PmKPilJ00U_9eQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 544FB3C0BE2F;
	Mon, 22 May 2023 12:12:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABF042029F6D;
	Mon, 22 May 2023 12:12:17 +0000 (UTC)
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
Subject: [PATCH net-next v10 14/16] ip: Remove ip_append_page()
Date: Mon, 22 May 2023 13:11:23 +0100
Message-Id: <20230522121125.2595254-15-dhowells@redhat.com>
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

ip_append_page() is no longer used with the removal of udp_sendpage(), so
remove it.

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
    ver #7)
     - Remove now-unused csum_page().

 include/net/ip.h     |   2 -
 net/ipv4/ip_output.c | 148 ++-----------------------------------------
 2 files changed, 4 insertions(+), 146 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..7627a4df893b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -220,8 +220,6 @@ int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 		   unsigned int flags);
 int ip_generic_getfrag(void *from, char *to, int offset, int len, int odd,
 		       struct sk_buff *skb);
-ssize_t ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
-		       int offset, size_t size, int flags);
 struct sk_buff *__ip_make_skb(struct sock *sk, struct flowi4 *fl4,
 			      struct sk_buff_head *queue,
 			      struct inet_cork *cork);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c7db973b5d29..553c740a6bfb 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -946,17 +946,6 @@ ip_generic_getfrag(void *from, char *to, int offset, int len, int odd, struct sk
 }
 EXPORT_SYMBOL(ip_generic_getfrag);
 
-static inline __wsum
-csum_page(struct page *page, int offset, int copy)
-{
-	char *kaddr;
-	__wsum csum;
-	kaddr = kmap(page);
-	csum = csum_partial(kaddr + offset, copy, 0);
-	kunmap(page);
-	return csum;
-}
-
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
 			    struct sk_buff_head *queue,
@@ -1327,10 +1316,10 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 }
 
 /*
- *	ip_append_data() and ip_append_page() can make one large IP datagram
- *	from many pieces of data. Each pieces will be holded on the socket
- *	until ip_push_pending_frames() is called. Each piece can be a page
- *	or non-page data.
+ *	ip_append_data() can make one large IP datagram from many pieces of
+ *	data.  Each piece will be held on the socket until
+ *	ip_push_pending_frames() is called. Each piece can be a page or
+ *	non-page data.
  *
  *	Not only UDP, other transport protocols - e.g. raw sockets - can use
  *	this interface potentially.
@@ -1363,135 +1352,6 @@ int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 				from, length, transhdrlen, flags);
 }
 
-ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
-		       int offset, size_t size, int flags)
-{
-	struct inet_sock *inet = inet_sk(sk);
-	struct sk_buff *skb;
-	struct rtable *rt;
-	struct ip_options *opt = NULL;
-	struct inet_cork *cork;
-	int hh_len;
-	int mtu;
-	int len;
-	int err;
-	unsigned int maxfraglen, fragheaderlen, fraggap, maxnonfragsize;
-
-	if (inet->hdrincl)
-		return -EPERM;
-
-	if (flags&MSG_PROBE)
-		return 0;
-
-	if (skb_queue_empty(&sk->sk_write_queue))
-		return -EINVAL;
-
-	cork = &inet->cork.base;
-	rt = (struct rtable *)cork->dst;
-	if (cork->flags & IPCORK_OPT)
-		opt = cork->opt;
-
-	if (!(rt->dst.dev->features & NETIF_F_SG))
-		return -EOPNOTSUPP;
-
-	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
-	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
-
-	fragheaderlen = sizeof(struct iphdr) + (opt ? opt->optlen : 0);
-	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen;
-	maxnonfragsize = ip_sk_ignore_df(sk) ? 0xFFFF : mtu;
-
-	if (cork->length + size > maxnonfragsize - fragheaderlen) {
-		ip_local_error(sk, EMSGSIZE, fl4->daddr, inet->inet_dport,
-			       mtu - (opt ? opt->optlen : 0));
-		return -EMSGSIZE;
-	}
-
-	skb = skb_peek_tail(&sk->sk_write_queue);
-	if (!skb)
-		return -EINVAL;
-
-	cork->length += size;
-
-	while (size > 0) {
-		/* Check if the remaining data fits into current packet. */
-		len = mtu - skb->len;
-		if (len < size)
-			len = maxfraglen - skb->len;
-
-		if (len <= 0) {
-			struct sk_buff *skb_prev;
-			int alloclen;
-
-			skb_prev = skb;
-			fraggap = skb_prev->len - maxfraglen;
-
-			alloclen = fragheaderlen + hh_len + fraggap + 15;
-			skb = sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
-			if (unlikely(!skb)) {
-				err = -ENOBUFS;
-				goto error;
-			}
-
-			/*
-			 *	Fill in the control structures
-			 */
-			skb->ip_summed = CHECKSUM_NONE;
-			skb->csum = 0;
-			skb_reserve(skb, hh_len);
-
-			/*
-			 *	Find where to start putting bytes.
-			 */
-			skb_put(skb, fragheaderlen + fraggap);
-			skb_reset_network_header(skb);
-			skb->transport_header = (skb->network_header +
-						 fragheaderlen);
-			if (fraggap) {
-				skb->csum = skb_copy_and_csum_bits(skb_prev,
-								   maxfraglen,
-						    skb_transport_header(skb),
-								   fraggap);
-				skb_prev->csum = csum_sub(skb_prev->csum,
-							  skb->csum);
-				pskb_trim_unique(skb_prev, maxfraglen);
-			}
-
-			/*
-			 * Put the packet on the pending queue.
-			 */
-			__skb_queue_tail(&sk->sk_write_queue, skb);
-			continue;
-		}
-
-		if (len > size)
-			len = size;
-
-		if (skb_append_pagefrags(skb, page, offset, len,
-					 MAX_SKB_FRAGS)) {
-			err = -EMSGSIZE;
-			goto error;
-		}
-
-		if (skb->ip_summed == CHECKSUM_NONE) {
-			__wsum csum;
-			csum = csum_page(page, offset, len);
-			skb->csum = csum_block_add(skb->csum, csum, skb->len);
-		}
-
-		skb_len_add(skb, len);
-		refcount_add(len, &sk->sk_wmem_alloc);
-		offset += len;
-		size -= len;
-	}
-	return 0;
-
-error:
-	cork->length -= size;
-	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTDISCARDS);
-	return err;
-}
-
 static void ip_cork_release(struct inet_cork *cork)
 {
 	cork->flags &= ~IPCORK_OPT;


