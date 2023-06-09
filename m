Return-Path: <netdev+bounces-9487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2AF729637
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9938A28181D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036DE15481;
	Fri,  9 Jun 2023 10:02:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC28A14A8A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:02:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A095420C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686304958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTIph0AO3Glm0cHnpdSUPYaa1BCa6IyevnPVIS0MlWU=;
	b=BafAUcNZy/E83B/Q22rlwzOEf1VtnHwsnX4cYe45R2BhnJB15G3dTglU5Q3Elf8KoR4tUH
	PS1pSwhG/9Sy/28Tb/Nb65ol2oO3KFYo/S4rHHMucxh+PE1yKmggU4HpeQqG9iUapiB/uJ
	TX20Zwikujm/UC7yI3Ff/dl/Vvs7Cxc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-Y6xKU7LEMfuedTeRt3xdBA-1; Fri, 09 Jun 2023 06:02:34 -0400
X-MC-Unique: Y6xKU7LEMfuedTeRt3xdBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75714185A78E;
	Fri,  9 Jun 2023 10:02:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B47D840C1438;
	Fri,  9 Jun 2023 10:02:30 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH net-next 3/6] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date: Fri,  9 Jun 2023 11:02:18 +0100
Message-ID: <20230609100221.2620633-4-dhowells@redhat.com>
In-Reply-To: <20230609100221.2620633-1-dhowells@redhat.com>
References: <20230609100221.2620633-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 762d7231e574..f66ec8fdb331 100644
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
index f77cebe2c071..9d9f522e3ae1 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1203,13 +1203,14 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
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
@@ -1249,28 +1250,13 @@ static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
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


