Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD4468BBAD
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjBFLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjBFLdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:43 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BA813DF7;
        Mon,  6 Feb 2023 03:33:34 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydn-007zi3-LG; Mon, 06 Feb 2023 18:22:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:27 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:27 +0800
Subject: [PATCH 8/17] tls: Only use data field in crypto completion function
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Message-Id: <E1pOydn-007zi3-LG@formenos.hmeau.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crypto_async_request passed to the completion is not guaranteed
to be the original request object.  Only the data field can be relied
upon.

Fix this by storing the socket pointer with the AEAD request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/tls/tls.h    |    2 ++
 net/tls/tls_sw.c |   40 +++++++++++++++++++++++++++++-----------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 0e840a0c3437..804c3880d028 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -70,6 +70,8 @@ struct tls_rec {
 	char content_type;
 	struct scatterlist sg_content_type;
 
+	struct sock *sk;
+
 	char aad_space[TLS_AAD_SPACE_SIZE];
 	u8 iv_data[MAX_IV_SIZE];
 	struct aead_request aead_req;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..5b7f67a7d394 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -38,6 +38,7 @@
 #include <linux/bug.h>
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/splice.h>
 #include <crypto/aead.h>
 
@@ -57,6 +58,7 @@ struct tls_decrypt_arg {
 };
 
 struct tls_decrypt_ctx {
+	struct sock *sk;
 	u8 iv[MAX_IV_SIZE];
 	u8 aad[TLS_MAX_AAD_SIZE];
 	u8 tail;
@@ -177,18 +179,25 @@ static int tls_padding_length(struct tls_prot_info *prot, struct sk_buff *skb,
 	return sub;
 }
 
-static void tls_decrypt_done(struct crypto_async_request *req, int err)
+static void tls_decrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct aead_request *aead_req = (struct aead_request *)req;
+	struct aead_request *aead_req = crypto_get_completion_data(data);
+	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
 	struct scatterlist *sgout = aead_req->dst;
 	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
+	struct tls_decrypt_ctx *dctx;
 	struct tls_context *tls_ctx;
 	struct scatterlist *sg;
 	unsigned int pages;
 	struct sock *sk;
+	int aead_size;
 
-	sk = (struct sock *)req->data;
+	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(aead);
+	aead_size = ALIGN(aead_size, __alignof__(*dctx));
+	dctx = (void *)((u8 *)aead_req + aead_size);
+
+	sk = dctx->sk;
 	tls_ctx = tls_get_ctx(sk);
 	ctx = tls_sw_ctx_rx(tls_ctx);
 
@@ -240,7 +249,7 @@ static int tls_do_decryption(struct sock *sk,
 	if (darg->async) {
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  tls_decrypt_done, sk);
+					  tls_decrypt_done, aead_req);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -336,6 +345,8 @@ static struct tls_rec *tls_get_rec(struct sock *sk)
 	sg_set_buf(&rec->sg_aead_out[0], rec->aad_space, prot->aad_size);
 	sg_unmark_end(&rec->sg_aead_out[1]);
 
+	rec->sk = sk;
+
 	return rec;
 }
 
@@ -417,22 +428,27 @@ int tls_tx_records(struct sock *sk, int flags)
 	return rc;
 }
 
-static void tls_encrypt_done(struct crypto_async_request *req, int err)
+static void tls_encrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct aead_request *aead_req = (struct aead_request *)req;
-	struct sock *sk = req->data;
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct aead_request *aead_req = crypto_get_completion_data(data);
+	struct tls_sw_context_tx *ctx;
+	struct tls_context *tls_ctx;
+	struct tls_prot_info *prot;
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
 	struct tls_rec *rec;
 	bool ready = false;
+	struct sock *sk;
 	int pending;
 
 	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
 
+	sk = rec->sk;
+	tls_ctx = tls_get_ctx(sk);
+	prot = &tls_ctx->prot_info;
+	ctx = tls_sw_ctx_tx(tls_ctx);
+
 	sge = sk_msg_elem(msg_en, msg_en->sg.curr);
 	sge->offset -= prot->prepend_size;
 	sge->length += prot->prepend_size;
@@ -520,7 +536,7 @@ static int tls_do_encryption(struct sock *sk,
 			       data_len, rec->iv_data);
 
 	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  tls_encrypt_done, sk);
+				  tls_encrypt_done, aead_req);
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
@@ -1485,6 +1501,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	 * Both structs are variable length.
 	 */
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
+	aead_size = ALIGN(aead_size, __alignof__(*dctx));
 	mem = kmalloc(aead_size + struct_size(dctx, sg, n_sgin + n_sgout),
 		      sk->sk_allocation);
 	if (!mem) {
@@ -1495,6 +1512,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	/* Segment the allocated memory */
 	aead_req = (struct aead_request *)mem;
 	dctx = (struct tls_decrypt_ctx *)(mem + aead_size);
+	dctx->sk = sk;
 	sgin = &dctx->sg[0];
 	sgout = &dctx->sg[n_sgin];
 
