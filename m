Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A507523D0C1
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgHETwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgHEQvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:51:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2DAC0A88B0;
        Wed,  5 Aug 2020 07:04:21 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k3K1j-00GoxW-2W; Wed, 05 Aug 2020 16:04:19 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/4] nl80211: use NLA_POLICY_RANGE(NLA_BINARY, ...) for a few attributes
Date:   Wed,  5 Aug 2020 16:03:24 +0200
Message-Id: <20200805154803.e858a2edcead.I9d948d59870e521febcd79bb4a986b1de1dca47b@changeid>
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

We have a few attributes with minimum and maximum lengths that are
not the same, use the new feature of being able to specify both in
the policy to validate them, removing code and allowing this to be
advertised to userspace in the policy export.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 076e3e96c809..e91d5bcb0f8b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -574,14 +574,20 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_BINARY },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = NLA_POLICY_MIN_LEN(2),
-	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
+	/*
+	 * The value of the Length field of the Supported Operating
+	 * Classes element is between 2 and 253.
+	 */
+	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] =
+		NLA_POLICY_RANGE(NLA_BINARY, 2, 253),
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_OPMODE_NOTIF] = { .type = NLA_U8 },
 	[NL80211_ATTR_VENDOR_ID] = { .type = NLA_U32 },
 	[NL80211_ATTR_VENDOR_SUBCMD] = { .type = NLA_U32 },
 	[NL80211_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
-	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
-				   .len = IEEE80211_QOS_MAP_LEN_MAX },
+	[NL80211_ATTR_QOS_MAP] = NLA_POLICY_RANGE(NLA_BINARY,
+						  IEEE80211_QOS_MAP_LEN_MIN,
+						  IEEE80211_QOS_MAP_LEN_MAX),
 	[NL80211_ATTR_MAC_HINT] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
@@ -636,9 +642,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
-	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
-					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
-
+	[NL80211_ATTR_HE_CAPABILITY] =
+		NLA_POLICY_RANGE(NLA_BINARY,
+				 NL80211_HE_MIN_CAPABILITY_LEN,
+				 NL80211_HE_MAX_CAPABILITY_LEN),
 	[NL80211_ATTR_FTM_RESPONDER] =
 		NLA_POLICY_NESTED(nl80211_ftm_responder_policy),
 	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
@@ -5851,13 +5858,6 @@ static int nl80211_parse_sta_channel_info(struct genl_info *info,
 		 nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
 		params->supported_oper_classes_len =
 		  nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
-		/*
-		 * The value of the Length field of the Supported Operating
-		 * Classes element is between 2 and 253.
-		 */
-		if (params->supported_oper_classes_len < 2 ||
-		    params->supported_oper_classes_len > 253)
-			return -EINVAL;
 	}
 	return 0;
 }
@@ -5880,9 +5880,6 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 			nla_data(info->attrs[NL80211_ATTR_HE_CAPABILITY]);
 		params->he_capa_len =
 			nla_len(info->attrs[NL80211_ATTR_HE_CAPABILITY]);
-
-		if (params->he_capa_len < NL80211_HE_MIN_CAPABILITY_LEN)
-			return -EINVAL;
 	}
 
 	err = nl80211_parse_sta_channel_info(info, params);
@@ -6141,10 +6138,6 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			nla_data(info->attrs[NL80211_ATTR_HE_CAPABILITY]);
 		params.he_capa_len =
 			nla_len(info->attrs[NL80211_ATTR_HE_CAPABILITY]);
-
-		/* max len is validated in nla policy */
-		if (params.he_capa_len < NL80211_HE_MIN_CAPABILITY_LEN)
-			return -EINVAL;
 	}
 
 	if (info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY])
@@ -13540,8 +13533,7 @@ static int nl80211_set_qos_map(struct sk_buff *skb,
 		pos = nla_data(info->attrs[NL80211_ATTR_QOS_MAP]);
 		len = nla_len(info->attrs[NL80211_ATTR_QOS_MAP]);
 
-		if (len % 2 || len < IEEE80211_QOS_MAP_LEN_MIN ||
-		    len > IEEE80211_QOS_MAP_LEN_MAX)
+		if (len % 2)
 			return -EINVAL;
 
 		qos_map = kzalloc(sizeof(struct cfg80211_qos_map), GFP_KERNEL);
-- 
2.26.2

