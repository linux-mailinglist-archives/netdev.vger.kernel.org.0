Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56890280F8E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgJBJJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387638AbgJBJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:09:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46566C0613E4
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:09:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOH4b-00F9QD-46; Fri, 02 Oct 2020 11:09:53 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/5] netlink: simplify netlink_policy_dump_start() prototype
Date:   Fri,  2 Oct 2020 11:09:40 +0200
Message-Id: <20201002110205.35dfe0fb3299.If2afc69c480c29c3dfc7c373c9a8b45678939746@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002090944.195891-1-johannes@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since moving the call to this to a dump start() handler we no
longer need this to deal with being called after having been
called already. Since that is the preferred way of doing things
anyway, remove the code necessary for that and simply return
the pointer (or an ERR_PTR()).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h   |  6 +++---
 net/netlink/genetlink.c |  5 ++++-
 net/netlink/policy.c    | 19 +++++++------------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 00258590f2cb..4be0ad237e57 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1937,9 +1937,9 @@ void nla_get_range_signed(const struct nla_policy *pt,
 
 struct netlink_policy_dump_state;
 
-int netlink_policy_dump_start(const struct nla_policy *policy,
-			      unsigned int maxtype,
-			      struct netlink_policy_dump_state **state);
+struct netlink_policy_dump_state *
+netlink_policy_dump_start(const struct nla_policy *policy,
+			  unsigned int maxtype);
 bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state);
 int netlink_policy_dump_write(struct sk_buff *skb,
 			      struct netlink_policy_dump_state *state);
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index fad691037402..537472342781 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1164,7 +1164,10 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!op.policy)
 		return -ENODATA;
 
-	return netlink_policy_dump_start(op.policy, op.maxattr, &ctx->state);
+	ctx->state = netlink_policy_dump_start(op.policy, op.maxattr);
+	if (IS_ERR(ctx->state))
+		return PTR_ERR(ctx->state);
+	return 0;
 }
 
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 0dc804afdb25..2a0d85cbc0a2 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -76,17 +76,14 @@ static unsigned int get_policy_idx(struct netlink_policy_dump_state *state,
 	return -1;
 }
 
-int netlink_policy_dump_start(const struct nla_policy *policy,
-			      unsigned int maxtype,
-                              struct netlink_policy_dump_state **statep)
+struct netlink_policy_dump_state *
+netlink_policy_dump_start(const struct nla_policy *policy,
+			  unsigned int maxtype)
 {
 	struct netlink_policy_dump_state *state;
 	unsigned int policy_idx;
 	int err;
 
-	if (*statep)
-		return 0;
-
 	/*
 	 * walk the policies and nested ones first, and build
 	 * a linear list of them.
@@ -95,12 +92,12 @@ int netlink_policy_dump_start(const struct nla_policy *policy,
 	state = kzalloc(struct_size(state, policies, INITIAL_POLICIES_ALLOC),
 			GFP_KERNEL);
 	if (!state)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	state->n_alloc = INITIAL_POLICIES_ALLOC;
 
 	err = add_policy(&state, policy, maxtype);
 	if (err)
-		return err;
+		return ERR_PTR(err);
 
 	for (policy_idx = 0;
 	     policy_idx < state->n_alloc && state->policies[policy_idx].policy;
@@ -120,7 +117,7 @@ int netlink_policy_dump_start(const struct nla_policy *policy,
 						 policy[type].nested_policy,
 						 policy[type].len);
 				if (err)
-					return err;
+					return ERR_PTR(err);
 				break;
 			default:
 				break;
@@ -128,9 +125,7 @@ int netlink_policy_dump_start(const struct nla_policy *policy,
 		}
 	}
 
-	*statep = state;
-
-	return 0;
+	return state;
 }
 
 static bool
-- 
2.26.2

