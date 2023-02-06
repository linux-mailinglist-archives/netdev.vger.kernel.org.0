Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1954968BB8C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjBFLdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBFLdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:14 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2FC13516;
        Mon,  6 Feb 2023 03:33:09 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydf-007zgz-7o; Mon, 06 Feb 2023 18:22:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:19 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:19 +0800
Subject: [PATCH 4/17] Bluetooth: Use crypto_wait_req
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
Message-Id: <E1pOydf-007zgz-7o@formenos.hmeau.com>
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

 net/bluetooth/ecdh_helper.c |   37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index 989401f116e9..0efc93fdae8a 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -25,22 +25,6 @@
 #include <linux/scatterlist.h>
 #include <crypto/ecdh.h>
 
-struct ecdh_completion {
-	struct completion completion;
-	int err;
-};
-
-static void ecdh_complete(struct crypto_async_request *req, int err)
-{
-	struct ecdh_completion *res = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	res->err = err;
-	complete(&res->completion);
-}
-
 static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
 {
 	int i;
@@ -60,9 +44,9 @@ static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
 int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 			u8 secret[32])
 {
+	DECLARE_CRYPTO_WAIT(result);
 	struct kpp_request *req;
 	u8 *tmp;
-	struct ecdh_completion result;
 	struct scatterlist src, dst;
 	int err;
 
@@ -76,8 +60,6 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 		goto free_tmp;
 	}
 
-	init_completion(&result.completion);
-
 	swap_digits((u64 *)public_key, (u64 *)tmp, 4); /* x */
 	swap_digits((u64 *)&public_key[32], (u64 *)&tmp[32], 4); /* y */
 
@@ -86,12 +68,9 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 	kpp_request_set_input(req, &src, 64);
 	kpp_request_set_output(req, &dst, 32);
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				 ecdh_complete, &result);
+				 crypto_req_done, &result);
 	err = crypto_kpp_compute_shared_secret(req);
-	if (err == -EINPROGRESS) {
-		wait_for_completion(&result.completion);
-		err = result.err;
-	}
+	err = crypto_wait_req(err, &result);
 	if (err < 0) {
 		pr_err("alg: ecdh: compute shared secret failed. err %d\n",
 		       err);
@@ -165,9 +144,9 @@ int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
  */
 int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64])
 {
+	DECLARE_CRYPTO_WAIT(result);
 	struct kpp_request *req;
 	u8 *tmp;
-	struct ecdh_completion result;
 	struct scatterlist dst;
 	int err;
 
@@ -181,18 +160,14 @@ int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64])
 		goto free_tmp;
 	}
 
-	init_completion(&result.completion);
 	sg_init_one(&dst, tmp, 64);
 	kpp_request_set_input(req, NULL, 0);
 	kpp_request_set_output(req, &dst, 64);
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				 ecdh_complete, &result);
+				 crypto_req_done, &result);
 
 	err = crypto_kpp_generate_public_key(req);
-	if (err == -EINPROGRESS) {
-		wait_for_completion(&result.completion);
-		err = result.err;
-	}
+	err = crypto_wait_req(err, &result);
 	if (err < 0)
 		goto free_all;
 
