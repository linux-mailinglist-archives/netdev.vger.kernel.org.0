Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FCC280F92
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387670AbgJBJJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387545AbgJBJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:09:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE8DC0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:09:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOH4b-00F9QD-LE; Fri, 02 Oct 2020 11:09:53 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/5] netlink: rework policy dump to support multiple policies
Date:   Fri,  2 Oct 2020 11:09:42 +0200
Message-Id: <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002090944.195891-1-johannes@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Rework the policy dump code a bit to support adding multiple
policies to a single dump, in order to e.g. support per-op
policies in generic netlink.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h   | 62 +++++++++++++++++++++++++++++++++++++++--
 net/netlink/genetlink.c |  6 ++--
 net/netlink/policy.c    | 57 +++++++++++++++++++++++++++++--------
 3 files changed, 106 insertions(+), 19 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4be0ad237e57..a929759a03f5 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1937,12 +1937,68 @@ void nla_get_range_signed(const struct nla_policy *pt,
 
 struct netlink_policy_dump_state;
 
-struct netlink_policy_dump_state *
-netlink_policy_dump_start(const struct nla_policy *policy,
-			  unsigned int maxtype);
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
+				   unsigned int maxtype);
+
+/**
+ * netlink_policy_dump_get_policy_idx - retrieve policy index
+ * @state: the policy dump state
+ * @policy: the policy to find
+ * @maxattr: the policy's maxattr
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
+				       unsigned int maxtype);
+
+/**
+ * netlink_policy_dump_loop - dumping loop indicator
+ * @state: the policy dump state
+ *
+ * Returns: %true if the dump continues, %false otherwise
+ *
+ * Note: this frees the dump state when finishing
+ */
 bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state);
+
+/**
+ * netlink_policy_dump_write - write current policy dump attributes
+ * @skb: the message skb to write to
+ * @state: the policy dump state
+ *
+ * Returns: 0 on success, an error code otherwise
+ */
 int netlink_policy_dump_write(struct sk_buff *skb,
 			      struct netlink_policy_dump_state *state);
+
+/**
+ * netlink_policy_dump_free - free policy dump state
+ * @state: the policy dump state to free
+ *
+ * Call this from the done() method to ensure dump state is freed.
+ */
 void netlink_policy_dump_free(struct netlink_policy_dump_state *state);
 
 #endif
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 537472342781..42777749d4d8 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1164,10 +1164,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!op.policy)
 		return -ENODATA;
 
-	ctx->state = netlink_policy_dump_start(op.policy, op.maxattr);
-	if (IS_ERR(ctx->state))
-		return PTR_ERR(ctx->state);
-	return 0;
+	return netlink_policy_dump_add_policy(&ctx->state, op.policy,
+					      op.maxattr);
 }
 
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 7bc8f81ecc43..d930064cbaf3 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -77,28 +77,41 @@ static unsigned int get_policy_idx(struct netlink_policy_dump_state *state,
 	return -1;
 }
 
-struct netlink_policy_dump_state *
-netlink_policy_dump_start(const struct nla_policy *policy,
-			  unsigned int maxtype)
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
+int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
+				   const struct nla_policy *policy,
+				   unsigned int maxtype)
+{
+	struct netlink_policy_dump_state *state = *pstate;
 	unsigned int policy_idx;
 	int err;
 
+	if (!state) {
+		state = alloc_state();
+		if (IS_ERR(state))
+			return PTR_ERR(state);
+	}
+
 	/*
 	 * walk the policies and nested ones first, and build
 	 * a linear list of them.
 	 */
 
-	state = kzalloc(struct_size(state, policies, INITIAL_POLICIES_ALLOC),
-			GFP_KERNEL);
-	if (!state)
-		return ERR_PTR(-ENOMEM);
-	state->n_alloc = INITIAL_POLICIES_ALLOC;
-
 	err = add_policy(&state, policy, maxtype);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	for (policy_idx = 0;
 	     policy_idx < state->n_alloc && state->policies[policy_idx].policy;
@@ -118,7 +131,7 @@ netlink_policy_dump_start(const struct nla_policy *policy,
 						 policy[type].nested_policy,
 						 policy[type].len);
 				if (err)
-					return ERR_PTR(err);
+					return err;
 				break;
 			default:
 				break;
@@ -126,7 +139,27 @@ netlink_policy_dump_start(const struct nla_policy *policy,
 		}
 	}
 
-	return state;
+	*pstate = state;
+	return 0;
+}
+
+int netlink_policy_dump_get_policy_idx(struct netlink_policy_dump_state *state,
+				       const struct nla_policy *policy,
+				       unsigned int maxtype)
+{
+	unsigned int i;
+
+	if (WARN_ON(!policy || !maxtype))
+                return 0;
+
+	for (i = 0; i < state->n_alloc; i++) {
+		if (state->policies[i].policy == policy &&
+		    state->policies[i].maxtype == maxtype)
+			return i;
+	}
+
+	WARN_ON(1);
+	return 0;
 }
 
 static bool
-- 
2.26.2

