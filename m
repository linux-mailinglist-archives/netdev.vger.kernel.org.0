Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE286284BA9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgJFMcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgJFMcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:32:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1789C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 05:32:10 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPm8W-000EQw-TC; Tue, 06 Oct 2020 14:32:09 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] netlink: policy: refactor per-attr policy writing
Date:   Tue,  6 Oct 2020 14:32:01 +0200
Message-Id: <20201006142714.00c563dc22b5.Id092e96bbd4df7102eea602baf20a409bff3b9b0@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006123202.57898-1-johannes@sipsolutions.net>
References: <20201006123202.57898-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Refactor the per-attribute policy writing into a new
helper function, to be used later for dumping out the
policy of a rejected attribute.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/policy.c | 79 ++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 28 deletions(-)

diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index cf23c0151721..bb4e3ffb4924 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -196,49 +196,33 @@ bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state)
 	return !netlink_policy_dump_finished(state);
 }
 
-/**
- * netlink_policy_dump_write - write current policy dump attributes
- * @skb: the message skb to write to
- * @state: the policy dump state
- *
- * Returns: 0 on success, an error code otherwise
- */
-int netlink_policy_dump_write(struct sk_buff *skb,
-			      struct netlink_policy_dump_state *state)
+static int
+__netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
+				  struct sk_buff *skb,
+				  const struct nla_policy *pt,
+				  int nestattr)
 {
-	const struct nla_policy *pt;
-	struct nlattr *policy, *attr;
 	enum netlink_attribute_type type;
-	bool again;
-
-send_attribute:
-	again = false;
-
-	pt = &state->policies[state->policy_idx].policy[state->attr_idx];
+	struct nlattr *attr;
 
-	policy = nla_nest_start(skb, state->policy_idx);
-	if (!policy)
-		return -ENOBUFS;
-
-	attr = nla_nest_start(skb, state->attr_idx);
+	attr = nla_nest_start(skb, nestattr);
 	if (!attr)
-		goto nla_put_failure;
+		return -ENOBUFS;
 
 	switch (pt->type) {
 	default:
 	case NLA_UNSPEC:
 	case NLA_REJECT:
 		/* skip - use NLA_MIN_LEN to advertise such */
-		nla_nest_cancel(skb, policy);
-		again = true;
-		goto next;
+		nla_nest_cancel(skb, attr);
+		return -ENODATA;
 	case NLA_NESTED:
 		type = NL_ATTR_TYPE_NESTED;
 		fallthrough;
 	case NLA_NESTED_ARRAY:
 		if (pt->type == NLA_NESTED_ARRAY)
 			type = NL_ATTR_TYPE_NESTED_ARRAY;
-		if (pt->nested_policy && pt->len &&
+		if (state && pt->nested_policy && pt->len &&
 		    (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_IDX,
 				 netlink_policy_dump_get_policy_idx(state,
 								    pt->nested_policy,
@@ -341,8 +325,47 @@ int netlink_policy_dump_write(struct sk_buff *skb,
 	if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_TYPE, type))
 		goto nla_put_failure;
 
-	/* finish and move state to next attribute */
 	nla_nest_end(skb, attr);
+	return 0;
+nla_put_failure:
+	nla_nest_cancel(skb, attr);
+	return -ENOBUFS;
+}
+
+/**
+ * netlink_policy_dump_write - write current policy dump attributes
+ * @skb: the message skb to write to
+ * @state: the policy dump state
+ *
+ * Returns: 0 on success, an error code otherwise
+ */
+int netlink_policy_dump_write(struct sk_buff *skb,
+			      struct netlink_policy_dump_state *state)
+{
+	const struct nla_policy *pt;
+	struct nlattr *policy;
+	int err;
+	bool again;
+
+send_attribute:
+	again = false;
+
+	pt = &state->policies[state->policy_idx].policy[state->attr_idx];
+
+	policy = nla_nest_start(skb, state->policy_idx);
+	if (!policy)
+		return -ENOBUFS;
+
+	err = __netlink_policy_dump_write_attr(state, skb, pt, state->attr_idx);
+	if (err == -ENODATA) {
+		nla_nest_cancel(skb, policy);
+		again = true;
+		goto next;
+	} else if (err) {
+		goto nla_put_failure;
+	}
+
+	/* finish and move state to next attribute */
 	nla_nest_end(skb, policy);
 
 next:
-- 
2.26.2

