Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B874284264
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgJEWIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgJEWHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:07:52 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD292080A;
        Mon,  5 Oct 2020 22:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601935670;
        bh=l8cpmkkzoNyRmCxNGh+CFm4+X9smLbU7Txabpuj4sxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqqnc88/8AeYQckLXZe+5QTof+Sve3aMXZg1kCz0tI5XoJGoTNGdu8Fh5coNbM8DL
         jGU/aymsNdkTboEGw9d7UdIERr+9O+WeUFvSngM4hQBWFpe2Lgnof17DU+QZq6id54
         ir9x77CeVF/BCiwIcWYj+vOZ25NUsmAu0vFFi6fM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/7] ethtool: trim policy tables
Date:   Mon,  5 Oct 2020 15:07:35 -0700
Message-Id: <20201005220739.2581920-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005220739.2581920-1-kuba@kernel.org>
References: <20201005220739.2581920-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ethtool uses strict attribute validation there's no need
to initialize all attributes in policy tables. 0 is NLA_UNSPEC
which is going to be rejected. Remove the NLA_REJECTs.

Similarly attributes above maxattrs are rejected, so there's
no need to always size the policy tables to ETHTOOL_A_..._MAX.

v2: - new patch

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/bitset.c    | 26 +++++++++----------
 net/ethtool/cabletest.c | 19 ++++++--------
 net/ethtool/channels.c  | 20 ++-------------
 net/ethtool/coalesce.c  | 30 ++--------------------
 net/ethtool/debug.c     |  7 ++----
 net/ethtool/eee.c       | 14 ++---------
 net/ethtool/features.c  | 15 ++---------
 net/ethtool/linkinfo.c  | 15 ++---------
 net/ethtool/linkmodes.c | 17 ++-----------
 net/ethtool/linkstate.c |  9 +------
 net/ethtool/netlink.c   |  7 +++---
 net/ethtool/netlink.h   | 56 ++++++++++++++++++++---------------------
 net/ethtool/pause.c     | 11 ++------
 net/ethtool/privflags.c |  9 ++-----
 net/ethtool/rings.c     | 18 ++-----------
 net/ethtool/strset.c    | 20 ++++++---------
 net/ethtool/tsinfo.c    |  7 +-----
 net/ethtool/tunnels.c   |  4 +--
 net/ethtool/wol.c       |  8 ++----
 19 files changed, 83 insertions(+), 229 deletions(-)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index dae7402eaca3..1fb3603d92ad 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -302,8 +302,7 @@ int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
 	return -EMSGSIZE;
 }
 
-static const struct nla_policy bitset_policy[ETHTOOL_A_BITSET_MAX + 1] = {
-	[ETHTOOL_A_BITSET_UNSPEC]	= { .type = NLA_REJECT },
+static const struct nla_policy bitset_policy[] = {
 	[ETHTOOL_A_BITSET_NOMASK]	= { .type = NLA_FLAG },
 	[ETHTOOL_A_BITSET_SIZE]		= NLA_POLICY_MAX(NLA_U32,
 							 ETHNL_MAX_BITSET_SIZE),
@@ -312,8 +311,7 @@ static const struct nla_policy bitset_policy[ETHTOOL_A_BITSET_MAX + 1] = {
 	[ETHTOOL_A_BITSET_MASK]		= { .type = NLA_BINARY },
 };
 
-static const struct nla_policy bit_policy[ETHTOOL_A_BITSET_BIT_MAX + 1] = {
-	[ETHTOOL_A_BITSET_BIT_UNSPEC]	= { .type = NLA_REJECT },
+static const struct nla_policy bit_policy[] = {
 	[ETHTOOL_A_BITSET_BIT_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_BITSET_BIT_NAME]	= { .type = NLA_NUL_STRING },
 	[ETHTOOL_A_BITSET_BIT_VALUE]	= { .type = NLA_FLAG },
@@ -329,10 +327,10 @@ static const struct nla_policy bit_policy[ETHTOOL_A_BITSET_BIT_MAX + 1] = {
  */
 int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact)
 {
-	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(bitset_policy)];
 	int ret;
 
-	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, bitset,
+	ret = nla_parse_nested(tb, ARRAY_SIZE(bitset_policy) - 1, bitset,
 			       bitset_policy, NULL);
 	if (ret < 0)
 		return ret;
@@ -381,10 +379,10 @@ static int ethnl_parse_bit(unsigned int *index, bool *val, unsigned int nbits,
 			   ethnl_string_array_t names,
 			   struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(bit_policy)];
 	int ret, idx;
 
-	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_BIT_MAX, bit_attr,
+	ret = nla_parse_nested(tb, ARRAY_SIZE(bit_policy) - 1, bit_attr,
 			       bit_policy, extack);
 	if (ret < 0)
 		return ret;
@@ -555,15 +553,15 @@ int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
 			  const struct nlattr *attr, ethnl_string_array_t names,
 			  struct netlink_ext_ack *extack, bool *mod)
 {
-	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(bitset_policy)];
 	unsigned int change_bits;
 	bool no_mask;
 	int ret;
 
 	if (!attr)
 		return 0;
-	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, attr, bitset_policy,
-			       extack);
+	ret = nla_parse_nested(tb, ARRAY_SIZE(bitset_policy) - 1, attr,
+			       bitset_policy, extack);
 	if (ret < 0)
 		return ret;
 
@@ -608,7 +606,7 @@ int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
 		       ethnl_string_array_t names,
 		       struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(bitset_policy)];
 	const struct nlattr *bit_attr;
 	bool no_mask;
 	int rem;
@@ -616,8 +614,8 @@ int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
 
 	if (!attr)
 		return 0;
-	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, attr, bitset_policy,
-			       extack);
+	ret = nla_parse_nested(tb, ARRAY_SIZE(bitset_policy) - 1, attr,
+			       bitset_policy, extack);
 	if (ret < 0)
 		return ret;
 	no_mask = tb[ETHTOOL_A_BITSET_NOMASK];
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index beb85e0b7fc6..6f3328be6592 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -11,9 +11,7 @@
  */
 #define MAX_CABLE_LENGTH_CM (150 * 100)
 
