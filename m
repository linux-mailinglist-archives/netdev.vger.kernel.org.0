Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20D9283BC7
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgJEP6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgJEP6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B99206DD;
        Mon,  5 Oct 2020 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913486;
        bh=Q0A8twdlh95KkcTbSxtli0EUmfvK8GPMx/2wdnbRyqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8zbMmrqDM4D3RHBgmiJuWn4Z/ZhANwQHDfuN4zJ8Pa+8GY6a1rm4kewznoV4x/Lm
         rC5TC56f/u8q4Z7TcWhue4nY3HnGX5SXLQUluWm5XOvoalGOzSLfPG1euWg/W+H+iS
         qMpH3gh2gZaOFl8W+pzAHhNuu6Q/Ww3MCkrITG4k=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] ethtool: wire up get policies to ops
Date:   Mon,  5 Oct 2020 08:57:48 -0700
Message-Id: <20201005155753.2333882-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005155753.2333882-1-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make use of genetlink code validating and parsing attributes
for us, as well as dumping policies to user space wrie up policies
for get commands in struct nla_policy of the ethtool family.

For ease of review this commit just does the repetitive wiring up.
Next changes will use the core-parsed attrs and migrate set commands.
For every ETHTOOL_MSG_*_GET:
 - add 'ethnl_' prefix to policy name
 - add extern declaration in net/ethtool/netlink.h
 - wire up the policy in ethtool_genl_ops[].

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/channels.c  |  6 +++---
 net/ethtool/coalesce.c  |  6 +++---
 net/ethtool/debug.c     |  5 ++---
 net/ethtool/eee.c       |  5 ++---
 net/ethtool/features.c  |  6 +++---
 net/ethtool/linkinfo.c  |  6 +++---
 net/ethtool/linkmodes.c |  6 +++---
 net/ethtool/linkstate.c |  6 +++---
 net/ethtool/netlink.c   | 32 ++++++++++++++++++++++++++++++++
 net/ethtool/netlink.h   | 16 ++++++++++++++++
 net/ethtool/pause.c     |  5 ++---
 net/ethtool/privflags.c |  6 +++---
 net/ethtool/rings.c     |  5 ++---
 net/ethtool/strset.c    |  4 ++--
 net/ethtool/tsinfo.c    |  5 ++---
 net/ethtool/tunnels.c   |  6 +++---
 net/ethtool/wol.c       |  5 ++---
 17 files changed, 86 insertions(+), 44 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 9ecda09ecb11..d3ef94c5ee59 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -17,8 +17,8 @@ struct channels_reply_data {
 #define CHANNELS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct channels_reply_data, base)
 
-static const struct nla_policy
-channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
+const struct nla_policy
+ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
 	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
@@ -102,7 +102,7 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 	.max_attr		= ETHTOOL_A_CHANNELS_MAX,
 	.req_info_size		= sizeof(struct channels_req_info),
 	.reply_data_size	= sizeof(struct channels_reply_data),
-	.request_policy		= channels_get_policy,
+	.request_policy		= ethnl_channels_get_policy,
 
 	.prepare_data		= channels_prepare_data,
 	.reply_size		= channels_reply_size,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 6afd99042d67..e0d8a269a46d 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -51,8 +51,8 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
 
-static const struct nla_policy
-coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
+const struct nla_policy
+ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
 	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_REJECT },
@@ -206,7 +206,7 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 	.max_attr		= ETHTOOL_A_COALESCE_MAX,
 	.req_info_size		= sizeof(struct coalesce_req_info),
 	.reply_data_size	= sizeof(struct coalesce_reply_data),
-	.request_policy		= coalesce_get_policy,
+	.request_policy		= ethnl_coalesce_get_policy,
 
 	.prepare_data		= coalesce_prepare_data,
 	.reply_size		= coalesce_reply_size,
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index 1bd026a29f3f..a007730320a4 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -16,8 +16,7 @@ struct debug_reply_data {
 #define DEBUG_REPDATA(__reply_base) \
 	container_of(__reply_base, struct debug_reply_data, base)
 
-static const struct nla_policy
-debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
+const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
 	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_REJECT },
@@ -72,7 +71,7 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 	.max_attr		= ETHTOOL_A_DEBUG_MAX,
 	.req_info_size		= sizeof(struct debug_req_info),
 	.reply_data_size	= sizeof(struct debug_reply_data),
-	.request_policy		= debug_get_policy,
+	.request_policy		= ethnl_debug_get_policy,
 
 	.prepare_data		= debug_prepare_data,
 	.reply_size		= debug_reply_size,
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 94aa19cff22f..ea9d071b5360 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -19,8 +19,7 @@ struct eee_reply_data {
 #define EEE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eee_reply_data, base)
 
-static const struct nla_policy
-eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
+const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
 	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_REJECT },
@@ -122,7 +121,7 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 	.max_attr		= ETHTOOL_A_EEE_MAX,
 	.req_info_size		= sizeof(struct eee_req_info),
 	.reply_data_size	= sizeof(struct eee_reply_data),
