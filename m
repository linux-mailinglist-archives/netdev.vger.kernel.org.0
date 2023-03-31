Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B06D2546
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbjCaQTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjCaQSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:18:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C252953D
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5XUK+PQOR7d9klL6/6O6KO8pAUYr8F8Qal1kb1WUAE=;
        b=IowyM2WrpAh7y8MuhIweL3+bf651A3RYPxq5Pd6p00dY2hnZaHXOzMZYp55zdFXYfxq2IP
        nuzBvXocwMI5kPpjrcrciQB2k0Is+IgaS5DfImKckcYG6wE0eGur/7ymC3dqdGcbVf9d/L
        dE+aJnTvPjbob7VJPxFXCQoozItWqcg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-fHdJvov2Og26gxE1ES-_Qg-1; Fri, 31 Mar 2023 12:11:35 -0400
X-MC-Unique: fHdJvov2Og26gxE1ES-_Qg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E74229ABA17;
        Fri, 31 Mar 2023 16:11:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22BEA492C3E;
        Fri, 31 Mar 2023 16:11:32 +0000 (UTC)
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
Subject: [PATCH v3 48/55] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date:   Fri, 31 Mar 2023 17:09:07 +0100
Message-Id: <20230331160914.1608208-49-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
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

When transmitting data, call down into TCP using sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing sendpage calls to transmit header, data pages and trailer.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
cc: Trond Myklebust <trond.myklebust@hammerspace.com>
cc: Anna Schumaker <anna@kernel.org>
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
 include/linux/sunrpc/svc.h | 11 +++++------
 net/sunrpc/svcsock.c       | 38 ++++++++++++--------------------------
 2 files changed, 17 insertions(+), 32 deletions(-)

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
index 03a4f5615086..3a015abac5bd 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1063,13 +1063,14 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
 			      int flags)
 {
-	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
-			       offset_in_page(vec->iov_base),
-			       vec->iov_len, flags);
+	struct msghdr msg = { .msg_flags = MSG_SPLICE_PAGES | flags, };
+
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 1, vec->iov_len);
+	return sock_sendmsg(sock, &msg);
 }
 
 /*
- * kernel_sendpage() is used exclusively to reduce the number of
+ * MSG_SPLICE_PAGES is used exclusively to reduce the number of
  * copy operations in this path. Therefore the caller must ensure
  * that the pages backing @xdr are unchanging.
  *
@@ -1109,28 +1110,13 @@ static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
 	if (ret != head->iov_len)
 		goto out;
 
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
+	msg.msg_flags = MSG_SPLICE_PAGES;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
+		      xdr_buf_pagecount(xdr), xdr->page_len);
+	ret = sock_sendmsg(sock, &msg);
+	if (ret < 0)
+		return ret;
+	*sentp += ret;
 
 	if (tail->iov_len) {
 		ret = svc_tcp_send_kvec(sock, tail, 0);

