Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7666D24EE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjCaQNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjCaQL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:11:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FE12291E
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8cNPLuNlp8TF1aeLVa/nfCczmmxDIoFIua9rMiLDvM=;
        b=PFuAuSzdYHEtanRoDuFb8x8kOdOkuR2Wbcb4gcqZXdfR+5ATPgipJxE+MGE4X6r6O7DuDT
        Ew3JU5BHWWDnxvnfP3ur/1NANj08k9BXaUPa3rQc8GNzrNGGSfrho8SLEm4/icl5P9VXWR
        KWtad/NjjX0meB/MOi34AdYp4cVkDC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-cb5mzzjVOOCi4dFlfSrt2Q-1; Fri, 31 Mar 2023 12:10:18 -0400
X-MC-Unique: cb5mzzjVOOCi4dFlfSrt2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27F62185A78B;
        Fri, 31 Mar 2023 16:10:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44F731121314;
        Fri, 31 Mar 2023 16:10:15 +0000 (UTC)
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
Subject: [PATCH v3 20/55] af_unix: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
Date:   Fri, 31 Mar 2023 17:08:39 +0100
Message-Id: <20230331160914.1608208-21-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
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
index a9ad97f3c57f..88b91005567e 100644
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
 			size_t part = min_t(size_t, PAGE_SIZE - off, len);
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

