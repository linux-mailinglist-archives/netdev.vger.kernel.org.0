Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002701C0797
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD3UNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbgD3UNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:13:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EDAC035494;
        Thu, 30 Apr 2020 13:13:25 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jUFYh-002qzz-FJ; Thu, 30 Apr 2020 22:13:23 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 6/8] netlink: remove NLA_EXACT_LEN_WARN
Date:   Thu, 30 Apr 2020 22:13:10 +0200
Message-Id: <20200430221106.370aafeaec9f.I9a91078267348ef563217cb525e8e357eba4b487@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430201312.60143-1-johannes@sipsolutions.net>
References: <20200430201312.60143-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Use a validation type instead, so we can later expose
the NLA_* values to userspace for policy descriptions.

Some transformations were done with this spatch:

    @@
    identifier p;
    expression X, L, A;
    @@
    struct nla_policy p[X] = {
    [A] =
    -{ .type = NLA_EXACT_LEN_WARN, .len = L },
    +NLA_POLICY_EXACT_LEN_WARN(L),
    ...
    };

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h  | 15 ++++----
 lib/nlattr.c           | 16 +++++----
 net/wireless/nl80211.c | 81 ++++++++++--------------------------------
 3 files changed, 36 insertions(+), 76 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4acd7165e900..4d4a733f1e8d 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -182,7 +182,6 @@ enum {
 	NLA_BITFIELD32,
 	NLA_REJECT,
 	NLA_EXACT_LEN,
-	NLA_EXACT_LEN_WARN,
 	NLA_MIN_LEN,
 	__NLA_TYPE_MAX,
 };
@@ -204,6 +203,7 @@ enum nla_policy_validation {
 	NLA_VALIDATE_MAX,
 	NLA_VALIDATE_RANGE_PTR,
 	NLA_VALIDATE_FUNCTION,
+	NLA_VALIDATE_WARN_TOO_LONG,
 };
 
 /**
@@ -237,10 +237,10 @@ enum nla_policy_validation {
  *                         just like "All other"
  *    NLA_BITFIELD32       Unused
  *    NLA_REJECT           Unused
- *    NLA_EXACT_LEN        Attribute must have exactly this length, otherwise
- *                         it is rejected.
- *    NLA_EXACT_LEN_WARN   Attribute should have exactly this length, a warning
- *                         is logged if it is longer, shorter is rejected.
+ *    NLA_EXACT_LEN        Attribute should have exactly this length, otherwise
+ *                         it is rejected or warned about, the latter happening
+ *                         if and only if the `validation_type' is set to
+ *                         NLA_VALIDATE_WARN_TOO_LONG.
  *    NLA_MIN_LEN          Minimum length of attribute payload
  *    All other            Minimum length of attribute payload
  *
@@ -350,8 +350,9 @@ struct nla_policy {
 };
 
 #define NLA_POLICY_EXACT_LEN(_len)	{ .type = NLA_EXACT_LEN, .len = _len }
-#define NLA_POLICY_EXACT_LEN_WARN(_len)	{ .type = NLA_EXACT_LEN_WARN, \
-					  .len = _len }
+#define NLA_POLICY_EXACT_LEN_WARN(_len) \
+	{ .type = NLA_EXACT_LEN, .len = _len, \
+	  .validation_type = NLA_VALIDATE_WARN_TOO_LONG, }
 #define NLA_POLICY_MIN_LEN(_len)	{ .type = NLA_MIN_LEN, .len = _len }
 
 #define NLA_POLICY_ETH_ADDR		NLA_POLICY_EXACT_LEN(ETH_ALEN)
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 21ef3998b9d9..6dcbe1bedd3b 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -261,7 +261,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	BUG_ON(pt->type > NLA_TYPE_MAX);
 
 	if ((nla_attr_len[pt->type] && attrlen != nla_attr_len[pt->type]) ||
-	    (pt->type == NLA_EXACT_LEN_WARN && attrlen != pt->len)) {
+	    (pt->type == NLA_EXACT_LEN &&
+	     pt->validation_type == NLA_VALIDATE_WARN_TOO_LONG &&
+	     attrlen != pt->len)) {
 		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
 				    current->comm, type);
 		if (validate & NL_VALIDATE_STRICT_ATTRS) {
@@ -287,11 +289,6 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	}
 
 	switch (pt->type) {
-	case NLA_EXACT_LEN:
-		if (attrlen != pt->len)
-			goto out_err;
-		break;
-
 	case NLA_REJECT:
 		if (extack && pt->reject_message) {
 			NL_SET_BAD_ATTR(extack, nla);
@@ -405,6 +402,13 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 		break;
 
+	case NLA_EXACT_LEN:
+		if (pt->validation_type != NLA_VALIDATE_WARN_TOO_LONG) {
+			if (attrlen != pt->len)
+				goto out_err;
+			break;
+		}
+		/* fall through */
 	default:
 		if (pt->len)
 			minlen = pt->len;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57c618b6cb0e..519414468b5d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -376,11 +376,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
