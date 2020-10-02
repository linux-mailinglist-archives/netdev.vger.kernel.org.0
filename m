Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C533280E38
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgJBHqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgJBHqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:46:35 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D38C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 00:46:35 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOFlx-00F7Ma-3e; Fri, 02 Oct 2020 09:46:33 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] netlink: fix policy dump leak
Date:   Fri,  2 Oct 2020 09:46:04 +0200
Message-Id: <20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If userspace doesn't complete the policy dump, we leak the
allocated state. Fix this.

Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Found this while looking at Jakub's series and the complete op dump
that I said I'd do ...

Jakub, this conflicts with your series now, of course. Not sure how
we want to handle that?
---
 include/net/netlink.h   |  3 ++-
 net/netlink/genetlink.c |  9 ++++++++-
 net/netlink/policy.c    | 24 ++++++++++--------------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 8e0eb2c9c528..271620f6bc7f 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1934,7 +1934,8 @@ void nla_get_range_signed(const struct nla_policy *pt,
 int netlink_policy_dump_start(const struct nla_policy *policy,
 			      unsigned int maxtype,
 			      unsigned long *state);
-bool netlink_policy_dump_loop(unsigned long *state);
+bool netlink_policy_dump_loop(unsigned long state);
 int netlink_policy_dump_write(struct sk_buff *skb, unsigned long state);
+void netlink_policy_dump_free(unsigned long state);
 
 #endif
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1eb65a7a27fd..c4b4d3376227 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1079,7 +1079,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
-	while (netlink_policy_dump_loop(&cb->args[1])) {
+	while (netlink_policy_dump_loop(cb->args[1])) {
 		void *hdr;
 		struct nlattr *nest;
 
@@ -1113,6 +1113,12 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int ctrl_dumppolicy_done(struct netlink_callback *cb)
+{
+	netlink_policy_dump_free(cb->args[1]);
+	return 0;
+}
+
 static const struct genl_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETFAMILY,
@@ -1123,6 +1129,7 @@ static const struct genl_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
 		.dumpit		= ctrl_dumppolicy,
+		.done		= ctrl_dumppolicy_done,
 	},
 };
 
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 641ffbdd977a..0176b59ce530 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -84,7 +84,6 @@ int netlink_policy_dump_start(const struct nla_policy *policy,
 	unsigned int policy_idx;
 	int err;
 
-	/* also returns 0 if "*_state" is our ERR_PTR() end marker */
 	if (*_state)
 		return 0;
 
@@ -140,21 +139,11 @@ static bool netlink_policy_dump_finished(struct nl_policy_dump *state)
 	       !state->policies[state->policy_idx].policy;
 }
 
-bool netlink_policy_dump_loop(unsigned long *_state)
+bool netlink_policy_dump_loop(unsigned long _state)
 {
-	struct nl_policy_dump *state = (void *)*_state;
-
-	if (IS_ERR(state))
-		return false;
-
-	if (netlink_policy_dump_finished(state)) {
-		kfree(state);
-		/* store end marker instead of freed state */
-		*_state = (unsigned long)ERR_PTR(-ENOENT);
-		return false;
-	}
+	struct nl_policy_dump *state = (void *)_state;
 
-	return true;
+	return !netlink_policy_dump_finished(state);
 }
 
 int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
@@ -309,3 +298,10 @@ int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
 	nla_nest_cancel(skb, policy);
 	return -ENOBUFS;
 }
+
+void netlink_policy_dump_free(unsigned long _state)
+{
+	struct nl_policy_dump *state = (void *)_state;
+
+	kfree(state);
+}
-- 
2.26.2

