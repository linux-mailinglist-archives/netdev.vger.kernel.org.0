Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BF627F672
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgJAAFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbgJAAFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:31 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C634521D46;
        Thu,  1 Oct 2020 00:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510731;
        bh=pPe+MH/hLFS8M9NT9L/p7GwJZpAEGgXqHYIhxyW3880=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qcc2FYa8dVoDj3cdzp0uDnOwqndMipWrrHrUFgDEaM6lbQcHZ0KgHoG4ZnT3XamF2
         wrJkBntDE1dCOs4lGa7rEjGSW97uWXFsUKKCQXynb2eky9IusWRsBtlmtUxsrcGhOb
         i3u2uAyP9HMFdx5aoeLEfw48XipjDGrepDyWb4cc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 8/9] genetlink: use per-op policy for CTRL_CMD_GETPOLICY
Date:   Wed, 30 Sep 2020 17:05:17 -0700
Message-Id: <20201001000518.685243-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
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
---
 net/netlink/genetlink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 7ceb2dc92a09..f2833e9165c7 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1115,17 +1115,18 @@ struct ctrl_dump_policy_ctx {
 	unsigned int fam_id;
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
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;
-	struct nlattr *tb[CTRL_ATTR_MAX + 1];
+	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
-	int err;
-
-	err = genlmsg_parse(cb->nlh, &genl_ctrl, tb, genl_ctrl.maxattr,
-			    genl_ctrl.policy, cb->extack);
-	if (err)
-		return err;
 
 	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
 		return -EINVAL;
@@ -1196,6 +1197,8 @@ static const struct genl_ops genl_ctrl_ops[] = {
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