-	[NL80211_ATTR_MAC] = { .type = NLA_EXACT_LEN_WARN, .len = ETH_ALEN },
-	[NL80211_ATTR_PREV_BSSID] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_ATTR_MAC] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
+	[NL80211_ATTR_PREV_BSSID] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 
 	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
@@ -432,10 +429,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
 
-	[NL80211_ATTR_HT_CAPABILITY] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = NL80211_HT_CAPABILITY_LEN
-	},
+	[NL80211_ATTR_HT_CAPABILITY] = NLA_POLICY_EXACT_LEN_WARN(NL80211_HT_CAPABILITY_LEN),
 
 	[NL80211_ATTR_MGMT_SUBTYPE] = { .type = NLA_U8 },
 	[NL80211_ATTR_IE] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
@@ -466,10 +460,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
 	[NL80211_ATTR_4ADDR] = { .type = NLA_U8 },
-	[NL80211_ATTR_PMKID] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = WLAN_PMKID_LEN
-	},
+	[NL80211_ATTR_PMKID] = NLA_POLICY_EXACT_LEN_WARN(WLAN_PMKID_LEN),
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
@@ -533,10 +524,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_AUTH_DATA] = { .type = NLA_BINARY, },
-	[NL80211_ATTR_VHT_CAPABILITY] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = NL80211_VHT_CAPABILITY_LEN
-	},
+	[NL80211_ATTR_VHT_CAPABILITY] = NLA_POLICY_EXACT_LEN_WARN(NL80211_VHT_CAPABILITY_LEN),
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 	[NL80211_ATTR_P2P_CTWINDOW] = NLA_POLICY_MAX(NLA_U8, 127),
 	[NL80211_ATTR_P2P_OPPPS] = NLA_POLICY_MAX(NLA_U8, 1),
@@ -574,10 +562,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
-	[NL80211_ATTR_MAC_HINT] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_ATTR_MAC_HINT] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
 	[NL80211_ATTR_SOCKET_OWNER] = { .type = NLA_FLAG },
@@ -589,10 +574,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_OPER_CLASS] = { .type = NLA_U8 },
-	[NL80211_ATTR_MAC_MASK] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_ATTR_MAC_MASK] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
@@ -604,21 +586,15 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MU_MIMO_GROUP_DATA] = {
 		.len = VHT_MUMIMO_GROUPS_DATA_LEN
 	},
-	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_ATTR_NAN_MASTER_PREF] = NLA_POLICY_MIN(NLA_U8, 1),
 	[NL80211_ATTR_BANDS] = { .type = NLA_U32 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
 	[NL80211_ATTR_FILS_KEK] = { .type = NLA_BINARY,
 				    .len = FILS_MAX_KEK_LEN },
-	[NL80211_ATTR_FILS_NONCES] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = 2 * FILS_NONCE_LEN
-	},
+	[NL80211_ATTR_FILS_NONCES] = NLA_POLICY_EXACT_LEN_WARN(2 * FILS_NONCE_LEN),
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
-	[NL80211_ATTR_BSSID] = { .type = NLA_EXACT_LEN_WARN, .len = ETH_ALEN },
+	[NL80211_ATTR_BSSID] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] = { .type = NLA_S8 },
 	[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST] = {
 		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
@@ -631,7 +607,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] = { .type = NLA_U16 },
 	[NL80211_ATTR_FILS_ERP_RRK] = { .type = NLA_BINARY,
 					.len = FILS_ERP_MAX_RRK_LEN },
