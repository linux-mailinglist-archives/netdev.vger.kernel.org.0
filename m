Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3A3450DB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhCVUcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:5513 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhCVUbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:23 -0400
IronPort-SDR: 7qNAA6OcD6lgksWkcs7E9fE/anrQHkvCBGngzBMgo1v5s3M0gt20yL1dyFb869Y4xuKSHmmWaT
 nb0VtsqIydEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438221"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438221"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: 3w7SuI5BmQu8iLs5Xga3OnL+aPyI0O8ceJyiHFoTFcbmu6FxJCokKPXBpRtIgwHkYgpWTH2v6f
 XXgA/77CtjbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810616"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        haiyue.wang@intel.com, Yahui Cao <yahui.cao@intel.com>,
        Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 12/18] ice: Add more FDIR filter type for AVF
Date:   Mon, 22 Mar 2021 13:32:38 -0700
Message-Id: <20210322203244.2525310-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

FDIR for AVF can forward
- L2TPV3 packets by matching session id.
- IPSEC ESP packets by matching security parameter index.
- IPSEC AH packets by matching security parameter index.
- NAT_T ESP packets by matching security parameter index.
- Any PFCP session packets(s field is 1).

Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fdir.c     | 254 ++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  15 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  13 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 281 ++++++++++++++++--
 4 files changed, 545 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index e0b1aa1c5f2c..e8155c7954a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -100,6 +100,138 @@ static const u8 ice_fdir_ipv4_gtpu4_pkt[] = {
 	0x00, 0x00,
 };
 
