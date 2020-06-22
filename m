Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041CD203247
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFVIkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgFVIkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 04:40:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6881C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 01:40:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g12so7275428pll.10
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 01:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AyxQeC7+6hNTAAWq0x7WjVMU9DPaS1YaxTTs8F/Iaeg=;
        b=eSvXVoi0IEvF7pG5vPeNZdtGzD2aNNBWVeFn7FGMSNKQRgLVEo1BnYMJiW0bU0pWnI
         H9U95zVR52X1De0/QyELVzwZZDUrbiOE2pR7QpgUNPeSUySK5xo6c4drunDk5fnTSF/A
         Utwkqy1OO3ZTMclmMH1CFm+uGIPRQnXjXEVOL3V2msDUh41DRSg/1AsxsXGCg8wavnhx
         s3qfNT6GH4JZysp+7RuKZ54+7MZZw4yZ5amt3FRQkllCeIzy9yfauZICcBaNFpC51twr
         adcfHU8fO3XaPrf5riybxbz/KLs/zlUDU+WewhAq3HZnrOdf/ao1dwWG/lMq0Vc1cexO
         gBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AyxQeC7+6hNTAAWq0x7WjVMU9DPaS1YaxTTs8F/Iaeg=;
        b=J1wWmzhtyibEM1Fgym4uLaKCgYWOe3EacKFONrqjinYCzr9ozgSiTwcYdjHS54xOUm
         T4+OywsObf4QNjHe0Alqvvk9nFCbewfPIMkfpv1Hd1A5OUi2iI8S+PSiGwxQh+NRQVru
         VdkNRyQF/djqrrvi3StZhlSZabfvCKAdaaDtmUZy7jzCs8DzXb/YVGfyEhOsME16hOhM
         I2/N53xf91iUhUCruJS0pY0vUXEqtHCPPP4p4IpbHZDvQMYVIKRsGztVyGvlir/YBDzZ
         pTtE4NUxvbOvktt4AAv/HIB0zCVp1V2coDT4nQhj4uvb6/2pFQSemWhMFnzVcRaBQf52
         B03g==
X-Gm-Message-State: AOAM530up6SwYEt8KSvNX4qu5kaasvdk/DZVRA2tnuhxlcoXDrgYhs9f
        FRsHvgMJ/7Yo0mjJouskKjqWxgPUFGE=
X-Google-Smtp-Source: ABdhPJzqapBwkV0tJbKdEzTpDoxrwG7rQwOR6ECUIgxhkI+4DjB4qq1fbOgD5vwsP3zE0xoR1AZ3bA==
X-Received: by 2002:a17:902:c082:: with SMTP id j2mr18515121pld.70.1592815237807;
        Mon, 22 Jun 2020 01:40:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3sm10704201pgk.67.2020.06.22.01.40.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 01:40:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Tobias Brunner <tobias@strongswan.org>
Subject: [PATCHv2 ipsec] xfrm: policy: match with both mark and mask on user interfaces
Date:   Mon, 22 Jun 2020 16:40:29 +0800
Message-Id: <e1e4d8b9fe775a7811afdbe0509d54286cf017e9.1592815229.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
it would take 'priority' to make a policy unique, and allow duplicated
policies with different 'priority' to be added, which is not expected
by userland, as Tobias reported in strongswan.

To fix this duplicated policies issue, and also fix the issue in
commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
when doing add/del/get/update on user interfaces, this patch is to change
to look up a policy with both mark and mask by doing:

  mark.v == pol->mark.v && mark.m == pol->mark.m

and leave the check:

  (mark & pol->mark.m) == pol->mark.v

for tx/rx path only.

As the userland expects an exact mark and mask match to manage policies.

v1->v2:
  - make xfrm_policy_mark_match inline and fix the changelog as
    Tobias suggested.