-const struct nla_policy
-ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
-	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_cable_test_act_policy[] = {
 	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
 };
 
@@ -212,17 +210,14 @@ struct cable_test_tdr_req_info {
 	struct ethnl_req_info		base;
 };
 
-static const struct nla_policy
-cable_test_tdr_act_cfg_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1] = {
+static const struct nla_policy cable_test_tdr_act_cfg_policy[] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST]	= { .type = NLA_U32 },
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST]	= { .type = NLA_U32 },
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP]	= { .type = NLA_U32 },
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]	= { .type = NLA_U8 },
 };
 
-const struct nla_policy
-ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
-	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
+const struct nla_policy ethnl_cable_test_tdr_act_policy[] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_CABLE_TEST_TDR_CFG]		= { .type = NLA_NESTED },
 };
@@ -232,7 +227,7 @@ static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
 					struct genl_info *info,
 					struct phy_tdr_config *cfg)
 {
-	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(cable_test_tdr_act_cfg_policy)];
 	int ret;
 
 	cfg->first = 100;
@@ -243,8 +238,10 @@ static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
 	if (!nest)
 		return 0;
 
-	ret = nla_parse_nested(tb, ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX, nest,
-			       cable_test_tdr_act_cfg_policy, info->extack);
+	ret = nla_parse_nested(tb,
+			       ARRAY_SIZE(cable_test_tdr_act_cfg_policy) - 1,
+			       nest, cable_test_tdr_act_cfg_policy,
+			       info->extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 52227c6dcb59..2a0cea0ad648 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -17,18 +17,8 @@ struct channels_reply_data {
 #define CHANNELS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct channels_reply_data, base)
 
-const struct nla_policy
-ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
-	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_channels_get_policy[] = {
 	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_TX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_OTHER_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_COMBINED_MAX]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_RX_COUNT]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_TX_COUNT]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_OTHER_COUNT]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_COMBINED_COUNT]	= { .type = NLA_REJECT },
 };
 
 static int channels_prepare_data(const struct ethnl_req_info *req_base,
@@ -109,14 +99,8 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 
 /* CHANNELS_SET */
 
-const struct nla_policy
-ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
-	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_channels_set_policy[] = {
 	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_TX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_OTHER_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_CHANNELS_COMBINED_MAX]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_RX_COUNT]		= { .type = NLA_U32 },
 	[ETHTOOL_A_CHANNELS_TX_COUNT]		= { .type = NLA_U32 },
 	[ETHTOOL_A_CHANNELS_OTHER_COUNT]	= { .type = NLA_U32 },
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 728cfe5cd527..c46d4247403a 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -51,32 +51,8 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
 
-const struct nla_policy
-ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
-	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_coalesce_get_policy[] = {
 	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_USECS_IRQ]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_USECS]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_USECS_IRQ]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_PKT_RATE_LOW]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_USECS_LOW]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_USECS_LOW]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_PKT_RATE_HIGH]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_USECS_HIGH]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_REJECT },
 };
 
 static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
