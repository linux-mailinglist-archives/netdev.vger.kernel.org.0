Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF8E3450D2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhCVUbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:31:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:5504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231390AbhCVUbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:19 -0400
IronPort-SDR: vwGdwSICv+CKZdAIeAYLly32fbE+D5SzebGnE4seAMcOR0pxlYMe6XEGmjB7HwErUwqAZBxeR3
 LabVTcT3ElkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438212"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438212"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: itpShH4rtJjQ8llQsO+dwI5IfGEXGepRpCUd0odMYfRLrrZeLHG/J3yJxM/LCgji4JEZ3LjJf0
 40xSqWLTDbvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810579"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        haiyue.wang@intel.com, Ting Xu <ting.xu@intel.com>,
        Yahui Cao <yahui.cao@intel.com>, Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 03/18] ice: Add more advanced protocol support in flow filter
Date:   Mon, 22 Mar 2021 13:32:29 -0700
Message-Id: <20210322203244.2525310-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

Add more protocol support in flow filter, these
include PPPoE, L2TPv3, GTP, PFCP, ESP and AH.

Signed-off-by: Ting Xu <ting.xu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c     | 271 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     | 128 ++++++++-
 .../ethernet/intel/ice/ice_protocol_type.h    |   4 +
 3 files changed, 397 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 39744773a403..fddf5c24930b 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -96,6 +96,38 @@ struct ice_flow_field_info ice_flds_info[ICE_FLOW_FIELD_IDX_MAX] = {
 	/* ICE_FLOW_FIELD_IDX_GRE_KEYID */
 	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GRE, 12,
 			  sizeof_field(struct gre_full_hdr, key)),
