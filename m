Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FD323D07F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgHETtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgHEQzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:55:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F208DC0A88AC;
        Wed,  5 Aug 2020 07:04:20 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k3K1i-00GoxW-5w; Wed, 05 Aug 2020 16:04:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/4] netlink: consistently use NLA_POLICY_EXACT_LEN()
Date:   Wed,  5 Aug 2020 16:03:21 +0200
Message-Id: <20200805154803.a6de3234b4e3.I3e27f5d489fc497b5d134488b8f3a72b5e3405c8@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200805140324.72855-1-johannes@sipsolutions.net>
References: <20200805140324.72855-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Change places that open-code NLA_POLICY_EXACT_LEN() to
use the macro instead, giving us flexibility in how we
handle the details of the macro.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireguard/netlink.c | 10 +++++-----
 net/bridge/br_netlink.c         |  4 ++--
 net/bridge/br_vlan.c            |  4 ++--
 net/mptcp/pm_netlink.c          |  4 ++--
 net/sched/act_ct.c              |  8 +++-----
 net/sched/act_ctinfo.c          |  5 ++---
 net/sched/act_gate.c            |  4 ++--
 net/wireless/nl80211.c          |  6 ++----
 8 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index 20a4f3c0a0a1..0e6c6eb9384e 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -22,8 +22,8 @@ static struct genl_family genl_family;
 static const struct nla_policy device_policy[WGDEVICE_A_MAX + 1] = {
 	[WGDEVICE_A_IFINDEX]		= { .type = NLA_U32 },
 	[WGDEVICE_A_IFNAME]		= { .type = NLA_NUL_STRING, .len = IFNAMSIZ - 1 },
-	[WGDEVICE_A_PRIVATE_KEY]	= { .type = NLA_EXACT_LEN, .len = NOISE_PUBLIC_KEY_LEN },
-	[WGDEVICE_A_PUBLIC_KEY]		= { .type = NLA_EXACT_LEN, .len = NOISE_PUBLIC_KEY_LEN },
+	[WGDEVICE_A_PRIVATE_KEY]	= NLA_POLICY_EXACT_LEN(NOISE_PUBLIC_KEY_LEN),
+	[WGDEVICE_A_PUBLIC_KEY]		= NLA_POLICY_EXACT_LEN(NOISE_PUBLIC_KEY_LEN),
 	[WGDEVICE_A_FLAGS]		= { .type = NLA_U32 },
 	[WGDEVICE_A_LISTEN_PORT]	= { .type = NLA_U16 },
 	[WGDEVICE_A_FWMARK]		= { .type = NLA_U32 },
@@ -31,12 +31,12 @@ static const struct nla_policy device_policy[WGDEVICE_A_MAX + 1] = {
 };
 
 static const struct nla_policy peer_policy[WGPEER_A_MAX + 1] = {
-	[WGPEER_A_PUBLIC_KEY]				= { .type = NLA_EXACT_LEN, .len = NOISE_PUBLIC_KEY_LEN },
-	[WGPEER_A_PRESHARED_KEY]			= { .type = NLA_EXACT_LEN, .len = NOISE_SYMMETRIC_KEY_LEN },
+	[WGPEER_A_PUBLIC_KEY]				= NLA_POLICY_EXACT_LEN(NOISE_PUBLIC_KEY_LEN),
+	[WGPEER_A_PRESHARED_KEY]			= NLA_POLICY_EXACT_LEN(NOISE_SYMMETRIC_KEY_LEN),
 	[WGPEER_A_FLAGS]				= { .type = NLA_U32 },
 	[WGPEER_A_ENDPOINT]				= { .type = NLA_MIN_LEN, .len = sizeof(struct sockaddr) },
 	[WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL]	= { .type = NLA_U16 },
-	[WGPEER_A_LAST_HANDSHAKE_TIME]			= { .type = NLA_EXACT_LEN, .len = sizeof(struct __kernel_timespec) },
+	[WGPEER_A_LAST_HANDSHAKE_TIME]			= NLA_POLICY_EXACT_LEN(sizeof(struct __kernel_timespec)),
 	[WGPEER_A_RX_BYTES]				= { .type = NLA_U64 },
 	[WGPEER_A_TX_BYTES]				= { .type = NLA_U64 },
 	[WGPEER_A_ALLOWEDIPS]				= { .type = NLA_NESTED },
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 240e260e3461..fd850ae78e15 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1069,8 +1069,8 @@ static const struct nla_policy br_policy[IFLA_BR_MAX + 1] = {
 	[IFLA_BR_MCAST_IGMP_VERSION] = { .type = NLA_U8 },
 	[IFLA_BR_MCAST_MLD_VERSION] = { .type = NLA_U8 },
 	[IFLA_BR_VLAN_STATS_PER_PORT] = { .type = NLA_U8 },
-	[IFLA_BR_MULTI_BOOLOPT] = { .type = NLA_EXACT_LEN,
-				    .len = sizeof(struct br_boolopt_multi) },
+	[IFLA_BR_MULTI_BOOLOPT] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
 };
 
 static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index f9092c71225f..d2b8737f9fc0 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1884,8 +1884,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] = {
-	[BRIDGE_VLANDB_ENTRY_INFO]	= { .type = NLA_EXACT_LEN,
-					    .len = sizeof(struct bridge_vlan_info) },
+	[BRIDGE_VLANDB_ENTRY_INFO]	=
+		NLA_POLICY_EXACT_LEN(sizeof(struct bridge_vlan_info)),
 	[BRIDGE_VLANDB_ENTRY_RANGE]	= { .type = NLA_U16 },
 	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = { .type = NLA_NESTED },
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b78edf237ba0..86291c5aaae5 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -384,8 +384,8 @@ mptcp_pm_addr_policy[MPTCP_PM_ADDR_ATTR_MAX + 1] = {
 	[MPTCP_PM_ADDR_ATTR_FAMILY]	= { .type	= NLA_U16,	},
 	[MPTCP_PM_ADDR_ATTR_ID]		= { .type	= NLA_U8,	},
 	[MPTCP_PM_ADDR_ATTR_ADDR4]	= { .type	= NLA_U32,	},
-	[MPTCP_PM_ADDR_ATTR_ADDR6]	= { .type	= NLA_EXACT_LEN,
-					    .len   = sizeof(struct in6_addr), },
+	[MPTCP_PM_ADDR_ATTR_ADDR6]	=
+		NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[MPTCP_PM_ADDR_ATTR_PORT]	= { .type	= NLA_U16	},
 	[MPTCP_PM_ADDR_ATTR_FLAGS]	= { .type	= NLA_U32	},
 	[MPTCP_PM_ADDR_ATTR_IF_IDX]     = { .type	= NLA_S32	},
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 6ed1652d1e26..a62a86cc06f6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1035,7 +1035,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
 	[TCA_CT_ACTION] = { .type = NLA_U16 },
-	[TCA_CT_PARMS] = { .type = NLA_EXACT_LEN, .len = sizeof(struct tc_ct) },
+	[TCA_CT_PARMS] = NLA_POLICY_EXACT_LEN(sizeof(struct tc_ct)),
 	[TCA_CT_ZONE] = { .type = NLA_U16 },
 	[TCA_CT_MARK] = { .type = NLA_U32 },
 	[TCA_CT_MARK_MASK] = { .type = NLA_U32 },
@@ -1045,10 +1045,8 @@ static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
 				 .len = 128 / BITS_PER_BYTE },
 	[TCA_CT_NAT_IPV4_MIN] = { .type = NLA_U32 },
 	[TCA_CT_NAT_IPV4_MAX] = { .type = NLA_U32 },
-	[TCA_CT_NAT_IPV6_MIN] = { .type = NLA_EXACT_LEN,
-				  .len = sizeof(struct in6_addr) },
-	[TCA_CT_NAT_IPV6_MAX] = { .type = NLA_EXACT_LEN,
-				   .len = sizeof(struct in6_addr) },
+	[TCA_CT_NAT_IPV6_MIN] = NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
+	[TCA_CT_NAT_IPV6_MAX] = NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
 };
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index b5042f3ea079..e88fa19ea8a9 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -144,9 +144,8 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 }
 
 static const struct nla_policy ctinfo_policy[TCA_CTINFO_MAX + 1] = {
-	[TCA_CTINFO_ACT]		  = { .type = NLA_EXACT_LEN,
-					      .len = sizeof(struct
-							    tc_ctinfo) },
+	[TCA_CTINFO_ACT]		  =
+		NLA_POLICY_EXACT_LEN(sizeof(struct tc_ctinfo)),
 	[TCA_CTINFO_ZONE]		  = { .type = NLA_U16 },
 	[TCA_CTINFO_PARMS_DSCP_MASK]	  = { .type = NLA_U32 },
 	[TCA_CTINFO_PARMS_DSCP_STATEMASK] = { .type = NLA_U32 },
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 323ae7f6315d..c93f22e8f02b 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -159,8 +159,8 @@ static const struct nla_policy entry_policy[TCA_GATE_ENTRY_MAX + 1] = {
 };
 
 static const struct nla_policy gate_policy[TCA_GATE_MAX + 1] = {
-	[TCA_GATE_PARMS]		= { .len = sizeof(struct tc_gate),
-					    .type = NLA_EXACT_LEN },
+	[TCA_GATE_PARMS]		=
+		NLA_POLICY_EXACT_LEN(sizeof(struct tc_gate)),
 	[TCA_GATE_PRIORITY]		= { .type = NLA_S32 },
 	[TCA_GATE_ENTRY_LIST]		= { .type = NLA_NESTED },
 	[TCA_GATE_BASE_TIME]		= { .type = NLA_U64 },
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57b989d53064..248e845ebd5b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -659,10 +659,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_RECEIVE_MULTICAST] = { .type = NLA_FLAG },
 	[NL80211_ATTR_WIPHY_FREQ_OFFSET] = NLA_POLICY_RANGE(NLA_U32, 0, 999),
 	[NL80211_ATTR_SCAN_FREQ_KHZ] = { .type = NLA_NESTED },
-	[NL80211_ATTR_HE_6GHZ_CAPABILITY] = {
-		.type = NLA_EXACT_LEN,
-		.len = sizeof(struct ieee80211_he_6ghz_capa),
-	},
+	[NL80211_ATTR_HE_6GHZ_CAPABILITY] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct ieee80211_he_6ghz_capa)),
 };
 
 /* policy for the key attributes */
-- 
2.26.2