@@ -213,9 +189,7 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 
 /* COALESCE_SET */
 
-const struct nla_policy
-ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
-	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_U32 },
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index 0f40fc921546..dbd3243ccae5 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -16,10 +16,8 @@ struct debug_reply_data {
 #define DEBUG_REPDATA(__reply_base) \
 	container_of(__reply_base, struct debug_reply_data, base)
 
-const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
-	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
+const struct nla_policy ethnl_debug_get_policy[] = {
 	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
-	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_REJECT },
 };
 
 static int debug_prepare_data(const struct ethnl_req_info *req_base,
@@ -78,8 +76,7 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 
 /* DEBUG_SET */
 
-const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
-	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
+const struct nla_policy ethnl_debug_set_policy[] = {
 	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_NESTED },
 };
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 6e35a041869b..d40a573d1eba 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -19,15 +19,8 @@ struct eee_reply_data {
 #define EEE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eee_reply_data, base)
 
-const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
-	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_eee_get_policy[] = {
 	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_MODES_PEER]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_ACTIVE]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_ENABLED]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_TX_LPI_ENABLED]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_TX_LPI_TIMER]	= { .type = NLA_REJECT },
 };
 
 static int eee_prepare_data(const struct ethnl_req_info *req_base,
@@ -128,12 +121,9 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 
 /* EEE_SET */
 
-const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_MAX + 1] = {
-	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_eee_set_policy[] = {
 	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_NESTED },
-	[ETHTOOL_A_EEE_MODES_PEER]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_EEE_ACTIVE]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_ENABLED]		= { .type = NLA_U8 },
 	[ETHTOOL_A_EEE_TX_LPI_ENABLED]	= { .type = NLA_U8 },
 	[ETHTOOL_A_EEE_TX_LPI_TIMER]	= { .type = NLA_U32 },
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index e4a91d86824d..920386cf7d0a 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -20,14 +20,8 @@ struct features_reply_data {
 #define FEATURES_REPDATA(__reply_base) \
 	container_of(__reply_base, struct features_reply_data, base)
 
-const struct nla_policy
-ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
-	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
+const struct nla_policy ethnl_features_get_policy[] = {
 	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
-	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_FEATURES_ACTIVE]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_FEATURES_NOCHANGE]	= { .type = NLA_REJECT },
 };
 
 static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
@@ -130,14 +124,9 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 
 /* FEATURES_SET */
 
-const struct nla_policy
-ethnl_features_set_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
-	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
+const struct nla_policy ethnl_features_set_policy[] = {
 	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
-	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
-	[ETHTOOL_A_FEATURES_ACTIVE]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_FEATURES_NOCHANGE]	= { .type = NLA_REJECT },
 };
 
 static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index ba66ca54b9c2..0c9161801bc7 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -16,15 +16,8 @@ struct linkinfo_reply_data {
 #define LINKINFO_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkinfo_reply_data, base)
 
-const struct nla_policy
-ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
-	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_linkinfo_get_policy[] = {
 	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKINFO_TRANSCEIVER]	= { .type = NLA_REJECT },
 };
 
 static int linkinfo_prepare_data(const struct ethnl_req_info *req_base,
@@ -93,15 +86,11 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 
 /* LINKINFO_SET */
 
-const struct nla_policy
-ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
-	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_linkinfo_set_policy[] = {
 	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_U8 },
-	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_U8 },
-	[ETHTOOL_A_LINKINFO_TRANSCEIVER]	= { .type = NLA_REJECT },
 };
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 77f0096bda2c..dcef79b6a2d2 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -18,17 +18,8 @@ struct linkmodes_reply_data {
 #define LINKMODES_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkmodes_reply_data, base)
 
-const struct nla_policy
-ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
-	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_linkmodes_get_policy[] = {
 	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE]	= { .type = NLA_REJECT },
 };
 
 static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
@@ -274,17 +265,13 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
 };
 
