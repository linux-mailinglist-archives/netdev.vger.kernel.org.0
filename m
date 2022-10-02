Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7722C5F2211
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJBIeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJBIeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:34:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6D24CA01
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:34:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0C82920561;
        Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rTIhFTKBtf7D; Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6F7EA20519;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 5E43680004A;
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
        id 0E1E53182A1B; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/24] xfrm: add extack to verify_policy_type
Date:   Sun, 2 Oct 2022 10:16:57 +0200
Message-ID: <20221002081712.757515-10-steffen.klassert@secunet.com>
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
 net/xfrm/xfrm_user.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 0042b77337bd..0f2a2aa1e289 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1497,7 +1497,7 @@ static int verify_policy_dir(u8 dir, struct netlink_ext_ack *extack)
 	return 0;
 }
 
-static int verify_policy_type(u8 type)
+static int verify_policy_type(u8 type, struct netlink_ext_ack *extack)
 {
 	switch (type) {
 	case XFRM_POLICY_TYPE_MAIN:
@@ -1507,6 +1507,7 @@ static int verify_policy_type(u8 type)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy type");
 		return -EINVAL;
 	}
 
@@ -1688,7 +1689,8 @@ static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs)
 	return 0;
 }
 
-static int copy_from_user_policy_type(u8 *tp, struct nlattr **attrs)
+static int copy_from_user_policy_type(u8 *tp, struct nlattr **attrs,
+				      struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_POLICY_TYPE];
 	struct xfrm_userpolicy_type *upt;
@@ -1700,7 +1702,7 @@ static int copy_from_user_policy_type(u8 *tp, struct nlattr **attrs)
 		type = upt->type;
 	}
 
-	err = verify_policy_type(type);
+	err = verify_policy_type(type, extack);
 	if (err)
 		return err;
 
@@ -1735,7 +1737,11 @@ static void copy_to_user_policy(struct xfrm_policy *xp, struct xfrm_userpolicy_i
 	p->share = XFRM_SHARE_ANY; /* XXX xp->share */
 }
 
-static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_userpolicy_info *p, struct nlattr **attrs, int *errp)
+static struct xfrm_policy *xfrm_policy_construct(struct net *net,
+						 struct xfrm_userpolicy_info *p,
+						 struct nlattr **attrs,
+						 int *errp,
+						 struct netlink_ext_ack *extack)
 {
 	struct xfrm_policy *xp = xfrm_policy_alloc(net, GFP_KERNEL);
 	int err;
@@ -1747,7 +1753,7 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
 	copy_from_user_policy(xp, p);
 
-	err = copy_from_user_policy_type(&xp->type, attrs);
+	err = copy_from_user_policy_type(&xp->type, attrs, extack);
 	if (err)
 		goto error;
 
@@ -1787,7 +1793,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	xp = xfrm_policy_construct(net, p, attrs, &err);
+	xp = xfrm_policy_construct(net, p, attrs, &err, extack);
 	if (!xp)
 		return err;
 
@@ -2099,7 +2105,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	p = nlmsg_data(nlh);
 	delete = nlh->nlmsg_type == XFRM_MSG_DELPOLICY;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
@@ -2371,7 +2377,7 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
@@ -2404,7 +2410,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_mark m;
 	u32 if_id = 0;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
@@ -2521,7 +2527,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto free_state;
 
 	/*   build an XP */
-	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err);
+	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err, extack);
 	if (!xp)
 		goto free_state;
 
@@ -2617,7 +2623,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	kmp = attrs[XFRMA_KMADDRESS] ? &km : NULL;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
-- 
2.25.1