+static const u8 ice_fdir_ipv4_l2tpv3_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x14, 0x00, 0x00, 0x40, 0x00, 0x40, 0x73,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv6_l2tpv3_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x73, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv4_esp_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x14, 0x00, 0x00, 0x40, 0x00, 0x40, 0x32,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00
+};
+
+static const u8 ice_fdir_ipv6_esp_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x32, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv4_ah_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x14, 0x00, 0x00, 0x40, 0x00, 0x40, 0x33,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00
+};
+
+static const u8 ice_fdir_ipv6_ah_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x33, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv4_nat_t_esp_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x1C, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x11, 0x94, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv6_nat_t_esp_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x08, 0x11, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x11, 0x94, 0x00, 0x00, 0x00, 0x08,
+};
+
+static const u8 ice_fdir_ipv4_pfcp_node_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x2C, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x22, 0x65, 0x22, 0x65, 0x00, 0x00,
+	0x00, 0x00, 0x20, 0x00, 0x00, 0x10, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv4_pfcp_session_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x2C, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x22, 0x65, 0x22, 0x65, 0x00, 0x00,
+	0x00, 0x00, 0x21, 0x00, 0x00, 0x10, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv6_pfcp_node_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x18, 0x11, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x65,
+	0x22, 0x65, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00,
+	0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv6_pfcp_session_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x18, 0x11, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x65,
+	0x22, 0x65, 0x00, 0x00, 0x00, 0x00, 0x21, 0x00,
+	0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
 static const u8 ice_fdir_non_ip_l2_pkt[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -332,6 +464,78 @@ static const struct ice_fdir_base_pkt ice_fdir_pkt[] = {
 		sizeof(ice_fdir_ipv4_gtpu4_pkt),
 		ice_fdir_ipv4_gtpu4_pkt,
 	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_L2TPV3,
+		sizeof(ice_fdir_ipv4_l2tpv3_pkt), ice_fdir_ipv4_l2tpv3_pkt,
+		sizeof(ice_fdir_ipv4_l2tpv3_pkt), ice_fdir_ipv4_l2tpv3_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_L2TPV3,
+		sizeof(ice_fdir_ipv6_l2tpv3_pkt), ice_fdir_ipv6_l2tpv3_pkt,
+		sizeof(ice_fdir_ipv6_l2tpv3_pkt), ice_fdir_ipv6_l2tpv3_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_ESP,
+		sizeof(ice_fdir_ipv4_esp_pkt), ice_fdir_ipv4_esp_pkt,
+		sizeof(ice_fdir_ipv4_esp_pkt), ice_fdir_ipv4_esp_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_ESP,
+		sizeof(ice_fdir_ipv6_esp_pkt), ice_fdir_ipv6_esp_pkt,
+		sizeof(ice_fdir_ipv6_esp_pkt), ice_fdir_ipv6_esp_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_AH,
+		sizeof(ice_fdir_ipv4_ah_pkt), ice_fdir_ipv4_ah_pkt,
+		sizeof(ice_fdir_ipv4_ah_pkt), ice_fdir_ipv4_ah_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_AH,
+		sizeof(ice_fdir_ipv6_ah_pkt), ice_fdir_ipv6_ah_pkt,
+		sizeof(ice_fdir_ipv6_ah_pkt), ice_fdir_ipv6_ah_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_NAT_T_ESP,
+		sizeof(ice_fdir_ipv4_nat_t_esp_pkt),
+		ice_fdir_ipv4_nat_t_esp_pkt,
+		sizeof(ice_fdir_ipv4_nat_t_esp_pkt),
+		ice_fdir_ipv4_nat_t_esp_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_NAT_T_ESP,
+		sizeof(ice_fdir_ipv6_nat_t_esp_pkt),
+		ice_fdir_ipv6_nat_t_esp_pkt,
+		sizeof(ice_fdir_ipv6_nat_t_esp_pkt),
+		ice_fdir_ipv6_nat_t_esp_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_PFCP_NODE,
+		sizeof(ice_fdir_ipv4_pfcp_node_pkt),
+		ice_fdir_ipv4_pfcp_node_pkt,
+		sizeof(ice_fdir_ipv4_pfcp_node_pkt),
+		ice_fdir_ipv4_pfcp_node_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_PFCP_SESSION,
+		sizeof(ice_fdir_ipv4_pfcp_session_pkt),
+		ice_fdir_ipv4_pfcp_session_pkt,
+		sizeof(ice_fdir_ipv4_pfcp_session_pkt),
+		ice_fdir_ipv4_pfcp_session_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_PFCP_NODE,
+		sizeof(ice_fdir_ipv6_pfcp_node_pkt),
+		ice_fdir_ipv6_pfcp_node_pkt,
+		sizeof(ice_fdir_ipv6_pfcp_node_pkt),
+		ice_fdir_ipv6_pfcp_node_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_PFCP_SESSION,
+		sizeof(ice_fdir_ipv6_pfcp_session_pkt),
+		ice_fdir_ipv6_pfcp_session_pkt,
+		sizeof(ice_fdir_ipv6_pfcp_session_pkt),
+		ice_fdir_ipv6_pfcp_session_pkt,
+	},
 	{
 		ICE_FLTR_PTYPE_NON_IP_L2,
 		sizeof(ice_fdir_non_ip_l2_pkt), ice_fdir_non_ip_l2_pkt,
@@ -802,6 +1006,56 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 		ice_pkt_insert_u6_qfi(loc, ICE_IPV4_GTPU_QFI_OFFSET,
 				      input->gtpu_data.qfi);
 		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_L2TPV3:
+		ice_pkt_insert_u32(loc, ICE_IPV4_L2TPV3_SESS_ID_OFFSET,
+				   input->l2tpv3_data.session_id);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_L2TPV3:
+		ice_pkt_insert_u32(loc, ICE_IPV6_L2TPV3_SESS_ID_OFFSET,
+				   input->l2tpv3_data.session_id);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_ESP:
+		ice_pkt_insert_u32(loc, ICE_IPV4_ESP_SPI_OFFSET,
+				   input->ip.v4.sec_parm_idx);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_ESP:
+		ice_pkt_insert_u32(loc, ICE_IPV6_ESP_SPI_OFFSET,
+				   input->ip.v6.sec_parm_idx);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_AH:
+		ice_pkt_insert_u32(loc, ICE_IPV4_AH_SPI_OFFSET,
+				   input->ip.v4.sec_parm_idx);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_AH:
+		ice_pkt_insert_u32(loc, ICE_IPV6_AH_SPI_OFFSET,
+				   input->ip.v6.sec_parm_idx);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_NAT_T_ESP:
+		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
+				   input->ip.v4.src_ip);
+		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
+				   input->ip.v4.dst_ip);
+		ice_pkt_insert_u32(loc, ICE_IPV4_NAT_T_ESP_SPI_OFFSET,
+				   input->ip.v4.sec_parm_idx);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_NAT_T_ESP:
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_DST_ADDR_OFFSET,
+					 input->ip.v6.src_ip);
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_SRC_ADDR_OFFSET,
+					 input->ip.v6.dst_ip);
+		ice_pkt_insert_u32(loc, ICE_IPV6_NAT_T_ESP_SPI_OFFSET,
+				   input->ip.v6.sec_parm_idx);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_PFCP_NODE:
+	case ICE_FLTR_PTYPE_NONF_IPV4_PFCP_SESSION:
+		ice_pkt_insert_u16(loc, ICE_IPV4_UDP_SRC_PORT_OFFSET,
+				   input->ip.v4.dst_port);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_PFCP_NODE:
+	case ICE_FLTR_PTYPE_NONF_IPV6_PFCP_SESSION:
+		ice_pkt_insert_u16(loc, ICE_IPV6_UDP_SRC_PORT_OFFSET,
+				   input->ip.v6.dst_port);
+		break;
 	case ICE_FLTR_PTYPE_NON_IP_L2:
 		ice_pkt_insert_u16(loc, ICE_MAC_ETHTYPE_OFFSET,
 				   input->ext_data.ether_type);
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index 2945421d5b6c..d2d40e18ae8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -33,6 +33,14 @@
 #define ICE_IPV6_PROTO_OFFSET		20
 #define ICE_IPV4_GTPU_TEID_OFFSET	46
 #define ICE_IPV4_GTPU_QFI_OFFSET	56
