Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7568268E7F9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBHF7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBHF7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:59:31 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC34CB47C;
        Tue,  7 Feb 2023 21:59:27 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPdTg-008l4u-Fv; Wed, 08 Feb 2023 13:58:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Feb 2023 13:58:44 +0800
Date:   Wed, 8 Feb 2023 13:58:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
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
Subject: [v2 PATCH 10/17] crypto: api - Use data directly in completion
 function
Message-ID: <Y+M6FDVFcXRNQtwi@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydr-007ziX-T2@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pOydr-007ziX-T2@formenos.hmeau.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 adds the actual algapi conversion which went missing.

---8<---
This patch does the final flag day conversion of all completion
functions which are now all contained in the Crypto API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/adiantum.c          |    5 +---
 crypto/af_alg.c            |    6 ++---
 crypto/ahash.c             |   12 +++++-----
 crypto/api.c               |    4 +--
 crypto/authenc.c           |   14 +++++-------
 crypto/authencesn.c        |   15 +++++-------
 crypto/ccm.c               |    9 +++----
 crypto/chacha20poly1305.c  |   40 +++++++++++++++++-----------------
 crypto/cryptd.c            |   52 ++++++++++++++++++++++-----------------------
 crypto/cts.c               |   12 +++++-----
 crypto/dh.c                |    5 +---
 crypto/essiv.c             |    8 +++---
 crypto/gcm.c               |   36 ++++++++++++++-----------------
 crypto/hctr2.c             |    5 +---
 crypto/lrw.c               |    4 +--
 crypto/pcrypt.c            |    4 +--
 crypto/rsa-pkcs1pad.c      |   15 +++++-------
 crypto/seqiv.c             |    5 +---
 crypto/xts.c               |   12 +++++-----
 drivers/crypto/atmel-sha.c |    5 +---
 include/crypto/algapi.h    |    3 --
 include/crypto/if_alg.h    |    4 ---
 include/linux/crypto.h     |   10 ++++----
 23 files changed, 133 insertions(+), 152 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 84450130cb6b..c33ba22a6638 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -308,10 +308,9 @@ static int adiantum_finish(struct skcipher_request *req)
 	return 0;
 }
 
-static void adiantum_streamcipher_done(struct crypto_async_request *areq,
-				       int err)
+static void adiantum_streamcipher_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (!err)
 		err = adiantum_finish(req);
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 0a4fa2a429e2..5f7252a5b7b4 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1186,7 +1186,7 @@ EXPORT_SYMBOL_GPL(af_alg_free_resources);
 
 /**
  * af_alg_async_cb - AIO callback handler
- * @_req: async request info
+ * @data: async request completion data
  * @err: if non-zero, error result to be returned via ki_complete();
  *       otherwise return the AIO output length via ki_complete().
  *
@@ -1196,9 +1196,9 @@ EXPORT_SYMBOL_GPL(af_alg_free_resources);
  * The number of bytes to be generated with the AIO operation must be set
  * in areq->outlen before the AIO callback handler is invoked.
  */
-void af_alg_async_cb(struct crypto_async_request *_req, int err)
+void af_alg_async_cb(void *data, int err)
 {
-	struct af_alg_async_req *areq = _req->data;
+	struct af_alg_async_req *areq = data;
 	struct sock *sk = areq->sk;
 	struct kiocb *iocb = areq->iocb;
 	unsigned int resultlen;
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 369447e483cd..5a0f21cb2059 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -240,9 +240,9 @@ static void ahash_restore_req(struct ahash_request *req, int err)
 	kfree_sensitive(subreq);
 }
 
