Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0EC4986DF
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbiAXRdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:33:04 -0500
Received: from mga06.intel.com ([134.134.136.31]:39630 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244632AbiAXRdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 12:33:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643045583; x=1674581583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kBJ1SG6vg2SenVTaOJYxd9H3FrALl/x7ebtfa8yZEZU=;
  b=kH4ohnf+9pjSwH7WG843YUEGr/gTr+t6wLgc/1LRsmWBrd5bmLRVcs2m
   GYqhlAQftGPsmCqZ65ZztXTqJ/ENkwEiT+ZKyp6o5LTj/edroQGlxrVn8
   owZ0WAflJhRQvrNUdxIT+Xjh5qE37AGzOzHBY6SuiqSfgz0U5kFQuAaZM
   Vc6NllLWzuAqq/A2hkiizK8Qx3uqbboJ06xRKJdMv8/nLQSbvAN8f4Kvp
   PLYvD7G8lPMV9v9zOjafzhf3TR5Z8dn3EWOXB6aLMNjayL/W8nftRZOUY
   8Y1auJGH8sPxqs5HFWQU519DFldy4LA/TvN0If3T0RS7Uoyt82iV7hP01
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="306815722"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="306815722"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:33:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="617323792"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2022 09:32:59 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20OHWuIr010465;
        Mon, 24 Jan 2022 17:32:58 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] ice: switch: use a struct to pass packet template params
Date:   Mon, 24 Jan 2022 18:31:14 +0100
Message-Id: <20220124173116.739083-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124173116.739083-1-alexandr.lobakin@intel.com>
References: <20220124173116.739083-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_find_dummy_packet() contains a lot of boilerplate code and a
nice room for copy-paste mistakes.
Instead of passing 3 separate pointers back and forth to get packet
template (dummy) params, directly return a structure containing
them. Then, use a macro to compose compound literals and avoid code
duplication on return path.
Now, dummy packet type/name is needed only once to return a full
correct triple pkt-pkt_len-offsets, and those are all one-liners.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 164 +++++++-------------
 1 file changed, 59 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 834ac8eebfaa..557b45f660ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -35,6 +35,20 @@ struct ice_dummy_pkt_offsets {
 	u16 offset; /* ICE_PROTOCOL_LAST indicates end of list */
 };
 
+struct ice_dummy_pkt_profile {
+	const struct ice_dummy_pkt_offsets *offsets;
+	const u8 *pkt;
+	u16 pkt_len;
+};
+
+#define ICE_PKT_PROFILE(type) ({					\
+	(struct ice_dummy_pkt_profile){					\
+		.pkt		= dummy_##type##_packet,		\
+		.pkt_len	= sizeof(dummy_##type##_packet),	\
+		.offsets	= dummy_##type##_packet_offsets,	\
+	};								\
+})
+
 static const struct ice_dummy_pkt_offsets dummy_gre_tcp_packet_offsets[] = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
@@ -4960,11 +4974,9 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
  * @pkt_len: packet length of dummy packet
  * @offsets: pointer to receive the pointer to the offsets for the packet
  */
-static void
+static struct ice_dummy_pkt_profile
 ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