+#define ICE_IPV4_L2TPV3_SESS_ID_OFFSET	34
+#define ICE_IPV6_L2TPV3_SESS_ID_OFFSET	54
+#define ICE_IPV4_ESP_SPI_OFFSET		34
+#define ICE_IPV6_ESP_SPI_OFFSET		54
+#define ICE_IPV4_AH_SPI_OFFSET		38
+#define ICE_IPV6_AH_SPI_OFFSET		58
+#define ICE_IPV4_NAT_T_ESP_SPI_OFFSET	42
+#define ICE_IPV6_NAT_T_ESP_SPI_OFFSET	62
 
 #define ICE_FDIR_MAX_FLTRS		16384
 
@@ -134,6 +142,10 @@ struct ice_fdir_udp_gtp {
 	u8 next_ext;
 };
 
+struct ice_fdir_l2tpv3 {
+	__be32 session_id;
+};
+
 struct ice_fdir_extra {
 	u8 dst_mac[ETH_ALEN];	/* dest MAC address */
 	u8 src_mac[ETH_ALEN];	/* src MAC address */
@@ -155,6 +167,9 @@ struct ice_fdir_fltr {
 	struct ice_fdir_udp_gtp gtpu_data;
 	struct ice_fdir_udp_gtp gtpu_mask;
 
+	struct ice_fdir_l2tpv3 l2tpv3_data;
+	struct ice_fdir_l2tpv3 l2tpv3_mask;
+
 	struct ice_fdir_extra ext_data;
 	struct ice_fdir_extra ext_mask;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c55076d20bea..2893143d9e62 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -196,6 +196,19 @@ enum ice_fltr_ptype {
 	ICE_FLTR_PTYPE_NONF_IPV4_GTPU_IPV4_TCP,
 	ICE_FLTR_PTYPE_NONF_IPV4_GTPU_IPV4_ICMP,
 	ICE_FLTR_PTYPE_NONF_IPV4_GTPU_IPV4_OTHER,
+	ICE_FLTR_PTYPE_NONF_IPV6_GTPU_IPV6_OTHER,
+	ICE_FLTR_PTYPE_NONF_IPV4_L2TPV3,
+	ICE_FLTR_PTYPE_NONF_IPV6_L2TPV3,
+	ICE_FLTR_PTYPE_NONF_IPV4_ESP,
+	ICE_FLTR_PTYPE_NONF_IPV6_ESP,
+	ICE_FLTR_PTYPE_NONF_IPV4_AH,
+	ICE_FLTR_PTYPE_NONF_IPV6_AH,
+	ICE_FLTR_PTYPE_NONF_IPV4_NAT_T_ESP,
+	ICE_FLTR_PTYPE_NONF_IPV6_NAT_T_ESP,
+	ICE_FLTR_PTYPE_NONF_IPV4_PFCP_NODE,
+	ICE_FLTR_PTYPE_NONF_IPV4_PFCP_SESSION,
+	ICE_FLTR_PTYPE_NONF_IPV6_PFCP_NODE,
+	ICE_FLTR_PTYPE_NONF_IPV6_PFCP_SESSION,
 	ICE_FLTR_PTYPE_NON_IP_L2,
 	ICE_FLTR_PTYPE_FRAG_IPV4,
 	ICE_FLTR_PTYPE_NONF_IPV6_UDP,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index e0bcd5baab60..f49947d3df37 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -25,6 +25,14 @@
 #define GTPU_TEID_OFFSET 4
 #define GTPU_EH_QFI_OFFSET 1
 #define GTPU_EH_QFI_MASK 0x3F
+#define PFCP_S_OFFSET 0
+#define PFCP_S_MASK 0x1
+#define PFCP_PORT_NR 8805
+
+#define FDIR_INSET_FLAG_ESP_S 0
+#define FDIR_INSET_FLAG_ESP_M BIT_ULL(FDIR_INSET_FLAG_ESP_S)
+#define FDIR_INSET_FLAG_ESP_UDP BIT_ULL(FDIR_INSET_FLAG_ESP_S)
+#define FDIR_INSET_FLAG_ESP_IPSEC (0ULL << FDIR_INSET_FLAG_ESP_S)
 
 enum ice_fdir_tunnel_type {
 	ICE_FDIR_TUNNEL_TYPE_NONE = 0,
@@ -35,6 +43,7 @@ enum ice_fdir_tunnel_type {
 struct virtchnl_fdir_fltr_conf {
 	struct ice_fdir_fltr input;
 	enum ice_fdir_tunnel_type ttype;
+	u64 inset_flag;
 };
 
 static enum virtchnl_proto_hdr_type vc_pattern_ether[] = {
@@ -113,6 +122,80 @@ static enum virtchnl_proto_hdr_type vc_pattern_ipv4_gtpu_eh[] = {
 	VIRTCHNL_PROTO_HDR_NONE,
 };
 
+static enum virtchnl_proto_hdr_type vc_pattern_ipv4_l2tpv3[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV4,
+	VIRTCHNL_PROTO_HDR_L2TPV3,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv6_l2tpv3[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV6,
+	VIRTCHNL_PROTO_HDR_L2TPV3,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv4_esp[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV4,
+	VIRTCHNL_PROTO_HDR_ESP,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv6_esp[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV6,
+	VIRTCHNL_PROTO_HDR_ESP,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv4_ah[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV4,
+	VIRTCHNL_PROTO_HDR_AH,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv6_ah[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV6,
+	VIRTCHNL_PROTO_HDR_AH,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv4_nat_t_esp[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV4,
+	VIRTCHNL_PROTO_HDR_UDP,
+	VIRTCHNL_PROTO_HDR_ESP,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv6_nat_t_esp[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV6,
+	VIRTCHNL_PROTO_HDR_UDP,
+	VIRTCHNL_PROTO_HDR_ESP,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv4_pfcp[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV4,
+	VIRTCHNL_PROTO_HDR_UDP,
+	VIRTCHNL_PROTO_HDR_PFCP,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
+static enum virtchnl_proto_hdr_type vc_pattern_ipv6_pfcp[] = {
+	VIRTCHNL_PROTO_HDR_ETH,
+	VIRTCHNL_PROTO_HDR_IPV6,
+	VIRTCHNL_PROTO_HDR_UDP,
+	VIRTCHNL_PROTO_HDR_PFCP,
+	VIRTCHNL_PROTO_HDR_NONE,
+};
+
 struct virtchnl_fdir_pattern_match_item {
 	enum virtchnl_proto_hdr_type *list;
 	u64 input_set;
@@ -142,32 +225,52 @@ static const struct virtchnl_fdir_pattern_match_item vc_fdir_pattern_comms[] = {
 	{vc_pattern_ether,                    0,         NULL},
 	{vc_pattern_ipv4_gtpu,                0,         NULL},
 	{vc_pattern_ipv4_gtpu_eh,             0,         NULL},
+	{vc_pattern_ipv4_l2tpv3,              0,         NULL},
+	{vc_pattern_ipv6_l2tpv3,              0,         NULL},
+	{vc_pattern_ipv4_esp,                 0,         NULL},
+	{vc_pattern_ipv6_esp,                 0,         NULL},
+	{vc_pattern_ipv4_ah,                  0,         NULL},
+	{vc_pattern_ipv6_ah,                  0,         NULL},
+	{vc_pattern_ipv4_nat_t_esp,           0,         NULL},
+	{vc_pattern_ipv6_nat_t_esp,           0,         NULL},
+	{vc_pattern_ipv4_pfcp,                0,         NULL},
+	{vc_pattern_ipv6_pfcp,                0,         NULL},
 };
 
 struct virtchnl_fdir_inset_map {
 	enum virtchnl_proto_hdr_field field;
 	enum ice_flow_field fld;
+	u64 flag;
+	u64 mask;
 };
 
 static const struct virtchnl_fdir_inset_map fdir_inset_map[] = {
-	{VIRTCHNL_PROTO_HDR_IPV4_SRC, ICE_FLOW_FIELD_IDX_IPV4_SA},
-	{VIRTCHNL_PROTO_HDR_IPV4_DST, ICE_FLOW_FIELD_IDX_IPV4_DA},
-	{VIRTCHNL_PROTO_HDR_IPV4_DSCP, ICE_FLOW_FIELD_IDX_IPV4_DSCP},
-	{VIRTCHNL_PROTO_HDR_IPV4_TTL, ICE_FLOW_FIELD_IDX_IPV4_TTL},
-	{VIRTCHNL_PROTO_HDR_IPV4_PROT, ICE_FLOW_FIELD_IDX_IPV4_PROT},
-	{VIRTCHNL_PROTO_HDR_IPV6_SRC, ICE_FLOW_FIELD_IDX_IPV6_SA},
-	{VIRTCHNL_PROTO_HDR_IPV6_DST, ICE_FLOW_FIELD_IDX_IPV6_DA},
-	{VIRTCHNL_PROTO_HDR_IPV6_TC, ICE_FLOW_FIELD_IDX_IPV6_DSCP},
-	{VIRTCHNL_PROTO_HDR_IPV6_HOP_LIMIT, ICE_FLOW_FIELD_IDX_IPV6_TTL},
-	{VIRTCHNL_PROTO_HDR_IPV6_PROT, ICE_FLOW_FIELD_IDX_IPV6_PROT},
-	{VIRTCHNL_PROTO_HDR_UDP_SRC_PORT, ICE_FLOW_FIELD_IDX_UDP_SRC_PORT},
-	{VIRTCHNL_PROTO_HDR_UDP_DST_PORT, ICE_FLOW_FIELD_IDX_UDP_DST_PORT},
-	{VIRTCHNL_PROTO_HDR_TCP_SRC_PORT, ICE_FLOW_FIELD_IDX_TCP_SRC_PORT},
-	{VIRTCHNL_PROTO_HDR_TCP_DST_PORT, ICE_FLOW_FIELD_IDX_TCP_DST_PORT},
-	{VIRTCHNL_PROTO_HDR_SCTP_SRC_PORT, ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT},
-	{VIRTCHNL_PROTO_HDR_SCTP_DST_PORT, ICE_FLOW_FIELD_IDX_SCTP_DST_PORT},
-	{VIRTCHNL_PROTO_HDR_GTPU_IP_TEID, ICE_FLOW_FIELD_IDX_GTPU_IP_TEID},
-	{VIRTCHNL_PROTO_HDR_GTPU_EH_QFI, ICE_FLOW_FIELD_IDX_GTPU_EH_QFI},
+	{VIRTCHNL_PROTO_HDR_ETH_ETHERTYPE, ICE_FLOW_FIELD_IDX_ETH_TYPE, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV4_SRC, ICE_FLOW_FIELD_IDX_IPV4_SA, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV4_DST, ICE_FLOW_FIELD_IDX_IPV4_DA, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV4_DSCP, ICE_FLOW_FIELD_IDX_IPV4_DSCP, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV4_TTL, ICE_FLOW_FIELD_IDX_IPV4_TTL, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV4_PROT, ICE_FLOW_FIELD_IDX_IPV4_PROT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV6_SRC, ICE_FLOW_FIELD_IDX_IPV6_SA, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV6_DST, ICE_FLOW_FIELD_IDX_IPV6_DA, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV6_TC, ICE_FLOW_FIELD_IDX_IPV6_DSCP, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV6_HOP_LIMIT, ICE_FLOW_FIELD_IDX_IPV6_TTL, 0, 0},
+	{VIRTCHNL_PROTO_HDR_IPV6_PROT, ICE_FLOW_FIELD_IDX_IPV6_PROT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_UDP_SRC_PORT, ICE_FLOW_FIELD_IDX_UDP_SRC_PORT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_UDP_DST_PORT, ICE_FLOW_FIELD_IDX_UDP_DST_PORT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_TCP_SRC_PORT, ICE_FLOW_FIELD_IDX_TCP_SRC_PORT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_TCP_DST_PORT, ICE_FLOW_FIELD_IDX_TCP_DST_PORT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_SCTP_SRC_PORT, ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_SCTP_DST_PORT, ICE_FLOW_FIELD_IDX_SCTP_DST_PORT, 0, 0},
+	{VIRTCHNL_PROTO_HDR_GTPU_IP_TEID, ICE_FLOW_FIELD_IDX_GTPU_IP_TEID, 0, 0},
+	{VIRTCHNL_PROTO_HDR_GTPU_EH_QFI, ICE_FLOW_FIELD_IDX_GTPU_EH_QFI, 0, 0},
+	{VIRTCHNL_PROTO_HDR_ESP_SPI, ICE_FLOW_FIELD_IDX_ESP_SPI,
+		FDIR_INSET_FLAG_ESP_IPSEC, FDIR_INSET_FLAG_ESP_M},
+	{VIRTCHNL_PROTO_HDR_ESP_SPI, ICE_FLOW_FIELD_IDX_NAT_T_ESP_SPI,
+		FDIR_INSET_FLAG_ESP_UDP, FDIR_INSET_FLAG_ESP_M},
+	{VIRTCHNL_PROTO_HDR_AH_SPI, ICE_FLOW_FIELD_IDX_AH_SPI, 0, 0},
+	{VIRTCHNL_PROTO_HDR_L2TPV3_SESS_ID, ICE_FLOW_FIELD_IDX_L2TPV3_SESS_ID, 0, 0},
+	{VIRTCHNL_PROTO_HDR_PFCP_S_FIELD, ICE_FLOW_FIELD_IDX_UDP_DST_PORT, 0, 0},
 };
 
 /**
@@ -344,6 +447,11 @@ ice_vc_fdir_parse_flow_fld(struct virtchnl_proto_hdr *proto_hdr,
 	for (i = 0; (i < ARRAY_SIZE(fdir_inset_map)) &&
 	     VIRTCHNL_GET_PROTO_HDR_FIELD(&hdr); i++)
 		if (VIRTCHNL_TEST_PROTO_HDR(&hdr, fdir_inset_map[i].field)) {
+			if (fdir_inset_map[i].mask &&
+			    ((fdir_inset_map[i].mask & conf->inset_flag) !=
+			     fdir_inset_map[i].flag))
+				continue;
+
 			fld[*fld_cnt] = fdir_inset_map[i].fld;
 			*fld_cnt += 1;
 			if (*fld_cnt >= ICE_FLOW_FIELD_IDX_MAX)
@@ -424,6 +532,36 @@ ice_vc_fdir_set_flow_hdr(struct ice_vf *vf,
 	case ICE_FLTR_PTYPE_NON_IP_L2:
 		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_ETH_NON_IP);
 		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_L2TPV3:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_L2TPV3 |
+				  ICE_FLOW_SEG_HDR_IPV4 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_ESP:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_ESP |
+				  ICE_FLOW_SEG_HDR_IPV4 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_AH:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_AH |
+				  ICE_FLOW_SEG_HDR_IPV4 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_NAT_T_ESP:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_NAT_T_ESP |
+				  ICE_FLOW_SEG_HDR_IPV4 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_PFCP_NODE:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_PFCP_NODE |
+				  ICE_FLOW_SEG_HDR_IPV4 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_PFCP_SESSION:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_PFCP_SESSION |
+				  ICE_FLOW_SEG_HDR_IPV4 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
 	case ICE_FLTR_PTYPE_NONF_IPV4_OTHER:
 		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4 |
 				  ICE_FLOW_SEG_HDR_IPV_OTHER);
@@ -462,6 +600,36 @@ ice_vc_fdir_set_flow_hdr(struct ice_vf *vf,
 				  ICE_FLOW_SEG_HDR_IPV4 |
 				  ICE_FLOW_SEG_HDR_IPV_OTHER);
 		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_L2TPV3:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_L2TPV3 |
+				  ICE_FLOW_SEG_HDR_IPV6 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_ESP:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_ESP |
+				  ICE_FLOW_SEG_HDR_IPV6 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_AH:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_AH |
+				  ICE_FLOW_SEG_HDR_IPV6 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_NAT_T_ESP:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_NAT_T_ESP |
+				  ICE_FLOW_SEG_HDR_IPV6 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_PFCP_NODE:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_PFCP_NODE |
+				  ICE_FLOW_SEG_HDR_IPV6 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_PFCP_SESSION:
+		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_PFCP_SESSION |
+				  ICE_FLOW_SEG_HDR_IPV6 |
+				  ICE_FLOW_SEG_HDR_IPV_OTHER);
+		break;
 	case ICE_FLTR_PTYPE_NONF_IPV6_OTHER:
 		ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV6 |
 				  ICE_FLOW_SEG_HDR_IPV_OTHER);
@@ -834,6 +1002,7 @@ ice_vc_fdir_parse_pattern(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 {
 	struct virtchnl_proto_hdrs *proto = &fltr->rule_cfg.proto_hdrs;
 	enum virtchnl_proto_hdr_type l3 = VIRTCHNL_PROTO_HDR_NONE;
+	enum virtchnl_proto_hdr_type l4 = VIRTCHNL_PROTO_HDR_NONE;
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	struct ice_fdir_fltr *input = &conf->input;
 	int i;
@@ -846,12 +1015,15 @@ ice_vc_fdir_parse_pattern(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 
 	for (i = 0; i < proto->count; i++) {
 		struct virtchnl_proto_hdr *hdr = &proto->proto_hdr[i];
+		struct ip_esp_hdr *esph;
+		struct ip_auth_hdr *ah;
 		struct sctphdr *sctph;
 		struct ipv6hdr *ip6h;
 		struct udphdr *udph;
 		struct tcphdr *tcph;
 		struct ethhdr *eth;
 		struct iphdr *iph;
+		u8 s_field;
 		u8 *rawh;
 
 		switch (hdr->type) {
@@ -944,6 +1116,75 @@ ice_vc_fdir_parse_pattern(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 				}
 			}
 			break;
+		case VIRTCHNL_PROTO_HDR_L2TPV3:
+			if (l3 == VIRTCHNL_PROTO_HDR_IPV4)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_L2TPV3;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV6)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV6_L2TPV3;
+
+			if (hdr->field_selector)
+				input->l2tpv3_data.session_id = *((__be32 *)hdr->buffer);
+			break;
+		case VIRTCHNL_PROTO_HDR_ESP:
+			esph = (struct ip_esp_hdr *)hdr->buffer;
+			if (l3 == VIRTCHNL_PROTO_HDR_IPV4 &&
+			    l4 == VIRTCHNL_PROTO_HDR_UDP)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_NAT_T_ESP;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV6 &&
+				 l4 == VIRTCHNL_PROTO_HDR_UDP)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV6_NAT_T_ESP;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV4 &&
+				 l4 == VIRTCHNL_PROTO_HDR_NONE)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_ESP;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV6 &&
+				 l4 == VIRTCHNL_PROTO_HDR_NONE)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV6_ESP;
+
+			if (l4 == VIRTCHNL_PROTO_HDR_UDP)
+				conf->inset_flag |= FDIR_INSET_FLAG_ESP_UDP;
+			else
+				conf->inset_flag |= FDIR_INSET_FLAG_ESP_IPSEC;
+
+			if (hdr->field_selector) {
+				if (l3 == VIRTCHNL_PROTO_HDR_IPV4)
+					input->ip.v4.sec_parm_idx = esph->spi;
+				else if (l3 == VIRTCHNL_PROTO_HDR_IPV6)
+					input->ip.v6.sec_parm_idx = esph->spi;
+			}
+			break;
+		case VIRTCHNL_PROTO_HDR_AH:
+			ah = (struct ip_auth_hdr *)hdr->buffer;
+			if (l3 == VIRTCHNL_PROTO_HDR_IPV4)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_AH;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV6)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV6_AH;
+
+			if (hdr->field_selector) {
+				if (l3 == VIRTCHNL_PROTO_HDR_IPV4)
+					input->ip.v4.sec_parm_idx = ah->spi;
+				else if (l3 == VIRTCHNL_PROTO_HDR_IPV6)
+					input->ip.v6.sec_parm_idx = ah->spi;
+			}
+			break;
+		case VIRTCHNL_PROTO_HDR_PFCP:
+			rawh = (u8 *)hdr->buffer;
+			s_field = (rawh[0] >> PFCP_S_OFFSET) & PFCP_S_MASK;
+			if (l3 == VIRTCHNL_PROTO_HDR_IPV4 && s_field == 0)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_PFCP_NODE;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV4 && s_field == 1)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_PFCP_SESSION;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV6 && s_field == 0)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV6_PFCP_NODE;
+			else if (l3 == VIRTCHNL_PROTO_HDR_IPV6 && s_field == 1)
+				input->flow_type = ICE_FLTR_PTYPE_NONF_IPV6_PFCP_SESSION;
+
+			if (hdr->field_selector) {
+				if (l3 == VIRTCHNL_PROTO_HDR_IPV4)
+					input->ip.v4.dst_port = cpu_to_be16(PFCP_PORT_NR);
+				else if (l3 == VIRTCHNL_PROTO_HDR_IPV6)
+					input->ip.v6.dst_port = cpu_to_be16(PFCP_PORT_NR);
+			}
+			break;
 		case VIRTCHNL_PROTO_HDR_GTPU_IP:
 			rawh = (u8 *)hdr->buffer;
 			input->flow_type = ICE_FLTR_PTYPE_NONF_IPV4_GTPU_IPV4_OTHER;
@@ -1096,6 +1337,10 @@ ice_vc_fdir_comp_rules(struct virtchnl_fdir_fltr_conf *conf_a,
 		return false;
 	if (memcmp(&a->gtpu_mask, &b->gtpu_mask, sizeof(a->gtpu_mask)))
 		return false;
+	if (memcmp(&a->l2tpv3_data, &b->l2tpv3_data, sizeof(a->l2tpv3_data)))
+		return false;
+	if (memcmp(&a->l2tpv3_mask, &b->l2tpv3_mask, sizeof(a->l2tpv3_mask)))
+		return false;
 	if (memcmp(&a->ext_data, &b->ext_data, sizeof(a->ext_data)))
 		return false;
 	if (memcmp(&a->ext_mask, &b->ext_mask, sizeof(a->ext_mask)))
-- 
2.26.2