-static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
+static void ahash_op_unaligned_done(void *data, int err)
 {
-	struct ahash_request *areq = req->data;
+	struct ahash_request *areq = data;
 
 	if (err == -EINPROGRESS)
 		goto out;
@@ -330,9 +330,9 @@ int crypto_ahash_digest(struct ahash_request *req)
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
-static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
+static void ahash_def_finup_done2(void *data, int err)
 {
-	struct ahash_request *areq = req->data;
+	struct ahash_request *areq = data;
 
 	if (err == -EINPROGRESS)
 		return;
@@ -360,9 +360,9 @@ static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 	return err;
 }
 
-static void ahash_def_finup_done1(struct crypto_async_request *req, int err)
+static void ahash_def_finup_done1(void *data, int err)
 {
-	struct ahash_request *areq = req->data;
+	struct ahash_request *areq = data;
 	struct ahash_request *subreq;
 
 	if (err == -EINPROGRESS)
diff --git a/crypto/api.c b/crypto/api.c
index b022702f6436..e67cc63368ed 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -643,9 +643,9 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
-void crypto_req_done(struct crypto_async_request *req, int err)
+void crypto_req_done(void *data, int err)
 {
-	struct crypto_wait *wait = req->data;
+	struct crypto_wait *wait = data;
 
 	if (err == -EINPROGRESS)
 		return;
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 17f674a7cdff..3326c7343e86 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -109,9 +109,9 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	return err;
 }
 
-static void authenc_geniv_ahash_done(struct crypto_async_request *areq, int err)
+static void authenc_geniv_ahash_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
@@ -160,10 +160,9 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 	return 0;
 }
 
-static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
-					int err)
+static void crypto_authenc_encrypt_done(void *data, int err)
 {
-	struct aead_request *areq = req->data;
+	struct aead_request *areq = data;
 
 	if (err)
 		goto out;
@@ -261,10 +260,9 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 	return crypto_skcipher_decrypt(skreq);
 }
 
-static void authenc_verify_ahash_done(struct crypto_async_request *areq,
-				      int err)
+static void authenc_verify_ahash_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index b60e61b1904c..91424e791d5c 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -107,10 +107,9 @@ static int crypto_authenc_esn_genicv_tail(struct aead_request *req,
 	return 0;
 }
 
-static void authenc_esn_geniv_ahash_done(struct crypto_async_request *areq,
-					 int err)
+static void authenc_esn_geniv_ahash_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	err = err ?: crypto_authenc_esn_genicv_tail(req, 0);
 	aead_request_complete(req, err);
@@ -153,10 +152,9 @@ static int crypto_authenc_esn_genicv(struct aead_request *req,
 }
 
 
-static void crypto_authenc_esn_encrypt_done(struct crypto_async_request *req,
-					    int err)
+static void crypto_authenc_esn_encrypt_done(void *data, int err)
 {
-	struct aead_request *areq = req->data;
+	struct aead_request *areq = data;
 
 	if (!err)
 		err = crypto_authenc_esn_genicv(areq, 0);
@@ -258,10 +256,9 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	return crypto_skcipher_decrypt(skreq);
 }
 
-static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
-					  int err)
+static void authenc_esn_verify_ahash_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	err = err ?: crypto_authenc_esn_decrypt_tail(req, 0);
 	authenc_esn_request_complete(req, err);
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 30dbae72728f..a9453129c51c 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -224,9 +224,9 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
 	return err;
 }
 
-static void crypto_ccm_encrypt_done(struct crypto_async_request *areq, int err)
+static void crypto_ccm_encrypt_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
 	u8 *odata = pctx->odata;
@@ -320,10 +320,9 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	return err;
 }
 
-static void crypto_ccm_decrypt_done(struct crypto_async_request *areq,
-				   int err)
+static void crypto_ccm_decrypt_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(aead);
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 97bbb135e9a6..3a905c5d8f53 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -115,9 +115,9 @@ static int poly_copy_tag(struct aead_request *req)
 	return 0;
 }
 
-static void chacha_decrypt_done(struct crypto_async_request *areq, int err)
+static void chacha_decrypt_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_verify_tag);
+	async_done_continue(data, err, poly_verify_tag);
 }
 
 static int chacha_decrypt(struct aead_request *req)
