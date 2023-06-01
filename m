Return-Path: <netdev+bounces-7094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F9C719E56
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B9CD1C20F8B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788D921CE5;
	Thu,  1 Jun 2023 13:32:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A632069E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:32:36 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE1A137
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685626344; x=1717162344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F6ymLhdcKz//QIJ/bkiRyza0kTDM5ukjtMcxL8tY8eY=;
  b=Wml6LwMTTK92HEDfl7yYWuWEGYHjp5JM06QvLP4tA9L6353ua8MMHhQp
   qOv62vBBFAgBfatZXLigOHLWWFhJYIs/NjaNe2iXubjHLRSz5T9obiuae
   pfoQ9pEqoGciUnWkPF0OWazeGLTT8gvkyYq2YVPrNbZoBgT/hwPJnhPMD
   iipr0g/KgOWqGuv+QP/rUw0uKH1lJVWuzt04vtSjIIxoBJFHJYxMkwmme
   FYXes2Rt5HqBD+5OcBPyU5S662/ekMRx4jlU3J3FGmZQ5Iy9yocG8oVP2
   hKWJXA1q/Cadf1M/pIlo5wam5T21eit7qWXDkqbompFANkmzKPuK931eH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="335906161"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="335906161"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:32:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="772427597"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="772427597"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2023 06:32:08 -0700
Received: from giewont.igk.intel.com (giewont.igk.intel.com [10.211.8.15])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 5736F34943;
	Thu,  1 Jun 2023 14:32:07 +0100 (IST)
From: Marcin Szycik <marcin.szycik@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	wojciech.drewek@intel.com,
	michal.swiatkowski@linux.intel.com,
	alexandr.lobakin@intel.com,
	davem@davemloft.net,
	kuba@kernel.org,
	jiri@resnulli.us,
	pabeni@redhat.com,
	jesse.brandeburg@intel.com,
	simon.horman@corigine.com,
	idosch@nvidia.com,
	Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH iwl-next 6/6] ice: Add support for PFCP hardware offload in switchdev
Date: Thu,  1 Jun 2023 15:19:29 +0200
Message-Id: <20230601131929.294667-7-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for creating PFCP filters in switchdev mode. Add support
for parsing PFCP-specific tc options: S flag and SEID.

To create a PFCP filter, a special netdev must be created and passed
to tc command:

ip link add pfcp0 type pfcp
tc filter add dev eth0 ingress prio 1 flower pfcp_opts \
1:123/ff:fffffffffffffff0 skip_hw action mirred egress redirect dev pfcp0

Changes in iproute2 are required to be able to add the pfcp netdev and use
pfcp_opts in tc.

ICE COMMS package is required to create a filter as it contains PFCP
profiles.

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c      |  9 ++
 .../net/ethernet/intel/ice/ice_flex_type.h    |  4 +-
 .../ethernet/intel/ice/ice_protocol_type.h    | 12 +++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 85 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_switch.h   |  2 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 58 +++++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  5 ++
 7 files changed, 168 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.c b/drivers/net/ethernet/intel/ice/ice_ddp.c
index d71ed210f9c4..b502405245dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -721,6 +721,12 @@ static bool ice_is_gtp_c_profile(u16 prof_idx)
 	}
 }
 
