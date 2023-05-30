Return-Path: <netdev+bounces-6417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D3CE7163A8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E4CA1C20BAC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E950A23C86;
	Tue, 30 May 2023 14:18:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93E921072
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:18:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766281AE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685456259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6Cj3Wp9DlUBqB3ssDU9rjwPMpP7CzOqqIN8IX2Zg2c=;
	b=TRxXAVfy3jURQZsZgJgN5WXsgDL8F9PCzwZm/CkSxIs+jmQcryJxon6Y8xIRUcBE36fw03
	Fa80+WsG0E/pUcm4HmdD7RGnes3h+yovdzjEQycpV2MDXVHrhDnkKG4wH9drTec529JtmI
	JuU1AgVh3zygYLOjp2ZKBHF7hmG2GwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-cs3AdqQuO9qpdCoxRFGrbA-1; Tue, 30 May 2023 10:17:36 -0400
X-MC-Unique: cs3AdqQuO9qpdCoxRFGrbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0582811E88;
	Tue, 30 May 2023 14:17:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 24263C154D1;
	Tue, 30 May 2023 14:17:32 +0000 (UTC)
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
Subject: [PATCH net-next v2 06/10] crypto: af_alg: Use extract_iter_to_sg() to create scatterlists
Date: Tue, 30 May 2023 15:16:30 +0100
Message-ID: <20230530141635.136968-7-dhowells@redhat.com>
In-Reply-To: <20230530141635.136968-1-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use extract_iter_to_sg() to decant the destination iterator into a
scatterlist in af_alg_get_rsgl().  af_alg_make_sg() can then be removed.

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

Notes:
    ver #2)
     - Fix some checkpatch warnings.

 crypto/af_alg.c         | 57 +++++++++++------------------------------
 crypto/algif_aead.c     | 16 +++++++-----
 crypto/algif_hash.c     | 18 +++++++++----
 crypto/algif_skcipher.c |  2 +-
 include/crypto/if_alg.h |  6 ++---
 5 files changed, 40 insertions(+), 59 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7caff10df643..b8bf6d8525ba 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -531,45 +531,11 @@ static const struct net_proto_family alg_family = {
 	.owner	=	THIS_MODULE,
 };
 
-int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len)
-{
-	struct page **pages = sgl->pages;
-	size_t off;
-	ssize_t n;
-	int npages, i;
-
-	n = iov_iter_extract_pages(iter, &pages, len, ALG_MAX_PAGES, 0, &off);
-	if (n < 0)
-		return n;
-
-	sgl->need_unpin = iov_iter_extract_will_pin(iter);
-
-	npages = DIV_ROUND_UP(off + n, PAGE_SIZE);
-	if (WARN_ON(npages == 0))
-		return -EINVAL;
-	/* Add one extra for linking */
-	sg_init_table(sgl->sg, npages + 1);
-
-	for (i = 0, len = n; i < npages; i++) {
-		int plen = min_t(int, len, PAGE_SIZE - off);
-
-		sg_set_page(sgl->sg + i, sgl->pages[i], plen, off);
-
-		off = 0;
-		len -= plen;
-	}
-	sg_mark_end(sgl->sg + npages - 1);
-	sgl->npages = npages;
-
-	return n;
-}
-EXPORT_SYMBOL_GPL(af_alg_make_sg);
-
 static void af_alg_link_sg(struct af_alg_sgl *sgl_prev,
 			   struct af_alg_sgl *sgl_new)
 {
-	sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
-	sg_chain(sgl_prev->sg, sgl_prev->npages + 1, sgl_new->sg);
+	sg_unmark_end(sgl_prev->sgt.sgl + sgl_prev->sgt.nents - 1);
+	sg_chain(sgl_prev->sgt.sgl, sgl_prev->sgt.nents + 1, sgl_new->sgt.sgl);
 }
 
 void af_alg_free_sg(struct af_alg_sgl *sgl)
@@ -577,8 +543,8 @@ void af_alg_free_sg(struct af_alg_sgl *sgl)
 	int i;
 
 	if (sgl->need_unpin)
-		for (i = 0; i < sgl->npages; i++)
-			unpin_user_page(sgl->pages[i]);
+		for (i = 0; i < sgl->sgt.nents; i++)
+			unpin_user_page(sg_page(&sgl->sgt.sgl[i]));
 }
 EXPORT_SYMBOL_GPL(af_alg_free_sg);
 
@@ -1292,8 +1258,8 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 	while (maxsize > len && msg_data_left(msg)) {
 		struct af_alg_rsgl *rsgl;
+		ssize_t err;
 		size_t seglen;
-		int err;
 
 		/* limit the amount of readable buffers */
 		if (!af_alg_readable(sk))
@@ -1310,16 +1276,23 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 				return -ENOMEM;
 		}
 
-		rsgl->sgl.npages = 0;
+		rsgl->sgl.sgt.sgl = rsgl->sgl.sgl;
+		rsgl->sgl.sgt.nents = 0;
+		rsgl->sgl.sgt.orig_nents = 0;
 		list_add_tail(&rsgl->list, &areq->rsgl_list);
 