@@ -161,9 +161,9 @@ static int poly_tail_continue(struct aead_request *req)
 	return chacha_decrypt(req);
 }
 
-static void poly_tail_done(struct crypto_async_request *areq, int err)
+static void poly_tail_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_tail_continue);
+	async_done_continue(data, err, poly_tail_continue);
 }
 
 static int poly_tail(struct aead_request *req)
@@ -191,9 +191,9 @@ static int poly_tail(struct aead_request *req)
 	return poly_tail_continue(req);
 }
 
-static void poly_cipherpad_done(struct crypto_async_request *areq, int err)
+static void poly_cipherpad_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_tail);
+	async_done_continue(data, err, poly_tail);
 }
 
 static int poly_cipherpad(struct aead_request *req)
@@ -220,9 +220,9 @@ static int poly_cipherpad(struct aead_request *req)
 	return poly_tail(req);
 }
 
-static void poly_cipher_done(struct crypto_async_request *areq, int err)
+static void poly_cipher_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_cipherpad);
+	async_done_continue(data, err, poly_cipherpad);
 }
 
 static int poly_cipher(struct aead_request *req)
@@ -250,9 +250,9 @@ static int poly_cipher(struct aead_request *req)
 	return poly_cipherpad(req);
 }
 
-static void poly_adpad_done(struct crypto_async_request *areq, int err)
+static void poly_adpad_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_cipher);
+	async_done_continue(data, err, poly_cipher);
 }
 
 static int poly_adpad(struct aead_request *req)
@@ -279,9 +279,9 @@ static int poly_adpad(struct aead_request *req)
 	return poly_cipher(req);
 }
 
-static void poly_ad_done(struct crypto_async_request *areq, int err)
+static void poly_ad_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_adpad);
+	async_done_continue(data, err, poly_adpad);
 }
 
 static int poly_ad(struct aead_request *req)
@@ -303,9 +303,9 @@ static int poly_ad(struct aead_request *req)
 	return poly_adpad(req);
 }
 
-static void poly_setkey_done(struct crypto_async_request *areq, int err)
+static void poly_setkey_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_ad);
+	async_done_continue(data, err, poly_ad);
 }
 
 static int poly_setkey(struct aead_request *req)
@@ -329,9 +329,9 @@ static int poly_setkey(struct aead_request *req)
 	return poly_ad(req);
 }
 
-static void poly_init_done(struct crypto_async_request *areq, int err)
+static void poly_init_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_setkey);
+	async_done_continue(data, err, poly_setkey);
 }
 
 static int poly_init(struct aead_request *req)
@@ -352,9 +352,9 @@ static int poly_init(struct aead_request *req)
 	return poly_setkey(req);
 }
 
-static void poly_genkey_done(struct crypto_async_request *areq, int err)
+static void poly_genkey_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_init);
+	async_done_continue(data, err, poly_init);
 }
 
 static int poly_genkey(struct aead_request *req)
@@ -391,9 +391,9 @@ static int poly_genkey(struct aead_request *req)
 	return poly_init(req);
 }
 
-static void chacha_encrypt_done(struct crypto_async_request *areq, int err)
+static void chacha_encrypt_done(void *data, int err)
 {
-	async_done_continue(areq->data, err, poly_genkey);
+	async_done_continue(data, err, poly_genkey);
 }
 
 static int chacha_encrypt(struct aead_request *req)
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 29890fc0eab7..37365ed30b38 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -285,10 +285,9 @@ static void cryptd_skcipher_complete(struct skcipher_request *req, int err,
 		crypto_free_skcipher(tfm);
 }
 
