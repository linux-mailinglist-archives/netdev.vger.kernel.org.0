Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98C65F2204
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJBIYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJBIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:03 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D03D41D2F
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F09292056D;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G2eFmQe-pHOV; Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3BC9420539;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2A1A580004A;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:23:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:23:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 44FE23182A3F; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 21/24] xfrm: esp: add extack to esp_init_state, esp6_init_state
Date:   Sun, 2 Oct 2022 10:17:09 +0200
Message-ID: <20221002081712.757515-22-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c | 53 +++++++++++++++++++++++++++++--------------------
 net/ipv6/esp6.c | 53 +++++++++++++++++++++++++++++--------------------
 2 files changed, 64 insertions(+), 42 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index bc2b2c5717b5..751a05276f48 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1007,16 +1007,17 @@ static void esp_destroy(struct xfrm_state *x)
 	crypto_free_aead(aead);
 }
 
-static int esp_init_aead(struct xfrm_state *x)
+static int esp_init_aead(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	char aead_name[CRYPTO_MAX_ALG_NAME];
 	struct crypto_aead *aead;
 	int err;
 
-	err = -ENAMETOOLONG;
 	if (snprintf(aead_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
-		     x->geniv, x->aead->alg_name) >= CRYPTO_MAX_ALG_NAME)
-		goto error;
+		     x->geniv, x->aead->alg_name) >= CRYPTO_MAX_ALG_NAME) {
+		NL_SET_ERR_MSG(extack, "Algorithm name is too long");
+		return -ENAMETOOLONG;
+	}
 
 	aead = crypto_alloc_aead(aead_name, 0, 0);
 	err = PTR_ERR(aead);
@@ -1034,11 +1035,15 @@ static int esp_init_aead(struct xfrm_state *x)
 	if (err)
 		goto error;
 
+	return 0;
+
 error:
+	NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 	return err;
 }
 
-static int esp_init_authenc(struct xfrm_state *x)
+static int esp_init_authenc(struct xfrm_state *x,
+			    struct netlink_ext_ack *extack)
 {
 	struct crypto_aead *aead;
 	struct crypto_authenc_key_param *param;
@@ -1049,10 +1054,6 @@ static int esp_init_authenc(struct xfrm_state *x)
 	unsigned int keylen;
 	int err;
 
-	err = -EINVAL;
-	if (!x->ealg)
-		goto error;
-
 	err = -ENAMETOOLONG;
 
 	if ((x->props.flags & XFRM_STATE_ESN)) {
@@ -1061,22 +1062,28 @@ static int esp_init_authenc(struct xfrm_state *x)
 			     x->geniv ?: "", x->geniv ? "(" : "",
 			     x->aalg ? x->aalg->alg_name : "digest_null",
 			     x->ealg->alg_name,
-			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME)
+			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME) {
+			NL_SET_ERR_MSG(extack, "Algorithm name is too long");
 			goto error;
+		}
 	} else {
 		if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME,
 			     "%s%sauthenc(%s,%s)%s",
 			     x->geniv ?: "", x->geniv ? "(" : "",
 			     x->aalg ? x->aalg->alg_name : "digest_null",
 			     x->ealg->alg_name,
-			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME)
+			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME) {
+			NL_SET_ERR_MSG(extack, "Algorithm name is too long");
 			goto error;
+		}
 	}
 
 	aead = crypto_alloc_aead(authenc_name, 0, 0);
 	err = PTR_ERR(aead);
-	if (IS_ERR(aead))
+	if (IS_ERR(aead)) {
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
+	}
 
 	x->data = aead;
 
@@ -1106,17 +1113,16 @@ static int esp_init_authenc(struct xfrm_state *x)
 		err = -EINVAL;
 		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			pr_info("ESP: %s digestsize %u != %u\n",
-				x->aalg->alg_name,
-				crypto_aead_authsize(aead),
-				aalg_desc->uinfo.auth.icv_fullbits / 8);
+			NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 			goto free_key;
 		}
 
 		err = crypto_aead_setauthsize(
 			aead, x->aalg->alg_trunc_len / 8);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 			goto free_key;
+		}
 	}
 
 	param->enckeylen = cpu_to_be32((x->ealg->alg_key_len + 7) / 8);
@@ -1139,10 +1145,14 @@ static int esp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 
 	x->data = NULL;
 
-	if (x->aead)
-		err = esp_init_aead(x);
-	else
-		err = esp_init_authenc(x);
+	if (x->aead) {
+		err = esp_init_aead(x, extack);
+	} else if (x->ealg) {
+		err = esp_init_authenc(x, extack);
+	} else {
+		NL_SET_ERR_MSG(extack, "ESP: AEAD or CRYPT must be provided");
+		err = -EINVAL;
+	}
 
 	if (err)
 		goto error;
