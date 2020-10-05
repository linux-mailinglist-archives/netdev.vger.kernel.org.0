Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2E283BC9
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgJEP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgJEP6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D857F2085B;
        Mon,  5 Oct 2020 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913487;
        bh=tzhQb5iyKZBF0aNypxY2FEGtL+iJiB0jmgoRfP/PYF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8TlhE1AgPsGVVshshlvK0eDE7iLeaOU0A314F4XUucKdzTAUOzgDadKenza1QkER
         a2EbfxSw+VcwDmh+1GBuIcEAgUVeWQQBHvHCJC7XS3KvwDt0jAUDIwDhddarJ54I0n
         lIMAw/Fr7GOi06jwGxs35GsCxMaIbbcUZUHzahOc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] ethtool: wire up set policies to ops
Date:   Mon,  5 Oct 2020 08:57:50 -0700
Message-Id: <20201005155753.2333882-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005155753.2333882-1-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to get commands wire up the policies of set commands
to get parsing by the core and policy dumps.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/cabletest.c | 24 ++++++------------------
 net/ethtool/channels.c  | 11 +++--------
 net/ethtool/coalesce.c  | 11 +++--------
 net/ethtool/debug.c     | 10 ++--------
 net/ethtool/eee.c       | 11 +++--------
 net/ethtool/features.c  | 11 +++--------
 net/ethtool/linkinfo.c  | 11 +++--------
 net/ethtool/linkmodes.c | 11 +++--------
 net/ethtool/netlink.c   | 26 ++++++++++++++++++++++++++
 net/ethtool/netlink.h   | 13 +++++++++++++
 net/ethtool/pause.c     |  9 ++-------
 net/ethtool/privflags.c | 11 +++--------
 net/ethtool/rings.c     | 10 ++--------
 net/ethtool/wol.c       |  9 ++-------
 14 files changed, 74 insertions(+), 104 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 888f6e101f34..beb85e0b7fc6 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -11,8 +11,8 @@
  */
 #define MAX_CABLE_LENGTH_CM (150 * 100)
 
-static const struct nla_policy
-cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
+const struct nla_policy
+ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
 };
@@ -56,18 +56,12 @@ static int ethnl_cable_test_started(struct phy_device *phydev, u8 cmd)
 
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
 	struct ethnl_req_info req_info = {};
 	const struct ethtool_phy_ops *ops;
+	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_CABLE_TEST_MAX,
-			  cable_test_act_policy, info->extack);
-	if (ret < 0)
-		return ret;
-
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_CABLE_TEST_HEADER],
 					 genl_info_net(info), info->extack,
@@ -226,8 +220,8 @@ cable_test_tdr_act_cfg_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]	= { .type = NLA_U8 },
 };
 
-static const struct nla_policy
-cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
+const struct nla_policy
+ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG]		= { .type = NLA_NESTED },
@@ -313,19 +307,13 @@ static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
 
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
 	struct ethnl_req_info req_info = {};
 	const struct ethtool_phy_ops *ops;
+	struct nlattr **tb = info->attrs;
 	struct phy_tdr_config cfg;
 	struct net_device *dev;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_CABLE_TEST_TDR_MAX,
-			  cable_test_tdr_act_policy, info->extack);
-	if (ret < 0)
-		return ret;
-
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_CABLE_TEST_TDR_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 76994c8f32a0..7e14e93adedb 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -110,8 +110,8 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 
 /* CHANNELS_SET */
 
-static const struct nla_policy
-channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
+const struct nla_policy
+ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
 	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
@@ -126,22 +126,17 @@ channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
 
 int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1];
 	unsigned int from_channel, old_total, i;
 	bool mod = false, mod_combined = false;
 	struct ethtool_channels channels = {};
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	const struct nlattr *err_attr;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
 	u32 max_rx_in_use = 0;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_CHANNELS_MAX, channels_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_CHANNELS_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 77d83062faa2..261ef40f7f98 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -214,8 +214,8 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 
 /* COALESCE_SET */
 
