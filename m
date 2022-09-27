Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9555EC877
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiI0Psz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiI0Psc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:48:32 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6020EB07DE
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:46:12 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-XjOjD95PPBOtbuMY9Wvj3g-1; Tue, 27 Sep 2022 11:46:09 -0400
X-MC-Unique: XjOjD95PPBOtbuMY9Wvj3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47FA9185A794;
        Tue, 27 Sep 2022 15:46:09 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 627812166B2A;
        Tue, 27 Sep 2022 15:46:08 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/6] xfrm: ah: add extack to ah_init_state, ah6_init_state
Date:   Tue, 27 Sep 2022 17:45:30 +0200
Message-Id: <b450839cfaec7f0109418aee0cb02a4b9345f653.1664287440.git.sd@queasysnail.net>
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
 net/ipv4/ah4.c | 21 +++++++++++++--------
 net/ipv6/ah6.c | 21 ++++++++++++++-------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index babefff15de3..ee4e578c7f20 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -477,24 +477,32 @@ static int ah_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 	struct xfrm_algo_desc *aalg_desc;
 	struct crypto_ahash *ahash;
 
-	if (!x->aalg)
+	if (!x->aalg) {
+		NL_SET_ERR_MSG(extack, "AH requires a state with an AUTH algorithm");
 		goto error;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "AH is not compatible with encapsulation");
 		goto error;
+	}
 
 	ahp = kzalloc(sizeof(*ahp), GFP_KERNEL);
 	if (!ahp)
 		return -ENOMEM;
 
 	ahash = crypto_alloc_ahash(x->aalg->alg_name, 0, 0);
-	if (IS_ERR(ahash))
+	if (IS_ERR(ahash)) {
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
+	}
 
 	ahp->ahash = ahash;
 	if (crypto_ahash_setkey(ahash, x->aalg->alg_key,
-				(x->aalg->alg_key_len + 7) / 8))
+				(x->aalg->alg_key_len + 7) / 8)) {
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
+	}
 
 	/*
 	 * Lookup the algorithm description maintained by xfrm_algo,
@@ -507,10 +515,7 @@ static int ah_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 
 	if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
 	    crypto_ahash_digestsize(ahash)) {
-		pr_info("%s: %s digestsize %u != %u\n",
-			__func__, x->aalg->alg_name,
-			crypto_ahash_digestsize(ahash),
-			aalg_desc->uinfo.auth.icv_fullbits / 8);
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
 	}
 
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index f5bc0d4b37ad..5228d2716289 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -672,24 +672,32 @@ static int ah6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 	struct xfrm_algo_desc *aalg_desc;
 	struct crypto_ahash *ahash;
 
-	if (!x->aalg)
+	if (!x->aalg) {
+		NL_SET_ERR_MSG(extack, "AH requires a state with an AUTH algorithm");
 		goto error;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "AH is not compatible with encapsulation");
 		goto error;
+	}
 
 	ahp = kzalloc(sizeof(*ahp), GFP_KERNEL);
 	if (!ahp)
 		return -ENOMEM;
 
 	ahash = crypto_alloc_ahash(x->aalg->alg_name, 0, 0);
-	if (IS_ERR(ahash))
+	if (IS_ERR(ahash)) {
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
+	}
 
 	ahp->ahash = ahash;
 	if (crypto_ahash_setkey(ahash, x->aalg->alg_key,
-			       (x->aalg->alg_key_len + 7) / 8))
+			       (x->aalg->alg_key_len + 7) / 8)) {
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
+	}
 
 	/*
 	 * Lookup the algorithm description maintained by xfrm_algo,
@@ -702,9 +710,7 @@ static int ah6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 
 	if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
 	    crypto_ahash_digestsize(ahash)) {
-		pr_info("AH: %s digestsize %u != %u\n",
-			x->aalg->alg_name, crypto_ahash_digestsize(ahash),
-			aalg_desc->uinfo.auth.icv_fullbits/8);
+		NL_SET_ERR_MSG(extack, "Kernel was unable to initialize cryptographic operations");
 		goto error;
 	}
 
@@ -721,6 +727,7 @@ static int ah6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 		x->props.header_len += sizeof(struct ipv6hdr);
 		break;
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid mode requested for AH, must be one of TRANSPORT, TUNNEL, BEET");
 		goto error;
 	}
 	x->data = ahp;
-- 
2.37.3

