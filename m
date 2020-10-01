Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07502806A0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbgJASbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732791AbgJASbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 14:31:42 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56AC620796;
        Thu,  1 Oct 2020 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601577100;
        bh=VxPzwft44E/+BhTDLu8zuMRDSPR+pKwcruGfdkpGZJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwb1gUhzs4f7RGLv016oqNcJl+jHR27ZX6719GzCkCA9jrUWKd9m8goTcAvORh5Se
         aX7YBFQIXLJGdu+ZMelXwkNENYIvfP7VKDeGhS/cNNF4cGLl/EzbDmniVbhxdZf4MF
         I+rAS5tp9CAYMklDPjxE9Cgt46rSmJ5iMs0L4ztU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/9] genetlink: use per-op policy for CTRL_CMD_GETPOLICY
Date:   Thu,  1 Oct 2020 11:30:15 -0700
Message-Id: <20201001183016.1259870-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001183016.1259870-1-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up per-op policy for CTRL_CMD_GETPOLICY.
This saves us a call to genlmsg_parse() and will soon allow
dumping this policy.

Create a new policy definition, since we don't want to pollute
ctrl_policy with attributes which CTRL_CMD_GETFAMILY does not
support.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/netlink/genetlink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 2a3608cfb179..81f0b960e9f8 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1115,20 +1115,21 @@ struct ctrl_dump_policy_ctx {
 	u16 fam_id;
 };
 
+static const struct nla_policy ctrl_policy_policy[] = {
+	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
+	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = GENL_NAMSIZ - 1 },
+};
+
 static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
-	struct nlattr *tb[CTRL_ATTR_MAX + 1];
+	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
-	int err;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
-	err = genlmsg_parse(cb->nlh, &genl_ctrl, tb, genl_ctrl.maxattr,
-			    genl_ctrl.policy, cb->extack);
-	if (err)
-		return err;
-
 	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
 		return -EINVAL;
 
@@ -1198,6 +1199,8 @@ static const struct genl_ops genl_ctrl_ops[] = {
 	},
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
+		.policy		= ctrl_policy_policy,
+		.maxattr	= ARRAY_SIZE(ctrl_policy_policy) - 1,
 		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 	},
-- 
2.26.2

