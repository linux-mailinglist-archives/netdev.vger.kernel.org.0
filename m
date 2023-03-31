Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E8C6D24E8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbjCaQMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjCaQLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999F022909
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uNZWqu+MQKIO3OTB8U4ZJVMqWS1JR9mPIUS8nXZLn4=;
        b=U+7Jfq5ZuKrCpPxiJXNUrOqO1DlQxtLQ/IPbl9ePSHNc98ifd7EU2W2w1PPkHHlr8vl5gy
        G0FsrfA/SE/kjcsTtSQ3YjKlfUhHlcI+kQta3L8S55GKqmej1E2BbJQ/h4i9sK7OmACWpq
        +d775q+uLQlUEYCXG/SL6f4bWsiQTeY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-jQiJhrbpN_2494oFduAemA-1; Fri, 31 Mar 2023 12:10:10 -0400
X-MC-Unique: jQiJhrbpN_2494oFduAemA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66A7829ABA23;
        Fri, 31 Mar 2023 16:10:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B0F74020C82;
        Fri, 31 Mar 2023 16:10:07 +0000 (UTC)
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
Subject: [PATCH v3 17/55] ip6, udp6: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:36 +0100
Message-Id: <20230331160914.1608208-18-dhowells@redhat.com>
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

Make IP6/UDP6 sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator if possible, copying the data if not.

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
 include/net/ip.h      |  4 ++++
 net/ipv4/ip_output.c  | 11 ++++++-----
 net/ipv6/ip6_output.c | 28 +++++++++++++++++++++++++---
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..e27d2ceffcfa 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -211,6 +211,10 @@ int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 		    __u8 tos);
 void ip_init(void);
+int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
+		      unsigned int fragheaderlen, unsigned int maxfraglen,
+		      unsigned int hh_len);
+int __ip_splice_pages(struct sock *sk, struct sk_buff *skb, void *from, int *pcopy);
 int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 		   int getfrag(void *from, char *to, int offset, int len,
 			       int odd, struct sk_buff *skb),
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 41a954ac9e1a..fa2546d944bc 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -959,9 +959,9 @@ csum_page(struct page *page, int offset, int copy)
 /*
  * Allocate a packet for MSG_SPLICE_PAGES.
  */
-static int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
-			     unsigned int fragheaderlen, unsigned int maxfraglen,
-			     unsigned int hh_len)
+int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
+		      unsigned int fragheaderlen, unsigned int maxfraglen,
+		      unsigned int hh_len)
 {
 	struct sk_buff *skb_prev = *pskb, *skb;
 	unsigned int fraggap = skb_prev->len - maxfraglen;
@@ -993,12 +993,12 @@ static int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
 	*pskb = skb;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__ip_splice_alloc);
 
 /*
  * Add (or copy) data pages for MSG_SPLICE_PAGES.
  */
-static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
-			     void *from, int *pcopy)
+int __ip_splice_pages(struct sock *sk, struct sk_buff *skb, void *from, int *pcopy)
 {
 	struct msghdr *msg = from;
 	struct page *page = NULL, **pages = &page;
@@ -1047,6 +1047,7 @@ static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
 	*pcopy = copy;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__ip_splice_pages);
 
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c314fdde0097..c95d034cb45a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1486,7 +1486,7 @@ static int __ip6_append_data(struct sock *sk,
 	struct rt6_info *rt = (struct rt6_info *)cork->dst;
 	struct ipv6_txoptions *opt = v6_cork->opt;
 	int csummode = CHECKSUM_NONE;
-	unsigned int maxnonfragsize, headersize;
+	unsigned int maxnonfragsize, headersize, initial_length;
 	unsigned int wmem_alloc_delta = 0;
 	bool paged, extra_uref = false;
 
@@ -1559,6 +1559,7 @@ static int __ip6_append_data(struct sock *sk,
 	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		csummode = CHECKSUM_PARTIAL;
 
+	initial_length = length;
 	if ((flags & MSG_ZEROCOPY) && length) {
 		struct msghdr *msg = from;
 
@@ -1589,6 +1590,14 @@ static int __ip6_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		if (inet_sk(sk)->hdrincl)
+			return -EPERM;
+		if (rt->dst.dev->features & NETIF_F_SG)
+			/* We need an empty buffer to attach stuff to */
+			initial_length = transhdrlen;
+		else
+			flags &= ~MSG_SPLICE_PAGES;
 	}
 
 	/*
@@ -1624,6 +1633,15 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int fraggap;
 			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
+
+			if (unlikely(flags & MSG_SPLICE_PAGES)) {
+				err = __ip_splice_alloc(sk, &skb, fragheaderlen,
+							maxfraglen, hh_len);
+				if (err < 0)
+					goto error;
+				continue;
+			}
+			initial_length = length;
 alloc_new_skb:
 			/* There's no room in the current skb */
 			if (skb)
@@ -1642,7 +1660,7 @@ static int __ip6_append_data(struct sock *sk,
 			 * If remaining data exceeds the mtu,
 			 * we know we need more fragment(s).
 			 */
-			datalen = length + fraggap;
+			datalen = initial_length + fraggap;
 
 			if (datalen > (cork->length <= mtu && !(cork->flags & IPCORK_ALLFRAG) ? mtu : maxfraglen) - fragheaderlen)
 				datalen = maxfraglen - fragheaderlen - rt->dst.trailer_len;
@@ -1672,7 +1690,7 @@ static int __ip6_append_data(struct sock *sk,
 			}
 			alloclen += alloc_extra;
 
-			if (datalen != length + fraggap) {
+			if (datalen != initial_length + fraggap) {
 				/*
 				 * this is not the last fragment, the trailer
 				 * space is regarded as data space.
@@ -1778,6 +1796,10 @@ static int __ip6_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			err = __ip_splice_pages(sk, skb, from, &copy);
+			if (err < 0)
+				goto error;
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 

