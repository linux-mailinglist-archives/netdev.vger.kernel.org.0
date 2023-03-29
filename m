Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D1F6CDC4D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjC2OWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjC2OUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:20:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53AC61AE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvXdMcltJv+r5QoZnXaavWZcwnuZQd4mm223J864Zdo=;
        b=Nfun/v3BBcJ8sAaVhaAVTsDrpkxxzvXOLMCaj+DbU528ogXsQDB5QkqTo0BS8PHgg3Vh7R
        dAW4I2DDMhOzMmlMFrXZUnDAPH0kUPMGtwZ9R0JlpDpuCnyGIBL97OQzi6Aq6HAZYnn7ey
        OkASfjFAVdaMJNqtvdh+wozlU76Tk+4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-Ff5bQfAPN6KgS6uIgJRP1w-1; Wed, 29 Mar 2023 10:15:53 -0400
X-MC-Unique: Ff5bQfAPN6KgS6uIgJRP1w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82A463814947;
        Wed, 29 Mar 2023 14:15:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5750F492B02;
        Wed, 29 Mar 2023 14:15:50 +0000 (UTC)
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
Subject: [RFC PATCH v2 41/48] sunrpc: Rely on TCP sendmsg + MSG_SPLICE_PAGES to copy unspliceable data
Date:   Wed, 29 Mar 2023 15:13:47 +0100
Message-Id: <20230329141354.516864-42-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than copying data in svc_tcp_sendmsg() into page fragments, just
hand in ITER_KVEC iterators as part of the ITER_ITERLIST and rely on TCP to
copy them if the pages they're residing on are belong to the slab or have a
zero refcount.

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
 net/sunrpc/svcsock.c | 44 ++++++++++++--------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index f1cc53aad6e0..c1421f6fe57a 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1071,47 +1071,27 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
 			   rpc_fraghdr marker, unsigned int *sentp)
 {
-	const struct kvec *head = xdr->head;
-	const struct kvec *tail = xdr->tail;
-	struct iov_iter iters[3];
-	struct bio_vec head_bv, tail_bv;
-	struct msghdr msg = {
-		.msg_flags	= MSG_SPLICE_PAGES,
-	};
-	void *m, *t;
-	int ret, n = 2, size;
+	struct iov_iter iters[4];
+	struct kvec marker_kv;
+	struct msghdr msg = { .msg_flags = MSG_SPLICE_PAGES, };
+	int ret, n = 0, size;
 
 	*sentp = 0;
 	ret = xdr_alloc_bvec(xdr, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
-	m = page_frag_alloc(NULL, sizeof(marker) + head->iov_len + tail->iov_len,
-			    GFP_KERNEL);
-	if (!m)
-		return -ENOMEM;
-
-	memcpy(m, &marker, sizeof(marker));
-	if (head->iov_len)
-		memcpy(m + sizeof(marker), head->iov_base, head->iov_len);
-	bvec_set_virt(&head_bv, m, sizeof(marker) + head->iov_len);
-	iov_iter_bvec(&iters[0], ITER_SOURCE, &head_bv, 1,
-		      sizeof(marker) + head->iov_len);
-
-	iov_iter_bvec(&iters[1], ITER_SOURCE, xdr->bvec,
+	marker_kv.iov_base = &marker;
+	marker_kv.iov_len  = sizeof(marker);
+	iov_iter_kvec(&iters[n++], ITER_SOURCE, &marker_kv, 1, sizeof(marker));
+	iov_iter_kvec(&iters[n++], ITER_SOURCE, xdr->head, 1, xdr->head->iov_len);
+	iov_iter_bvec(&iters[n++], ITER_SOURCE, xdr->bvec,
 		      xdr_buf_pagecount(xdr), xdr->page_len);
 
-	if (tail->iov_len) {
-		t = page_frag_alloc(NULL, tail->iov_len, GFP_KERNEL);
-		if (!t)
-			return -ENOMEM;
-		memcpy(t, tail->iov_base, tail->iov_len);
-		bvec_set_virt(&tail_bv,  t, tail->iov_len);
-		iov_iter_bvec(&iters[2], ITER_SOURCE, &tail_bv, 1, tail->iov_len);
-		n++;
-	}
+	if (xdr->tail->iov_len)
+		iov_iter_kvec(&iters[n++], ITER_SOURCE, xdr->tail, 1, xdr->tail->iov_len);
 
-	size = sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_len;
+	size = sizeof(marker) + xdr->head->iov_len + xdr->page_len + xdr->tail->iov_len;
 	iov_iter_iterlist(&msg.msg_iter, ITER_SOURCE, iters, n, size);
 
 	ret = sock_sendmsg(sock, &msg);

