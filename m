Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD535283BCA
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgJEP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgJEP6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 595562100A;
        Mon,  5 Oct 2020 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913487;
        bh=0eRoRSZ7j9UMHnlBnA9fTPrkden7f8gFHt/+Dq3j4As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjFSx954so2iOnYaBNsvIKbx9j27cUQiQE4nbg6zRhctDFbGJnT4hq+Yhp7T2fkT/
         BSLdnRCtKC/CMjilNnDj9bWXq8ogSTlaRxiOkfKuYP/9+cECFLD0S4cXPKz2DtbnYP
         TvWOtzxwtN77YjbvgygepZ7i9ajabGt9PpMUS8zw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/6] ethtool: link up ethnl_header_policy as a nested policy
Date:   Mon,  5 Oct 2020 08:57:51 -0700
Message-Id: <20201005155753.2333882-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005155753.2333882-1-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To get the most out of parsing by the core, and to allow dumping
full policies we need to specify which policy applies to nested
attrs. For headers it's ethnl_header_policy.

$ sed -i 's@\(ETHTOOL_A_.*HEADER\].*=\) { .type = NLA_NESTED },@\1\n\t\tNLA_POLICY_NESTED(ethnl_header_policy),@' net/ethtool/*

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/cabletest.c | 6 ++++--
 net/ethtool/channels.c  | 6 ++++--
 net/ethtool/coalesce.c  | 6 ++++--
 net/ethtool/debug.c     | 6 ++++--
 net/ethtool/eee.c       | 6 ++++--
 net/ethtool/features.c  | 6 ++++--
 net/ethtool/linkinfo.c  | 6 ++++--
 net/ethtool/linkmodes.c | 6 ++++--
 net/ethtool/linkstate.c | 3 ++-
 net/ethtool/netlink.c   | 2 +-
 net/ethtool/netlink.h   | 1 +
 net/ethtool/pause.c     | 6 ++++--
 net/ethtool/privflags.c | 6 ++++--
 net/ethtool/rings.c     | 6 ++++--
 net/ethtool/strset.c    | 3 ++-
 net/ethtool/tsinfo.c    | 3 ++-
 net/ethtool/tunnels.c   | 3 ++-
 net/ethtool/wol.c       | 6 ++++--
 18 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index beb85e0b7fc6..17019ed74a02 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -14,7 +14,8 @@
 const struct nla_policy
 ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int ethnl_cable_test_started(struct phy_device *phydev, u8 cmd)
@@ -223,7 +224,8 @@ cable_test_tdr_act_cfg_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1] = {
 const struct nla_policy
 ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG]		= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 7e14e93adedb..dbbe2dcb21d6 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -20,7 +20,8 @@ struct channels_reply_data {
 const struct nla_policy
 ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
 	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CHANNELS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_TX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_OTHER_MAX]		= { .type = NLA_REJECT },
@@ -113,7 +114,8 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 const struct nla_policy
 ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
 	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CHANNELS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_TX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_OTHER_MAX]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 261ef40f7f98..15adc9861421 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -54,7 +54,8 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
 const struct nla_policy
 ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
 	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_COALESCE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_COALESCE_RX_USECS_IRQ]	= { .type = NLA_REJECT },
@@ -217,7 +218,8 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 const struct nla_policy
 ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
 	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_COALESCE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RX_USECS_IRQ]	= { .type = NLA_U32 },
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index 33a4126ed80d..b72980698ecb 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -18,7 +18,8 @@ struct debug_reply_data {
 
 const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
 	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_DEBUG_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_REJECT },
 };
 
@@ -81,7 +82,8 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 
 const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
 	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_DEBUG_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 25b99f1cfe12..646456d5d78a 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -21,7 +21,8 @@ struct eee_reply_data {
 
 const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
 	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_MODES_PEER]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_ACTIVE]		= { .type = NLA_REJECT },
@@ -131,7 +132,8 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 
 const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_MAX + 1] = {
 	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_EEE_MODES_PEER]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_ACTIVE]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 00c5b77852ec..63ead0ca9eac 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -23,7 +23,8 @@ struct features_reply_data {
 const struct nla_policy
 ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
 	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_ACTIVE]	= { .type = NLA_REJECT },
@@ -134,7 +135,8 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 const struct nla_policy
 ethnl_features_set_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
 	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_FEATURES_ACTIVE]	= { .type = NLA_REJECT },
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index eb801271b9bc..9d66679b3e21 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -19,7 +19,8 @@ struct linkinfo_reply_data {
 const struct nla_policy
 ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
 	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKINFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
@@ -97,7 +98,8 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 const struct nla_policy
 ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
 	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKINFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index b5f061f192b9..951ab02e688e 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -21,7 +21,8 @@ struct linkmodes_reply_data {
 const struct nla_policy
 ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
@@ -278,7 +279,8 @@ static const struct link_mode_info link_mode_params[] = {
 const struct nla_policy
 ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 3f0ab6e84fce..ed713552029c 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -23,7 +23,8 @@ struct linkstate_reply_data {
 const struct nla_policy
 ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKSTATE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI_MAX]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index f2d197e6c9d0..e78ff7ce2a7d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -9,7 +9,7 @@ static struct genl_family ethtool_genl_family;
 static bool ethnl_ok __read_mostly;
 static u32 ethnl_bcast_seq;
 
-static const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
+const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
 	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 53eeda056441..4fcd2e8b259b 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,6 +347,7 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
+extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1];
 extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 26c73ba987d1..a7fbe0e4dca6 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -18,7 +18,8 @@ struct pause_reply_data {
 
 const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PAUSE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_REJECT },
@@ -142,7 +143,8 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 
 const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PAUSE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_U8 },
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index f8164e0f2f87..4a77a8a547f7 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -21,7 +21,8 @@ struct privflags_reply_data {
 const struct nla_policy
 ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
 	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PRIVFLAGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_REJECT },
 };
 
@@ -139,7 +140,8 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 const struct nla_policy
 ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
 	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PRIVFLAGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 73ee664f9b0b..142d0902293a 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -17,7 +17,8 @@ struct rings_reply_data {
 
 const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
 	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_RINGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_RX_MINI_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_RX_JUMBO_MAX]		= { .type = NLA_REJECT },
@@ -109,7 +110,8 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 
 const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_MAX + 1] = {
 	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_RINGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_RX_MINI_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_RX_JUMBO_MAX]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index e893f98505d0..8aec735216ca 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -101,7 +101,8 @@ struct strset_reply_data {
 
 const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
 	[ETHTOOL_A_STRSET_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_STRSET_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STRSET_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 185333d377c9..8a26e1620083 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -20,7 +20,8 @@ struct tsinfo_reply_data {
 
 const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
 	[ETHTOOL_A_TSINFO_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_TSINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_TSINFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_TSINFO_TIMESTAMPING]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_TSINFO_TX_TYPES]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_TSINFO_RX_FILTERS]		= { .type = NLA_REJECT },
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index 330817adcf62..734e12147d34 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -11,7 +11,8 @@
 const struct nla_policy
 ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
 	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_TUNNEL_INFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN == ilog2(UDP_TUNNEL_TYPE_VXLAN));
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index a5f396c8c69a..0e1aa6acb4aa 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -19,7 +19,8 @@ struct wol_reply_data {
 
 const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
 	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_REJECT },
 };
@@ -101,7 +102,8 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 
 const struct nla_policy ethnl_wol_set_policy[ETHTOOL_A_WOL_MAX + 1] = {
 	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_BINARY,
 					    .len = SOPASS_MAX },
-- 
2.26.2