-static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
-				    int err)
+static void cryptd_skcipher_encrypt(void *data, int err)
 {
-	struct skcipher_request *req = skcipher_request_cast(base);
+	struct skcipher_request *req = data;
 	struct skcipher_request *subreq;
 
 	subreq = cryptd_skcipher_prepare(req, err);
@@ -298,10 +297,9 @@ static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
 	cryptd_skcipher_complete(req, err, cryptd_skcipher_encrypt);
 }
 
-static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
-				    int err)
+static void cryptd_skcipher_decrypt(void *data, int err)
 {
-	struct skcipher_request *req = skcipher_request_cast(base);
+	struct skcipher_request *req = data;
 	struct skcipher_request *subreq;
 
 	subreq = cryptd_skcipher_prepare(req, err);
@@ -515,9 +513,9 @@ static void cryptd_hash_complete(struct ahash_request *req, int err,
 		crypto_free_ahash(tfm);
 }
 
-static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
+static void cryptd_hash_init(void *data, int err)
 {
-	struct ahash_request *req = ahash_request_cast(req_async);
+	struct ahash_request *req = data;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_shash *child = ctx->child;
@@ -540,9 +538,9 @@ static int cryptd_hash_init_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_init);
 }
 
-static void cryptd_hash_update(struct crypto_async_request *req_async, int err)
+static void cryptd_hash_update(void *data, int err)
 {
-	struct ahash_request *req = ahash_request_cast(req_async);
+	struct ahash_request *req = data;
 	struct shash_desc *desc;
 
 	desc = cryptd_hash_prepare(req, err);
@@ -557,9 +555,9 @@ static int cryptd_hash_update_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_update);
 }
 
-static void cryptd_hash_final(struct crypto_async_request *req_async, int err)
+static void cryptd_hash_final(void *data, int err)
 {
-	struct ahash_request *req = ahash_request_cast(req_async);
+	struct ahash_request *req = data;
 	struct shash_desc *desc;
 
 	desc = cryptd_hash_prepare(req, err);
@@ -574,9 +572,9 @@ static int cryptd_hash_final_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_final);
 }
 
-static void cryptd_hash_finup(struct crypto_async_request *req_async, int err)
+static void cryptd_hash_finup(void *data, int err)
 {
-	struct ahash_request *req = ahash_request_cast(req_async);
+	struct ahash_request *req = data;
 	struct shash_desc *desc;
 
 	desc = cryptd_hash_prepare(req, err);
@@ -591,9 +589,9 @@ static int cryptd_hash_finup_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_finup);
 }
 
-static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
+static void cryptd_hash_digest(void *data, int err)
 {
-	struct ahash_request *req = ahash_request_cast(req_async);
+	struct ahash_request *req = data;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_shash *child = ctx->child;
@@ -767,24 +765,26 @@ static void cryptd_aead_crypt(struct aead_request *req,
 		crypto_free_aead(tfm);
 }
 
-static void cryptd_aead_encrypt(struct crypto_async_request *areq, int err)
+static void cryptd_aead_encrypt(void *data, int err)
 {
-	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(areq->tfm);
-	struct crypto_aead *child = ctx->child;
-	struct aead_request *req;
+	struct aead_request *req = data;
+	struct cryptd_aead_ctx *ctx;
+	struct crypto_aead *child;
 
-	req = container_of(areq, struct aead_request, base);
+	ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	child = ctx->child;
 	cryptd_aead_crypt(req, child, err, crypto_aead_alg(child)->encrypt,
 			  cryptd_aead_encrypt);
 }
 
-static void cryptd_aead_decrypt(struct crypto_async_request *areq, int err)
+static void cryptd_aead_decrypt(void *data, int err)
 {
-	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(areq->tfm);
-	struct crypto_aead *child = ctx->child;
-	struct aead_request *req;
+	struct aead_request *req = data;
+	struct cryptd_aead_ctx *ctx;
+	struct crypto_aead *child;
 
-	req = container_of(areq, struct aead_request, base);
+	ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	child = ctx->child;
 	cryptd_aead_crypt(req, child, err, crypto_aead_alg(child)->decrypt,
 			  cryptd_aead_decrypt);
 }
diff --git a/crypto/cts.c b/crypto/cts.c
index 3766d47ebcc0..8f604f6554b1 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -85,9 +85,9 @@ static int crypto_cts_setkey(struct crypto_skcipher *parent, const u8 *key,
 	return crypto_skcipher_setkey(child, key, keylen);
 }
 
-static void cts_cbc_crypt_done(struct crypto_async_request *areq, int err)
+static void cts_cbc_crypt_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (err == -EINPROGRESS)
 		return;
@@ -125,9 +125,9 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	return crypto_skcipher_encrypt(subreq);
 }
 
