Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE103485DBD
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344005AbiAFAzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344422AbiAFAzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:55:07 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949FCC03325A
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:53:01 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id f28-20020ac8015c000000b002c5ccf04258so80983qtg.1
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 16:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nBKOm9ACTq4RYQ6BPU3hdBzr1CZ1X3o99QnZETPKwFQ=;
        b=slXrR9bzmPTfUK7E/7jakCakzyZe64wBfDhK4kx+wpya3E/jzaC40H7BFc+YwvsORX
         60anCCUcyw2PFvNbmnO6PusziZ39F2Ll9928dPGvcMUTsaQRwOxcvonpiaX8tVsb/b7V
         OWdzzISkKMLcci/L1aSpq9HZG3hBwHVfaAB+mhNCiwEd4KagG8kf2NsSgWkR8gjWv4iu
         8QKInkmu7O4atnBBafV0Ixxpm24/7j42BViwKUCKpticnx3qjVTMpLPI3LncrhU7F89v
         bvjuny5L+Joky36VGsnq3DOhvJI9B8XTbfgd/lGmF05Y4WxmXJ1mrsaNUUCFubAT3geO
         QQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nBKOm9ACTq4RYQ6BPU3hdBzr1CZ1X3o99QnZETPKwFQ=;
        b=L+DdjEb46BYf2MMgn9bL8IMgTc4GGXHyXIqoHbwVxr8pPkmu+AsPTriuDE17RIvUEX
         1NLbPrRmJ4Slw4Ci10l5JAt+LoLgl0x0m58uvfvpZgWsiR8WlS9sOpqKQNBRCHy9qQz/
         dTngGo2UKOCenV2R7KEfObW0L1mOWGEHwRiE9mE0aYCK9wmdKI2NZ/anOFx+UA9ZWajJ
         soA2XtfUfFkgGBvwAzypqyZcLahEWH4B3OqAMP706FejDOhoemSTIRA53KWSbLbqiNv4
         yzhztwJu4+ciMs3AW8TqWaDXyY2AtapUUAr42uMeb4+jVr8BjncIaOwngZlgQ/WwguaX
         UQnw==
X-Gm-Message-State: AOAM533L7HrAL4CQPQl5Cdunf4oqyOR2qpQ+wmcGq8h3llbcruN2U7s8
        XZh2MBwWkptmI+2zTT9E1Bz61aL86cKaYw==
X-Google-Smtp-Source: ABdhPJwZrkgiQXDCj9/qTV4fCUGoP+siTtAFe9StP7P3LrxH3e5fuLQgYHBV7iI/qsobeaRNh8FW9Y7HVT+gew==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:bcd2:c148:e081:25e6])
 (user=evitayan job=sendgmr) by 2002:ac8:47cb:: with SMTP id
 d11mr50303132qtr.446.1641430380767; Wed, 05 Jan 2022 16:53:00 -0800 (PST)
Date:   Wed,  5 Jan 2022 16:52:50 -0800
In-Reply-To: <20220106005251.2833941-1-evitayan@google.com>
Message-Id: <20220106005251.2833941-2-evitayan@google.com>
Mime-Version: 1.0
References: <20220106005251.2833941-1-evitayan@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v1 1/2] xfrm: Check if_id in xfrm_migrate
From:   Yan Yan <evitayan@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lorenzo@google.com,
        maze@google.com, nharold@googlel.com, benedictwong@googlel.com,
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
 include/net/xfrm.h     |  5 +++--
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  |  7 ++++++-
 net/xfrm/xfrm_user.c   |  6 +++++-
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 83b46da8873d..faee50259fd4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1676,14 +1676,15 @@ int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
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
index 1a06585022ab..cd656b4ec5b9 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4235,7 +4235,7 @@ static bool xfrm_migrate_selector_match(const struct xfrm_selector *sel_cmp,
 }
 
 static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *sel,
-						    u8 dir, u8 type, struct net *net)
+						    u8 dir, u8 type, struct net *net, u32 if_id)
 {
 	struct xfrm_policy *pol, *ret = NULL;
 	struct hlist_head *chain;
@@ -4244,7 +4244,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_direct(net, &sel->daddr, &sel->saddr, sel->family, dir);
 	hlist_for_each_entry(pol, chain, bydst) {
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			priority = ret->priority;
@@ -4256,7 +4257,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 		if ((pol->priority >= priority) && ret)
 			break;
 
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			break;
@@ -4372,7 +4374,7 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_migrate,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap)
+		 struct xfrm_encap_tmpl *encap, u32 if_id)
 {
 	int i, err, nx_cur = 0, nx_new = 0;
 	struct xfrm_policy *pol = NULL;
@@ -4391,14 +4393,14 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
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
+		if (x = xfrm_migrate_state_find(mp, net, if_id)) {
 			x_cur[nx_cur] = x;
 			nx_cur++;
 			xc = xfrm_state_migrate(x, mp, encap);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 0407272a990c..f52767685b13 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1603,7 +1603,8 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	return NULL;
 }
 
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net)
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id)
 {
 	unsigned int h;
 	struct xfrm_state *x = NULL;
@@ -1619,6 +1620,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 				continue;
 			if (m->reqid && x->props.reqid != m->reqid)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
@@ -1634,6 +1637,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e3e26f4da6c2..eda02c5544ae 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2580,6 +2580,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int n = 0;
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_encap_tmpl  *encap = NULL;
+	u32 if_id = 0;
 
 	if (attrs[XFRMA_MIGRATE] == NULL)
 		return -EINVAL;
@@ -2604,7 +2605,10 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -ENOMEM;
 	}
 
-	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap);
+	if (attrs[XFRMA_IF_ID])
+		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+
+	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap, if_id);
 
 	kfree(encap);
 
-- 
2.34.1.448.ga2b2bfdf31-goog

