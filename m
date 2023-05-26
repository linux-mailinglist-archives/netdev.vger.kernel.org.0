Return-Path: <netdev+bounces-5717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C07C9712874
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 767B528191B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AF628C2A;
	Fri, 26 May 2023 14:31:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3694931F10
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:31:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3176E5F
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685111498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2+JeX97sTAuGBdDq4pkhVGY1pvhFtHUoAAG71out0Q=;
	b=B96FL2eNujnZZPXpwq0oNfAB5xy/gfsEBBKeHgmVo//KRrLokgC+7GaQ0r92M5EipyddAo
	1hq6Wzphdr0TyzAclJEh8W/EmtF834v/L6wngcKb99a+wND7Q0gCvfYjIH/PX6ILUCGj2W
	5g/vEemym0mMfqj9kDSIpAo/aCfuiu4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-xMkPZctLMmGrywq7icCpaA-1; Fri, 26 May 2023 10:31:33 -0400
X-MC-Unique: xMkPZctLMmGrywq7icCpaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09E968007D9;
	Fri, 26 May 2023 14:31:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 296062166B2B;
	Fri, 26 May 2023 14:31:31 +0000 (UTC)
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
Subject: [PATCH net-next 8/8] crypto: af_alg/hash: Support MSG_SPLICE_PAGES
Date: Fri, 26 May 2023 15:31:04 +0100
Message-Id: <20230526143104.882842-9-dhowells@redhat.com>
In-Reply-To: <20230526143104.882842-1-dhowells@redhat.com>
References: <20230526143104.882842-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make AF_ALG sendmsg() support MSG_SPLICE_PAGES in the hashing code.  This
causes pages to be spliced from the source iterator if possible.

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
 crypto/af_alg.c     |  11 +++--
 crypto/algif_hash.c | 100 +++++++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 41 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 105afd77a064..1965fc4641ed 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -542,9 +542,14 @@ void af_alg_free_sg(struct af_alg_sgl *sgl)
 {
 	int i;
 
-	if (sgl->need_unpin)
-		for (i = 0; i < sgl->sgt.nents; i++)
-			unpin_user_page(sg_page(&sgl->sgt.sgl[i]));
+	if (sgl->sgt.sgl) {
+		if (sgl->need_unpin)
+			for (i = 0; i < sgl->sgt.nents; i++)
+				unpin_user_page(sg_page(&sgl->sgt.sgl[i]));
+		if (sgl->sgt.sgl != sgl->sgl)
+			kvfree(sgl->sgt.sgl);
+		sgl->sgt.sgl = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(af_alg_free_sg);
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 16c69c4b9c62..3d96c0e06ca6 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -63,78 +63,102 @@ static void hash_free_result(struct sock *sk, struct hash_ctx *ctx)
 static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 			size_t ignored)
 {
-	int limit = ALG_MAX_PAGES * PAGE_SIZE;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
-	long copied = 0;
+	ssize_t copied = 0;
+	size_t len, max_pages = ALG_MAX_PAGES, npages;
+	bool continuing = ctx->more, need_init = false;
 	int err;
 
-	if (limit > sk->sk_sndbuf)
-		limit = sk->sk_sndbuf;
+	/* Don't limit to ALG_MAX_PAGES if the pages are all already pinned. */
+	if (!user_backed_iter(&msg->msg_iter))
+		max_pages = INT_MAX;
+	else
+		max_pages = min_t(size_t, max_pages,
+				  DIV_ROUND_UP(sk->sk_sndbuf, PAGE_SIZE));
 
 	lock_sock(sk);
-	if (!ctx->more) {
+	if (!continuing) {
 		if ((msg->msg_flags & MSG_MORE))
 			hash_free_result(sk, ctx);
-
-		err = crypto_wait_req(crypto_ahash_init(&ctx->req), &ctx->wait);
-		if (err)
-			goto unlock;
+		need_init = true;
 	}
 
 	ctx->more = false;
 
 	while (msg_data_left(msg)) {
-		int len = msg_data_left(msg);
-
-		if (len > limit)
-			len = limit;
-
 		ctx->sgl.sgt.sgl = ctx->sgl.sgl;
 		ctx->sgl.sgt.nents = 0;
 		ctx->sgl.sgt.orig_nents = 0;
 
-		len = extract_iter_to_sg(&msg->msg_iter, len, &ctx->sgl.sgt,
-					 ALG_MAX_PAGES, 0);
-		if (len < 0) {
-			err = copied ? 0 : len;
-			goto unlock;
+		err = -EIO;
+		npages = iov_iter_npages(&msg->msg_iter, max_pages);
+		if (npages == 0)
+			goto unlock_free;
+
+		if (npages > ARRAY_SIZE(ctx->sgl.sgl)) {
+			err = -ENOMEM;
+			ctx->sgl.sgt.sgl =
+				kvmalloc(array_size(npages, sizeof(*ctx->sgl.sgt.sgl)),
+					GFP_KERNEL);
+			if (!ctx->sgl.sgt.sgl)
+				goto unlock_free;
 		}
-		sg_mark_end(ctx->sgl.sgt.sgl + ctx->sgl.sgt.nents);
+		sg_init_table(ctx->sgl.sgl, npages);
 
 		ctx->sgl.need_unpin = iov_iter_extract_will_pin(&msg->msg_iter);
 
-		ahash_request_set_crypt(&ctx->req, ctx->sgl.sgt.sgl, NULL, len);
+		err = extract_iter_to_sg(&msg->msg_iter, LONG_MAX,
+					 &ctx->sgl.sgt, npages, 0);
+		if (err < 0)
+			goto unlock_free;
+		len = err;
+		sg_mark_end(ctx->sgl.sgt.sgl + ctx->sgl.sgt.nents - 1);
 
-		err = crypto_wait_req(crypto_ahash_update(&ctx->req),
-				      &ctx->wait);
-		af_alg_free_sg(&ctx->sgl);
-		if (err) {
-			iov_iter_revert(&msg->msg_iter, len);
-			goto unlock;
+		if (!msg_data_left(msg)) {
+			err = hash_alloc_result(sk, ctx);
+			if (err)
+				goto unlock_free;
 		}
 
-		copied += len;
-	}
+		ahash_request_set_crypt(&ctx->req, ctx->sgl.sgt.sgl, ctx->result, len);
 
-	err = 0;
+		if (!msg_data_left(msg) && !continuing && !(msg->msg_flags & MSG_MORE)) {
+			err = crypto_ahash_digest(&ctx->req);
+		} else {
+			if (need_init) {
+				err = crypto_wait_req(crypto_ahash_init(&ctx->req),
+						      &ctx->wait);
+				if (err)
+					goto unlock_free;
+				need_init = false;
+			}
+
+			if (msg_data_left(msg) || (msg->msg_flags & MSG_MORE))
+				err = crypto_ahash_update(&ctx->req);
+			else
+				err = crypto_ahash_finup(&ctx->req);
+			continuing = true;
+		}
 
-	ctx->more = msg->msg_flags & MSG_MORE;
-	if (!ctx->more) {
-		err = hash_alloc_result(sk, ctx);
+		err = crypto_wait_req(err, &ctx->wait);
 		if (err)
-			goto unlock;
+			goto unlock_free;
 
-		ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
-		err = crypto_wait_req(crypto_ahash_final(&ctx->req),
-				      &ctx->wait);
+		copied += len;
+		af_alg_free_sg(&ctx->sgl);
 	}
 
+	ctx->more = msg->msg_flags & MSG_MORE;
+	err = 0;
 unlock:
 	release_sock(sk);
+	return copied ?: err;
 
-	return err ?: copied;
+unlock_free:
+	af_alg_free_sg(&ctx->sgl);
+	goto unlock;
 }
 
 static ssize_t hash_sendpage(struct socket *sock, struct page *page,