-const struct nla_policy
-ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
-	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_linkmodes_set_policy[] = {
 	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
-	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE]	= { .type = NLA_REJECT },
 };
 
 /* Set advertised link modes to all supported modes matching requested speed
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index ebd6dcff1dad..fc36e73d8b7f 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -20,15 +20,8 @@ struct linkstate_reply_data {
 #define LINKSTATE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkstate_reply_data, base)
 
-const struct nla_policy
-ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
-	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_linkstate_get_policy[] = {
 	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKSTATE_SQI_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKSTATE_EXT_STATE]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]	= { .type = NLA_REJECT },
 };
 
 static int linkstate_get_sqi(struct net_device *dev)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index be6fd358114c..dec1185db5ea 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -9,8 +9,7 @@ static struct genl_family ethtool_genl_family;
 static bool ethnl_ok __read_mostly;
 static u32 ethnl_bcast_seq;
 
-static const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
-	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
+static const struct nla_policy ethnl_header_policy[] = {
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
 					    .len = ALTIFNAMSIZ - 1 },
@@ -37,7 +36,7 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 			       const struct nlattr *header, struct net *net,
 			       struct netlink_ext_ack *extack, bool require_dev)
 {
-	struct nlattr *tb[ETHTOOL_A_HEADER_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(ethnl_header_policy)];
 	const struct nlattr *devname_attr;
 	struct net_device *dev = NULL;
 	u32 flags = 0;
@@ -47,7 +46,7 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		NL_SET_ERR_MSG(extack, "request header missing");
 		return -EINVAL;
 	}
-	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, header,
+	ret = nla_parse_nested(tb, ARRAY_SIZE(ethnl_header_policy) - 1, header,
 			       ethnl_header_policy, extack);
 	if (ret < 0)
 		return ret;
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 7fee8ba81ef5..2cfbc016393c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,34 +345,34 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
-extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1];
-extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1];
-extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1];
-extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1];
-extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1];
-extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1];
-extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1];
-extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MAX + 1];
-extern const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1];
-extern const struct nla_policy ethnl_wol_set_policy[ETHTOOL_A_WOL_MAX + 1];
-extern const struct nla_policy ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1];
-extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_MAX + 1];
-extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1];
-extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1];
-extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_MAX + 1];
-extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1];
-extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1];
-extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1];
-extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
-extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1];
-extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1];
-extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1];
-extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_MAX + 1];
-extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1];
-extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1];
-extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
-extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1];
+extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_STRINGSETS + 1];
+extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
+extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
+extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG + 1];
+extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_HEADER + 1];
+extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_HEADER + 1];
+extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MSGMASK + 1];
+extern const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_HEADER + 1];
+extern const struct nla_policy ethnl_wol_set_policy[ETHTOOL_A_WOL_SOPASS + 1];
+extern const struct nla_policy ethnl_features_get_policy[ETHTOOL_A_FEATURES_HEADER + 1];
+extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANTED + 1];
+extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
+extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
+extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
+extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
+extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
+extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
+extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL + 1];
+extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
+extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
+extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
+extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_TX_LPI_TIMER + 1];
+extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER + 1];
+extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
+extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
+extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index ff54e3ca030d..084798d629a8 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -16,13 +16,8 @@ struct pause_reply_data {
 #define PAUSE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct pause_reply_data, base)
 
-const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
-	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_pause_get_policy[] = {
 	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_REJECT },
-	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_REJECT },
-	[ETHTOOL_A_PAUSE_STATS]			= { .type = NLA_REJECT },
 };
 
 static void ethtool_stats_init(u64 *stats, unsigned int n)
@@ -139,13 +134,11 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 
 /* PAUSE_SET */
 
-const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
-	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_pause_set_policy[] = {
 	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_U8 },
