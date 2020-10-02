Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24646281DD8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgJBVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgJBVuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:50:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 835DE20796;
        Fri,  2 Oct 2020 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601675407;
        bh=Gl+TJ4XCTyVVO/eBVahkHTS6069rqFCUb3ANJx+vpP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAPFAOoSsKPIC5dr8mWklze70ImZmt0d6tlpX4bbdfDjbKvqt5k3pnCHHJtww04WJ
         LHEJMKl9IxrU0NKrrbY2gzh1kdObT9ObupXd8GrM4PX+t0ozf1q9mvl2rHYpKRaX+w
         jZQAfGGrf94hg+RkDODLxet27i4vkOmI2z+gnlVs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>,
        bsingharora@gmail.com
Subject: [PATCH net-next v3 7/9] taskstats: move specifying netlink policy back to ops
Date:   Fri,  2 Oct 2020 14:49:58 -0700
Message-Id: <20201002215000.1526096-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002215000.1526096-1-kuba@kernel.org>
References: <20201002215000.1526096-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 3b0f31f2b8c9 ("genetlink: make policy common to family")
had to work around removal of policy from ops by parsing in
the pre_doit callback. Now that policy is back in full ops
we can switch again. Set maxattr to actual size of the policies
- both commands set GENL_DONT_VALIDATE_STRICT so out of range
attributes will be silently ignored, anyway.

v2:
 - remove stale comment

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
CC: bsingharora@gmail.com
---
 kernel/taskstats.c | 46 ++++++++++------------------------------------
 1 file changed, 10 insertions(+), 36 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index ef4de29fbe8a..a2802b6ff4bb 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -34,17 +34,13 @@ struct kmem_cache *taskstats_cache;
 
 static struct genl_family family;
 
-static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
+static const struct nla_policy taskstats_cmd_get_policy[] = {
 	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
 	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },};
 
-/*
- * We have to use TASKSTATS_CMD_ATTR_MAX here, it is the maxattr in the family.
- * Make sure they are always aligned.
- */
-static const struct nla_policy cgroupstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
+static const struct nla_policy cgroupstats_cmd_get_policy[] = {
 	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
 };
 
@@ -644,52 +640,30 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	nlmsg_free(rep_skb);
 }
 
-static const struct genl_small_ops taskstats_ops[] = {
+static const struct genl_ops taskstats_ops[] = {
 	{
 		.cmd		= TASKSTATS_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit		= taskstats_user_cmd,
-		/* policy enforced later */
-		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_HASPOL,
+		.policy		= taskstats_cmd_get_policy,
+		.maxattr	= ARRAY_SIZE(taskstats_cmd_get_policy) - 1,
+		.flags		= GENL_ADMIN_PERM,
 	},
 	{
 		.cmd		= CGROUPSTATS_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit		= cgroupstats_user_cmd,
-		/* policy enforced later */
-		.flags		= GENL_CMD_CAP_HASPOL,
+		.policy		= cgroupstats_cmd_get_policy,
+		.maxattr	= ARRAY_SIZE(cgroupstats_cmd_get_policy) - 1,
 	},
 };
 
-static int taskstats_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
-			      struct genl_info *info)
-{
-	const struct nla_policy *policy = NULL;
-
-	switch (ops->cmd) {
-	case TASKSTATS_CMD_GET:
-		policy = taskstats_cmd_get_policy;
-		break;
-	case CGROUPSTATS_CMD_GET:
-		policy = cgroupstats_cmd_get_policy;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return nlmsg_validate_deprecated(info->nlhdr, GENL_HDRLEN,
-					 TASKSTATS_CMD_ATTR_MAX, policy,
-					 info->extack);
-}
-
 static struct genl_family family __ro_after_init = {
 	.name		= TASKSTATS_GENL_NAME,
 	.version	= TASKSTATS_GENL_VERSION,
-	.maxattr	= TASKSTATS_CMD_ATTR_MAX,
 	.module		= THIS_MODULE,
-	.small_ops	= taskstats_ops,
-	.n_small_ops	= ARRAY_SIZE(taskstats_ops),
-	.pre_doit	= taskstats_pre_doit,
+	.ops		= taskstats_ops,
+	.n_ops		= ARRAY_SIZE(taskstats_ops),
 };
 
 /* Needed early in initialization */
-- 
2.26.2

