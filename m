Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D13A5F2208
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJBIYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJBIYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDCF41D22
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 62BDF20539;
        Sun,  2 Oct 2022 10:24:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id x1391PdhKeXQ; Sun,  2 Oct 2022 10:24:00 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 448342053D;
        Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 35BE980004A;
        Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:23:59 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:23:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 305313182A31; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 16/24] xfrm: add extack to attach_*
Date:   Sun, 2 Oct 2022 10:17:04 +0200
Message-ID: <20221002081712.757515-17-steffen.klassert@secunet.com>
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
 net/xfrm/xfrm_user.c | 46 +++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index c56b9442dffe..2cf5956b562e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -366,7 +366,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 
 static int attach_one_algo(struct xfrm_algo **algpp, u8 *props,
 			   struct xfrm_algo_desc *(*get_byname)(const char *, int),
-			   struct nlattr *rta)
+			   struct nlattr *rta, struct netlink_ext_ack *extack)
 {
 	struct xfrm_algo *p, *ualg;
 	struct xfrm_algo_desc *algo;
@@ -377,8 +377,10 @@ static int attach_one_algo(struct xfrm_algo **algpp, u8 *props,
 	ualg = nla_data(rta);
 
 	algo = get_byname(ualg->alg_name, 1);
-	if (!algo)
+	if (!algo) {
+		NL_SET_ERR_MSG(extack, "Requested COMP algorithm not found");
 		return -ENOSYS;
+	}
 	*props = algo->desc.sadb_alg_id;
 
 	p = kmemdup(ualg, xfrm_alg_len(ualg), GFP_KERNEL);
@@ -390,7 +392,8 @@ static int attach_one_algo(struct xfrm_algo **algpp, u8 *props,
 	return 0;
 }
 
-static int attach_crypt(struct xfrm_state *x, struct nlattr *rta)
+static int attach_crypt(struct xfrm_state *x, struct nlattr *rta,
+			struct netlink_ext_ack *extack)
 {
 	struct xfrm_algo *p, *ualg;
 	struct xfrm_algo_desc *algo;
@@ -401,8 +404,10 @@ static int attach_crypt(struct xfrm_state *x, struct nlattr *rta)
 	ualg = nla_data(rta);
 
 	algo = xfrm_ealg_get_byname(ualg->alg_name, 1);
-	if (!algo)
+	if (!algo) {
+		NL_SET_ERR_MSG(extack, "Requested CRYPT algorithm not found");
 		return -ENOSYS;
+	}
 	x->props.ealgo = algo->desc.sadb_alg_id;
 
 	p = kmemdup(ualg, xfrm_alg_len(ualg), GFP_KERNEL);
@@ -416,7 +421,7 @@ static int attach_crypt(struct xfrm_state *x, struct nlattr *rta)
 }
 
 static int attach_auth(struct xfrm_algo_auth **algpp, u8 *props,
-		       struct nlattr *rta)
+		       struct nlattr *rta, struct netlink_ext_ack *extack)
 {
 	struct xfrm_algo *ualg;
 	struct xfrm_algo_auth *p;
@@ -428,8 +433,10 @@ static int attach_auth(struct xfrm_algo_auth **algpp, u8 *props,
 	ualg = nla_data(rta);
 
 	algo = xfrm_aalg_get_byname(ualg->alg_name, 1);
-	if (!algo)
+	if (!algo) {
+		NL_SET_ERR_MSG(extack, "Requested AUTH algorithm not found");
 		return -ENOSYS;
+	}
 	*props = algo->desc.sadb_alg_id;
 
 	p = kmalloc(sizeof(*p) + (ualg->alg_key_len + 7) / 8, GFP_KERNEL);
@@ -446,7 +453,7 @@ static int attach_auth(struct xfrm_algo_auth **algpp, u8 *props,
 }
 
 static int attach_auth_trunc(struct xfrm_algo_auth **algpp, u8 *props,
-			     struct nlattr *rta)
+			     struct nlattr *rta, struct netlink_ext_ack *extack)
 {
 	struct xfrm_algo_auth *p, *ualg;
 	struct xfrm_algo_desc *algo;
@@ -457,10 +464,14 @@ static int attach_auth_trunc(struct xfrm_algo_auth **algpp, u8 *props,
 	ualg = nla_data(rta);
 
 	algo = xfrm_aalg_get_byname(ualg->alg_name, 1);
-	if (!algo)
+	if (!algo) {
+		NL_SET_ERR_MSG(extack, "Requested AUTH_TRUNC algorithm not found");
 		return -ENOSYS;
-	if (ualg->alg_trunc_len > algo->uinfo.auth.icv_fullbits)
+	}
+	if (ualg->alg_trunc_len > algo->uinfo.auth.icv_fullbits) {
+		NL_SET_ERR_MSG(extack, "Invalid length requested for truncated ICV");
 		return -EINVAL;
+	}
 	*props = algo->desc.sadb_alg_id;
 
 	p = kmemdup(ualg, xfrm_alg_auth_len(ualg), GFP_KERNEL);
@@ -475,7 +486,8 @@ static int attach_auth_trunc(struct xfrm_algo_auth **algpp, u8 *props,
 	return 0;
 }
 
-static int attach_aead(struct xfrm_state *x, struct nlattr *rta)
+static int attach_aead(struct xfrm_state *x, struct nlattr *rta,
+		       struct netlink_ext_ack *extack)
 {
 	struct xfrm_algo_aead *p, *ualg;
 	struct xfrm_algo_desc *algo;
@@ -486,8 +498,10 @@ static int attach_aead(struct xfrm_state *x, struct nlattr *rta)
 	ualg = nla_data(rta);
 
 	algo = xfrm_aead_get_byname(ualg->alg_name, ualg->alg_icv_len, 1);
-	if (!algo)
+	if (!algo) {
+		NL_SET_ERR_MSG(extack, "Requested AEAD algorithm not found");
 		return -ENOSYS;
+	}
 	x->props.ealgo = algo->desc.sadb_alg_id;
 
 	p = kmemdup(ualg, aead_len(ualg), GFP_KERNEL);
@@ -680,21 +694,21 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	if (attrs[XFRMA_SA_EXTRA_FLAGS])
 		x->props.extra_flags = nla_get_u32(attrs[XFRMA_SA_EXTRA_FLAGS]);
 
-	if ((err = attach_aead(x, attrs[XFRMA_ALG_AEAD])))
+	if ((err = attach_aead(x, attrs[XFRMA_ALG_AEAD], extack)))
 		goto error;
 	if ((err = attach_auth_trunc(&x->aalg, &x->props.aalgo,
-				     attrs[XFRMA_ALG_AUTH_TRUNC])))
+				     attrs[XFRMA_ALG_AUTH_TRUNC], extack)))
 		goto error;
 	if (!x->props.aalgo) {
 		if ((err = attach_auth(&x->aalg, &x->props.aalgo,
-				       attrs[XFRMA_ALG_AUTH])))
+				       attrs[XFRMA_ALG_AUTH], extack)))
 			goto error;
 	}
-	if ((err = attach_crypt(x, attrs[XFRMA_ALG_CRYPT])))
+	if ((err = attach_crypt(x, attrs[XFRMA_ALG_CRYPT], extack)))
 		goto error;
 	if ((err = attach_one_algo(&x->calg, &x->props.calgo,
 				   xfrm_calg_get_byname,
-				   attrs[XFRMA_ALG_COMP])))
+				   attrs[XFRMA_ALG_COMP], extack)))
 		goto error;
 
 	if (attrs[XFRMA_TFCPAD])
-- 
2.25.1

