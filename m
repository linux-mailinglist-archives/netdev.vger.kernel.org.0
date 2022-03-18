Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53C84DDEC2
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbiCRQX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiCRQXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:23:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD599D4C4;
        Fri, 18 Mar 2022 09:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647620390; x=1679156390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hsq855aJWaAQp5u675gRwGodFSYs3pfMf1rbcv+1j3s=;
  b=BshKjy113Z/BuxIkSwnA/GkjLx1r14Yqr2Cq3h/cV6418WJoJFnHDaqQ
   5f4lI9IfzxZpUCZLAnqFxQyIaLedOevB0kc/SDenLY9FodhiFWJWqilAO
   cqfXz+6anr72GXcrvCgEgHn103KI2rR1/YAapoAnBl39TGnsW+PuwHgMH
   XKUALWbbmG2+jBXqcRGBU81RLmPpP6nPiffiJlYuCzXfovgTjs5PfbNSY
   qbpDA0wrta1mP8T3t8FIv0QQdrYSXrmP3hJr/pfAV2iudAOD7ODpHS339
   gEFUAB2ixIOgKQmdwS6+IuYn/bjKyP8uWgolyEUfUvqJgSBG5JZsPAFWk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="257114799"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="257114799"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:18:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="784286449"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 18 Mar 2022 09:18:29 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22IGIOmH024113;
        Fri, 18 Mar 2022 16:18:28 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 5/5] ice: switch: convert packet template match code to rodata
Date:   Fri, 18 Mar 2022 17:17:13 +0100
Message-Id: <20220318161713.680436-6-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318161713.680436-1-alexandr.lobakin@intel.com>
References: <20220318161713.680436-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trade text size for rodata size and replace tons of nested if-elses
to the const mask match based structs. The almost entire
ice_find_dummy_packet() now becomes just one plain while-increment
loop. The order in ice_dummy_pkt_profiles[] should be same with the
if-elses order previously, as masks become less and less strict
through the array to follow the original code flow.
Apart from removing 80 locs of 4-level if-elses, it brings a solid
text size optimization:

$ scripts/bloat-o-meter -c {__,}vmlinux L
add/remove: 0/1 grow/shrink: 1/1 up/down: 2/-1045 (-1043)
Function                                     old     new   delta
ice_fill_adv_dummy_packet                    289     291      +2
ice_adv_add_update_vsi_list                  201       -    -201
ice_add_adv_rule                            2950    2106    -844
Total: Before=413901, After=412858, chg -0.25%
add/remove: 53/52 grow/shrink: 0/0 up/down: 4660/-3988 (672)
RO Data                                      old     new   delta
ice_dummy_pkt_profiles                         -     672    +672

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 215 ++++++++++----------
 1 file changed, 108 insertions(+), 107 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 8d4e49173dd1..263bc43d679e 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -30,6 +30,19 @@ static const u8 dummy_eth_header[DUMMY_ETH_HDR_LEN] = { 0x2, 0, 0, 0, 0, 0,
 							0x2, 0, 0, 0, 0, 0,
 							0x81, 0, 0, 0};
 
