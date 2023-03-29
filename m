Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0E26CDC51
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjC2OWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjC2OUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:20:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A461A9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=soF5gavmzneSvIIvHwhPEmiQq18BggR/9B/uQZFrN8w=;
        b=ZXW1HzVsOGyt5V4GXikPJkY5ih0M+B27i+lSSZ0oZqoJ9AyiDpVLy/cGyWq+j+g7WFJRMf
        Qic3wt5LyJ8XCaso4qI0+qXqIbP7hTSS/H+HsNSMGXZtfu8syaWTSZQ51rTrPNfvGNEPtI
        5rjCT7O9gt66J/xrNqwkZ8UF+QsoWcQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-ruOkGzEjPIqn8iT3b-ztNw-1; Wed, 29 Mar 2023 10:15:54 -0400
X-MC-Unique: ruOkGzEjPIqn8iT3b-ztNw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99B85855300;
        Wed, 29 Mar 2023 14:15:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CE9C2027040;
        Wed, 29 Mar 2023 14:15:47 +0000 (UTC)
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
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org
Subject: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date:   Wed, 29 Mar 2023 15:13:46 +0100
Message-Id: <20230329141354.516864-41-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When transmitting data, call down into TCP using a single sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing several sendmsg and sendpage calls to transmit header, data
pages and trailer.

To make this work, the data is assembled in a bio_vec array and attached to
a BVEC-type iterator.  The header and trailer are copied into page
fragments so that they can be freed with put_page and attached to iterators
of their own.  An iterator-of-iterators is then created to bridge all three
iterators (headers, data, trailer) and that is passed to sendmsg to pass
the entire message in a single call.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <trond.myklebust@hammerspace.com>
cc: Anna Schumaker <anna@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-nfs@vger.kernel.org
cc: netdev@vger.kernel.org
---
 include/linux/sunrpc/svc.h | 11 +++--
 net/sunrpc/svcsock.c       | 89 +++++++++++++++-----------------------
 2 files changed, 40 insertions(+), 60 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 877891536c2f..456ae554aa11 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -161,16 +161,15 @@ static inline bool svc_put_not_last(struct svc_serv *serv)
 extern u32 svc_max_payload(const struct svc_rqst *rqstp);
 
 /*
- * RPC Requsts and replies are stored in one or more pages.
+ * RPC Requests and replies are stored in one or more pages.
  * We maintain an array of pages for each server thread.
  * Requests are copied into these pages as they arrive.  Remaining
  * pages are available to write the reply into.
  *
- * Pages are sent using ->sendpage so each server thread needs to
- * allocate more to replace those used in sending.  To help keep track
- * of these pages we have a receive list where all pages initialy live,
- * and a send list where pages are moved to when there are to be part
- * of a reply.
+ * Pages are sent using ->sendmsg with MSG_SPLICE_PAGES so each server thread
+ * needs to allocate more to replace those used in sending.  To help keep track
+ * of these pages we have a receive list where all pages initialy live, and a
+ * send list where pages are moved to when there are to be part of a reply.
  *
  * We use xdr_buf for holding responses as it fits well with NFS
  * read responses (that have a header, and some data pages, and possibly
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 03a4f5615086..f1cc53aad6e0 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1060,16 +1060,8 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 	return 0;	/* record not complete */
 }
 
-static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
-			      int flags)
-{
-	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
-			       offset_in_page(vec->iov_base),
-			       vec->iov_len, flags);
-}
-
 /*
- * kernel_sendpage() is used exclusively to reduce the number of
+ * MSG_SPLICE_PAGES is used exclusively to reduce the number of
  * copy operations in this path. Therefore the caller must ensure
  * that the pages backing @xdr are unchanging.
  *
@@ -1081,65 +1073,54 @@ static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
 {
 	const struct kvec *head = xdr->head;
 	const struct kvec *tail = xdr->tail;
-	struct kvec rm = {
-		.iov_base	= &marker,
-		.iov_len	= sizeof(marker),
-	};
+	struct iov_iter iters[3];
+	struct bio_vec head_bv, tail_bv;
 	struct msghdr msg = {
-		.msg_flags	= 0,
+		.msg_flags	= MSG_SPLICE_PAGES,
 	};
-	int ret;
+	void *m, *t;
+	int ret, n = 2, size;
 
 	*sentp = 0;
 	ret = xdr_alloc_bvec(xdr, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
-	ret = kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
-	if (ret < 0)
-		return ret;
-	*sentp += ret;
-	if (ret != rm.iov_len)
-		return -EAGAIN;
+	m = page_frag_alloc(NULL, sizeof(marker) + head->iov_len + tail->iov_len,
+			    GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
 
-	ret = svc_tcp_send_kvec(sock, head, 0);
-	if (ret < 0)
-		return ret;
-	*sentp += ret;
-	if (ret != head->iov_len)
-		goto out;
+	memcpy(m, &marker, sizeof(marker));
+	if (head->iov_len)
+		memcpy(m + sizeof(marker), head->iov_base, head->iov_len);
+	bvec_set_virt(&head_bv, m, sizeof(marker) + head->iov_len);
+	iov_iter_bvec(&iters[0], ITER_SOURCE, &head_bv, 1,
+		      sizeof(marker) + head->iov_len);
 
-	if (xdr->page_len) {
-		unsigned int offset, len, remaining;
-		struct bio_vec *bvec;
-
-		bvec = xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
-		offset = offset_in_page(xdr->page_base);
-		remaining = xdr->page_len;
-		while (remaining > 0) {
-			len = min(remaining, bvec->bv_len - offset);
-			ret = kernel_sendpage(sock, bvec->bv_page,
-					      bvec->bv_offset + offset,
-					      len, 0);
-			if (ret < 0)
-				return ret;
-			*sentp += ret;
-			if (ret != len)
-				goto out;
-			remaining -= len;
-			offset = 0;
-			bvec++;
-		}
-	}
+	iov_iter_bvec(&iters[1], ITER_SOURCE, xdr->bvec,
+		      xdr_buf_pagecount(xdr), xdr->page_len);
 
 	if (tail->iov_len) {
-		ret = svc_tcp_send_kvec(sock, tail, 0);
-		if (ret < 0)
-			return ret;
-		*sentp += ret;
+		t = page_frag_alloc(NULL, tail->iov_len, GFP_KERNEL);
+		if (!t)
+			return -ENOMEM;
+		memcpy(t, tail->iov_base, tail->iov_len);
+		bvec_set_virt(&tail_bv,  t, tail->iov_len);
+		iov_iter_bvec(&iters[2], ITER_SOURCE, &tail_bv, 1, tail->iov_len);
+		n++;
 	}
 
-out:
+	size = sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_len;
+	iov_iter_iterlist(&msg.msg_iter, ITER_SOURCE, iters, n, size);
+
+	ret = sock_sendmsg(sock, &msg);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		*sentp = ret;
+	if (ret != size)
+		return -EAGAIN;
 	return 0;
 }
 