Fixes: 295fae568885 ("xfrm: Allow user space manipulation of SPD mark")
Fixes: ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h     | 11 +++++++----
 net/key/af_key.c       |  4 ++--
 net/xfrm/xfrm_policy.c | 39 ++++++++++++++++-----------------------
 net/xfrm/xfrm_user.c   | 18 +++++++++++-------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c7d213c..5c20953 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1630,13 +1630,16 @@ int xfrm_policy_walk(struct net *net, struct xfrm_policy_walk *walk,
 		     void *);
 void xfrm_policy_walk_done(struct xfrm_policy_walk *walk, struct net *net);
 int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl);
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u32 if_id,
-					  u8 type, int dir,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net,
+					  const struct xfrm_mark *mark,
+					  u32 if_id, u8 type, int dir,
 					  struct xfrm_selector *sel,
 					  struct xfrm_sec_ctx *ctx, int delete,
 					  int *err);
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id, u8,
-				     int dir, u32 id, int delete, int *err);
+struct xfrm_policy *xfrm_policy_byid(struct net *net,
+				     const struct xfrm_mark *mark, u32 if_id,
+				     u8 type, int dir, u32 id, int delete,
+				     int *err);
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid);
 void xfrm_policy_hash_rebuild(struct net *net);
 u32 xfrm_get_acqseq(void);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index b67ed3a..979c579 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2400,7 +2400,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, const struct sa
 			return err;
 	}
 
