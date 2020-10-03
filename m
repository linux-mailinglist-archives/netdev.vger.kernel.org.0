Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0228229B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgJCIoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJCIoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:44:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78B0C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:44:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOd9w-00FmcE-Dd; Sat, 03 Oct 2020 10:44:52 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 2/5] netlink: rework policy dump to support multiple policies
Date:   Sat,  3 Oct 2020 10:44:43 +0200
Message-Id: <20201003104138.c69b48fe6e9b.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201003084446.59042-1-johannes@sipsolutions.net>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Rework the policy dump code a bit to support adding multiple
policies to a single dump, in order to e.g. support per-op
policies in generic netlink.

v2:
 - move kernel-doc to implementation [Jakub]
 - squash the first patch to not flip-flop on the prototype
   [Jakub]
 - merge netlink_policy_dump_get_policy_idx() with the old
   get_policy_idx() we already had
 - rebase without Jakub's patch to have per-op dump

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h   |   9 ++--
 net/netlink/genetlink.c |   3 +-
 net/netlink/policy.c    | 102 ++++++++++++++++++++++++++++++++--------
 3 files changed, 90 insertions(+), 24 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 00258590f2cb..5a5ff97cc596 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1937,9 +1937,12 @@ void nla_get_range_signed(const struct nla_policy *pt,
 
 struct netlink_policy_dump_state;
 
-int netlink_policy_dump_start(const struct nla_policy *policy,
-			      unsigned int maxtype,
-			      struct netlink_policy_dump_state **state);
+int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
+				   const struct nla_policy *policy,
+				   unsigned int maxtype);
+int netlink_policy_dump_get_policy_idx(struct netlink_policy_dump_state *state,
+				       const struct nla_policy *policy,
+				       unsigned int maxtype);
 bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state);
 int netlink_policy_dump_write(struct sk_buff *skb,
 			      struct netlink_policy_dump_state *state);
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 7ddc574931f4..89646b97300c 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1150,7 +1150,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!rt->policy)
 		return -ENODATA;
 
-	return netlink_policy_dump_start(rt->policy, rt->maxattr, &ctx->state);
+	return netlink_policy_dump_add_policy(&ctx->state, rt->policy,
+					      rt->maxattr);
 }
 
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 753b265acec5..cf23c0151721 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -63,44 +63,85 @@ static int add_policy(struct netlink_policy_dump_state **statep,
 	return 0;
 }
 
-static unsigned int get_policy_idx(struct netlink_policy_dump_state *state,
-				   const struct nla_policy *policy,
-				   unsigned int maxtype)
+/**
+ * netlink_policy_dump_get_policy_idx - retrieve policy index
+ * @state: the policy dump state
+ * @policy: the policy to find
+ * @maxtype: the policy's maxattr
+ *
+ * Returns: the index of the given policy in the dump state
+ *
+ * Call this to find a policy index when you've added multiple and e.g.
+ * need to tell userspace which command has which policy (by index).
+ *
+ * Note: this will WARN and return 0 if the policy isn't found, which
+ *	 means it wasn't added in the first place, which would be an
+ *	 internal consistency bug.
+ */
+int netlink_policy_dump_get_policy_idx(struct netlink_policy_dump_state *state,
+				       const struct nla_policy *policy,
+				       unsigned int maxtype)
 {
 	unsigned int i;
 
+	if (WARN_ON(!policy || !maxtype))
+                return 0;
+
 	for (i = 0; i < state->n_alloc; i++) {
 		if (state->policies[i].policy == policy &&
 		    state->policies[i].maxtype == maxtype)
 			return i;
 	}
 
-	WARN_ON_ONCE(1);
-	return -1;
+	WARN_ON(1);
+	return 0;
 }
 
-int netlink_policy_dump_start(const struct nla_policy *policy,
-			      unsigned int maxtype,
-			      struct netlink_policy_dump_state **statep)
+static struct netlink_policy_dump_state *alloc_state(void)
 {
 	struct netlink_policy_dump_state *state;
+
+	state = kzalloc(struct_size(state, policies, INITIAL_POLICIES_ALLOC),
+			GFP_KERNEL);
+	if (!state)
+		return ERR_PTR(-ENOMEM);
+	state->n_alloc = INITIAL_POLICIES_ALLOC;
+
+	return state;
+}
+
+/**
+ * netlink_policy_dump_add_policy - add a policy to the dump
+ * @pstate: state to add to, may be reallocated, must be %NULL the first time
+ * @policy: the new policy to add to the dump
+ * @maxtype: the new policy's max attr type
+ *
+ * Returns: 0 on success, a negative error code otherwise.
+ *
+ * Call this to allocate a policy dump state, and to add policies to it. This
+ * should be called from the dump start() callback.
+ *
+ * Note: on failures, any previously allocated state is freed.
+ */
+int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
+				   const struct nla_policy *policy,
+				   unsigned int maxtype)
+{
+	struct netlink_policy_dump_state *state = *pstate;
 	unsigned int policy_idx;
 	int err;
 
-	if (*statep)
-		return 0;
+	if (!state) {
+		state = alloc_state();
+		if (IS_ERR(state))
+			return PTR_ERR(state);
+	}
 
 	/*
 	 * walk the policies and nested ones first, and build
 	 * a linear list of them.
 	 */
 
-	state = kzalloc(struct_size(state, policies, INITIAL_POLICIES_ALLOC),
-			GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->n_alloc = INITIAL_POLICIES_ALLOC;
-
 	err = add_policy(&state, policy, maxtype);
 	if (err)
 		return err;
@@ -131,8 +172,7 @@ int netlink_policy_dump_start(const struct nla_policy *policy,
 		}
 	}
 
-	*statep = state;
-
+	*pstate = state;
 	return 0;
 }
 
@@ -143,11 +183,26 @@ netlink_policy_dump_finished(struct netlink_policy_dump_state *state)
 	       !state->policies[state->policy_idx].policy;
 }
 
+/**
+ * netlink_policy_dump_loop - dumping loop indicator
+ * @state: the policy dump state
+ *
+ * Returns: %true if the dump continues, %false otherwise
+ *
+ * Note: this frees the dump state when finishing
+ */
 bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state)
 {
 	return !netlink_policy_dump_finished(state);
 }
 
+/**
+ * netlink_policy_dump_write - write current policy dump attributes
+ * @skb: the message skb to write to
+ * @state: the policy dump state
+ *
+ * Returns: 0 on success, an error code otherwise
+ */
 int netlink_policy_dump_write(struct sk_buff *skb,
 			      struct netlink_policy_dump_state *state)
 {
@@ -185,8 +240,9 @@ int netlink_policy_dump_write(struct sk_buff *skb,
 			type = NL_ATTR_TYPE_NESTED_ARRAY;
 		if (pt->nested_policy && pt->len &&
 		    (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_IDX,
-				 get_policy_idx(state, pt->nested_policy,
-						pt->len)) ||
+				 netlink_policy_dump_get_policy_idx(state,
+								    pt->nested_policy,
+								    pt->len)) ||
 		     nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
 				 pt->len)))
 			goto nla_put_failure;
@@ -309,6 +365,12 @@ int netlink_policy_dump_write(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+/**
+ * netlink_policy_dump_free - free policy dump state
+ * @state: the policy dump state to free
+ *
+ * Call this from the done() method to ensure dump state is freed.
+ */
 void netlink_policy_dump_free(struct netlink_policy_dump_state *state)
 {
 	kfree(state);
-- 
2.26.2

