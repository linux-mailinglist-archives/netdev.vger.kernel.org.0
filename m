Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AD668BBA7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjBFLeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjBFLdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:43 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119921EBF7;
        Mon,  6 Feb 2023 03:33:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydp-007ziH-Oe; Mon, 06 Feb 2023 18:22:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:29 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:29 +0800
Subject: [PATCH 9/17] KEYS: DH: Use crypto_wait_req
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
Message-Id: <E1pOydp-007ziH-Oe@formenos.hmeau.com>
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

 security/keys/dh.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index b339760a31dd..da64c358474b 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -64,22 +64,6 @@ static void dh_free_data(struct dh *dh)
 	kfree_sensitive(dh->g);
 }
 
-struct dh_completion {
-	struct completion completion;
-	int err;
-};
-
-static void dh_crypto_done(struct crypto_async_request *req, int err)
-{
-	struct dh_completion *compl = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	compl->err = err;
-	complete(&compl->completion);
-}
-
 static int kdf_alloc(struct crypto_shash **hash, char *hashname)
 {
 	struct crypto_shash *tfm;
@@ -146,7 +130,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	struct keyctl_dh_params pcopy;
 	struct dh dh_inputs;
 	struct scatterlist outsg;
-	struct dh_completion compl;
+	DECLARE_CRYPTO_WAIT(compl);
 	struct crypto_kpp *tfm;
 	struct kpp_request *req;
 	uint8_t *secret;
@@ -266,22 +250,18 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 
 	kpp_request_set_input(req, NULL, 0);
 	kpp_request_set_output(req, &outsg, outlen);
-	init_completion(&compl.completion);
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				 CRYPTO_TFM_REQ_MAY_SLEEP,
-				 dh_crypto_done, &compl);
+				 crypto_req_done, &compl);
 
 	/*
 	 * For DH, generate_public_key and generate_shared_secret are
 	 * the same calculation
 	 */
 	ret = crypto_kpp_generate_public_key(req);
-	if (ret == -EINPROGRESS) {
-		wait_for_completion(&compl.completion);
-		ret = compl.err;
-		if (ret)
-			goto out6;
-	}
+	ret = crypto_wait_req(ret, &compl);
+	if (ret)
+		goto out6;
 
 	if (kdfcopy) {
 		/*
