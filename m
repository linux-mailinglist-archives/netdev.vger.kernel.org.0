Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E3D28069F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732917AbgJASbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732760AbgJASbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 14:31:42 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B35922204;
        Thu,  1 Oct 2020 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601577100;
        bh=r3De7CL83EYfgDWL7NHWKZAHI1mNh7iLCNmkP0RBKeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGMSw5K6n4Qb6dh/13UwczkvA6MUrU+wsl3fpk0OA2bPHteRNYGB03VafOO72iEwH
         cCmzFlTK9SwZHDOZBS2xMKdXUwJfA7uzE+oHjcBiqsEn+2Ee1+0IDcf6VEA0uWX/LX
         dUmahnOmC0HDf4mIhJrs02F8FTOHivsFPQDjZuIE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>,
        bsingharora@gmail.com
Subject: [PATCH net-next 7/9] taskstats: move specifying netlink policy back to ops
Date:   Thu,  1 Oct 2020 11:30:14 -0700
Message-Id: <20201001183016.1259870-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001183016.1259870-1-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
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

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: bsingharora@gmail.com
---
 kernel/taskstats.c | 42 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index ef4de29fbe8a..b5ff1f2b6122 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -34,7 +34,7 @@ struct kmem_cache *taskstats_cache;
 
 static struct genl_family family;
 
-static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
+static const struct nla_policy taskstats_cmd_get_policy[] = {
 	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
@@ -44,7 +44,7 @@ static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1
  * We have to use TASKSTATS_CMD_ATTR_MAX here, it is the maxattr in the family.
  * Make sure they are always aligned.
  */
-static const struct nla_policy cgroupstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
+static const struct nla_policy cgroupstats_cmd_get_policy[] = {
 	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
 };
 
@@ -644,52 +644,30 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
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