-static void crypto_cts_encrypt_done(struct crypto_async_request *areq, int err)
+static void crypto_cts_encrypt_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (err)
 		goto out;
@@ -219,9 +219,9 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	return crypto_skcipher_decrypt(subreq);
 }
 
-static void crypto_cts_decrypt_done(struct crypto_async_request *areq, int err)
+static void crypto_cts_decrypt_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (err)
 		goto out;
diff --git a/crypto/dh.c b/crypto/dh.c
index e39c1bde1ac0..0fcad279e6fe 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -503,10 +503,9 @@ static int dh_safe_prime_set_secret(struct crypto_kpp *tfm, const void *buffer,
 	return err;
 }
 
-static void dh_safe_prime_complete_req(struct crypto_async_request *dh_req,
-				       int err)
+static void dh_safe_prime_complete_req(void *data, int err)
 {
-	struct kpp_request *req = dh_req->data;
+	struct kpp_request *req = data;
 
 	kpp_request_complete(req, err);
 }
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 307eba74b901..f7d4ef4837e5 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -131,9 +131,9 @@ static int essiv_aead_setauthsize(struct crypto_aead *tfm,
 	return crypto_aead_setauthsize(tctx->u.aead, authsize);
 }
 
-static void essiv_skcipher_done(struct crypto_async_request *areq, int err)
+static void essiv_skcipher_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	skcipher_request_complete(req, err);
 }
@@ -166,9 +166,9 @@ static int essiv_skcipher_decrypt(struct skcipher_request *req)
 	return essiv_skcipher_crypt(req, false);
 }
 
-static void essiv_aead_done(struct crypto_async_request *areq, int err)
+static void essiv_aead_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 
 	if (err == -EINPROGRESS)
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 338ee0769747..4ba624450c3f 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -197,7 +197,7 @@ static inline unsigned int gcm_remain(unsigned int len)
 	return len ? 16 - len : 0;
 }
 
-static void gcm_hash_len_done(struct crypto_async_request *areq, int err);
+static void gcm_hash_len_done(void *data, int err);
 
 static int gcm_hash_update(struct aead_request *req,
 			   crypto_completion_t compl,
@@ -246,9 +246,9 @@ static int gcm_hash_len_continue(struct aead_request *req, u32 flags)
 	return gctx->complete(req, flags);
 }
 
-static void gcm_hash_len_done(struct crypto_async_request *areq, int err)
+static void gcm_hash_len_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -267,10 +267,9 @@ static int gcm_hash_crypt_remain_continue(struct aead_request *req, u32 flags)
 	       gcm_hash_len_continue(req, flags);
 }
 
-static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
-				       int err)
+static void gcm_hash_crypt_remain_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -298,9 +297,9 @@ static int gcm_hash_crypt_continue(struct aead_request *req, u32 flags)
 	return gcm_hash_crypt_remain_continue(req, flags);
 }
 
-static void gcm_hash_crypt_done(struct crypto_async_request *areq, int err)
+static void gcm_hash_crypt_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -326,10 +325,9 @@ static int gcm_hash_assoc_remain_continue(struct aead_request *req, u32 flags)
 	return gcm_hash_crypt_remain_continue(req, flags);
 }
 
