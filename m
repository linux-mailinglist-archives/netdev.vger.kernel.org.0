Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F2B44D64B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhKKMGP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 07:06:15 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:27924 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233180AbhKKMGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:06:14 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-dm06Z1YkNYukMrFV4gQuDg-1; Thu, 11 Nov 2021 07:03:08 -0500
X-MC-Unique: dm06Z1YkNYukMrFV4gQuDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79EBD1923762;
        Thu, 11 Nov 2021 12:03:07 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA4BC1017CE3;
        Thu, 11 Nov 2021 12:03:06 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [RFC PATCH ipsec-next 5/6] xfrm: add extack to verify_policy_type
Date:   Thu, 11 Nov 2021 13:02:46 +0100
Message-Id: <365dd12f2a79988ad82f77e9bd2ab31022d46d1f.1636450303.git.sd@queasysnail.net>
In-Reply-To: <cover.1636450303.git.sd@queasysnail.net>
References: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 1cd3e1e316da..06735eb07a7d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1482,7 +1482,7 @@ static int verify_policy_dir(u8 dir, struct netlink_ext_ack *extack)
 	return 0;
 }
 
-static int verify_policy_type(u8 type)
+static int verify_policy_type(u8 type, struct netlink_ext_ack *extack)
 {
 	switch (type) {
 	case XFRM_POLICY_TYPE_MAIN:
@@ -1492,6 +1492,7 @@ static int verify_policy_type(u8 type)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy type");
 		return -EINVAL;
 	}
 
@@ -1684,7 +1685,8 @@ static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs,
 	return 0;
 }
 
-static int copy_from_user_policy_type(u8 *tp, struct nlattr **attrs)
+static int copy_from_user_policy_type(u8 *tp, struct nlattr **attrs,
+				      struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_POLICY_TYPE];
 	struct xfrm_userpolicy_type *upt;
@@ -1696,7 +1698,7 @@ static int copy_from_user_policy_type(u8 *tp, struct nlattr **attrs)
 		type = upt->type;
 	}
 
-	err = verify_policy_type(type);
+	err = verify_policy_type(type, extack);
 	if (err)
 		return err;
 
@@ -1731,7 +1733,11 @@ static void copy_to_user_policy(struct xfrm_policy *xp, struct xfrm_userpolicy_i
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
@@ -1743,7 +1749,7 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
 	copy_from_user_policy(xp, p);
 
-	err = copy_from_user_policy_type(&xp->type, attrs);
+	err = copy_from_user_policy_type(&xp->type, attrs, extack);
 	if (err)
 		goto error;
 
@@ -1783,7 +1789,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	xp = xfrm_policy_construct(net, p, attrs, &err);
+	xp = xfrm_policy_construct(net, p, attrs, &err, extack);
 	if (!xp)
 		return err;
 
@@ -2059,7 +2065,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	p = nlmsg_data(nlh);
 	delete = nlh->nlmsg_type == XFRM_MSG_DELPOLICY;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
@@ -2331,7 +2337,7 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
@@ -2364,7 +2370,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_mark m;
 	u32 if_id = 0;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
@@ -2481,7 +2487,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto free_state;
 
 	/*   build an XP */
-	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err);
+	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err, extack);
 	if (!xp)
 		goto free_state;
 
@@ -2576,7 +2582,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	kmp = attrs[XFRMA_KMADDRESS] ? &km : NULL;
 
-	err = copy_from_user_policy_type(&type, attrs);
+	err = copy_from_user_policy_type(&type, attrs, extack);
 	if (err)
 		return err;
 
-- 
2.33.1

