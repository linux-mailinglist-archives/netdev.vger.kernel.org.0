Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2774B5A662D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiH3OXv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 10:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiH3OXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:23:47 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD5CB69C1
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:23:44 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-e1qJOiHBMxeuR0P1fA0mUQ-1; Tue, 30 Aug 2022 10:23:40 -0400
X-MC-Unique: e1qJOiHBMxeuR0P1fA0mUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FA26380452D;
        Tue, 30 Aug 2022 14:23:40 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47F3B4010D42;
        Tue, 30 Aug 2022 14:23:39 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 4/6] xfrm: add extack to verify_policy_type
Date:   Tue, 30 Aug 2022 16:23:10 +0200
Message-Id: <5757e5fe510d278358320605b9298c4a95b697d4.1661162395.git.sd@queasysnail.net>
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
2.37.2

