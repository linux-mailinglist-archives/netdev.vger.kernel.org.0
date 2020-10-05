Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635C9284261
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgJEWHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgJEWHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:07:52 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE7E32084C;
        Mon,  5 Oct 2020 22:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601935671;
        bh=/FQJdAnb6yoA74yBsbGIi0DwUgjvdneghOJF2oI8Kvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wd9w1y/NlQgby8UWwKJlZ5ohyi3ZboxYuNNmUh79d+fmmBuaC41hw74bU0auqDVKD
         CUEC0xohJc/5feuFUFyoTVUO8XsDcG4k/8Bw5NWXsiqXjRXn/m96uxl3/LKnvLOlll
         CzwIW0emLcKHQjHx1r8fMNmav6egygVNH/WYXMfU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/7] ethtool: link up ethnl_header_policy as a nested policy
Date:   Mon,  5 Oct 2020 15:07:36 -0700
Message-Id: <20201005220739.2581920-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005220739.2581920-1-kuba@kernel.org>
References: <20201005220739.2581920-1-kuba@kernel.org>
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
index 6f3328be6592..63560bbb7d1f 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -12,7 +12,8 @@
 #define MAX_CABLE_LENGTH_CM (150 * 100)
 
 const struct nla_policy ethnl_cable_test_act_policy[] = {
-	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int ethnl_cable_test_started(struct phy_device *phydev, u8 cmd)
@@ -218,7 +219,8 @@ static const struct nla_policy cable_test_tdr_act_cfg_policy[] = {
 };
 
 const struct nla_policy ethnl_cable_test_tdr_act_policy[] = {
-	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG]		= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 2a0cea0ad648..5635604cb9ba 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -18,7 +18,8 @@ struct channels_reply_data {
 	container_of(__reply_base, struct channels_reply_data, base)
 
 const struct nla_policy ethnl_channels_get_policy[] = {
-	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CHANNELS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int channels_prepare_data(const struct ethnl_req_info *req_base,
@@ -100,7 +101,8 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 /* CHANNELS_SET */
 
 const struct nla_policy ethnl_channels_set_policy[] = {
-	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CHANNELS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_CHANNELS_RX_COUNT]		= { .type = NLA_U32 },
 	[ETHTOOL_A_CHANNELS_TX_COUNT]		= { .type = NLA_U32 },
 	[ETHTOOL_A_CHANNELS_OTHER_COUNT]	= { .type = NLA_U32 },
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index c46d4247403a..1d6bc132aa4d 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -52,7 +52,8 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
 
 const struct nla_policy ethnl_coalesce_get_policy[] = {
-	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_COALESCE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
@@ -190,7 +191,8 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 /* COALESCE_SET */
 
 const struct nla_policy ethnl_coalesce_set_policy[] = {
-	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_COALESCE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RX_USECS_IRQ]	= { .type = NLA_U32 },
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index dbd3243ccae5..f99912d7957e 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -17,7 +17,8 @@ struct debug_reply_data {
 	container_of(__reply_base, struct debug_reply_data, base)
 
 const struct nla_policy ethnl_debug_get_policy[] = {
-	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_DEBUG_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int debug_prepare_data(const struct ethnl_req_info *req_base,
@@ -77,7 +78,8 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 /* DEBUG_SET */
 
 const struct nla_policy ethnl_debug_set_policy[] = {
-	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_DEBUG_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index d40a573d1eba..901b7de941ab 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -20,7 +20,8 @@ struct eee_reply_data {
 	container_of(__reply_base, struct eee_reply_data, base)
 
 const struct nla_policy ethnl_eee_get_policy[] = {
-	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int eee_prepare_data(const struct ethnl_req_info *req_base,
@@ -122,7 +123,8 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 /* EEE_SET */
 
 const struct nla_policy ethnl_eee_set_policy[] = {
-	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_EEE_ENABLED]		= { .type = NLA_U8 },
 	[ETHTOOL_A_EEE_TX_LPI_ENABLED]	= { .type = NLA_U8 },
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 920386cf7d0a..8ee4cdbd6b82 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -21,7 +21,8 @@ struct features_reply_data {
 	container_of(__reply_base, struct features_reply_data, base)
 
 const struct nla_policy ethnl_features_get_policy[] = {
-	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
@@ -125,7 +126,8 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 /* FEATURES_SET */
 
 const struct nla_policy ethnl_features_set_policy[] = {
-	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 0c9161801bc7..b91839870efc 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -17,7 +17,8 @@ struct linkinfo_reply_data {
 	container_of(__reply_base, struct linkinfo_reply_data, base)
 
 const struct nla_policy ethnl_linkinfo_get_policy[] = {
-	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKINFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int linkinfo_prepare_data(const struct ethnl_req_info *req_base,
@@ -87,7 +88,8 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 /* LINKINFO_SET */
 
 const struct nla_policy ethnl_linkinfo_set_policy[] = {
-	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKINFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_U8 },
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index dcef79b6a2d2..c5bcb9abc8b9 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -19,7 +19,8 @@ struct linkmodes_reply_data {
 	container_of(__reply_base, struct linkmodes_reply_data, base)
 
 const struct nla_policy ethnl_linkmodes_get_policy[] = {
-	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
@@ -266,7 +267,8 @@ static const struct link_mode_info link_mode_params[] = {
 };
 
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
-	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index fc36e73d8b7f..fb676f349455 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -21,7 +21,8 @@ struct linkstate_reply_data {
 	container_of(__reply_base, struct linkstate_reply_data, base)
 
 const struct nla_policy ethnl_linkstate_get_policy[] = {
-	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKSTATE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int linkstate_get_sqi(struct net_device *dev)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index dec1185db5ea..57b5bbb7f48f 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -9,7 +9,7 @@ static struct genl_family ethtool_genl_family;
 static bool ethnl_ok __read_mostly;
 static u32 ethnl_bcast_seq;
 
-static const struct nla_policy ethnl_header_policy[] = {
+const struct nla_policy ethnl_header_policy[] = {
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
 					    .len = ALTIFNAMSIZ - 1 },
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 2cfbc016393c..281d793d4557 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
+extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_STRINGSETS + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 084798d629a8..bf4013afd8b2 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -17,7 +17,8 @@ struct pause_reply_data {
 	container_of(__reply_base, struct pause_reply_data, base)
 
 const struct nla_policy ethnl_pause_get_policy[] = {
-	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PAUSE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static void ethtool_stats_init(u64 *stats, unsigned int n)
@@ -135,7 +136,8 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 /* PAUSE_SET */
 
 const struct nla_policy ethnl_pause_set_policy[] = {
-	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PAUSE_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_U8 },
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index 050d3d428a59..fc9f3be23a19 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -19,7 +19,8 @@ struct privflags_reply_data {
 	container_of(__reply_base, struct privflags_reply_data, base)
 
 const struct nla_policy ethnl_privflags_get_policy[] = {
-	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PRIVFLAGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int ethnl_get_priv_flags_info(struct net_device *dev,
@@ -133,7 +134,8 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 /* PRIVFLAGS_SET */
 
 const struct nla_policy ethnl_privflags_set_policy[] = {
-	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PRIVFLAGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index da5d9041b2b1..4e097812a967 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -16,7 +16,8 @@ struct rings_reply_data {
 	container_of(__reply_base, struct rings_reply_data, base)
 
 const struct nla_policy ethnl_rings_get_policy[] = {
-	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_RINGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int rings_prepare_data(const struct ethnl_req_info *req_base,
@@ -98,7 +99,8 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 /* RINGS_SET */
 
 const struct nla_policy ethnl_rings_set_policy[] = {
-	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_RINGS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_RINGS_RX]			= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 02199570c3fc..0734e83c674c 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -100,7 +100,8 @@ struct strset_reply_data {
 	container_of(__reply_base, struct strset_reply_data, base)
 
 const struct nla_policy ethnl_strset_get_policy[] = {
-	[ETHTOOL_A_STRSET_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STRSET_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 6f050b81b77c..63b5814bd460 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -19,7 +19,8 @@ struct tsinfo_reply_data {
 	container_of(__reply_base, struct tsinfo_reply_data, base)
 
 const struct nla_policy ethnl_tsinfo_get_policy[] = {
-	[ETHTOOL_A_TSINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_TSINFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int tsinfo_prepare_data(const struct ethnl_req_info *req_base,
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index 48a52951917e..e7f2ee0d2471 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -9,7 +9,8 @@
 #include "netlink.h"
 
 const struct nla_policy ethnl_tunnel_info_get_policy[] = {
-	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_TUNNEL_INFO_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN == ilog2(UDP_TUNNEL_TYPE_VXLAN));
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 7671089c119d..ada7df2331d2 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -18,7 +18,8 @@ struct wol_reply_data {
 	container_of(__reply_base, struct wol_reply_data, base)
 
 const struct nla_policy ethnl_wol_get_policy[] = {
-	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
 static int wol_prepare_data(const struct ethnl_req_info *req_base,
@@ -96,7 +97,8 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 /* WOL_SET */
 
 const struct nla_policy ethnl_wol_set_policy[] = {
-	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_WOL_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_BINARY,
 					    .len = SOPASS_MAX },
-- 
2.26.2