-	[ETHTOOL_A_PAUSE_STATS]			= { .type = NLA_REJECT },
 };
 
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index fd3754ca83e1..050d3d428a59 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -18,11 +18,8 @@ struct privflags_reply_data {
 #define PRIVFLAGS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct privflags_reply_data, base)
 
-const struct nla_policy
-ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
-	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_privflags_get_policy[] = {
 	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_REJECT },
 };
 
 static int ethnl_get_priv_flags_info(struct net_device *dev,
@@ -135,9 +132,7 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 
 /* PRIVFLAGS_SET */
 
-const struct nla_policy
-ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
-	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_privflags_set_policy[] = {
 	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_NESTED },
 };
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 7e25127a727c..da5d9041b2b1 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -15,17 +15,8 @@ struct rings_reply_data {
 #define RINGS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct rings_reply_data, base)
 
-const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
-	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_rings_get_policy[] = {
 	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX_MINI_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX_JUMBO_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_TX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX]			= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_REJECT },
 };
 
 static int rings_prepare_data(const struct ethnl_req_info *req_base,
@@ -106,13 +97,8 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 
 /* RINGS_SET */
 
-const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_MAX + 1] = {
-	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX_MINI_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_RX_JUMBO_MAX]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_RINGS_TX_MAX]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_RX]			= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 9adff4668004..02199570c3fc 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -99,18 +99,13 @@ struct strset_reply_data {
 #define STRSET_REPDATA(__reply_base) \
 	container_of(__reply_base, struct strset_reply_data, base)
 
-const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
-	[ETHTOOL_A_STRSET_UNSPEC]	= { .type = NLA_REJECT },
+const struct nla_policy ethnl_strset_get_policy[] = {
 	[ETHTOOL_A_STRSET_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
 };
 
-static const struct nla_policy
-get_stringset_policy[ETHTOOL_A_STRINGSET_MAX + 1] = {
-	[ETHTOOL_A_STRINGSET_UNSPEC]	= { .type = NLA_REJECT },
+static const struct nla_policy get_stringset_policy[] = {
 	[ETHTOOL_A_STRINGSET_ID]	= { .type = NLA_U32 },
-	[ETHTOOL_A_STRINGSET_COUNT]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_STRINGSET_STRINGS]	= { .type = NLA_REJECT },
 };
 
 /**
@@ -138,10 +133,10 @@ static bool strset_include(const struct strset_req_info *info,
 static int strset_get_id(const struct nlattr *nest, u32 *val,
 			 struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[ETHTOOL_A_STRINGSET_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(get_stringset_policy)];
 	int ret;
 
-	ret = nla_parse_nested(tb, ETHTOOL_A_STRINGSET_MAX, nest,
+	ret = nla_parse_nested(tb, ARRAY_SIZE(get_stringset_policy) - 1, nest,
 			       get_stringset_policy, extack);
 	if (ret < 0)
 		return ret;
@@ -152,9 +147,7 @@ static int strset_get_id(const struct nlattr *nest, u32 *val,
 	return 0;
 }
 
-static const struct nla_policy
-strset_stringsets_policy[ETHTOOL_A_STRINGSETS_MAX + 1] = {
-	[ETHTOOL_A_STRINGSETS_UNSPEC]		= { .type = NLA_REJECT },
+static const struct nla_policy strset_stringsets_policy[] = {
 	[ETHTOOL_A_STRINGSETS_STRINGSET]	= { .type = NLA_NESTED },
 };
 
@@ -169,7 +162,8 @@ static int strset_parse_request(struct ethnl_req_info *req_base,
 
 	if (!nest)
 		return 0;
-	ret = nla_validate_nested(nest, ETHTOOL_A_STRINGSETS_MAX,
+	ret = nla_validate_nested(nest,
+				  ARRAY_SIZE(strset_stringsets_policy) - 1,
 				  strset_stringsets_policy, extack);
 	if (ret < 0)
 		return ret;
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 21f0dc08cead..6f050b81b77c 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -18,13 +18,8 @@ struct tsinfo_reply_data {
 #define TSINFO_REPDATA(__reply_base) \
 	container_of(__reply_base, struct tsinfo_reply_data, base)
 
-const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
-	[ETHTOOL_A_TSINFO_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_tsinfo_get_policy[] = {
 	[ETHTOOL_A_TSINFO_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_TSINFO_TIMESTAMPING]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_TSINFO_TX_TYPES]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_TSINFO_RX_FILTERS]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_TSINFO_PHC_INDEX]		= { .type = NLA_REJECT },
 };
 
 static int tsinfo_prepare_data(const struct ethnl_req_info *req_base,
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index 330817adcf62..48a52951917e 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -8,9 +8,7 @@
 #include "common.h"
 #include "netlink.h"
 
-const struct nla_policy
-ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
-	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_tunnel_info_get_policy[] = {
 	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
 };
 
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 5a306ffadffe..7671089c119d 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -17,11 +17,8 @@ struct wol_reply_data {
 #define WOL_REPDATA(__reply_base) \
 	container_of(__reply_base, struct wol_reply_data, base)
 
-const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
-	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_wol_get_policy[] = {
 	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
-	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_REJECT },
-	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_REJECT },
 };
 
 static int wol_prepare_data(const struct ethnl_req_info *req_base,
@@ -98,8 +95,7 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 
 /* WOL_SET */
 
-const struct nla_policy ethnl_wol_set_policy[ETHTOOL_A_WOL_MAX + 1] = {
-	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
+const struct nla_policy ethnl_wol_set_policy[] = {
 	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_SOPASS]		= { .type = NLA_BINARY,
-- 
2.26.2

