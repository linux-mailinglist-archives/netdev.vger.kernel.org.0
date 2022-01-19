Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B6A493186
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350313AbiASAA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350315AbiASAAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:00:25 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F47DC06161C
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:00:25 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b61-20020a25a243000000b006126ea65191so1315415ybi.19
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e5iuwCS5o5hvhvHLV2qnLv3xOubQ/ccZCT9hUXZcbmE=;
        b=R6Ckw40nty68aXcfD+UapBD9z2eC06U75tQtbJEJqr7OIt0cbCAUL9jURjlO/eGIQC
         mS0DhK9+cq44X05DVGZ0fFxjEzRkP6vcFSL7/883Nn4gk+u/DUGP37FVwHmOnFYey6/Z
         FkMiesgWkm2mM0MAugYpQ25qy0vJIQ8Ck8K5Kjv/NbkuT3uSYpiZbF43wXDds1A/YtT5
         LFlxDho+SIoMtH62CB6AX2LKdTBonYbjt7jcp5bkVJrrKlrutZf6NeLJvUmi1hReIfrO
         wWUn5VCa/L0G2An8rzSDsAYr/foqInE71NeYifRMsnLJMtySipeJg6biiH3BolIvFMUT
         B83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e5iuwCS5o5hvhvHLV2qnLv3xOubQ/ccZCT9hUXZcbmE=;
        b=Pu6B6pPqElvIURmXB6pObEMZYjMCtdxWwwAudTisZcZgmt4/eW2jNwp5cx0R/6vdeg
         xttT61GZplj6S0mSBJtGUfxrw/zcf9fWz1JNzapwjBKKs3YlYyrOAM18vgLaral9MEXZ
         vDRaCIKfN6URwK2KZClpun27baotCIT8jo4CxqcIZyi/3UAg59Dxownu6FhBpmwYpzfa
         MD9XpKFErufBhnEgVzl7loTmuL9QRvybQVSiTGCNLdVl0anl6HO4z0E1Z9nRBggNu05G
         CNECmx3P9KH63SEdb+8Wz20s9+Wkdw7FHkZuX6iw9XwYH/05si4FtOzqXs+IqKEPq84v
         H+Nw==
X-Gm-Message-State: AOAM532+c+4zncOHs5jTig/69eZScd1rtYUSxcIf1dnXr1d3rDNWXbrP
        SnQptCedj+8p0p1Lih048NklZmoqraP2sA==
X-Google-Smtp-Source: ABdhPJzj3W0z5lcTS/NzRWdxm29S3ivIcnM4KfvkJ2wtUnISJDZhRQJCz+OoD8Hz+LZ4YwsjC3P7aAfhKo1avA==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:543f:65f4:6992:2c5a])
 (user=evitayan job=sendgmr) by 2002:a25:8b02:: with SMTP id
 i2mr38737018ybl.688.1642550424440; Tue, 18 Jan 2022 16:00:24 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:00:13 -0800
In-Reply-To: <20220119000014.1745223-1-evitayan@google.com>
Message-Id: <20220119000014.1745223-2-evitayan@google.com>
Mime-Version: 1.0
References: <20220119000014.1745223-1-evitayan@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 1/2] xfrm: Check if_id in xfrm_migrate
From:   Yan Yan <evitayan@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lorenzo@google.com,
        maze@google.com, nharold@google.com, benedictwong@google.com,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

---
V1->V2:
- No change (change of this commit serie is not in this commit)
---
 include/net/xfrm.h     |  5 +++--
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  |  7 ++++++-
 net/xfrm/xfrm_user.c   |  6 +++++-
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fdb41e8bb626..743dd1da506e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1681,14 +1681,15 @@ int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
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
index de24a7d474df..9bf52a09b5ff 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2623,7 +2623,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	}
 
 	return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
-			    kma ? &k : NULL, net, NULL);
+			    kma ? &k : NULL, net, NULL, 0);
 
  out:
 	return err;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index dccb8f3318ef..b4ccad50d94f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4255,7 +4255,7 @@ static bool xfrm_migrate_selector_match(const struct xfrm_selector *sel_cmp,
 }
 
 static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *sel,
-						    u8 dir, u8 type, struct net *net)
+						    u8 dir, u8 type, struct net *net, u32 if_id)
 {
 	struct xfrm_policy *pol, *ret = NULL;
 	struct hlist_head *chain;
@@ -4264,7 +4264,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_direct(net, &sel->daddr, &sel->saddr, sel->family, dir);
 	hlist_for_each_entry(pol, chain, bydst) {
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			priority = ret->priority;
@@ -4276,7 +4277,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 		if ((pol->priority >= priority) && ret)
 			break;
 
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			break;
@@ -4392,7 +4394,7 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_migrate,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap)
+		 struct xfrm_encap_tmpl *encap, u32 if_id)
 {
 	int i, err, nx_cur = 0, nx_new = 0;
 	struct xfrm_policy *pol = NULL;
@@ -4411,14 +4413,14 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
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
index ca6bee18346d..b0eeb0aef493 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1606,7 +1606,8 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	return NULL;
 }
 
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net)
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id)
 {
 	unsigned int h;
 	struct xfrm_state *x = NULL;
@@ -1622,6 +1623,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 				continue;
 			if (m->reqid && x->props.reqid != m->reqid)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
@@ -1637,6 +1640,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8cd6c8129004..a4fb596e87af 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2608,6 +2608,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int n = 0;
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_encap_tmpl  *encap = NULL;
+	u32 if_id = 0;
 
 	if (attrs[XFRMA_MIGRATE] == NULL)
 		return -EINVAL;
@@ -2632,7 +2633,10 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -ENOMEM;
 	}
 
-	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap);
+	if (attrs[XFRMA_IF_ID])
+		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+
+	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap, if_id);
 
 	kfree(encap);
 
-- 
2.34.1.703.g22d0c6ccf7-goog

