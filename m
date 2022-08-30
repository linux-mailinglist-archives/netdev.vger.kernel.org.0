Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389D65A6630
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiH3OYA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 10:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiH3OXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:23:50 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507DDF8249
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:23:48 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-BcsVEOvLNLi5CaMoJIYAjw-1; Tue, 30 Aug 2022 10:23:43 -0400
X-MC-Unique: BcsVEOvLNLi5CaMoJIYAjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB774101E989;
        Tue, 30 Aug 2022 14:23:42 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB1524010FA1;
        Tue, 30 Aug 2022 14:23:41 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 6/6] xfrm: add extack to verify_sec_ctx_len
Date:   Tue, 30 Aug 2022 16:23:12 +0200
Message-Id: <8321c2da6fce07658c226dc473b17b6b17f3f676.1661162395.git.sd@queasysnail.net>
In-Reply-To: <cover.1661162395.git.sd@queasysnail.net>
References: <cover.1661162395.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 net/xfrm/xfrm_user.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 9fd30914f1ff..772a051feedb 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -102,7 +102,7 @@ static void verify_one_addr(struct nlattr **attrs, enum xfrm_attr_type_t type,
 		*addrp = nla_data(rt);
 }
 
-static inline int verify_sec_ctx_len(struct nlattr **attrs)
+static inline int verify_sec_ctx_len(struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 	struct xfrm_user_sec_ctx *uctx;
@@ -112,8 +112,10 @@ static inline int verify_sec_ctx_len(struct nlattr **attrs)
 
 	uctx = nla_data(rt);
 	if (uctx->len > nla_len(rt) ||
-	    uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len))
+	    uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len)) {
+		NL_SET_ERR_MSG(extack, "Invalid security context length");
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -264,7 +266,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP)))
 		goto out;
-	if ((err = verify_sec_ctx_len(attrs)))
+	if ((err = verify_sec_ctx_len(attrs, NULL)))
 		goto out;
 	if ((err = verify_replay(p, attrs)))
 		goto out;
@@ -1800,7 +1802,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(p, extack);
 	if (err)
 		return err;
-	err = verify_sec_ctx_len(attrs);
+	err = verify_sec_ctx_len(attrs, extack);
 	if (err)
 		return err;
 
@@ -2136,7 +2138,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
 
-		err = verify_sec_ctx_len(attrs);
+		err = verify_sec_ctx_len(attrs, extack);
 		if (err)
 			return err;
 
@@ -2441,7 +2443,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
 
-		err = verify_sec_ctx_len(attrs);
+		err = verify_sec_ctx_len(attrs, extack);
 		if (err)
 			return err;
 
@@ -2533,7 +2535,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(&ua->policy, extack);
 	if (err)
 		goto free_state;
-	err = verify_sec_ctx_len(attrs);
+	err = verify_sec_ctx_len(attrs, extack);
 	if (err)
 		goto free_state;
 
-- 
2.37.2