-	.request_policy		= eee_get_policy,
+	.request_policy		= ethnl_eee_get_policy,
 
 	.prepare_data		= eee_prepare_data,
 	.reply_size		= eee_reply_size,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 495635f152ba..c2979b3890f9 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -20,8 +20,8 @@ struct features_reply_data {
 #define FEATURES_REPDATA(__reply_base) \
 	container_of(__reply_base, struct features_reply_data, base)
 
-static const struct nla_policy
-features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
+const struct nla_policy
+ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
 	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
@@ -123,7 +123,7 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 	.max_attr		= ETHTOOL_A_FEATURES_MAX,
 	.req_info_size		= sizeof(struct features_req_info),
 	.reply_data_size	= sizeof(struct features_reply_data),
-	.request_policy		= features_get_policy,
+	.request_policy		= ethnl_features_get_policy,
 
 	.prepare_data		= features_prepare_data,
 	.reply_size		= features_reply_size,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 5eaf173eaaca..676aa5a00ac0 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -16,8 +16,8 @@ struct linkinfo_reply_data {
 #define LINKINFO_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkinfo_reply_data, base)
 
-static const struct nla_policy
-linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
+const struct nla_policy
+ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
 	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_REJECT },
@@ -86,7 +86,7 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
 	.req_info_size		= sizeof(struct linkinfo_req_info),
 	.reply_data_size	= sizeof(struct linkinfo_reply_data),
-	.request_policy		= linkinfo_get_policy,
+	.request_policy		= ethnl_linkinfo_get_policy,
 
 	.prepare_data		= linkinfo_prepare_data,
 	.reply_size		= linkinfo_reply_size,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 29dcd675b65a..f32ab3239d15 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -18,8 +18,8 @@ struct linkmodes_reply_data {
 #define LINKMODES_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkmodes_reply_data, base)
 
-static const struct nla_policy
-linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
+const struct nla_policy
+ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_REJECT },
@@ -151,7 +151,7 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 	.max_attr		= ETHTOOL_A_LINKMODES_MAX,
 	.req_info_size		= sizeof(struct linkmodes_req_info),
 	.reply_data_size	= sizeof(struct linkmodes_reply_data),
-	.request_policy		= linkmodes_get_policy,
+	.request_policy		= ethnl_linkmodes_get_policy,
 
 	.prepare_data		= linkmodes_prepare_data,
 	.reply_size		= linkmodes_reply_size,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 4834091ec24c..c86ae67e2486 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -20,8 +20,8 @@ struct linkstate_reply_data {
 #define LINKSTATE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkstate_reply_data, base)
 
-static const struct nla_policy
-linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
+const struct nla_policy
+ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
@@ -182,7 +182,7 @@ const struct ethnl_request_ops ethnl_linkstate_request_ops = {
 	.max_attr		= ETHTOOL_A_LINKSTATE_MAX,
 	.req_info_size		= sizeof(struct linkstate_req_info),
 	.reply_data_size	= sizeof(struct linkstate_reply_data),
-	.request_policy		= linkstate_get_policy,
+	.request_policy		= ethnl_linkstate_get_policy,
 
 	.prepare_data		= linkstate_prepare_data,
 	.reply_size		= linkstate_reply_size,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5c2072765be7..dbabac38c191 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -696,6 +696,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_strset_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_strset_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKINFO_GET,
@@ -703,6 +705,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_linkinfo_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkinfo_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
@@ -715,6 +719,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_linkmodes_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkmodes_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKMODES_SET,
@@ -727,6 +733,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_linkstate_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkstate_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_DEBUG_GET,
@@ -734,6 +742,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_debug_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_debug_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_DEBUG_SET,
@@ -747,6 +757,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_wol_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_wol_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_WOL_SET,
@@ -759,6 +771,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_features_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_features_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_FEATURES_SET,
@@ -771,6 +785,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_privflags_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_privflags_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_PRIVFLAGS_SET,
@@ -783,6 +799,9 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_rings_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rings_get_policy) - 1,
+
 	},
 	{
 		.cmd	= ETHTOOL_MSG_RINGS_SET,
@@ -795,6 +814,9 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_channels_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_channels_get_policy) - 1,
+
 	},
 	{
 		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
@@ -807,6 +829,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_coalesce_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_coalesce_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_COALESCE_SET,
@@ -819,6 +843,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_pause_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_pause_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_PAUSE_SET,
@@ -831,6 +857,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_eee_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_eee_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_EEE_SET,
@@ -843,6 +871,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_tsinfo_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_tsinfo_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_ACT,
@@ -859,6 +889,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.doit	= ethnl_tunnel_info_doit,
 		.start	= ethnl_tunnel_info_start,
 		.dumpit	= ethnl_tunnel_info_dumpit,
+		.policy = ethnl_tunnel_info_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
 };
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index e2085005caac..0100fab5829e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -349,6 +349,22 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
+extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1];
+extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1];
+extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1];
+extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1];
+extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1];
+extern const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1];
+extern const struct nla_policy ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1];
+extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1];
+extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1];
+extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1];
+extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1];
+extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1];
+extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1];
+extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1];
+extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1];
+
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 1980aa7eb2b6..40f36f8d6291 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -16,8 +16,7 @@ struct pause_reply_data {
 #define PAUSE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct pause_reply_data, base)
 
-static const struct nla_policy
-pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
+const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
@@ -133,7 +132,7 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.max_attr		= ETHTOOL_A_PAUSE_MAX,
 	.req_info_size		= sizeof(struct pause_req_info),
 	.reply_data_size	= sizeof(struct pause_reply_data),
-	.request_policy		= pause_get_policy,
+	.request_policy		= ethnl_pause_get_policy,
 
 	.prepare_data		= pause_prepare_data,
 	.reply_size		= pause_reply_size,
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index 77447dceb109..7ebab33f2244 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -18,8 +18,8 @@ struct privflags_reply_data {
 #define PRIVFLAGS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct privflags_reply_data, base)
 
-static const struct nla_policy
-privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
+const struct nla_policy
+ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
 	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_REJECT },
@@ -127,7 +127,7 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,
 	.req_info_size		= sizeof(struct privflags_req_info),
 	.reply_data_size	= sizeof(struct privflags_reply_data),
-	.request_policy		= privflags_get_policy,
+	.request_policy		= ethnl_privflags_get_policy,
 
 	.prepare_data		= privflags_prepare_data,
 	.reply_size		= privflags_reply_size,
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 5422526f4eef..eb52639b6ed3 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -15,8 +15,7 @@ struct rings_reply_data {
 #define RINGS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct rings_reply_data, base)
 
-static const struct nla_policy
-rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
+const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
 	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
@@ -100,7 +99,7 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 	.max_attr		= ETHTOOL_A_RINGS_MAX,
 	.req_info_size		= sizeof(struct rings_req_info),
 	.reply_data_size	= sizeof(struct rings_reply_data),
-	.request_policy		= rings_get_policy,
+	.request_policy		= ethnl_rings_get_policy,
 
 	.prepare_data		= rings_prepare_data,
 	.reply_size		= rings_reply_size,
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 82707b662fe4..8d30fe0fbe3b 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -99,7 +99,7 @@ struct strset_reply_data {
 #define STRSET_REPDATA(__reply_base) \
 	container_of(__reply_base, struct strset_reply_data, base)
 
-static const struct nla_policy strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
+const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
 	[ETHTOOL_A_STRSET_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_STRSET_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
@@ -448,7 +448,7 @@ const struct ethnl_request_ops ethnl_strset_request_ops = {
 	.max_attr		= ETHTOOL_A_STRSET_MAX,
 	.req_info_size		= sizeof(struct strset_req_info),
 	.reply_data_size	= sizeof(struct strset_reply_data),
-	.request_policy		= strset_get_policy,
+	.request_policy		= ethnl_strset_get_policy,
 	.allow_nodev_do		= true,
 
 	.parse_request		= strset_parse_request,
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 7cb5b512b77c..05d501563dc9 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -18,8 +18,7 @@ struct tsinfo_reply_data {
 #define TSINFO_REPDATA(__reply_base) \
 	container_of(__reply_base, struct tsinfo_reply_data, base)
 
-static const struct nla_policy
-tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
+const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
 	[ETHTOOL_A_TSINFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_TSINFO_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_TSINFO_TIMESTAMPING]		= { .type = NLA_REJECT },
@@ -135,7 +134,7 @@ const struct ethnl_request_ops ethnl_tsinfo_request_ops = {
 	.max_attr		= ETHTOOL_A_TSINFO_MAX,
 	.req_info_size		= sizeof(struct tsinfo_req_info),
 	.reply_data_size	= sizeof(struct tsinfo_reply_data),
-	.request_policy		= tsinfo_get_policy,
+	.request_policy		= ethnl_tsinfo_get_policy,
 
 	.prepare_data		= tsinfo_prepare_data,
 	.reply_size		= tsinfo_reply_size,
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index d93bf2da0f34..d7d4964ea773 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -8,8 +8,8 @@
 #include "common.h"
 #include "netlink.h"
 
-static const struct nla_policy
-ethtool_tunnel_info_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
+const struct nla_policy
+ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
 	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
 };
@@ -170,7 +170,7 @@ ethnl_tunnel_info_req_parse(struct ethnl_req_info *req_info,
 	int ret;
 
 	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_TUNNEL_INFO_MAX,
-			  ethtool_tunnel_info_policy, extack);
+			  ethnl_tunnel_info_get_policy, extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 1798421e9f1c..d234885fc265 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -17,8 +17,7 @@ struct wol_reply_data {
 #define WOL_REPDATA(__reply_base) \
 	container_of(__reply_base, struct wol_reply_data, base)
 
-static const struct nla_policy
-wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
+const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
 	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_REJECT },
@@ -92,7 +91,7 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 	.max_attr		= ETHTOOL_A_WOL_MAX,
 	.req_info_size		= sizeof(struct wol_req_info),
 	.reply_data_size	= sizeof(struct wol_reply_data),
-	.request_policy		= wol_get_policy,
+	.request_policy		= ethnl_wol_get_policy,
 
 	.prepare_data		= wol_prepare_data,
 	.reply_size		= wol_reply_size,
-- 
2.26.2