+	/* GTP */
+	/* ICE_FLOW_FIELD_IDX_GTPC_TEID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GTPC_TEID, 12, sizeof(__be32)),
+	/* ICE_FLOW_FIELD_IDX_GTPU_IP_TEID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GTPU_IP, 12, sizeof(__be32)),
+	/* ICE_FLOW_FIELD_IDX_GTPU_EH_TEID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GTPU_EH, 12, sizeof(__be32)),
+	/* ICE_FLOW_FIELD_IDX_GTPU_EH_QFI */
+	ICE_FLOW_FLD_INFO_MSK(ICE_FLOW_SEG_HDR_GTPU_EH, 22, sizeof(__be16),
+			      0x3f00),
+	/* ICE_FLOW_FIELD_IDX_GTPU_UP_TEID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GTPU_UP, 12, sizeof(__be32)),
+	/* ICE_FLOW_FIELD_IDX_GTPU_DWN_TEID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GTPU_DWN, 12, sizeof(__be32)),
+	/* PPPoE */
+	/* ICE_FLOW_FIELD_IDX_PPPOE_SESS_ID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_PPPOE, 2, sizeof(__be16)),
+	/* PFCP */
+	/* ICE_FLOW_FIELD_IDX_PFCP_SEID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_PFCP_SESSION, 12, sizeof(__be64)),
+	/* L2TPv3 */
+	/* ICE_FLOW_FIELD_IDX_L2TPV3_SESS_ID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_L2TPV3, 0, sizeof(__be32)),
+	/* ESP */
+	/* ICE_FLOW_FIELD_IDX_ESP_SPI */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_ESP, 0, sizeof(__be32)),
+	/* AH */
+	/* ICE_FLOW_FIELD_IDX_AH_SPI */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_AH, 4, sizeof(__be32)),
+	/* NAT_T_ESP */
+	/* ICE_FLOW_FIELD_IDX_NAT_T_ESP_SPI */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_NAT_T_ESP, 8, sizeof(__be32)),
 };
 
 /* Bitmaps indicating relevant packet types for a particular protocol header
@@ -128,6 +160,8 @@ static const u32 ice_ptypes_macvlan_il[] = {
 /* Packet types for packets with an Outer/First/Single IPv4 header */
 static const u32 ice_ptypes_ipv4_ofos[] = {
 	0x1DC00000, 0x04000800, 0x00000000, 0x00000000,
+	0x00000000, 0x00000155, 0x00000000, 0x00000000,
+	0x00000000, 0x000FC000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -141,7 +175,7 @@ static const u32 ice_ptypes_ipv4_ofos[] = {
 static const u32 ice_ptypes_ipv4_il[] = {
 	0xE0000000, 0xB807700E, 0x80000003, 0xE01DC03B,
 	0x0000000E, 0x00000000, 0x00000000, 0x00000000,
-	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x001FF800, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -152,6 +186,8 @@ static const u32 ice_ptypes_ipv4_il[] = {
 /* Packet types for packets with an Outer/First/Single IPv6 header */
 static const u32 ice_ptypes_ipv6_ofos[] = {
 	0x00000000, 0x00000000, 0x77000000, 0x10002000,
+	0x00000000, 0x000002AA, 0x00000000, 0x00000000,
+	0x00000000, 0x03F00000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -165,7 +201,7 @@ static const u32 ice_ptypes_ipv6_ofos[] = {
 static const u32 ice_ptypes_ipv6_il[] = {
 	0x00000000, 0x03B80770, 0x000001DC, 0x0EE00000,
 	0x00000770, 0x00000000, 0x00000000, 0x00000000,
-	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x7FE00000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -239,7 +275,7 @@ static const u32 ice_ipv6_il_no_l4[] = {
 static const u32 ice_ptypes_udp_il[] = {
 	0x81000000, 0x20204040, 0x04000010, 0x80810102,
 	0x00000040, 0x00000000, 0x00000000, 0x00000000,
-	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00410000, 0x90842000, 0x00000007,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -251,7 +287,7 @@ static const u32 ice_ptypes_udp_il[] = {
 static const u32 ice_ptypes_tcp_il[] = {
 	0x04000000, 0x80810102, 0x10000040, 0x02040408,
 	0x00000102, 0x00000000, 0x00000000, 0x00000000,
-	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00820000, 0x21084000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -263,6 +299,7 @@ static const u32 ice_ptypes_tcp_il[] = {
 static const u32 ice_ptypes_sctp_il[] = {
 	0x08000000, 0x01020204, 0x20000081, 0x04080810,
 	0x00000204, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x01040000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -318,6 +355,125 @@ static const u32 ice_ptypes_mac_il[] = {
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 };
 
+/* Packet types for GTPC */
+static const u32 ice_ptypes_gtpc[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000180, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for GTPC with TEID */
+static const u32 ice_ptypes_gtpc_tid[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000060, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+static const u32 ice_ptypes_gtpu[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x7FFFFE00, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for PPPoE */
+static const u32 ice_ptypes_pppoe[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x03ffe000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with PFCP NODE header */
+static const u32 ice_ptypes_pfcp_node[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x80000000, 0x00000002,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with PFCP SESSION header */
+static const u32 ice_ptypes_pfcp_session[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000005,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for L2TPv3 */
+static const u32 ice_ptypes_l2tpv3[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000300,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for ESP */
+static const u32 ice_ptypes_esp[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000003, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for AH */
+static const u32 ice_ptypes_ah[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x0000000C, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with NAT_T ESP header */
+static const u32 ice_ptypes_nat_t_esp[] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000030, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
 /* Manage parameters and info. used during the creation of a flow profile */
 struct ice_flow_prof_params {
 	enum ice_block blk;
@@ -334,6 +490,15 @@ struct ice_flow_prof_params {
 	DECLARE_BITMAP(ptypes, ICE_FLOW_PTYPE_MAX);
 };
 
+#define ICE_FLOW_RSS_HDRS_INNER_MASK \
+	(ICE_FLOW_SEG_HDR_PPPOE | ICE_FLOW_SEG_HDR_GTPC | \
+	ICE_FLOW_SEG_HDR_GTPC_TEID | ICE_FLOW_SEG_HDR_GTPU | \
+	ICE_FLOW_SEG_HDR_PFCP_SESSION | ICE_FLOW_SEG_HDR_L2TPV3 | \
+	ICE_FLOW_SEG_HDR_ESP | ICE_FLOW_SEG_HDR_AH | \
+	ICE_FLOW_SEG_HDR_NAT_T_ESP)
+
+#define ICE_FLOW_SEG_HDRS_L2_MASK	\
+	(ICE_FLOW_SEG_HDR_ETH | ICE_FLOW_SEG_HDR_VLAN)
 #define ICE_FLOW_SEG_HDRS_L3_MASK	\
 	(ICE_FLOW_SEG_HDR_IPV4 | ICE_FLOW_SEG_HDR_IPV6 | ICE_FLOW_SEG_HDR_ARP)
 #define ICE_FLOW_SEG_HDRS_L4_MASK	\
@@ -478,6 +643,16 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 				   ICE_FLOW_PTYPE_MAX);
 		}
 
+		if (hdrs & ICE_FLOW_SEG_HDR_PPPOE) {
+			src = (const unsigned long *)ice_ptypes_pppoe;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else {
+			src = (const unsigned long *)ice_ptypes_pppoe;
+			bitmap_andnot(params->ptypes, params->ptypes, src,
+				      ICE_FLOW_PTYPE_MAX);
+		}
+
 		if (hdrs & ICE_FLOW_SEG_HDR_UDP) {
 			src = (const unsigned long *)ice_ptypes_udp_il;
 			bitmap_and(params->ptypes, params->ptypes, src,
@@ -503,6 +678,64 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 				bitmap_and(params->ptypes, params->ptypes,
 					   src, ICE_FLOW_PTYPE_MAX);
 			}
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GTPC) {
+			src = (const unsigned long *)ice_ptypes_gtpc;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GTPC_TEID) {
+			src = (const unsigned long *)ice_ptypes_gtpc_tid;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GTPU_DWN) {
+			src = (const unsigned long *)ice_ptypes_gtpu;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GTPU_UP) {
+			src = (const unsigned long *)ice_ptypes_gtpu;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GTPU_EH) {
+			src = (const unsigned long *)ice_ptypes_gtpu;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GTPU_IP) {
+			src = (const unsigned long *)ice_ptypes_gtpu;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_L2TPV3) {
+			src = (const unsigned long *)ice_ptypes_l2tpv3;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_ESP) {
+			src = (const unsigned long *)ice_ptypes_esp;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_AH) {
+			src = (const unsigned long *)ice_ptypes_ah;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_NAT_T_ESP) {
+			src = (const unsigned long *)ice_ptypes_nat_t_esp;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		}
+
+		if (hdrs & ICE_FLOW_SEG_HDR_PFCP) {
+			if (hdrs & ICE_FLOW_SEG_HDR_PFCP_NODE)
+				src = (const unsigned long *)ice_ptypes_pfcp_node;
+			else
+				src = (const unsigned long *)ice_ptypes_pfcp_session;
+
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else {
+			src = (const unsigned long *)ice_ptypes_pfcp_node;
+			bitmap_andnot(params->ptypes, params->ptypes, src,
+				      ICE_FLOW_PTYPE_MAX);
+
+			src = (const unsigned long *)ice_ptypes_pfcp_session;
+			bitmap_andnot(params->ptypes, params->ptypes, src,
+				      ICE_FLOW_PTYPE_MAX);
 		}
 	}
 
@@ -611,6 +844,33 @@ ice_flow_xtract_fld(struct ice_hw *hw, struct ice_flow_prof_params *params,
 	case ICE_FLOW_FIELD_IDX_SCTP_DST_PORT:
 		prot_id = ICE_PROT_SCTP_IL;
 		break;
+	case ICE_FLOW_FIELD_IDX_GTPC_TEID:
+	case ICE_FLOW_FIELD_IDX_GTPU_IP_TEID:
+	case ICE_FLOW_FIELD_IDX_GTPU_UP_TEID:
+	case ICE_FLOW_FIELD_IDX_GTPU_DWN_TEID:
+	case ICE_FLOW_FIELD_IDX_GTPU_EH_TEID:
+	case ICE_FLOW_FIELD_IDX_GTPU_EH_QFI:
+		/* GTP is accessed through UDP OF protocol */
+		prot_id = ICE_PROT_UDP_OF;
+		break;
+	case ICE_FLOW_FIELD_IDX_PPPOE_SESS_ID:
+		prot_id = ICE_PROT_PPPOE;
+		break;
+	case ICE_FLOW_FIELD_IDX_PFCP_SEID:
+		prot_id = ICE_PROT_UDP_IL_OR_S;
+		break;
+	case ICE_FLOW_FIELD_IDX_L2TPV3_SESS_ID:
+		prot_id = ICE_PROT_L2TPV3;
+		break;
+	case ICE_FLOW_FIELD_IDX_ESP_SPI:
+		prot_id = ICE_PROT_ESP_F;
+		break;
+	case ICE_FLOW_FIELD_IDX_AH_SPI:
+		prot_id = ICE_PROT_ESP_2;
+		break;
+	case ICE_FLOW_FIELD_IDX_NAT_T_ESP_SPI:
+		prot_id = ICE_PROT_UDP_IL_OR_S;
+		break;
 	case ICE_FLOW_FIELD_IDX_ARP_SIP:
 	case ICE_FLOW_FIELD_IDX_ARP_DIP:
 	case ICE_FLOW_FIELD_IDX_ARP_SHA:
@@ -1446,7 +1706,8 @@ ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
 
 	ICE_FLOW_SET_HDRS(segs, flow_hdr);
 
-	if (segs->hdrs & ~ICE_FLOW_RSS_SEG_HDR_VAL_MASKS)
+	if (segs->hdrs & ~ICE_FLOW_RSS_SEG_HDR_VAL_MASKS &
+	    ~ICE_FLOW_RSS_HDRS_INNER_MASK)
 		return ICE_ERR_PARAM;
 
 	val = (u64)(segs->hdrs & ICE_FLOW_RSS_SEG_HDR_L3_MASKS);
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 612ea3be21a9..feda2ffd47ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -30,6 +30,80 @@
 #define ICE_HASH_UDP_IPV4	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_UDP_PORT)
 #define ICE_HASH_UDP_IPV6	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_UDP_PORT)
 
+#define ICE_FLOW_HASH_GTP_TEID \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_GTPC_TEID))
+
+#define ICE_FLOW_HASH_GTP_IPV4_TEID \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_GTP_TEID)
+#define ICE_FLOW_HASH_GTP_IPV6_TEID \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_GTP_TEID)
+
+#define ICE_FLOW_HASH_GTP_U_TEID \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_GTPU_IP_TEID))
+
+#define ICE_FLOW_HASH_GTP_U_IPV4_TEID \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_GTP_U_TEID)
+#define ICE_FLOW_HASH_GTP_U_IPV6_TEID \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_GTP_U_TEID)
+
+#define ICE_FLOW_HASH_GTP_U_EH_TEID \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_GTPU_EH_TEID))
+
+#define ICE_FLOW_HASH_GTP_U_EH_QFI \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_GTPU_EH_QFI))
+
+#define ICE_FLOW_HASH_GTP_U_IPV4_EH \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_GTP_U_EH_TEID | \
+	 ICE_FLOW_HASH_GTP_U_EH_QFI)
+#define ICE_FLOW_HASH_GTP_U_IPV6_EH \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_GTP_U_EH_TEID | \
+	 ICE_FLOW_HASH_GTP_U_EH_QFI)
+
+#define ICE_FLOW_HASH_PPPOE_SESS_ID \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_PPPOE_SESS_ID))
+
+#define ICE_FLOW_HASH_PPPOE_SESS_ID_ETH \
+	(ICE_FLOW_HASH_ETH | ICE_FLOW_HASH_PPPOE_SESS_ID)
+#define ICE_FLOW_HASH_PPPOE_TCP_ID \
+	(ICE_FLOW_HASH_TCP_PORT | ICE_FLOW_HASH_PPPOE_SESS_ID)
+#define ICE_FLOW_HASH_PPPOE_UDP_ID \
+	(ICE_FLOW_HASH_UDP_PORT | ICE_FLOW_HASH_PPPOE_SESS_ID)
+
+#define ICE_FLOW_HASH_PFCP_SEID \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_PFCP_SEID))
+#define ICE_FLOW_HASH_PFCP_IPV4_SEID \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_PFCP_SEID)
+#define ICE_FLOW_HASH_PFCP_IPV6_SEID \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_PFCP_SEID)
+
+#define ICE_FLOW_HASH_L2TPV3_SESS_ID \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_L2TPV3_SESS_ID))
+#define ICE_FLOW_HASH_L2TPV3_IPV4_SESS_ID \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_L2TPV3_SESS_ID)
+#define ICE_FLOW_HASH_L2TPV3_IPV6_SESS_ID \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_L2TPV3_SESS_ID)
+
+#define ICE_FLOW_HASH_ESP_SPI \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_ESP_SPI))
+#define ICE_FLOW_HASH_ESP_IPV4_SPI \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_ESP_SPI)
+#define ICE_FLOW_HASH_ESP_IPV6_SPI \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_ESP_SPI)
+
+#define ICE_FLOW_HASH_AH_SPI \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_AH_SPI))
+#define ICE_FLOW_HASH_AH_IPV4_SPI \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_AH_SPI)
+#define ICE_FLOW_HASH_AH_IPV6_SPI \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_AH_SPI)
+
+#define ICE_FLOW_HASH_NAT_T_ESP_SPI \
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_NAT_T_ESP_SPI))
+#define ICE_FLOW_HASH_NAT_T_ESP_IPV4_SPI \
+	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_NAT_T_ESP_SPI)
+#define ICE_FLOW_HASH_NAT_T_ESP_IPV6_SPI \
+	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_NAT_T_ESP_SPI)
+
 /* Protocol header fields within a packet segment. A segment consists of one or
  * more protocol headers that make up a logical group of protocol headers. Each
  * logical group of protocol headers encapsulates or is encapsulated using/by
@@ -48,8 +122,37 @@ enum ice_flow_seg_hdr {
 	ICE_FLOW_SEG_HDR_UDP		= 0x00000080,
 	ICE_FLOW_SEG_HDR_SCTP		= 0x00000100,
 	ICE_FLOW_SEG_HDR_GRE		= 0x00000200,
+	ICE_FLOW_SEG_HDR_GTPC		= 0x00000400,
+	ICE_FLOW_SEG_HDR_GTPC_TEID	= 0x00000800,
+	ICE_FLOW_SEG_HDR_GTPU_IP	= 0x00001000,
+	ICE_FLOW_SEG_HDR_GTPU_EH	= 0x00002000,
+	ICE_FLOW_SEG_HDR_GTPU_DWN	= 0x00004000,
+	ICE_FLOW_SEG_HDR_GTPU_UP	= 0x00008000,
+	ICE_FLOW_SEG_HDR_PPPOE		= 0x00010000,
+	ICE_FLOW_SEG_HDR_PFCP_NODE	= 0x00020000,
+	ICE_FLOW_SEG_HDR_PFCP_SESSION	= 0x00040000,
+	ICE_FLOW_SEG_HDR_L2TPV3		= 0x00080000,
+	ICE_FLOW_SEG_HDR_ESP		= 0x00100000,
+	ICE_FLOW_SEG_HDR_AH		= 0x00200000,
+	ICE_FLOW_SEG_HDR_NAT_T_ESP	= 0x00400000,
 };
 
+/* These segments all have the same PTYPES, but are otherwise distinguished by
+ * the value of the gtp_eh_pdu and gtp_eh_pdu_link flags:
+ *
+ *                                gtp_eh_pdu     gtp_eh_pdu_link
+ * ICE_FLOW_SEG_HDR_GTPU_IP           0              0
+ * ICE_FLOW_SEG_HDR_GTPU_EH           1              don't care
+ * ICE_FLOW_SEG_HDR_GTPU_DWN          1              0
+ * ICE_FLOW_SEG_HDR_GTPU_UP           1              1
+ */
+#define ICE_FLOW_SEG_HDR_GTPU (ICE_FLOW_SEG_HDR_GTPU_IP | \
+			       ICE_FLOW_SEG_HDR_GTPU_EH | \
+			       ICE_FLOW_SEG_HDR_GTPU_DWN | \
+			       ICE_FLOW_SEG_HDR_GTPU_UP)
+#define ICE_FLOW_SEG_HDR_PFCP (ICE_FLOW_SEG_HDR_PFCP_NODE | \
+			       ICE_FLOW_SEG_HDR_PFCP_SESSION)
+
 enum ice_flow_field {
 	/* L2 */
 	ICE_FLOW_FIELD_IDX_ETH_DA,
@@ -87,7 +190,30 @@ enum ice_flow_field {
 	ICE_FLOW_FIELD_IDX_ICMP_CODE,
 	/* GRE */
 	ICE_FLOW_FIELD_IDX_GRE_KEYID,
-	/* The total number of enums must not exceed 64 */
+	/* GTPC_TEID */
+	ICE_FLOW_FIELD_IDX_GTPC_TEID,
+	/* GTPU_IP */
+	ICE_FLOW_FIELD_IDX_GTPU_IP_TEID,
+	/* GTPU_EH */
+	ICE_FLOW_FIELD_IDX_GTPU_EH_TEID,
+	ICE_FLOW_FIELD_IDX_GTPU_EH_QFI,
+	/* GTPU_UP */
+	ICE_FLOW_FIELD_IDX_GTPU_UP_TEID,
+	/* GTPU_DWN */
+	ICE_FLOW_FIELD_IDX_GTPU_DWN_TEID,
+	/* PPPoE */
+	ICE_FLOW_FIELD_IDX_PPPOE_SESS_ID,
+	/* PFCP */
+	ICE_FLOW_FIELD_IDX_PFCP_SEID,
+	/* L2TPv3 */
+	ICE_FLOW_FIELD_IDX_L2TPV3_SESS_ID,
+	/* ESP */
+	ICE_FLOW_FIELD_IDX_ESP_SPI,
+	/* AH */
+	ICE_FLOW_FIELD_IDX_AH_SPI,
+	/* NAT_T ESP */
+	ICE_FLOW_FIELD_IDX_NAT_T_ESP_SPI,
+	 /* The total number of enums must not exceed 64 */
 	ICE_FLOW_FIELD_IDX_MAX
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index fac5f15a692c..199aa5b71540 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -24,9 +24,13 @@ enum ice_prot_id {
 	ICE_PROT_UDP_OF		= 52,
 	ICE_PROT_UDP_IL_OR_S	= 53,
 	ICE_PROT_GRE_OF		= 64,
+	ICE_PROT_ESP_F		= 88,
+	ICE_PROT_ESP_2		= 89,
 	ICE_PROT_SCTP_IL	= 96,
 	ICE_PROT_ICMP_IL	= 98,
 	ICE_PROT_ICMPV6_IL	= 100,
+	ICE_PROT_PPPOE		= 103,
+	ICE_PROT_L2TPV3		= 104,
 	ICE_PROT_ARP_OF		= 118,
 	ICE_PROT_META_ID	= 255, /* when offset == metadata */
 	ICE_PROT_INVALID	= 255  /* when offset == ICE_FV_OFFSET_INVAL */
-- 
2.26.2

