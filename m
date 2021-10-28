Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1505843E7FF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhJ1SLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:46220 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhJ1SLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427775"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427775"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849075"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 4/9] ice: support for GRE in eswitch
Date:   Thu, 28 Oct 2021 11:06:54 -0700
Message-Id: <20211028180659.218912-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Mostly reuse code from Geneve and VXLAN in TC parsing code. Add new GRE
header to match on correct fields. Create new dummy packets with GRE
fields.

Instead of checking if any encap values are presented in TC flower,
check if device is tunnel type or redirect is to tunnel device. This
will allow adding all combination of rules. For example filters only
with inner fields.

Return error in case device isn't tunnel but encap values are presented.

gre example:
- create tunnel device
ip l add $NVGRE_DEV type gretap remote $NVGRE_REM_IP local $VF1_IP \
dev $PF
- add tc filter (in switchdev mode)
tc filter add dev $NVGRE_DEV protocol ip parent ffff: flower dst_ip \
$NVGRE1_IP action mirred egress redirect dev $VF1_PR

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   4 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |   2 +
 .../ethernet/intel/ice/ice_protocol_type.h    |  12 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 110 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  47 +++++---
 5 files changed, 161 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 8736d3ae230f..23cfcceb1536 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1580,6 +1580,10 @@ ice_get_sw_prof_type(struct ice_hw *hw, struct ice_fv *fv)
 		if (fv->ew[i].prot_id == (u8)ICE_PROT_UDP_OF &&
 		    fv->ew[i].off == ICE_VNI_OFFSET)
 			return ICE_PROF_TUN_UDP;