-		      enum ice_sw_tunnel_type tun_type,
-		      const u8 **pkt, u16 *pkt_len,
-		      const struct ice_dummy_pkt_offsets **offsets)
+		      enum ice_sw_tunnel_type tun_type)
 {
 	bool tcp = false, udp = false, ipv6 = false, vlan = false;
 	bool ipv6_il = false;
@@ -4994,100 +5006,49 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 	}
 
 	if (tun_type == ICE_SW_TUN_NVGRE) {
-		if (tcp && ipv6_il) {
-			*pkt = dummy_gre_ipv6_tcp_packet;
-			*pkt_len = sizeof(dummy_gre_ipv6_tcp_packet);
-			*offsets = dummy_gre_ipv6_tcp_packet_offsets;
-			return;
-		}
-		if (tcp) {
-			*pkt = dummy_gre_tcp_packet;
-			*pkt_len = sizeof(dummy_gre_tcp_packet);
-			*offsets = dummy_gre_tcp_packet_offsets;
-			return;
-		}
-		if (ipv6_il) {
-			*pkt = dummy_gre_ipv6_udp_packet;
-			*pkt_len = sizeof(dummy_gre_ipv6_udp_packet);
-			*offsets = dummy_gre_ipv6_udp_packet_offsets;
-			return;
-		}
-		*pkt = dummy_gre_udp_packet;
-		*pkt_len = sizeof(dummy_gre_udp_packet);
-		*offsets = dummy_gre_udp_packet_offsets;
-		return;
+		if (tcp && ipv6_il)
+			return ICE_PKT_PROFILE(gre_ipv6_tcp);
+		else if (tcp)
+			return ICE_PKT_PROFILE(gre_tcp);
+		else if (ipv6_il)
+			return ICE_PKT_PROFILE(gre_ipv6_udp);
+		else
+			return ICE_PKT_PROFILE(gre_udp);
 	}
 
 	if (tun_type == ICE_SW_TUN_VXLAN ||
 	    tun_type == ICE_SW_TUN_GENEVE) {
-		if (tcp && ipv6_il) {
-			*pkt = dummy_udp_tun_ipv6_tcp_packet;
-			*pkt_len = sizeof(dummy_udp_tun_ipv6_tcp_packet);
-			*offsets = dummy_udp_tun_ipv6_tcp_packet_offsets;
-			return;
-		}
-		if (tcp) {
-			*pkt = dummy_udp_tun_tcp_packet;
-			*pkt_len = sizeof(dummy_udp_tun_tcp_packet);
-			*offsets = dummy_udp_tun_tcp_packet_offsets;
-			return;
-		}
-		if (ipv6_il) {
-			*pkt = dummy_udp_tun_ipv6_udp_packet;
-			*pkt_len = sizeof(dummy_udp_tun_ipv6_udp_packet);
-			*offsets = dummy_udp_tun_ipv6_udp_packet_offsets;
-			return;
-		}
-		*pkt = dummy_udp_tun_udp_packet;
-		*pkt_len = sizeof(dummy_udp_tun_udp_packet);
-		*offsets = dummy_udp_tun_udp_packet_offsets;
-		return;
+		if (tcp && ipv6_il)
+			return ICE_PKT_PROFILE(udp_tun_ipv6_tcp);
+		else if (tcp)
+			return ICE_PKT_PROFILE(udp_tun_tcp);
+		else if (ipv6_il)
+			return ICE_PKT_PROFILE(udp_tun_ipv6_udp);
+		else
+			return ICE_PKT_PROFILE(udp_tun_udp);
 	}
 
 	if (udp && !ipv6) {
-		if (vlan) {
-			*pkt = dummy_vlan_udp_packet;
-			*pkt_len = sizeof(dummy_vlan_udp_packet);
-			*offsets = dummy_vlan_udp_packet_offsets;
-			return;
-		}
-		*pkt = dummy_udp_packet;
-		*pkt_len = sizeof(dummy_udp_packet);
-		*offsets = dummy_udp_packet_offsets;
-		return;
+		if (vlan)
+			return ICE_PKT_PROFILE(vlan_udp);
+		else
+			return ICE_PKT_PROFILE(udp);
 	} else if (udp && ipv6) {
-		if (vlan) {
-			*pkt = dummy_vlan_udp_ipv6_packet;
-			*pkt_len = sizeof(dummy_vlan_udp_ipv6_packet);
-			*offsets = dummy_vlan_udp_ipv6_packet_offsets;
-			return;
-		}
-		*pkt = dummy_udp_ipv6_packet;
-		*pkt_len = sizeof(dummy_udp_ipv6_packet);
-		*offsets = dummy_udp_ipv6_packet_offsets;
-		return;
+		if (vlan)
+			return ICE_PKT_PROFILE(vlan_udp_ipv6);
+		else
+			return ICE_PKT_PROFILE(udp_ipv6);
 	} else if ((tcp && ipv6) || ipv6) {
-		if (vlan) {
-			*pkt = dummy_vlan_tcp_ipv6_packet;
-			*pkt_len = sizeof(dummy_vlan_tcp_ipv6_packet);
-			*offsets = dummy_vlan_tcp_ipv6_packet_offsets;
-			return;
-		}
-		*pkt = dummy_tcp_ipv6_packet;
-		*pkt_len = sizeof(dummy_tcp_ipv6_packet);
-		*offsets = dummy_tcp_ipv6_packet_offsets;
-		return;
+		if (vlan)
+			return ICE_PKT_PROFILE(vlan_tcp_ipv6);
+		else
+			return ICE_PKT_PROFILE(tcp_ipv6);
 	}
 
