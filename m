Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9FF5B8DCF
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiINRFD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiINRE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:56 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358AF1E3C5
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:52 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-GXmiRYz0Piub49QWglb5Fw-1; Wed, 14 Sep 2022 13:04:48 -0400
X-MC-Unique: GXmiRYz0Piub49QWglb5Fw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D152862FDC;
        Wed, 14 Sep 2022 17:04:48 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4397A1121315;
        Wed, 14 Sep 2022 17:04:47 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 5/7] xfrm: add extack to attach_*
Date:   Wed, 14 Sep 2022 19:04:04 +0200
Message-Id: <0ea301f214b9310fa9bcca6cea64db7cf98336ff.1663103634.git.sd@queasysnail.net>
In-Reply-To: <cover.1663103634.git.sd@queasysnail.net>
References: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.37.3