+
+		/* GRE tunnel will have GRE protocol */
+		if (fv->ew[i].prot_id == (u8)ICE_PROT_GRE_OF)
+			return ICE_PROF_TUN_GRE;
 	}
 
 	return ICE_PROF_NON_TUN;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 07d3795d2b10..0f572a36d021 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -373,6 +373,7 @@ struct ice_pkg_enum {
 enum ice_tunnel_type {
 	TNL_VXLAN = 0,
 	TNL_GENEVE,
+	TNL_GRETAP,
 	__TNL_TYPE_CNT,
 	TNL_LAST = 0xFF,
 	TNL_ALL = 0xFF,
@@ -615,6 +616,7 @@ struct ice_chs_chg {
 enum ice_prof_type {
 	ICE_PROF_NON_TUN = 0x1,
 	ICE_PROF_TUN_UDP = 0x2,
+	ICE_PROF_TUN_GRE = 0x4,
 	ICE_PROF_TUN_ALL = 0x6,
 	ICE_PROF_ALL = 0xFF,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 8309ecaa771c..dc1b0e9e6df5 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -39,6 +39,7 @@ enum ice_protocol_type {
 	ICE_UDP_ILOS,
 	ICE_VXLAN,
 	ICE_GENEVE,
+	ICE_NVGRE,
 	ICE_VXLAN_GPE,
 	ICE_SCTP_IL,
 	ICE_PROTOCOL_LAST
@@ -48,7 +49,8 @@ enum ice_sw_tunnel_type {
 	ICE_NON_TUN = 0,
 	ICE_SW_TUN_VXLAN,
 	ICE_SW_TUN_GENEVE,
-	ICE_ALL_TUNNELS /* All tunnel types */
+	ICE_SW_TUN_NVGRE,
+	ICE_ALL_TUNNELS /* All tunnel types including NVGRE */
 };
 
 /* Decoders for ice_prot_id:
@@ -97,6 +99,7 @@ enum ice_prot_id {
 #define ICE_IPV6_IL_HW		41
 #define ICE_TCP_IL_HW		49
 #define ICE_UDP_ILOS_HW		53
+#define ICE_GRE_OF_HW		64
 
 #define ICE_UDP_OF_HW	52 /* UDP Tunnels */
 #define ICE_META_DATA_ID_HW 255 /* this is used for tunnel type */
@@ -176,6 +179,12 @@ struct ice_udp_tnl_hdr {
 	__be32 vni;     /* only use lower 24-bits */
 };
 
+struct ice_nvgre_hdr {
+	__be16 flags;
+	__be16 protocol;
+	__be32 tni_flow;
+};
+
 union ice_prot_hdr {
 	struct ice_ether_hdr eth_hdr;
 	struct ice_ethtype_hdr ethertype;
@@ -185,6 +194,7 @@ union ice_prot_hdr {
 	struct ice_l4_hdr l4_hdr;
 	struct ice_sctp_hdr sctp_hdr;
 	struct ice_udp_tnl_hdr tnl_hdr;
+	struct ice_nvgre_hdr nvgre_hdr;
 };
 
 /* This is mapping table entry that maps every word within a given protocol
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index a2dfe8e3d3fa..2af03b9845eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -35,6 +35,93 @@ struct ice_dummy_pkt_offsets {
 	u16 offset; /* ICE_PROTOCOL_LAST indicates end of list */
 };
 
+static const struct ice_dummy_pkt_offsets dummy_gre_tcp_packet_offsets[] = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_NVGRE,		34 },
+	{ ICE_MAC_IL,		42 },
+	{ ICE_IPV4_IL,		56 },
+	{ ICE_TCP_IL,		76 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+static const u8 dummy_gre_tcp_packet[] = {
+	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x3E,	/* ICE_IPV4_OFOS 14 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x2F, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x80, 0x00, 0x65, 0x58,	/* ICE_NVGRE 34 */
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_IL 42 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x08, 0x00,
+
+	0x45, 0x00, 0x00, 0x14,	/* ICE_IPV4_IL 56 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x06, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00,	/* ICE_TCP_IL 76 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x50, 0x02, 0x20, 0x00,
+	0x00, 0x00, 0x00, 0x00
+};
+
+static const struct ice_dummy_pkt_offsets dummy_gre_udp_packet_offsets[] = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_NVGRE,		34 },
+	{ ICE_MAC_IL,		42 },
+	{ ICE_IPV4_IL,		56 },
+	{ ICE_UDP_ILOS,		76 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+static const u8 dummy_gre_udp_packet[] = {
+	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x3E,	/* ICE_IPV4_OFOS 14 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x2F, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x80, 0x00, 0x65, 0x58,	/* ICE_NVGRE 34 */
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_IL 42 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x08, 0x00,
+
+	0x45, 0x00, 0x00, 0x14,	/* ICE_IPV4_IL 56 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x11, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00,	/* ICE_UDP_ILOS 76 */
+	0x00, 0x08, 0x00, 0x00,
+};
+
 static const struct ice_dummy_pkt_offsets dummy_udp_tun_tcp_packet_offsets[] = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
@@ -3683,6 +3770,7 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	{ ICE_UDP_ILOS,		{ 0, 2 } },
 	{ ICE_VXLAN,		{ 8, 10, 12, 14 } },
 	{ ICE_GENEVE,		{ 8, 10, 12, 14 } },
+	{ ICE_NVGRE,            { 0, 2, 4, 6 } },
 };
 
 static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
@@ -3699,6 +3787,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_UDP_ILOS,		ICE_UDP_ILOS_HW },
 	{ ICE_VXLAN,		ICE_UDP_OF_HW },
 	{ ICE_GENEVE,		ICE_UDP_OF_HW },
+	{ ICE_NVGRE,            ICE_GRE_OF_HW },
 };
 
 /**
@@ -4383,6 +4472,7 @@ static bool ice_tun_type_match_word(enum ice_sw_tunnel_type tun_type, u16 *mask)
 	switch (tun_type) {
 	case ICE_SW_TUN_GENEVE:
 	case ICE_SW_TUN_VXLAN:
+	case ICE_SW_TUN_NVGRE:
 		*mask = ICE_TUN_FLAG_MASK;
 		return true;
 
@@ -4445,6 +4535,9 @@ ice_get_compat_fv_bitmap(struct ice_hw *hw, struct ice_adv_rule_info *rinfo,
 	case ICE_SW_TUN_VXLAN:
 		prof_type = ICE_PROF_TUN_UDP;
 		break;
+	case ICE_SW_TUN_NVGRE:
+		prof_type = ICE_PROF_TUN_GRE;
+		break;
 	default:
 		prof_type = ICE_PROF_ALL;
 		break;
@@ -4663,6 +4756,20 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 			ipv6 = true;
 	}
 
+	if (tun_type == ICE_SW_TUN_NVGRE) {
+		if (tcp) {
+			*pkt = dummy_gre_tcp_packet;
+			*pkt_len = sizeof(dummy_gre_tcp_packet);
+			*offsets = dummy_gre_tcp_packet_offsets;
+			return;
+		}
+
+		*pkt = dummy_gre_udp_packet;
+		*pkt_len = sizeof(dummy_gre_udp_packet);
+		*offsets = dummy_gre_udp_packet_offsets;
+		return;
+	}
+
 	if (tun_type == ICE_SW_TUN_VXLAN ||
 	    tun_type == ICE_SW_TUN_GENEVE) {
 		if (tcp) {
@@ -4798,6 +4905,9 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		case ICE_SCTP_IL:
 			len = sizeof(struct ice_sctp_hdr);
 			break;
+		case ICE_NVGRE:
+			len = sizeof(struct ice_nvgre_hdr);
+			break;
 		case ICE_VXLAN:
 		case ICE_GENEVE:
 			len = sizeof(struct ice_udp_tnl_hdr);
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 920d9024a6c1..e5d23feb6701 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -102,6 +102,8 @@ ice_proto_type_from_tunnel(enum ice_tunnel_type type)
 		return ICE_VXLAN;
 	case TNL_GENEVE:
 		return ICE_GENEVE;
+	case TNL_GRETAP:
+		return ICE_NVGRE;
 	default:
 		return 0;
 	}
@@ -115,6 +117,8 @@ ice_sw_type_from_tunnel(enum ice_tunnel_type type)
 		return ICE_SW_TUN_VXLAN;
 	case TNL_GENEVE:
 		return ICE_SW_TUN_GENEVE;
+	case TNL_GRETAP:
+		return ICE_SW_TUN_NVGRE;
 	default:
 		return ICE_NON_TUN;
 	}
@@ -131,10 +135,22 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		u32 tenant_id;
 
 		list[i].type = ice_proto_type_from_tunnel(fltr->tunnel_type);
-		tenant_id = be32_to_cpu(fltr->tenant_id) << 8;
-		list[i].h_u.tnl_hdr.vni = cpu_to_be32(tenant_id);
-		memcpy(&list[i].m_u.tnl_hdr.vni, "\xff\xff\xff\x00", 4);
-		i++;
+		switch (fltr->tunnel_type) {
+		case TNL_VXLAN:
+		case TNL_GENEVE:
+			tenant_id = be32_to_cpu(fltr->tenant_id) << 8;
+			list[i].h_u.tnl_hdr.vni = cpu_to_be32(tenant_id);
+			memcpy(&list[i].m_u.tnl_hdr.vni, "\xff\xff\xff\x00", 4);
+			i++;
+			break;
+		case TNL_GRETAP:
+			list[i].h_u.nvgre_hdr.tni_flow = fltr->tenant_id;
+			memcpy(&list[i].m_u.nvgre_hdr.tni_flow, "\xff\xff\xff\xff", 4);
+			i++;
+			break;
+		default:
+			break;
+		}
 	}
 
 	if (flags & (ICE_TC_FLWR_FIELD_ENC_SRC_IPV4 |
@@ -332,6 +348,9 @@ static int ice_tc_tun_get_type(struct net_device *tunnel_dev)
 		return TNL_VXLAN;
 	if (netif_is_geneve(tunnel_dev))
 		return TNL_GENEVE;
+	if (netif_is_gretap(tunnel_dev) ||
+	    netif_is_ip6gretap(tunnel_dev))
+		return TNL_GRETAP;
 	return TNL_LAST;
 }
 
@@ -810,6 +829,7 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	u16 n_proto_mask = 0, n_proto_key = 0, addr_type = 0;
 	struct flow_dissector *dissector;
+	struct net_device *tunnel_dev;
 
 	dissector = rule->match.dissector;
 
@@ -831,17 +851,11 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		return -EOPNOTSUPP;
 	}
 
-	if ((flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
-	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) ||
-	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
-	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS))) {
+	tunnel_dev = ice_get_tunnel_device(filter_dev, rule);
+	if (tunnel_dev) {
 		int err;
 
-		filter_dev = ice_get_tunnel_device(filter_dev, rule);
-		if (!filter_dev) {
-			NL_SET_ERR_MSG_MOD(fltr->extack, "Tunnel device not found");
-			return -EOPNOTSUPP;
-		}
+		filter_dev = tunnel_dev;
 
 		err = ice_parse_tunnel_attr(filter_dev, rule, fltr);
 		if (err) {
@@ -853,6 +867,13 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		 * header were already set by ice_parse_tunnel_attr
 		 */
 		headers = &fltr->inner_headers;
+	} else if (dissector->used_keys &
+		  (BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
+		   BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+		   BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+		   BIT(FLOW_DISSECTOR_KEY_ENC_PORTS))) {
+		NL_SET_ERR_MSG_MOD(fltr->extack, "Tunnel key used, but device isn't a tunnel");
+		return -EOPNOTSUPP;
 	} else {
 		fltr->tunnel_type = TNL_LAST;
 	}
-- 
2.31.1

