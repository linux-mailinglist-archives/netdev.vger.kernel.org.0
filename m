Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E0A281DD6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgJBVuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgJBVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:50:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57C12184D;
        Fri,  2 Oct 2020 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601675408;
        bh=ZMZ1FUKQUdmxU+jok+48qxk9i9Vl46b+OPwtPSb/CP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1g2a40lS+VAq8+FFLNWnYP20fDs24t3HDPG4lAMg68frqhKPcFhbKRt3I4LyMltbT
         GTSyqKjSBTb2aRNx0gJ9RLCqWLKu2DhmCFGIevN68L+PnRbmiNtBCes8BsnF0th/wh
         T3uUS92yDaYxuvhMm35W9fikTncODNNKNgk8ALLI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 9/9] genetlink: switch control commands to per-op policies
Date:   Fri,  2 Oct 2020 14:50:00 -0700
Message-Id: <20201002215000.1526096-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002215000.1526096-1-kuba@kernel.org>
References: <20201002215000.1526096-1-kuba@kernel.org>
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
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/netlink/genetlink.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 6f7cd5f577b0..7ddc574931f4 100644
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
@@ -1196,11 +1202,15 @@ static const struct genl_ops genl_ctrl_ops[] = {
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
 		.done		= ctrl_dumppolicy_done,
@@ -1220,8 +1230,6 @@ static struct genl_family genl_ctrl __ro_after_init = {
 	.id = GENL_ID_CTRL,
 	.name = "nlctrl",
 	.version = 0x2,
-	.maxattr = CTRL_ATTR_MAX,
-	.policy = ctrl_policy,
 	.netnsok = true,
 };
 
-- 
2.26.2

