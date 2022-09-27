Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0745F5EC881
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiI0PtA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 11:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiI0Pse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:48:34 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA8FB2778
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:46:13 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-gdsvTEbkMBGSVtQYyUF0MQ-1; Tue, 27 Sep 2022 11:46:10 -0400
X-MC-Unique: gdsvTEbkMBGSVtQYyUF0MQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A5BF101A52A;
        Tue, 27 Sep 2022 15:46:10 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B5362166B26;
        Tue, 27 Sep 2022 15:46:09 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/6] xfrm: esp: add extack to esp_init_state, esp6_init_state
Date:   Tue, 27 Sep 2022 17:45:31 +0200
Message-Id: <bea5bfb4b893a47ff3e4464f09bbd68c164b3797.1664287440.git.sd@queasysnail.net>
In-Reply-To: <cover.1664287440.git.sd@queasysnail.net>
References: <cover.1664287440.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.37.3