+enum {
+	ICE_PKT_VLAN		= BIT(0),
+	ICE_PKT_OUTER_IPV6	= BIT(1),
+	ICE_PKT_TUN_GTPC	= BIT(2),
+	ICE_PKT_TUN_GTPU	= BIT(3),
+	ICE_PKT_TUN_NVGRE	= BIT(4),
+	ICE_PKT_TUN_UDP		= BIT(5),
+	ICE_PKT_INNER_IPV6	= BIT(6),
+	ICE_PKT_INNER_TCP	= BIT(7),
+	ICE_PKT_INNER_UDP	= BIT(8),
+	ICE_PKT_GTP_NOPAY	= BIT(9),
+};
+
 struct ice_dummy_pkt_offsets {
 	enum ice_protocol_type type;
 	u16 offset; /* ICE_PROTOCOL_LAST indicates end of list */
@@ -39,22 +52,22 @@ struct ice_dummy_pkt_profile {
 	const struct ice_dummy_pkt_offsets *offsets;
 	const u8 *pkt;
 	u64 pkt_len:16;
+	u64 match:48;
 };
 
-#define ICE_DECLARE_PKT_OFFSETS(type)					\
-	static const struct ice_dummy_pkt_offsets			\
+#define ICE_DECLARE_PKT_OFFSETS(type)				\
+	static const struct ice_dummy_pkt_offsets		\
 	ice_dummy_##type##_packet_offsets[]
 
-#define ICE_DECLARE_PKT_TEMPLATE(type)					\
+#define ICE_DECLARE_PKT_TEMPLATE(type)				\
 	static const u8 ice_dummy_##type##_packet[]
 
-#define ICE_PKT_PROFILE(type) ({					\
-	(struct ice_dummy_pkt_profile){					\
-		.pkt		= ice_dummy_##type##_packet,		\
-		.pkt_len	= sizeof(ice_dummy_##type##_packet),	\
-		.offsets	= ice_dummy_##type##_packet_offsets,	\
-	};								\
-})
+#define ICE_PKT_PROFILE(type, m) {				\
+	.match		= (m),					\
+	.pkt		= ice_dummy_##type##_packet,		\
+	.pkt_len	= sizeof(ice_dummy_##type##_packet),	\
+	.offsets	= ice_dummy_##type##_packet_offsets,	\
+}
 
 ICE_DECLARE_PKT_OFFSETS(gre_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
@@ -1220,6 +1233,55 @@ ICE_DECLARE_PKT_TEMPLATE(ipv6_gtp) = {
 	0x00, 0x00,
 };
 
+static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
+	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPU | ICE_PKT_OUTER_IPV6 |
+				  ICE_PKT_GTP_NOPAY),
+	ICE_PKT_PROFILE(ipv6_gtpu_ipv6_udp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_OUTER_IPV6 |
+					    ICE_PKT_INNER_IPV6 |
+					    ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(ipv6_gtpu_ipv6_tcp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_OUTER_IPV6 |
+					    ICE_PKT_INNER_IPV6),
+	ICE_PKT_PROFILE(ipv6_gtpu_ipv4_udp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_OUTER_IPV6 |
+					    ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(ipv6_gtpu_ipv4_tcp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_OUTER_IPV6),
+	ICE_PKT_PROFILE(ipv4_gtpu_ipv4, ICE_PKT_TUN_GTPU | ICE_PKT_GTP_NOPAY),
+	ICE_PKT_PROFILE(ipv4_gtpu_ipv6_udp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_INNER_IPV6 |
+					    ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(ipv4_gtpu_ipv6_tcp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_INNER_IPV6),
+	ICE_PKT_PROFILE(ipv4_gtpu_ipv4_udp, ICE_PKT_TUN_GTPU |
+					    ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(ipv4_gtpu_ipv4_tcp, ICE_PKT_TUN_GTPU),
+	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPC | ICE_PKT_OUTER_IPV6),
+	ICE_PKT_PROFILE(ipv4_gtpu_ipv4, ICE_PKT_TUN_GTPC),
+	ICE_PKT_PROFILE(gre_ipv6_tcp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_IPV6 |
+				      ICE_PKT_INNER_TCP),
+	ICE_PKT_PROFILE(gre_tcp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_TCP),
+	ICE_PKT_PROFILE(gre_ipv6_udp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_IPV6),
+	ICE_PKT_PROFILE(gre_udp, ICE_PKT_TUN_NVGRE),
+	ICE_PKT_PROFILE(udp_tun_ipv6_tcp, ICE_PKT_TUN_UDP |
+					  ICE_PKT_INNER_IPV6 |
+					  ICE_PKT_INNER_TCP),
+	ICE_PKT_PROFILE(udp_tun_tcp, ICE_PKT_TUN_UDP | ICE_PKT_INNER_TCP),
+	ICE_PKT_PROFILE(udp_tun_ipv6_udp, ICE_PKT_TUN_UDP |
+					  ICE_PKT_INNER_IPV6),
+	ICE_PKT_PROFILE(udp_tun_udp, ICE_PKT_TUN_UDP),
+	ICE_PKT_PROFILE(vlan_udp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_INNER_UDP |
+				       ICE_PKT_VLAN),
+	ICE_PKT_PROFILE(udp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(vlan_udp, ICE_PKT_INNER_UDP | ICE_PKT_VLAN),
+	ICE_PKT_PROFILE(udp, ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_INNER_IPV6 | ICE_PKT_VLAN),
+	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_INNER_IPV6),
+	ICE_PKT_PROFILE(vlan_tcp, ICE_PKT_VLAN),
+	ICE_PKT_PROFILE(tcp, 0),
+};
+
 #define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
 	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr) + \
 	 (DUMMY_ETH_HDR_LEN * \
@@ -5509,124 +5571,63 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
  *
  * Returns the &ice_dummy_pkt_profile corresponding to these lookup params.
  */
-static struct ice_dummy_pkt_profile
+static const struct ice_dummy_pkt_profile *
 ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		      enum ice_sw_tunnel_type tun_type)
 {
-	bool inner_tcp = false, inner_udp = false, outer_ipv6 = false;
-	bool vlan = false, inner_ipv6 = false, gtp_no_pay = false;
+	const struct ice_dummy_pkt_profile *ret = ice_dummy_pkt_profiles;
+	u64 match = 0;
 	u16 i;
 
+	switch (tun_type) {
+	case ICE_SW_TUN_GTPC:
+		match |= ICE_PKT_TUN_GTPC;
+		break;
+	case ICE_SW_TUN_GTPU:
+		match |= ICE_PKT_TUN_GTPU;
+		break;
+	case ICE_SW_TUN_NVGRE:
+		match |= ICE_PKT_TUN_NVGRE;
+		break;
+	case ICE_SW_TUN_GENEVE:
+	case ICE_SW_TUN_VXLAN:
+		match |= ICE_PKT_TUN_UDP;
+		break;
+	default:
+		break;
+	}
+
 	for (i = 0; i < lkups_cnt; i++) {
 		if (lkups[i].type == ICE_UDP_ILOS)
-			inner_udp = true;
+			match |= ICE_PKT_INNER_UDP;
 		else if (lkups[i].type == ICE_TCP_IL)
-			inner_tcp = true;
+			match |= ICE_PKT_INNER_TCP;
 		else if (lkups[i].type == ICE_IPV6_OFOS)
-			outer_ipv6 = true;
+			match |= ICE_PKT_OUTER_IPV6;
 		else if (lkups[i].type == ICE_VLAN_OFOS)
-			vlan = true;
+			match |= ICE_PKT_VLAN;
 		else if (lkups[i].type == ICE_ETYPE_OL &&
 			 lkups[i].h_u.ethertype.ethtype_id ==
 				cpu_to_be16(ICE_IPV6_ETHER_ID) &&
 			 lkups[i].m_u.ethertype.ethtype_id ==
 				cpu_to_be16(0xFFFF))
-			outer_ipv6 = true;
+			match |= ICE_PKT_OUTER_IPV6;
 		else if (lkups[i].type == ICE_ETYPE_IL &&
 			 lkups[i].h_u.ethertype.ethtype_id ==
 				cpu_to_be16(ICE_IPV6_ETHER_ID) &&
 			 lkups[i].m_u.ethertype.ethtype_id ==
 				cpu_to_be16(0xFFFF))
-			inner_ipv6 = true;
+			match |= ICE_PKT_INNER_IPV6;
 		else if (lkups[i].type == ICE_IPV6_IL)
-			inner_ipv6 = true;
+			match |= ICE_PKT_INNER_IPV6;
 		else if (lkups[i].type == ICE_GTP_NO_PAY)
-			gtp_no_pay = true;
-	}
-
-	if (tun_type == ICE_SW_TUN_GTPU) {
-		if (outer_ipv6) {
-			if (gtp_no_pay) {
-				return ICE_PKT_PROFILE(ipv6_gtp);
-			} else if (inner_ipv6) {
-				if (inner_udp)
-					return ICE_PKT_PROFILE(ipv6_gtpu_ipv6_udp);
-				else
-					return ICE_PKT_PROFILE(ipv6_gtpu_ipv6_tcp);
-			} else {
-				if (inner_udp)
-					return ICE_PKT_PROFILE(ipv6_gtpu_ipv4_udp);
-				else
-					return ICE_PKT_PROFILE(ipv6_gtpu_ipv4_tcp);
-			}
-		} else {
-			if (gtp_no_pay) {
-				return ICE_PKT_PROFILE(ipv4_gtpu_ipv4);
-			} else if (inner_ipv6) {
-				if (inner_udp)
-					return ICE_PKT_PROFILE(ipv4_gtpu_ipv6_udp);
-				else
-					return ICE_PKT_PROFILE(ipv4_gtpu_ipv6_tcp);
-			} else {
-				if (inner_udp)
-					return ICE_PKT_PROFILE(ipv4_gtpu_ipv4_udp);
-				else
-					return ICE_PKT_PROFILE(ipv4_gtpu_ipv4_tcp);
-			}
-		}
+			match |= ICE_PKT_GTP_NOPAY;
 	}
 
-	if (tun_type == ICE_SW_TUN_GTPC) {
-		if (outer_ipv6)
-			return ICE_PKT_PROFILE(ipv6_gtp);
-		else
-			return ICE_PKT_PROFILE(ipv4_gtpu_ipv4);
-	}
-
-	if (tun_type == ICE_SW_TUN_NVGRE) {
-		if (inner_tcp && inner_ipv6)
-			return ICE_PKT_PROFILE(gre_ipv6_tcp);
-		else if (inner_tcp)
-			return ICE_PKT_PROFILE(gre_tcp);
-		else if (inner_ipv6)
-			return ICE_PKT_PROFILE(gre_ipv6_udp);
-		else
-			return ICE_PKT_PROFILE(gre_udp);
-	}
+	while (ret->match && (match & ret->match) != ret->match)
+		ret++;
 
-	if (tun_type == ICE_SW_TUN_VXLAN ||
-	    tun_type == ICE_SW_TUN_GENEVE) {
-		if (inner_tcp && inner_ipv6)
-			return ICE_PKT_PROFILE(udp_tun_ipv6_tcp);
-		else if (inner_tcp)
-			return ICE_PKT_PROFILE(udp_tun_tcp);
-		else if (inner_ipv6)
-			return ICE_PKT_PROFILE(udp_tun_ipv6_udp);
-		else
-			return ICE_PKT_PROFILE(udp_tun_udp);
-	}
-
-	if (inner_udp && !outer_ipv6) {
-		if (vlan)
-			return ICE_PKT_PROFILE(vlan_udp);
-		else
-			return ICE_PKT_PROFILE(udp);
-	} else if (inner_udp && outer_ipv6) {
-		if (vlan)
-			return ICE_PKT_PROFILE(vlan_udp_ipv6);
-		else
-			return ICE_PKT_PROFILE(udp_ipv6);
-	} else if ((inner_tcp && outer_ipv6) || outer_ipv6) {
-		if (vlan)
-			return ICE_PKT_PROFILE(vlan_tcp_ipv6);
-		else
-			return ICE_PKT_PROFILE(tcp_ipv6);
-	}
-
-	if (vlan)
-		return ICE_PKT_PROFILE(vlan_tcp);
-
-	return ICE_PKT_PROFILE(tcp);
+	return ret;
 }
 
 /**
@@ -5963,8 +5964,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 {
 	struct ice_adv_fltr_mgmt_list_entry *m_entry, *adv_fltr = NULL;
 	struct ice_aqc_sw_rules_elem *s_rule = NULL;
+	const struct ice_dummy_pkt_profile *profile;
 	u16 rid = 0, i, rule_buf_sz, vsi_handle;
-	struct ice_dummy_pkt_profile profile;
 	struct list_head *rule_head;
 	struct ice_switch_info *sw;
 	u16 word_cnt;
@@ -6036,7 +6037,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		}
 		return status;
 	}
-	rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE + profile.pkt_len;
+	rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE + profile->pkt_len;
 	s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
@@ -6096,7 +6097,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	s_rule->pdata.lkup_tx_rx.recipe_id = cpu_to_le16(rid);
 	s_rule->pdata.lkup_tx_rx.act = cpu_to_le32(act);
 
-	status = ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, &profile);
+	status = ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, profile);
 	if (status)
 		goto err_ice_add_adv_rule;
 
@@ -6104,7 +6105,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	    rinfo->tun_type != ICE_SW_TUN_AND_NON_TUN) {
 		status = ice_fill_adv_packet_tun(hw, rinfo->tun_type,
 						 s_rule->pdata.lkup_tx_rx.hdr,
-						 profile.offsets);
+						 profile->offsets);
 		if (status)
 			goto err_ice_add_adv_rule;
 	}
-- 
2.35.1

