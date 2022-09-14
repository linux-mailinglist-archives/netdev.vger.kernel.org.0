Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8ED5B8DCA
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiINRE4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiINREx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:53 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E422312D25
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:49 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-XJeNPX9gOaO5XTYMHOCImQ-1; Wed, 14 Sep 2022 13:04:45 -0400
X-MC-Unique: XJeNPX9gOaO5XTYMHOCImQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FD8D85A59D;
        Wed, 14 Sep 2022 17:04:45 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 826811121314;
        Wed, 14 Sep 2022 17:04:44 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/7] xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
Date:   Wed, 14 Sep 2022 19:04:02 +0200
Message-Id: <7fd9b7ecd81f5f22bb8f2574e4807f34f113eed6.1663103634.git.sd@queasysnail.net>
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
2.37.3