@@ -1160,6 +1170,7 @@ static int esp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 
 		switch (encap->encap_type) {
 		default:
+			NL_SET_ERR_MSG(extack, "Unsupported encapsulation type for ESP");
 			err = -EINVAL;
 			goto error;
 		case UDP_ENCAP_ESPINUDP:
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 2ca9b7b7e500..e7a16f9643e5 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -1050,16 +1050,17 @@ static void esp6_destroy(struct xfrm_state *x)
 	crypto_free_aead(aead);
 }
 
-static int esp_init_aead(struct xfrm_state *x)
+static int esp_init_aead(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	char aead_name[CRYPTO_MAX_ALG_NAME];
 	struct crypto_aead *aead;
 	int err;
 
-	err = -ENAMETOOLONG;
 	if (snprintf(aead_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
-		     x->geniv, x->aead->alg_name) >= CRYPTO_MAX_ALG_NAME)
-		goto error;
+		     x->geniv, x->aead->alg_name) >= CRYPTO_MAX_ALG_NAME) {
+		NL_SET_ERR_MSG(extack, "Algorithm name is too long");
+		return -ENAMETOOLONG;
+	}
 
 	aead = crypto_alloc_aead(aead_name, 0, 0);
 	err = PTR_ERR(aead);
@@ -1077,11 +1078,15 @@ static int esp_init_aead(struct xfrm_state *x)
 	if (err)
 		goto error;
 
+	return 0;
+
 error:
+	NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 	return err;
 }
 
-static int esp_init_authenc(struct xfrm_state *x)
+static int esp_init_authenc(struct xfrm_state *x,
+			    struct netlink_ext_ack *extack)
 {
 	struct crypto_aead *aead;
 	struct crypto_authenc_key_param *param;
@@ -1092,10 +1097,6 @@ static int esp_init_authenc(struct xfrm_state *x)
 	unsigned int keylen;
 	int err;
 
-	err = -EINVAL;
-	if (!x->ealg)
-		goto error;
-
 	err = -ENAMETOOLONG;
 
 	if ((x->props.flags & XFRM_STATE_ESN)) {
@@ -1104,22 +1105,28 @@ static int esp_init_authenc(struct xfrm_state *x)
 			     x->geniv ?: "", x->geniv ? "(" : "",
 			     x->aalg ? x->aalg->alg_name : "digest_null",
 			     x->ealg->alg_name,
-			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME)
+			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME) {
+			NL_SET_ERR_MSG(extack, "Algorithm name is too long");
 			goto error;
+		}
 	} else {
 		if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME,
 			     "%s%sauthenc(%s,%s)%s",
 			     x->geniv ?: "", x->geniv ? "(" : "",
 			     x->aalg ? x->aalg->alg_name : "digest_null",
 			     x->ealg->alg_name,
-			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME)
+			     x->geniv ? ")" : "") >= CRYPTO_MAX_ALG_NAME) {
+			NL_SET_ERR_MSG(extack, "Algorithm name is too long");
 			goto error;
+		}
 	}
 
 	aead = crypto_alloc_aead(authenc_name, 0, 0);
 	err = PTR_ERR(aead);
-	if (IS_ERR(aead))
+	if (IS_ERR(aead)) {
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
+	}
 
 	x->data = aead;
 
@@ -1149,17 +1156,16 @@ static int esp_init_authenc(struct xfrm_state *x)
 		err = -EINVAL;
 		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			pr_info("ESP: %s digestsize %u != %u\n",
-				x->aalg->alg_name,
-				crypto_aead_authsize(aead),
-				aalg_desc->uinfo.auth.icv_fullbits / 8);
+			NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 			goto free_key;
 		}
 
 		err = crypto_aead_setauthsize(
 			aead, x->aalg->alg_trunc_len / 8);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 			goto free_key;
+		}
 	}
 
 	param->enckeylen = cpu_to_be32((x->ealg->alg_key_len + 7) / 8);
@@ -1182,10 +1188,14 @@ static int esp6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 
 	x->data = NULL;
 
-	if (x->aead)
-		err = esp_init_aead(x);
-	else
-		err = esp_init_authenc(x);
+	if (x->aead) {
+		err = esp_init_aead(x, extack);
+	} else if (x->ealg) {
+		err = esp_init_authenc(x, extack);
+	} else {
+		NL_SET_ERR_MSG(extack, "ESP: AEAD or CRYPT must be provided");
+		err = -EINVAL;
+	}
 
 	if (err)
 		goto error;
@@ -1213,6 +1223,7 @@ static int esp6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 
 		switch (encap->encap_type) {
 		default:
+			NL_SET_ERR_MSG(extack, "Unsupported encapsulation type for ESP");
 			err = -EINVAL;
 			goto error;
 		case UDP_ENCAP_ESPINUDP:
-- 
2.25.1

