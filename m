Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C05768BBB5
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjBFLeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjBFLdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:44 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA121E1FE;
        Mon,  6 Feb 2023 03:33:41 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydd-007zgo-4c; Mon, 06 Feb 2023 18:22:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:17 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:17 +0800
Subject: [PATCH 3/17] fs: ecryptfs: Use crypto_wait_req
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
Message-Id: <E1pOydd-007zgo-4c@formenos.hmeau.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the custom crypto completion function with
crypto_req_done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 fs/ecryptfs/crypto.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index e3f5d7f3c8a0..c3057539f088 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -260,22 +260,6 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 	return i;
 }
 
-struct extent_crypt_result {
-	struct completion completion;
-	int rc;
-};
-
-static void extent_crypt_complete(struct crypto_async_request *req, int rc)
-{
-	struct extent_crypt_result *ecr = req->data;
-
-	if (rc == -EINPROGRESS)
-		return;
-
-	ecr->rc = rc;
-	complete(&ecr->completion);
-}
-
 /**
  * crypt_scatterlist
  * @crypt_stat: Pointer to the crypt_stat struct to initialize.
@@ -293,7 +277,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 			     unsigned char *iv, int op)
 {
 	struct skcipher_request *req = NULL;
-	struct extent_crypt_result ecr;
+	DECLARE_CRYPTO_WAIT(ecr);
 	int rc = 0;
 
 	if (unlikely(ecryptfs_verbosity > 0)) {
@@ -303,8 +287,6 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 				  crypt_stat->key_size);
 	}
 
-	init_completion(&ecr.completion);
-
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
 	req = skcipher_request_alloc(crypt_stat->tfm, GFP_NOFS);
 	if (!req) {
@@ -315,7 +297,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			extent_crypt_complete, &ecr);
+			crypto_req_done, &ecr);
 	/* Consider doing this once, when the file is opened */
 	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
 		rc = crypto_skcipher_setkey(crypt_stat->tfm, crypt_stat->key,
@@ -334,13 +316,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	skcipher_request_set_crypt(req, src_sg, dst_sg, size, iv);
 	rc = op == ENCRYPT ? crypto_skcipher_encrypt(req) :
 			     crypto_skcipher_decrypt(req);
-	if (rc == -EINPROGRESS || rc == -EBUSY) {
-		struct extent_crypt_result *ecr = req->base.data;
-
-		wait_for_completion(&ecr->completion);
-		rc = ecr->rc;
-		reinit_completion(&ecr->completion);
-	}
+	rc = crypto_wait_req(rc, &ecr);
 out:
 	skcipher_request_free(req);
 	return rc;