-		/* make one iovec available as scatterlist */
-		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
+		sg_init_table(rsgl->sgl.sgt.sgl, ALG_MAX_PAGES);
+		err = extract_iter_to_sg(&msg->msg_iter, seglen, &rsgl->sgl.sgt,
+					 ALG_MAX_PAGES, 0);
 		if (err < 0) {
 			rsgl->sg_num_bytes = 0;
 			return err;
 		}
 
+		sg_mark_end(rsgl->sgl.sgt.sgl + rsgl->sgl.sgt.nents - 1);
+		rsgl->sgl.need_unpin =
+			iov_iter_extract_will_pin(&msg->msg_iter);
+
 		/* chain the new scatterlist with previous one */
 		if (areq->last_rsgl)
 			af_alg_link_sg(&areq->last_rsgl->sgl, &rsgl->sgl);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 42493b4d8ce4..829878025dba 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -210,7 +210,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 */
 
 	/* Use the RX SGL as source (and destination) for crypto op. */
-	rsgl_src = areq->first_rsgl.sgl.sg;
+	rsgl_src = areq->first_rsgl.sgl.sgt.sgl;
 
 	if (ctx->enc) {
 		/*
@@ -224,7 +224,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 * RX SGL: AAD || PT || Tag
 		 */
 		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
-					   areq->first_rsgl.sgl.sg, processed);
+					   areq->first_rsgl.sgl.sgt.sgl,
+					   processed);
 		if (err)
 			goto free;
 		af_alg_pull_tsgl(sk, processed, NULL, 0);
@@ -242,7 +243,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 		 /* Copy AAD || CT to RX SGL buffer for in-place operation. */
 		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
-					   areq->first_rsgl.sgl.sg, outlen);
+					   areq->first_rsgl.sgl.sgt.sgl,
+					   outlen);
 		if (err)
 			goto free;
 
@@ -267,10 +269,10 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		if (usedpages) {
 			/* RX SGL present */
 			struct af_alg_sgl *sgl_prev = &areq->last_rsgl->sgl;
+			struct scatterlist *sg = sgl_prev->sgt.sgl;
 
-			sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
-			sg_chain(sgl_prev->sg, sgl_prev->npages + 1,
-				 areq->tsgl);
+			sg_unmark_end(sg + sgl_prev->sgt.nents - 1);
+			sg_chain(sg, sgl_prev->sgt.nents + 1, areq->tsgl);
 		} else
 			/* no RX SGL present (e.g. authentication only) */
 			rsgl_src = areq->tsgl;
@@ -278,7 +280,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
-			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 63af72e19fa8..16c69c4b9c62 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -91,13 +91,21 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (len > limit)
 			len = limit;
 
-		len = af_alg_make_sg(&ctx->sgl, &msg->msg_iter, len);
+		ctx->sgl.sgt.sgl = ctx->sgl.sgl;
+		ctx->sgl.sgt.nents = 0;
+		ctx->sgl.sgt.orig_nents = 0;
+
+		len = extract_iter_to_sg(&msg->msg_iter, len, &ctx->sgl.sgt,
+					 ALG_MAX_PAGES, 0);
 		if (len < 0) {
 			err = copied ? 0 : len;
 			goto unlock;
 		}
+		sg_mark_end(ctx->sgl.sgt.sgl + ctx->sgl.sgt.nents);
+
+		ctx->sgl.need_unpin = iov_iter_extract_will_pin(&msg->msg_iter);
 
-		ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, NULL, len);
+		ahash_request_set_crypt(&ctx->req, ctx->sgl.sgt.sgl, NULL, len);
 
 		err = crypto_wait_req(crypto_ahash_update(&ctx->req),
 				      &ctx->wait);
@@ -141,8 +149,8 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 		flags |= MSG_MORE;
 
 	lock_sock(sk);
-	sg_init_table(ctx->sgl.sg, 1);
-	sg_set_page(ctx->sgl.sg, page, size, offset);
+	sg_init_table(ctx->sgl.sgl, 1);
+	sg_set_page(ctx->sgl.sgl, page, size, offset);
 
 	if (!(flags & MSG_MORE)) {
 		err = hash_alloc_result(sk, ctx);
@@ -151,7 +159,7 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	} else if (!ctx->more)
 		hash_free_result(sk, ctx);
 
-	ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, ctx->result, size);
+	ahash_request_set_crypt(&ctx->req, ctx->sgl.sgl, ctx->result, size);
 
 	if (!(flags & MSG_MORE)) {
 		if (ctx->more)
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ee8890ee8f33..a251cd6bd5b9 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -105,7 +105,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sg, len, ctx->iv);
+				   areq->first_rsgl.sgl.sgt.sgl, len, ctx->iv);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 46494b33f5bc..34224e77f5a2 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -56,9 +56,8 @@ struct af_alg_type {
 };
 
 struct af_alg_sgl {
-	struct scatterlist sg[ALG_MAX_PAGES + 1];
-	struct page *pages[ALG_MAX_PAGES];
-	unsigned int npages;
+	struct sg_table sgt;
+	struct scatterlist sgl[ALG_MAX_PAGES + 1];
 	bool need_unpin;
 };
 
@@ -164,7 +163,6 @@ int af_alg_release(struct socket *sock);
 void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern);
 
-int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
 void af_alg_free_sg(struct af_alg_sgl *sgl);
 
 static inline struct alg_sock *alg_sk(struct sock *sk)