+static bool ice_is_pfcp_profile(u16 prof_idx)
+{
+	return prof_idx >= ICE_PROFID_IPV4_PFCP_NODE &&
+	       prof_idx <= ICE_PROFID_IPV6_PFCP_SESSION;
+}
+
 /**
  * ice_get_sw_prof_type - determine switch profile type
  * @hw: pointer to the HW structure
@@ -738,6 +744,9 @@ static enum ice_prof_type ice_get_sw_prof_type(struct ice_hw *hw,
 	if (ice_is_gtp_u_profile(prof_idx))
 		return ICE_PROF_TUN_GTPU;
 
+	if (ice_is_pfcp_profile(prof_idx))
+		return ICE_PROF_TUN_PFCP;
+
 	for (i = 0; i < hw->blk[ICE_BLK_SW].es.fvw; i++) {
 		/* UDP tunnel will have UDP_OF protocol ID and VNI offset */
 		if (fv->ew[i].prot_id == (u8)ICE_PROT_UDP_OF &&
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 4f42e14ed3ae..2dd8909dce2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -93,6 +93,7 @@ enum ice_tunnel_type {
 	TNL_GRETAP,
 	TNL_GTPC,
 	TNL_GTPU,
+	TNL_PFCP,
 	__TNL_TYPE_CNT,
 	TNL_LAST = 0xFF,
 	TNL_ALL = 0xFF,
@@ -351,7 +352,8 @@ enum ice_prof_type {
 	ICE_PROF_TUN_GRE = 0x4,
 	ICE_PROF_TUN_GTPU = 0x8,
 	ICE_PROF_TUN_GTPC = 0x10,
-	ICE_PROF_TUN_ALL = 0x1E,
+	ICE_PROF_TUN_PFCP = 0x20,
+	ICE_PROF_TUN_ALL = 0x3E,
 	ICE_PROF_ALL = 0xFF,
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 6a9364761165..a1543e995fa1 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -43,6 +43,7 @@ enum ice_protocol_type {
 	ICE_NVGRE,
 	ICE_GTP,
 	ICE_GTP_NO_PAY,
+	ICE_PFCP,
 	ICE_PPPOE,
 	ICE_L2TPV3,
 	ICE_VLAN_EX,
@@ -61,6 +62,7 @@ enum ice_sw_tunnel_type {
 	ICE_SW_TUN_NVGRE,
 	ICE_SW_TUN_GTPU,
 	ICE_SW_TUN_GTPC,
+	ICE_SW_TUN_PFCP,
 	ICE_ALL_TUNNELS /* All tunnel types including NVGRE */
 };
 
@@ -202,6 +204,15 @@ struct ice_udp_gtp_hdr {
 	u8 rsvrd;
 };
 
+struct ice_pfcp_hdr {
+	u8 flags;
+	u8 msg_type;
+	__be16 length;
+	__be64 seid;
+	__be32 seq;
+	u8 spare;
+} __packed __aligned(__alignof__(u16));
+
 struct ice_pppoe_hdr {
 	u8 rsrvd_ver_type;
 	u8 rsrvd_code;
@@ -417,6 +428,7 @@ union ice_prot_hdr {
 	struct ice_udp_tnl_hdr tnl_hdr;
 	struct ice_nvgre_hdr nvgre_hdr;
 	struct ice_udp_gtp_hdr gtp_hdr;
+	struct ice_pfcp_hdr pfcp_hdr;
 	struct ice_pppoe_hdr pppoe_hdr;
 	struct ice_l2tpv3_sess_hdr l2tpv3_sess_hdr;
 	struct ice_hw_metadata metadata;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index d69efd33beee..bdcd38d6e9bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -43,6 +43,7 @@ enum {
 	ICE_PKT_KMALLOC		= BIT(9),
 	ICE_PKT_PPPOE		= BIT(10),
 	ICE_PKT_L2TPV3		= BIT(11),
+	ICE_PKT_PFCP		= BIT(12),
 };
 
 struct ice_dummy_pkt_offsets {
@@ -1111,6 +1112,77 @@ ICE_DECLARE_PKT_TEMPLATE(ipv6_gtp) = {
 	0x00, 0x00,
 };
 
+ICE_DECLARE_PKT_OFFSETS(pfcp_session_ipv4) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_UDP_ILOS,		34 },
+	{ ICE_PFCP,		42 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(pfcp_session_ipv4) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x2c, /* ICE_IPV4_OFOS 14 */
+	0x00, 0x01, 0x00, 0x00,
+	0x00, 0x11, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x22, 0x65, /* ICE_UDP_ILOS 34 */
+	0x00, 0x18, 0x00, 0x00,
+
+	0x21, 0x01, 0x00, 0x0c, /* ICE_PFCP 42 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00,		/* 2 bytes for 4 byte alignment */
+};
+
+ICE_DECLARE_PKT_OFFSETS(pfcp_session_ipv6) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV6_OFOS,	14 },
+	{ ICE_UDP_ILOS,		54 },
+	{ ICE_PFCP,		62 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(pfcp_session_ipv6) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x86, 0xdd,		/* ICE_ETYPE_OL 12 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_OFOS 14 */
+	0x00, 0x10, 0x11, 0x00, /* Next header UDP */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x22, 0x65, /* ICE_UDP_ILOS 54 */
+	0x00, 0x18, 0x00, 0x00,
+
+	0x21, 0x01, 0x00, 0x0c, /* ICE_PFCP 62 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00,		/* 2 bytes for 4 byte alignment */
+};
+
 ICE_DECLARE_PKT_OFFSETS(pppoe_ipv4_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
@@ -1344,6 +1416,8 @@ static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(ipv4_gtpu_ipv4_tcp, ICE_PKT_TUN_GTPU),
 	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPC | ICE_PKT_OUTER_IPV6),
 	ICE_PKT_PROFILE(ipv4_gtpu_ipv4, ICE_PKT_TUN_GTPC),
+	ICE_PKT_PROFILE(pfcp_session_ipv6, ICE_PKT_PFCP | ICE_PKT_OUTER_IPV6),
+	ICE_PKT_PROFILE(pfcp_session_ipv4, ICE_PKT_PFCP),
 	ICE_PKT_PROFILE(pppoe_ipv6_udp, ICE_PKT_PPPOE | ICE_PKT_OUTER_IPV6 |
 					ICE_PKT_INNER_UDP),
 	ICE_PKT_PROFILE(pppoe_ipv6_tcp, ICE_PKT_PPPOE | ICE_PKT_OUTER_IPV6),
@@ -4578,6 +4652,7 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	ICE_PROTOCOL_ENTRY(ICE_NVGRE, 0, 2, 4, 6),
 	ICE_PROTOCOL_ENTRY(ICE_GTP, 8, 10, 12, 14, 16, 18, 20, 22),
 	ICE_PROTOCOL_ENTRY(ICE_GTP_NO_PAY, 8, 10, 12, 14),
+	ICE_PROTOCOL_ENTRY(ICE_PFCP, 8, 10, 12, 14, 16, 18, 20, 22),
 	ICE_PROTOCOL_ENTRY(ICE_PPPOE, 0, 2, 4, 6),
 	ICE_PROTOCOL_ENTRY(ICE_L2TPV3, 0, 2, 4, 6, 8, 10),
 	ICE_PROTOCOL_ENTRY(ICE_VLAN_EX, 2, 0),
@@ -4611,6 +4686,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_NVGRE,		ICE_GRE_OF_HW },
 	{ ICE_GTP,		ICE_UDP_OF_HW },
 	{ ICE_GTP_NO_PAY,	ICE_UDP_ILOS_HW },
+	{ ICE_PFCP,		ICE_UDP_ILOS_HW },
 	{ ICE_PPPOE,		ICE_PPPOE_HW },
 	{ ICE_L2TPV3,		ICE_L2TPV3_HW },
 	{ ICE_VLAN_EX,          ICE_VLAN_OF_HW },
@@ -5318,6 +5394,9 @@ ice_get_compat_fv_bitmap(struct ice_hw *hw, struct ice_adv_rule_info *rinfo,
 	case ICE_SW_TUN_GTPC:
 		prof_type = ICE_PROF_TUN_GTPC;
 		break;
+	case ICE_SW_TUN_PFCP:
+		prof_type = ICE_PROF_TUN_PFCP;
+		break;
 	case ICE_SW_TUN_AND_NON_TUN:
 	default:
 		prof_type = ICE_PROF_ALL;
@@ -5602,6 +5681,9 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 	case ICE_SW_TUN_VXLAN:
 		match |= ICE_PKT_TUN_UDP;
 		break;
+	case ICE_SW_TUN_PFCP:
+		match |= ICE_PKT_PFCP;
+		break;
 	default:
 		break;
 	}
@@ -5742,6 +5824,9 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		case ICE_GTP:
 			len = sizeof(struct ice_udp_gtp_hdr);
 			break;
+		case ICE_PFCP:
+			len = sizeof(struct ice_pfcp_hdr);
+			break;
 		case ICE_PPPOE:
 			len = sizeof(struct ice_pppoe_hdr);
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 838a2823b3dc..3ae8429167fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -21,6 +21,8 @@
 #define ICE_PROFID_IPV6_GTPC_NO_TEID			45
 #define ICE_PROFID_IPV6_GTPU_TEID			46
 #define ICE_PROFID_IPV6_GTPU_IPV6_TCP_INNER		70
+#define ICE_PROFID_IPV4_PFCP_NODE			79
+#define ICE_PROFID_IPV6_PFCP_SESSION			82
 
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index b48ded4bd067..f625d0920ae6 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -30,6 +30,9 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & ICE_TC_FLWR_FIELD_GTP_OPTS)
 		lkups_cnt++;
 
+	if (flags & ICE_TC_FLWR_FIELD_PFCP_OPTS)
+		lkups_cnt++;
+
 	if (flags & (ICE_TC_FLWR_FIELD_ENC_SRC_IPV4 |
 		     ICE_TC_FLWR_FIELD_ENC_DEST_IPV4 |
 		     ICE_TC_FLWR_FIELD_ENC_SRC_IPV6 |
@@ -138,6 +141,8 @@ ice_proto_type_from_tunnel(enum ice_tunnel_type type)
 		return ICE_GTP;
 	case TNL_GTPC:
 		return ICE_GTP_NO_PAY;
+	case TNL_PFCP:
+		return ICE_PFCP;
 	default:
 		return 0;
 	}
@@ -157,6 +162,8 @@ ice_sw_type_from_tunnel(enum ice_tunnel_type type)
 		return ICE_SW_TUN_GTPU;
 	case TNL_GTPC:
 		return ICE_SW_TUN_GTPC;
+	case TNL_PFCP:
+		return ICE_SW_TUN_PFCP;
 	default:
 		return ICE_NON_TUN;
 	}
@@ -237,6 +244,22 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		i++;
 	}
 
+	if (flags & ICE_TC_FLWR_FIELD_PFCP_OPTS) {
+		struct ice_pfcp_hdr *hdr_h, *hdr_m;
+
+		hdr_h = &list[i].h_u.pfcp_hdr;
+		hdr_m = &list[i].m_u.pfcp_hdr;
+		list[i].type = ICE_PFCP;
+
+		hdr_h->flags = fltr->pfcp_meta_keys.type;
+		hdr_m->flags = fltr->pfcp_meta_masks.type & 0x01;
+
+		hdr_h->seid = fltr->pfcp_meta_keys.seid;
+		hdr_m->seid = fltr->pfcp_meta_masks.seid;
+
+		i++;
+	}
+
 	if (flags & (ICE_TC_FLWR_FIELD_ENC_SRC_IPV4 |
 		     ICE_TC_FLWR_FIELD_ENC_DEST_IPV4)) {
 		list[i].type = ice_proto_type_from_ipv4(false);
@@ -365,8 +388,11 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 	if (tc_fltr->tunnel_type != TNL_LAST) {
 		i = ice_tc_fill_tunnel_outer(flags, tc_fltr, list);
 
-		headers = &tc_fltr->inner_headers;
-		inner = true;
+		/* PFCP is considered non-tunneled - don't swap headers. */
+		if (tc_fltr->tunnel_type != TNL_PFCP) {
+			headers = &tc_fltr->inner_headers;
+			inner = true;
+		}
 	}
 
 	if (flags & ICE_TC_FLWR_FIELD_ETH_TYPE_ID) {
@@ -621,6 +647,8 @@ static int ice_tc_tun_get_type(struct net_device *tunnel_dev)
 	 */
 	if (netif_is_gtp(tunnel_dev))
 		return TNL_GTPU;
+	if (netif_is_pfcp(tunnel_dev))
+		return TNL_PFCP;
 	return TNL_LAST;
 }
 
@@ -1319,6 +1347,20 @@ ice_parse_tunnel_attr(struct net_device *dev, struct flow_rule *rule,
 		fltr->flags |= ICE_TC_FLWR_FIELD_GTP_OPTS;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS) &&
+	    fltr->tunnel_type == TNL_PFCP) {
+		struct flow_match_enc_opts match;
+
+		flow_rule_match_enc_opts(rule, &match);
+
+		memcpy(&fltr->pfcp_meta_keys, &match.key->data[0],
+		       sizeof(struct pfcp_metadata));
+		memcpy(&fltr->pfcp_meta_masks, &match.mask->data[0],
+		       sizeof(struct pfcp_metadata));
+
+		fltr->flags |= ICE_TC_FLWR_FIELD_PFCP_OPTS;
+	}
+
 	return 0;
 }
 
@@ -1377,10 +1419,14 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 			return err;
 		}
 
