Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94E25A268B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245736AbiHZLGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbiHZLEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:04:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2346D8A
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661511869; x=1693047869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WLxjP7Z1v76rB64MBo/vQh9rHaRlUQJ7g/xZ6YHY2X4=;
  b=KnLqknWC8mS9kG2/+cpzt2ZB00gCXgtb52lc7WSgmjmHpym7WDmkaNz4
   e7uqpKDkFUZiQuiYC4BeB0bgzlX/XmmmfpVbH3IvTYaPTiXJwvqQtPFbn
   KyaJnK5fYj5uIF/LrTJvn71gzH0D+5OxqASbJ00U051ZZsSiC6iDXANiN
   RODKduy8OI86S78yTVlSLlWfmQtyyjKU8mbML42fjFWEcLqR8N7tXClMU
   /UoxsbDw/F9CqWPVVNoaHRBvaB2gkw+hTrhsfJJPBx475t8rp86vRKtBV
   zHkRuAWLOuLsDhKOWtxRrrGhn27oz92fNMRqkgbXxYyvFMu251B2d0ojx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="320576109"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="320576109"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 04:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="613496753"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 26 Aug 2022 04:04:22 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27QB4CLv024087;
        Fri, 26 Aug 2022 12:04:20 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: [RFC PATCH net-next 5/5] ice: Add L2TPv3 hardware offload support
Date:   Fri, 26 Aug 2022 13:00:59 +0200
Message-Id: <20220826110059.119927-6-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220826110059.119927-1-wojciech.drewek@intel.com>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Add support for offloading packets based on L2TPv3 session id in switchdev
mode.

Example filter:
tc filter add dev $PF1 ingress prio 1 protocol ip flower ip_proto l2tp \
    l2tpv3_sid 1234 skip_sw action mirred egress redirect dev $VF1_PR

Changes in iproute2 are required to be able to specify l2tpv3_sid.

ICE COMMS DDP package is required to create a filter as it contains L2TPv3
profiles.

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 .../ethernet/intel/ice/ice_protocol_type.h    |  8 +++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 70 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 27 ++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  6 ++
 4 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 560efc7654c7..02a4e1cf624e 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -44,6 +44,7 @@ enum ice_protocol_type {
 	ICE_GTP,
 	ICE_GTP_NO_PAY,
 	ICE_PPPOE,
+	ICE_L2TPV3,
 	ICE_VLAN_EX,
 	ICE_VLAN_IN,
 	ICE_VXLAN_GPE,
@@ -111,6 +112,7 @@ enum ice_prot_id {
 #define ICE_UDP_ILOS_HW		53
 #define ICE_GRE_OF_HW		64
 #define ICE_PPPOE_HW		103
+#define ICE_L2TPV3_HW		104
 
 #define ICE_UDP_OF_HW	52 /* UDP Tunnels */
 #define ICE_META_DATA_ID_HW 255 /* this is used for tunnel and VLAN type */
@@ -217,6 +219,11 @@ struct ice_pppoe_hdr {
 	__be16 ppp_prot_id; /* control and data only */
 };
 
+struct ice_l2tpv3_sess_hdr {
+	__be32 session_id;
+	__be64 cookie;
+};
+
 struct ice_nvgre_hdr {
 	__be16 flags;
 	__be16 protocol;
@@ -235,6 +242,7 @@ union ice_prot_hdr {
 	struct ice_nvgre_hdr nvgre_hdr;
 	struct ice_udp_gtp_hdr gtp_hdr;
 	struct ice_pppoe_hdr pppoe_hdr;
+	struct ice_l2tpv3_sess_hdr l2tpv3_sess_hdr;
 };
 
 /* This is mapping table entry that maps every word within a given protocol
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 697feb89188c..075703f513ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -42,6 +42,7 @@ enum {
 	ICE_PKT_GTP_NOPAY	= BIT(8),
 	ICE_PKT_KMALLOC		= BIT(9),
 	ICE_PKT_PPPOE		= BIT(10),
+	ICE_PKT_L2TPV3		= BIT(11),
 };
 
 struct ice_dummy_pkt_offsets {
@@ -1258,6 +1259,65 @@ ICE_DECLARE_PKT_TEMPLATE(pppoe_ipv6_udp) = {
 	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
 };
 
+ICE_DECLARE_PKT_OFFSETS(ipv4_l2tpv3) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_L2TPV3,		34 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(ipv4_l2tpv3) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x20, /* ICE_IPV4_IL 14 */
+	0x00, 0x00, 0x40, 0x00,
+	0x40, 0x73, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_L2TPV3 34 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
+};
+
+ICE_DECLARE_PKT_OFFSETS(ipv6_l2tpv3) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV6_OFOS,	14 },
+	{ ICE_L2TPV3,		54 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(ipv6_l2tpv3) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x86, 0xDD,		/* ICE_ETYPE_OL 12 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_IL 14 */
+	0x00, 0x0c, 0x73, 0x40,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_L2TPV3 54 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
+};
+
 static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPU | ICE_PKT_OUTER_IPV6 |
 				  ICE_PKT_GTP_NOPAY),
@@ -1297,6 +1357,8 @@ static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(udp_tun_ipv6_tcp, ICE_PKT_TUN_UDP |
 					  ICE_PKT_INNER_IPV6 |
 					  ICE_PKT_INNER_TCP),