-	xp = xfrm_policy_bysel_ctx(net, DUMMY_MARK, 0, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_bysel_ctx(net, &dummy_mark, 0, XFRM_POLICY_TYPE_MAIN,
 				   pol->sadb_x_policy_dir - 1, &sel, pol_ctx,
 				   1, &err);
 	security_xfrm_policy_free(pol_ctx);
@@ -2651,7 +2651,7 @@ static int pfkey_spdget(struct sock *sk, struct sk_buff *skb, const struct sadb_
 		return -EINVAL;
 
 	delete = (hdr->sadb_msg_type == SADB_X_SPDDELETE2);
-	xp = xfrm_policy_byid(net, DUMMY_MARK, 0, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_byid(net, &dummy_mark, 0, XFRM_POLICY_TYPE_MAIN,
 			      dir, pol->sadb_x_policy_id, delete, &err);
 	if (xp == NULL)
 		return -ENOENT;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 564aa649..6847b35 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1433,14 +1433,10 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
 	spin_unlock_bh(&pq->hold_queue.lock);
 }
 
-static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
-				   struct xfrm_policy *pol)
+static inline bool xfrm_policy_mark_match(const struct xfrm_mark *mark,
+					  struct xfrm_policy *pol)
 {
-	if (policy->mark.v == pol->mark.v &&
-	    policy->priority == pol->priority)
-		return true;
-
-	return false;
+	return mark->v == pol->mark.v && mark->m == pol->mark.m;
 }
 
 static u32 xfrm_pol_bin_key(const void *data, u32 len, u32 seed)
@@ -1503,7 +1499,7 @@ static void xfrm_policy_insert_inexact_list(struct hlist_head *chain,
 		if (pol->type == policy->type &&
 		    pol->if_id == policy->if_id &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			delpol = pol;
@@ -1538,7 +1534,7 @@ static struct xfrm_policy *xfrm_policy_insert_list(struct hlist_head *chain,
 		if (pol->type == policy->type &&
 		    pol->if_id == policy->if_id &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			if (excl)
@@ -1610,9 +1606,8 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 EXPORT_SYMBOL(xfrm_policy_insert);
 
 static struct xfrm_policy *
-__xfrm_policy_bysel_ctx(struct hlist_head *chain, u32 mark, u32 if_id,
-			u8 type, int dir,
-			struct xfrm_selector *sel,
+__xfrm_policy_bysel_ctx(struct hlist_head *chain, const struct xfrm_mark *mark,
+			u32 if_id, u8 type, int dir, struct xfrm_selector *sel,
 			struct xfrm_sec_ctx *ctx)
 {
 	struct xfrm_policy *pol;
@@ -1623,7 +1618,7 @@ __xfrm_policy_bysel_ctx(struct hlist_head *chain, u32 mark, u32 if_id,
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == type &&
 		    pol->if_id == if_id &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    xfrm_policy_mark_match(mark, pol) &&
 		    !selector_cmp(sel, &pol->selector) &&
 		    xfrm_sec_ctx_match(ctx, pol->security))
 			return pol;
@@ -1632,11 +1627,10 @@ __xfrm_policy_bysel_ctx(struct hlist_head *chain, u32 mark, u32 if_id,
 	return NULL;
 }
 
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u32 if_id,
-					  u8 type, int dir,
-					  struct xfrm_selector *sel,
-					  struct xfrm_sec_ctx *ctx, int delete,
-					  int *err)
+struct xfrm_policy *
+xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark, u32 if_id,
+		      u8 type, int dir, struct xfrm_selector *sel,
+		      struct xfrm_sec_ctx *ctx, int delete, int *err)
 {
 	struct xfrm_pol_inexact_bin *bin = NULL;
 	struct xfrm_policy *pol, *ret = NULL;
@@ -1703,9 +1697,9 @@ struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u32 if_id,
 }
 EXPORT_SYMBOL(xfrm_policy_bysel_ctx);
 
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id,
-				     u8 type, int dir, u32 id, int delete,
-				     int *err)
+struct xfrm_policy *
+xfrm_policy_byid(struct net *net, const struct xfrm_mark *mark, u32 if_id,
+		 u8 type, int dir, u32 id, int delete, int *err)
 {
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
@@ -1720,8 +1714,7 @@ struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id,
 	ret = NULL;
 	hlist_for_each_entry(pol, chain, byidx) {
 		if (pol->type == type && pol->index == id &&
-		    pol->if_id == if_id &&
-		    (mark & pol->mark.m) == pol->mark.v) {
+		    pol->if_id == if_id && xfrm_policy_mark_match(mark, pol)) {
 			xfrm_pol_hold(pol);
 			if (delete) {
 				*err = security_xfrm_policy_delete(
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e6cfaa6..fbb7d9d0 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1863,7 +1863,6 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct km_event c;
 	int delete;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 	u32 if_id = 0;
 
 	p = nlmsg_data(nlh);
@@ -1880,8 +1879,11 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
+	xfrm_mark_get(attrs, &m);
+
 	if (p->index)
-		xp = xfrm_policy_byid(net, mark, if_id, type, p->dir, p->index, delete, &err);
+		xp = xfrm_policy_byid(net, &m, if_id, type, p->dir,
+				      p->index, delete, &err);
 	else {
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
@@ -1898,8 +1900,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, if_id, type, p->dir, &p->sel,
-					   ctx, delete, &err);
+		xp = xfrm_policy_bysel_ctx(net, &m, if_id, type, p->dir,
+					   &p->sel, ctx, delete, &err);
 		security_xfrm_policy_free(ctx);
 	}
 	if (xp == NULL)
@@ -2166,7 +2168,6 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err = -ENOENT;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 	u32 if_id = 0;
 
 	err = copy_from_user_policy_type(&type, attrs);
@@ -2180,8 +2181,11 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
+	xfrm_mark_get(attrs, &m);
+
 	if (p->index)
-		xp = xfrm_policy_byid(net, mark, if_id, type, p->dir, p->index, 0, &err);
+		xp = xfrm_policy_byid(net, &m, if_id, type, p->dir, p->index,
+				      0, &err);
 	else {
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
@@ -2198,7 +2202,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, if_id, type, p->dir,
+		xp = xfrm_policy_bysel_ctx(net, &m, if_id, type, p->dir,
 					   &p->sel, ctx, 0, &err);
 		security_xfrm_policy_free(ctx);
 	}
-- 
2.1.0

