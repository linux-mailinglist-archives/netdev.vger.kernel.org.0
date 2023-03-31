Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA16D24E4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCaQM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjCaQLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:11:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA3622903
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zS5R68pySMwmjEGC4becLd7BE+l3zHJhW5dAqXR21oE=;
        b=bewGvrouT/i8buf28/2iX9EO5Dr4rVLja2HZkOGlKk4sqhwYVUZ5eDKv5H5enNZGX0hqm0
        RcSm7xOpaT69xYICt2+8t0Fu0z32waAto/MKK4YIbKbCz9G3Cna/xo834crB230ext4rzQ
        Z4eBq91n26Rvw2kUlgn8zerXRz1POCY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-_6_3ZMiSNHmxuLq7kZsEhw-1; Fri, 31 Mar 2023 12:10:05 -0400
X-MC-Unique: _6_3ZMiSNHmxuLq7kZsEhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1890F3C0D1AE;
        Fri, 31 Mar 2023 16:10:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F5EC2166B33;
        Fri, 31 Mar 2023 16:10:02 +0000 (UTC)
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
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v3 15/55] ip, udp: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:34 +0100
Message-Id: <20230331160914.1608208-16-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make IP/UDP sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/ip_output.c | 102 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 99 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 4e4e308c3230..e2eaba817c1f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -956,6 +956,79 @@ csum_page(struct page *page, int offset, int copy)
 	return csum;
 }
 
+/*
+ * Allocate a packet for MSG_SPLICE_PAGES.
+ */
+static int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
+			     unsigned int fragheaderlen, unsigned int maxfraglen,
+			     unsigned int hh_len)
+{
+	struct sk_buff *skb_prev = *pskb, *skb;
+	unsigned int fraggap = skb_prev->len - maxfraglen;
+	unsigned int alloclen = fragheaderlen + hh_len + fraggap + 15;
+
+	skb = sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
+	if (unlikely(!skb))
+		return -ENOBUFS;
+
+	/* Fill in the control structures */
+	skb->ip_summed = CHECKSUM_NONE;
+	skb->csum = 0;
+	skb_reserve(skb, hh_len);
+
+	/* Find where to start putting bytes. */
+	skb_put(skb, fragheaderlen + fraggap);
+	skb_reset_network_header(skb);
+	skb->transport_header = skb->network_header + fragheaderlen;
+	if (fraggap) {
+		skb->csum = skb_copy_and_csum_bits(skb_prev, maxfraglen,
+						   skb_transport_header(skb),
+						   fraggap);
+		skb_prev->csum = csum_sub(skb_prev->csum, skb->csum);
+		pskb_trim_unique(skb_prev, maxfraglen);
+	}
+
+	/* Put the packet on the pending queue. */
+	__skb_queue_tail(&sk->sk_write_queue, skb);
+	*pskb = skb;
+	return 0;
+}
+
+/*
+ * Add (or copy) data pages for MSG_SPLICE_PAGES.
+ */
+static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
+			     void *from, int *pcopy)
+{
+	struct msghdr *msg = from;
+	struct page *page = NULL, **pages = &page;
+	ssize_t copy = *pcopy;
+	size_t off;
+	int err;
+
+	copy = iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off);
+	if (copy <= 0)
+		return copy ?: -EIO;
+
+	err = skb_append_pagefrags(skb, page, off, copy);
+	if (err < 0) {
+		iov_iter_revert(&msg->msg_iter, copy);
+		return err;
+	}
+
+	if (skb->ip_summed == CHECKSUM_NONE) {
+		__wsum csum;
+
+		csum = csum_page(page, off, copy);
+		skb->csum = csum_block_add(skb->csum, csum, skb->len);
+	}
+
+	skb_len_add(skb, copy);
+	refcount_add(copy, &sk->sk_wmem_alloc);
+	*pcopy = copy;
+	return 0;
+}
+
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
 			    struct sk_buff_head *queue,
@@ -977,7 +1050,7 @@ static int __ip_append_data(struct sock *sk,
 	int err;
 	int offset = 0;
 	bool zc = false;
-	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
+	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, initial_length;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
 	unsigned int wmem_alloc_delta = 0;
@@ -1017,6 +1090,7 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
 
+	initial_length = length;
 	if ((flags & MSG_ZEROCOPY) && length) {
 		struct msghdr *msg = from;
 
@@ -1047,6 +1121,14 @@ static int __ip_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		if (inet->hdrincl)
+			return -EPERM;
+		if (rt->dst.dev->features & NETIF_F_SG)
+			/* We need an empty buffer to attach stuff to */
+			initial_length = transhdrlen;
+		else
+			flags &= ~MSG_SPLICE_PAGES;
 	}
 
 	cork->length += length;
@@ -1074,6 +1156,16 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
 			struct sk_buff *skb_prev;
+
+			if (unlikely(flags & MSG_SPLICE_PAGES)) {
+				err = __ip_splice_alloc(sk, &skb, fragheaderlen,
+							maxfraglen, hh_len);
+				if (err < 0)
+					goto error;
+				continue;
+			}
+			initial_length = length;
+
 alloc_new_skb:
 			skb_prev = skb;
 			if (skb_prev)
@@ -1085,7 +1177,7 @@ static int __ip_append_data(struct sock *sk,
 			 * If remaining data exceeds the mtu,
 			 * we know we need more fragment(s).
 			 */
-			datalen = length + fraggap;
+			datalen = initial_length + fraggap;
 			if (datalen > mtu - fragheaderlen)
 				datalen = maxfraglen - fragheaderlen;
 			fraglen = datalen + fragheaderlen;
@@ -1099,7 +1191,7 @@ static int __ip_append_data(struct sock *sk,
 			 * because we have no idea what fragment will be
 			 * the last.
 			 */
-			if (datalen == length + fraggap)
+			if (datalen == initial_length + fraggap)
 				alloc_extra += rt->dst.trailer_len;
 
 			if ((flags & MSG_MORE) &&
@@ -1206,6 +1298,10 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			err = __ip_splice_pages(sk, skb, from, &copy);
+			if (err < 0)
+				goto error;
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 