-static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
-				       int err)
+static void gcm_hash_assoc_remain_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -355,9 +353,9 @@ static int gcm_hash_assoc_continue(struct aead_request *req, u32 flags)
 	return gcm_hash_assoc_remain_continue(req, flags);
 }
 
-static void gcm_hash_assoc_done(struct crypto_async_request *areq, int err)
+static void gcm_hash_assoc_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -380,9 +378,9 @@ static int gcm_hash_init_continue(struct aead_request *req, u32 flags)
 	return gcm_hash_assoc_remain_continue(req, flags);
 }
 
-static void gcm_hash_init_done(struct crypto_async_request *areq, int err)
+static void gcm_hash_init_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -433,9 +431,9 @@ static int gcm_encrypt_continue(struct aead_request *req, u32 flags)
 	return gcm_hash(req, flags);
 }
 
-static void gcm_encrypt_done(struct crypto_async_request *areq, int err)
+static void gcm_encrypt_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (err)
 		goto out;
@@ -477,9 +475,9 @@ static int crypto_gcm_verify(struct aead_request *req)
 	return crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
 }
 
-static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
+static void gcm_decrypt_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 
 	if (!err)
 		err = crypto_gcm_verify(req);
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index 7d00a3bcb667..6f4c1884d0e9 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -252,10 +252,9 @@ static int hctr2_finish(struct skcipher_request *req)
 	return 0;
 }
 
-static void hctr2_xctr_done(struct crypto_async_request *areq,
-				    int err)
+static void hctr2_xctr_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (!err)
 		err = hctr2_finish(req);
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 8d59a66b6525..1b0f76ba3eb5 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -205,9 +205,9 @@ static int lrw_xor_tweak_post(struct skcipher_request *req)
 	return lrw_xor_tweak(req, true);
 }
 
-static void lrw_crypt_done(struct crypto_async_request *areq, int err)
+static void lrw_crypt_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (!err) {
 		struct lrw_request_ctx *rctx = skcipher_request_ctx(req);
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9d10b846ccf7..8c1d0ca41213 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -63,9 +63,9 @@ static void pcrypt_aead_serial(struct padata_priv *padata)
 	aead_request_complete(req->base.data, padata->info);
 }
 
-static void pcrypt_aead_done(struct crypto_async_request *areq, int err)
+static void pcrypt_aead_done(void *data, int err)
 {
-	struct aead_request *req = areq->data;
+	struct aead_request *req = data;
 	struct pcrypt_request *preq = aead_request_ctx(req);
 	struct padata_priv *padata = pcrypt_request_padata(preq);
 
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 02028670331d..d2e5e104f8cf 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -210,10 +210,9 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	return err;
 }
 
-static void pkcs1pad_encrypt_sign_complete_cb(
-		struct crypto_async_request *child_async_req, int err)
+static void pkcs1pad_encrypt_sign_complete_cb(void *data, int err)
 {
-	struct akcipher_request *req = child_async_req->data;
+	struct akcipher_request *req = data;
 
 	if (err == -EINPROGRESS)
 		goto out;
@@ -326,10 +325,9 @@ static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
 	return err;
 }
 
-static void pkcs1pad_decrypt_complete_cb(
-		struct crypto_async_request *child_async_req, int err)
+static void pkcs1pad_decrypt_complete_cb(void *data, int err)
 {
-	struct akcipher_request *req = child_async_req->data;
+	struct akcipher_request *req = data;
 
 	if (err == -EINPROGRESS)
 		goto out;
@@ -506,10 +504,9 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 	return err;
 }
 
-static void pkcs1pad_verify_complete_cb(
-		struct crypto_async_request *child_async_req, int err)
+static void pkcs1pad_verify_complete_cb(void *data, int err)
 {
-	struct akcipher_request *req = child_async_req->data;
+	struct akcipher_request *req = data;
 
 	if (err == -EINPROGRESS)
 		goto out;
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index b1bcfe537daf..17e11d51ddc3 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -36,10 +36,9 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	kfree_sensitive(subreq->iv);
 }
 
