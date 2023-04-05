Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8156D845D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjDEQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbjDEQ4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:56:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29F26EA0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/JFI/23Tc+s/ig3NV2/20J93ojirddDNW00qNvViyfU=;
        b=ReqOQhGXwcfWg1FfIgVmuPPkkV+IiWeOeLaVuDlhFN0p7Fdafkj3e6ohqH8AQSlOLkxhSp
        vIvcDCu0fRiEQh3JHfzXucwvmp043i5zEPAMaM1pp6cxPIGxtmpeoISyhKC47SiQqRXxB4
        I4AoHBTx1eB1hy26Y9ZWXDFFudLCnOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-mGoavVuyPK63hF6pFvfXqA-1; Wed, 05 Apr 2023 12:54:37 -0400
X-MC-Unique: mGoavVuyPK63hF6pFvfXqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5FED101A531;
        Wed,  5 Apr 2023 16:54:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B22C6C1602B;
        Wed,  5 Apr 2023 16:54:34 +0000 (UTC)
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
Subject: [PATCH net-next v4 18/20] ip6, udp6: Support MSG_SPLICE_PAGES
Date:   Wed,  5 Apr 2023 17:53:37 +0100
Message-Id: <20230405165339.3468808-19-dhowells@redhat.com>
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
 include/net/ip.h      |  1 +
 net/ipv4/ip_output.c  |  4 ++--
 net/ipv6/ip6_output.c | 12 ++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 7627a4df893b..8a50341007bf 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -211,6 +211,7 @@ int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 		    __u8 tos);
 void ip_init(void);
+int __ip_splice_pages(struct sock *sk, struct sk_buff *skb, void *from, int *pcopy);
 int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 		   int getfrag(void *from, char *to, int offset, int len,
 			       int odd, struct sk_buff *skb),
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e34c86b1b59a..241a78d82766 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -960,8 +960,7 @@ csum_page(struct page *page, int offset, int copy)
 /*
  * Add (or copy) data pages for MSG_SPLICE_PAGES.
  */
-static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
-			     void *from, int *pcopy)
+int __ip_splice_pages(struct sock *sk, struct sk_buff *skb, void *from, int *pcopy)
 {
 	struct msghdr *msg = from;
 	struct page *page = NULL, **pages = &page;
@@ -1010,6 +1009,7 @@ static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
 	*pcopy = copy;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__ip_splice_pages);
 
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0b6140f0179d..82846d18cf22 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1589,6 +1589,14 @@ static int __ip6_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		if (inet_sk(sk)->hdrincl)
+			return -EPERM;
+		if (rt->dst.dev->features & NETIF_F_SG)
+			/* We need an empty buffer to attach stuff to */
+			paged = true;
+		else
+			flags &= ~MSG_SPLICE_PAGES;
 	}
 
 	/*
@@ -1778,6 +1786,10 @@ static int __ip6_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			err = __ip_splice_pages(sk, skb, from, &copy);
+			if (err < 0)
+				goto error;
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 

