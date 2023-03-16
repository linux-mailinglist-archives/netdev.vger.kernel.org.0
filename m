Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B816BD391
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjCPP2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjCPP2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:28:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B96DB1B12
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYA122zSJc6JqJKbnjvsKVO49kEubsqnJ80XNajw+5k=;
        b=c1XBtLVqQRTsm+XHYJdCWktkzko/U1QqoSyTUb723fGh4aj+w//i1BFvFSWFjv2L9e1aH2
        jnQ8zvj5eOiZAl19sYKLCJcsfprxEZM+e+kq3NU66XxGyziwc73VsM5dn6uyn42heYqjcr
        eFELmk6unO+EqSVkYS1eYEhXnc7914s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-LkkusC7mPii-DXgerJyhEQ-1; Thu, 16 Mar 2023 11:26:52 -0400
X-MC-Unique: LkkusC7mPii-DXgerJyhEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 431AA101A553;
        Thu, 16 Mar 2023 15:26:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D14C1121315;
        Thu, 16 Mar 2023 15:26:47 +0000 (UTC)
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC PATCH 10/28] ip, udp: Support MSG_SPLICE_PAGES
Date:   Thu, 16 Mar 2023 15:26:00 +0000
Message-Id: <20230316152618.711970-11-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make IP/UDP sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator if possible (the iterator must be
ITER_BVEC and the pages must be spliceable).

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
 net/ipv4/ip_output.c | 89 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 4e4e308c3230..721d7e4343ed 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -977,7 +977,7 @@ static int __ip_append_data(struct sock *sk,
 	int err;
 	int offset = 0;
 	bool zc = false;
-	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
+	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, xlength;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
 	unsigned int wmem_alloc_delta = 0;
@@ -1017,6 +1017,7 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
 
+	xlength = length;
 	if ((flags & MSG_ZEROCOPY) && length) {
 		struct msghdr *msg = from;
 
@@ -1047,6 +1048,16 @@ static int __ip_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		struct msghdr *msg = from;
+
+		if (!iov_iter_is_bvec(&msg->msg_iter))
+			return -EINVAL;
+		if (inet->hdrincl)
+			return -EPERM;
+		if (!(rt->dst.dev->features & NETIF_F_SG))
+			return -EOPNOTSUPP;
+		xlength = transhdrlen; /* We need an empty buffer to attach stuff to */
 	}
 
 	cork->length += length;
@@ -1074,6 +1085,50 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
 			struct sk_buff *skb_prev;
+
+			if (unlikely(flags & MSG_SPLICE_PAGES)) {
+				skb_prev = skb;
+				fraggap = skb_prev->len - maxfraglen;
+
+				alloclen = fragheaderlen + hh_len + fraggap + 15;
+				skb = sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
+				if (unlikely(!skb)) {
+					err = -ENOBUFS;
+					goto error;
+				}
+
+				/*
+				 *	Fill in the control structures
+				 */
+				skb->ip_summed = CHECKSUM_NONE;
+				skb->csum = 0;
+				skb_reserve(skb, hh_len);
+
+				/*
+				 *	Find where to start putting bytes.
+				 */
+				skb_put(skb, fragheaderlen + fraggap);
+				skb_reset_network_header(skb);
+				skb->transport_header = (skb->network_header +
+							 fragheaderlen);
+				if (fraggap) {
+					skb->csum = skb_copy_and_csum_bits(
+						skb_prev, maxfraglen,
+						skb_transport_header(skb),
+						fraggap);
+					skb_prev->csum = csum_sub(skb_prev->csum,
+								  skb->csum);
+					pskb_trim_unique(skb_prev, maxfraglen);
+				}
+
+				/*
+				 * Put the packet on the pending queue.
+				 */
+				__skb_queue_tail(&sk->sk_write_queue, skb);
+				continue;
+			}
+			xlength = length;
+
 alloc_new_skb:
 			skb_prev = skb;
 			if (skb_prev)
@@ -1085,7 +1140,7 @@ static int __ip_append_data(struct sock *sk,
 			 * If remaining data exceeds the mtu,
 			 * we know we need more fragment(s).
 			 */
-			datalen = length + fraggap;
+			datalen = xlength + fraggap;
 			if (datalen > mtu - fragheaderlen)
 				datalen = maxfraglen - fragheaderlen;
 			fraglen = datalen + fragheaderlen;
@@ -1099,7 +1154,7 @@ static int __ip_append_data(struct sock *sk,
 			 * because we have no idea what fragment will be
 			 * the last.
 			 */
-			if (datalen == length + fraggap)
+			if (datalen == xlength + fraggap)
 				alloc_extra += rt->dst.trailer_len;
 
 			if ((flags & MSG_MORE) &&
@@ -1206,6 +1261,34 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			struct msghdr *msg = from;
+			struct iov_iter *iter = &msg->msg_iter;
+			const struct bio_vec *bv = iter->bvec;
+
+			if (iov_iter_count(iter) <= 0) {
+				err = -EIO;
+				goto error;
+			}
+
+			copy = iov_iter_single_seg_count(&msg->msg_iter);
+
+			err = skb_append_pagefrags(skb, bv->bv_page,
+						   bv->bv_offset + iter->iov_offset,
+						   copy);
+			if (err < 0)
+				goto error;
+
+			if (skb->ip_summed == CHECKSUM_NONE) {
+				__wsum csum;
+				csum = csum_page(bv->bv_page,
+						 bv->bv_offset + iter->iov_offset, copy);
+				skb->csum = csum_block_add(skb->csum, csum, skb->len);
+			}
+
+			iov_iter_advance(iter, copy);
+			skb_len_add(skb, copy);
+			refcount_add(copy, &sk->sk_wmem_alloc);
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 

