Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA66280AB9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbgJAXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733197AbgJAW7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 18:59:47 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE8E20872;
        Thu,  1 Oct 2020 22:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601593186;
        bh=GW8qHxW0GPhgQDBut2vcecmrWiqs3MjDuVXHkehn1GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JX/JF+qYH8XaBnYU7iMxHdDUA5awradVCeB4GfPpV52ySgr2evG71jKbNujDfYoVF
         xoRpRWrFon0p5BNQ0aYLTIRDRVwqZvr6CHMOBE15/vBuwvynaivvvxIopl10Sc21LK
         RqLuH0hZ0hvSjNA4YZe8jNSP6HyaAlD7pjYJSoP4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 09/10] genetlink: switch control commands to per-op policies
Date:   Thu,  1 Oct 2020 15:59:32 -0700
Message-Id: <20201001225933.1373426-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001225933.1373426-1-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for adding a new attribute to CTRL_CMD_GETPOLICY
split the policies for getpolicy and getfamily apart.

This will cause a slight user-visible change in that dumping
the policies will switch from per family to per op, but
supposedly sniffer-type applications (which are the main use
case for policy dumping thus far) should support both, anyway.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9e50a8e4abf9..fc5d25bd5698 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1016,7 +1016,7 @@ ctrl_build_mcgrp_msg(const struct genl_family *family,
 	return skb;
 }
 
-static const struct nla_policy ctrl_policy[CTRL_ATTR_MAX+1] = {
+static const struct nla_policy ctrl_policy_family[] = {
 	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
 	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = GENL_NAMSIZ - 1 },
@@ -1115,6 +1115,12 @@ struct ctrl_dump_policy_ctx {
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
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
@@ -1188,11 +1194,15 @@ static const struct genl_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETFAMILY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.policy		= ctrl_policy_family,
+		.maxattr	= ARRAY_SIZE(ctrl_policy_family) - 1,
 		.doit		= ctrl_getfamily,
 		.dumpit		= ctrl_dumpfamily,
 	},
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
+		.policy		= ctrl_policy_policy,
+		.maxattr	= ARRAY_SIZE(ctrl_policy_policy) - 1,
 		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 	},
@@ -1211,8 +1221,6 @@ static struct genl_family genl_ctrl __ro_after_init = {
 	.id = GENL_ID_CTRL,
 	.name = "nlctrl",
 	.version = 0x2,
-	.maxattr = CTRL_ATTR_MAX,
-	.policy = ctrl_policy,
 	.netnsok = true,
 };
 
-- 
2.26.2