-static const struct nla_policy
-coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
+const struct nla_policy
+ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
 	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_U32 },
@@ -244,9 +244,9 @@ coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_COALESCE_MAX + 1];
 	struct ethtool_coalesce coalesce = {};
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
 	u32 supported_params;
@@ -254,11 +254,6 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 	int ret;
 	u16 a;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_COALESCE_MAX, coalesce_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_COALESCE_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index f553ef6a99e4..33a4126ed80d 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -79,8 +79,7 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 
 /* DEBUG_SET */
 
-static const struct nla_policy
-debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
+const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
 	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_NESTED },
@@ -88,18 +87,13 @@ debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
 
 int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_DEBUG_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod = false;
 	u32 msg_mask;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_DEBUG_MAX, debug_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_DEBUG_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 9ee03444fb8f..25b99f1cfe12 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -129,8 +129,7 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 
 /* EEE_SET */
 
-static const struct nla_policy
-eee_set_policy[ETHTOOL_A_EEE_MAX + 1] = {
+const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_MAX + 1] = {
 	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_NESTED },
@@ -143,18 +142,14 @@ eee_set_policy[ETHTOOL_A_EEE_MAX + 1] = {
 
 int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_EEE_MAX + 1];
-	struct ethtool_eee eee = {};
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	const struct ethtool_ops *ops;
+	struct ethtool_eee eee = {};
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_EEE_MAX,
-			  eee_set_policy, info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_EEE_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 99944190f398..00c5b77852ec 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -131,8 +131,8 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 
 /* FEATURES_SET */
 
-static const struct nla_policy
-features_set_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
+const struct nla_policy
+ethnl_features_set_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
 	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
@@ -228,17 +228,12 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
-	struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_FEATURES_MAX, features_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	if (!tb[ETHTOOL_A_FEATURES_WANTED])
 		return -EINVAL;
 	ret = ethnl_parse_header_dev_get(&req_info,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index b7142d8e2baf..eb801271b9bc 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -94,8 +94,8 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 
 /* LINKINFO_SET */
 
-static const struct nla_policy
-linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
+const struct nla_policy
+ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
 	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
@@ -107,19 +107,14 @@ linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_LINKINFO_MAX + 1];
 	struct ethtool_link_ksettings ksettings = {};
 	struct ethtool_link_settings *lsettings;
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_LINKINFO_MAX, linkinfo_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_LINKINFO_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index e23e600b73cb..b5f061f192b9 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -275,8 +275,8 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
 };
 
-static const struct nla_policy
-linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
+const struct nla_policy
+ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_U8 },
@@ -391,18 +391,13 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1];
 	struct ethtool_link_ksettings ksettings = {};
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_LINKMODES_MAX, linkmodes_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_LINKMODES_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 2f317caa077a..f2d197e6c9d0 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -700,6 +700,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_linkinfo,
+		.policy = ethnl_linkinfo_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkinfo_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKMODES_GET,
@@ -714,6 +716,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_LINKMODES_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_linkmodes,
+		.policy = ethnl_linkmodes_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkmodes_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKSTATE_GET,
@@ -737,6 +741,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_DEBUG_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_debug,
+		.policy = ethnl_debug_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_debug_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_WOL_GET,
@@ -752,6 +758,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_WOL_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_wol,
+		.policy = ethnl_wol_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_wol_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_FEATURES_GET,
@@ -766,6 +774,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_FEATURES_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_features,
+		.policy = ethnl_features_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_features_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_PRIVFLAGS_GET,
@@ -780,6 +790,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_PRIVFLAGS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_privflags,
+		.policy = ethnl_privflags_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_privflags_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_RINGS_GET,
@@ -795,6 +807,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_RINGS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_rings,
+		.policy = ethnl_rings_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rings_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_CHANNELS_GET,
@@ -810,6 +824,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_channels,
+		.policy = ethnl_channels_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_channels_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_COALESCE_GET,
@@ -824,6 +840,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_COALESCE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_coalesce,
+		.policy = ethnl_coalesce_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_coalesce_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_PAUSE_GET,
@@ -838,6 +856,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_PAUSE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_pause,
+		.policy = ethnl_pause_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_pause_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_EEE_GET,
@@ -852,6 +872,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_EEE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_eee,
+		.policy = ethnl_eee_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_eee_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_TSINFO_GET,
@@ -866,11 +888,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_ACT,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_act_cable_test,
+		.policy = ethnl_cable_test_act_policy,
+		.maxattr = ARRAY_SIZE(ethnl_cable_test_act_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_act_cable_test_tdr,
+		.policy = ethnl_cable_test_tdr_act_policy,
+		.maxattr = ARRAY_SIZE(ethnl_cable_test_tdr_act_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_TUNNEL_INFO_GET,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index b67c41efaf7e..53eeda056441 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -349,18 +349,31 @@ extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
 extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1];
+extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1];
 extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1];
 extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1];
+extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1];
 extern const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1];
+extern const struct nla_policy ethnl_wol_set_policy[ETHTOOL_A_WOL_MAX + 1];
 extern const struct nla_policy ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1];
+extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_MAX + 1];
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1];
+extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_MAX + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1];
+extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1];
+extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
 extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1];
+extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1];
+extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_MAX + 1];
 extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1];
+extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1];
+extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 32f37240e04d..26c73ba987d1 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -140,8 +140,7 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 
 /* PAUSE_SET */
 
-static const struct nla_policy
-pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
+const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_U8 },
@@ -152,18 +151,14 @@ pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_PAUSE_MAX + 1];
 	struct ethtool_pauseparam params = {};
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_PAUSE_MAX,
-			  pause_set_policy, info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_PAUSE_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index c255c75a7ac0..f8164e0f2f87 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -136,8 +136,8 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 
 /* PRIVFLAGS_SET */
 
-static const struct nla_policy
-privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
+const struct nla_policy
+ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
 	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_NESTED },
@@ -145,9 +145,9 @@ privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
 
 int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_PRIVFLAGS_MAX + 1];
 	const char (*names)[ETH_GSTRING_LEN] = NULL;
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
 	unsigned int nflags;
@@ -156,11 +156,6 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
 	u32 flags;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_PRIVFLAGS_MAX, privflags_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	if (!tb[ETHTOOL_A_PRIVFLAGS_FLAGS])
 		return -EINVAL;
 	ret = ethnl_bitset_is_compact(tb[ETHTOOL_A_PRIVFLAGS_FLAGS], &compact);
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 80545845a3c8..73ee664f9b0b 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -107,8 +107,7 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 
 /* RINGS_SET */
 
-static const struct nla_policy
-rings_set_policy[ETHTOOL_A_RINGS_MAX + 1] = {
+const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_MAX + 1] = {
 	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
@@ -123,20 +122,15 @@ rings_set_policy[ETHTOOL_A_RINGS_MAX + 1] = {
 
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *tb[ETHTOOL_A_RINGS_MAX + 1];
 	struct ethtool_ringparam ringparam = {};
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	const struct nlattr *err_attr;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
-			  ETHTOOL_A_RINGS_MAX, rings_set_policy,
-			  info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_RINGS_HEADER],
 					 genl_info_net(info), info->extack,
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 4a88c597890c..a5f396c8c69a 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -99,8 +99,7 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 
 /* WOL_SET */
 
-static const struct nla_policy
-wol_set_policy[ETHTOOL_A_WOL_MAX + 1] = {
+const struct nla_policy ethnl_wol_set_policy[ETHTOOL_A_WOL_MAX + 1] = {
 	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_NESTED },
@@ -111,16 +110,12 @@ wol_set_policy[ETHTOOL_A_WOL_MAX + 1] = {
 int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
 {
 	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
-	struct nlattr *tb[ETHTOOL_A_WOL_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_WOL_MAX,
-			  wol_set_policy, info->extack);
-	if (ret < 0)
-		return ret;
 	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_WOL_HEADER],
 					 genl_info_net(info), info->extack,
 					 true);
-- 
2.26.2

