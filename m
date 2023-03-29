Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E696CDBFE
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjC2OSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjC2ORS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969BD558E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DuSpRIzeQZ01nwpBuy8LkLTaj8h3sZ+W9+uqSPxJMKE=;
        b=UsPd6PrkoQCblAI2v1eMwiLnNxU05DPXNLL7c0d42AAvgKOWxHxtYhCxXvduZQ/XPd61dx
        fXh73g4hw64L5gMY4ZJJAuLogbLpFzfoscK0T3jkI+O8lO8+aMIn/re3Xv/e4t9QGG4cPp
        OAwsKQNqaC094amgctdN3FY9P9TN56M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-jnNXOk_ROhmWbX02B6xDmA-1; Wed, 29 Mar 2023 10:14:55 -0400
X-MC-Unique: jnNXOk_ROhmWbX02B6xDmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 170BE85A5B1;
        Wed, 29 Mar 2023 14:14:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35746492C3E;
        Wed, 29 Mar 2023 14:14:52 +0000 (UTC)
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
Subject: [RFC PATCH v2 20/48] af_unix: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
Date:   Wed, 29 Mar 2023 15:13:26 +0100
Message-Id: <20230329141354.516864-21-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sendmsg() with MSG_SPLICE_PAGES encounters a page that shouldn't be
spliced - a slab page, for instance, or one with a zero count - make
unix_extract_bvec_to_skb() copy it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/unix/af_unix.c | 44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 84a0d97f1aa4..b4b27a652ef0 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2154,12 +2154,12 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 /*
  * Extract pages from an iterator and add them to the socket buffer.
  */
-static ssize_t unix_extract_bvec_to_skb(struct sk_buff *skb,
-					struct iov_iter *iter, ssize_t maxsize)
+static ssize_t unix_extract_bvec_to_skb(struct sk_buff *skb, struct iov_iter *iter,
+					ssize_t maxsize, gfp_t gfp)
 {
 	struct page *pages[8], **ppages = pages;
 	unsigned int i, nr;
-	ssize_t ret = 0;
+	ssize_t spliced = 0, ret = 0;
 
 	while (iter->count > 0) {
 		size_t off, len;
@@ -2171,31 +2171,52 @@ static ssize_t unix_extract_bvec_to_skb(struct sk_buff *skb,
 
 		len = iov_iter_extract_pages(iter, &ppages, maxsize, nr, 0, &off);
 		if (len <= 0) {
-			if (!ret)
-				ret = len ?: -EIO;
+			ret = len ?: -EIO;
 			break;
 		}
 
 		i = 0;
 		do {
+			struct page *page = pages[i++];
 			size_t part = min(PAGE_SIZE - off, len);
+			bool put = false;
+
+			if (!sendpage_ok(page)) {
+				const void *p = kmap_local_page(page);
+				void *q;
+
+				q = page_frag_memdup(NULL, p + off, part, gfp,
+						     ULONG_MAX);
+				kunmap_local(p);
+				if (!q) {
+					iov_iter_revert(iter, len);
+					ret = -ENOMEM;
+					goto out;
+				}
+				page = virt_to_page(q);
+				off = offset_in_page(q);
+				put = true;
+			}
 
-			if (skb_append_pagefrags(skb, pages[i++], off, part) < 0) {
-				if (!ret)
-					ret = -EMSGSIZE;
+			ret = skb_append_pagefrags(skb, page, off, part);
+			if (put)
+				put_page(page);
+			if (ret < 0) {
+				iov_iter_revert(iter, len);
 				goto out;
 			}
 			off = 0;
-			ret += part;
+			spliced += part;
 			maxsize -= part;
 			len -= part;
 		} while (len > 0);
+
 		if (maxsize <= 0)
 			break;
 	}
 
 out:
-	return ret;
+	return spliced ?: ret;
 }
 
 static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
@@ -2272,7 +2293,8 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		fds_sent = true;
 
 		if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES)) {
-			size = unix_extract_bvec_to_skb(skb, &msg->msg_iter, size);
+			size = unix_extract_bvec_to_skb(skb, &msg->msg_iter, size,
+							sk->sk_allocation);
 			skb->data_len += size;
 			skb->len += size;
 			skb->truesize += size;

