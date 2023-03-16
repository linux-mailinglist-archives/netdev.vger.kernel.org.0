Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F126BD3D6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjCPPbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjCPPaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:30:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B99E1CAC
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNHQplOZd5HfwcKa/y8evYEBVb89JfsyQlI6+74E8fk=;
        b=etjMSyAaUMrXETAwP6TjkzO4Aq1Ju9tGjaxVgQ5nKvw68CX54Iw1F+JLz+IrK8/iOmUfEv
        IPrDz4p2ZBaYRZqyhdfW9oFYB1yHbsuAHF37Jlu4xEbeUvVEV8P0XlcRBMgWnHvueFy946
        4Ocjn4o3Pt+zn9Lyt9IvrleG7Jpl+h8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-2P0S9tmzOBuO6RSNRr9oBQ-1; Thu, 16 Mar 2023 11:27:36 -0400
X-MC-Unique: 2P0S9tmzOBuO6RSNRr9oBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5750887402;
        Thu, 16 Mar 2023 15:27:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F26035453;
        Thu, 16 Mar 2023 15:27:32 +0000 (UTC)
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
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org
Subject: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date:   Thu, 16 Mar 2023 15:26:17 +0000
Message-Id: <20230316152618.711970-28-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
a BVEC-type iterator.  The bio_vec array has two extra slots before the
first for headers and one after the last for a trailer.  The headers and
trailer are copied into memory acquired from zcopy_alloc() which just
breaks a page up into small pieces that can be freed with put_page().

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
 net/sunrpc/svcsock.c | 70 ++++++++++++--------------------------------
 net/sunrpc/xdr.c     | 24 ++++++++++++---
 2 files changed, 38 insertions(+), 56 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 03a4f5615086..1fa41ddbc40e 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -36,6 +36,7 @@
 #include <linux/skbuff.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
+#include <linux/zcopy_alloc.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip.h>
@@ -1060,16 +1061,8 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
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
@@ -1081,65 +1074,38 @@ static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
 {
 	const struct kvec *head = xdr->head;
 	const struct kvec *tail = xdr->tail;
-	struct kvec rm = {
-		.iov_base	= &marker,
-		.iov_len	= sizeof(marker),
-	};
 	struct msghdr msg = {
-		.msg_flags	= 0,
+		.msg_flags	= MSG_SPLICE_PAGES,
 	};
-	int ret;
+	int ret, n = xdr_buf_pagecount(xdr), size;
 
 	*sentp = 0;
 	ret = xdr_alloc_bvec(xdr, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
-	ret = kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
+	ret = zcopy_memdup(sizeof(marker), &marker, &xdr->bvec[-2], GFP_KERNEL);
 	if (ret < 0)
 		return ret;
-	*sentp += ret;
-	if (ret != rm.iov_len)
-		return -EAGAIN;
 
-	ret = svc_tcp_send_kvec(sock, head, 0);
+	ret = zcopy_memdup(head->iov_len, head->iov_base, &xdr->bvec[-1], GFP_KERNEL);
 	if (ret < 0)
 		return ret;
-	*sentp += ret;
-	if (ret != head->iov_len)
-		goto out;
 
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
+	ret = zcopy_memdup(tail->iov_len, tail->iov_base, &xdr->bvec[n], GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	if (tail->iov_len) {
-		ret = svc_tcp_send_kvec(sock, tail, 0);
-		if (ret < 0)
-			return ret;
-		*sentp += ret;
-	}
+	size = sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_len;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec - 2, n + 3, size);
 
-out:
+	ret = sock_sendmsg(sock, &msg);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		*sentp = ret;
+	if (ret != size)
+		return -EAGAIN;
 	return 0;
 }
 
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 36835b2f5446..6dff0b4f17b8 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -145,14 +145,19 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
 {
 	size_t i, n = xdr_buf_pagecount(buf);
 
-	if (n != 0 && buf->bvec == NULL) {
-		buf->bvec = kmalloc_array(n, sizeof(buf->bvec[0]), gfp);
+	if (buf->bvec == NULL) {
+		/* Allow for two headers and a trailer to be attached */
+		buf->bvec = kmalloc_array(n + 3, sizeof(buf->bvec[0]), gfp);
 		if (!buf->bvec)
 			return -ENOMEM;
+		buf->bvec += 2;
+		buf->bvec[-2].bv_page = NULL;
+		buf->bvec[-1].bv_page = NULL;
 		for (i = 0; i < n; i++) {
 			bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
 				      0);
 		}
+		buf->bvec[n].bv_page = NULL;
 	}
 	return 0;
 }
@@ -160,8 +165,19 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
 void
 xdr_free_bvec(struct xdr_buf *buf)
 {
-	kfree(buf->bvec);
-	buf->bvec = NULL;
+	if (buf->bvec) {
+		size_t n = xdr_buf_pagecount(buf);
+
+		if (buf->bvec[-2].bv_page)
+			put_page(buf->bvec[-2].bv_page);
+		if (buf->bvec[-1].bv_page)
+			put_page(buf->bvec[-1].bv_page);
+		if (buf->bvec[n].bv_page)
+			put_page(buf->bvec[n].bv_page);
+		buf->bvec -= 2;
+		kfree(buf->bvec);
+		buf->bvec = NULL;
+	}
 }
 
 /**