-	[NL80211_ATTR_FILS_CACHE_ID] = { .type = NLA_EXACT_LEN_WARN, .len = 2 },
+	[NL80211_ATTR_FILS_CACHE_ID] = NLA_POLICY_EXACT_LEN_WARN(2),
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
 	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
 	[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT] = { .type = NLA_FLAG },
@@ -701,10 +677,7 @@ static const struct nla_policy
 nl80211_wowlan_tcp_policy[NUM_NL80211_WOWLAN_TCP] = {
 	[NL80211_WOWLAN_TCP_SRC_IPV4] = { .type = NLA_U32 },
 	[NL80211_WOWLAN_TCP_DST_IPV4] = { .type = NLA_U32 },
-	[NL80211_WOWLAN_TCP_DST_MAC] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_WOWLAN_TCP_DST_MAC] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_WOWLAN_TCP_SRC_PORT] = { .type = NLA_U16 },
 	[NL80211_WOWLAN_TCP_DST_PORT] = { .type = NLA_U16 },
 	[NL80211_WOWLAN_TCP_DATA_PAYLOAD] = { .type = NLA_MIN_LEN, .len = 1 },
@@ -734,18 +707,9 @@ nl80211_coalesce_policy[NUM_NL80211_ATTR_COALESCE_RULE] = {
 /* policy for GTK rekey offload attributes */
 static const struct nla_policy
 nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
-	[NL80211_REKEY_DATA_KEK] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = NL80211_KEK_LEN,
-	},
-	[NL80211_REKEY_DATA_KCK] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = NL80211_KCK_LEN,
-	},
-	[NL80211_REKEY_DATA_REPLAY_CTR] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = NL80211_REPLAY_CTR_LEN
-	},
+	[NL80211_REKEY_DATA_KEK] = NLA_POLICY_EXACT_LEN_WARN(NL80211_KEK_LEN),
+	[NL80211_REKEY_DATA_KCK] = NLA_POLICY_EXACT_LEN_WARN(NL80211_KCK_LEN),
+	[NL80211_REKEY_DATA_REPLAY_CTR] = NLA_POLICY_EXACT_LEN_WARN(NL80211_REPLAY_CTR_LEN),
 };
 
 static const struct nla_policy
@@ -760,10 +724,7 @@ static const struct nla_policy
 nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
 	[NL80211_SCHED_SCAN_MATCH_ATTR_SSID] = { .type = NLA_BINARY,
 						 .len = IEEE80211_MAX_SSID_LEN },
-	[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI] = { .type = NLA_U32 },
 	[NL80211_SCHED_SCAN_MATCH_PER_BAND_RSSI] =
 		NLA_POLICY_NESTED(nl80211_match_band_rssi_policy),
@@ -795,10 +756,7 @@ nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
 	[NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE] = { .type = NLA_FLAG },
 	[NL80211_NAN_FUNC_FOLLOW_UP_ID] = { .type = NLA_U8 },
 	[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID] = { .type = NLA_U8 },
-	[NL80211_NAN_FUNC_FOLLOW_UP_DEST] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = ETH_ALEN
-	},
+	[NL80211_NAN_FUNC_FOLLOW_UP_DEST] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_NAN_FUNC_CLOSE_RANGE] = { .type = NLA_FLAG },
 	[NL80211_NAN_FUNC_TTL] = { .type = NLA_U32 },
 	[NL80211_NAN_FUNC_SERVICE_INFO] = { .type = NLA_BINARY,
@@ -4404,10 +4362,7 @@ static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 				    .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
 				.len = NL80211_MAX_SUPP_HT_RATES },
-	[NL80211_TXRATE_VHT] = {
-		.type = NLA_EXACT_LEN_WARN,
-		.len = sizeof(struct nl80211_txrate_vht),
-	},
+	[NL80211_TXRATE_VHT] = NLA_POLICY_EXACT_LEN_WARN(sizeof(struct nl80211_txrate_vht)),
 	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
 };
 
-- 
2.25.1