+	ICE_PKT_PROFILE(ipv6_l2tpv3, ICE_PKT_L2TPV3 | ICE_PKT_OUTER_IPV6),
+	ICE_PKT_PROFILE(ipv4_l2tpv3, ICE_PKT_L2TPV3),
 	ICE_PKT_PROFILE(udp_tun_tcp, ICE_PKT_TUN_UDP | ICE_PKT_INNER_TCP),
 	ICE_PKT_PROFILE(udp_tun_ipv6_udp, ICE_PKT_TUN_UDP |
 					  ICE_PKT_INNER_IPV6),
@@ -4492,6 +4554,7 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	{ ICE_GTP,		{ 8, 10, 12, 14, 16, 18, 20, 22 } },
 	{ ICE_GTP_NO_PAY,	{ 8, 10, 12, 14 } },
 	{ ICE_PPPOE,		{ 0, 2, 4, 6 } },
+	{ ICE_L2TPV3,		{ 0, 2, 4, 6, 8, 10 } },
 	{ ICE_VLAN_EX,          { 2, 0 } },
 	{ ICE_VLAN_IN,          { 2, 0 } },
 };
@@ -4515,6 +4578,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_GTP,		ICE_UDP_OF_HW },
 	{ ICE_GTP_NO_PAY,	ICE_UDP_ILOS_HW },
 	{ ICE_PPPOE,		ICE_PPPOE_HW },
+	{ ICE_L2TPV3,		ICE_L2TPV3_HW },
 	{ ICE_VLAN_EX,          ICE_VLAN_OF_HW },
 	{ ICE_VLAN_IN,          ICE_VLAN_OL_HW },
 };
@@ -5598,7 +5662,8 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 			if (lkups[i].h_u.pppoe_hdr.ppp_prot_id ==
 			    htons(PPP_IPV6))
 				match |= ICE_PKT_OUTER_IPV6;
-		}
+		} else if (lkups[i].type == ICE_L2TPV3)
+			match |= ICE_PKT_L2TPV3;
 	}
 
 	while (ret->match && (match & ret->match) != ret->match)
@@ -5699,6 +5764,9 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		case ICE_PPPOE:
 			len = sizeof(struct ice_pppoe_hdr);
 			break;
+		case ICE_L2TPV3:
+			len = sizeof(struct ice_l2tpv3_sess_hdr);
+			break;
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index a298862857a8..85825f27a8b3 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -64,6 +64,10 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 		     ICE_TC_FLWR_FIELD_DEST_IPV6 | ICE_TC_FLWR_FIELD_SRC_IPV6))
 		lkups_cnt++;
 
+	/* are L2TPv3 options specified? */
+	if (flags & ICE_TC_FLWR_FIELD_L2TPV3_SESSID)
+		lkups_cnt++;
+
 	/* is L4 (TCP/UDP/any other L4 protocol fields) specified? */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_L4_PORT |
 		     ICE_TC_FLWR_FIELD_SRC_L4_PORT))
@@ -420,6 +424,17 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 		i++;
 	}
 
+	if (flags & ICE_TC_FLWR_FIELD_L2TPV3_SESSID) {
+		list[i].type = ICE_L2TPV3;
+
+		list[i].h_u.l2tpv3_sess_hdr.session_id =
+			headers->l2tpv3_hdr.session_id;
+		list[i].m_u.l2tpv3_sess_hdr.session_id =
+			cpu_to_be32(0xFFFFFFFF);
+
+		i++;
+	}
+
 	/* copy L4 (src, dest) port */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_L4_PORT |
 		     ICE_TC_FLWR_FIELD_SRC_L4_PORT)) {
@@ -1041,7 +1056,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
-	      BIT(FLOW_DISSECTOR_KEY_PPPOE))) {
+	      BIT(FLOW_DISSECTOR_KEY_PPPOE) |
+	      BIT(FLOW_DISSECTOR_KEY_L2TPV3))) {
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported key used");
 		return -EOPNOTSUPP;
 	}
@@ -1217,6 +1233,15 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 			return -EINVAL;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_L2TPV3)) {
+		struct flow_match_l2tpv3 match;
+
+		flow_rule_match_l2tpv3(rule, &match);
+
+		fltr->flags |= ICE_TC_FLWR_FIELD_L2TPV3_SESSID;
+		headers->l2tpv3_hdr.session_id = match.key->session_id;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 91cd3d3778c7..48503a0e35b4 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -26,6 +26,7 @@
 #define ICE_TC_FLWR_FIELD_CVLAN			BIT(19)
 #define ICE_TC_FLWR_FIELD_PPPOE_SESSID		BIT(20)
 #define ICE_TC_FLWR_FIELD_PPP_PROTO		BIT(21)
+#define ICE_TC_FLWR_FIELD_L2TPV3_SESSID		BIT(22)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
@@ -80,6 +81,10 @@ struct ice_tc_l3_hdr {
 	u8 ttl;
 };
 
+struct ice_tc_l2tpv3_hdr {
+	__be32 session_id;
+};
+
 struct ice_tc_l4_hdr {
 	__be16 dst_port;
 	__be16 src_port;
@@ -92,6 +97,7 @@ struct ice_tc_flower_lyr_2_4_hdrs {
 	struct ice_tc_vlan_hdr vlan_hdr;
 	struct ice_tc_vlan_hdr cvlan_hdr;
 	struct ice_tc_pppoe_hdr pppoe_hdr;
+	struct ice_tc_l2tpv3_hdr l2tpv3_hdr;
 	/* L3 (IPv4[6]) layer fields with their mask */
 	struct ice_tc_l3_hdr l3_key;
 	struct ice_tc_l3_hdr l3_mask;
-- 
2.31.1

