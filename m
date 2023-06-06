Return-Path: <netdev+bounces-8480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F3A724404
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0611C20FDC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D6A2A9FB;
	Tue,  6 Jun 2023 13:10:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582552A9DB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:10:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16481981
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686056986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fy2ggJLQIWe53H9p3VJNg7LWC+KUVOljTaVR6c617po=;
	b=QOmcBDGmvarbaZ06OcKm7BVEg7pj9AHYjzbtjwYqmCV9Bpkm9yRVNnkXBbRAFueQpvigRg
	W7ZACQ8HE/SOsLWKMcwRb3DAQCejwSlD40svAQsiJd6LyPrTpDNysL2wkCY5Rwj1itjttF
	26gzoJz/bwhoo9bgpJDkPWHjVl6h/Nk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-LDioG1ZoO5yPnQdoqqJwpg-1; Tue, 06 Jun 2023 09:09:43 -0400
X-MC-Unique: LDioG1ZoO5yPnQdoqqJwpg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 302A78037AD;
	Tue,  6 Jun 2023 13:09:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A110F492B00;
	Tue,  6 Jun 2023 13:09:39 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 09/10] crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
Date: Tue,  6 Jun 2023 14:08:55 +0100
Message-ID: <20230606130856.1970660-10-dhowells@redhat.com>
In-Reply-To: <20230606130856.1970660-1-dhowells@redhat.com>
References: <20230606130856.1970660-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert af_alg_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather
than directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/af_alg.c | 52 ++++++++-----------------------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 9c12530d604a..3cf734835ccb 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1114,53 +1114,17 @@ EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags)
 {
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	int err = -EINVAL;
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags | MSG_SPLICE_PAGES,
+	};
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (!size)
-		goto done;
-
-	if (!af_alg_writable(sk)) {
-		err = af_alg_wait_for_wmem(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	err = af_alg_alloc_tsgl(sk);
-	if (err)
-		goto unlock;
-
-	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-
-	if (sgl->cur)
-		sg_unmark_end(sgl->sg + sgl->cur - 1);
-
-	sg_mark_end(sgl->sg + sgl->cur);
-
-	get_page(page);
-	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
-	sgl->cur++;
-	ctx->used += size;
-
-done:
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
+		msg.msg_flags |= MSG_MORE;
 
-	return err ?: size;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return sock_sendmsg(sock, &msg);
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 