-	if (vlan) {
-		*pkt = dummy_vlan_tcp_packet;
-		*pkt_len = sizeof(dummy_vlan_tcp_packet);
-		*offsets = dummy_vlan_tcp_packet_offsets;
-	} else {
-		*pkt = dummy_tcp_packet;
-		*pkt_len = sizeof(dummy_tcp_packet);
-		*offsets = dummy_tcp_packet_offsets;
-	}
+	if (vlan)
+		return ICE_PKT_PROFILE(vlan_tcp);
+
+	return ICE_PKT_PROFILE(tcp);
 }
 
 /**
@@ -5104,8 +5065,7 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 static int
 ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 			  struct ice_aqc_sw_rules_elem *s_rule,
-			  const u8 *dummy_pkt, u16 pkt_len,
-			  const struct ice_dummy_pkt_offsets *offsets)
+			  const struct ice_dummy_pkt_profile *profile)
 {
 	u8 *pkt;
 	u16 i;
@@ -5115,9 +5075,10 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 	 */
 	pkt = s_rule->pdata.lkup_tx_rx.hdr;
 
-	memcpy(pkt, dummy_pkt, pkt_len);
+	memcpy(pkt, profile->pkt, profile->pkt_len);
 
 	for (i = 0; i < lkups_cnt; i++) {
+		const struct ice_dummy_pkt_offsets *offsets = profile->offsets;
 		enum ice_protocol_type type;
 		u16 offset = 0, len = 0, j;
 		bool found = false;
@@ -5198,7 +5159,7 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		}
 	}
 
-	s_rule->pdata.lkup_tx_rx.hdr_len = cpu_to_le16(pkt_len);
+	s_rule->pdata.lkup_tx_rx.hdr_len = cpu_to_le16(profile->pkt_len);
 
 	return 0;
 }
@@ -5421,12 +5382,11 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		 struct ice_rule_query_data *added_entry)
 {
 	struct ice_adv_fltr_mgmt_list_entry *m_entry, *adv_fltr = NULL;
-	u16 rid = 0, i, pkt_len, rule_buf_sz, vsi_handle;
-	const struct ice_dummy_pkt_offsets *pkt_offsets;
 	struct ice_aqc_sw_rules_elem *s_rule = NULL;
+	u16 rid = 0, i, rule_buf_sz, vsi_handle;
+	struct ice_dummy_pkt_profile profile;
 	struct list_head *rule_head;
 	struct ice_switch_info *sw;
-	const u8 *pkt = NULL;
 	u16 word_cnt;
 	u32 act = 0;
 	int status;
@@ -5454,13 +5414,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (!word_cnt || word_cnt > ICE_MAX_CHAIN_WORDS)
 		return -EINVAL;
 
-	/* make sure that we can locate a dummy packet */
-	ice_find_dummy_packet(lkups, lkups_cnt, rinfo->tun_type, &pkt, &pkt_len,
-			      &pkt_offsets);
-	if (!pkt) {
-		status = -EINVAL;
-		goto err_ice_add_adv_rule;
-	}
+	/* locate a dummy packet */
+	profile = ice_find_dummy_packet(lkups, lkups_cnt, rinfo->tun_type);
 
 	if (!(rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI ||
 	      rinfo->sw_act.fltr_act == ICE_FWD_TO_Q ||
@@ -5501,7 +5456,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		}
 		return status;
 	}
-	rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE + pkt_len;
+	rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE + profile.pkt_len;
 	s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
@@ -5561,15 +5516,14 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	s_rule->pdata.lkup_tx_rx.recipe_id = cpu_to_le16(rid);
 	s_rule->pdata.lkup_tx_rx.act = cpu_to_le32(act);
 
-	status = ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, pkt,
-					   pkt_len, pkt_offsets);
+	status = ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, &profile);
 	if (status)
 		goto err_ice_add_adv_rule;
 
 	if (rinfo->tun_type != ICE_NON_TUN) {
 		status = ice_fill_adv_packet_tun(hw, rinfo->tun_type,
 						 s_rule->pdata.lkup_tx_rx.hdr,
-						 pkt_offsets);
+						 profile.offsets);
 		if (status)
 			goto err_ice_add_adv_rule;
 	}
-- 
2.34.1

