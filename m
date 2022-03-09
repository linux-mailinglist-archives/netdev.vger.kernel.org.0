Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85CF4D34C1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiCIQ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbiCIQZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:25:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489B71520E3;
        Wed,  9 Mar 2022 08:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2EE06194A;
        Wed,  9 Mar 2022 16:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6ABC340EC;
        Wed,  9 Mar 2022 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842925;
        bh=ZiVX5ZSqfRDgUmK73Fp+fOWJp8vV4A0a8UtWw7AE76E=;
        h=From:To:Cc:Subject:Date:From;
        b=iW2CPLHbbqVjD5BHToSXDE8MBBzwA9sfKgYx2zykSDYp8Pwk/YWUDzqM0EitS8Krw
         Rwgxg6D57coNOdebP8UZiBqG/yYmGh0drtNXJc/N1Qfvi2KuVLDQSSkosi+ZsrQeqF
         hcazYsZ4gAJ0gtc9DyCD/+rWDDxHBPILy23+cbXgfCSC3MJmWNpI6jN5/V3kc7umgG
         fVDzDiQBCIcCvigcxvzlhSLu5/CiP0FDWb/V+TKLrfdvUTldePRnPtMemMcG269WwO
         AoOC0OGjEmyQdUEBDnE7nSzKppwHC3taernY+eICxi8In5ag6+m23MtnY9y6J0B1Ra
         WgXH9dDgPOysg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Yan <evitayan@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/20] xfrm: Check if_id in xfrm_migrate
Date:   Wed,  9 Mar 2022 11:21:39 -0500
Message-Id: <20220309162158.136467-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yan Yan <evitayan@google.com>

[ Upstream commit c1aca3080e382886e2e58e809787441984a2f89b ]

This patch enables distinguishing SAs and SPs based on if_id during
the xfrm_migrate flow. This ensures support for xfrm interfaces
throughout the SA/SP lifecycle.

When there are multiple existing SPs with the same direction,
the same xfrm_selector and different endpoint addresses,
xfrm_migrate might fail with ENODATA.

Specifically, the code path for performing xfrm_migrate is:
  Stage 1: find policy to migrate with
    xfrm_migrate_policy_find(sel, dir, type, net)
  Stage 2: find and update state(s) with
    xfrm_migrate_state_find(mp, net)
  Stage 3: update endpoint address(es) of template(s) with
    xfrm_policy_migrate(pol, m, num_migrate)

Currently "Stage 1" always returns the first xfrm_policy that
matches, and "Stage 3" looks for the xfrm_tmpl that matches the
old endpoint address. Thus if there are multiple xfrm_policy
with same selector, direction, type and net, "Stage 1" might
rertun a wrong xfrm_policy and "Stage 3" will fail with ENODATA
because it cannot find a xfrm_tmpl with the matching endpoint
address.

The fix is to allow userspace to pass an if_id and add if_id
to the matching rule in Stage 1 and Stage 2 since if_id is a
unique ID for xfrm_policy and xfrm_state. For compatibility,
if_id will only be checked if the attribute is set.

Tested with additions to Android's kernel unit test suite:
https://android-review.googlesource.com/c/kernel/tests/+/1668886

Signed-off-by: Yan Yan <evitayan@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     |  5 +++--
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  |  7 ++++++-
 net/xfrm/xfrm_user.c   |  6 +++++-
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4a2843441caf..0049a7459649 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1668,14 +1668,15 @@ int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	       const struct xfrm_migrate *m, int num_bundles,
 	       const struct xfrm_kmaddress *k,
 	       const struct xfrm_encap_tmpl *encap);
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net);
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id);
 struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 				      struct xfrm_migrate *m,
 				      struct xfrm_encap_tmpl *encap);
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_bundles,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap);
+		 struct xfrm_encap_tmpl *encap, u32 if_id);
 #endif
 
 int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index ef9b4ac03e7b..d1364b858fdf 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2627,7 +2627,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	}
 
 	return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
-			    kma ? &k : NULL, net, NULL);
+			    kma ? &k : NULL, net, NULL, 0);
 
  out:
 	return err;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c4a195cb3681..3d0ffd927004 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4287,7 +4287,7 @@ static bool xfrm_migrate_selector_match(const struct xfrm_selector *sel_cmp,
 }
 
 static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *sel,
-						    u8 dir, u8 type, struct net *net)
+						    u8 dir, u8 type, struct net *net, u32 if_id)
 {
 	struct xfrm_policy *pol, *ret = NULL;
 	struct hlist_head *chain;
@@ -4296,7 +4296,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_direct(net, &sel->daddr, &sel->saddr, sel->family, dir);
 	hlist_for_each_entry(pol, chain, bydst) {
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			priority = ret->priority;
@@ -4308,7 +4309,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 		if ((pol->priority >= priority) && ret)
 			break;
 
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			break;
@@ -4424,7 +4426,7 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_migrate,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap)
+		 struct xfrm_encap_tmpl *encap, u32 if_id)
 {
 	int i, err, nx_cur = 0, nx_new = 0;
 	struct xfrm_policy *pol = NULL;
@@ -4443,14 +4445,14 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 1 - find policy */
-	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net)) == NULL) {
+	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id)) == NULL) {
 		err = -ENOENT;
 		goto out;
 	}
 
 	/* Stage 2 - find and update state(s) */
 	for (i = 0, mp = m; i < num_migrate; i++, mp++) {
-		if ((x = xfrm_migrate_state_find(mp, net))) {
+		if ((x = xfrm_migrate_state_find(mp, net, if_id))) {
 			x_cur[nx_cur] = x;
 			nx_cur++;
 			xc = xfrm_state_migrate(x, mp, encap);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f5b846a2edcd..37fe22b2e843 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1569,7 +1569,8 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	return NULL;
 }
 
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net)
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id)
 {
 	unsigned int h;
 	struct xfrm_state *x = NULL;
@@ -1585,6 +1586,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 				continue;
 			if (m->reqid && x->props.reqid != m->reqid)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
@@ -1600,6 +1603,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d0fdfbf4c5f7..a535def86c52 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2451,6 +2451,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int n = 0;
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_encap_tmpl  *encap = NULL;
+	u32 if_id = 0;
 
 	if (attrs[XFRMA_MIGRATE] == NULL)
 		return -EINVAL;
@@ -2475,7 +2476,10 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return 0;
 	}
 
-	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap);
+	if (attrs[XFRMA_IF_ID])
+		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+
+	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap, if_id);
 
 	kfree(encap);
 
-- 
2.34.1

