Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D585213003A
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgADCuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:00 -0500
Received: from mga12.intel.com ([192.55.52.136]:64695 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757870"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vignesh Sridhar <vignesh.sridhar@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/16] ice: Remove Rx flex descriptor programming
Date:   Fri,  3 Jan 2020 18:49:45 -0800
Message-Id: <20200104024953.2336731-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vignesh Sridhar <vignesh.sridhar@intel.com>

Remove Rx flex descriptor metadata and flag programming; per specification
these registers cannot be written to as they are read only.

Signed-off-by: Vignesh Sridhar <vignesh.sridhar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 104 ------------------
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   9 --
 2 files changed, 113 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index fb1d930470c7..a03b4fdc01e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -7,25 +7,6 @@
 
 #define ICE_PF_RESET_WAIT_COUNT	200
 
-#define ICE_PROG_FLEX_ENTRY(hw, rxdid, mdid, idx) \
-	wr32((hw), GLFLXP_RXDID_FLX_WRD_##idx(rxdid), \
-	     ((ICE_RX_OPC_MDID << \
-	       GLFLXP_RXDID_FLX_WRD_##idx##_RXDID_OPCODE_S) & \
-	      GLFLXP_RXDID_FLX_WRD_##idx##_RXDID_OPCODE_M) | \
-	     (((mdid) << GLFLXP_RXDID_FLX_WRD_##idx##_PROT_MDID_S) & \
-	      GLFLXP_RXDID_FLX_WRD_##idx##_PROT_MDID_M))
-
-#define ICE_PROG_FLG_ENTRY(hw, rxdid, flg_0, flg_1, flg_2, flg_3, idx) \
-	wr32((hw), GLFLXP_RXDID_FLAGS(rxdid, idx), \
-	     (((flg_0) << GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_S) & \
-	      GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_M) | \
-	     (((flg_1) << GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_1_S) & \
-	      GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_1_M) | \
-	     (((flg_2) << GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_2_S) & \
-	      GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_2_M) | \
-	     (((flg_3) << GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_3_S) & \
-	      GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_3_M))
-
 /**
  * ice_set_mac_type - Sets MAC type
  * @hw: pointer to the HW structure
@@ -347,88 +328,6 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 	return 0;
 }
 
-/**
- * ice_init_flex_flags
- * @hw: pointer to the hardware structure
- * @prof_id: Rx Descriptor Builder profile ID
- *
- * Function to initialize Rx flex flags
- */
-static void ice_init_flex_flags(struct ice_hw *hw, enum ice_rxdid prof_id)
-{
-	u8 idx = 0;
-
-	/* Flex-flag fields (0-2) are programmed with FLG64 bits with layout:
-	 * flexiflags0[5:0] - TCP flags, is_packet_fragmented, is_packet_UDP_GRE
-	 * flexiflags1[3:0] - Not used for flag programming
-	 * flexiflags2[7:0] - Tunnel and VLAN types
-	 * 2 invalid fields in last index
-	 */
-	switch (prof_id) {
-	/* Rx flex flags are currently programmed for the NIC profiles only.
-	 * Different flag bit programming configurations can be added per
-	 * profile as needed.
-	 */
-	case ICE_RXDID_FLEX_NIC:
-	case ICE_RXDID_FLEX_NIC_2:
-		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_FLG_PKT_FRG,
-				   ICE_FLG_UDP_GRE, ICE_FLG_PKT_DSI,
-				   ICE_FLG_FIN, idx++);
-		/* flex flag 1 is not used for flexi-flag programming, skipping
-		 * these four FLG64 bits.
-		 */
-		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_FLG_SYN, ICE_FLG_RST,
-				   ICE_FLG_PKT_DSI, ICE_FLG_PKT_DSI, idx++);
-		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_FLG_PKT_DSI,
-				   ICE_FLG_PKT_DSI, ICE_FLG_EVLAN_x8100,
-				   ICE_FLG_EVLAN_x9100, idx++);
-		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_FLG_VLAN_x8100,
-				   ICE_FLG_TNL_VLAN, ICE_FLG_TNL_MAC,
-				   ICE_FLG_TNL0, idx++);
-		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_FLG_TNL1, ICE_FLG_TNL2,
-				   ICE_FLG_PKT_DSI, ICE_FLG_PKT_DSI, idx);
-		break;
-
-	default:
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Flag programming for profile ID %d not supported\n",
-			  prof_id);
-	}
-}
-
-/**
- * ice_init_flex_flds
- * @hw: pointer to the hardware structure
- * @prof_id: Rx Descriptor Builder profile ID
- *
- * Function to initialize flex descriptors
- */
-static void ice_init_flex_flds(struct ice_hw *hw, enum ice_rxdid prof_id)
-{
-	enum ice_flex_rx_mdid mdid;
-
-	switch (prof_id) {
-	case ICE_RXDID_FLEX_NIC:
-	case ICE_RXDID_FLEX_NIC_2:
-		ICE_PROG_FLEX_ENTRY(hw, prof_id, ICE_RX_MDID_HASH_LOW, 0);
-		ICE_PROG_FLEX_ENTRY(hw, prof_id, ICE_RX_MDID_HASH_HIGH, 1);
-		ICE_PROG_FLEX_ENTRY(hw, prof_id, ICE_RX_MDID_FLOW_ID_LOWER, 2);
-
-		mdid = (prof_id == ICE_RXDID_FLEX_NIC_2) ?
-			ICE_RX_MDID_SRC_VSI : ICE_RX_MDID_FLOW_ID_HIGH;
-
-		ICE_PROG_FLEX_ENTRY(hw, prof_id, mdid, 3);
-
-		ice_init_flex_flags(hw, prof_id);
-		break;
-
-	default:
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Field init for profile ID %d not supported\n",
-			  prof_id);
-	}
-}
-
 /**
  * ice_init_fltr_mgmt_struct - initializes filter management list and locks
  * @hw: pointer to the HW struct
@@ -882,9 +781,6 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
-
-	ice_init_flex_flds(hw, ICE_RXDID_FLEX_NIC);
-	ice_init_flex_flds(hw, ICE_RXDID_FLEX_NIC_2);
 	status = ice_init_hw_tbls(hw);
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index e8f32350fed2..f2cababf2561 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -60,15 +60,6 @@
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
 #define GL_PREEXT_L2_PMASK0(_i)			(0x0020F0FC + ((_i) * 4))
 #define GL_PREEXT_L2_PMASK1(_i)			(0x0020F108 + ((_i) * 4))
-#define GLFLXP_RXDID_FLAGS(_i, _j)		(0x0045D000 + ((_i) * 4 + (_j) * 256))
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_S	0
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_M	ICE_M(0x3F, 0)
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_1_S	8
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_1_M	ICE_M(0x3F, 8)
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_2_S	16
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_2_M	ICE_M(0x3F, 16)
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_3_S	24
-#define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_3_M	ICE_M(0x3F, 24)
 #define GLFLXP_RXDID_FLX_WRD_0(_i)		(0x0045c800 + ((_i) * 4))
 #define GLFLXP_RXDID_FLX_WRD_0_PROT_MDID_S	0
 #define GLFLXP_RXDID_FLX_WRD_0_PROT_MDID_M	ICE_M(0xFF, 0)
-- 
2.24.1

