Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F546D9317
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbjDFJpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbjDFJor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:44:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28383E0
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680774215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWLW7zv5E95PcNMvzADLtZC4cFCYwscW+4auTp2qbuU=;
        b=R5otaIRxGLVDK8yRdH6LvIcdX4g3F48zgPK827dxzX+Hjj8TrhiliU4zCuk+JnHOliijeP
        uou7dS6+82NwQNNw7OdcujV4etO0EaL0T7StaCcUFx7cCbuPODZoD2PdgTopuQSnr5re2S
        ujYeDlvV+9TN9ddGYnMNPKvgTvorRdQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-vEeTLutcMDW3WDa_hFgwtA-1; Thu, 06 Apr 2023 05:43:31 -0400
X-MC-Unique: vEeTLutcMDW3WDa_hFgwtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F9C2800B23;
        Thu,  6 Apr 2023 09:43:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F03781121314;
        Thu,  6 Apr 2023 09:43:28 +0000 (UTC)
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
        linux-mm@kvack.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v5 13/19] ip, udp: Support MSG_SPLICE_PAGES
Date:   Thu,  6 Apr 2023 10:42:39 +0100
Message-Id: <20230406094245.3633290-14-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-1-dhowells@redhat.com>
References: <20230406094245.3633290-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
cc: David Ahern <dsahern@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/ip_output.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 22a90a9392eb..c6c318eb3d37 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -957,6 +957,41 @@ csum_page(struct page *page, int offset, int copy)
 	return csum;
 }
 
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
@@ -1048,6 +1083,14 @@ static int __ip_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		if (inet->hdrincl)
+			return -EPERM;
+		if (rt->dst.dev->features & NETIF_F_SG)
+			/* We need an empty buffer to attach stuff to */
+			paged = true;
+		else
+			flags &= ~MSG_SPLICE_PAGES;
 	}
 
 	cork->length += length;
@@ -1207,6 +1250,10 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			err = __ip_splice_pages(sk, skb, from, &copy);
+			if (err < 0)
+				goto error;
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 