-		/* header pointers should point to the inner headers, outer
-		 * header were already set by ice_parse_tunnel_attr
-		 */
-		headers = &fltr->inner_headers;
+		/* PFCP is considered non-tunneled - don't swap headers. */
+		if (fltr->tunnel_type != TNL_PFCP) {
+			/* Header pointers should point to the inner headers,
+			 * outer header were already set by
+			 * ice_parse_tunnel_attr().
+			 */
+			headers = &fltr->inner_headers;
+		}
 	} else if (dissector->used_keys &
 		  (BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
 		   BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index aed48d1ff83f..7e6560ec083c 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -4,6 +4,8 @@
 #ifndef _ICE_TC_LIB_H_
 #define _ICE_TC_LIB_H_
 
+#include <net/pfcp.h>
+
 #define ICE_TC_FLWR_FIELD_DST_MAC		BIT(0)
 #define ICE_TC_FLWR_FIELD_SRC_MAC		BIT(1)
 #define ICE_TC_FLWR_FIELD_VLAN			BIT(2)
@@ -34,6 +36,7 @@
 #define ICE_TC_FLWR_FIELD_VLAN_PRIO		BIT(27)
 #define ICE_TC_FLWR_FIELD_CVLAN_PRIO		BIT(28)
 #define ICE_TC_FLWR_FIELD_VLAN_TPID		BIT(29)
+#define ICE_TC_FLWR_FIELD_PFCP_OPTS		BIT(30)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
@@ -161,6 +164,8 @@ struct ice_tc_flower_fltr {
 	__be32 tenant_id;
 	struct gtp_pdu_session_info gtp_pdu_info_keys;
 	struct gtp_pdu_session_info gtp_pdu_info_masks;
+	struct pfcp_metadata pfcp_meta_keys;
+	struct pfcp_metadata pfcp_meta_masks;
 	u32 flags;
 	u8 tunnel_type;
 	struct ice_tc_flower_action	action;
-- 
2.31.1


