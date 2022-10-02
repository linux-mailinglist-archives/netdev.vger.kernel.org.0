Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218F45F2210
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJBIeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJBIeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:34:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972B4CA05
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:34:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 201C620539;
        Sun,  2 Oct 2022 10:34:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PtMusBP4FL81; Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EEE712055E;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E0A1480004A;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:33:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:33:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 268F73182A2B; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 14/24] xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
Date:   Sun, 2 Oct 2022 10:17:02 +0200
Message-ID: <20221002081712.757515-15-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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
 net/xfrm/xfrm_user.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 048c1e150b4e..3c150e1f8a2a 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -35,7 +35,8 @@
 #endif
 #include <asm/unaligned.h>
 
-static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
+static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[type];
 	struct xfrm_algo *algp;
@@ -44,8 +45,10 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 		return 0;
 
 	algp = nla_data(rt);
-	if (nla_len(rt) < (int)xfrm_alg_len(algp))
+	if (nla_len(rt) < (int)xfrm_alg_len(algp)) {
+		NL_SET_ERR_MSG(extack, "Invalid AUTH/CRYPT/COMP attribute length");
 		return -EINVAL;
+	}
 
 	switch (type) {
 	case XFRMA_ALG_AUTH:
@@ -54,6 +57,7 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid algorithm attribute type");
 		return -EINVAL;
 	}
 
@@ -61,7 +65,8 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 	return 0;
 }
 
-static int verify_auth_trunc(struct nlattr **attrs)
+static int verify_auth_trunc(struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_ALG_AUTH_TRUNC];
 	struct xfrm_algo_auth *algp;
@@ -70,14 +75,16 @@ static int verify_auth_trunc(struct nlattr **attrs)
 		return 0;
 
 	algp = nla_data(rt);
-	if (nla_len(rt) < (int)xfrm_alg_auth_len(algp))
+	if (nla_len(rt) < (int)xfrm_alg_auth_len(algp)) {
+		NL_SET_ERR_MSG(extack, "Invalid AUTH_TRUNC attribute length");
 		return -EINVAL;
+	}
 
 	algp->alg_name[sizeof(algp->alg_name) - 1] = '\0';
 	return 0;
 }
 
-static int verify_aead(struct nlattr **attrs)
+static int verify_aead(struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_ALG_AEAD];
 	struct xfrm_algo_aead *algp;
@@ -86,8 +93,10 @@ static int verify_aead(struct nlattr **attrs)
 		return 0;
 
 	algp = nla_data(rt);
-	if (nla_len(rt) < (int)aead_len(algp))
+	if (nla_len(rt) < (int)aead_len(algp)) {
+		NL_SET_ERR_MSG(extack, "Invalid AEAD attribute length");
 		return -EINVAL;
+	}
 
 	algp->alg_name[sizeof(algp->alg_name) - 1] = '\0';
 	return 0;
@@ -313,15 +322,15 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	}
 
-	if ((err = verify_aead(attrs)))
+	if ((err = verify_aead(attrs, extack)))
 		goto out;
-	if ((err = verify_auth_trunc(attrs)))
+	if ((err = verify_auth_trunc(attrs, extack)))
 		goto out;
-	if ((err = verify_one_alg(attrs, XFRMA_ALG_AUTH)))
+	if ((err = verify_one_alg(attrs, XFRMA_ALG_AUTH, extack)))
 		goto out;
-	if ((err = verify_one_alg(attrs, XFRMA_ALG_CRYPT)))
+	if ((err = verify_one_alg(attrs, XFRMA_ALG_CRYPT, extack)))
 		goto out;
-	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP)))
+	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP, extack)))
 		goto out;
 	if ((err = verify_sec_ctx_len(attrs, extack)))
 		goto out;
-- 
2.25.1