-static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
-					int err)
+static void seqiv_aead_encrypt_complete(void *data, int err)
 {
-	struct aead_request *req = base->data;
+	struct aead_request *req = data;
 
 	seqiv_aead_encrypt_complete2(req, err);
 	aead_request_complete(req, err);
diff --git a/crypto/xts.c b/crypto/xts.c
index de6cbcf69bbd..09be909a6a1a 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -140,9 +140,9 @@ static int xts_xor_tweak_post(struct skcipher_request *req, bool enc)
 	return xts_xor_tweak(req, true, enc);
 }
 
-static void xts_cts_done(struct crypto_async_request *areq, int err)
+static void xts_cts_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 	le128 b;
 
 	if (!err) {
@@ -196,9 +196,9 @@ static int xts_cts_final(struct skcipher_request *req,
 	return 0;
 }
 
-static void xts_encrypt_done(struct crypto_async_request *areq, int err)
+static void xts_encrypt_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
@@ -216,9 +216,9 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
 	skcipher_request_complete(req, err);
 }
 
-static void xts_decrypt_done(struct crypto_async_request *areq, int err)
+static void xts_decrypt_done(void *data, int err)
 {
-	struct skcipher_request *req = areq->data;
+	struct skcipher_request *req = data;
 
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index a77cf0da0816..e7c1db2739ec 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2099,10 +2099,9 @@ struct atmel_sha_authenc_reqctx {
 	unsigned int		digestlen;
 };
 
-static void atmel_sha_authenc_complete(struct crypto_async_request *areq,
-				       int err)
+static void atmel_sha_authenc_complete(void *data, int err)
 {
-	struct ahash_request *req = areq->data;
+	struct ahash_request *req = data;
 	struct atmel_sha_authenc_reqctx *authctx  = ahash_request_ctx(req);
 
 	authctx->cb(authctx->aes_dev, err, authctx->base.dd->is_async);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 1fd81e74a174..fede394ae2ab 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -305,8 +305,7 @@ enum {
 static inline void crypto_request_complete(struct crypto_async_request *req,
 					   int err)
 {
-	crypto_completion_t complete = req->complete;
-	complete(req, err);
+	req->complete(req->data, err);
 }
 
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index a5db86670bdf..7e76623f9ec3 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -21,8 +21,6 @@
 
 #define ALG_MAX_PAGES			16
 
-struct crypto_async_request;
-
 struct alg_sock {
 	/* struct sock must be the first member of struct alg_sock */
 	struct sock sk;
@@ -235,7 +233,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags);
 void af_alg_free_resources(struct af_alg_async_req *areq);
-void af_alg_async_cb(struct crypto_async_request *_req, int err);
+void af_alg_async_cb(void *data, int err);
 __poll_t af_alg_poll(struct file *file, struct socket *sock,
 			 poll_table *wait);
 struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b18f6e669fb1..80f6350fb588 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -176,8 +176,8 @@ struct crypto_async_request;
 struct crypto_tfm;
 struct crypto_type;
 
-typedef struct crypto_async_request crypto_completion_data_t;
-typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
+typedef void crypto_completion_data_t;
+typedef void (*crypto_completion_t)(void *req, int err);
 
 /**
  * DOC: Block Cipher Context Data Structures
@@ -596,12 +596,12 @@ struct crypto_wait {
 /*
  * Async ops completion helper functioons
  */
-static inline void *crypto_get_completion_data(crypto_completion_data_t *req)
+static inline void *crypto_get_completion_data(void *data)
 {
-	return req->data;
+	return data;
 }
 
-void crypto_req_done(struct crypto_async_request *req, int err);
+void crypto_req_done(void *req, int err);
 
 static inline int crypto_wait_req(int err, struct crypto_wait *wait)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
