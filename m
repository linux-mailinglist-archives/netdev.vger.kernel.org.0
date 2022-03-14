Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A764D8B69
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiCNSLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243684AbiCNSL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3BF13F55
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281409; x=1678817409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oVZWE+drA5tabgzBr48Ll0VjHBj/vjPvpeOUvEXWyUM=;
  b=aZ7RS8C9heuvCa33XKY02LtLzOU1jyJQN+tbWdYPySmD7J28V4/m8upt
   I27CCC/a2AjyTH+SHpQT+cB92nTOco8nI3M1CmAiBvJr3yMaCMoFXXA0v
   TLyG5uJiBR69T1+o4e9W6E5qgpFd1xlJCkoe+pqh6c0UVq0VaxxkChfvm
   hG6LQ5CuiKstkCgve+FFlB3qgEzKdUBDFs8yqxX1STX2vZhuJV2Oom9Pf
   cvlmxQ7zJLi4dM3XEAqMc1YROaOvyNI2sPh1cpGeYCBHQlS/kiBeNtvly
   fJW2ZSlgEQZKhjRWg5Nkm+IRy/xTHzrNkZJ5+f3UvfRUwSpkn67FupuAq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275415"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275415"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297746"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 24/25] ice: introduce ice_virtchnl.c and ice_virtchnl.h
Date:   Mon, 14 Mar 2022 11:10:15 -0700
Message-Id: <20220314181016.1690595-25-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Just as we moved the generic virtualization library logic into
ice_vf_lib.c, move the virtchnl message handling into ice_virtchnl.c

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 3851 +--------
 drivers/net/ethernet/intel/ice/ice_sriov.h    |   55 +-
 .../intel/ice/{ice_sriov.c => ice_virtchnl.c} | 7137 ++++++-----------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   82 +
 5 files changed, 2740 insertions(+), 8386 deletions(-)
 copy drivers/net/ethernet/intel/ice/{ice_sriov.c => ice_virtchnl.c} (68%)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index c21a0aa897a5..9183d480b70b 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -35,6 +35,7 @@ ice-y := ice_main.o	\
 	 ice_tc_lib.o
 ice-$(CONFIG_PCI_IOV) +=	\
 	ice_sriov.o		\
+	ice_virtchnl.o		\
 	ice_virtchnl_allowlist.o \
 	ice_virtchnl_fdir.o	\
 	ice_vf_mbx.o		\
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 4f3d25ed68c9..8915a9d39e36 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -14,158 +14,6 @@
 #include "ice_vf_vsi_vlan_ops.h"
 #include "ice_vlan.h"
 
-#define FIELD_SELECTOR(proto_hdr_field) \
-		BIT((proto_hdr_field) & PROTO_HDR_FIELD_MASK)
-
-struct ice_vc_hdr_match_type {
-	u32 vc_hdr;	/* virtchnl headers (VIRTCHNL_PROTO_HDR_XXX) */
-	u32 ice_hdr;	/* ice headers (ICE_FLOW_SEG_HDR_XXX) */
-};
-
-static const struct ice_vc_hdr_match_type ice_vc_hdr_list[] = {
-	{VIRTCHNL_PROTO_HDR_NONE,	ICE_FLOW_SEG_HDR_NONE},
-	{VIRTCHNL_PROTO_HDR_ETH,	ICE_FLOW_SEG_HDR_ETH},
-	{VIRTCHNL_PROTO_HDR_S_VLAN,	ICE_FLOW_SEG_HDR_VLAN},
-	{VIRTCHNL_PROTO_HDR_C_VLAN,	ICE_FLOW_SEG_HDR_VLAN},
-	{VIRTCHNL_PROTO_HDR_IPV4,	ICE_FLOW_SEG_HDR_IPV4 |
-					ICE_FLOW_SEG_HDR_IPV_OTHER},
-	{VIRTCHNL_PROTO_HDR_IPV6,	ICE_FLOW_SEG_HDR_IPV6 |
-					ICE_FLOW_SEG_HDR_IPV_OTHER},
-	{VIRTCHNL_PROTO_HDR_TCP,	ICE_FLOW_SEG_HDR_TCP},
-	{VIRTCHNL_PROTO_HDR_UDP,	ICE_FLOW_SEG_HDR_UDP},
-	{VIRTCHNL_PROTO_HDR_SCTP,	ICE_FLOW_SEG_HDR_SCTP},
-	{VIRTCHNL_PROTO_HDR_PPPOE,	ICE_FLOW_SEG_HDR_PPPOE},
-	{VIRTCHNL_PROTO_HDR_GTPU_IP,	ICE_FLOW_SEG_HDR_GTPU_IP},
-	{VIRTCHNL_PROTO_HDR_GTPU_EH,	ICE_FLOW_SEG_HDR_GTPU_EH},
-	{VIRTCHNL_PROTO_HDR_GTPU_EH_PDU_DWN,
-					ICE_FLOW_SEG_HDR_GTPU_DWN},
-	{VIRTCHNL_PROTO_HDR_GTPU_EH_PDU_UP,
-					ICE_FLOW_SEG_HDR_GTPU_UP},
-	{VIRTCHNL_PROTO_HDR_L2TPV3,	ICE_FLOW_SEG_HDR_L2TPV3},
-	{VIRTCHNL_PROTO_HDR_ESP,	ICE_FLOW_SEG_HDR_ESP},
-	{VIRTCHNL_PROTO_HDR_AH,		ICE_FLOW_SEG_HDR_AH},
-	{VIRTCHNL_PROTO_HDR_PFCP,	ICE_FLOW_SEG_HDR_PFCP_SESSION},
-};
-
-struct ice_vc_hash_field_match_type {
-	u32 vc_hdr;		/* virtchnl headers
-				 * (VIRTCHNL_PROTO_HDR_XXX)
-				 */
-	u32 vc_hash_field;	/* virtchnl hash fields selector
-				 * FIELD_SELECTOR((VIRTCHNL_PROTO_HDR_ETH_XXX))
-				 */
-	u64 ice_hash_field;	/* ice hash fields
-				 * (BIT_ULL(ICE_FLOW_FIELD_IDX_XXX))
-				 */
-};
-
-static const struct
-ice_vc_hash_field_match_type ice_vc_hash_field_list[] = {
-	{VIRTCHNL_PROTO_HDR_ETH, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_SRC),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_ETH_SA)},
-	{VIRTCHNL_PROTO_HDR_ETH, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_DST),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_ETH_DA)},
-	{VIRTCHNL_PROTO_HDR_ETH, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_DST),
-		ICE_FLOW_HASH_ETH},
-	{VIRTCHNL_PROTO_HDR_ETH,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_ETHERTYPE),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_ETH_TYPE)},
-	{VIRTCHNL_PROTO_HDR_S_VLAN,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_S_VLAN_ID),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_S_VLAN)},
-	{VIRTCHNL_PROTO_HDR_C_VLAN,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_C_VLAN_ID),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_C_VLAN)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_SA)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_DA)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST),
-		ICE_FLOW_HASH_IPV4},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_SA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_DA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		ICE_FLOW_HASH_IPV4 | BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_SA)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_DA)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST),
-		ICE_FLOW_HASH_IPV6},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_SA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_DA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		ICE_FLOW_HASH_IPV6 | BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_TCP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_SRC_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_TCP_SRC_PORT)},
-	{VIRTCHNL_PROTO_HDR_TCP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_DST_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_TCP_DST_PORT)},
-	{VIRTCHNL_PROTO_HDR_TCP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_SRC_PORT) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_DST_PORT),
-		ICE_FLOW_HASH_TCP_PORT},
-	{VIRTCHNL_PROTO_HDR_UDP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_SRC_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_SRC_PORT)},
-	{VIRTCHNL_PROTO_HDR_UDP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_DST_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_DST_PORT)},
-	{VIRTCHNL_PROTO_HDR_UDP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_SRC_PORT) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_DST_PORT),
-		ICE_FLOW_HASH_UDP_PORT},
-	{VIRTCHNL_PROTO_HDR_SCTP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_SRC_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT)},
-	{VIRTCHNL_PROTO_HDR_SCTP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_DST_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_SCTP_DST_PORT)},
-	{VIRTCHNL_PROTO_HDR_SCTP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_SRC_PORT) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_DST_PORT),
-		ICE_FLOW_HASH_SCTP_PORT},
-	{VIRTCHNL_PROTO_HDR_PPPOE,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_PPPOE_SESS_ID),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_PPPOE_SESS_ID)},
-	{VIRTCHNL_PROTO_HDR_GTPU_IP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_GTPU_IP_TEID),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_GTPU_IP_TEID)},
-	{VIRTCHNL_PROTO_HDR_L2TPV3,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_L2TPV3_SESS_ID),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_L2TPV3_SESS_ID)},
-	{VIRTCHNL_PROTO_HDR_ESP, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ESP_SPI),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_ESP_SPI)},
-	{VIRTCHNL_PROTO_HDR_AH, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_AH_SPI),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_AH_SPI)},
-	{VIRTCHNL_PROTO_HDR_PFCP, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_PFCP_SEID),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_PFCP_SEID)},
-};
-
 /**
  * ice_free_vf_entries - Free all VF entries from the hash table
  * @pf: pointer to the PF structure
@@ -192,88 +40,6 @@ static void ice_free_vf_entries(struct ice_pf *pf)
 	}
 }
 
-/**
- * ice_vc_vf_broadcast - Broadcast a message to all VFs on PF
- * @pf: pointer to the PF structure
- * @v_opcode: operation code
- * @v_retval: return value
- * @msg: pointer to the msg buffer
- * @msglen: msg length
- */
-static void
-ice_vc_vf_broadcast(struct ice_pf *pf, enum virtchnl_ops v_opcode,
-		    enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
-{
-	struct ice_hw *hw = &pf->hw;
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	mutex_lock(&pf->vfs.table_lock);
-	ice_for_each_vf(pf, bkt, vf) {
-		/* Not all vfs are enabled so skip the ones that are not */
-		if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states) &&
-		    !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
-			continue;
-
-		/* Ignore return value on purpose - a given VF may fail, but
-		 * we need to keep going and send to all of them
-		 */
-		ice_aq_send_msg_to_vf(hw, vf->vf_id, v_opcode, v_retval, msg,
-				      msglen, NULL);
-	}
-	mutex_unlock(&pf->vfs.table_lock);
-}
-
-/**
- * ice_set_pfe_link - Set the link speed/status of the virtchnl_pf_event
- * @vf: pointer to the VF structure
- * @pfe: pointer to the virtchnl_pf_event to set link speed/status for
- * @ice_link_speed: link speed specified by ICE_AQ_LINK_SPEED_*
- * @link_up: whether or not to set the link up/down
- */
-static void
-ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
-		 int ice_link_speed, bool link_up)
-{
-	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED) {
-		pfe->event_data.link_event_adv.link_status = link_up;
-		/* Speed in Mbps */
-		pfe->event_data.link_event_adv.link_speed =
-			ice_conv_link_speed_to_virtchnl(true, ice_link_speed);
-	} else {
-		pfe->event_data.link_event.link_status = link_up;
-		/* Legacy method for virtchnl link speeds */
-		pfe->event_data.link_event.link_speed =
-			(enum virtchnl_link_speed)
-			ice_conv_link_speed_to_virtchnl(false, ice_link_speed);
-	}
-}
-
-/**
- * ice_vc_notify_vf_link_state - Inform a VF of link status
- * @vf: pointer to the VF structure
- *
- * send a link status message to a single VF
- */
-void ice_vc_notify_vf_link_state(struct ice_vf *vf)
-{
-	struct virtchnl_pf_event pfe = { 0 };
-	struct ice_hw *hw = &vf->pf->hw;
-
-	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
-	pfe.severity = PF_EVENT_SEVERITY_INFO;
-
-	if (ice_is_vf_link_up(vf))
-		ice_set_pfe_link(vf, &pfe,
-				 hw->port_info->phy.link_info.link_speed, true);
-	else
-		ice_set_pfe_link(vf, &pfe, ICE_AQ_LINK_SPEED_UNKNOWN, false);
-
-	ice_aq_send_msg_to_vf(hw, vf->vf_id, VIRTCHNL_OP_EVENT,
-			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe,
-			      sizeof(pfe), NULL);
-}
-
 /**
  * ice_vf_vsi_release - invalidate the VF's VSI after freeing it
  * @vf: invalidate this VF's VSI after freeing it
@@ -795,40 +561,6 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 	return 0;
 }
 
-/**
- * ice_vc_notify_link_state - Inform all VFs on a PF of link status
- * @pf: pointer to the PF structure
- */
-void ice_vc_notify_link_state(struct ice_pf *pf)
-{
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	mutex_lock(&pf->vfs.table_lock);
-	ice_for_each_vf(pf, bkt, vf)
-		ice_vc_notify_vf_link_state(vf);
-	mutex_unlock(&pf->vfs.table_lock);
-}
-
-/**
- * ice_vc_notify_reset - Send pending reset message to all VFs
- * @pf: pointer to the PF structure
- *
- * indicate a pending reset to all VFs on a given PF
- */
-void ice_vc_notify_reset(struct ice_pf *pf)
-{
-	struct virtchnl_pf_event pfe;
-
-	if (!ice_has_vfs(pf))
-		return;
-
-	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
-	pfe.severity = PF_EVENT_SEVERITY_CERTAIN_DOOM;
-	ice_vc_vf_broadcast(pf, VIRTCHNL_OP_EVENT, VIRTCHNL_STATUS_SUCCESS,
-			    (u8 *)&pfe, sizeof(struct virtchnl_pf_event));
-}
-
 /**
  * ice_init_vf_vsi_res - initialize/setup VF VSI resources
  * @vf: VF to initialize/setup the VSI for
@@ -1455,3568 +1187,65 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 }
 
 /**
- * ice_vc_send_msg_to_vf - Send message to VF
- * @vf: pointer to the VF info
- * @v_opcode: virtual channel opcode
- * @v_retval: virtual channel return value
- * @msg: pointer to the msg buffer
- * @msglen: msg length
+ * ice_set_vf_spoofchk
+ * @netdev: network interface device structure
+ * @vf_id: VF identifier
+ * @ena: flag to enable or disable feature
  *
- * send msg to VF
+ * Enable or disable VF spoof checking
  */
-int
-ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
+int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 {
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+	struct ice_vsi *vf_vsi;
 	struct device *dev;
-	struct ice_pf *pf;
-	int aq_ret;
-
-	pf = vf->pf;
-	dev = ice_pf_to_dev(pf);
-
-	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
-				       msg, msglen, NULL);
-	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
-		dev_info(dev, "Unable to send the message to VF %d ret %d aq_err %s\n",
-			 vf->vf_id, aq_ret,
-			 ice_aq_str(pf->hw.mailboxq.sq_last_status));
-		return -EIO;
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_get_ver_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to request the API version used by the PF
- */
-static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
-{
-	struct virtchnl_version_info info = {
-		VIRTCHNL_VERSION_MAJOR, VIRTCHNL_VERSION_MINOR
-	};
-
-	vf->vf_ver = *(struct virtchnl_version_info *)msg;
-	/* VFs running the 1.0 API expect to get 1.0 back or they will cry. */
-	if (VF_IS_V10(&vf->vf_ver))
-		info.minor = VIRTCHNL_VERSION_MINOR_NO_VF_CAPS;
-
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_VERSION,
-				     VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
-				     sizeof(struct virtchnl_version_info));
-}
-
-/**
- * ice_vc_get_max_frame_size - get max frame size allowed for VF
- * @vf: VF used to determine max frame size
- *
- * Max frame size is determined based on the current port's max frame size and
- * whether a port VLAN is configured on this VF. The VF is not aware whether
- * it's in a port VLAN so the PF needs to account for this in max frame size
- * checks and sending the max frame size to the VF.
- */
-static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
-{
-	struct ice_port_info *pi = ice_vf_get_port_info(vf);
-	u16 max_frame_size;
-
-	max_frame_size = pi->phy.link_info.max_frame_size;
-
-	if (ice_vf_is_port_vlan_ena(vf))
-		max_frame_size -= VLAN_HLEN;
-
-	return max_frame_size;
-}
-
-/**
- * ice_vc_get_vf_res_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to request its resources
- */
-static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vf_resource *vfres = NULL;
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-	int len = 0;
+	struct ice_vf *vf;
 	int ret;
 
-	if (ice_check_vf_init(pf, vf)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto err;
-	}
+	dev = ice_pf_to_dev(pf);
 
-	len = sizeof(struct virtchnl_vf_resource);
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
 
-	vfres = kzalloc(len, GFP_KERNEL);
-	if (!vfres) {
-		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
-		len = 0;
-		goto err;
-	}
-	if (VF_IS_V11(&vf->vf_ver))
-		vf->driver_caps = *(u32 *)msg;
-	else
-		vf->driver_caps = VIRTCHNL_VF_OFFLOAD_L2 |
-				  VIRTCHNL_VF_OFFLOAD_RSS_REG |
-				  VIRTCHNL_VF_OFFLOAD_VLAN;
+	ret = ice_check_vf_ready_for_cfg(vf);
+	if (ret)
+		goto out_put_vf;
 
-	vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto err;
+	vf_vsi = ice_get_vf_vsi(vf);
+	if (!vf_vsi) {
+		netdev_err(netdev, "VSI %d for VF %d is null\n",
+			   vf->lan_vsi_idx, vf->vf_id);
+		ret = -EINVAL;
+		goto out_put_vf;
 	}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN_V2) {
-		/* VLAN offloads based on current device configuration */
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN_V2;
-	} else if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN) {
-		/* allow VF to negotiate VIRTCHNL_VF_OFFLOAD explicitly for
-		 * these two conditions, which amounts to guest VLAN filtering
-		 * and offloads being based on the inner VLAN or the
-		 * inner/single VLAN respectively and don't allow VF to
-		 * negotiate VIRTCHNL_VF_OFFLOAD in any other cases
-		 */
-		if (ice_is_dvm_ena(&pf->hw) && ice_vf_is_port_vlan_ena(vf)) {
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-		} else if (!ice_is_dvm_ena(&pf->hw) &&
-			   !ice_vf_is_port_vlan_ena(vf)) {
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-			/* configure backward compatible support for VFs that
-			 * only support VIRTCHNL_VF_OFFLOAD_VLAN, the PF is
-			 * configured in SVM, and no port VLAN is configured
-			 */
-			ice_vf_vsi_cfg_svm_legacy_vlan_mode(vsi);
-		} else if (ice_is_dvm_ena(&pf->hw)) {
-			/* configure software offloaded VLAN support when DVM
-			 * is enabled, but no port VLAN is enabled
-			 */
-			ice_vf_vsi_cfg_dvm_legacy_vlan_mode(vsi);
-		}
+	if (vf_vsi->type != ICE_VSI_VF) {
+		netdev_err(netdev, "Type %d of VSI %d for VF %d is no ICE_VSI_VF\n",
+			   vf_vsi->type, vf_vsi->vsi_num, vf->vf_id);
+		ret = -ENODEV;
+		goto out_put_vf;
 	}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PF;
-	} else {
-		if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_AQ)
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_AQ;
-		else
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_REG;
+	if (ena == vf->spoofchk) {
+		dev_dbg(dev, "VF spoofchk already %s\n", ena ? "ON" : "OFF");
+		ret = 0;
+		goto out_put_vf;
 	}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_FDIR_PF)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_FDIR_PF;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ENCAP)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ENCAP;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RX_POLLING)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RX_POLLING;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_WB_ON_ITR)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_WB_ON_ITR;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_REQ_QUEUES)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_REQ_QUEUES;
-
-	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_USO;
-
-	vfres->num_vsis = 1;
-	/* Tx and Rx queue are equal for VF */
-	vfres->num_queue_pairs = vsi->num_txq;
-	vfres->max_vectors = pf->vfs.num_msix_per;
-	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
-	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
-	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
-
-	vfres->vsi_res[0].vsi_id = vf->lan_vsi_num;
-	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
-	vfres->vsi_res[0].num_queue_pairs = vsi->num_txq;
-	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
-			vf->hw_lan_addr.addr);
-
-	/* match guest capabilities */
-	vf->driver_caps = vfres->vf_cap_flags;
-
-	ice_vc_set_caps_allowlist(vf);
-	ice_vc_set_working_allowlist(vf);
-
-	set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
-
-err:
-	/* send the response back to the VF */
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
-				    (u8 *)vfres, len);
+	ret = ice_vsi_apply_spoofchk(vf_vsi, ena);
+	if (ret)
+		dev_err(dev, "Failed to set spoofchk %s for VF %d VSI %d\n error %d\n",
+			ena ? "ON" : "OFF", vf->vf_id, vf_vsi->vsi_num, ret);
+	else
+		vf->spoofchk = ena;
 
-	kfree(vfres);
+out_put_vf:
+	ice_put_vf(vf);
 	return ret;
 }
 
-/**
- * ice_vc_reset_vf_msg
- * @vf: pointer to the VF info
- *
- * called from the VF to reset itself,
- * unlike other virtchnl messages, PF driver
- * doesn't send the response back to the VF
- */
-static void ice_vc_reset_vf_msg(struct ice_vf *vf)
-{
-	if (test_bit(ICE_VF_STATE_INIT, vf->vf_states))
-		ice_reset_vf(vf, 0);
-}
-
-/**
- * ice_find_vsi_from_id
- * @pf: the PF structure to search for the VSI
- * @id: ID of the VSI it is searching for
- *
- * searches for the VSI with the given ID
- */
-static struct ice_vsi *ice_find_vsi_from_id(struct ice_pf *pf, u16 id)
-{
-	int i;
-
-	ice_for_each_vsi(pf, i)
-		if (pf->vsi[i] && pf->vsi[i]->vsi_num == id)
-			return pf->vsi[i];
-
-	return NULL;
-}
-
-/**
- * ice_vc_isvalid_vsi_id
- * @vf: pointer to the VF info
- * @vsi_id: VF relative VSI ID
- *
- * check for the valid VSI ID
- */
-bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
-{
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-
-	vsi = ice_find_vsi_from_id(pf, vsi_id);
-
-	return (vsi && (vsi->vf == vf));
-}
-
-/**
- * ice_vc_isvalid_q_id
- * @vf: pointer to the VF info
- * @vsi_id: VSI ID
- * @qid: VSI relative queue ID
- *
- * check for the valid queue ID
- */
-static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
-{
-	struct ice_vsi *vsi = ice_find_vsi_from_id(vf->pf, vsi_id);
-	/* allocated Tx and Rx queues should be always equal for VF VSI */
-	return (vsi && (qid < vsi->alloc_txq));
-}
-
-/**
- * ice_vc_isvalid_ring_len
- * @ring_len: length of ring
- *
- * check for the valid ring count, should be multiple of ICE_REQ_DESC_MULTIPLE
- * or zero
- */
-static bool ice_vc_isvalid_ring_len(u16 ring_len)
-{
-	return ring_len == 0 ||
-	       (ring_len >= ICE_MIN_NUM_DESC &&
-		ring_len <= ICE_MAX_NUM_DESC &&
-		!(ring_len % ICE_REQ_DESC_MULTIPLE));
-}
-
-/**
- * ice_vc_validate_pattern
- * @vf: pointer to the VF info
- * @proto: virtchnl protocol headers
- *
- * validate the pattern is supported or not.
- *
- * Return: true on success, false on error.
- */
-bool
-ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto)
-{
-	bool is_ipv4 = false;
-	bool is_ipv6 = false;
-	bool is_udp = false;
-	u16 ptype = -1;
-	int i = 0;
-
-	while (i < proto->count &&
-	       proto->proto_hdr[i].type != VIRTCHNL_PROTO_HDR_NONE) {
-		switch (proto->proto_hdr[i].type) {
-		case VIRTCHNL_PROTO_HDR_ETH:
-			ptype = ICE_PTYPE_MAC_PAY;
-			break;
-		case VIRTCHNL_PROTO_HDR_IPV4:
-			ptype = ICE_PTYPE_IPV4_PAY;
-			is_ipv4 = true;
-			break;
-		case VIRTCHNL_PROTO_HDR_IPV6:
-			ptype = ICE_PTYPE_IPV6_PAY;
-			is_ipv6 = true;
-			break;
-		case VIRTCHNL_PROTO_HDR_UDP:
-			if (is_ipv4)
-				ptype = ICE_PTYPE_IPV4_UDP_PAY;
-			else if (is_ipv6)
-				ptype = ICE_PTYPE_IPV6_UDP_PAY;
-			is_udp = true;
-			break;
-		case VIRTCHNL_PROTO_HDR_TCP:
-			if (is_ipv4)
-				ptype = ICE_PTYPE_IPV4_TCP_PAY;
-			else if (is_ipv6)
-				ptype = ICE_PTYPE_IPV6_TCP_PAY;
-			break;
-		case VIRTCHNL_PROTO_HDR_SCTP:
-			if (is_ipv4)
-				ptype = ICE_PTYPE_IPV4_SCTP_PAY;
-			else if (is_ipv6)
-				ptype = ICE_PTYPE_IPV6_SCTP_PAY;
-			break;
-		case VIRTCHNL_PROTO_HDR_GTPU_IP:
-		case VIRTCHNL_PROTO_HDR_GTPU_EH:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_GTPU;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_GTPU;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_L2TPV3:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_L2TPV3;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_L2TPV3;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_ESP:
-			if (is_ipv4)
-				ptype = is_udp ? ICE_MAC_IPV4_NAT_T_ESP :
-						ICE_MAC_IPV4_ESP;
-			else if (is_ipv6)
-				ptype = is_udp ? ICE_MAC_IPV6_NAT_T_ESP :
-						ICE_MAC_IPV6_ESP;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_AH:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_AH;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_AH;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_PFCP:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_PFCP_SESSION;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_PFCP_SESSION;
-			goto out;
-		default:
-			break;
-		}
-		i++;
-	}
-
-out:
-	return ice_hw_ptype_ena(&vf->pf->hw, ptype);
-}
-
-/**
- * ice_vc_parse_rss_cfg - parses hash fields and headers from
- * a specific virtchnl RSS cfg
- * @hw: pointer to the hardware
- * @rss_cfg: pointer to the virtchnl RSS cfg
- * @addl_hdrs: pointer to the protocol header fields (ICE_FLOW_SEG_HDR_*)
- * to configure
- * @hash_flds: pointer to the hash bit fields (ICE_FLOW_HASH_*) to configure
- *
- * Return true if all the protocol header and hash fields in the RSS cfg could
- * be parsed, else return false
- *
- * This function parses the virtchnl RSS cfg to be the intended
- * hash fields and the intended header for RSS configuration
- */
-static bool
-ice_vc_parse_rss_cfg(struct ice_hw *hw, struct virtchnl_rss_cfg *rss_cfg,
-		     u32 *addl_hdrs, u64 *hash_flds)
-{
-	const struct ice_vc_hash_field_match_type *hf_list;
-	const struct ice_vc_hdr_match_type *hdr_list;
-	int i, hf_list_len, hdr_list_len;
-
-	hf_list = ice_vc_hash_field_list;
-	hf_list_len = ARRAY_SIZE(ice_vc_hash_field_list);
-	hdr_list = ice_vc_hdr_list;
-	hdr_list_len = ARRAY_SIZE(ice_vc_hdr_list);
-
-	for (i = 0; i < rss_cfg->proto_hdrs.count; i++) {
-		struct virtchnl_proto_hdr *proto_hdr =
-					&rss_cfg->proto_hdrs.proto_hdr[i];
-		bool hdr_found = false;
-		int j;
-
-		/* Find matched ice headers according to virtchnl headers. */
-		for (j = 0; j < hdr_list_len; j++) {
-			struct ice_vc_hdr_match_type hdr_map = hdr_list[j];
-
-			if (proto_hdr->type == hdr_map.vc_hdr) {
-				*addl_hdrs |= hdr_map.ice_hdr;
-				hdr_found = true;
-			}
-		}
-
-		if (!hdr_found)
-			return false;
-
-		/* Find matched ice hash fields according to
-		 * virtchnl hash fields.
-		 */
-		for (j = 0; j < hf_list_len; j++) {
-			struct ice_vc_hash_field_match_type hf_map = hf_list[j];
-
-			if (proto_hdr->type == hf_map.vc_hdr &&
-			    proto_hdr->field_selector == hf_map.vc_hash_field) {
-				*hash_flds |= hf_map.ice_hash_field;
-				break;
-			}
-		}
-	}
-
-	return true;
-}
-
-/**
- * ice_vf_adv_rss_offload_ena - determine if capabilities support advanced
- * RSS offloads
- * @caps: VF driver negotiated capabilities
- *
- * Return true if VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF capability is set,
- * else return false
- */
-static bool ice_vf_adv_rss_offload_ena(u32 caps)
-{
-	return !!(caps & VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF);
-}
-
-/**
- * ice_vc_handle_rss_cfg
- * @vf: pointer to the VF info
- * @msg: pointer to the message buffer
- * @add: add a RSS config if true, otherwise delete a RSS config
- *
- * This function adds/deletes a RSS config
- */
-static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
-{
-	u32 v_opcode = add ? VIRTCHNL_OP_ADD_RSS_CFG : VIRTCHNL_OP_DEL_RSS_CFG;
-	struct virtchnl_rss_cfg *rss_cfg = (struct virtchnl_rss_cfg *)msg;
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	struct ice_hw *hw = &vf->pf->hw;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
-		dev_dbg(dev, "VF %d attempting to configure RSS, but RSS is not supported by the PF\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-		goto error_param;
-	}
-
-	if (!ice_vf_adv_rss_offload_ena(vf->driver_caps)) {
-		dev_dbg(dev, "VF %d attempting to configure RSS, but Advanced RSS offload is not supported\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (rss_cfg->proto_hdrs.count > VIRTCHNL_MAX_NUM_PROTO_HDRS ||
-	    rss_cfg->rss_algorithm < VIRTCHNL_RSS_ALG_TOEPLITZ_ASYMMETRIC ||
-	    rss_cfg->rss_algorithm > VIRTCHNL_RSS_ALG_XOR_SYMMETRIC) {
-		dev_dbg(dev, "VF %d attempting to configure RSS, but RSS configuration is not valid\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_validate_pattern(vf, &rss_cfg->proto_hdrs)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (rss_cfg->rss_algorithm == VIRTCHNL_RSS_ALG_R_ASYMMETRIC) {
-		struct ice_vsi_ctx *ctx;
-		u8 lut_type, hash_type;
-		int status;
-
-		lut_type = ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI;
-		hash_type = add ? ICE_AQ_VSI_Q_OPT_RSS_XOR :
-				ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
-
-		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-		if (!ctx) {
-			v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
-			goto error_param;
-		}
-
-		ctx->info.q_opt_rss = ((lut_type <<
-					ICE_AQ_VSI_Q_OPT_RSS_LUT_S) &
-				       ICE_AQ_VSI_Q_OPT_RSS_LUT_M) |
-				       (hash_type &
-					ICE_AQ_VSI_Q_OPT_RSS_HASH_M);
-
-		/* Preserve existing queueing option setting */
-		ctx->info.q_opt_rss |= (vsi->info.q_opt_rss &
-					  ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_M);
-		ctx->info.q_opt_tc = vsi->info.q_opt_tc;
-		ctx->info.q_opt_flags = vsi->info.q_opt_rss;
-
-		ctx->info.valid_sections =
-				cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
-
-		status = ice_update_vsi(hw, vsi->idx, ctx, NULL);
-		if (status) {
-			dev_err(dev, "update VSI for RSS failed, err %d aq_err %s\n",
-				status, ice_aq_str(hw->adminq.sq_last_status));
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		} else {
-			vsi->info.q_opt_rss = ctx->info.q_opt_rss;
-		}
-
-		kfree(ctx);
-	} else {
-		u32 addl_hdrs = ICE_FLOW_SEG_HDR_NONE;
-		u64 hash_flds = ICE_HASH_INVALID;
-
-		if (!ice_vc_parse_rss_cfg(hw, rss_cfg, &addl_hdrs,
-					  &hash_flds)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		if (add) {
-			if (ice_add_rss_cfg(hw, vsi->idx, hash_flds,
-					    addl_hdrs)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				dev_err(dev, "ice_add_rss_cfg failed for vsi = %d, v_ret = %d\n",
-					vsi->vsi_num, v_ret);
-			}
-		} else {
-			int status;
-
-			status = ice_rem_rss_cfg(hw, vsi->idx, hash_flds,
-						 addl_hdrs);
-			/* We just ignore -ENOENT, because if two configurations
-			 * share the same profile remove one of them actually
-			 * removes both, since the profile is deleted.
-			 */
-			if (status && status != -ENOENT) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				dev_err(dev, "ice_rem_rss_cfg failed for VF ID:%d, error:%d\n",
-					vf->vf_id, status);
-			}
-		}
-	}
-
-error_param:
-	return ice_vc_send_msg_to_vf(vf, v_opcode, v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_config_rss_key
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * Configure the VF's RSS key
- */
-static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_rss_key *vrk =
-		(struct virtchnl_rss_key *)msg;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vrk->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (vrk->key_len != ICE_VSIQF_HKEY_ARRAY_SIZE) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (ice_set_rss_key(vsi, vrk->key))
-		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
-				     NULL, 0);
-}
-
-/**
- * ice_vc_config_rss_lut
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * Configure the VF's RSS LUT
- */
-static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
-{
-	struct virtchnl_rss_lut *vrl = (struct virtchnl_rss_lut *)msg;
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vrl->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (vrl->lut_entries != ICE_VSIQF_HLUT_ARRAY_SIZE) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (ice_set_rss_lut(vsi, vrl->lut, ICE_VSIQF_HLUT_ARRAY_SIZE))
-		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
-				     NULL, 0);
-}
-
-/**
- * ice_set_vf_spoofchk
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @ena: flag to enable or disable feature
- *
- * Enable or disable VF spoof checking
- */
-int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
-{
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_pf *pf = np->vsi->back;
-	struct ice_vsi *vf_vsi;
-	struct device *dev;
-	struct ice_vf *vf;
-	int ret;
-
-	dev = ice_pf_to_dev(pf);
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
-
-	vf_vsi = ice_get_vf_vsi(vf);
-	if (!vf_vsi) {
-		netdev_err(netdev, "VSI %d for VF %d is null\n",
-			   vf->lan_vsi_idx, vf->vf_id);
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
-
-	if (vf_vsi->type != ICE_VSI_VF) {
-		netdev_err(netdev, "Type %d of VSI %d for VF %d is no ICE_VSI_VF\n",
-			   vf_vsi->type, vf_vsi->vsi_num, vf->vf_id);
-		ret = -ENODEV;
-		goto out_put_vf;
-	}
-
-	if (ena == vf->spoofchk) {
-		dev_dbg(dev, "VF spoofchk already %s\n", ena ? "ON" : "OFF");
-		ret = 0;
-		goto out_put_vf;
-	}
-
-	ret = ice_vsi_apply_spoofchk(vf_vsi, ena);
-	if (ret)
-		dev_err(dev, "Failed to set spoofchk %s for VF %d VSI %d\n error %d\n",
-			ena ? "ON" : "OFF", vf->vf_id, vf_vsi->vsi_num, ret);
-	else
-		vf->spoofchk = ena;
-
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
-}
-
-/**
- * ice_vc_cfg_promiscuous_mode_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to configure VF VSIs promiscuous mode
- */
-static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	bool rm_promisc, alluni = false, allmulti = false;
-	struct virtchnl_promisc_info *info =
-	    (struct virtchnl_promisc_info *)msg;
-	struct ice_vsi_vlan_ops *vlan_ops;
-	int mcast_err = 0, ucast_err = 0;
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-	struct device *dev;
-	int ret = 0;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, info->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	dev = ice_pf_to_dev(pf);
-	if (!ice_is_vf_trusted(vf)) {
-		dev_err(dev, "Unprivileged VF %d is attempting to configure promiscuous mode\n",
-			vf->vf_id);
-		/* Leave v_ret alone, lie to the VF on purpose. */
-		goto error_param;
-	}
-
-	if (info->flags & FLAG_VF_UNICAST_PROMISC)
-		alluni = true;
-
-	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
-		allmulti = true;
-
-	rm_promisc = !allmulti && !alluni;
-
-	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
-	if (rm_promisc)
-		ret = vlan_ops->ena_rx_filtering(vsi);
-	else
-		ret = vlan_ops->dis_rx_filtering(vsi);
-	if (ret) {
-		dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
-		bool set_dflt_vsi = alluni || allmulti;
-
-		if (set_dflt_vsi && !ice_is_dflt_vsi_in_use(pf->first_sw))
-			/* only attempt to set the default forwarding VSI if
-			 * it's not currently set
-			 */
-			ret = ice_set_dflt_vsi(pf->first_sw, vsi);
-		else if (!set_dflt_vsi &&
-			 ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
-			/* only attempt to free the default forwarding VSI if we
-			 * are the owner
-			 */
-			ret = ice_clear_dflt_vsi(pf->first_sw);
-
-		if (ret) {
-			dev_err(dev, "%sable VF %d as the default VSI failed, error %d\n",
-				set_dflt_vsi ? "en" : "dis", vf->vf_id, ret);
-			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-			goto error_param;
-		}
-	} else {
-		u8 mcast_m, ucast_m;
-
-		if (ice_vf_is_port_vlan_ena(vf) ||
-		    ice_vsi_has_non_zero_vlans(vsi)) {
-			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
-		} else {
-			mcast_m = ICE_MCAST_PROMISC_BITS;
-			ucast_m = ICE_UCAST_PROMISC_BITS;
-		}
-
-		if (alluni)
-			ucast_err = ice_vf_set_vsi_promisc(vf, vsi, ucast_m);
-		else
-			ucast_err = ice_vf_clear_vsi_promisc(vf, vsi, ucast_m);
-
-		if (allmulti)
-			mcast_err = ice_vf_set_vsi_promisc(vf, vsi, mcast_m);
-		else
-			mcast_err = ice_vf_clear_vsi_promisc(vf, vsi, mcast_m);
-
-		if (ucast_err || mcast_err)
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-	}
-
-	if (!mcast_err) {
-		if (allmulti &&
-		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
-			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
-				 vf->vf_id);
-		else if (!allmulti &&
-			 test_and_clear_bit(ICE_VF_STATE_MC_PROMISC,
-					    vf->vf_states))
-			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
-				 vf->vf_id);
-	}
-
-	if (!ucast_err) {
-		if (alluni &&
-		    !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
-				 vf->vf_id);
-		else if (!alluni &&
-			 test_and_clear_bit(ICE_VF_STATE_UC_PROMISC,
-					    vf->vf_states))
-			dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n",
-				 vf->vf_id);
-	}
-
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_get_stats_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to get VSI stats
- */
-static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_queue_select *vqs =
-		(struct virtchnl_queue_select *)msg;
-	struct ice_eth_stats stats = { 0 };
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	ice_update_eth_stats(vsi);
-
-	stats = vsi->eth_stats;
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
-				     (u8 *)&stats, sizeof(stats));
-}
-
-/**
- * ice_vc_validate_vqs_bitmaps - validate Rx/Tx queue bitmaps from VIRTCHNL
- * @vqs: virtchnl_queue_select structure containing bitmaps to validate
- *
- * Return true on successful validation, else false
- */
-static bool ice_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
-{
-	if ((!vqs->rx_queues && !vqs->tx_queues) ||
-	    vqs->rx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF) ||
-	    vqs->tx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vf_ena_txq_interrupt - enable Tx queue interrupt via QINT_TQCTL
- * @vsi: VSI of the VF to configure
- * @q_idx: VF queue index used to determine the queue in the PF's space
- */
-static void ice_vf_ena_txq_interrupt(struct ice_vsi *vsi, u32 q_idx)
-{
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 pfq = vsi->txq_map[q_idx];
-	u32 reg;
-
-	reg = rd32(hw, QINT_TQCTL(pfq));
-
-	/* MSI-X index 0 in the VF's space is always for the OICR, which means
-	 * this is most likely a poll mode VF driver, so don't enable an
-	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
-	 */
-	if (!(reg & QINT_TQCTL_MSIX_INDX_M))
-		return;
-
-	wr32(hw, QINT_TQCTL(pfq), reg | QINT_TQCTL_CAUSE_ENA_M);
-}
-
-/**
- * ice_vf_ena_rxq_interrupt - enable Tx queue interrupt via QINT_RQCTL
- * @vsi: VSI of the VF to configure
- * @q_idx: VF queue index used to determine the queue in the PF's space
- */
-static void ice_vf_ena_rxq_interrupt(struct ice_vsi *vsi, u32 q_idx)
-{
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 pfq = vsi->rxq_map[q_idx];
-	u32 reg;
-
-	reg = rd32(hw, QINT_RQCTL(pfq));
-
-	/* MSI-X index 0 in the VF's space is always for the OICR, which means
-	 * this is most likely a poll mode VF driver, so don't enable an
-	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
-	 */
-	if (!(reg & QINT_RQCTL_MSIX_INDX_M))
-		return;
-
-	wr32(hw, QINT_RQCTL(pfq), reg | QINT_RQCTL_CAUSE_ENA_M);
-}
-
-/**
- * ice_vc_ena_qs_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to enable all or specific queue(s)
- */
-static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_queue_select *vqs =
-	    (struct virtchnl_queue_select *)msg;
-	struct ice_vsi *vsi;
-	unsigned long q_map;
-	u16 vf_q_id;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	/* Enable only Rx rings, Tx rings were enabled by the FW when the
-	 * Tx queue group list was configured and the context bits were
-	 * programmed using ice_vsi_cfg_txqs
-	 */
-	q_map = vqs->rx_queues;
-	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* Skip queue if enabled */
-		if (test_bit(vf_q_id, vf->rxq_ena))
-			continue;
-
-		if (ice_vsi_ctrl_one_rx_ring(vsi, true, vf_q_id, true)) {
-			dev_err(ice_pf_to_dev(vsi->back), "Failed to enable Rx ring %d on VSI %d\n",
-				vf_q_id, vsi->vsi_num);
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		ice_vf_ena_rxq_interrupt(vsi, vf_q_id);
-		set_bit(vf_q_id, vf->rxq_ena);
-	}
-
-	q_map = vqs->tx_queues;
-	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* Skip queue if enabled */
-		if (test_bit(vf_q_id, vf->txq_ena))
-			continue;
-
-		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
-		set_bit(vf_q_id, vf->txq_ena);
-	}
-
-	/* Set flag to indicate that queues are enabled */
-	if (v_ret == VIRTCHNL_STATUS_SUCCESS)
-		set_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
-				     NULL, 0);
-}
-
-/**
- * ice_vc_dis_qs_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to disable all or specific
- * queue(s)
- */
-static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_queue_select *vqs =
-	    (struct virtchnl_queue_select *)msg;
-	struct ice_vsi *vsi;
-	unsigned long q_map;
-	u16 vf_q_id;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) &&
-	    !test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (vqs->tx_queues) {
-		q_map = vqs->tx_queues;
-
-		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			struct ice_tx_ring *ring = vsi->tx_rings[vf_q_id];
-			struct ice_txq_meta txq_meta = { 0 };
-
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			/* Skip queue if not enabled */
-			if (!test_bit(vf_q_id, vf->txq_ena))
-				continue;
-
-			ice_fill_txq_meta(vsi, ring, &txq_meta);
-
-			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
-						 ring, &txq_meta)) {
-				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
-					vf_q_id, vsi->vsi_num);
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			/* Clear enabled queues flag */
-			clear_bit(vf_q_id, vf->txq_ena);
-		}
-	}
-
-	q_map = vqs->rx_queues;
-	/* speed up Rx queue disable by batching them if possible */
-	if (q_map &&
-	    bitmap_equal(&q_map, vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF)) {
-		if (ice_vsi_stop_all_rx_rings(vsi)) {
-			dev_err(ice_pf_to_dev(vsi->back), "Failed to stop all Rx rings on VSI %d\n",
-				vsi->vsi_num);
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
-	} else if (q_map) {
-		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			/* Skip queue if not enabled */
-			if (!test_bit(vf_q_id, vf->rxq_ena))
-				continue;
-
-			if (ice_vsi_ctrl_one_rx_ring(vsi, false, vf_q_id,
-						     true)) {
-				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Rx ring %d on VSI %d\n",
-					vf_q_id, vsi->vsi_num);
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			/* Clear enabled queues flag */
-			clear_bit(vf_q_id, vf->rxq_ena);
-		}
-	}
-
-	/* Clear enabled queues flag */
-	if (v_ret == VIRTCHNL_STATUS_SUCCESS && ice_vf_has_no_qs_ena(vf))
-		clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
-				     NULL, 0);
-}
-
-/**
- * ice_cfg_interrupt
- * @vf: pointer to the VF info
- * @vsi: the VSI being configured
- * @vector_id: vector ID
- * @map: vector map for mapping vectors to queues
- * @q_vector: structure for interrupt vector
- * configure the IRQ to queue map
- */
-static int
-ice_cfg_interrupt(struct ice_vf *vf, struct ice_vsi *vsi, u16 vector_id,
-		  struct virtchnl_vector_map *map,
-		  struct ice_q_vector *q_vector)
-{
-	u16 vsi_q_id, vsi_q_id_idx;
-	unsigned long qmap;
-
-	q_vector->num_ring_rx = 0;
-	q_vector->num_ring_tx = 0;
-
-	qmap = map->rxq_map;
-	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
-		vsi_q_id = vsi_q_id_idx;
-
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
-			return VIRTCHNL_STATUS_ERR_PARAM;
-
-		q_vector->num_ring_rx++;
-		q_vector->rx.itr_idx = map->rxitr_idx;
-		vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
-		ice_cfg_rxq_interrupt(vsi, vsi_q_id, vector_id,
-				      q_vector->rx.itr_idx);
-	}
-
-	qmap = map->txq_map;
-	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
-		vsi_q_id = vsi_q_id_idx;
-
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
-			return VIRTCHNL_STATUS_ERR_PARAM;
-
-		q_vector->num_ring_tx++;
-		q_vector->tx.itr_idx = map->txitr_idx;
-		vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
-		ice_cfg_txq_interrupt(vsi, vsi_q_id, vector_id,
-				      q_vector->tx.itr_idx);
-	}
-
-	return VIRTCHNL_STATUS_SUCCESS;
-}
-
-/**
- * ice_vc_cfg_irq_map_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to configure the IRQ to queue map
- */
-static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	u16 num_q_vectors_mapped, vsi_id, vector_id;
-	struct virtchnl_irq_map_info *irqmap_info;
-	struct virtchnl_vector_map *map;
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-	int i;
-
-	irqmap_info = (struct virtchnl_irq_map_info *)msg;
-	num_q_vectors_mapped = irqmap_info->num_vectors;
-
-	/* Check to make sure number of VF vectors mapped is not greater than
-	 * number of VF vectors originally allocated, and check that
-	 * there is actually at least a single VF queue vector mapped
-	 */
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    pf->vfs.num_msix_per < num_q_vectors_mapped ||
-	    !num_q_vectors_mapped) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	for (i = 0; i < num_q_vectors_mapped; i++) {
-		struct ice_q_vector *q_vector;
-
-		map = &irqmap_info->vecmap[i];
-
-		vector_id = map->vector_id;
-		vsi_id = map->vsi_id;
-		/* vector_id is always 0-based for each VF, and can never be
-		 * larger than or equal to the max allowed interrupts per VF
-		 */
-		if (!(vector_id < pf->vfs.num_msix_per) ||
-		    !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
-		    (!vector_id && (map->rxq_map || map->txq_map))) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* No need to map VF miscellaneous or rogue vector */
-		if (!vector_id)
-			continue;
-
-		/* Subtract non queue vector from vector_id passed by VF
-		 * to get actual number of VSI queue vector array index
-		 */
-		q_vector = vsi->q_vectors[vector_id - ICE_NONQ_VECS_VF];
-		if (!q_vector) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* lookout for the invalid queue index */
-		v_ret = (enum virtchnl_status_code)
-			ice_cfg_interrupt(vf, vsi, vector_id, map, q_vector);
-		if (v_ret)
-			goto error_param;
-	}
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
-				     NULL, 0);
-}
-
-/**
- * ice_vc_cfg_qs_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to configure the Rx/Tx queues
- */
-static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vsi_queue_config_info *qci =
-	    (struct virtchnl_vsi_queue_config_info *)msg;
-	struct virtchnl_queue_pair_info *qpi;
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-	int i, q_idx;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
-	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
-		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
-			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	for (i = 0; i < qci->num_queue_pairs; i++) {
-		qpi = &qci->qpair[i];
-		if (qpi->txq.vsi_id != qci->vsi_id ||
-		    qpi->rxq.vsi_id != qci->vsi_id ||
-		    qpi->rxq.queue_id != qpi->txq.queue_id ||
-		    qpi->txq.headwb_enabled ||
-		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
-		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
-		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		q_idx = qpi->rxq.queue_id;
-
-		/* make sure selected "q_idx" is in valid range of queues
-		 * for selected "vsi"
-		 */
-		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* copy Tx queue info from VF into VSI */
-		if (qpi->txq.ring_len > 0) {
-			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
-			vsi->tx_rings[i]->count = qpi->txq.ring_len;
-			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-		}
-
-		/* copy Rx queue info from VF into VSI */
-		if (qpi->rxq.ring_len > 0) {
-			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
-
-			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
-			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
-
-			if (qpi->rxq.databuffer_size != 0 &&
-			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-			     qpi->rxq.databuffer_size < 1024)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-			vsi->rx_buf_len = qpi->rxq.databuffer_size;
-			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
-			if (qpi->rxq.max_pkt_size > max_frame_size ||
-			    qpi->rxq.max_pkt_size < 64) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			vsi->max_frame = qpi->rxq.max_pkt_size;
-			/* add space for the port VLAN since the VF driver is
-			 * not expected to account for it in the MTU
-			 * calculation
-			 */
-			if (ice_vf_is_port_vlan_ena(vf))
-				vsi->max_frame += VLAN_HLEN;
-
-			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-		}
-	}
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES, v_ret,
-				     NULL, 0);
-}
-
-/**
- * ice_can_vf_change_mac
- * @vf: pointer to the VF info
- *
- * Return true if the VF is allowed to change its MAC filters, false otherwise
- */
-static bool ice_can_vf_change_mac(struct ice_vf *vf)
-{
-	/* If the VF MAC address has been set administratively (via the
-	 * ndo_set_vf_mac command), then deny permission to the VF to
-	 * add/delete unicast MAC addresses, unless the VF is trusted
-	 */
-	if (vf->pf_set_mac && !ice_is_vf_trusted(vf))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_ether_addr_type - get type of virtchnl_ether_addr
- * @vc_ether_addr: used to extract the type
- */
-static u8
-ice_vc_ether_addr_type(struct virtchnl_ether_addr *vc_ether_addr)
-{
-	return (vc_ether_addr->type & VIRTCHNL_ETHER_ADDR_TYPE_MASK);
-}
-
-/**
- * ice_is_vc_addr_legacy - check if the MAC address is from an older VF
- * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
- */
-static bool
-ice_is_vc_addr_legacy(struct virtchnl_ether_addr *vc_ether_addr)
-{
-	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
-
-	return (type == VIRTCHNL_ETHER_ADDR_LEGACY);
-}
-
-/**
- * ice_is_vc_addr_primary - check if the MAC address is the VF's primary MAC
- * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
- *
- * This function should only be called when the MAC address in
- * virtchnl_ether_addr is a valid unicast MAC
- */
-static bool
-ice_is_vc_addr_primary(struct virtchnl_ether_addr __maybe_unused *vc_ether_addr)
-{
-	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
-
-	return (type == VIRTCHNL_ETHER_ADDR_PRIMARY);
-}
-
-/**
- * ice_vfhw_mac_add - update the VF's cached hardware MAC if allowed
- * @vf: VF to update
- * @vc_ether_addr: structure from VIRTCHNL with MAC to add
- */
-static void
-ice_vfhw_mac_add(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
-{
-	u8 *mac_addr = vc_ether_addr->addr;
-
-	if (!is_valid_ether_addr(mac_addr))
-		return;
-
-	/* only allow legacy VF drivers to set the device and hardware MAC if it
-	 * is zero and allow new VF drivers to set the hardware MAC if the type
-	 * was correctly specified over VIRTCHNL
-	 */
-	if ((ice_is_vc_addr_legacy(vc_ether_addr) &&
-	     is_zero_ether_addr(vf->hw_lan_addr.addr)) ||
-	    ice_is_vc_addr_primary(vc_ether_addr)) {
-		ether_addr_copy(vf->dev_lan_addr.addr, mac_addr);
-		ether_addr_copy(vf->hw_lan_addr.addr, mac_addr);
-	}
-
-	/* hardware and device MACs are already set, but its possible that the
-	 * VF driver sent the VIRTCHNL_OP_ADD_ETH_ADDR message before the
-	 * VIRTCHNL_OP_DEL_ETH_ADDR when trying to update its MAC, so save it
-	 * away for the legacy VF driver case as it will be updated in the
-	 * delete flow for this case
-	 */
-	if (ice_is_vc_addr_legacy(vc_ether_addr)) {
-		ether_addr_copy(vf->legacy_last_added_umac.addr,
-				mac_addr);
-		vf->legacy_last_added_umac.time_modified = jiffies;
-	}
-}
-
-/**
- * ice_vc_add_mac_addr - attempt to add the MAC address passed in
- * @vf: pointer to the VF info
- * @vsi: pointer to the VF's VSI
- * @vc_ether_addr: VIRTCHNL MAC address structure used to add MAC
- */
-static int
-ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
-		    struct virtchnl_ether_addr *vc_ether_addr)
-{
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	u8 *mac_addr = vc_ether_addr->addr;
-	int ret;
-
-	/* device MAC already added */
-	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
-		return 0;
-
-	if (is_unicast_ether_addr(mac_addr) && !ice_can_vf_change_mac(vf)) {
-		dev_err(dev, "VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
-		return -EPERM;
-	}
-
-	ret = ice_fltr_add_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
-	if (ret == -EEXIST) {
-		dev_dbg(dev, "MAC %pM already exists for VF %d\n", mac_addr,
-			vf->vf_id);
-		/* don't return since we might need to update
-		 * the primary MAC in ice_vfhw_mac_add() below
-		 */
-	} else if (ret) {
-		dev_err(dev, "Failed to add MAC %pM for VF %d\n, error %d\n",
-			mac_addr, vf->vf_id, ret);
-		return ret;
-	} else {
-		vf->num_mac++;
-	}
-
-	ice_vfhw_mac_add(vf, vc_ether_addr);
-
-	return ret;
-}
-
-/**
- * ice_is_legacy_umac_expired - check if last added legacy unicast MAC expired
- * @last_added_umac: structure used to check expiration
- */
-static bool ice_is_legacy_umac_expired(struct ice_time_mac *last_added_umac)
-{
-#define ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME	msecs_to_jiffies(3000)
-	return time_is_before_jiffies(last_added_umac->time_modified +
-				      ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME);
-}
-
-/**
- * ice_update_legacy_cached_mac - update cached hardware MAC for legacy VF
- * @vf: VF to update
- * @vc_ether_addr: structure from VIRTCHNL with MAC to check
- *
- * only update cached hardware MAC for legacy VF drivers on delete
- * because we cannot guarantee order/type of MAC from the VF driver
- */
-static void
-ice_update_legacy_cached_mac(struct ice_vf *vf,
-			     struct virtchnl_ether_addr *vc_ether_addr)
-{
-	if (!ice_is_vc_addr_legacy(vc_ether_addr) ||
-	    ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
-		return;
-
-	ether_addr_copy(vf->dev_lan_addr.addr, vf->legacy_last_added_umac.addr);
-	ether_addr_copy(vf->hw_lan_addr.addr, vf->legacy_last_added_umac.addr);
-}
-
-/**
- * ice_vfhw_mac_del - update the VF's cached hardware MAC if allowed
- * @vf: VF to update
- * @vc_ether_addr: structure from VIRTCHNL with MAC to delete
- */
-static void
-ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
-{
-	u8 *mac_addr = vc_ether_addr->addr;
-
-	if (!is_valid_ether_addr(mac_addr) ||
-	    !ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
-		return;
-
-	/* allow the device MAC to be repopulated in the add flow and don't
-	 * clear the hardware MAC (i.e. hw_lan_addr.addr) here as that is meant
-	 * to be persistent on VM reboot and across driver unload/load, which
-	 * won't work if we clear the hardware MAC here
-	 */
-	eth_zero_addr(vf->dev_lan_addr.addr);
-
-	ice_update_legacy_cached_mac(vf, vc_ether_addr);
-}
-
-/**
- * ice_vc_del_mac_addr - attempt to delete the MAC address passed in
- * @vf: pointer to the VF info
- * @vsi: pointer to the VF's VSI
- * @vc_ether_addr: VIRTCHNL MAC address structure used to delete MAC
- */
-static int
-ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
-		    struct virtchnl_ether_addr *vc_ether_addr)
-{
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	u8 *mac_addr = vc_ether_addr->addr;
-	int status;
-
-	if (!ice_can_vf_change_mac(vf) &&
-	    ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
-		return 0;
-
-	status = ice_fltr_remove_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
-	if (status == -ENOENT) {
-		dev_err(dev, "MAC %pM does not exist for VF %d\n", mac_addr,
-			vf->vf_id);
-		return -ENOENT;
-	} else if (status) {
-		dev_err(dev, "Failed to delete MAC %pM for VF %d, error %d\n",
-			mac_addr, vf->vf_id, status);
-		return -EIO;
-	}
-
-	ice_vfhw_mac_del(vf, vc_ether_addr);
-
-	vf->num_mac--;
-
-	return 0;
-}
-
-/**
- * ice_vc_handle_mac_addr_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- * @set: true if MAC filters are being set, false otherwise
- *
- * add guest MAC address filter
- */
-static int
-ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
-{
-	int (*ice_vc_cfg_mac)
-		(struct ice_vf *vf, struct ice_vsi *vsi,
-		 struct virtchnl_ether_addr *virtchnl_ether_addr);
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_ether_addr_list *al =
-	    (struct virtchnl_ether_addr_list *)msg;
-	struct ice_pf *pf = vf->pf;
-	enum virtchnl_ops vc_op;
-	struct ice_vsi *vsi;
-	int i;
-
-	if (set) {
-		vc_op = VIRTCHNL_OP_ADD_ETH_ADDR;
-		ice_vc_cfg_mac = ice_vc_add_mac_addr;
-	} else {
-		vc_op = VIRTCHNL_OP_DEL_ETH_ADDR;
-		ice_vc_cfg_mac = ice_vc_del_mac_addr;
-	}
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	/* If this VF is not privileged, then we can't add more than a
-	 * limited number of addresses. Check to make sure that the
-	 * additions do not push us over the limit.
-	 */
-	if (set && !ice_is_vf_trusted(vf) &&
-	    (vf->num_mac + al->num_elements) > ICE_MAX_MACADDR_PER_VF) {
-		dev_err(ice_pf_to_dev(pf), "Can't add more MAC addresses, because VF-%d is not trusted, switch the VF to trusted mode in order to add more functionalities\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	for (i = 0; i < al->num_elements; i++) {
-		u8 *mac_addr = al->list[i].addr;
-		int result;
-
-		if (is_broadcast_ether_addr(mac_addr) ||
-		    is_zero_ether_addr(mac_addr))
-			continue;
-
-		result = ice_vc_cfg_mac(vf, vsi, &al->list[i]);
-		if (result == -EEXIST || result == -ENOENT) {
-			continue;
-		} else if (result) {
-			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-			goto handle_mac_exit;
-		}
-	}
-
-handle_mac_exit:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_add_mac_addr_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * add guest MAC address filter
- */
-static int ice_vc_add_mac_addr_msg(struct ice_vf *vf, u8 *msg)
-{
-	return ice_vc_handle_mac_addr_msg(vf, msg, true);
-}
-
-/**
- * ice_vc_del_mac_addr_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * remove guest MAC address filter
- */
-static int ice_vc_del_mac_addr_msg(struct ice_vf *vf, u8 *msg)
-{
-	return ice_vc_handle_mac_addr_msg(vf, msg, false);
-}
-
-/**
- * ice_vc_request_qs_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * VFs get a default number of queues but can use this message to request a
- * different number. If the request is successful, PF will reset the VF and
- * return 0. If unsuccessful, PF will send message informing VF of number of
- * available queue pairs via virtchnl message response to VF.
- */
-static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vf_res_request *vfres =
-		(struct virtchnl_vf_res_request *)msg;
-	u16 req_queues = vfres->num_queue_pairs;
-	struct ice_pf *pf = vf->pf;
-	u16 max_allowed_vf_queues;
-	u16 tx_rx_queue_left;
-	struct device *dev;
-	u16 cur_queues;
-
-	dev = ice_pf_to_dev(pf);
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	cur_queues = vf->num_vf_qs;
-	tx_rx_queue_left = min_t(u16, ice_get_avail_txq_count(pf),
-				 ice_get_avail_rxq_count(pf));
-	max_allowed_vf_queues = tx_rx_queue_left + cur_queues;
-	if (!req_queues) {
-		dev_err(dev, "VF %d tried to request 0 queues. Ignoring.\n",
-			vf->vf_id);
-	} else if (req_queues > ICE_MAX_RSS_QS_PER_VF) {
-		dev_err(dev, "VF %d tried to request more than %d queues.\n",
-			vf->vf_id, ICE_MAX_RSS_QS_PER_VF);
-		vfres->num_queue_pairs = ICE_MAX_RSS_QS_PER_VF;
-	} else if (req_queues > cur_queues &&
-		   req_queues - cur_queues > tx_rx_queue_left) {
-		dev_warn(dev, "VF %d requested %u more queues, but only %u left.\n",
-			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
-		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
-					       ICE_MAX_RSS_QS_PER_VF);
-	} else {
-		/* request is successful, then reset VF */
-		vf->num_req_qs = req_queues;
-		ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
-		dev_info(dev, "VF %d granted request of %u queues.\n",
-			 vf->vf_id, req_queues);
-		return 0;
-	}
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
-				     v_ret, (u8 *)vfres, sizeof(*vfres));
-}
-
-/**
- * ice_vf_vlan_offload_ena - determine if capabilities support VLAN offloads
- * @caps: VF driver negotiated capabilities
- *
- * Return true if VIRTCHNL_VF_OFFLOAD_VLAN capability is set, else return false
- */
-static bool ice_vf_vlan_offload_ena(u32 caps)
-{
-	return !!(caps & VIRTCHNL_VF_OFFLOAD_VLAN);
-}
-
-/**
- * ice_is_vlan_promisc_allowed - check if VLAN promiscuous config is allowed
- * @vf: VF used to determine if VLAN promiscuous config is allowed
- */
-static bool ice_is_vlan_promisc_allowed(struct ice_vf *vf)
-{
-	if ((test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
-	     test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) &&
-	    test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, vf->pf->flags))
-		return true;
-
-	return false;
-}
-
-/**
- * ice_vf_ena_vlan_promisc - Enable Tx/Rx VLAN promiscuous for the VLAN
- * @vsi: VF's VSI used to enable VLAN promiscuous mode
- * @vlan: VLAN used to enable VLAN promiscuous
- *
- * This function should only be called if VLAN promiscuous mode is allowed,
- * which can be determined via ice_is_vlan_promisc_allowed().
- */
-static int ice_vf_ena_vlan_promisc(struct ice_vsi *vsi, struct ice_vlan *vlan)
-{
-	u8 promisc_m = ICE_PROMISC_VLAN_TX | ICE_PROMISC_VLAN_RX;
-	int status;
-
-	status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m,
-					  vlan->vid);
-	if (status && status != -EEXIST)
-		return status;
-
-	return 0;
-}
-
-/**
- * ice_vf_dis_vlan_promisc - Disable Tx/Rx VLAN promiscuous for the VLAN
- * @vsi: VF's VSI used to disable VLAN promiscuous mode for
- * @vlan: VLAN used to disable VLAN promiscuous
- *
- * This function should only be called if VLAN promiscuous mode is allowed,
- * which can be determined via ice_is_vlan_promisc_allowed().
- */
-static int ice_vf_dis_vlan_promisc(struct ice_vsi *vsi, struct ice_vlan *vlan)
-{
-	u8 promisc_m = ICE_PROMISC_VLAN_TX | ICE_PROMISC_VLAN_RX;
-	int status;
-
-	status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m,
-					    vlan->vid);
-	if (status && status != -ENOENT)
-		return status;
-
-	return 0;
-}
-
-/**
- * ice_vf_has_max_vlans - check if VF already has the max allowed VLAN filters
- * @vf: VF to check against
- * @vsi: VF's VSI
- *
- * If the VF is trusted then the VF is allowed to add as many VLANs as it
- * wants to, so return false.
- *
- * When the VF is untrusted compare the number of non-zero VLANs + 1 to the max
- * allowed VLANs for an untrusted VF. Return the result of this comparison.
- */
-static bool ice_vf_has_max_vlans(struct ice_vf *vf, struct ice_vsi *vsi)
-{
-	if (ice_is_vf_trusted(vf))
-		return false;
-
-#define ICE_VF_ADDED_VLAN_ZERO_FLTRS	1
-	return ((ice_vsi_num_non_zero_vlans(vsi) +
-		ICE_VF_ADDED_VLAN_ZERO_FLTRS) >= ICE_MAX_VLAN_PER_VF);
-}
-
-/**
- * ice_vc_process_vlan_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- * @add_v: Add VLAN if true, otherwise delete VLAN
- *
- * Process virtchnl op to add or remove programmed guest VLAN ID
- */
-static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_filter_list *vfl =
-	    (struct virtchnl_vlan_filter_list *)msg;
-	struct ice_pf *pf = vf->pf;
-	bool vlan_promisc = false;
-	struct ice_vsi *vsi;
-	struct device *dev;
-	int status = 0;
-	int i;
-
-	dev = ice_pf_to_dev(pf);
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		if (vfl->vlan_id[i] >= VLAN_N_VID) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			dev_err(dev, "invalid VF VLAN id %d\n",
-				vfl->vlan_id[i]);
-			goto error_param;
-		}
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (add_v && ice_vf_has_max_vlans(vf, vsi)) {
-		dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
-			 vf->vf_id);
-		/* There is no need to let VF know about being not trusted,
-		 * so we can just return success message here
-		 */
-		goto error_param;
-	}
-
-	/* in DVM a VF can add/delete inner VLAN filters when
-	 * VIRTCHNL_VF_OFFLOAD_VLAN is negotiated, so only reject in SVM
-	 */
-	if (ice_vf_is_port_vlan_ena(vf) && !ice_is_dvm_ena(&pf->hw)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	/* in DVM VLAN promiscuous is based on the outer VLAN, which would be
-	 * the port VLAN if VIRTCHNL_VF_OFFLOAD_VLAN was negotiated, so only
-	 * allow vlan_promisc = true in SVM and if no port VLAN is configured
-	 */
-	vlan_promisc = ice_is_vlan_promisc_allowed(vf) &&
-		!ice_is_dvm_ena(&pf->hw) &&
-		!ice_vf_is_port_vlan_ena(vf);
-
-	if (add_v) {
-		for (i = 0; i < vfl->num_elements; i++) {
-			u16 vid = vfl->vlan_id[i];
-			struct ice_vlan vlan;
-
-			if (ice_vf_has_max_vlans(vf, vsi)) {
-				dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
-					 vf->vf_id);
-				/* There is no need to let VF know about being
-				 * not trusted, so we can just return success
-				 * message here as well.
-				 */
-				goto error_param;
-			}
-
-			/* we add VLAN 0 by default for each VF so we can enable
-			 * Tx VLAN anti-spoof without triggering MDD events so
-			 * we don't need to add it again here
-			 */
-			if (!vid)
-				continue;
-
-			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
-			status = vsi->inner_vlan_ops.add_vlan(vsi, &vlan);
-			if (status) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			/* Enable VLAN filtering on first non-zero VLAN */
-			if (!vlan_promisc && vid && !ice_is_dvm_ena(&pf->hw)) {
-				if (vsi->inner_vlan_ops.ena_rx_filtering(vsi)) {
-					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
-						vid, status);
-					goto error_param;
-				}
-			} else if (vlan_promisc) {
-				status = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (status) {
-					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(dev, "Enable Unicast/multicast promiscuous mode on VLAN ID:%d failed error-%d\n",
-						vid, status);
-				}
-			}
-		}
-	} else {
-		/* In case of non_trusted VF, number of VLAN elements passed
-		 * to PF for removal might be greater than number of VLANs
-		 * filter programmed for that VF - So, use actual number of
-		 * VLANS added earlier with add VLAN opcode. In order to avoid
-		 * removing VLAN that doesn't exist, which result to sending
-		 * erroneous failed message back to the VF
-		 */
-		int num_vf_vlan;
-
-		num_vf_vlan = vsi->num_vlan;
-		for (i = 0; i < vfl->num_elements && i < num_vf_vlan; i++) {
-			u16 vid = vfl->vlan_id[i];
-			struct ice_vlan vlan;
-
-			/* we add VLAN 0 by default for each VF so we can enable
-			 * Tx VLAN anti-spoof without triggering MDD events so
-			 * we don't want a VIRTCHNL request to remove it
-			 */
-			if (!vid)
-				continue;
-
-			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
-			status = vsi->inner_vlan_ops.del_vlan(vsi, &vlan);
-			if (status) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			/* Disable VLAN filtering when only VLAN 0 is left */
-			if (!ice_vsi_has_non_zero_vlans(vsi))
-				vsi->inner_vlan_ops.dis_rx_filtering(vsi);
-
-			if (vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
-		}
-	}
-
-error_param:
-	/* send the response to the VF */
-	if (add_v)
-		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
-					     NULL, 0);
-	else
-		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
-					     NULL, 0);
-}
-
-/**
- * ice_vc_add_vlan_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * Add and program guest VLAN ID
- */
-static int ice_vc_add_vlan_msg(struct ice_vf *vf, u8 *msg)
-{
-	return ice_vc_process_vlan_msg(vf, msg, true);
-}
-
-/**
- * ice_vc_remove_vlan_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * remove programmed guest VLAN ID
- */
-static int ice_vc_remove_vlan_msg(struct ice_vf *vf, u8 *msg)
-{
-	return ice_vc_process_vlan_msg(vf, msg, false);
-}
-
-/**
- * ice_vc_ena_vlan_stripping
- * @vf: pointer to the VF info
- *
- * Enable VLAN header stripping for a given VF
- */
-static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_dis_vlan_stripping
- * @vf: pointer to the VF info
- *
- * Disable VLAN header stripping for a given VF
- */
-static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (vsi->inner_vlan_ops.dis_stripping(vsi))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
- * @vf: VF to enable/disable VLAN stripping for on initialization
- *
- * Set the default for VLAN stripping based on whether a port VLAN is configured
- * and the current VLAN mode of the device.
- */
-static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
-{
-	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-
-	if (!vsi)
-		return -EINVAL;
-
-	/* don't modify stripping if port VLAN is configured in SVM since the
-	 * port VLAN is based on the inner/single VLAN in SVM
-	 */
-	if (ice_vf_is_port_vlan_ena(vf) && !ice_is_dvm_ena(&vsi->back->hw))
-		return 0;
-
-	if (ice_vf_vlan_offload_ena(vf->driver_caps))
-		return vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
-	else
-		return vsi->inner_vlan_ops.dis_stripping(vsi);
-}
-
-static u16 ice_vc_get_max_vlan_fltrs(struct ice_vf *vf)
-{
-	if (vf->trusted)
-		return VLAN_N_VID;
-	else
-		return ICE_MAX_VLAN_PER_VF;
-}
-
-/**
- * ice_vf_outer_vlan_not_allowed - check if outer VLAN can be used
- * @vf: VF that being checked for
- *
- * When the device is in double VLAN mode, check whether or not the outer VLAN
- * is allowed.
- */
-static bool ice_vf_outer_vlan_not_allowed(struct ice_vf *vf)
-{
-	if (ice_vf_is_port_vlan_ena(vf))
-		return true;
-
-	return false;
-}
-
-/**
- * ice_vc_set_dvm_caps - set VLAN capabilities when the device is in DVM
- * @vf: VF that capabilities are being set for
- * @caps: VLAN capabilities to populate
- *
- * Determine VLAN capabilities support based on whether a port VLAN is
- * configured. If a port VLAN is configured then the VF should use the inner
- * filtering/offload capabilities since the port VLAN is using the outer VLAN
- * capabilies.
- */
-static void
-ice_vc_set_dvm_caps(struct ice_vf *vf, struct virtchnl_vlan_caps *caps)
-{
-	struct virtchnl_vlan_supported_caps *supported_caps;
-
-	if (ice_vf_outer_vlan_not_allowed(vf)) {
-		/* until support for inner VLAN filtering is added when a port
-		 * VLAN is configured, only support software offloaded inner
-		 * VLANs when a port VLAN is confgured in DVM
-		 */
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		caps->offloads.ethertype_match =
-			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
-	} else {
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-					VIRTCHNL_VLAN_ETHERTYPE_9100 |
-					VIRTCHNL_VLAN_ETHERTYPE_AND;
-		caps->filtering.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-						 VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-						 VIRTCHNL_VLAN_ETHERTYPE_9100;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-					VIRTCHNL_VLAN_ETHERTYPE_9100 |
-					VIRTCHNL_VLAN_ETHERTYPE_XOR |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-					VIRTCHNL_VLAN_ETHERTYPE_9100 |
-					VIRTCHNL_VLAN_ETHERTYPE_XOR |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-
-		caps->offloads.ethertype_match =
-			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
-	}
-
-	caps->filtering.max_filters = ice_vc_get_max_vlan_fltrs(vf);
-}
-
-/**
- * ice_vc_set_svm_caps - set VLAN capabilities when the device is in SVM
- * @vf: VF that capabilities are being set for
- * @caps: VLAN capabilities to populate
- *
- * Determine VLAN capabilities support based on whether a port VLAN is
- * configured. If a port VLAN is configured then the VF does not have any VLAN
- * filtering or offload capabilities since the port VLAN is using the inner VLAN
- * capabilities in single VLAN mode (SVM). Otherwise allow the VF to use inner
- * VLAN fitlering and offload capabilities.
- */
-static void
-ice_vc_set_svm_caps(struct ice_vf *vf, struct virtchnl_vlan_caps *caps)
-{
-	struct virtchnl_vlan_supported_caps *supported_caps;
-
-	if (ice_vf_is_port_vlan_ena(vf)) {
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_UNSUPPORTED;
-		caps->offloads.ethertype_match = VIRTCHNL_VLAN_UNSUPPORTED;
-		caps->filtering.max_filters = 0;
-	} else {
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-		caps->filtering.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		caps->offloads.ethertype_match =
-			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
-		caps->filtering.max_filters = ice_vc_get_max_vlan_fltrs(vf);
-	}
-}
-
-/**
- * ice_vc_get_offload_vlan_v2_caps - determine VF's VLAN capabilities
- * @vf: VF to determine VLAN capabilities for
- *
- * This will only be called if the VF and PF successfully negotiated
- * VIRTCHNL_VF_OFFLOAD_VLAN_V2.
- *
- * Set VLAN capabilities based on the current VLAN mode and whether a port VLAN
- * is configured or not.
- */
-static int ice_vc_get_offload_vlan_v2_caps(struct ice_vf *vf)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_caps *caps = NULL;
-	int err, len = 0;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
-	if (!caps) {
-		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
-		goto out;
-	}
-	len = sizeof(*caps);
-
-	if (ice_is_dvm_ena(&vf->pf->hw))
-		ice_vc_set_dvm_caps(vf, caps);
-	else
-		ice_vc_set_svm_caps(vf, caps);
-
-	/* store negotiated caps to prevent invalid VF messages */
-	memcpy(&vf->vlan_v2_caps, caps, sizeof(*caps));
-
-out:
-	err = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
-				    v_ret, (u8 *)caps, len);
-	kfree(caps);
-	return err;
-}
-
-/**
- * ice_vc_validate_vlan_tpid - validate VLAN TPID
- * @filtering_caps: negotiated/supported VLAN filtering capabilities
- * @tpid: VLAN TPID used for validation
- *
- * Convert the VLAN TPID to a VIRTCHNL_VLAN_ETHERTYPE_* and then compare against
- * the negotiated/supported filtering caps to see if the VLAN TPID is valid.
- */
-static bool ice_vc_validate_vlan_tpid(u16 filtering_caps, u16 tpid)
-{
-	enum virtchnl_vlan_support vlan_ethertype = VIRTCHNL_VLAN_UNSUPPORTED;
-
-	switch (tpid) {
-	case ETH_P_8021Q:
-		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		break;
-	case ETH_P_8021AD:
-		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_88A8;
-		break;
-	case ETH_P_QINQ1:
-		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_9100;
-		break;
-	}
-
-	if (!(filtering_caps & vlan_ethertype))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_is_valid_vlan - validate the virtchnl_vlan
- * @vc_vlan: virtchnl_vlan to validate
- *
- * If the VLAN TCI and VLAN TPID are 0, then this filter is invalid, so return
- * false. Otherwise return true.
- */
-static bool ice_vc_is_valid_vlan(struct virtchnl_vlan *vc_vlan)
-{
-	if (!vc_vlan->tci || !vc_vlan->tpid)
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_validate_vlan_filter_list - validate the filter list from the VF
- * @vfc: negotiated/supported VLAN filtering capabilities
- * @vfl: VLAN filter list from VF to validate
- *
- * Validate all of the filters in the VLAN filter list from the VF. If any of
- * the checks fail then return false. Otherwise return true.
- */
-static bool
-ice_vc_validate_vlan_filter_list(struct virtchnl_vlan_filtering_caps *vfc,
-				 struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	u16 i;
-
-	if (!vfl->num_elements)
-		return false;
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		struct virtchnl_vlan_supported_caps *filtering_support =
-			&vfc->filtering_support;
-		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
-		struct virtchnl_vlan *outer = &vlan_fltr->outer;
-		struct virtchnl_vlan *inner = &vlan_fltr->inner;
-
-		if ((ice_vc_is_valid_vlan(outer) &&
-		     filtering_support->outer == VIRTCHNL_VLAN_UNSUPPORTED) ||
-		    (ice_vc_is_valid_vlan(inner) &&
-		     filtering_support->inner == VIRTCHNL_VLAN_UNSUPPORTED))
-			return false;
-
-		if ((outer->tci_mask &&
-		     !(filtering_support->outer & VIRTCHNL_VLAN_FILTER_MASK)) ||
-		    (inner->tci_mask &&
-		     !(filtering_support->inner & VIRTCHNL_VLAN_FILTER_MASK)))
-			return false;
-
-		if (((outer->tci & VLAN_PRIO_MASK) &&
-		     !(filtering_support->outer & VIRTCHNL_VLAN_PRIO)) ||
-		    ((inner->tci & VLAN_PRIO_MASK) &&
-		     !(filtering_support->inner & VIRTCHNL_VLAN_PRIO)))
-			return false;
-
-		if ((ice_vc_is_valid_vlan(outer) &&
-		     !ice_vc_validate_vlan_tpid(filtering_support->outer,
-						outer->tpid)) ||
-		    (ice_vc_is_valid_vlan(inner) &&
-		     !ice_vc_validate_vlan_tpid(filtering_support->inner,
-						inner->tpid)))
-			return false;
-	}
-
-	return true;
-}
-
-/**
- * ice_vc_to_vlan - transform from struct virtchnl_vlan to struct ice_vlan
- * @vc_vlan: struct virtchnl_vlan to transform
- */
-static struct ice_vlan ice_vc_to_vlan(struct virtchnl_vlan *vc_vlan)
-{
-	struct ice_vlan vlan = { 0 };
-
-	vlan.prio = (vc_vlan->tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	vlan.vid = vc_vlan->tci & VLAN_VID_MASK;
-	vlan.tpid = vc_vlan->tpid;
-
-	return vlan;
-}
-
-/**
- * ice_vc_vlan_action - action to perform on the virthcnl_vlan
- * @vsi: VF's VSI used to perform the action
- * @vlan_action: function to perform the action with (i.e. add/del)
- * @vlan: VLAN filter to perform the action with
- */
-static int
-ice_vc_vlan_action(struct ice_vsi *vsi,
-		   int (*vlan_action)(struct ice_vsi *, struct ice_vlan *),
-		   struct ice_vlan *vlan)
-{
-	int err;
-
-	err = vlan_action(vsi, vlan);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-/**
- * ice_vc_del_vlans - delete VLAN(s) from the virtchnl filter list
- * @vf: VF used to delete the VLAN(s)
- * @vsi: VF's VSI used to delete the VLAN(s)
- * @vfl: virthchnl filter list used to delete the filters
- */
-static int
-ice_vc_del_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
-		 struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	bool vlan_promisc = ice_is_vlan_promisc_allowed(vf);
-	int err;
-	u16 i;
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
-		struct virtchnl_vlan *vc_vlan;
-
-		vc_vlan = &vlan_fltr->outer;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->outer_vlan_ops.del_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			if (vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
-		}
-
-		vc_vlan = &vlan_fltr->inner;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->inner_vlan_ops.del_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			/* no support for VLAN promiscuous on inner VLAN unless
-			 * we are in Single VLAN Mode (SVM)
-			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
-		}
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_remove_vlan_v2_msg - virtchnl handler for VIRTCHNL_OP_DEL_VLAN_V2
- * @vf: VF the message was received from
- * @msg: message received from the VF
- */
-static int ice_vc_remove_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	struct virtchnl_vlan_filter_list_v2 *vfl =
-		(struct virtchnl_vlan_filter_list_v2 *)msg;
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
-
-	if (!ice_vc_validate_vlan_filter_list(&vf->vlan_v2_caps.filtering,
-					      vfl)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vfl->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (ice_vc_del_vlans(vf, vsi, vfl))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL,
-				     0);
-}
-
-/**
- * ice_vc_add_vlans - add VLAN(s) from the virtchnl filter list
- * @vf: VF used to add the VLAN(s)
- * @vsi: VF's VSI used to add the VLAN(s)
- * @vfl: virthchnl filter list used to add the filters
- */
-static int
-ice_vc_add_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
-		 struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	bool vlan_promisc = ice_is_vlan_promisc_allowed(vf);
-	int err;
-	u16 i;
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
-		struct virtchnl_vlan *vc_vlan;
-
-		vc_vlan = &vlan_fltr->outer;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->outer_vlan_ops.add_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			if (vlan_promisc) {
-				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (err)
-					return err;
-			}
-		}
-
-		vc_vlan = &vlan_fltr->inner;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->inner_vlan_ops.add_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			/* no support for VLAN promiscuous on inner VLAN unless
-			 * we are in Single VLAN Mode (SVM)
-			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc) {
-				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (err)
-					return err;
-			}
-		}
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_validate_add_vlan_filter_list - validate add filter list from the VF
- * @vsi: VF VSI used to get number of existing VLAN filters
- * @vfc: negotiated/supported VLAN filtering capabilities
- * @vfl: VLAN filter list from VF to validate
- *
- * Validate all of the filters in the VLAN filter list from the VF during the
- * VIRTCHNL_OP_ADD_VLAN_V2 opcode. If any of the checks fail then return false.
- * Otherwise return true.
- */
-static bool
-ice_vc_validate_add_vlan_filter_list(struct ice_vsi *vsi,
-				     struct virtchnl_vlan_filtering_caps *vfc,
-				     struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	u16 num_requested_filters = vsi->num_vlan + vfl->num_elements;
-
-	if (num_requested_filters > vfc->max_filters)
-		return false;
-
-	return ice_vc_validate_vlan_filter_list(vfc, vfl);
-}
-
-/**
- * ice_vc_add_vlan_v2_msg - virtchnl handler for VIRTCHNL_OP_ADD_VLAN_V2
- * @vf: VF the message was received from
- * @msg: message received from the VF
- */
-static int ice_vc_add_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_filter_list_v2 *vfl =
-		(struct virtchnl_vlan_filter_list_v2 *)msg;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vfl->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_validate_add_vlan_filter_list(vsi,
-						  &vf->vlan_v2_caps.filtering,
-						  vfl)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (ice_vc_add_vlans(vf, vsi, vfl))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL,
-				     0);
-}
-
-/**
- * ice_vc_valid_vlan_setting - validate VLAN setting
- * @negotiated_settings: negotiated VLAN settings during VF init
- * @ethertype_setting: ethertype(s) requested for the VLAN setting
- */
-static bool
-ice_vc_valid_vlan_setting(u32 negotiated_settings, u32 ethertype_setting)
-{
-	if (ethertype_setting && !(negotiated_settings & ethertype_setting))
-		return false;
-
-	/* only allow a single VIRTCHNL_VLAN_ETHERTYPE if
-	 * VIRTHCNL_VLAN_ETHERTYPE_AND is not negotiated/supported
-	 */
-	if (!(negotiated_settings & VIRTCHNL_VLAN_ETHERTYPE_AND) &&
-	    hweight32(ethertype_setting) > 1)
-		return false;
-
-	/* ability to modify the VLAN setting was not negotiated */
-	if (!(negotiated_settings & VIRTCHNL_VLAN_TOGGLE))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_valid_vlan_setting_msg - validate the VLAN setting message
- * @caps: negotiated VLAN settings during VF init
- * @msg: message to validate
- *
- * Used to validate any VLAN virtchnl message sent as a
- * virtchnl_vlan_setting structure. Validates the message against the
- * negotiated/supported caps during VF driver init.
- */
-static bool
-ice_vc_valid_vlan_setting_msg(struct virtchnl_vlan_supported_caps *caps,
-			      struct virtchnl_vlan_setting *msg)
-{
-	if ((!msg->outer_ethertype_setting &&
-	     !msg->inner_ethertype_setting) ||
-	    (!caps->outer && !caps->inner))
-		return false;
-
-	if (msg->outer_ethertype_setting &&
-	    !ice_vc_valid_vlan_setting(caps->outer,
-				       msg->outer_ethertype_setting))
-		return false;
-
-	if (msg->inner_ethertype_setting &&
-	    !ice_vc_valid_vlan_setting(caps->inner,
-				       msg->inner_ethertype_setting))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_get_tpid - transform from VIRTCHNL_VLAN_ETHERTYPE_* to VLAN TPID
- * @ethertype_setting: VIRTCHNL_VLAN_ETHERTYPE_* used to get VLAN TPID
- * @tpid: VLAN TPID to populate
- */
-static int ice_vc_get_tpid(u32 ethertype_setting, u16 *tpid)
-{
-	switch (ethertype_setting) {
-	case VIRTCHNL_VLAN_ETHERTYPE_8100:
-		*tpid = ETH_P_8021Q;
-		break;
-	case VIRTCHNL_VLAN_ETHERTYPE_88A8:
-		*tpid = ETH_P_8021AD;
-		break;
-	case VIRTCHNL_VLAN_ETHERTYPE_9100:
-		*tpid = ETH_P_QINQ1;
-		break;
-	default:
-		*tpid = 0;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_ena_vlan_offload - enable VLAN offload based on the ethertype_setting
- * @vsi: VF's VSI used to enable the VLAN offload
- * @ena_offload: function used to enable the VLAN offload
- * @ethertype_setting: VIRTCHNL_VLAN_ETHERTYPE_* to enable offloads for
- */
-static int
-ice_vc_ena_vlan_offload(struct ice_vsi *vsi,
-			int (*ena_offload)(struct ice_vsi *vsi, u16 tpid),
-			u32 ethertype_setting)
-{
-	u16 tpid;
-	int err;
-
-	err = ice_vc_get_tpid(ethertype_setting, &tpid);
-	if (err)
-		return err;
-
-	err = ena_offload(vsi, tpid);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-#define ICE_L2TSEL_QRX_CONTEXT_REG_IDX	3
-#define ICE_L2TSEL_BIT_OFFSET		23
-enum ice_l2tsel {
-	ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND,
-	ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1,
-};
-
-/**
- * ice_vsi_update_l2tsel - update l2tsel field for all Rx rings on this VSI
- * @vsi: VSI used to update l2tsel on
- * @l2tsel: l2tsel setting requested
- *
- * Use the l2tsel setting to update all of the Rx queue context bits for l2tsel.
- * This will modify which descriptor field the first offloaded VLAN will be
- * stripped into.
- */
-static void ice_vsi_update_l2tsel(struct ice_vsi *vsi, enum ice_l2tsel l2tsel)
-{
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 l2tsel_bit;
-	int i;
-
-	if (l2tsel == ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND)
-		l2tsel_bit = 0;
-	else
-		l2tsel_bit = BIT(ICE_L2TSEL_BIT_OFFSET);
-
-	for (i = 0; i < vsi->alloc_rxq; i++) {
-		u16 pfq = vsi->rxq_map[i];
-		u32 qrx_context_offset;
-		u32 regval;
-
-		qrx_context_offset =
-			QRX_CONTEXT(ICE_L2TSEL_QRX_CONTEXT_REG_IDX, pfq);
-
-		regval = rd32(hw, qrx_context_offset);
-		regval &= ~BIT(ICE_L2TSEL_BIT_OFFSET);
-		regval |= l2tsel_bit;
-		wr32(hw, qrx_context_offset, regval);
-	}
-}
-
-/**
- * ice_vc_ena_vlan_stripping_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2
- */
-static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *stripping_support;
-	struct virtchnl_vlan_setting *strip_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, strip_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	stripping_support = &vf->vlan_v2_caps.offloads.stripping_support;
-	if (!ice_vc_valid_vlan_setting_msg(stripping_support, strip_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = strip_msg->outer_ethertype_setting;
-	if (ethertype_setting) {
-		if (ice_vc_ena_vlan_offload(vsi,
-					    vsi->outer_vlan_ops.ena_stripping,
-					    ethertype_setting)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto out;
-		} else {
-			enum ice_l2tsel l2tsel =
-				ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND;
-
-			/* PF tells the VF that the outer VLAN tag is always
-			 * extracted to VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 and
-			 * inner is always extracted to
-			 * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1. This is needed to
-			 * support outer stripping so the first tag always ends
-			 * up in L2TAG2_2ND and the second/inner tag, if
-			 * enabled, is extracted in L2TAG1.
-			 */
-			ice_vsi_update_l2tsel(vsi, l2tsel);
-		}
-	}
-
-	ethertype_setting = strip_msg->inner_ethertype_setting;
-	if (ethertype_setting &&
-	    ice_vc_ena_vlan_offload(vsi, vsi->inner_vlan_ops.ena_stripping,
-				    ethertype_setting)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_dis_vlan_stripping_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2
- */
-static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *stripping_support;
-	struct virtchnl_vlan_setting *strip_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, strip_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	stripping_support = &vf->vlan_v2_caps.offloads.stripping_support;
-	if (!ice_vc_valid_vlan_setting_msg(stripping_support, strip_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = strip_msg->outer_ethertype_setting;
-	if (ethertype_setting) {
-		if (vsi->outer_vlan_ops.dis_stripping(vsi)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto out;
-		} else {
-			enum ice_l2tsel l2tsel =
-				ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1;
-
-			/* PF tells the VF that the outer VLAN tag is always
-			 * extracted to VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 and
-			 * inner is always extracted to
-			 * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1. This is needed to
-			 * support inner stripping while outer stripping is
-			 * disabled so that the first and only tag is extracted
-			 * in L2TAG1.
-			 */
-			ice_vsi_update_l2tsel(vsi, l2tsel);
-		}
-	}
-
-	ethertype_setting = strip_msg->inner_ethertype_setting;
-	if (ethertype_setting && vsi->inner_vlan_ops.dis_stripping(vsi)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_ena_vlan_insertion_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2
- */
-static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *insertion_support;
-	struct virtchnl_vlan_setting *insertion_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, insertion_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	insertion_support = &vf->vlan_v2_caps.offloads.insertion_support;
-	if (!ice_vc_valid_vlan_setting_msg(insertion_support, insertion_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->outer_ethertype_setting;
-	if (ethertype_setting &&
-	    ice_vc_ena_vlan_offload(vsi, vsi->outer_vlan_ops.ena_insertion,
-				    ethertype_setting)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->inner_ethertype_setting;
-	if (ethertype_setting &&
-	    ice_vc_ena_vlan_offload(vsi, vsi->inner_vlan_ops.ena_insertion,
-				    ethertype_setting)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_dis_vlan_insertion_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2
- */
-static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *insertion_support;
-	struct virtchnl_vlan_setting *insertion_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, insertion_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	insertion_support = &vf->vlan_v2_caps.offloads.insertion_support;
-	if (!ice_vc_valid_vlan_setting_msg(insertion_support, insertion_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->outer_ethertype_setting;
-	if (ethertype_setting && vsi->outer_vlan_ops.dis_insertion(vsi)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->inner_ethertype_setting;
-	if (ethertype_setting && vsi->inner_vlan_ops.dis_insertion(vsi)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
-}
-
-static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
-	.get_ver_msg = ice_vc_get_ver_msg,
-	.get_vf_res_msg = ice_vc_get_vf_res_msg,
-	.reset_vf = ice_vc_reset_vf_msg,
-	.add_mac_addr_msg = ice_vc_add_mac_addr_msg,
-	.del_mac_addr_msg = ice_vc_del_mac_addr_msg,
-	.cfg_qs_msg = ice_vc_cfg_qs_msg,
-	.ena_qs_msg = ice_vc_ena_qs_msg,
-	.dis_qs_msg = ice_vc_dis_qs_msg,
-	.request_qs_msg = ice_vc_request_qs_msg,
-	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
-	.config_rss_key = ice_vc_config_rss_key,
-	.config_rss_lut = ice_vc_config_rss_lut,
-	.get_stats_msg = ice_vc_get_stats_msg,
-	.cfg_promiscuous_mode_msg = ice_vc_cfg_promiscuous_mode_msg,
-	.add_vlan_msg = ice_vc_add_vlan_msg,
-	.remove_vlan_msg = ice_vc_remove_vlan_msg,
-	.ena_vlan_stripping = ice_vc_ena_vlan_stripping,
-	.dis_vlan_stripping = ice_vc_dis_vlan_stripping,
-	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
-	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
-	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
-	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
-	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
-	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
-	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
-	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
-	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
-	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
-};
-
-/**
- * ice_virtchnl_set_dflt_ops - Switch to default virtchnl ops
- * @vf: the VF to switch ops
- */
-void ice_virtchnl_set_dflt_ops(struct ice_vf *vf)
-{
-	vf->virtchnl_ops = &ice_virtchnl_dflt_ops;
-}
-
-/**
- * ice_vc_repr_add_mac
- * @vf: pointer to VF
- * @msg: virtchannel message
- *
- * When port representors are created, we do not add MAC rule
- * to firmware, we store it so that PF could report same
- * MAC as VF.
- */
-static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_ether_addr_list *al =
-	    (struct virtchnl_ether_addr_list *)msg;
-	struct ice_vsi *vsi;
-	struct ice_pf *pf;
-	int i;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	pf = vf->pf;
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	for (i = 0; i < al->num_elements; i++) {
-		u8 *mac_addr = al->list[i].addr;
-		int result;
-
-		if (!is_unicast_ether_addr(mac_addr) ||
-		    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
-			continue;
-
-		if (vf->pf_set_mac) {
-			dev_err(ice_pf_to_dev(pf), "VF attempting to override administratively set MAC address\n");
-			v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-			goto handle_mac_exit;
-		}
-
-		result = ice_eswitch_add_vf_mac_rule(pf, vf, mac_addr);
-		if (result) {
-			dev_err(ice_pf_to_dev(pf), "Failed to add MAC %pM for VF %d\n, error %d\n",
-				mac_addr, vf->vf_id, result);
-			goto handle_mac_exit;
-		}
-
-		ice_vfhw_mac_add(vf, &al->list[i]);
-		vf->num_mac++;
-		break;
-	}
-
-handle_mac_exit:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_repr_del_mac - response with success for deleting MAC
- * @vf: pointer to VF
- * @msg: virtchannel message
- *
- * Respond with success to not break normal VF flow.
- * For legacy VF driver try to update cached MAC address.
- */
-static int
-ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
-{
-	struct virtchnl_ether_addr_list *al =
-		(struct virtchnl_ether_addr_list *)msg;
-
-	ice_update_legacy_cached_mac(vf, &al->list[0]);
-
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_add_vlan(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't add VLAN in switchdev mode for VF %d\n", vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_del_vlan(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't delete VLAN in switchdev mode for VF %d\n", vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_ena_vlan_stripping(struct ice_vf *vf)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't enable VLAN stripping in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static int ice_vc_repr_dis_vlan_stripping(struct ice_vf *vf)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't disable VLAN stripping in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static int
-ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't config promiscuous mode in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static const struct ice_virtchnl_ops ice_virtchnl_repr_ops = {
-	.get_ver_msg = ice_vc_get_ver_msg,
-	.get_vf_res_msg = ice_vc_get_vf_res_msg,
-	.reset_vf = ice_vc_reset_vf_msg,
-	.add_mac_addr_msg = ice_vc_repr_add_mac,
-	.del_mac_addr_msg = ice_vc_repr_del_mac,
-	.cfg_qs_msg = ice_vc_cfg_qs_msg,
-	.ena_qs_msg = ice_vc_ena_qs_msg,
-	.dis_qs_msg = ice_vc_dis_qs_msg,
-	.request_qs_msg = ice_vc_request_qs_msg,
-	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
-	.config_rss_key = ice_vc_config_rss_key,
-	.config_rss_lut = ice_vc_config_rss_lut,
-	.get_stats_msg = ice_vc_get_stats_msg,
-	.cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode,
-	.add_vlan_msg = ice_vc_repr_add_vlan,
-	.remove_vlan_msg = ice_vc_repr_del_vlan,
-	.ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping,
-	.dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping,
-	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
-	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
-	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
-	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
-	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
-	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
-	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
-	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
-	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
-	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
-};
-
-/**
- * ice_virtchnl_set_repr_ops - Switch to representor virtchnl ops
- * @vf: the VF to switch ops
- */
-void ice_virtchnl_set_repr_ops(struct ice_vf *vf)
-{
-	vf->virtchnl_ops = &ice_virtchnl_repr_ops;
-}
-
-/**
- * ice_vc_process_vf_msg - Process request from VF
- * @pf: pointer to the PF structure
- * @event: pointer to the AQ event
- *
- * called from the common asq/arq handler to
- * process request from VF
- */
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
-{
-	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
-	s16 vf_id = le16_to_cpu(event->desc.retval);
-	const struct ice_virtchnl_ops *ops;
-	u16 msglen = event->msg_len;
-	u8 *msg = event->msg_buf;
-	struct ice_vf *vf = NULL;
-	struct device *dev;
-	int err = 0;
-
-	dev = ice_pf_to_dev(pf);
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf) {
-		dev_err(dev, "Unable to locate VF for message from VF ID %d, opcode %d, len %d\n",
-			vf_id, v_opcode, msglen);
-		return;
-	}
-
-	/* Check if VF is disabled. */
-	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
-		err = -EPERM;
-		goto error_handler;
-	}
-
-	ops = vf->virtchnl_ops;
-
-	/* Perform basic checks on the msg */
-	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
-	if (err) {
-		if (err == VIRTCHNL_STATUS_ERR_PARAM)
-			err = -EPERM;
-		else
-			err = -EINVAL;
-	}
-
-	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
-		ice_vc_send_msg_to_vf(vf, v_opcode,
-				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
-				      0);
-		ice_put_vf(vf);
-		return;
-	}
-
-error_handler:
-	if (err) {
-		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
-				      NULL, 0);
-		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
-			vf_id, v_opcode, msglen, err);
-		ice_put_vf(vf);
-		return;
-	}
-
-	/* VF is being configured in another context that triggers a VFR, so no
-	 * need to process this message
-	 */
-	if (!mutex_trylock(&vf->cfg_lock)) {
-		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
-			 vf->vf_id);
-		ice_put_vf(vf);
-		return;
-	}
-
-	switch (v_opcode) {
-	case VIRTCHNL_OP_VERSION:
-		err = ops->get_ver_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_GET_VF_RESOURCES:
-		err = ops->get_vf_res_msg(vf, msg);
-		if (ice_vf_init_vlan_stripping(vf))
-			dev_dbg(dev, "Failed to initialize VLAN stripping for VF %d\n",
-				vf->vf_id);
-		ice_vc_notify_vf_link_state(vf);
-		break;
-	case VIRTCHNL_OP_RESET_VF:
-		ops->reset_vf(vf);
-		break;
-	case VIRTCHNL_OP_ADD_ETH_ADDR:
-		err = ops->add_mac_addr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_ETH_ADDR:
-		err = ops->del_mac_addr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_VSI_QUEUES:
-		err = ops->cfg_qs_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_QUEUES:
-		err = ops->ena_qs_msg(vf, msg);
-		ice_vc_notify_vf_link_state(vf);
-		break;
-	case VIRTCHNL_OP_DISABLE_QUEUES:
-		err = ops->dis_qs_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_REQUEST_QUEUES:
-		err = ops->request_qs_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_IRQ_MAP:
-		err = ops->cfg_irq_map_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_RSS_KEY:
-		err = ops->config_rss_key(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_RSS_LUT:
-		err = ops->config_rss_lut(vf, msg);
-		break;
-	case VIRTCHNL_OP_GET_STATS:
-		err = ops->get_stats_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
-		err = ops->cfg_promiscuous_mode_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ADD_VLAN:
-		err = ops->add_vlan_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_VLAN:
-		err = ops->remove_vlan_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
-		err = ops->ena_vlan_stripping(vf);
-		break;
-	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
-		err = ops->dis_vlan_stripping(vf);
-		break;
-	case VIRTCHNL_OP_ADD_FDIR_FILTER:
-		err = ops->add_fdir_fltr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_FDIR_FILTER:
-		err = ops->del_fdir_fltr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ADD_RSS_CFG:
-		err = ops->handle_rss_cfg_msg(vf, msg, true);
-		break;
-	case VIRTCHNL_OP_DEL_RSS_CFG:
-		err = ops->handle_rss_cfg_msg(vf, msg, false);
-		break;
-	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS:
-		err = ops->get_offload_vlan_v2_caps(vf);
-		break;
-	case VIRTCHNL_OP_ADD_VLAN_V2:
-		err = ops->add_vlan_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_VLAN_V2:
-		err = ops->remove_vlan_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2:
-		err = ops->ena_vlan_stripping_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2:
-		err = ops->dis_vlan_stripping_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2:
-		err = ops->ena_vlan_insertion_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2:
-		err = ops->dis_vlan_insertion_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_UNKNOWN:
-	default:
-		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
-			vf_id);
-		err = ice_vc_send_msg_to_vf(vf, v_opcode,
-					    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-					    NULL, 0);
-		break;
-	}
-	if (err) {
-		/* Helper function cares less about error return values here
-		 * as it is busy with pending work.
-		 */
-		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
-			 vf_id, v_opcode, err);
-	}
-
-	mutex_unlock(&vf->cfg_lock);
-	ice_put_vf(vf);
-}
-
 /**
  * ice_get_vf_cfg
  * @netdev: network interface device structure
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 8f0b3789ba4b..955ab810a198 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -5,13 +5,7 @@
 #define _ICE_SRIOV_H_
 #include "ice_virtchnl_fdir.h"
 #include "ice_vf_lib.h"
-
-/* Restrict number of MAC Addr and VLAN that non-trusted VF can programmed */
-#define ICE_MAX_VLAN_PER_VF		8
-/* MAC filters: 1 is reserved for the VF's default/perm_addr/LAA MAC, 1 for
- * broadcast, and 16 for additional unicast/multicast filters
- */
-#define ICE_MAX_MACADDR_PER_VF		18
+#include "ice_virtchnl.h"
 
 /* Static VF transaction/status register def */
 #define VF_DEVICE_STATUS		0xAA
@@ -31,39 +25,6 @@
 #define ICE_MAX_VF_RESET_TRIES		40
 #define ICE_MAX_VF_RESET_SLEEP_MS	20
 
-struct ice_vf;
-
-struct ice_virtchnl_ops {
-	int (*get_ver_msg)(struct ice_vf *vf, u8 *msg);
-	int (*get_vf_res_msg)(struct ice_vf *vf, u8 *msg);
-	void (*reset_vf)(struct ice_vf *vf);
-	int (*add_mac_addr_msg)(struct ice_vf *vf, u8 *msg);
-	int (*del_mac_addr_msg)(struct ice_vf *vf, u8 *msg);
-	int (*cfg_qs_msg)(struct ice_vf *vf, u8 *msg);
-	int (*ena_qs_msg)(struct ice_vf *vf, u8 *msg);
-	int (*dis_qs_msg)(struct ice_vf *vf, u8 *msg);
-	int (*request_qs_msg)(struct ice_vf *vf, u8 *msg);
-	int (*cfg_irq_map_msg)(struct ice_vf *vf, u8 *msg);
-	int (*config_rss_key)(struct ice_vf *vf, u8 *msg);
-	int (*config_rss_lut)(struct ice_vf *vf, u8 *msg);
-	int (*get_stats_msg)(struct ice_vf *vf, u8 *msg);
-	int (*cfg_promiscuous_mode_msg)(struct ice_vf *vf, u8 *msg);
-	int (*add_vlan_msg)(struct ice_vf *vf, u8 *msg);
-	int (*remove_vlan_msg)(struct ice_vf *vf, u8 *msg);
-	int (*ena_vlan_stripping)(struct ice_vf *vf);
-	int (*dis_vlan_stripping)(struct ice_vf *vf);
-	int (*handle_rss_cfg_msg)(struct ice_vf *vf, u8 *msg, bool add);
-	int (*add_fdir_fltr_msg)(struct ice_vf *vf, u8 *msg);
-	int (*del_fdir_fltr_msg)(struct ice_vf *vf, u8 *msg);
-	int (*get_offload_vlan_v2_caps)(struct ice_vf *vf);
-	int (*add_vlan_v2_msg)(struct ice_vf *vf, u8 *msg);
-	int (*remove_vlan_v2_msg)(struct ice_vf *vf, u8 *msg);
-	int (*ena_vlan_stripping_v2_msg)(struct ice_vf *vf, u8 *msg);
-	int (*dis_vlan_stripping_v2_msg)(struct ice_vf *vf, u8 *msg);
-	int (*ena_vlan_insertion_v2_msg)(struct ice_vf *vf, u8 *msg);
-	int (*dis_vlan_insertion_v2_msg)(struct ice_vf *vf, u8 *msg);
-};
-
 #ifdef CONFIG_PCI_IOV
 void ice_process_vflr_event(struct ice_pf *pf);
 int ice_sriov_configure(struct pci_dev *pdev, int num_vfs);
@@ -73,11 +34,6 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi);
 
 void ice_free_vfs(struct ice_pf *pf);
 void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
-void ice_vc_notify_link_state(struct ice_pf *pf);
-void ice_vc_notify_reset(struct ice_pf *pf);
-void ice_vc_notify_vf_link_state(struct ice_vf *vf);
-void ice_virtchnl_set_repr_ops(struct ice_vf *vf);
-void ice_virtchnl_set_dflt_ops(struct ice_vf *vf);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
 bool
 ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
@@ -108,20 +64,11 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf);
 void ice_print_vf_rx_mdd_event(struct ice_vf *vf);
 bool
 ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto);
-int
-ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
-bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_process_vflr_event(struct ice_pf *pf) { }
 static inline void ice_free_vfs(struct ice_pf *pf) { }
 static inline
 void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event) { }
-static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
-static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
-static inline void ice_vc_notify_vf_link_state(struct ice_vf *vf) { }
-static inline void ice_virtchnl_set_repr_ops(struct ice_vf *vf) { }
-static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
 static inline
 void ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event) { }
 static inline void ice_print_vfs_mdd_events(struct ice_pf *pf) { }
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
similarity index 68%
copy from drivers/net/ethernet/intel/ice/ice_sriov.c
copy to drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 4f3d25ed68c9..d820ec622640 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1,18 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2018, Intel Corporation. */
+/* Copyright (C) 2022, Intel Corporation. */
 
-#include "ice.h"
+#include "ice_virtchnl.h"
 #include "ice_vf_lib_private.h"
+#include "ice.h"
 #include "ice_base.h"
 #include "ice_lib.h"
 #include "ice_fltr.h"
-#include "ice_dcb_lib.h"
-#include "ice_flow.h"
-#include "ice_eswitch.h"
 #include "ice_virtchnl_allowlist.h"
-#include "ice_flex_pipe.h"
 #include "ice_vf_vsi_vlan_ops.h"
 #include "ice_vlan.h"
+#include "ice_flex_pipe.h"
+#include "ice_dcb_lib.h"
 
 #define FIELD_SELECTOR(proto_hdr_field) \
 		BIT((proto_hdr_field) & PROTO_HDR_FIELD_MASK)
@@ -166,32 +165,6 @@ ice_vc_hash_field_match_type ice_vc_hash_field_list[] = {
 		BIT_ULL(ICE_FLOW_FIELD_IDX_PFCP_SEID)},
 };
 
-/**
- * ice_free_vf_entries - Free all VF entries from the hash table
- * @pf: pointer to the PF structure
- *
- * Iterate over the VF hash table, removing and releasing all VF entries.
- * Called during VF teardown or as cleanup during failed VF initialization.
- */
-static void ice_free_vf_entries(struct ice_pf *pf)
-{
-	struct ice_vfs *vfs = &pf->vfs;
-	struct hlist_node *tmp;
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	/* Remove all VFs from the hash table and release their main
-	 * reference. Once all references to the VF are dropped, ice_put_vf()
-	 * will call ice_release_vf which will remove the VF memory.
-	 */
-	lockdep_assert_held(&vfs->table_lock);
-
-	hash_for_each_safe(vfs->table, bkt, tmp, vf, entry) {
-		hash_del_rcu(&vf->entry);
-		ice_put_vf(vf);
-	}
-}
-
 /**
  * ice_vc_vf_broadcast - Broadcast a message to all VFs on PF
  * @pf: pointer to the PF structure
@@ -275,1695 +248,1335 @@ void ice_vc_notify_vf_link_state(struct ice_vf *vf)
 }
 
 /**
- * ice_vf_vsi_release - invalidate the VF's VSI after freeing it
- * @vf: invalidate this VF's VSI after freeing it
+ * ice_vc_notify_link_state - Inform all VFs on a PF of link status
+ * @pf: pointer to the PF structure
  */
-static void ice_vf_vsi_release(struct ice_vf *vf)
+void ice_vc_notify_link_state(struct ice_pf *pf)
 {
-	ice_vsi_release(ice_get_vf_vsi(vf));
-	ice_vf_invalidate_vsi(vf);
+	struct ice_vf *vf;
+	unsigned int bkt;
+
+	mutex_lock(&pf->vfs.table_lock);
+	ice_for_each_vf(pf, bkt, vf)
+		ice_vc_notify_vf_link_state(vf);
+	mutex_unlock(&pf->vfs.table_lock);
 }
 
 /**
- * ice_free_vf_res - Free a VF's resources
- * @vf: pointer to the VF info
+ * ice_vc_notify_reset - Send pending reset message to all VFs
+ * @pf: pointer to the PF structure
+ *
+ * indicate a pending reset to all VFs on a given PF
  */
-static void ice_free_vf_res(struct ice_vf *vf)
+void ice_vc_notify_reset(struct ice_pf *pf)
 {
-	struct ice_pf *pf = vf->pf;
-	int i, last_vector_idx;
-
-	/* First, disable VF's configuration API to prevent OS from
-	 * accessing the VF's VSI after it's freed or invalidated.
-	 */
-	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
-	ice_vf_fdir_exit(vf);
-	/* free VF control VSI */
-	if (vf->ctrl_vsi_idx != ICE_NO_VSI)
-		ice_vf_ctrl_vsi_release(vf);
-
-	/* free VSI and disconnect it from the parent uplink */
-	if (vf->lan_vsi_idx != ICE_NO_VSI) {
-		ice_vf_vsi_release(vf);
-		vf->num_mac = 0;
-	}
-
-	last_vector_idx = vf->first_vector_idx + pf->vfs.num_msix_per - 1;
+	struct virtchnl_pf_event pfe;
 
-	/* clear VF MDD event information */
-	memset(&vf->mdd_tx_events, 0, sizeof(vf->mdd_tx_events));
-	memset(&vf->mdd_rx_events, 0, sizeof(vf->mdd_rx_events));
+	if (!ice_has_vfs(pf))
+		return;
 
-	/* Disable interrupts so that VF starts in a known state */
-	for (i = vf->first_vector_idx; i <= last_vector_idx; i++) {
-		wr32(&pf->hw, GLINT_DYN_CTL(i), GLINT_DYN_CTL_CLEARPBA_M);
-		ice_flush(&pf->hw);
-	}
-	/* reset some of the state variables keeping track of the resources */
-	clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states);
-	clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states);
+	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
+	pfe.severity = PF_EVENT_SEVERITY_CERTAIN_DOOM;
+	ice_vc_vf_broadcast(pf, VIRTCHNL_OP_EVENT, VIRTCHNL_STATUS_SUCCESS,
+			    (u8 *)&pfe, sizeof(struct virtchnl_pf_event));
 }
 
 /**
- * ice_dis_vf_mappings
- * @vf: pointer to the VF structure
+ * ice_vc_send_msg_to_vf - Send message to VF
+ * @vf: pointer to the VF info
+ * @v_opcode: virtual channel opcode
+ * @v_retval: virtual channel return value
+ * @msg: pointer to the msg buffer
+ * @msglen: msg length
+ *
+ * send msg to VF
  */
-static void ice_dis_vf_mappings(struct ice_vf *vf)
+int
+ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
+		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
 {
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
 	struct device *dev;
-	int first, last, v;
-	struct ice_hw *hw;
-
-	hw = &pf->hw;
-	vsi = ice_get_vf_vsi(vf);
+	struct ice_pf *pf;
+	int aq_ret;
 
+	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
-	wr32(hw, VPINT_ALLOC(vf->vf_id), 0);
-	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), 0);
-
-	first = vf->first_vector_idx;
-	last = first + pf->vfs.num_msix_per - 1;
-	for (v = first; v <= last; v++) {
-		u32 reg;
 
-		reg = (((1 << GLINT_VECT2FUNC_IS_PF_S) &
-			GLINT_VECT2FUNC_IS_PF_M) |
-		       ((hw->pf_id << GLINT_VECT2FUNC_PF_NUM_S) &
-			GLINT_VECT2FUNC_PF_NUM_M));
-		wr32(hw, GLINT_VECT2FUNC(v), reg);
+	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
+				       msg, msglen, NULL);
+	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
+		dev_info(dev, "Unable to send the message to VF %d ret %d aq_err %s\n",
+			 vf->vf_id, aq_ret,
+			 ice_aq_str(pf->hw.mailboxq.sq_last_status));
+		return -EIO;
 	}
 
-	if (vsi->tx_mapping_mode == ICE_VSI_MAP_CONTIG)
-		wr32(hw, VPLAN_TX_QBASE(vf->vf_id), 0);
-	else
-		dev_err(dev, "Scattered mode for VF Tx queues is not yet implemented\n");
-
-	if (vsi->rx_mapping_mode == ICE_VSI_MAP_CONTIG)
-		wr32(hw, VPLAN_RX_QBASE(vf->vf_id), 0);
-	else
-		dev_err(dev, "Scattered mode for VF Rx queues is not yet implemented\n");
+	return 0;
 }
 
 /**
- * ice_sriov_free_msix_res - Reset/free any used MSIX resources
- * @pf: pointer to the PF structure
- *
- * Since no MSIX entries are taken from the pf->irq_tracker then just clear
- * the pf->sriov_base_vector.
+ * ice_vc_get_ver_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
  *
- * Returns 0 on success, and -EINVAL on error.
+ * called from the VF to request the API version used by the PF
  */
-static int ice_sriov_free_msix_res(struct ice_pf *pf)
+static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_res_tracker *res;
+	struct virtchnl_version_info info = {
+		VIRTCHNL_VERSION_MAJOR, VIRTCHNL_VERSION_MINOR
+	};
 
-	if (!pf)
-		return -EINVAL;
+	vf->vf_ver = *(struct virtchnl_version_info *)msg;
+	/* VFs running the 1.0 API expect to get 1.0 back or they will cry. */
+	if (VF_IS_V10(&vf->vf_ver))
+		info.minor = VIRTCHNL_VERSION_MINOR_NO_VF_CAPS;
 
-	res = pf->irq_tracker;
-	if (!res)
-		return -EINVAL;
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_VERSION,
+				     VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
+				     sizeof(struct virtchnl_version_info));
+}
+
+/**
+ * ice_vc_get_max_frame_size - get max frame size allowed for VF
+ * @vf: VF used to determine max frame size
+ *
+ * Max frame size is determined based on the current port's max frame size and
+ * whether a port VLAN is configured on this VF. The VF is not aware whether
+ * it's in a port VLAN so the PF needs to account for this in max frame size
+ * checks and sending the max frame size to the VF.
+ */
+static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
+{
+	struct ice_port_info *pi = ice_vf_get_port_info(vf);
+	u16 max_frame_size;
 
-	/* give back irq_tracker resources used */
-	WARN_ON(pf->sriov_base_vector < res->num_entries);
+	max_frame_size = pi->phy.link_info.max_frame_size;
 
-	pf->sriov_base_vector = 0;
+	if (ice_vf_is_port_vlan_ena(vf))
+		max_frame_size -= VLAN_HLEN;
 
-	return 0;
+	return max_frame_size;
 }
 
 /**
- * ice_free_vfs - Free all VFs
- * @pf: pointer to the PF structure
+ * ice_vc_get_vf_res_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
+ *
+ * called from the VF to request its resources
  */
-void ice_free_vfs(struct ice_pf *pf)
+static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_vfs *vfs = &pf->vfs;
-	struct ice_hw *hw = &pf->hw;
-	struct ice_vf *vf;
-	unsigned int bkt;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vf_resource *vfres = NULL;
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
+	int len = 0;
+	int ret;
 
-	if (!ice_has_vfs(pf))
-		return;
+	if (ice_check_vf_init(pf, vf)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err;
+	}
 
-	while (test_and_set_bit(ICE_VF_DIS, pf->state))
-		usleep_range(1000, 2000);
+	len = sizeof(struct virtchnl_vf_resource);
 
-	/* Disable IOV before freeing resources. This lets any VF drivers
-	 * running in the host get themselves cleaned up before we yank
-	 * the carpet out from underneath their feet.
-	 */
-	if (!pci_vfs_assigned(pf->pdev))
-		pci_disable_sriov(pf->pdev);
+	vfres = kzalloc(len, GFP_KERNEL);
+	if (!vfres) {
+		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		len = 0;
+		goto err;
+	}
+	if (VF_IS_V11(&vf->vf_ver))
+		vf->driver_caps = *(u32 *)msg;
 	else
-		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
+		vf->driver_caps = VIRTCHNL_VF_OFFLOAD_L2 |
+				  VIRTCHNL_VF_OFFLOAD_RSS_REG |
+				  VIRTCHNL_VF_OFFLOAD_VLAN;
 
-	mutex_lock(&vfs->table_lock);
+	vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err;
+	}
 
-	ice_eswitch_release(pf);
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN_V2) {
+		/* VLAN offloads based on current device configuration */
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN_V2;
+	} else if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN) {
+		/* allow VF to negotiate VIRTCHNL_VF_OFFLOAD explicitly for
+		 * these two conditions, which amounts to guest VLAN filtering
+		 * and offloads being based on the inner VLAN or the
+		 * inner/single VLAN respectively and don't allow VF to
+		 * negotiate VIRTCHNL_VF_OFFLOAD in any other cases
+		 */
+		if (ice_is_dvm_ena(&pf->hw) && ice_vf_is_port_vlan_ena(vf)) {
+			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
+		} else if (!ice_is_dvm_ena(&pf->hw) &&
+			   !ice_vf_is_port_vlan_ena(vf)) {
+			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
+			/* configure backward compatible support for VFs that
+			 * only support VIRTCHNL_VF_OFFLOAD_VLAN, the PF is
+			 * configured in SVM, and no port VLAN is configured
+			 */
+			ice_vf_vsi_cfg_svm_legacy_vlan_mode(vsi);
+		} else if (ice_is_dvm_ena(&pf->hw)) {
+			/* configure software offloaded VLAN support when DVM
+			 * is enabled, but no port VLAN is enabled
+			 */
+			ice_vf_vsi_cfg_dvm_legacy_vlan_mode(vsi);
+		}
+	}
 
-	ice_for_each_vf(pf, bkt, vf) {
-		mutex_lock(&vf->cfg_lock);
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PF;
+	} else {
+		if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_AQ)
+			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_AQ;
+		else
+			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_REG;
+	}
 
-		ice_dis_vf_qs(vf);
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_FDIR_PF)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_FDIR_PF;
 
-		if (test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-			/* disable VF qp mappings and set VF disable state */
-			ice_dis_vf_mappings(vf);
-			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
-			ice_free_vf_res(vf);
-		}
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2;
 
-		if (!pci_vfs_assigned(pf->pdev)) {
-			u32 reg_idx, bit_idx;
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ENCAP)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ENCAP;
 
-			reg_idx = (hw->func_caps.vf_base_id + vf->vf_id) / 32;
-			bit_idx = (hw->func_caps.vf_base_id + vf->vf_id) % 32;
-			wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
-		}
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM;
 
-		/* clear malicious info since the VF is getting released */
-		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-					ICE_MAX_SRIOV_VFS, vf->vf_id))
-			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
-				vf->vf_id);
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RX_POLLING)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RX_POLLING;
 
-		mutex_unlock(&vf->cfg_lock);
-	}
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_WB_ON_ITR)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_WB_ON_ITR;
 
-	if (ice_sriov_free_msix_res(pf))
-		dev_err(dev, "Failed to free MSIX resources used by SR-IOV\n");
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_REQ_QUEUES)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_REQ_QUEUES;
 
-	vfs->num_qps_per = 0;
-	ice_free_vf_entries(pf);
+	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
-	mutex_unlock(&vfs->table_lock);
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF;
 
-	clear_bit(ICE_VF_DIS, pf->state);
-	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
-}
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_USO;
 
-/**
- * ice_vf_vsi_setup - Set up a VF VSI
- * @vf: VF to setup VSI for
- *
- * Returns pointer to the successfully allocated VSI struct on success,
- * otherwise returns NULL on failure.
- */
-static struct ice_vsi *ice_vf_vsi_setup(struct ice_vf *vf)
-{
-	struct ice_port_info *pi = ice_vf_get_port_info(vf);
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
+	vfres->num_vsis = 1;
+	/* Tx and Rx queue are equal for VF */
+	vfres->num_queue_pairs = vsi->num_txq;
+	vfres->max_vectors = pf->vfs.num_msix_per;
+	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
+	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
+	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
+
+	vfres->vsi_res[0].vsi_id = vf->lan_vsi_num;
+	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
+	vfres->vsi_res[0].num_queue_pairs = vsi->num_txq;
+	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
+			vf->hw_lan_addr.addr);
 
-	vsi = ice_vsi_setup(pf, pi, ICE_VSI_VF, vf, NULL);
+	/* match guest capabilities */
+	vf->driver_caps = vfres->vf_cap_flags;
 
-	if (!vsi) {
-		dev_err(ice_pf_to_dev(pf), "Failed to create VF VSI\n");
-		ice_vf_invalidate_vsi(vf);
-		return NULL;
-	}
+	ice_vc_set_caps_allowlist(vf);
+	ice_vc_set_working_allowlist(vf);
 
-	vf->lan_vsi_idx = vsi->idx;
-	vf->lan_vsi_num = vsi->vsi_num;
+	set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
+
+err:
+	/* send the response back to the VF */
+	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
+				    (u8 *)vfres, len);
 
-	return vsi;
+	kfree(vfres);
+	return ret;
 }
 
 /**
- * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the PF space
- * @pf: pointer to PF structure
- * @vf: pointer to VF that the first MSIX vector index is being calculated for
+ * ice_vc_reset_vf_msg
+ * @vf: pointer to the VF info
  *
- * This returns the first MSIX vector index in PF space that is used by this VF.
- * This index is used when accessing PF relative registers such as
- * GLINT_VECT2FUNC and GLINT_DYN_CTL.
- * This will always be the OICR index in the AVF driver so any functionality
- * using vf->first_vector_idx for queue configuration will have to increment by
- * 1 to avoid meddling with the OICR index.
+ * called from the VF to reset itself,
+ * unlike other virtchnl messages, PF driver
+ * doesn't send the response back to the VF
  */
-static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
+static void ice_vc_reset_vf_msg(struct ice_vf *vf)
 {
-	return pf->sriov_base_vector + vf->vf_id * pf->vfs.num_msix_per;
+	if (test_bit(ICE_VF_STATE_INIT, vf->vf_states))
+		ice_reset_vf(vf, 0);
 }
 
 /**
- * ice_ena_vf_msix_mappings - enable VF MSIX mappings in hardware
- * @vf: VF to enable MSIX mappings for
+ * ice_find_vsi_from_id
+ * @pf: the PF structure to search for the VSI
+ * @id: ID of the VSI it is searching for
  *
- * Some of the registers need to be indexed/configured using hardware global
- * device values and other registers need 0-based values, which represent PF
- * based values.
+ * searches for the VSI with the given ID
  */
-static void ice_ena_vf_msix_mappings(struct ice_vf *vf)
+static struct ice_vsi *ice_find_vsi_from_id(struct ice_pf *pf, u16 id)
 {
-	int device_based_first_msix, device_based_last_msix;
-	int pf_based_first_msix, pf_based_last_msix, v;
-	struct ice_pf *pf = vf->pf;
-	int device_based_vf_id;
-	struct ice_hw *hw;
-	u32 reg;
+	int i;
 
-	hw = &pf->hw;
-	pf_based_first_msix = vf->first_vector_idx;
-	pf_based_last_msix = (pf_based_first_msix + pf->vfs.num_msix_per) - 1;
-
-	device_based_first_msix = pf_based_first_msix +
-		pf->hw.func_caps.common_cap.msix_vector_first_id;
-	device_based_last_msix =
-		(device_based_first_msix + pf->vfs.num_msix_per) - 1;
-	device_based_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
-
-	reg = (((device_based_first_msix << VPINT_ALLOC_FIRST_S) &
-		VPINT_ALLOC_FIRST_M) |
-	       ((device_based_last_msix << VPINT_ALLOC_LAST_S) &
-		VPINT_ALLOC_LAST_M) | VPINT_ALLOC_VALID_M);
-	wr32(hw, VPINT_ALLOC(vf->vf_id), reg);
-
-	reg = (((device_based_first_msix << VPINT_ALLOC_PCI_FIRST_S)
-		 & VPINT_ALLOC_PCI_FIRST_M) |
-	       ((device_based_last_msix << VPINT_ALLOC_PCI_LAST_S) &
-		VPINT_ALLOC_PCI_LAST_M) | VPINT_ALLOC_PCI_VALID_M);
-	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), reg);
-
-	/* map the interrupts to its functions */
-	for (v = pf_based_first_msix; v <= pf_based_last_msix; v++) {
-		reg = (((device_based_vf_id << GLINT_VECT2FUNC_VF_NUM_S) &
-			GLINT_VECT2FUNC_VF_NUM_M) |
-		       ((hw->pf_id << GLINT_VECT2FUNC_PF_NUM_S) &
-			GLINT_VECT2FUNC_PF_NUM_M));
-		wr32(hw, GLINT_VECT2FUNC(v), reg);
-	}
-
-	/* Map mailbox interrupt to VF MSI-X vector 0 */
-	wr32(hw, VPINT_MBX_CTL(device_based_vf_id), VPINT_MBX_CTL_CAUSE_ENA_M);
+	ice_for_each_vsi(pf, i)
+		if (pf->vsi[i] && pf->vsi[i]->vsi_num == id)
+			return pf->vsi[i];
+
+	return NULL;
 }
 
 /**
- * ice_ena_vf_q_mappings - enable Rx/Tx queue mappings for a VF
- * @vf: VF to enable the mappings for
- * @max_txq: max Tx queues allowed on the VF's VSI
- * @max_rxq: max Rx queues allowed on the VF's VSI
+ * ice_vc_isvalid_vsi_id
+ * @vf: pointer to the VF info
+ * @vsi_id: VF relative VSI ID
+ *
+ * check for the valid VSI ID
  */
-static void ice_ena_vf_q_mappings(struct ice_vf *vf, u16 max_txq, u16 max_rxq)
+bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 {
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-	struct ice_hw *hw = &vf->pf->hw;
-	u32 reg;
-
-	/* set regardless of mapping mode */
-	wr32(hw, VPLAN_TXQ_MAPENA(vf->vf_id), VPLAN_TXQ_MAPENA_TX_ENA_M);
-
-	/* VF Tx queues allocation */
-	if (vsi->tx_mapping_mode == ICE_VSI_MAP_CONTIG) {
-		/* set the VF PF Tx queue range
-		 * VFNUMQ value should be set to (number of queues - 1). A value
-		 * of 0 means 1 queue and a value of 255 means 256 queues
-		 */
-		reg = (((vsi->txq_map[0] << VPLAN_TX_QBASE_VFFIRSTQ_S) &
-			VPLAN_TX_QBASE_VFFIRSTQ_M) |
-		       (((max_txq - 1) << VPLAN_TX_QBASE_VFNUMQ_S) &
-			VPLAN_TX_QBASE_VFNUMQ_M));
-		wr32(hw, VPLAN_TX_QBASE(vf->vf_id), reg);
-	} else {
-		dev_err(dev, "Scattered mode for VF Tx queues is not yet implemented\n");
-	}
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
 
-	/* set regardless of mapping mode */
-	wr32(hw, VPLAN_RXQ_MAPENA(vf->vf_id), VPLAN_RXQ_MAPENA_RX_ENA_M);
+	vsi = ice_find_vsi_from_id(pf, vsi_id);
 
-	/* VF Rx queues allocation */
-	if (vsi->rx_mapping_mode == ICE_VSI_MAP_CONTIG) {
-		/* set the VF PF Rx queue range
-		 * VFNUMQ value should be set to (number of queues - 1). A value
-		 * of 0 means 1 queue and a value of 255 means 256 queues
-		 */
-		reg = (((vsi->rxq_map[0] << VPLAN_RX_QBASE_VFFIRSTQ_S) &
-			VPLAN_RX_QBASE_VFFIRSTQ_M) |
-		       (((max_rxq - 1) << VPLAN_RX_QBASE_VFNUMQ_S) &
-			VPLAN_RX_QBASE_VFNUMQ_M));
-		wr32(hw, VPLAN_RX_QBASE(vf->vf_id), reg);
-	} else {
-		dev_err(dev, "Scattered mode for VF Rx queues is not yet implemented\n");
-	}
+	return (vsi && (vsi->vf == vf));
 }
 
 /**
- * ice_ena_vf_mappings - enable VF MSIX and queue mapping
- * @vf: pointer to the VF structure
+ * ice_vc_isvalid_q_id
+ * @vf: pointer to the VF info
+ * @vsi_id: VSI ID
+ * @qid: VSI relative queue ID
+ *
+ * check for the valid queue ID
  */
-static void ice_ena_vf_mappings(struct ice_vf *vf)
+static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
 {
-	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-
-	ice_ena_vf_msix_mappings(vf);
-	ice_ena_vf_q_mappings(vf, vsi->alloc_txq, vsi->alloc_rxq);
+	struct ice_vsi *vsi = ice_find_vsi_from_id(vf->pf, vsi_id);
+	/* allocated Tx and Rx queues should be always equal for VF VSI */
+	return (vsi && (qid < vsi->alloc_txq));
 }
 
 /**
- * ice_calc_vf_reg_idx - Calculate the VF's register index in the PF space
- * @vf: VF to calculate the register index for
- * @q_vector: a q_vector associated to the VF
+ * ice_vc_isvalid_ring_len
+ * @ring_len: length of ring
+ *
+ * check for the valid ring count, should be multiple of ICE_REQ_DESC_MULTIPLE
+ * or zero
  */
-int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector)
+static bool ice_vc_isvalid_ring_len(u16 ring_len)
 {
-	struct ice_pf *pf;
-
-	if (!vf || !q_vector)
-		return -EINVAL;
-
-	pf = vf->pf;
-
-	/* always add one to account for the OICR being the first MSIX */
-	return pf->sriov_base_vector + pf->vfs.num_msix_per * vf->vf_id +
-		q_vector->v_idx + 1;
+	return ring_len == 0 ||
+	       (ring_len >= ICE_MIN_NUM_DESC &&
+		ring_len <= ICE_MAX_NUM_DESC &&
+		!(ring_len % ICE_REQ_DESC_MULTIPLE));
 }
 
 /**
- * ice_get_max_valid_res_idx - Get the max valid resource index
- * @res: pointer to the resource to find the max valid index for
+ * ice_vc_validate_pattern
+ * @vf: pointer to the VF info
+ * @proto: virtchnl protocol headers
+ *
+ * validate the pattern is supported or not.
  *
- * Start from the end of the ice_res_tracker and return right when we find the
- * first res->list entry with the ICE_RES_VALID_BIT set. This function is only
- * valid for SR-IOV because it is the only consumer that manipulates the
- * res->end and this is always called when res->end is set to res->num_entries.
+ * Return: true on success, false on error.
  */
-static int ice_get_max_valid_res_idx(struct ice_res_tracker *res)
+bool
+ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto)
 {
-	int i;
-
-	if (!res)
-		return -EINVAL;
+	bool is_ipv4 = false;
+	bool is_ipv6 = false;
+	bool is_udp = false;
+	u16 ptype = -1;
+	int i = 0;
 
-	for (i = res->num_entries - 1; i >= 0; i--)
-		if (res->list[i] & ICE_RES_VALID_BIT)
-			return i;
+	while (i < proto->count &&
+	       proto->proto_hdr[i].type != VIRTCHNL_PROTO_HDR_NONE) {
+		switch (proto->proto_hdr[i].type) {
+		case VIRTCHNL_PROTO_HDR_ETH:
+			ptype = ICE_PTYPE_MAC_PAY;
+			break;
+		case VIRTCHNL_PROTO_HDR_IPV4:
+			ptype = ICE_PTYPE_IPV4_PAY;
+			is_ipv4 = true;
+			break;
+		case VIRTCHNL_PROTO_HDR_IPV6:
+			ptype = ICE_PTYPE_IPV6_PAY;
+			is_ipv6 = true;
+			break;
+		case VIRTCHNL_PROTO_HDR_UDP:
+			if (is_ipv4)
+				ptype = ICE_PTYPE_IPV4_UDP_PAY;
+			else if (is_ipv6)
+				ptype = ICE_PTYPE_IPV6_UDP_PAY;
+			is_udp = true;
+			break;
+		case VIRTCHNL_PROTO_HDR_TCP:
+			if (is_ipv4)
+				ptype = ICE_PTYPE_IPV4_TCP_PAY;
+			else if (is_ipv6)
+				ptype = ICE_PTYPE_IPV6_TCP_PAY;
+			break;
+		case VIRTCHNL_PROTO_HDR_SCTP:
+			if (is_ipv4)
+				ptype = ICE_PTYPE_IPV4_SCTP_PAY;
+			else if (is_ipv6)
+				ptype = ICE_PTYPE_IPV6_SCTP_PAY;
+			break;
+		case VIRTCHNL_PROTO_HDR_GTPU_IP:
+		case VIRTCHNL_PROTO_HDR_GTPU_EH:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_GTPU;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_GTPU;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_L2TPV3:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_L2TPV3;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_L2TPV3;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_ESP:
+			if (is_ipv4)
+				ptype = is_udp ? ICE_MAC_IPV4_NAT_T_ESP :
+						ICE_MAC_IPV4_ESP;
+			else if (is_ipv6)
+				ptype = is_udp ? ICE_MAC_IPV6_NAT_T_ESP :
+						ICE_MAC_IPV6_ESP;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_AH:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_AH;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_AH;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_PFCP:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_PFCP_SESSION;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_PFCP_SESSION;
+			goto out;
+		default:
+			break;
+		}
+		i++;
+	}
 
-	return 0;
+out:
+	return ice_hw_ptype_ena(&vf->pf->hw, ptype);
 }
 
 /**
- * ice_sriov_set_msix_res - Set any used MSIX resources
- * @pf: pointer to PF structure
- * @num_msix_needed: number of MSIX vectors needed for all SR-IOV VFs
- *
- * This function allows SR-IOV resources to be taken from the end of the PF's
- * allowed HW MSIX vectors so that the irq_tracker will not be affected. We
- * just set the pf->sriov_base_vector and return success.
+ * ice_vc_parse_rss_cfg - parses hash fields and headers from
+ * a specific virtchnl RSS cfg
+ * @hw: pointer to the hardware
+ * @rss_cfg: pointer to the virtchnl RSS cfg
+ * @addl_hdrs: pointer to the protocol header fields (ICE_FLOW_SEG_HDR_*)
+ * to configure
+ * @hash_flds: pointer to the hash bit fields (ICE_FLOW_HASH_*) to configure
  *
- * If there are not enough resources available, return an error. This should
- * always be caught by ice_set_per_vf_res().
+ * Return true if all the protocol header and hash fields in the RSS cfg could
+ * be parsed, else return false
  *
- * Return 0 on success, and -EINVAL when there are not enough MSIX vectors
- * in the PF's space available for SR-IOV.
+ * This function parses the virtchnl RSS cfg to be the intended
+ * hash fields and the intended header for RSS configuration
  */
-static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
+static bool
+ice_vc_parse_rss_cfg(struct ice_hw *hw, struct virtchnl_rss_cfg *rss_cfg,
+		     u32 *addl_hdrs, u64 *hash_flds)
 {
-	u16 total_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
-	int vectors_used = pf->irq_tracker->num_entries;
-	int sriov_base_vector;
-
-	sriov_base_vector = total_vectors - num_msix_needed;
+	const struct ice_vc_hash_field_match_type *hf_list;
+	const struct ice_vc_hdr_match_type *hdr_list;
+	int i, hf_list_len, hdr_list_len;
 
-	/* make sure we only grab irq_tracker entries from the list end and
-	 * that we have enough available MSIX vectors
-	 */
-	if (sriov_base_vector < vectors_used)
-		return -EINVAL;
+	hf_list = ice_vc_hash_field_list;
+	hf_list_len = ARRAY_SIZE(ice_vc_hash_field_list);
+	hdr_list = ice_vc_hdr_list;
+	hdr_list_len = ARRAY_SIZE(ice_vc_hdr_list);
 
-	pf->sriov_base_vector = sriov_base_vector;
+	for (i = 0; i < rss_cfg->proto_hdrs.count; i++) {
+		struct virtchnl_proto_hdr *proto_hdr =
+					&rss_cfg->proto_hdrs.proto_hdr[i];
+		bool hdr_found = false;
+		int j;
 
-	return 0;
-}
+		/* Find matched ice headers according to virtchnl headers. */
+		for (j = 0; j < hdr_list_len; j++) {
+			struct ice_vc_hdr_match_type hdr_map = hdr_list[j];
 
-/**
- * ice_set_per_vf_res - check if vectors and queues are available
- * @pf: pointer to the PF structure
- * @num_vfs: the number of SR-IOV VFs being configured
- *
- * First, determine HW interrupts from common pool. If we allocate fewer VFs, we
- * get more vectors and can enable more queues per VF. Note that this does not
- * grab any vectors from the SW pool already allocated. Also note, that all
- * vector counts include one for each VF's miscellaneous interrupt vector
- * (i.e. OICR).
- *
- * Minimum VFs - 2 vectors, 1 queue pair
- * Small VFs - 5 vectors, 4 queue pairs
- * Medium VFs - 17 vectors, 16 queue pairs
- *
- * Second, determine number of queue pairs per VF by starting with a pre-defined
- * maximum each VF supports. If this is not possible, then we adjust based on
- * queue pairs available on the device.
- *
- * Lastly, set queue and MSI-X VF variables tracked by the PF so it can be used
- * by each VF during VF initialization and reset.
- */
-static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
-{
-	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
-	u16 num_msix_per_vf, num_txq, num_rxq, avail_qs;
-	int msix_avail_per_vf, msix_avail_for_sriov;
-	struct device *dev = ice_pf_to_dev(pf);
-	int err;
+			if (proto_hdr->type == hdr_map.vc_hdr) {
+				*addl_hdrs |= hdr_map.ice_hdr;
+				hdr_found = true;
+			}
+		}
 
-	lockdep_assert_held(&pf->vfs.table_lock);
+		if (!hdr_found)
+			return false;
 
-	if (!num_vfs)
-		return -EINVAL;
+		/* Find matched ice hash fields according to
+		 * virtchnl hash fields.
+		 */
+		for (j = 0; j < hf_list_len; j++) {
+			struct ice_vc_hash_field_match_type hf_map = hf_list[j];
 
-	if (max_valid_res_idx < 0)
-		return -ENOSPC;
-
-	/* determine MSI-X resources per VF */
-	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
-		pf->irq_tracker->num_entries;
-	msix_avail_per_vf = msix_avail_for_sriov / num_vfs;
-	if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MED) {
-		num_msix_per_vf = ICE_NUM_VF_MSIX_MED;
-	} else if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_SMALL) {
-		num_msix_per_vf = ICE_NUM_VF_MSIX_SMALL;
-	} else if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MULTIQ_MIN) {
-		num_msix_per_vf = ICE_NUM_VF_MSIX_MULTIQ_MIN;
-	} else if (msix_avail_per_vf >= ICE_MIN_INTR_PER_VF) {
-		num_msix_per_vf = ICE_MIN_INTR_PER_VF;
-	} else {
-		dev_err(dev, "Only %d MSI-X interrupts available for SR-IOV. Not enough to support minimum of %d MSI-X interrupts per VF for %d VFs\n",
-			msix_avail_for_sriov, ICE_MIN_INTR_PER_VF,
-			num_vfs);
-		return -ENOSPC;
-	}
-
-	num_txq = min_t(u16, num_msix_per_vf - ICE_NONQ_VECS_VF,
-			ICE_MAX_RSS_QS_PER_VF);
-	avail_qs = ice_get_avail_txq_count(pf) / num_vfs;
-	if (!avail_qs)
-		num_txq = 0;
-	else if (num_txq > avail_qs)
-		num_txq = rounddown_pow_of_two(avail_qs);
-
-	num_rxq = min_t(u16, num_msix_per_vf - ICE_NONQ_VECS_VF,
-			ICE_MAX_RSS_QS_PER_VF);
-	avail_qs = ice_get_avail_rxq_count(pf) / num_vfs;
-	if (!avail_qs)
-		num_rxq = 0;
-	else if (num_rxq > avail_qs)
-		num_rxq = rounddown_pow_of_two(avail_qs);
-
-	if (num_txq < ICE_MIN_QS_PER_VF || num_rxq < ICE_MIN_QS_PER_VF) {
-		dev_err(dev, "Not enough queues to support minimum of %d queue pairs per VF for %d VFs\n",
-			ICE_MIN_QS_PER_VF, num_vfs);
-		return -ENOSPC;
-	}
-
-	err = ice_sriov_set_msix_res(pf, num_msix_per_vf * num_vfs);
-	if (err) {
-		dev_err(dev, "Unable to set MSI-X resources for %d VFs, err %d\n",
-			num_vfs, err);
-		return err;
+			if (proto_hdr->type == hf_map.vc_hdr &&
+			    proto_hdr->field_selector == hf_map.vc_hash_field) {
+				*hash_flds |= hf_map.ice_hash_field;
+				break;
+			}
+		}
 	}
 
-	/* only allow equal Tx/Rx queue count (i.e. queue pairs) */
-	pf->vfs.num_qps_per = min_t(int, num_txq, num_rxq);
-	pf->vfs.num_msix_per = num_msix_per_vf;
-	dev_info(dev, "Enabling %d VFs with %d vectors and %d queues per VF\n",
-		 num_vfs, pf->vfs.num_msix_per, pf->vfs.num_qps_per);
-
-	return 0;
+	return true;
 }
 
 /**
- * ice_vc_notify_link_state - Inform all VFs on a PF of link status
- * @pf: pointer to the PF structure
+ * ice_vf_adv_rss_offload_ena - determine if capabilities support advanced
+ * RSS offloads
+ * @caps: VF driver negotiated capabilities
+ *
+ * Return true if VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF capability is set,
+ * else return false
  */
-void ice_vc_notify_link_state(struct ice_pf *pf)
+static bool ice_vf_adv_rss_offload_ena(u32 caps)
 {
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	mutex_lock(&pf->vfs.table_lock);
-	ice_for_each_vf(pf, bkt, vf)
-		ice_vc_notify_vf_link_state(vf);
-	mutex_unlock(&pf->vfs.table_lock);
+	return !!(caps & VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF);
 }
 
 /**
- * ice_vc_notify_reset - Send pending reset message to all VFs
- * @pf: pointer to the PF structure
+ * ice_vc_handle_rss_cfg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the message buffer
+ * @add: add a RSS config if true, otherwise delete a RSS config
  *
- * indicate a pending reset to all VFs on a given PF
- */
-void ice_vc_notify_reset(struct ice_pf *pf)
-{
-	struct virtchnl_pf_event pfe;
-
-	if (!ice_has_vfs(pf))
-		return;
-
-	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
-	pfe.severity = PF_EVENT_SEVERITY_CERTAIN_DOOM;
-	ice_vc_vf_broadcast(pf, VIRTCHNL_OP_EVENT, VIRTCHNL_STATUS_SUCCESS,
-			    (u8 *)&pfe, sizeof(struct virtchnl_pf_event));
-}
-
-/**
- * ice_init_vf_vsi_res - initialize/setup VF VSI resources
- * @vf: VF to initialize/setup the VSI for
- *
- * This function creates a VSI for the VF, adds a VLAN 0 filter, and sets up the
- * VF VSI's broadcast filter and is only used during initial VF creation.
+ * This function adds/deletes a RSS config
  */
-static int ice_init_vf_vsi_res(struct ice_vf *vf)
+static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
 {
-	struct ice_vsi_vlan_ops *vlan_ops;
-	struct ice_pf *pf = vf->pf;
-	u8 broadcast[ETH_ALEN];
+	u32 v_opcode = add ? VIRTCHNL_OP_ADD_RSS_CFG : VIRTCHNL_OP_DEL_RSS_CFG;
+	struct virtchnl_rss_cfg *rss_cfg = (struct virtchnl_rss_cfg *)msg;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
 	struct ice_vsi *vsi;
-	struct device *dev;
-	int err;
 
-	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
+	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
+		dev_dbg(dev, "VF %d attempting to configure RSS, but RSS is not supported by the PF\n",
+			vf->vf_id);
+		v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
+		goto error_param;
+	}
 
-	dev = ice_pf_to_dev(pf);
-	vsi = ice_vf_vsi_setup(vf);
-	if (!vsi)
-		return -ENOMEM;
+	if (!ice_vf_adv_rss_offload_ena(vf->driver_caps)) {
+		dev_dbg(dev, "VF %d attempting to configure RSS, but Advanced RSS offload is not supported\n",
+			vf->vf_id);
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	err = ice_vsi_add_vlan_zero(vsi);
-	if (err) {
-		dev_warn(dev, "Failed to add VLAN 0 filter for VF %d\n",
-			 vf->vf_id);
-		goto release_vsi;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
-	err = vlan_ops->ena_rx_filtering(vsi);
-	if (err) {
-		dev_warn(dev, "Failed to enable Rx VLAN filtering for VF %d\n",
-			 vf->vf_id);
-		goto release_vsi;
+	if (rss_cfg->proto_hdrs.count > VIRTCHNL_MAX_NUM_PROTO_HDRS ||
+	    rss_cfg->rss_algorithm < VIRTCHNL_RSS_ALG_TOEPLITZ_ASYMMETRIC ||
+	    rss_cfg->rss_algorithm > VIRTCHNL_RSS_ALG_XOR_SYMMETRIC) {
+		dev_dbg(dev, "VF %d attempting to configure RSS, but RSS configuration is not valid\n",
+			vf->vf_id);
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	eth_broadcast_addr(broadcast);
-	err = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
-	if (err) {
-		dev_err(dev, "Failed to add broadcast MAC filter for VF %d, error %d\n",
-			vf->vf_id, err);
-		goto release_vsi;
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	err = ice_vsi_apply_spoofchk(vsi, vf->spoofchk);
-	if (err) {
-		dev_warn(dev, "Failed to initialize spoofchk setting for VF %d\n",
-			 vf->vf_id);
-		goto release_vsi;
+	if (!ice_vc_validate_pattern(vf, &rss_cfg->proto_hdrs)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	vf->num_mac = 1;
+	if (rss_cfg->rss_algorithm == VIRTCHNL_RSS_ALG_R_ASYMMETRIC) {
+		struct ice_vsi_ctx *ctx;
+		u8 lut_type, hash_type;
+		int status;
 
-	return 0;
+		lut_type = ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI;
+		hash_type = add ? ICE_AQ_VSI_Q_OPT_RSS_XOR :
+				ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
 
-release_vsi:
-	ice_vf_vsi_release(vf);
-	return err;
-}
+		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+		if (!ctx) {
+			v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+			goto error_param;
+		}
 
-/**
- * ice_start_vfs - start VFs so they are ready to be used by SR-IOV
- * @pf: PF the VFs are associated with
- */
-static int ice_start_vfs(struct ice_pf *pf)
-{
-	struct ice_hw *hw = &pf->hw;
-	unsigned int bkt, it_cnt;
-	struct ice_vf *vf;
-	int retval;
+		ctx->info.q_opt_rss = ((lut_type <<
+					ICE_AQ_VSI_Q_OPT_RSS_LUT_S) &
+				       ICE_AQ_VSI_Q_OPT_RSS_LUT_M) |
+				       (hash_type &
+					ICE_AQ_VSI_Q_OPT_RSS_HASH_M);
 
-	lockdep_assert_held(&pf->vfs.table_lock);
+		/* Preserve existing queueing option setting */
+		ctx->info.q_opt_rss |= (vsi->info.q_opt_rss &
+					  ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_M);
+		ctx->info.q_opt_tc = vsi->info.q_opt_tc;
+		ctx->info.q_opt_flags = vsi->info.q_opt_rss;
 
-	it_cnt = 0;
-	ice_for_each_vf(pf, bkt, vf) {
-		vf->vf_ops->clear_reset_trigger(vf);
+		ctx->info.valid_sections =
+				cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
 
-		retval = ice_init_vf_vsi_res(vf);
-		if (retval) {
-			dev_err(ice_pf_to_dev(pf), "Failed to initialize VSI resources for VF %d, error %d\n",
-				vf->vf_id, retval);
-			goto teardown;
+		status = ice_update_vsi(hw, vsi->idx, ctx, NULL);
+		if (status) {
+			dev_err(dev, "update VSI for RSS failed, err %d aq_err %s\n",
+				status, ice_aq_str(hw->adminq.sq_last_status));
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		} else {
+			vsi->info.q_opt_rss = ctx->info.q_opt_rss;
 		}
 
-		set_bit(ICE_VF_STATE_INIT, vf->vf_states);
-		ice_ena_vf_mappings(vf);
-		wr32(hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_VFACTIVE);
-		it_cnt++;
-	}
+		kfree(ctx);
+	} else {
+		u32 addl_hdrs = ICE_FLOW_SEG_HDR_NONE;
+		u64 hash_flds = ICE_HASH_INVALID;
 
-	ice_flush(hw);
-	return 0;
+		if (!ice_vc_parse_rss_cfg(hw, rss_cfg, &addl_hdrs,
+					  &hash_flds)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
-teardown:
-	ice_for_each_vf(pf, bkt, vf) {
-		if (it_cnt == 0)
-			break;
+		if (add) {
+			if (ice_add_rss_cfg(hw, vsi->idx, hash_flds,
+					    addl_hdrs)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_err(dev, "ice_add_rss_cfg failed for vsi = %d, v_ret = %d\n",
+					vsi->vsi_num, v_ret);
+			}
+		} else {
+			int status;
 
-		ice_dis_vf_mappings(vf);
-		ice_vf_vsi_release(vf);
-		it_cnt--;
+			status = ice_rem_rss_cfg(hw, vsi->idx, hash_flds,
+						 addl_hdrs);
+			/* We just ignore -ENOENT, because if two configurations
+			 * share the same profile remove one of them actually
+			 * removes both, since the profile is deleted.
+			 */
+			if (status && status != -ENOENT) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_err(dev, "ice_rem_rss_cfg failed for VF ID:%d, error:%d\n",
+					vf->vf_id, status);
+			}
+		}
 	}
 
-	return retval;
+error_param:
+	return ice_vc_send_msg_to_vf(vf, v_opcode, v_ret, NULL, 0);
 }
 
 /**
- * ice_sriov_free_vf - Free VF memory after all references are dropped
- * @vf: pointer to VF to free
+ * ice_vc_config_rss_key
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
  *
- * Called by ice_put_vf through ice_release_vf once the last reference to a VF
- * structure has been dropped.
- */
-static void ice_sriov_free_vf(struct ice_vf *vf)
-{
-	mutex_destroy(&vf->cfg_lock);
-
-	kfree_rcu(vf, rcu);
-}
-
-/**
- * ice_sriov_clear_mbx_register - clears SRIOV VF's mailbox registers
- * @vf: the vf to configure
+ * Configure the VF's RSS key
  */
-static void ice_sriov_clear_mbx_register(struct ice_vf *vf)
+static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_pf *pf = vf->pf;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_rss_key *vrk =
+		(struct virtchnl_rss_key *)msg;
+	struct ice_vsi *vsi;
 
-	wr32(&pf->hw, VF_MBX_ARQLEN(vf->vf_id), 0);
-	wr32(&pf->hw, VF_MBX_ATQLEN(vf->vf_id), 0);
-}
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-/**
- * ice_sriov_trigger_reset_register - trigger VF reset for SRIOV VF
- * @vf: pointer to VF structure
- * @is_vflr: true if reset occurred due to VFLR
- *
- * Trigger and cleanup after a VF reset for a SR-IOV VF.
- */
-static void ice_sriov_trigger_reset_register(struct ice_vf *vf, bool is_vflr)
-{
-	struct ice_pf *pf = vf->pf;
-	u32 reg, reg_idx, bit_idx;
-	unsigned int vf_abs_id, i;
-	struct device *dev;
-	struct ice_hw *hw;
+	if (!ice_vc_isvalid_vsi_id(vf, vrk->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	dev = ice_pf_to_dev(pf);
-	hw = &pf->hw;
-	vf_abs_id = vf->vf_id + hw->func_caps.vf_base_id;
+	if (vrk->key_len != ICE_VSIQF_HKEY_ARRAY_SIZE) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	/* In the case of a VFLR, HW has already reset the VF and we just need
-	 * to clean up. Otherwise we must first trigger the reset using the
-	 * VFRTRIG register.
-	 */
-	if (!is_vflr) {
-		reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
-		reg |= VPGEN_VFRTRIG_VFSWR_M;
-		wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
-	}
-
-	/* clear the VFLR bit in GLGEN_VFLRSTAT */
-	reg_idx = (vf_abs_id) / 32;
-	bit_idx = (vf_abs_id) % 32;
-	wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
-	ice_flush(hw);
-
-	wr32(hw, PF_PCI_CIAA,
-	     VF_DEVICE_STATUS | (vf_abs_id << PF_PCI_CIAA_VF_NUM_S));
-	for (i = 0; i < ICE_PCI_CIAD_WAIT_COUNT; i++) {
-		reg = rd32(hw, PF_PCI_CIAD);
-		/* no transactions pending so stop polling */
-		if ((reg & VF_TRANS_PENDING_M) == 0)
-			break;
+	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-		dev_err(dev, "VF %u PCI transactions stuck\n", vf->vf_id);
-		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
+
+	if (ice_set_rss_key(vsi, vrk->key))
+		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+error_param:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
+				     NULL, 0);
 }
 
 /**
- * ice_sriov_poll_reset_status - poll SRIOV VF reset status
- * @vf: pointer to VF structure
+ * ice_vc_config_rss_lut
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
  *
- * Returns true when reset is successful, else returns false
+ * Configure the VF's RSS LUT
  */
-static bool ice_sriov_poll_reset_status(struct ice_vf *vf)
+static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_pf *pf = vf->pf;
-	unsigned int i;
-	u32 reg;
-
-	for (i = 0; i < 10; i++) {
-		/* VF reset requires driver to first reset the VF and then
-		 * poll the status register to make sure that the reset
-		 * completed successfully.
-		 */
-		reg = rd32(&pf->hw, VPGEN_VFRSTAT(vf->vf_id));
-		if (reg & VPGEN_VFRSTAT_VFRD_M)
-			return true;
+	struct virtchnl_rss_lut *vrl = (struct virtchnl_rss_lut *)msg;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_vsi *vsi;
 
-		/* only sleep if the reset is not done */
-		usleep_range(10, 20);
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
-	return false;
-}
 
-/**
- * ice_sriov_clear_reset_trigger - enable VF to access hardware
- * @vf: VF to enabled hardware access for
- */
-static void ice_sriov_clear_reset_trigger(struct ice_vf *vf)
-{
-	struct ice_hw *hw = &vf->pf->hw;
-	u32 reg;
+	if (!ice_vc_isvalid_vsi_id(vf, vrl->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
-	reg &= ~VPGEN_VFRTRIG_VFSWR_M;
-	wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
-	ice_flush(hw);
-}
+	if (vrl->lut_entries != ICE_VSIQF_HLUT_ARRAY_SIZE) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-/**
- * ice_sriov_vsi_rebuild - release and rebuild VF's VSI
- * @vf: VF to release and setup the VSI for
- *
- * This is only called when a single VF is being reset (i.e. VFR, VFLR, host VF
- * configuration change, etc.).
- */
-static int ice_sriov_vsi_rebuild(struct ice_vf *vf)
-{
-	struct ice_pf *pf = vf->pf;
+	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	ice_vf_vsi_release(vf);
-	if (!ice_vf_vsi_setup(vf)) {
-		dev_err(ice_pf_to_dev(pf),
-			"Failed to release and setup the VF%u's VSI\n",
-			vf->vf_id);
-		return -ENOMEM;
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	return 0;
+	if (ice_set_rss_lut(vsi, vrl->lut, ICE_VSIQF_HLUT_ARRAY_SIZE))
+		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+error_param:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
+				     NULL, 0);
 }
 
 /**
- * ice_sriov_post_vsi_rebuild - tasks to do after the VF's VSI have been rebuilt
- * @vf: VF to perform tasks on
+ * ice_vc_cfg_promiscuous_mode_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
+ *
+ * called from the VF to configure VF VSIs promiscuous mode
  */
-static void ice_sriov_post_vsi_rebuild(struct ice_vf *vf)
+static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
-	ice_vf_rebuild_host_cfg(vf);
-	ice_vf_set_initialized(vf);
-	ice_ena_vf_mappings(vf);
-	wr32(&vf->pf->hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_VFACTIVE);
-}
-
-static const struct ice_vf_ops ice_sriov_vf_ops = {
-	.reset_type = ICE_VF_RESET,
-	.free = ice_sriov_free_vf,
-	.clear_mbx_register = ice_sriov_clear_mbx_register,
-	.trigger_reset_register = ice_sriov_trigger_reset_register,
-	.poll_reset_status = ice_sriov_poll_reset_status,
-	.clear_reset_trigger = ice_sriov_clear_reset_trigger,
-	.vsi_rebuild = ice_sriov_vsi_rebuild,
-	.post_vsi_rebuild = ice_sriov_post_vsi_rebuild,
-};
-
-/**
- * ice_create_vf_entries - Allocate and insert VF entries
- * @pf: pointer to the PF structure
- * @num_vfs: the number of VFs to allocate
- *
- * Allocate new VF entries and insert them into the hash table. Set some
- * basic default fields for initializing the new VFs.
- *
- * After this function exits, the hash table will have num_vfs entries
- * inserted.
- *
- * Returns 0 on success or an integer error code on failure.
- */
-static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
-{
-	struct ice_vfs *vfs = &pf->vfs;
-	struct ice_vf *vf;
-	u16 vf_id;
-	int err;
-
-	lockdep_assert_held(&vfs->table_lock);
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	bool rm_promisc, alluni = false, allmulti = false;
+	struct virtchnl_promisc_info *info =
+	    (struct virtchnl_promisc_info *)msg;
+	struct ice_vsi_vlan_ops *vlan_ops;
+	int mcast_err = 0, ucast_err = 0;
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	int ret = 0;
 
-	for (vf_id = 0; vf_id < num_vfs; vf_id++) {
-		vf = kzalloc(sizeof(*vf), GFP_KERNEL);
-		if (!vf) {
-			err = -ENOMEM;
-			goto err_free_entries;
-		}
-		kref_init(&vf->refcnt);
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-		vf->pf = pf;
-		vf->vf_id = vf_id;
+	if (!ice_vc_isvalid_vsi_id(vf, info->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-		/* set sriov vf ops for VFs created during SRIOV flow */
-		vf->vf_ops = &ice_sriov_vf_ops;
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-		vf->vf_sw_id = pf->first_sw;
-		/* assign default capabilities */
-		vf->spoofchk = true;
-		vf->num_vf_qs = pf->vfs.num_qps_per;
-		ice_vc_set_default_allowlist(vf);
+	dev = ice_pf_to_dev(pf);
+	if (!ice_is_vf_trusted(vf)) {
+		dev_err(dev, "Unprivileged VF %d is attempting to configure promiscuous mode\n",
+			vf->vf_id);
+		/* Leave v_ret alone, lie to the VF on purpose. */
+		goto error_param;
+	}
 
-		/* ctrl_vsi_idx will be set to a valid value only when VF
-		 * creates its first fdir rule.
-		 */
-		ice_vf_ctrl_invalidate_vsi(vf);
-		ice_vf_fdir_init(vf);
+	if (info->flags & FLAG_VF_UNICAST_PROMISC)
+		alluni = true;
 
-		ice_virtchnl_set_dflt_ops(vf);
+	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
+		allmulti = true;
 
-		mutex_init(&vf->cfg_lock);
+	rm_promisc = !allmulti && !alluni;
 
-		hash_add_rcu(vfs->table, &vf->entry, vf_id);
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	if (rm_promisc)
+		ret = vlan_ops->ena_rx_filtering(vsi);
+	else
+		ret = vlan_ops->dis_rx_filtering(vsi);
+	if (ret) {
+		dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	return 0;
-
-err_free_entries:
-	ice_free_vf_entries(pf);
-	return err;
-}
+	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
+		bool set_dflt_vsi = alluni || allmulti;
 
-/**
- * ice_ena_vfs - enable VFs so they are ready to be used
- * @pf: pointer to the PF structure
- * @num_vfs: number of VFs to enable
- */
-static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
-{
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_hw *hw = &pf->hw;
-	int ret;
+		if (set_dflt_vsi && !ice_is_dflt_vsi_in_use(pf->first_sw))
+			/* only attempt to set the default forwarding VSI if
+			 * it's not currently set
+			 */
+			ret = ice_set_dflt_vsi(pf->first_sw, vsi);
+		else if (!set_dflt_vsi &&
+			 ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
+			/* only attempt to free the default forwarding VSI if we
+			 * are the owner
+			 */
+			ret = ice_clear_dflt_vsi(pf->first_sw);
 
-	/* Disable global interrupt 0 so we don't try to handle the VFLR. */
-	wr32(hw, GLINT_DYN_CTL(pf->oicr_idx),
-	     ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S);
-	set_bit(ICE_OICR_INTR_DIS, pf->state);
-	ice_flush(hw);
+		if (ret) {
+			dev_err(dev, "%sable VF %d as the default VSI failed, error %d\n",
+				set_dflt_vsi ? "en" : "dis", vf->vf_id, ret);
+			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+			goto error_param;
+		}
+	} else {
+		u8 mcast_m, ucast_m;
 
-	ret = pci_enable_sriov(pf->pdev, num_vfs);
-	if (ret)
-		goto err_unroll_intr;
+		if (ice_vf_is_port_vlan_ena(vf) ||
+		    ice_vsi_has_non_zero_vlans(vsi)) {
+			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
+			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
+		} else {
+			mcast_m = ICE_MCAST_PROMISC_BITS;
+			ucast_m = ICE_UCAST_PROMISC_BITS;
+		}
 
-	mutex_lock(&pf->vfs.table_lock);
+		if (alluni)
+			ucast_err = ice_vf_set_vsi_promisc(vf, vsi, ucast_m);
+		else
+			ucast_err = ice_vf_clear_vsi_promisc(vf, vsi, ucast_m);
 
-	ret = ice_set_per_vf_res(pf, num_vfs);
-	if (ret) {
-		dev_err(dev, "Not enough resources for %d VFs, err %d. Try with fewer number of VFs\n",
-			num_vfs, ret);
-		goto err_unroll_sriov;
-	}
+		if (allmulti)
+			mcast_err = ice_vf_set_vsi_promisc(vf, vsi, mcast_m);
+		else
+			mcast_err = ice_vf_clear_vsi_promisc(vf, vsi, mcast_m);
 
-	ret = ice_create_vf_entries(pf, num_vfs);
-	if (ret) {
-		dev_err(dev, "Failed to allocate VF entries for %d VFs\n",
-			num_vfs);
-		goto err_unroll_sriov;
+		if (ucast_err || mcast_err)
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 	}
 
-	ret = ice_start_vfs(pf);
-	if (ret) {
-		dev_err(dev, "Failed to start %d VFs, err %d\n", num_vfs, ret);
-		ret = -EAGAIN;
-		goto err_unroll_vf_entries;
+	if (!mcast_err) {
+		if (allmulti &&
+		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!allmulti &&
+			 test_and_clear_bit(ICE_VF_STATE_MC_PROMISC,
+					    vf->vf_states))
+			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
+				 vf->vf_id);
 	}
 
-	clear_bit(ICE_VF_DIS, pf->state);
-
-	ret = ice_eswitch_configure(pf);
-	if (ret) {
-		dev_err(dev, "Failed to configure eswitch, err %d\n", ret);
-		goto err_unroll_sriov;
+	if (!ucast_err) {
+		if (alluni &&
+		    !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!alluni &&
+			 test_and_clear_bit(ICE_VF_STATE_UC_PROMISC,
+					    vf->vf_states))
+			dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n",
+				 vf->vf_id);
 	}
 
-	/* rearm global interrupts */
-	if (test_and_clear_bit(ICE_OICR_INTR_DIS, pf->state))
-		ice_irq_dynamic_ena(hw, NULL, NULL);
-
-	mutex_unlock(&pf->vfs.table_lock);
-
-	return 0;
-
-err_unroll_vf_entries:
-	ice_free_vf_entries(pf);
-err_unroll_sriov:
-	mutex_unlock(&pf->vfs.table_lock);
-	pci_disable_sriov(pf->pdev);
-err_unroll_intr:
-	/* rearm interrupts here */
-	ice_irq_dynamic_ena(hw, NULL, NULL);
-	clear_bit(ICE_OICR_INTR_DIS, pf->state);
-	return ret;
+error_param:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				     v_ret, NULL, 0);
 }
 
 /**
- * ice_pci_sriov_ena - Enable or change number of VFs
- * @pf: pointer to the PF structure
- * @num_vfs: number of VFs to allocate
+ * ice_vc_get_stats_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
  *
- * Returns 0 on success and negative on failure
+ * called from the VF to get VSI stats
  */
-static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
+static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 {
-	int pre_existing_vfs = pci_num_vf(pf->pdev);
-	struct device *dev = ice_pf_to_dev(pf);
-	int err;
-
-	if (pre_existing_vfs && pre_existing_vfs != num_vfs)
-		ice_free_vfs(pf);
-	else if (pre_existing_vfs && pre_existing_vfs == num_vfs)
-		return 0;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_queue_select *vqs =
+		(struct virtchnl_queue_select *)msg;
+	struct ice_eth_stats stats = { 0 };
+	struct ice_vsi *vsi;
 
-	if (num_vfs > pf->vfs.num_supported) {
-		dev_err(dev, "Can't enable %d VFs, max VFs supported is %d\n",
-			num_vfs, pf->vfs.num_supported);
-		return -EOPNOTSUPP;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	dev_info(dev, "Enabling %d VFs\n", num_vfs);
-	err = ice_ena_vfs(pf, num_vfs);
-	if (err) {
-		dev_err(dev, "Failed to enable SR-IOV: %d\n", err);
-		return err;
+	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	set_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
-	return 0;
-}
-
-/**
- * ice_check_sriov_allowed - check if SR-IOV is allowed based on various checks
- * @pf: PF to enabled SR-IOV on
- */
-static int ice_check_sriov_allowed(struct ice_pf *pf)
-{
-	struct device *dev = ice_pf_to_dev(pf);
-
-	if (!test_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags)) {
-		dev_err(dev, "This device is not capable of SR-IOV\n");
-		return -EOPNOTSUPP;
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	if (ice_is_safe_mode(pf)) {
-		dev_err(dev, "SR-IOV cannot be configured - Device is in Safe Mode\n");
-		return -EOPNOTSUPP;
-	}
+	ice_update_eth_stats(vsi);
 
-	if (!ice_pf_state_is_nominal(pf)) {
-		dev_err(dev, "Cannot enable SR-IOV, device not ready\n");
-		return -EBUSY;
-	}
+	stats = vsi->eth_stats;
 
-	return 0;
+error_param:
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
+				     (u8 *)&stats, sizeof(stats));
 }
 
 /**
- * ice_sriov_configure - Enable or change number of VFs via sysfs
- * @pdev: pointer to a pci_dev structure
- * @num_vfs: number of VFs to allocate or 0 to free VFs
+ * ice_vc_validate_vqs_bitmaps - validate Rx/Tx queue bitmaps from VIRTCHNL
+ * @vqs: virtchnl_queue_select structure containing bitmaps to validate
  *
- * This function is called when the user updates the number of VFs in sysfs. On
- * success return whatever num_vfs was set to by the caller. Return negative on
- * failure.
+ * Return true on successful validation, else false
  */
-int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
+static bool ice_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
 {
-	struct ice_pf *pf = pci_get_drvdata(pdev);
-	struct device *dev = ice_pf_to_dev(pf);
-	int err;
-
-	err = ice_check_sriov_allowed(pf);
-	if (err)
-		return err;
-
-	if (!num_vfs) {
-		if (!pci_vfs_assigned(pdev)) {
-			ice_mbx_deinit_snapshot(&pf->hw);
-			ice_free_vfs(pf);
-			if (pf->lag)
-				ice_enable_lag(pf->lag);
-			return 0;
-		}
-
-		dev_err(dev, "can't free VFs because some are assigned to VMs.\n");
-		return -EBUSY;
-	}
-
-	err = ice_mbx_init_snapshot(&pf->hw, num_vfs);
-	if (err)
-		return err;
-
-	err = ice_pci_sriov_ena(pf, num_vfs);
-	if (err) {
-		ice_mbx_deinit_snapshot(&pf->hw);
-		return err;
-	}
+	if ((!vqs->rx_queues && !vqs->tx_queues) ||
+	    vqs->rx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF) ||
+	    vqs->tx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF))
+		return false;
 
-	if (pf->lag)
-		ice_disable_lag(pf->lag);
-	return num_vfs;
+	return true;
 }
 
 /**
- * ice_process_vflr_event - Free VF resources via IRQ calls
- * @pf: pointer to the PF structure
- *
- * called from the VFLR IRQ handler to
- * free up VF resources and state variables
+ * ice_vf_ena_txq_interrupt - enable Tx queue interrupt via QINT_TQCTL
+ * @vsi: VSI of the VF to configure
+ * @q_idx: VF queue index used to determine the queue in the PF's space
  */
-void ice_process_vflr_event(struct ice_pf *pf)
+static void ice_vf_ena_txq_interrupt(struct ice_vsi *vsi, u32 q_idx)
 {
-	struct ice_hw *hw = &pf->hw;
-	struct ice_vf *vf;
-	unsigned int bkt;
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 pfq = vsi->txq_map[q_idx];
 	u32 reg;
 
-	if (!test_and_clear_bit(ICE_VFLR_EVENT_PENDING, pf->state) ||
-	    !ice_has_vfs(pf))
-		return;
+	reg = rd32(hw, QINT_TQCTL(pfq));
 
-	mutex_lock(&pf->vfs.table_lock);
-	ice_for_each_vf(pf, bkt, vf) {
-		u32 reg_idx, bit_idx;
+	/* MSI-X index 0 in the VF's space is always for the OICR, which means
+	 * this is most likely a poll mode VF driver, so don't enable an
+	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
+	 */
+	if (!(reg & QINT_TQCTL_MSIX_INDX_M))
+		return;
 
-		reg_idx = (hw->func_caps.vf_base_id + vf->vf_id) / 32;
-		bit_idx = (hw->func_caps.vf_base_id + vf->vf_id) % 32;
-		/* read GLGEN_VFLRSTAT register to find out the flr VFs */
-		reg = rd32(hw, GLGEN_VFLRSTAT(reg_idx));
-		if (reg & BIT(bit_idx))
-			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
-			ice_reset_vf(vf, ICE_VF_RESET_VFLR | ICE_VF_RESET_LOCK);
-	}
-	mutex_unlock(&pf->vfs.table_lock);
+	wr32(hw, QINT_TQCTL(pfq), reg | QINT_TQCTL_CAUSE_ENA_M);
 }
 
 /**
- * ice_get_vf_from_pfq - get the VF who owns the PF space queue passed in
- * @pf: PF used to index all VFs
- * @pfq: queue index relative to the PF's function space
- *
- * If no VF is found who owns the pfq then return NULL, otherwise return a
- * pointer to the VF who owns the pfq
- *
- * If this function returns non-NULL, it acquires a reference count of the VF
- * structure. The caller is responsible for calling ice_put_vf() to drop this
- * reference.
+ * ice_vf_ena_rxq_interrupt - enable Tx queue interrupt via QINT_RQCTL
+ * @vsi: VSI of the VF to configure
+ * @q_idx: VF queue index used to determine the queue in the PF's space
  */
-static struct ice_vf *ice_get_vf_from_pfq(struct ice_pf *pf, u16 pfq)
+static void ice_vf_ena_rxq_interrupt(struct ice_vsi *vsi, u32 q_idx)
 {
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	rcu_read_lock();
-	ice_for_each_vf_rcu(pf, bkt, vf) {
-		struct ice_vsi *vsi;
-		u16 rxq_idx;
-
-		vsi = ice_get_vf_vsi(vf);
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 pfq = vsi->rxq_map[q_idx];
+	u32 reg;
 
-		ice_for_each_rxq(vsi, rxq_idx)
-			if (vsi->rxq_map[rxq_idx] == pfq) {
-				struct ice_vf *found;
+	reg = rd32(hw, QINT_RQCTL(pfq));
 
-				if (kref_get_unless_zero(&vf->refcnt))
-					found = vf;
-				else
-					found = NULL;
-				rcu_read_unlock();
-				return found;
-			}
-	}
-	rcu_read_unlock();
+	/* MSI-X index 0 in the VF's space is always for the OICR, which means
+	 * this is most likely a poll mode VF driver, so don't enable an
+	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
+	 */
+	if (!(reg & QINT_RQCTL_MSIX_INDX_M))
+		return;
 
-	return NULL;
+	wr32(hw, QINT_RQCTL(pfq), reg | QINT_RQCTL_CAUSE_ENA_M);
 }
 
 /**
- * ice_globalq_to_pfq - convert from global queue index to PF space queue index
- * @pf: PF used for conversion
- * @globalq: global queue index used to convert to PF space queue index
- */
-static u32 ice_globalq_to_pfq(struct ice_pf *pf, u32 globalq)
-{
-	return globalq - pf->hw.func_caps.common_cap.rxq_first_id;
-}
-
-/**
- * ice_vf_lan_overflow_event - handle LAN overflow event for a VF
- * @pf: PF that the LAN overflow event happened on
- * @event: structure holding the event information for the LAN overflow event
- *
- * Determine if the LAN overflow event was caused by a VF queue. If it was not
- * caused by a VF, do nothing. If a VF caused this LAN overflow event trigger a
- * reset on the offending VF.
- */
-void
-ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
-{
-	u32 gldcb_rtctq, queue;
-	struct ice_vf *vf;
-
-	gldcb_rtctq = le32_to_cpu(event->desc.params.lan_overflow.prtdcb_ruptq);
-	dev_dbg(ice_pf_to_dev(pf), "GLDCB_RTCTQ: 0x%08x\n", gldcb_rtctq);
-
-	/* event returns device global Rx queue number */
-	queue = (gldcb_rtctq & GLDCB_RTCTQ_RXQNUM_M) >>
-		GLDCB_RTCTQ_RXQNUM_S;
-
-	vf = ice_get_vf_from_pfq(pf, ice_globalq_to_pfq(pf, queue));
-	if (!vf)
-		return;
-
-	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY | ICE_VF_RESET_LOCK);
-	ice_put_vf(vf);
-}
-
-/**
- * ice_vc_send_msg_to_vf - Send message to VF
+ * ice_vc_ena_qs_msg
  * @vf: pointer to the VF info
- * @v_opcode: virtual channel opcode
- * @v_retval: virtual channel return value
  * @msg: pointer to the msg buffer
- * @msglen: msg length
  *
- * send msg to VF
+ * called from the VF to enable all or specific queue(s)
  */
-int
-ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
+static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct device *dev;
-	struct ice_pf *pf;
-	int aq_ret;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_queue_select *vqs =
+	    (struct virtchnl_queue_select *)msg;
+	struct ice_vsi *vsi;
+	unsigned long q_map;
+	u16 vf_q_id;
 
-	pf = vf->pf;
-	dev = ice_pf_to_dev(pf);
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
-				       msg, msglen, NULL);
-	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
-		dev_info(dev, "Unable to send the message to VF %d ret %d aq_err %s\n",
-			 vf->vf_id, aq_ret,
-			 ice_aq_str(pf->hw.mailboxq.sq_last_status));
-		return -EIO;
+	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
-	return 0;
-}
+	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-/**
- * ice_vc_get_ver_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to request the API version used by the PF
- */
-static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
-{
-	struct virtchnl_version_info info = {
-		VIRTCHNL_VERSION_MAJOR, VIRTCHNL_VERSION_MINOR
-	};
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	vf->vf_ver = *(struct virtchnl_version_info *)msg;
-	/* VFs running the 1.0 API expect to get 1.0 back or they will cry. */
-	if (VF_IS_V10(&vf->vf_ver))
-		info.minor = VIRTCHNL_VERSION_MINOR_NO_VF_CAPS;
+	/* Enable only Rx rings, Tx rings were enabled by the FW when the
+	 * Tx queue group list was configured and the context bits were
+	 * programmed using ice_vsi_cfg_txqs
+	 */
+	q_map = vqs->rx_queues;
+	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
+		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_VERSION,
-				     VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
-				     sizeof(struct virtchnl_version_info));
-}
+		/* Skip queue if enabled */
+		if (test_bit(vf_q_id, vf->rxq_ena))
+			continue;
 
-/**
- * ice_vc_get_max_frame_size - get max frame size allowed for VF
- * @vf: VF used to determine max frame size
- *
- * Max frame size is determined based on the current port's max frame size and
- * whether a port VLAN is configured on this VF. The VF is not aware whether
- * it's in a port VLAN so the PF needs to account for this in max frame size
- * checks and sending the max frame size to the VF.
- */
-static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
-{
-	struct ice_port_info *pi = ice_vf_get_port_info(vf);
-	u16 max_frame_size;
+		if (ice_vsi_ctrl_one_rx_ring(vsi, true, vf_q_id, true)) {
+			dev_err(ice_pf_to_dev(vsi->back), "Failed to enable Rx ring %d on VSI %d\n",
+				vf_q_id, vsi->vsi_num);
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
-	max_frame_size = pi->phy.link_info.max_frame_size;
+		ice_vf_ena_rxq_interrupt(vsi, vf_q_id);
+		set_bit(vf_q_id, vf->rxq_ena);
+	}
 
-	if (ice_vf_is_port_vlan_ena(vf))
-		max_frame_size -= VLAN_HLEN;
+	q_map = vqs->tx_queues;
+	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
+		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
-	return max_frame_size;
+		/* Skip queue if enabled */
+		if (test_bit(vf_q_id, vf->txq_ena))
+			continue;
+
+		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
+		set_bit(vf_q_id, vf->txq_ena);
+	}
+
+	/* Set flag to indicate that queues are enabled */
+	if (v_ret == VIRTCHNL_STATUS_SUCCESS)
+		set_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
+
+error_param:
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
+				     NULL, 0);
 }
 
 /**
- * ice_vc_get_vf_res_msg
+ * ice_vc_dis_qs_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  *
- * called from the VF to request its resources
+ * called from the VF to disable all or specific
+ * queue(s)
  */
-static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
+static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vf_resource *vfres = NULL;
-	struct ice_pf *pf = vf->pf;
+	struct virtchnl_queue_select *vqs =
+	    (struct virtchnl_queue_select *)msg;
 	struct ice_vsi *vsi;
-	int len = 0;
-	int ret;
+	unsigned long q_map;
+	u16 vf_q_id;
 
-	if (ice_check_vf_init(pf, vf)) {
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) &&
+	    !test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto err;
+		goto error_param;
 	}
 
-	len = sizeof(struct virtchnl_vf_resource);
+	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-	vfres = kzalloc(len, GFP_KERNEL);
-	if (!vfres) {
-		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
-		len = 0;
-		goto err;
+	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
-	if (VF_IS_V11(&vf->vf_ver))
-		vf->driver_caps = *(u32 *)msg;
-	else
-		vf->driver_caps = VIRTCHNL_VF_OFFLOAD_L2 |
-				  VIRTCHNL_VF_OFFLOAD_RSS_REG |
-				  VIRTCHNL_VF_OFFLOAD_VLAN;
 
-	vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
 	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto err;
+		goto error_param;
 	}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN_V2) {
-		/* VLAN offloads based on current device configuration */
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN_V2;
-	} else if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN) {
-		/* allow VF to negotiate VIRTCHNL_VF_OFFLOAD explicitly for
-		 * these two conditions, which amounts to guest VLAN filtering
-		 * and offloads being based on the inner VLAN or the
-		 * inner/single VLAN respectively and don't allow VF to
-		 * negotiate VIRTCHNL_VF_OFFLOAD in any other cases
-		 */
-		if (ice_is_dvm_ena(&pf->hw) && ice_vf_is_port_vlan_ena(vf)) {
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-		} else if (!ice_is_dvm_ena(&pf->hw) &&
-			   !ice_vf_is_port_vlan_ena(vf)) {
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-			/* configure backward compatible support for VFs that
-			 * only support VIRTCHNL_VF_OFFLOAD_VLAN, the PF is
-			 * configured in SVM, and no port VLAN is configured
-			 */
-			ice_vf_vsi_cfg_svm_legacy_vlan_mode(vsi);
-		} else if (ice_is_dvm_ena(&pf->hw)) {
-			/* configure software offloaded VLAN support when DVM
-			 * is enabled, but no port VLAN is enabled
-			 */
-			ice_vf_vsi_cfg_dvm_legacy_vlan_mode(vsi);
-		}
-	}
+	if (vqs->tx_queues) {
+		q_map = vqs->tx_queues;
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PF;
-	} else {
-		if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_AQ)
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_AQ;
-		else
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_REG;
-	}
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
+			struct ice_tx_ring *ring = vsi->tx_rings[vf_q_id];
+			struct ice_txq_meta txq_meta = { 0 };
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_FDIR_PF)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_FDIR_PF;
+			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2;
+			/* Skip queue if not enabled */
+			if (!test_bit(vf_q_id, vf->txq_ena))
+				continue;
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ENCAP)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ENCAP;
+			ice_fill_txq_meta(vsi, ring, &txq_meta);
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM;
+			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
+						 ring, &txq_meta)) {
+				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
+					vf_q_id, vsi->vsi_num);
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RX_POLLING)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RX_POLLING;
+			/* Clear enabled queues flag */
+			clear_bit(vf_q_id, vf->txq_ena);
+		}
+	}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_WB_ON_ITR)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_WB_ON_ITR;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_REQ_QUEUES)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_REQ_QUEUES;
-
-	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF;
-
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO)
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_USO;
-
-	vfres->num_vsis = 1;
-	/* Tx and Rx queue are equal for VF */
-	vfres->num_queue_pairs = vsi->num_txq;
-	vfres->max_vectors = pf->vfs.num_msix_per;
-	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
-	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
-	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
+	q_map = vqs->rx_queues;
+	/* speed up Rx queue disable by batching them if possible */
+	if (q_map &&
+	    bitmap_equal(&q_map, vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF)) {
+		if (ice_vsi_stop_all_rx_rings(vsi)) {
+			dev_err(ice_pf_to_dev(vsi->back), "Failed to stop all Rx rings on VSI %d\n",
+				vsi->vsi_num);
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
-	vfres->vsi_res[0].vsi_id = vf->lan_vsi_num;
-	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
-	vfres->vsi_res[0].num_queue_pairs = vsi->num_txq;
-	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
-			vf->hw_lan_addr.addr);
+		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
+	} else if (q_map) {
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
+			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
 
-	/* match guest capabilities */
-	vf->driver_caps = vfres->vf_cap_flags;
+			/* Skip queue if not enabled */
+			if (!test_bit(vf_q_id, vf->rxq_ena))
+				continue;
 
-	ice_vc_set_caps_allowlist(vf);
-	ice_vc_set_working_allowlist(vf);
+			if (ice_vsi_ctrl_one_rx_ring(vsi, false, vf_q_id,
+						     true)) {
+				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Rx ring %d on VSI %d\n",
+					vf_q_id, vsi->vsi_num);
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
 
-	set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
+			/* Clear enabled queues flag */
+			clear_bit(vf_q_id, vf->rxq_ena);
+		}
+	}
 
-err:
-	/* send the response back to the VF */
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
-				    (u8 *)vfres, len);
+	/* Clear enabled queues flag */
+	if (v_ret == VIRTCHNL_STATUS_SUCCESS && ice_vf_has_no_qs_ena(vf))
+		clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 
-	kfree(vfres);
-	return ret;
+error_param:
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
+				     NULL, 0);
 }
 
 /**
- * ice_vc_reset_vf_msg
+ * ice_cfg_interrupt
  * @vf: pointer to the VF info
- *
- * called from the VF to reset itself,
- * unlike other virtchnl messages, PF driver
- * doesn't send the response back to the VF
+ * @vsi: the VSI being configured
+ * @vector_id: vector ID
+ * @map: vector map for mapping vectors to queues
+ * @q_vector: structure for interrupt vector
+ * configure the IRQ to queue map
  */
-static void ice_vc_reset_vf_msg(struct ice_vf *vf)
+static int
+ice_cfg_interrupt(struct ice_vf *vf, struct ice_vsi *vsi, u16 vector_id,
+		  struct virtchnl_vector_map *map,
+		  struct ice_q_vector *q_vector)
 {
-	if (test_bit(ICE_VF_STATE_INIT, vf->vf_states))
-		ice_reset_vf(vf, 0);
-}
+	u16 vsi_q_id, vsi_q_id_idx;
+	unsigned long qmap;
 
-/**
- * ice_find_vsi_from_id
- * @pf: the PF structure to search for the VSI
- * @id: ID of the VSI it is searching for
- *
- * searches for the VSI with the given ID
- */
-static struct ice_vsi *ice_find_vsi_from_id(struct ice_pf *pf, u16 id)
-{
-	int i;
+	q_vector->num_ring_rx = 0;
+	q_vector->num_ring_tx = 0;
 
-	ice_for_each_vsi(pf, i)
-		if (pf->vsi[i] && pf->vsi[i]->vsi_num == id)
-			return pf->vsi[i];
+	qmap = map->rxq_map;
+	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
+		vsi_q_id = vsi_q_id_idx;
 
-	return NULL;
+		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+			return VIRTCHNL_STATUS_ERR_PARAM;
+
+		q_vector->num_ring_rx++;
+		q_vector->rx.itr_idx = map->rxitr_idx;
+		vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
+		ice_cfg_rxq_interrupt(vsi, vsi_q_id, vector_id,
+				      q_vector->rx.itr_idx);
+	}
+
+	qmap = map->txq_map;
+	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
+		vsi_q_id = vsi_q_id_idx;
+
+		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+			return VIRTCHNL_STATUS_ERR_PARAM;
+
+		q_vector->num_ring_tx++;
+		q_vector->tx.itr_idx = map->txitr_idx;
+		vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
+		ice_cfg_txq_interrupt(vsi, vsi_q_id, vector_id,
+				      q_vector->tx.itr_idx);
+	}
+
+	return VIRTCHNL_STATUS_SUCCESS;
 }
 
 /**
- * ice_vc_isvalid_vsi_id
+ * ice_vc_cfg_irq_map_msg
  * @vf: pointer to the VF info
- * @vsi_id: VF relative VSI ID
+ * @msg: pointer to the msg buffer
  *
- * check for the valid VSI ID
+ * called from the VF to configure the IRQ to queue map
  */
-bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
+static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 {
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	u16 num_q_vectors_mapped, vsi_id, vector_id;
+	struct virtchnl_irq_map_info *irqmap_info;
+	struct virtchnl_vector_map *map;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
+	int i;
 
-	vsi = ice_find_vsi_from_id(pf, vsi_id);
+	irqmap_info = (struct virtchnl_irq_map_info *)msg;
+	num_q_vectors_mapped = irqmap_info->num_vectors;
 
-	return (vsi && (vsi->vf == vf));
-}
+	/* Check to make sure number of VF vectors mapped is not greater than
+	 * number of VF vectors originally allocated, and check that
+	 * there is actually at least a single VF queue vector mapped
+	 */
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
+	    pf->vfs.num_msix_per < num_q_vectors_mapped ||
+	    !num_q_vectors_mapped) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-/**
- * ice_vc_isvalid_q_id
- * @vf: pointer to the VF info
- * @vsi_id: VSI ID
- * @qid: VSI relative queue ID
- *
- * check for the valid queue ID
- */
-static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
-{
-	struct ice_vsi *vsi = ice_find_vsi_from_id(vf->pf, vsi_id);
-	/* allocated Tx and Rx queues should be always equal for VF VSI */
-	return (vsi && (qid < vsi->alloc_txq));
-}
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-/**
- * ice_vc_isvalid_ring_len
- * @ring_len: length of ring
- *
- * check for the valid ring count, should be multiple of ICE_REQ_DESC_MULTIPLE
- * or zero
- */
-static bool ice_vc_isvalid_ring_len(u16 ring_len)
-{
-	return ring_len == 0 ||
-	       (ring_len >= ICE_MIN_NUM_DESC &&
-		ring_len <= ICE_MAX_NUM_DESC &&
-		!(ring_len % ICE_REQ_DESC_MULTIPLE));
+	for (i = 0; i < num_q_vectors_mapped; i++) {
+		struct ice_q_vector *q_vector;
+
+		map = &irqmap_info->vecmap[i];
+
+		vector_id = map->vector_id;
+		vsi_id = map->vsi_id;
+		/* vector_id is always 0-based for each VF, and can never be
+		 * larger than or equal to the max allowed interrupts per VF
+		 */
+		if (!(vector_id < pf->vfs.num_msix_per) ||
+		    !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
+		    (!vector_id && (map->rxq_map || map->txq_map))) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		/* No need to map VF miscellaneous or rogue vector */
+		if (!vector_id)
+			continue;
+
+		/* Subtract non queue vector from vector_id passed by VF
+		 * to get actual number of VSI queue vector array index
+		 */
+		q_vector = vsi->q_vectors[vector_id - ICE_NONQ_VECS_VF];
+		if (!q_vector) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		/* lookout for the invalid queue index */
+		v_ret = (enum virtchnl_status_code)
+			ice_cfg_interrupt(vf, vsi, vector_id, map, q_vector);
+		if (v_ret)
+			goto error_param;
+	}
+
+error_param:
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
+				     NULL, 0);
 }
 
 /**
- * ice_vc_validate_pattern
+ * ice_vc_cfg_qs_msg
  * @vf: pointer to the VF info
- * @proto: virtchnl protocol headers
- *
- * validate the pattern is supported or not.
+ * @msg: pointer to the msg buffer
  *
- * Return: true on success, false on error.
+ * called from the VF to configure the Rx/Tx queues
  */
-bool
-ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto)
+static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 {
-	bool is_ipv4 = false;
-	bool is_ipv6 = false;
-	bool is_udp = false;
-	u16 ptype = -1;
-	int i = 0;
-
-	while (i < proto->count &&
-	       proto->proto_hdr[i].type != VIRTCHNL_PROTO_HDR_NONE) {
-		switch (proto->proto_hdr[i].type) {
-		case VIRTCHNL_PROTO_HDR_ETH:
-			ptype = ICE_PTYPE_MAC_PAY;
-			break;
-		case VIRTCHNL_PROTO_HDR_IPV4:
-			ptype = ICE_PTYPE_IPV4_PAY;
-			is_ipv4 = true;
-			break;
-		case VIRTCHNL_PROTO_HDR_IPV6:
-			ptype = ICE_PTYPE_IPV6_PAY;
-			is_ipv6 = true;
-			break;
-		case VIRTCHNL_PROTO_HDR_UDP:
-			if (is_ipv4)
-				ptype = ICE_PTYPE_IPV4_UDP_PAY;
-			else if (is_ipv6)
-				ptype = ICE_PTYPE_IPV6_UDP_PAY;
-			is_udp = true;
-			break;
-		case VIRTCHNL_PROTO_HDR_TCP:
-			if (is_ipv4)
-				ptype = ICE_PTYPE_IPV4_TCP_PAY;
-			else if (is_ipv6)
-				ptype = ICE_PTYPE_IPV6_TCP_PAY;
-			break;
-		case VIRTCHNL_PROTO_HDR_SCTP:
-			if (is_ipv4)
-				ptype = ICE_PTYPE_IPV4_SCTP_PAY;
-			else if (is_ipv6)
-				ptype = ICE_PTYPE_IPV6_SCTP_PAY;
-			break;
-		case VIRTCHNL_PROTO_HDR_GTPU_IP:
-		case VIRTCHNL_PROTO_HDR_GTPU_EH:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_GTPU;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_GTPU;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_L2TPV3:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_L2TPV3;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_L2TPV3;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_ESP:
-			if (is_ipv4)
-				ptype = is_udp ? ICE_MAC_IPV4_NAT_T_ESP :
-						ICE_MAC_IPV4_ESP;
-			else if (is_ipv6)
-				ptype = is_udp ? ICE_MAC_IPV6_NAT_T_ESP :
-						ICE_MAC_IPV6_ESP;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_AH:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_AH;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_AH;
-			goto out;
-		case VIRTCHNL_PROTO_HDR_PFCP:
-			if (is_ipv4)
-				ptype = ICE_MAC_IPV4_PFCP_SESSION;
-			else if (is_ipv6)
-				ptype = ICE_MAC_IPV6_PFCP_SESSION;
-			goto out;
-		default:
-			break;
-		}
-		i++;
-	}
-
-out:
-	return ice_hw_ptype_ena(&vf->pf->hw, ptype);
-}
-
-/**
- * ice_vc_parse_rss_cfg - parses hash fields and headers from
- * a specific virtchnl RSS cfg
- * @hw: pointer to the hardware
- * @rss_cfg: pointer to the virtchnl RSS cfg
- * @addl_hdrs: pointer to the protocol header fields (ICE_FLOW_SEG_HDR_*)
- * to configure
- * @hash_flds: pointer to the hash bit fields (ICE_FLOW_HASH_*) to configure
- *
- * Return true if all the protocol header and hash fields in the RSS cfg could
- * be parsed, else return false
- *
- * This function parses the virtchnl RSS cfg to be the intended
- * hash fields and the intended header for RSS configuration
- */
-static bool
-ice_vc_parse_rss_cfg(struct ice_hw *hw, struct virtchnl_rss_cfg *rss_cfg,
-		     u32 *addl_hdrs, u64 *hash_flds)
-{
-	const struct ice_vc_hash_field_match_type *hf_list;
-	const struct ice_vc_hdr_match_type *hdr_list;
-	int i, hf_list_len, hdr_list_len;
-
-	hf_list = ice_vc_hash_field_list;
-	hf_list_len = ARRAY_SIZE(ice_vc_hash_field_list);
-	hdr_list = ice_vc_hdr_list;
-	hdr_list_len = ARRAY_SIZE(ice_vc_hdr_list);
-
-	for (i = 0; i < rss_cfg->proto_hdrs.count; i++) {
-		struct virtchnl_proto_hdr *proto_hdr =
-					&rss_cfg->proto_hdrs.proto_hdr[i];
-		bool hdr_found = false;
-		int j;
-
-		/* Find matched ice headers according to virtchnl headers. */
-		for (j = 0; j < hdr_list_len; j++) {
-			struct ice_vc_hdr_match_type hdr_map = hdr_list[j];
-
-			if (proto_hdr->type == hdr_map.vc_hdr) {
-				*addl_hdrs |= hdr_map.ice_hdr;
-				hdr_found = true;
-			}
-		}
-
-		if (!hdr_found)
-			return false;
-
-		/* Find matched ice hash fields according to
-		 * virtchnl hash fields.
-		 */
-		for (j = 0; j < hf_list_len; j++) {
-			struct ice_vc_hash_field_match_type hf_map = hf_list[j];
-
-			if (proto_hdr->type == hf_map.vc_hdr &&
-			    proto_hdr->field_selector == hf_map.vc_hash_field) {
-				*hash_flds |= hf_map.ice_hash_field;
-				break;
-			}
-		}
-	}
-
-	return true;
-}
-
-/**
- * ice_vf_adv_rss_offload_ena - determine if capabilities support advanced
- * RSS offloads
- * @caps: VF driver negotiated capabilities
- *
- * Return true if VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF capability is set,
- * else return false
- */
-static bool ice_vf_adv_rss_offload_ena(u32 caps)
-{
-	return !!(caps & VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF);
-}
-
-/**
- * ice_vc_handle_rss_cfg
- * @vf: pointer to the VF info
- * @msg: pointer to the message buffer
- * @add: add a RSS config if true, otherwise delete a RSS config
- *
- * This function adds/deletes a RSS config
- */
-static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
-{
-	u32 v_opcode = add ? VIRTCHNL_OP_ADD_RSS_CFG : VIRTCHNL_OP_DEL_RSS_CFG;
-	struct virtchnl_rss_cfg *rss_cfg = (struct virtchnl_rss_cfg *)msg;
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	struct ice_hw *hw = &vf->pf->hw;
+	struct virtchnl_vsi_queue_config_info *qci =
+	    (struct virtchnl_vsi_queue_config_info *)msg;
+	struct virtchnl_queue_pair_info *qpi;
+	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
-		dev_dbg(dev, "VF %d attempting to configure RSS, but RSS is not supported by the PF\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-		goto error_param;
-	}
-
-	if (!ice_vf_adv_rss_offload_ena(vf->driver_caps)) {
-		dev_dbg(dev, "VF %d attempting to configure RSS, but Advanced RSS offload is not supported\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	int i, q_idx;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (rss_cfg->proto_hdrs.count > VIRTCHNL_MAX_NUM_PROTO_HDRS ||
-	    rss_cfg->rss_algorithm < VIRTCHNL_RSS_ALG_TOEPLITZ_ASYMMETRIC ||
-	    rss_cfg->rss_algorithm > VIRTCHNL_RSS_ALG_XOR_SYMMETRIC) {
-		dev_dbg(dev, "VF %d attempting to configure RSS, but RSS configuration is not valid\n",
-			vf->vf_id);
+	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -1974,842 +1587,804 @@ static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
 		goto error_param;
 	}
 
-	if (!ice_vc_validate_pattern(vf, &rss_cfg->proto_hdrs)) {
+	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
+	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
+		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
+			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (rss_cfg->rss_algorithm == VIRTCHNL_RSS_ALG_R_ASYMMETRIC) {
-		struct ice_vsi_ctx *ctx;
-		u8 lut_type, hash_type;
-		int status;
+	for (i = 0; i < qci->num_queue_pairs; i++) {
+		qpi = &qci->qpair[i];
+		if (qpi->txq.vsi_id != qci->vsi_id ||
+		    qpi->rxq.vsi_id != qci->vsi_id ||
+		    qpi->rxq.queue_id != qpi->txq.queue_id ||
+		    qpi->txq.headwb_enabled ||
+		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
+		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
+		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
-		lut_type = ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI;
-		hash_type = add ? ICE_AQ_VSI_Q_OPT_RSS_XOR :
-				ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
+		q_idx = qpi->rxq.queue_id;
 
-		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-		if (!ctx) {
-			v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		/* make sure selected "q_idx" is in valid range of queues
+		 * for selected "vsi"
+		 */
+		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
-		ctx->info.q_opt_rss = ((lut_type <<
-					ICE_AQ_VSI_Q_OPT_RSS_LUT_S) &
-				       ICE_AQ_VSI_Q_OPT_RSS_LUT_M) |
-				       (hash_type &
-					ICE_AQ_VSI_Q_OPT_RSS_HASH_M);
+		/* copy Tx queue info from VF into VSI */
+		if (qpi->txq.ring_len > 0) {
+			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
+			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+		}
 
-		/* Preserve existing queueing option setting */
-		ctx->info.q_opt_rss |= (vsi->info.q_opt_rss &
-					  ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_M);
-		ctx->info.q_opt_tc = vsi->info.q_opt_tc;
-		ctx->info.q_opt_flags = vsi->info.q_opt_rss;
+		/* copy Rx queue info from VF into VSI */
+		if (qpi->rxq.ring_len > 0) {
+			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
 
-		ctx->info.valid_sections =
-				cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
+			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
+			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
 
-		status = ice_update_vsi(hw, vsi->idx, ctx, NULL);
-		if (status) {
-			dev_err(dev, "update VSI for RSS failed, err %d aq_err %s\n",
-				status, ice_aq_str(hw->adminq.sq_last_status));
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		} else {
-			vsi->info.q_opt_rss = ctx->info.q_opt_rss;
-		}
-
-		kfree(ctx);
-	} else {
-		u32 addl_hdrs = ICE_FLOW_SEG_HDR_NONE;
-		u64 hash_flds = ICE_HASH_INVALID;
-
-		if (!ice_vc_parse_rss_cfg(hw, rss_cfg, &addl_hdrs,
-					  &hash_flds)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		if (add) {
-			if (ice_add_rss_cfg(hw, vsi->idx, hash_flds,
-					    addl_hdrs)) {
+			if (qpi->rxq.databuffer_size != 0 &&
+			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
+			     qpi->rxq.databuffer_size < 1024)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				dev_err(dev, "ice_add_rss_cfg failed for vsi = %d, v_ret = %d\n",
-					vsi->vsi_num, v_ret);
+				goto error_param;
+			}
+			vsi->rx_buf_len = qpi->rxq.databuffer_size;
+			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
+			if (qpi->rxq.max_pkt_size > max_frame_size ||
+			    qpi->rxq.max_pkt_size < 64) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
 			}
-		} else {
-			int status;
 
-			status = ice_rem_rss_cfg(hw, vsi->idx, hash_flds,
-						 addl_hdrs);
-			/* We just ignore -ENOENT, because if two configurations
-			 * share the same profile remove one of them actually
-			 * removes both, since the profile is deleted.
+			vsi->max_frame = qpi->rxq.max_pkt_size;
+			/* add space for the port VLAN since the VF driver is
+			 * not expected to account for it in the MTU
+			 * calculation
 			 */
-			if (status && status != -ENOENT) {
+			if (ice_vf_is_port_vlan_ena(vf))
+				vsi->max_frame += VLAN_HLEN;
+
+			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				dev_err(dev, "ice_rem_rss_cfg failed for VF ID:%d, error:%d\n",
-					vf->vf_id, status);
+				goto error_param;
 			}
 		}
 	}
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, v_opcode, v_ret, NULL, 0);
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES, v_ret,
+				     NULL, 0);
 }
 
 /**
- * ice_vc_config_rss_key
+ * ice_can_vf_change_mac
  * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
  *
- * Configure the VF's RSS key
+ * Return true if the VF is allowed to change its MAC filters, false otherwise
  */
-static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
+static bool ice_can_vf_change_mac(struct ice_vf *vf)
 {
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_rss_key *vrk =
-		(struct virtchnl_rss_key *)msg;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vrk->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	/* If the VF MAC address has been set administratively (via the
+	 * ndo_set_vf_mac command), then deny permission to the VF to
+	 * add/delete unicast MAC addresses, unless the VF is trusted
+	 */
+	if (vf->pf_set_mac && !ice_is_vf_trusted(vf))
+		return false;
 
-	if (vrk->key_len != ICE_VSIQF_HKEY_ARRAY_SIZE) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	return true;
+}
 
-	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+/**
+ * ice_vc_ether_addr_type - get type of virtchnl_ether_addr
+ * @vc_ether_addr: used to extract the type
+ */
+static u8
+ice_vc_ether_addr_type(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	return (vc_ether_addr->type & VIRTCHNL_ETHER_ADDR_TYPE_MASK);
+}
 
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+/**
+ * ice_is_vc_addr_legacy - check if the MAC address is from an older VF
+ * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
+ */
+static bool
+ice_is_vc_addr_legacy(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
 
-	if (ice_set_rss_key(vsi, vrk->key))
-		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
-				     NULL, 0);
+	return (type == VIRTCHNL_ETHER_ADDR_LEGACY);
 }
 
 /**
- * ice_vc_config_rss_lut
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
+ * ice_is_vc_addr_primary - check if the MAC address is the VF's primary MAC
+ * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
  *
- * Configure the VF's RSS LUT
+ * This function should only be called when the MAC address in
+ * virtchnl_ether_addr is a valid unicast MAC
  */
-static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
+static bool
+ice_is_vc_addr_primary(struct virtchnl_ether_addr __maybe_unused *vc_ether_addr)
 {
-	struct virtchnl_rss_lut *vrl = (struct virtchnl_rss_lut *)msg;
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
+	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	return (type == VIRTCHNL_ETHER_ADDR_PRIMARY);
+}
 
-	if (!ice_vc_isvalid_vsi_id(vf, vrl->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+/**
+ * ice_vfhw_mac_add - update the VF's cached hardware MAC if allowed
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to add
+ */
+static void
+ice_vfhw_mac_add(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 *mac_addr = vc_ether_addr->addr;
 
-	if (vrl->lut_entries != ICE_VSIQF_HLUT_ARRAY_SIZE) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	if (!is_valid_ether_addr(mac_addr))
+		return;
 
-	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+	/* only allow legacy VF drivers to set the device and hardware MAC if it
+	 * is zero and allow new VF drivers to set the hardware MAC if the type
+	 * was correctly specified over VIRTCHNL
+	 */
+	if ((ice_is_vc_addr_legacy(vc_ether_addr) &&
+	     is_zero_ether_addr(vf->hw_lan_addr.addr)) ||
+	    ice_is_vc_addr_primary(vc_ether_addr)) {
+		ether_addr_copy(vf->dev_lan_addr.addr, mac_addr);
+		ether_addr_copy(vf->hw_lan_addr.addr, mac_addr);
 	}
 
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+	/* hardware and device MACs are already set, but its possible that the
+	 * VF driver sent the VIRTCHNL_OP_ADD_ETH_ADDR message before the
+	 * VIRTCHNL_OP_DEL_ETH_ADDR when trying to update its MAC, so save it
+	 * away for the legacy VF driver case as it will be updated in the
+	 * delete flow for this case
+	 */
+	if (ice_is_vc_addr_legacy(vc_ether_addr)) {
+		ether_addr_copy(vf->legacy_last_added_umac.addr,
+				mac_addr);
+		vf->legacy_last_added_umac.time_modified = jiffies;
 	}
-
-	if (ice_set_rss_lut(vsi, vrl->lut, ICE_VSIQF_HLUT_ARRAY_SIZE))
-		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
-				     NULL, 0);
 }
 
 /**
- * ice_set_vf_spoofchk
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @ena: flag to enable or disable feature
- *
- * Enable or disable VF spoof checking
+ * ice_vc_add_mac_addr - attempt to add the MAC address passed in
+ * @vf: pointer to the VF info
+ * @vsi: pointer to the VF's VSI
+ * @vc_ether_addr: VIRTCHNL MAC address structure used to add MAC
  */
-int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
+static int
+ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
+		    struct virtchnl_ether_addr *vc_ether_addr)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_pf *pf = np->vsi->back;
-	struct ice_vsi *vf_vsi;
-	struct device *dev;
-	struct ice_vf *vf;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	u8 *mac_addr = vc_ether_addr->addr;
 	int ret;
 
-	dev = ice_pf_to_dev(pf);
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
-
-	vf_vsi = ice_get_vf_vsi(vf);
-	if (!vf_vsi) {
-		netdev_err(netdev, "VSI %d for VF %d is null\n",
-			   vf->lan_vsi_idx, vf->vf_id);
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
+	/* device MAC already added */
+	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
+		return 0;
 
-	if (vf_vsi->type != ICE_VSI_VF) {
-		netdev_err(netdev, "Type %d of VSI %d for VF %d is no ICE_VSI_VF\n",
-			   vf_vsi->type, vf_vsi->vsi_num, vf->vf_id);
-		ret = -ENODEV;
-		goto out_put_vf;
+	if (is_unicast_ether_addr(mac_addr) && !ice_can_vf_change_mac(vf)) {
+		dev_err(dev, "VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
+		return -EPERM;
 	}
 
-	if (ena == vf->spoofchk) {
-		dev_dbg(dev, "VF spoofchk already %s\n", ena ? "ON" : "OFF");
-		ret = 0;
-		goto out_put_vf;
+	ret = ice_fltr_add_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
+	if (ret == -EEXIST) {
+		dev_dbg(dev, "MAC %pM already exists for VF %d\n", mac_addr,
+			vf->vf_id);
+		/* don't return since we might need to update
+		 * the primary MAC in ice_vfhw_mac_add() below
+		 */
+	} else if (ret) {
+		dev_err(dev, "Failed to add MAC %pM for VF %d\n, error %d\n",
+			mac_addr, vf->vf_id, ret);
+		return ret;
+	} else {
+		vf->num_mac++;
 	}
 
-	ret = ice_vsi_apply_spoofchk(vf_vsi, ena);
-	if (ret)
-		dev_err(dev, "Failed to set spoofchk %s for VF %d VSI %d\n error %d\n",
-			ena ? "ON" : "OFF", vf->vf_id, vf_vsi->vsi_num, ret);
-	else
-		vf->spoofchk = ena;
+	ice_vfhw_mac_add(vf, vc_ether_addr);
 
-out_put_vf:
-	ice_put_vf(vf);
 	return ret;
 }
 
 /**
- * ice_vc_cfg_promiscuous_mode_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * called from the VF to configure VF VSIs promiscuous mode
+ * ice_is_legacy_umac_expired - check if last added legacy unicast MAC expired
+ * @last_added_umac: structure used to check expiration
  */
-static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
+static bool ice_is_legacy_umac_expired(struct ice_time_mac *last_added_umac)
 {
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	bool rm_promisc, alluni = false, allmulti = false;
-	struct virtchnl_promisc_info *info =
-	    (struct virtchnl_promisc_info *)msg;
-	struct ice_vsi_vlan_ops *vlan_ops;
-	int mcast_err = 0, ucast_err = 0;
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-	struct device *dev;
-	int ret = 0;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, info->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	dev = ice_pf_to_dev(pf);
-	if (!ice_is_vf_trusted(vf)) {
-		dev_err(dev, "Unprivileged VF %d is attempting to configure promiscuous mode\n",
-			vf->vf_id);
-		/* Leave v_ret alone, lie to the VF on purpose. */
-		goto error_param;
-	}
-
-	if (info->flags & FLAG_VF_UNICAST_PROMISC)
-		alluni = true;
-
-	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
-		allmulti = true;
+#define ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME	msecs_to_jiffies(3000)
+	return time_is_before_jiffies(last_added_umac->time_modified +
+				      ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME);
+}
 
-	rm_promisc = !allmulti && !alluni;
+/**
+ * ice_update_legacy_cached_mac - update cached hardware MAC for legacy VF
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to check
+ *
+ * only update cached hardware MAC for legacy VF drivers on delete
+ * because we cannot guarantee order/type of MAC from the VF driver
+ */
+static void
+ice_update_legacy_cached_mac(struct ice_vf *vf,
+			     struct virtchnl_ether_addr *vc_ether_addr)
+{
+	if (!ice_is_vc_addr_legacy(vc_ether_addr) ||
+	    ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
+		return;
 
-	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
-	if (rm_promisc)
-		ret = vlan_ops->ena_rx_filtering(vsi);
-	else
-		ret = vlan_ops->dis_rx_filtering(vsi);
-	if (ret) {
-		dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	ether_addr_copy(vf->dev_lan_addr.addr, vf->legacy_last_added_umac.addr);
+	ether_addr_copy(vf->hw_lan_addr.addr, vf->legacy_last_added_umac.addr);
+}
 
-	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
-		bool set_dflt_vsi = alluni || allmulti;
+/**
+ * ice_vfhw_mac_del - update the VF's cached hardware MAC if allowed
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to delete
+ */
+static void
+ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 *mac_addr = vc_ether_addr->addr;
 
-		if (set_dflt_vsi && !ice_is_dflt_vsi_in_use(pf->first_sw))
-			/* only attempt to set the default forwarding VSI if
-			 * it's not currently set
-			 */
-			ret = ice_set_dflt_vsi(pf->first_sw, vsi);
-		else if (!set_dflt_vsi &&
-			 ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
-			/* only attempt to free the default forwarding VSI if we
-			 * are the owner
-			 */
-			ret = ice_clear_dflt_vsi(pf->first_sw);
+	if (!is_valid_ether_addr(mac_addr) ||
+	    !ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
+		return;
 
-		if (ret) {
-			dev_err(dev, "%sable VF %d as the default VSI failed, error %d\n",
-				set_dflt_vsi ? "en" : "dis", vf->vf_id, ret);
-			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-			goto error_param;
-		}
-	} else {
-		u8 mcast_m, ucast_m;
+	/* allow the device MAC to be repopulated in the add flow and don't
+	 * clear the hardware MAC (i.e. hw_lan_addr.addr) here as that is meant
+	 * to be persistent on VM reboot and across driver unload/load, which
+	 * won't work if we clear the hardware MAC here
+	 */
+	eth_zero_addr(vf->dev_lan_addr.addr);
 
-		if (ice_vf_is_port_vlan_ena(vf) ||
-		    ice_vsi_has_non_zero_vlans(vsi)) {
-			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
-		} else {
-			mcast_m = ICE_MCAST_PROMISC_BITS;
-			ucast_m = ICE_UCAST_PROMISC_BITS;
-		}
+	ice_update_legacy_cached_mac(vf, vc_ether_addr);
+}
 
-		if (alluni)
-			ucast_err = ice_vf_set_vsi_promisc(vf, vsi, ucast_m);
-		else
-			ucast_err = ice_vf_clear_vsi_promisc(vf, vsi, ucast_m);
+/**
+ * ice_vc_del_mac_addr - attempt to delete the MAC address passed in
+ * @vf: pointer to the VF info
+ * @vsi: pointer to the VF's VSI
+ * @vc_ether_addr: VIRTCHNL MAC address structure used to delete MAC
+ */
+static int
+ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
+		    struct virtchnl_ether_addr *vc_ether_addr)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	u8 *mac_addr = vc_ether_addr->addr;
+	int status;
 
-		if (allmulti)
-			mcast_err = ice_vf_set_vsi_promisc(vf, vsi, mcast_m);
-		else
-			mcast_err = ice_vf_clear_vsi_promisc(vf, vsi, mcast_m);
+	if (!ice_can_vf_change_mac(vf) &&
+	    ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
+		return 0;
 
-		if (ucast_err || mcast_err)
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	status = ice_fltr_remove_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
+	if (status == -ENOENT) {
+		dev_err(dev, "MAC %pM does not exist for VF %d\n", mac_addr,
+			vf->vf_id);
+		return -ENOENT;
+	} else if (status) {
+		dev_err(dev, "Failed to delete MAC %pM for VF %d, error %d\n",
+			mac_addr, vf->vf_id, status);
+		return -EIO;
 	}
 
-	if (!mcast_err) {
-		if (allmulti &&
-		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
-			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
-				 vf->vf_id);
-		else if (!allmulti &&
-			 test_and_clear_bit(ICE_VF_STATE_MC_PROMISC,
-					    vf->vf_states))
-			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
-				 vf->vf_id);
-	}
+	ice_vfhw_mac_del(vf, vc_ether_addr);
 
-	if (!ucast_err) {
-		if (alluni &&
-		    !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
-				 vf->vf_id);
-		else if (!alluni &&
-			 test_and_clear_bit(ICE_VF_STATE_UC_PROMISC,
-					    vf->vf_states))
-			dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n",
-				 vf->vf_id);
-	}
+	vf->num_mac--;
 
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     v_ret, NULL, 0);
+	return 0;
 }
 
 /**
- * ice_vc_get_stats_msg
+ * ice_vc_handle_mac_addr_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
+ * @set: true if MAC filters are being set, false otherwise
  *
- * called from the VF to get VSI stats
+ * add guest MAC address filter
  */
-static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
+static int
+ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 {
+	int (*ice_vc_cfg_mac)
+		(struct ice_vf *vf, struct ice_vsi *vsi,
+		 struct virtchnl_ether_addr *virtchnl_ether_addr);
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_queue_select *vqs =
-		(struct virtchnl_queue_select *)msg;
-	struct ice_eth_stats stats = { 0 };
+	struct virtchnl_ether_addr_list *al =
+	    (struct virtchnl_ether_addr_list *)msg;
+	struct ice_pf *pf = vf->pf;
+	enum virtchnl_ops vc_op;
 	struct ice_vsi *vsi;
+	int i;
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+	if (set) {
+		vc_op = VIRTCHNL_OP_ADD_ETH_ADDR;
+		ice_vc_cfg_mac = ice_vc_add_mac_addr;
+	} else {
+		vc_op = VIRTCHNL_OP_DEL_ETH_ADDR;
+		ice_vc_cfg_mac = ice_vc_del_mac_addr;
+	}
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
+	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto handle_mac_exit;
 	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
+	/* If this VF is not privileged, then we can't add more than a
+	 * limited number of addresses. Check to make sure that the
+	 * additions do not push us over the limit.
+	 */
+	if (set && !ice_is_vf_trusted(vf) &&
+	    (vf->num_mac + al->num_elements) > ICE_MAX_MACADDR_PER_VF) {
+		dev_err(ice_pf_to_dev(pf), "Can't add more MAC addresses, because VF-%d is not trusted, switch the VF to trusted mode in order to add more functionalities\n",
+			vf->vf_id);
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto handle_mac_exit;
 	}
 
 	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto handle_mac_exit;
 	}
 
-	ice_update_eth_stats(vsi);
+	for (i = 0; i < al->num_elements; i++) {
+		u8 *mac_addr = al->list[i].addr;
+		int result;
 
-	stats = vsi->eth_stats;
+		if (is_broadcast_ether_addr(mac_addr) ||
+		    is_zero_ether_addr(mac_addr))
+			continue;
 
-error_param:
+		result = ice_vc_cfg_mac(vf, vsi, &al->list[i]);
+		if (result == -EEXIST || result == -ENOENT) {
+			continue;
+		} else if (result) {
+			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+			goto handle_mac_exit;
+		}
+	}
+
+handle_mac_exit:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
-				     (u8 *)&stats, sizeof(stats));
+	return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
 }
 
 /**
- * ice_vc_validate_vqs_bitmaps - validate Rx/Tx queue bitmaps from VIRTCHNL
- * @vqs: virtchnl_queue_select structure containing bitmaps to validate
+ * ice_vc_add_mac_addr_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
  *
- * Return true on successful validation, else false
+ * add guest MAC address filter
  */
-static bool ice_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
+static int ice_vc_add_mac_addr_msg(struct ice_vf *vf, u8 *msg)
 {
-	if ((!vqs->rx_queues && !vqs->tx_queues) ||
-	    vqs->rx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF) ||
-	    vqs->tx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF))
-		return false;
-
-	return true;
+	return ice_vc_handle_mac_addr_msg(vf, msg, true);
 }
 
 /**
- * ice_vf_ena_txq_interrupt - enable Tx queue interrupt via QINT_TQCTL
- * @vsi: VSI of the VF to configure
- * @q_idx: VF queue index used to determine the queue in the PF's space
- */
-static void ice_vf_ena_txq_interrupt(struct ice_vsi *vsi, u32 q_idx)
-{
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 pfq = vsi->txq_map[q_idx];
-	u32 reg;
-
-	reg = rd32(hw, QINT_TQCTL(pfq));
-
-	/* MSI-X index 0 in the VF's space is always for the OICR, which means
-	 * this is most likely a poll mode VF driver, so don't enable an
-	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
-	 */
-	if (!(reg & QINT_TQCTL_MSIX_INDX_M))
-		return;
-
-	wr32(hw, QINT_TQCTL(pfq), reg | QINT_TQCTL_CAUSE_ENA_M);
-}
-
-/**
- * ice_vf_ena_rxq_interrupt - enable Tx queue interrupt via QINT_RQCTL
- * @vsi: VSI of the VF to configure
- * @q_idx: VF queue index used to determine the queue in the PF's space
+ * ice_vc_del_mac_addr_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
+ *
+ * remove guest MAC address filter
  */
-static void ice_vf_ena_rxq_interrupt(struct ice_vsi *vsi, u32 q_idx)
+static int ice_vc_del_mac_addr_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 pfq = vsi->rxq_map[q_idx];
-	u32 reg;
-
-	reg = rd32(hw, QINT_RQCTL(pfq));
-
-	/* MSI-X index 0 in the VF's space is always for the OICR, which means
-	 * this is most likely a poll mode VF driver, so don't enable an
-	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
-	 */
-	if (!(reg & QINT_RQCTL_MSIX_INDX_M))
-		return;
-
-	wr32(hw, QINT_RQCTL(pfq), reg | QINT_RQCTL_CAUSE_ENA_M);
+	return ice_vc_handle_mac_addr_msg(vf, msg, false);
 }
 
 /**
- * ice_vc_ena_qs_msg
+ * ice_vc_request_qs_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  *
- * called from the VF to enable all or specific queue(s)
+ * VFs get a default number of queues but can use this message to request a
+ * different number. If the request is successful, PF will reset the VF and
+ * return 0. If unsuccessful, PF will send message informing VF of number of
+ * available queue pairs via virtchnl message response to VF.
  */
-static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
+static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_queue_select *vqs =
-	    (struct virtchnl_queue_select *)msg;
-	struct ice_vsi *vsi;
-	unsigned long q_map;
-	u16 vf_q_id;
+	struct virtchnl_vf_res_request *vfres =
+		(struct virtchnl_vf_res_request *)msg;
+	u16 req_queues = vfres->num_queue_pairs;
+	struct ice_pf *pf = vf->pf;
+	u16 max_allowed_vf_queues;
+	u16 tx_rx_queue_left;
+	struct device *dev;
+	u16 cur_queues;
 
+	dev = ice_pf_to_dev(pf);
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+	cur_queues = vf->num_vf_qs;
+	tx_rx_queue_left = min_t(u16, ice_get_avail_txq_count(pf),
+				 ice_get_avail_rxq_count(pf));
+	max_allowed_vf_queues = tx_rx_queue_left + cur_queues;
+	if (!req_queues) {
+		dev_err(dev, "VF %d tried to request 0 queues. Ignoring.\n",
+			vf->vf_id);
+	} else if (req_queues > ICE_MAX_RSS_QS_PER_VF) {
+		dev_err(dev, "VF %d tried to request more than %d queues.\n",
+			vf->vf_id, ICE_MAX_RSS_QS_PER_VF);
+		vfres->num_queue_pairs = ICE_MAX_RSS_QS_PER_VF;
+	} else if (req_queues > cur_queues &&
+		   req_queues - cur_queues > tx_rx_queue_left) {
+		dev_warn(dev, "VF %d requested %u more queues, but only %u left.\n",
+			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
+		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
+					       ICE_MAX_RSS_QS_PER_VF);
+	} else {
+		/* request is successful, then reset VF */
+		vf->num_req_qs = req_queues;
+		ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
+		dev_info(dev, "VF %d granted request of %u queues.\n",
+			 vf->vf_id, req_queues);
+		return 0;
 	}
 
-	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+error_param:
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
+				     v_ret, (u8 *)vfres, sizeof(*vfres));
+}
 
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+/**
+ * ice_vf_vlan_offload_ena - determine if capabilities support VLAN offloads
+ * @caps: VF driver negotiated capabilities
+ *
+ * Return true if VIRTCHNL_VF_OFFLOAD_VLAN capability is set, else return false
+ */
+static bool ice_vf_vlan_offload_ena(u32 caps)
+{
+	return !!(caps & VIRTCHNL_VF_OFFLOAD_VLAN);
+}
 
-	/* Enable only Rx rings, Tx rings were enabled by the FW when the
-	 * Tx queue group list was configured and the context bits were
-	 * programmed using ice_vsi_cfg_txqs
-	 */
-	q_map = vqs->rx_queues;
-	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
+/**
+ * ice_is_vlan_promisc_allowed - check if VLAN promiscuous config is allowed
+ * @vf: VF used to determine if VLAN promiscuous config is allowed
+ */
+static bool ice_is_vlan_promisc_allowed(struct ice_vf *vf)
+{
+	if ((test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
+	     test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) &&
+	    test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, vf->pf->flags))
+		return true;
 
-		/* Skip queue if enabled */
-		if (test_bit(vf_q_id, vf->rxq_ena))
-			continue;
+	return false;
+}
 
-		if (ice_vsi_ctrl_one_rx_ring(vsi, true, vf_q_id, true)) {
-			dev_err(ice_pf_to_dev(vsi->back), "Failed to enable Rx ring %d on VSI %d\n",
-				vf_q_id, vsi->vsi_num);
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
+/**
+ * ice_vf_ena_vlan_promisc - Enable Tx/Rx VLAN promiscuous for the VLAN
+ * @vsi: VF's VSI used to enable VLAN promiscuous mode
+ * @vlan: VLAN used to enable VLAN promiscuous
+ *
+ * This function should only be called if VLAN promiscuous mode is allowed,
+ * which can be determined via ice_is_vlan_promisc_allowed().
+ */
+static int ice_vf_ena_vlan_promisc(struct ice_vsi *vsi, struct ice_vlan *vlan)
+{
+	u8 promisc_m = ICE_PROMISC_VLAN_TX | ICE_PROMISC_VLAN_RX;
+	int status;
 
-		ice_vf_ena_rxq_interrupt(vsi, vf_q_id);
-		set_bit(vf_q_id, vf->rxq_ena);
-	}
+	status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m,
+					  vlan->vid);
+	if (status && status != -EEXIST)
+		return status;
 
-	q_map = vqs->tx_queues;
-	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
+	return 0;
+}
 
-		/* Skip queue if enabled */
-		if (test_bit(vf_q_id, vf->txq_ena))
-			continue;
+/**
+ * ice_vf_dis_vlan_promisc - Disable Tx/Rx VLAN promiscuous for the VLAN
+ * @vsi: VF's VSI used to disable VLAN promiscuous mode for
+ * @vlan: VLAN used to disable VLAN promiscuous
+ *
+ * This function should only be called if VLAN promiscuous mode is allowed,
+ * which can be determined via ice_is_vlan_promisc_allowed().
+ */
+static int ice_vf_dis_vlan_promisc(struct ice_vsi *vsi, struct ice_vlan *vlan)
+{
+	u8 promisc_m = ICE_PROMISC_VLAN_TX | ICE_PROMISC_VLAN_RX;
+	int status;
 
-		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
-		set_bit(vf_q_id, vf->txq_ena);
-	}
+	status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m,
+					    vlan->vid);
+	if (status && status != -ENOENT)
+		return status;
 
-	/* Set flag to indicate that queues are enabled */
-	if (v_ret == VIRTCHNL_STATUS_SUCCESS)
-		set_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
+	return 0;
+}
 
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
-				     NULL, 0);
+/**
+ * ice_vf_has_max_vlans - check if VF already has the max allowed VLAN filters
+ * @vf: VF to check against
+ * @vsi: VF's VSI
+ *
+ * If the VF is trusted then the VF is allowed to add as many VLANs as it
+ * wants to, so return false.
+ *
+ * When the VF is untrusted compare the number of non-zero VLANs + 1 to the max
+ * allowed VLANs for an untrusted VF. Return the result of this comparison.
+ */
+static bool ice_vf_has_max_vlans(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	if (ice_is_vf_trusted(vf))
+		return false;
+
+#define ICE_VF_ADDED_VLAN_ZERO_FLTRS	1
+	return ((ice_vsi_num_non_zero_vlans(vsi) +
+		ICE_VF_ADDED_VLAN_ZERO_FLTRS) >= ICE_MAX_VLAN_PER_VF);
 }
 
 /**
- * ice_vc_dis_qs_msg
+ * ice_vc_process_vlan_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
+ * @add_v: Add VLAN if true, otherwise delete VLAN
  *
- * called from the VF to disable all or specific
- * queue(s)
+ * Process virtchnl op to add or remove programmed guest VLAN ID
  */
-static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
+static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_queue_select *vqs =
-	    (struct virtchnl_queue_select *)msg;
+	struct virtchnl_vlan_filter_list *vfl =
+	    (struct virtchnl_vlan_filter_list *)msg;
+	struct ice_pf *pf = vf->pf;
+	bool vlan_promisc = false;
 	struct ice_vsi *vsi;
-	unsigned long q_map;
-	u16 vf_q_id;
+	struct device *dev;
+	int status = 0;
+	int i;
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) &&
-	    !test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states)) {
+	dev = ice_pf_to_dev(pf);
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, vqs->vsi_id)) {
+	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
+	if (!ice_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
+	for (i = 0; i < vfl->num_elements; i++) {
+		if (vfl->vlan_id[i] >= VLAN_N_VID) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			dev_err(dev, "invalid VF VLAN id %d\n",
+				vfl->vlan_id[i]);
+			goto error_param;
+		}
+	}
+
 	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (vqs->tx_queues) {
-		q_map = vqs->tx_queues;
+	if (add_v && ice_vf_has_max_vlans(vf, vsi)) {
+		dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
+			 vf->vf_id);
+		/* There is no need to let VF know about being not trusted,
+		 * so we can just return success message here
+		 */
+		goto error_param;
+	}
 
-		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			struct ice_tx_ring *ring = vsi->tx_rings[vf_q_id];
-			struct ice_txq_meta txq_meta = { 0 };
+	/* in DVM a VF can add/delete inner VLAN filters when
+	 * VIRTCHNL_VF_OFFLOAD_VLAN is negotiated, so only reject in SVM
+	 */
+	if (ice_vf_is_port_vlan_ena(vf) && !ice_is_dvm_ena(&pf->hw)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	/* in DVM VLAN promiscuous is based on the outer VLAN, which would be
+	 * the port VLAN if VIRTCHNL_VF_OFFLOAD_VLAN was negotiated, so only
+	 * allow vlan_promisc = true in SVM and if no port VLAN is configured
+	 */
+	vlan_promisc = ice_is_vlan_promisc_allowed(vf) &&
+		!ice_is_dvm_ena(&pf->hw) &&
+		!ice_vf_is_port_vlan_ena(vf);
+
+	if (add_v) {
+		for (i = 0; i < vfl->num_elements; i++) {
+			u16 vid = vfl->vlan_id[i];
+			struct ice_vlan vlan;
+
+			if (ice_vf_has_max_vlans(vf, vsi)) {
+				dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
+					 vf->vf_id);
+				/* There is no need to let VF know about being
+				 * not trusted, so we can just return success
+				 * message here as well.
+				 */
 				goto error_param;
 			}
 
-			/* Skip queue if not enabled */
-			if (!test_bit(vf_q_id, vf->txq_ena))
+			/* we add VLAN 0 by default for each VF so we can enable
+			 * Tx VLAN anti-spoof without triggering MDD events so
+			 * we don't need to add it again here
+			 */
+			if (!vid)
 				continue;
 
-			ice_fill_txq_meta(vsi, ring, &txq_meta);
-
-			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
-						 ring, &txq_meta)) {
-				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
-					vf_q_id, vsi->vsi_num);
+			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
+			status = vsi->inner_vlan_ops.add_vlan(vsi, &vlan);
+			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
 
-			/* Clear enabled queues flag */
-			clear_bit(vf_q_id, vf->txq_ena);
-		}
-	}
-
-	q_map = vqs->rx_queues;
-	/* speed up Rx queue disable by batching them if possible */
-	if (q_map &&
-	    bitmap_equal(&q_map, vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF)) {
-		if (ice_vsi_stop_all_rx_rings(vsi)) {
-			dev_err(ice_pf_to_dev(vsi->back), "Failed to stop all Rx rings on VSI %d\n",
-				vsi->vsi_num);
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
+			/* Enable VLAN filtering on first non-zero VLAN */
+			if (!vlan_promisc && vid && !ice_is_dvm_ena(&pf->hw)) {
+				if (vsi->inner_vlan_ops.ena_rx_filtering(vsi)) {
+					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
+						vid, status);
+					goto error_param;
+				}
+			} else if (vlan_promisc) {
+				status = ice_vf_ena_vlan_promisc(vsi, &vlan);
+				if (status) {
+					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+					dev_err(dev, "Enable Unicast/multicast promiscuous mode on VLAN ID:%d failed error-%d\n",
+						vid, status);
+				}
+			}
 		}
+	} else {
+		/* In case of non_trusted VF, number of VLAN elements passed
+		 * to PF for removal might be greater than number of VLANs
+		 * filter programmed for that VF - So, use actual number of
+		 * VLANS added earlier with add VLAN opcode. In order to avoid
+		 * removing VLAN that doesn't exist, which result to sending
+		 * erroneous failed message back to the VF
+		 */
+		int num_vf_vlan;
 
-		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
-	} else if (q_map) {
-		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
+		num_vf_vlan = vsi->num_vlan;
+		for (i = 0; i < vfl->num_elements && i < num_vf_vlan; i++) {
+			u16 vid = vfl->vlan_id[i];
+			struct ice_vlan vlan;
 
-			/* Skip queue if not enabled */
-			if (!test_bit(vf_q_id, vf->rxq_ena))
+			/* we add VLAN 0 by default for each VF so we can enable
+			 * Tx VLAN anti-spoof without triggering MDD events so
+			 * we don't want a VIRTCHNL request to remove it
+			 */
+			if (!vid)
 				continue;
 
-			if (ice_vsi_ctrl_one_rx_ring(vsi, false, vf_q_id,
-						     true)) {
-				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Rx ring %d on VSI %d\n",
-					vf_q_id, vsi->vsi_num);
+			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
+			status = vsi->inner_vlan_ops.del_vlan(vsi, &vlan);
+			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
 
-			/* Clear enabled queues flag */
-			clear_bit(vf_q_id, vf->rxq_ena);
+			/* Disable VLAN filtering when only VLAN 0 is left */
+			if (!ice_vsi_has_non_zero_vlans(vsi))
+				vsi->inner_vlan_ops.dis_rx_filtering(vsi);
+
+			if (vlan_promisc)
+				ice_vf_dis_vlan_promisc(vsi, &vlan);
 		}
 	}
 
-	/* Clear enabled queues flag */
-	if (v_ret == VIRTCHNL_STATUS_SUCCESS && ice_vf_has_no_qs_ena(vf))
-		clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
-
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
-				     NULL, 0);
+	if (add_v)
+		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
+					     NULL, 0);
+	else
+		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
+					     NULL, 0);
 }
 
 /**
- * ice_cfg_interrupt
+ * ice_vc_add_vlan_msg
  * @vf: pointer to the VF info
- * @vsi: the VSI being configured
- * @vector_id: vector ID
- * @map: vector map for mapping vectors to queues
- * @q_vector: structure for interrupt vector
- * configure the IRQ to queue map
+ * @msg: pointer to the msg buffer
+ *
+ * Add and program guest VLAN ID
  */
-static int
-ice_cfg_interrupt(struct ice_vf *vf, struct ice_vsi *vsi, u16 vector_id,
-		  struct virtchnl_vector_map *map,
-		  struct ice_q_vector *q_vector)
+static int ice_vc_add_vlan_msg(struct ice_vf *vf, u8 *msg)
 {
-	u16 vsi_q_id, vsi_q_id_idx;
-	unsigned long qmap;
-
-	q_vector->num_ring_rx = 0;
-	q_vector->num_ring_tx = 0;
-
-	qmap = map->rxq_map;
-	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
-		vsi_q_id = vsi_q_id_idx;
-
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
-			return VIRTCHNL_STATUS_ERR_PARAM;
-
-		q_vector->num_ring_rx++;
-		q_vector->rx.itr_idx = map->rxitr_idx;
-		vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
-		ice_cfg_rxq_interrupt(vsi, vsi_q_id, vector_id,
-				      q_vector->rx.itr_idx);
-	}
-
-	qmap = map->txq_map;
-	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
-		vsi_q_id = vsi_q_id_idx;
-
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
-			return VIRTCHNL_STATUS_ERR_PARAM;
-
-		q_vector->num_ring_tx++;
-		q_vector->tx.itr_idx = map->txitr_idx;
-		vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
-		ice_cfg_txq_interrupt(vsi, vsi_q_id, vector_id,
-				      q_vector->tx.itr_idx);
-	}
-
-	return VIRTCHNL_STATUS_SUCCESS;
+	return ice_vc_process_vlan_msg(vf, msg, true);
 }
 
 /**
- * ice_vc_cfg_irq_map_msg
+ * ice_vc_remove_vlan_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  *
- * called from the VF to configure the IRQ to queue map
+ * remove programmed guest VLAN ID
  */
-static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
+static int ice_vc_remove_vlan_msg(struct ice_vf *vf, u8 *msg)
+{
+	return ice_vc_process_vlan_msg(vf, msg, false);
+}
+
+/**
+ * ice_vc_ena_vlan_stripping
+ * @vf: pointer to the VF info
+ *
+ * Enable VLAN header stripping for a given VF
+ */
+static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	u16 num_q_vectors_mapped, vsi_id, vector_id;
-	struct virtchnl_irq_map_info *irqmap_info;
-	struct virtchnl_vector_map *map;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int i;
-
-	irqmap_info = (struct virtchnl_irq_map_info *)msg;
-	num_q_vectors_mapped = irqmap_info->num_vectors;
 
-	/* Check to make sure number of VF vectors mapped is not greater than
-	 * number of VF vectors originally allocated, and check that
-	 * there is actually at least a single VF queue vector mapped
-	 */
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    pf->vfs.num_msix_per < num_q_vectors_mapped ||
-	    !num_q_vectors_mapped) {
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
+	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	for (i = 0; i < num_q_vectors_mapped; i++) {
-		struct ice_q_vector *q_vector;
+	vsi = ice_get_vf_vsi(vf);
+	if (vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
-		map = &irqmap_info->vecmap[i];
-
-		vector_id = map->vector_id;
-		vsi_id = map->vsi_id;
-		/* vector_id is always 0-based for each VF, and can never be
-		 * larger than or equal to the max allowed interrupts per VF
-		 */
-		if (!(vector_id < pf->vfs.num_msix_per) ||
-		    !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
-		    (!vector_id && (map->rxq_map || map->txq_map))) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* No need to map VF miscellaneous or rogue vector */
-		if (!vector_id)
-			continue;
-
-		/* Subtract non queue vector from vector_id passed by VF
-		 * to get actual number of VSI queue vector array index
-		 */
-		q_vector = vsi->q_vectors[vector_id - ICE_NONQ_VECS_VF];
-		if (!q_vector) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* lookout for the invalid queue index */
-		v_ret = (enum virtchnl_status_code)
-			ice_cfg_interrupt(vf, vsi, vector_id, map, q_vector);
-		if (v_ret)
-			goto error_param;
-	}
-
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
-				     NULL, 0);
-}
+error_param:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
+				     v_ret, NULL, 0);
+}
 
 /**
- * ice_vc_cfg_qs_msg
+ * ice_vc_dis_vlan_stripping
  * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
  *
- * called from the VF to configure the Rx/Tx queues
+ * Disable VLAN header stripping for a given VF
  */
-static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
+static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vsi_queue_config_info *qci =
-	    (struct virtchnl_vsi_queue_config_info *)msg;
-	struct virtchnl_queue_pair_info *qpi;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int i, q_idx;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
+	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -2820,2871 +2395,1391 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
-	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
-		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
-			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
+	if (vsi->inner_vlan_ops.dis_stripping(vsi))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	for (i = 0; i < qci->num_queue_pairs; i++) {
-		qpi = &qci->qpair[i];
-		if (qpi->txq.vsi_id != qci->vsi_id ||
-		    qpi->rxq.vsi_id != qci->vsi_id ||
-		    qpi->rxq.queue_id != qpi->txq.queue_id ||
-		    qpi->txq.headwb_enabled ||
-		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
-		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
-		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		q_idx = qpi->rxq.queue_id;
-
-		/* make sure selected "q_idx" is in valid range of queues
-		 * for selected "vsi"
-		 */
-		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		/* copy Tx queue info from VF into VSI */
-		if (qpi->txq.ring_len > 0) {
-			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
-			vsi->tx_rings[i]->count = qpi->txq.ring_len;
-			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-		}
-
-		/* copy Rx queue info from VF into VSI */
-		if (qpi->rxq.ring_len > 0) {
-			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
-
-			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
-			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
-
-			if (qpi->rxq.databuffer_size != 0 &&
-			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-			     qpi->rxq.databuffer_size < 1024)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-			vsi->rx_buf_len = qpi->rxq.databuffer_size;
-			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
-			if (qpi->rxq.max_pkt_size > max_frame_size ||
-			    qpi->rxq.max_pkt_size < 64) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-
-			vsi->max_frame = qpi->rxq.max_pkt_size;
-			/* add space for the port VLAN since the VF driver is
-			 * not expected to account for it in the MTU
-			 * calculation
-			 */
-			if (ice_vf_is_port_vlan_ena(vf))
-				vsi->max_frame += VLAN_HLEN;
-
-			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-		}
-	}
 
 error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
+				     v_ret, NULL, 0);
 }
 
 /**
- * ice_can_vf_change_mac
- * @vf: pointer to the VF info
+ * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
+ * @vf: VF to enable/disable VLAN stripping for on initialization
  *
- * Return true if the VF is allowed to change its MAC filters, false otherwise
+ * Set the default for VLAN stripping based on whether a port VLAN is configured
+ * and the current VLAN mode of the device.
  */
-static bool ice_can_vf_change_mac(struct ice_vf *vf)
+static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 {
-	/* If the VF MAC address has been set administratively (via the
-	 * ndo_set_vf_mac command), then deny permission to the VF to
-	 * add/delete unicast MAC addresses, unless the VF is trusted
-	 */
-	if (vf->pf_set_mac && !ice_is_vf_trusted(vf))
-		return false;
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
-	return true;
-}
+	if (!vsi)
+		return -EINVAL;
 
-/**
- * ice_vc_ether_addr_type - get type of virtchnl_ether_addr
- * @vc_ether_addr: used to extract the type
- */
-static u8
-ice_vc_ether_addr_type(struct virtchnl_ether_addr *vc_ether_addr)
-{
-	return (vc_ether_addr->type & VIRTCHNL_ETHER_ADDR_TYPE_MASK);
+	/* don't modify stripping if port VLAN is configured in SVM since the
+	 * port VLAN is based on the inner/single VLAN in SVM
+	 */
+	if (ice_vf_is_port_vlan_ena(vf) && !ice_is_dvm_ena(&vsi->back->hw))
+		return 0;
+
+	if (ice_vf_vlan_offload_ena(vf->driver_caps))
+		return vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
+	else
+		return vsi->inner_vlan_ops.dis_stripping(vsi);
 }
 
-/**
- * ice_is_vc_addr_legacy - check if the MAC address is from an older VF
- * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
- */
-static bool
-ice_is_vc_addr_legacy(struct virtchnl_ether_addr *vc_ether_addr)
+static u16 ice_vc_get_max_vlan_fltrs(struct ice_vf *vf)
 {
-	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
-
-	return (type == VIRTCHNL_ETHER_ADDR_LEGACY);
+	if (vf->trusted)
+		return VLAN_N_VID;
+	else
+		return ICE_MAX_VLAN_PER_VF;
 }
 
 /**
- * ice_is_vc_addr_primary - check if the MAC address is the VF's primary MAC
- * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
+ * ice_vf_outer_vlan_not_allowed - check if outer VLAN can be used
+ * @vf: VF that being checked for
  *
- * This function should only be called when the MAC address in
- * virtchnl_ether_addr is a valid unicast MAC
+ * When the device is in double VLAN mode, check whether or not the outer VLAN
+ * is allowed.
  */
-static bool
-ice_is_vc_addr_primary(struct virtchnl_ether_addr __maybe_unused *vc_ether_addr)
+static bool ice_vf_outer_vlan_not_allowed(struct ice_vf *vf)
 {
-	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
+	if (ice_vf_is_port_vlan_ena(vf))
+		return true;
 
-	return (type == VIRTCHNL_ETHER_ADDR_PRIMARY);
+	return false;
 }
 
 /**
- * ice_vfhw_mac_add - update the VF's cached hardware MAC if allowed
- * @vf: VF to update
- * @vc_ether_addr: structure from VIRTCHNL with MAC to add
+ * ice_vc_set_dvm_caps - set VLAN capabilities when the device is in DVM
+ * @vf: VF that capabilities are being set for
+ * @caps: VLAN capabilities to populate
+ *
+ * Determine VLAN capabilities support based on whether a port VLAN is
+ * configured. If a port VLAN is configured then the VF should use the inner
+ * filtering/offload capabilities since the port VLAN is using the outer VLAN
+ * capabilies.
  */
 static void
-ice_vfhw_mac_add(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
+ice_vc_set_dvm_caps(struct ice_vf *vf, struct virtchnl_vlan_caps *caps)
 {
-	u8 *mac_addr = vc_ether_addr->addr;
+	struct virtchnl_vlan_supported_caps *supported_caps;
 
-	if (!is_valid_ether_addr(mac_addr))
-		return;
+	if (ice_vf_outer_vlan_not_allowed(vf)) {
+		/* until support for inner VLAN filtering is added when a port
+		 * VLAN is configured, only support software offloaded inner
+		 * VLANs when a port VLAN is confgured in DVM
+		 */
+		supported_caps = &caps->filtering.filtering_support;
+		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
 
-	/* only allow legacy VF drivers to set the device and hardware MAC if it
-	 * is zero and allow new VF drivers to set the hardware MAC if the type
-	 * was correctly specified over VIRTCHNL
-	 */
-	if ((ice_is_vc_addr_legacy(vc_ether_addr) &&
-	     is_zero_ether_addr(vf->hw_lan_addr.addr)) ||
-	    ice_is_vc_addr_primary(vc_ether_addr)) {
-		ether_addr_copy(vf->dev_lan_addr.addr, mac_addr);
-		ether_addr_copy(vf->hw_lan_addr.addr, mac_addr);
-	}
+		supported_caps = &caps->offloads.stripping_support;
+		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
 
-	/* hardware and device MACs are already set, but its possible that the
-	 * VF driver sent the VIRTCHNL_OP_ADD_ETH_ADDR message before the
-	 * VIRTCHNL_OP_DEL_ETH_ADDR when trying to update its MAC, so save it
-	 * away for the legacy VF driver case as it will be updated in the
-	 * delete flow for this case
-	 */
-	if (ice_is_vc_addr_legacy(vc_ether_addr)) {
-		ether_addr_copy(vf->legacy_last_added_umac.addr,
-				mac_addr);
-		vf->legacy_last_added_umac.time_modified = jiffies;
-	}
-}
+		supported_caps = &caps->offloads.insertion_support;
+		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
 
-/**
- * ice_vc_add_mac_addr - attempt to add the MAC address passed in
- * @vf: pointer to the VF info
- * @vsi: pointer to the VF's VSI
- * @vc_ether_addr: VIRTCHNL MAC address structure used to add MAC
- */
-static int
-ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
-		    struct virtchnl_ether_addr *vc_ether_addr)
-{
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	u8 *mac_addr = vc_ether_addr->addr;
-	int ret;
-
-	/* device MAC already added */
-	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
-		return 0;
+		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
+		caps->offloads.ethertype_match =
+			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
+	} else {
+		supported_caps = &caps->filtering.filtering_support;
+		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
+		supported_caps->outer = VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+					VIRTCHNL_VLAN_ETHERTYPE_9100 |
+					VIRTCHNL_VLAN_ETHERTYPE_AND;
+		caps->filtering.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100 |
+						 VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+						 VIRTCHNL_VLAN_ETHERTYPE_9100;
 
-	if (is_unicast_ether_addr(mac_addr) && !ice_can_vf_change_mac(vf)) {
-		dev_err(dev, "VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
-		return -EPERM;
-	}
+		supported_caps = &caps->offloads.stripping_support;
+		supported_caps->inner = VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
+		supported_caps->outer = VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+					VIRTCHNL_VLAN_ETHERTYPE_9100 |
+					VIRTCHNL_VLAN_ETHERTYPE_XOR |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2;
 
-	ret = ice_fltr_add_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
-	if (ret == -EEXIST) {
-		dev_dbg(dev, "MAC %pM already exists for VF %d\n", mac_addr,
-			vf->vf_id);
-		/* don't return since we might need to update
-		 * the primary MAC in ice_vfhw_mac_add() below
-		 */
-	} else if (ret) {
-		dev_err(dev, "Failed to add MAC %pM for VF %d\n, error %d\n",
-			mac_addr, vf->vf_id, ret);
-		return ret;
-	} else {
-		vf->num_mac++;
-	}
+		supported_caps = &caps->offloads.insertion_support;
+		supported_caps->inner = VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
+		supported_caps->outer = VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+					VIRTCHNL_VLAN_ETHERTYPE_9100 |
+					VIRTCHNL_VLAN_ETHERTYPE_XOR |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2;
 
-	ice_vfhw_mac_add(vf, vc_ether_addr);
+		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
 
-	return ret;
-}
+		caps->offloads.ethertype_match =
+			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
+	}
 
-/**
- * ice_is_legacy_umac_expired - check if last added legacy unicast MAC expired
- * @last_added_umac: structure used to check expiration
- */
-static bool ice_is_legacy_umac_expired(struct ice_time_mac *last_added_umac)
-{
-#define ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME	msecs_to_jiffies(3000)
-	return time_is_before_jiffies(last_added_umac->time_modified +
-				      ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME);
+	caps->filtering.max_filters = ice_vc_get_max_vlan_fltrs(vf);
 }
 
 /**
- * ice_update_legacy_cached_mac - update cached hardware MAC for legacy VF
- * @vf: VF to update
- * @vc_ether_addr: structure from VIRTCHNL with MAC to check
+ * ice_vc_set_svm_caps - set VLAN capabilities when the device is in SVM
+ * @vf: VF that capabilities are being set for
+ * @caps: VLAN capabilities to populate
  *
- * only update cached hardware MAC for legacy VF drivers on delete
- * because we cannot guarantee order/type of MAC from the VF driver
+ * Determine VLAN capabilities support based on whether a port VLAN is
+ * configured. If a port VLAN is configured then the VF does not have any VLAN
+ * filtering or offload capabilities since the port VLAN is using the inner VLAN
+ * capabilities in single VLAN mode (SVM). Otherwise allow the VF to use inner
+ * VLAN fitlering and offload capabilities.
  */
 static void
-ice_update_legacy_cached_mac(struct ice_vf *vf,
-			     struct virtchnl_ether_addr *vc_ether_addr)
+ice_vc_set_svm_caps(struct ice_vf *vf, struct virtchnl_vlan_caps *caps)
 {
-	if (!ice_is_vc_addr_legacy(vc_ether_addr) ||
-	    ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
-		return;
+	struct virtchnl_vlan_supported_caps *supported_caps;
 
-	ether_addr_copy(vf->dev_lan_addr.addr, vf->legacy_last_added_umac.addr);
-	ether_addr_copy(vf->hw_lan_addr.addr, vf->legacy_last_added_umac.addr);
-}
+	if (ice_vf_is_port_vlan_ena(vf)) {
+		supported_caps = &caps->filtering.filtering_support;
+		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
 
-/**
- * ice_vfhw_mac_del - update the VF's cached hardware MAC if allowed
- * @vf: VF to update
- * @vc_ether_addr: structure from VIRTCHNL with MAC to delete
- */
-static void
-ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
-{
-	u8 *mac_addr = vc_ether_addr->addr;
+		supported_caps = &caps->offloads.stripping_support;
+		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
 
-	if (!is_valid_ether_addr(mac_addr) ||
-	    !ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
-		return;
+		supported_caps = &caps->offloads.insertion_support;
+		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
 
-	/* allow the device MAC to be repopulated in the add flow and don't
-	 * clear the hardware MAC (i.e. hw_lan_addr.addr) here as that is meant
-	 * to be persistent on VM reboot and across driver unload/load, which
-	 * won't work if we clear the hardware MAC here
-	 */
-	eth_zero_addr(vf->dev_lan_addr.addr);
+		caps->offloads.ethertype_init = VIRTCHNL_VLAN_UNSUPPORTED;
+		caps->offloads.ethertype_match = VIRTCHNL_VLAN_UNSUPPORTED;
+		caps->filtering.max_filters = 0;
+	} else {
+		supported_caps = &caps->filtering.filtering_support;
+		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
+		caps->filtering.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
 
-	ice_update_legacy_cached_mac(vf, vc_ether_addr);
+		supported_caps = &caps->offloads.stripping_support;
+		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
+
+		supported_caps = &caps->offloads.insertion_support;
+		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
+					VIRTCHNL_VLAN_TOGGLE |
+					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
+		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
+
+		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
+		caps->offloads.ethertype_match =
+			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
+		caps->filtering.max_filters = ice_vc_get_max_vlan_fltrs(vf);
+	}
 }
 
 /**
- * ice_vc_del_mac_addr - attempt to delete the MAC address passed in
- * @vf: pointer to the VF info
- * @vsi: pointer to the VF's VSI
- * @vc_ether_addr: VIRTCHNL MAC address structure used to delete MAC
+ * ice_vc_get_offload_vlan_v2_caps - determine VF's VLAN capabilities
+ * @vf: VF to determine VLAN capabilities for
+ *
+ * This will only be called if the VF and PF successfully negotiated
+ * VIRTCHNL_VF_OFFLOAD_VLAN_V2.
+ *
+ * Set VLAN capabilities based on the current VLAN mode and whether a port VLAN
+ * is configured or not.
  */
-static int
-ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
-		    struct virtchnl_ether_addr *vc_ether_addr)
+static int ice_vc_get_offload_vlan_v2_caps(struct ice_vf *vf)
 {
-	struct device *dev = ice_pf_to_dev(vf->pf);
-	u8 *mac_addr = vc_ether_addr->addr;
-	int status;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vlan_caps *caps = NULL;
+	int err, len = 0;
 
-	if (!ice_can_vf_change_mac(vf) &&
-	    ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
-		return 0;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	status = ice_fltr_remove_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
-	if (status == -ENOENT) {
-		dev_err(dev, "MAC %pM does not exist for VF %d\n", mac_addr,
-			vf->vf_id);
-		return -ENOENT;
-	} else if (status) {
-		dev_err(dev, "Failed to delete MAC %pM for VF %d, error %d\n",
-			mac_addr, vf->vf_id, status);
-		return -EIO;
+	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
+	if (!caps) {
+		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		goto out;
 	}
+	len = sizeof(*caps);
 
-	ice_vfhw_mac_del(vf, vc_ether_addr);
+	if (ice_is_dvm_ena(&vf->pf->hw))
+		ice_vc_set_dvm_caps(vf, caps);
+	else
+		ice_vc_set_svm_caps(vf, caps);
 
-	vf->num_mac--;
+	/* store negotiated caps to prevent invalid VF messages */
+	memcpy(&vf->vlan_v2_caps, caps, sizeof(*caps));
 
-	return 0;
+out:
+	err = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
+				    v_ret, (u8 *)caps, len);
+	kfree(caps);
+	return err;
 }
 
 /**
- * ice_vc_handle_mac_addr_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- * @set: true if MAC filters are being set, false otherwise
+ * ice_vc_validate_vlan_tpid - validate VLAN TPID
+ * @filtering_caps: negotiated/supported VLAN filtering capabilities
+ * @tpid: VLAN TPID used for validation
  *
- * add guest MAC address filter
+ * Convert the VLAN TPID to a VIRTCHNL_VLAN_ETHERTYPE_* and then compare against
+ * the negotiated/supported filtering caps to see if the VLAN TPID is valid.
  */
-static int
-ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
+static bool ice_vc_validate_vlan_tpid(u16 filtering_caps, u16 tpid)
 {
-	int (*ice_vc_cfg_mac)
-		(struct ice_vf *vf, struct ice_vsi *vsi,
-		 struct virtchnl_ether_addr *virtchnl_ether_addr);
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_ether_addr_list *al =
-	    (struct virtchnl_ether_addr_list *)msg;
-	struct ice_pf *pf = vf->pf;
-	enum virtchnl_ops vc_op;
-	struct ice_vsi *vsi;
-	int i;
+	enum virtchnl_vlan_support vlan_ethertype = VIRTCHNL_VLAN_UNSUPPORTED;
 
-	if (set) {
-		vc_op = VIRTCHNL_OP_ADD_ETH_ADDR;
-		ice_vc_cfg_mac = ice_vc_add_mac_addr;
-	} else {
-		vc_op = VIRTCHNL_OP_DEL_ETH_ADDR;
-		ice_vc_cfg_mac = ice_vc_del_mac_addr;
+	switch (tpid) {
+	case ETH_P_8021Q:
+		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_8100;
+		break;
+	case ETH_P_8021AD:
+		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_88A8;
+		break;
+	case ETH_P_QINQ1:
+		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_9100;
+		break;
 	}
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	/* If this VF is not privileged, then we can't add more than a
-	 * limited number of addresses. Check to make sure that the
-	 * additions do not push us over the limit.
-	 */
-	if (set && !ice_is_vf_trusted(vf) &&
-	    (vf->num_mac + al->num_elements) > ICE_MAX_MACADDR_PER_VF) {
-		dev_err(ice_pf_to_dev(pf), "Can't add more MAC addresses, because VF-%d is not trusted, switch the VF to trusted mode in order to add more functionalities\n",
-			vf->vf_id);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	for (i = 0; i < al->num_elements; i++) {
-		u8 *mac_addr = al->list[i].addr;
-		int result;
-
-		if (is_broadcast_ether_addr(mac_addr) ||
-		    is_zero_ether_addr(mac_addr))
-			continue;
-
-		result = ice_vc_cfg_mac(vf, vsi, &al->list[i]);
-		if (result == -EEXIST || result == -ENOENT) {
-			continue;
-		} else if (result) {
-			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-			goto handle_mac_exit;
-		}
-	}
+	if (!(filtering_caps & vlan_ethertype))
+		return false;
 
-handle_mac_exit:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
+	return true;
 }
 
 /**
- * ice_vc_add_mac_addr_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
+ * ice_vc_is_valid_vlan - validate the virtchnl_vlan
+ * @vc_vlan: virtchnl_vlan to validate
  *
- * add guest MAC address filter
+ * If the VLAN TCI and VLAN TPID are 0, then this filter is invalid, so return
+ * false. Otherwise return true.
  */
-static int ice_vc_add_mac_addr_msg(struct ice_vf *vf, u8 *msg)
+static bool ice_vc_is_valid_vlan(struct virtchnl_vlan *vc_vlan)
 {
-	return ice_vc_handle_mac_addr_msg(vf, msg, true);
-}
+	if (!vc_vlan->tci || !vc_vlan->tpid)
+		return false;
 
-/**
- * ice_vc_del_mac_addr_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * remove guest MAC address filter
- */
-static int ice_vc_del_mac_addr_msg(struct ice_vf *vf, u8 *msg)
-{
-	return ice_vc_handle_mac_addr_msg(vf, msg, false);
+	return true;
 }
 
 /**
- * ice_vc_request_qs_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
+ * ice_vc_validate_vlan_filter_list - validate the filter list from the VF
+ * @vfc: negotiated/supported VLAN filtering capabilities
+ * @vfl: VLAN filter list from VF to validate
  *
- * VFs get a default number of queues but can use this message to request a
- * different number. If the request is successful, PF will reset the VF and
- * return 0. If unsuccessful, PF will send message informing VF of number of
- * available queue pairs via virtchnl message response to VF.
+ * Validate all of the filters in the VLAN filter list from the VF. If any of
+ * the checks fail then return false. Otherwise return true.
  */
-static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
+static bool
+ice_vc_validate_vlan_filter_list(struct virtchnl_vlan_filtering_caps *vfc,
+				 struct virtchnl_vlan_filter_list_v2 *vfl)
 {
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vf_res_request *vfres =
-		(struct virtchnl_vf_res_request *)msg;
-	u16 req_queues = vfres->num_queue_pairs;
-	struct ice_pf *pf = vf->pf;
-	u16 max_allowed_vf_queues;
-	u16 tx_rx_queue_left;
-	struct device *dev;
-	u16 cur_queues;
+	u16 i;
 
-	dev = ice_pf_to_dev(pf);
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
+	if (!vfl->num_elements)
+		return false;
 
-	cur_queues = vf->num_vf_qs;
-	tx_rx_queue_left = min_t(u16, ice_get_avail_txq_count(pf),
-				 ice_get_avail_rxq_count(pf));
-	max_allowed_vf_queues = tx_rx_queue_left + cur_queues;
-	if (!req_queues) {
-		dev_err(dev, "VF %d tried to request 0 queues. Ignoring.\n",
-			vf->vf_id);
-	} else if (req_queues > ICE_MAX_RSS_QS_PER_VF) {
-		dev_err(dev, "VF %d tried to request more than %d queues.\n",
-			vf->vf_id, ICE_MAX_RSS_QS_PER_VF);
-		vfres->num_queue_pairs = ICE_MAX_RSS_QS_PER_VF;
-	} else if (req_queues > cur_queues &&
-		   req_queues - cur_queues > tx_rx_queue_left) {
-		dev_warn(dev, "VF %d requested %u more queues, but only %u left.\n",
-			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
-		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
-					       ICE_MAX_RSS_QS_PER_VF);
-	} else {
-		/* request is successful, then reset VF */
-		vf->num_req_qs = req_queues;
-		ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
-		dev_info(dev, "VF %d granted request of %u queues.\n",
-			 vf->vf_id, req_queues);
-		return 0;
-	}
+	for (i = 0; i < vfl->num_elements; i++) {
+		struct virtchnl_vlan_supported_caps *filtering_support =
+			&vfc->filtering_support;
+		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
+		struct virtchnl_vlan *outer = &vlan_fltr->outer;
+		struct virtchnl_vlan *inner = &vlan_fltr->inner;
 
-error_param:
-	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
-				     v_ret, (u8 *)vfres, sizeof(*vfres));
-}
+		if ((ice_vc_is_valid_vlan(outer) &&
+		     filtering_support->outer == VIRTCHNL_VLAN_UNSUPPORTED) ||
+		    (ice_vc_is_valid_vlan(inner) &&
+		     filtering_support->inner == VIRTCHNL_VLAN_UNSUPPORTED))
+			return false;
 
-/**
- * ice_vf_vlan_offload_ena - determine if capabilities support VLAN offloads
- * @caps: VF driver negotiated capabilities
- *
- * Return true if VIRTCHNL_VF_OFFLOAD_VLAN capability is set, else return false
- */
-static bool ice_vf_vlan_offload_ena(u32 caps)
-{
-	return !!(caps & VIRTCHNL_VF_OFFLOAD_VLAN);
-}
+		if ((outer->tci_mask &&
+		     !(filtering_support->outer & VIRTCHNL_VLAN_FILTER_MASK)) ||
+		    (inner->tci_mask &&
+		     !(filtering_support->inner & VIRTCHNL_VLAN_FILTER_MASK)))
+			return false;
 
-/**
- * ice_is_vlan_promisc_allowed - check if VLAN promiscuous config is allowed
- * @vf: VF used to determine if VLAN promiscuous config is allowed
- */
-static bool ice_is_vlan_promisc_allowed(struct ice_vf *vf)
-{
-	if ((test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
-	     test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) &&
-	    test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, vf->pf->flags))
-		return true;
+		if (((outer->tci & VLAN_PRIO_MASK) &&
+		     !(filtering_support->outer & VIRTCHNL_VLAN_PRIO)) ||
+		    ((inner->tci & VLAN_PRIO_MASK) &&
+		     !(filtering_support->inner & VIRTCHNL_VLAN_PRIO)))
+			return false;
 
-	return false;
+		if ((ice_vc_is_valid_vlan(outer) &&
+		     !ice_vc_validate_vlan_tpid(filtering_support->outer,
+						outer->tpid)) ||
+		    (ice_vc_is_valid_vlan(inner) &&
+		     !ice_vc_validate_vlan_tpid(filtering_support->inner,
+						inner->tpid)))
+			return false;
+	}
+
+	return true;
 }
 
 /**
- * ice_vf_ena_vlan_promisc - Enable Tx/Rx VLAN promiscuous for the VLAN
- * @vsi: VF's VSI used to enable VLAN promiscuous mode
- * @vlan: VLAN used to enable VLAN promiscuous
- *
- * This function should only be called if VLAN promiscuous mode is allowed,
- * which can be determined via ice_is_vlan_promisc_allowed().
+ * ice_vc_to_vlan - transform from struct virtchnl_vlan to struct ice_vlan
+ * @vc_vlan: struct virtchnl_vlan to transform
  */
-static int ice_vf_ena_vlan_promisc(struct ice_vsi *vsi, struct ice_vlan *vlan)
+static struct ice_vlan ice_vc_to_vlan(struct virtchnl_vlan *vc_vlan)
 {
-	u8 promisc_m = ICE_PROMISC_VLAN_TX | ICE_PROMISC_VLAN_RX;
-	int status;
+	struct ice_vlan vlan = { 0 };
 
-	status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m,
-					  vlan->vid);
-	if (status && status != -EEXIST)
-		return status;
+	vlan.prio = (vc_vlan->tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	vlan.vid = vc_vlan->tci & VLAN_VID_MASK;
+	vlan.tpid = vc_vlan->tpid;
 
-	return 0;
+	return vlan;
 }
 
 /**
- * ice_vf_dis_vlan_promisc - Disable Tx/Rx VLAN promiscuous for the VLAN
- * @vsi: VF's VSI used to disable VLAN promiscuous mode for
- * @vlan: VLAN used to disable VLAN promiscuous
- *
- * This function should only be called if VLAN promiscuous mode is allowed,
- * which can be determined via ice_is_vlan_promisc_allowed().
+ * ice_vc_vlan_action - action to perform on the virthcnl_vlan
+ * @vsi: VF's VSI used to perform the action
+ * @vlan_action: function to perform the action with (i.e. add/del)
+ * @vlan: VLAN filter to perform the action with
  */
-static int ice_vf_dis_vlan_promisc(struct ice_vsi *vsi, struct ice_vlan *vlan)
+static int
+ice_vc_vlan_action(struct ice_vsi *vsi,
+		   int (*vlan_action)(struct ice_vsi *, struct ice_vlan *),
+		   struct ice_vlan *vlan)
 {
-	u8 promisc_m = ICE_PROMISC_VLAN_TX | ICE_PROMISC_VLAN_RX;
-	int status;
+	int err;
 
-	status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m,
-					    vlan->vid);
-	if (status && status != -ENOENT)
-		return status;
+	err = vlan_action(vsi, vlan);
+	if (err)
+		return err;
 
 	return 0;
 }
 
 /**
- * ice_vf_has_max_vlans - check if VF already has the max allowed VLAN filters
- * @vf: VF to check against
- * @vsi: VF's VSI
- *
- * If the VF is trusted then the VF is allowed to add as many VLANs as it
- * wants to, so return false.
- *
- * When the VF is untrusted compare the number of non-zero VLANs + 1 to the max
- * allowed VLANs for an untrusted VF. Return the result of this comparison.
+ * ice_vc_del_vlans - delete VLAN(s) from the virtchnl filter list
+ * @vf: VF used to delete the VLAN(s)
+ * @vsi: VF's VSI used to delete the VLAN(s)
+ * @vfl: virthchnl filter list used to delete the filters
  */
-static bool ice_vf_has_max_vlans(struct ice_vf *vf, struct ice_vsi *vsi)
+static int
+ice_vc_del_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
+		 struct virtchnl_vlan_filter_list_v2 *vfl)
 {
-	if (ice_is_vf_trusted(vf))
-		return false;
+	bool vlan_promisc = ice_is_vlan_promisc_allowed(vf);
+	int err;
+	u16 i;
 
-#define ICE_VF_ADDED_VLAN_ZERO_FLTRS	1
-	return ((ice_vsi_num_non_zero_vlans(vsi) +
-		ICE_VF_ADDED_VLAN_ZERO_FLTRS) >= ICE_MAX_VLAN_PER_VF);
-}
+	for (i = 0; i < vfl->num_elements; i++) {
+		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
+		struct virtchnl_vlan *vc_vlan;
+
+		vc_vlan = &vlan_fltr->outer;
+		if (ice_vc_is_valid_vlan(vc_vlan)) {
+			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
+
+			err = ice_vc_vlan_action(vsi,
+						 vsi->outer_vlan_ops.del_vlan,
+						 &vlan);
+			if (err)
+				return err;
+
+			if (vlan_promisc)
+				ice_vf_dis_vlan_promisc(vsi, &vlan);
+		}
+
+		vc_vlan = &vlan_fltr->inner;
+		if (ice_vc_is_valid_vlan(vc_vlan)) {
+			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
+
+			err = ice_vc_vlan_action(vsi,
+						 vsi->inner_vlan_ops.del_vlan,
+						 &vlan);
+			if (err)
+				return err;
+
+			/* no support for VLAN promiscuous on inner VLAN unless
+			 * we are in Single VLAN Mode (SVM)
+			 */
+			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc)
+				ice_vf_dis_vlan_promisc(vsi, &vlan);
+		}
+	}
+
+	return 0;
+}
 
 /**
- * ice_vc_process_vlan_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- * @add_v: Add VLAN if true, otherwise delete VLAN
- *
- * Process virtchnl op to add or remove programmed guest VLAN ID
+ * ice_vc_remove_vlan_v2_msg - virtchnl handler for VIRTCHNL_OP_DEL_VLAN_V2
+ * @vf: VF the message was received from
+ * @msg: message received from the VF
  */
-static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
+static int ice_vc_remove_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
 {
+	struct virtchnl_vlan_filter_list_v2 *vfl =
+		(struct virtchnl_vlan_filter_list_v2 *)msg;
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_filter_list *vfl =
-	    (struct virtchnl_vlan_filter_list *)msg;
-	struct ice_pf *pf = vf->pf;
-	bool vlan_promisc = false;
 	struct ice_vsi *vsi;
-	struct device *dev;
-	int status = 0;
-	int i;
-
-	dev = ice_pf_to_dev(pf);
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
 
-	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
+	if (!ice_vc_validate_vlan_filter_list(&vf->vlan_v2_caps.filtering,
+					      vfl)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto out;
 	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
+	if (!ice_vc_isvalid_vsi_id(vf, vfl->vport_id)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		if (vfl->vlan_id[i] >= VLAN_N_VID) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			dev_err(dev, "invalid VF VLAN id %d\n",
-				vfl->vlan_id[i]);
-			goto error_param;
-		}
+		goto out;
 	}
 
 	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (add_v && ice_vf_has_max_vlans(vf, vsi)) {
-		dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
-			 vf->vf_id);
-		/* There is no need to let VF know about being not trusted,
-		 * so we can just return success message here
-		 */
-		goto error_param;
+		goto out;
 	}
 
-	/* in DVM a VF can add/delete inner VLAN filters when
-	 * VIRTCHNL_VF_OFFLOAD_VLAN is negotiated, so only reject in SVM
-	 */
-	if (ice_vf_is_port_vlan_ena(vf) && !ice_is_dvm_ena(&pf->hw)) {
+	if (ice_vc_del_vlans(vf, vsi, vfl))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
 
-	/* in DVM VLAN promiscuous is based on the outer VLAN, which would be
-	 * the port VLAN if VIRTCHNL_VF_OFFLOAD_VLAN was negotiated, so only
-	 * allow vlan_promisc = true in SVM and if no port VLAN is configured
-	 */
-	vlan_promisc = ice_is_vlan_promisc_allowed(vf) &&
-		!ice_is_dvm_ena(&pf->hw) &&
-		!ice_vf_is_port_vlan_ena(vf);
+out:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL,
+				     0);
+}
 
-	if (add_v) {
-		for (i = 0; i < vfl->num_elements; i++) {
-			u16 vid = vfl->vlan_id[i];
-			struct ice_vlan vlan;
+/**
+ * ice_vc_add_vlans - add VLAN(s) from the virtchnl filter list
+ * @vf: VF used to add the VLAN(s)
+ * @vsi: VF's VSI used to add the VLAN(s)
+ * @vfl: virthchnl filter list used to add the filters
+ */
+static int
+ice_vc_add_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
+		 struct virtchnl_vlan_filter_list_v2 *vfl)
+{
+	bool vlan_promisc = ice_is_vlan_promisc_allowed(vf);
+	int err;
+	u16 i;
 
-			if (ice_vf_has_max_vlans(vf, vsi)) {
-				dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
-					 vf->vf_id);
-				/* There is no need to let VF know about being
-				 * not trusted, so we can just return success
-				 * message here as well.
-				 */
-				goto error_param;
-			}
+	for (i = 0; i < vfl->num_elements; i++) {
+		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
+		struct virtchnl_vlan *vc_vlan;
 
-			/* we add VLAN 0 by default for each VF so we can enable
-			 * Tx VLAN anti-spoof without triggering MDD events so
-			 * we don't need to add it again here
-			 */
-			if (!vid)
-				continue;
+		vc_vlan = &vlan_fltr->outer;
+		if (ice_vc_is_valid_vlan(vc_vlan)) {
+			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
 
-			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
-			status = vsi->inner_vlan_ops.add_vlan(vsi, &vlan);
-			if (status) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
+			err = ice_vc_vlan_action(vsi,
+						 vsi->outer_vlan_ops.add_vlan,
+						 &vlan);
+			if (err)
+				return err;
 
-			/* Enable VLAN filtering on first non-zero VLAN */
-			if (!vlan_promisc && vid && !ice_is_dvm_ena(&pf->hw)) {
-				if (vsi->inner_vlan_ops.ena_rx_filtering(vsi)) {
-					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
-						vid, status);
-					goto error_param;
-				}
-			} else if (vlan_promisc) {
-				status = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (status) {
-					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(dev, "Enable Unicast/multicast promiscuous mode on VLAN ID:%d failed error-%d\n",
-						vid, status);
-				}
+			if (vlan_promisc) {
+				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
+				if (err)
+					return err;
 			}
 		}
-	} else {
-		/* In case of non_trusted VF, number of VLAN elements passed
-		 * to PF for removal might be greater than number of VLANs
-		 * filter programmed for that VF - So, use actual number of
-		 * VLANS added earlier with add VLAN opcode. In order to avoid
-		 * removing VLAN that doesn't exist, which result to sending
-		 * erroneous failed message back to the VF
-		 */
-		int num_vf_vlan;
 
-		num_vf_vlan = vsi->num_vlan;
-		for (i = 0; i < vfl->num_elements && i < num_vf_vlan; i++) {
-			u16 vid = vfl->vlan_id[i];
-			struct ice_vlan vlan;
+		vc_vlan = &vlan_fltr->inner;
+		if (ice_vc_is_valid_vlan(vc_vlan)) {
+			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
 
-			/* we add VLAN 0 by default for each VF so we can enable
-			 * Tx VLAN anti-spoof without triggering MDD events so
-			 * we don't want a VIRTCHNL request to remove it
-			 */
-			if (!vid)
-				continue;
+			err = ice_vc_vlan_action(vsi,
+						 vsi->inner_vlan_ops.add_vlan,
+						 &vlan);
+			if (err)
+				return err;
 
-			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
-			status = vsi->inner_vlan_ops.del_vlan(vsi, &vlan);
-			if (status) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
+			/* no support for VLAN promiscuous on inner VLAN unless
+			 * we are in Single VLAN Mode (SVM)
+			 */
+			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc) {
+				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
+				if (err)
+					return err;
 			}
-
-			/* Disable VLAN filtering when only VLAN 0 is left */
-			if (!ice_vsi_has_non_zero_vlans(vsi))
-				vsi->inner_vlan_ops.dis_rx_filtering(vsi);
-
-			if (vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
 		}
 	}
 
-error_param:
-	/* send the response to the VF */
-	if (add_v)
-		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
-					     NULL, 0);
-	else
-		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
-					     NULL, 0);
+	return 0;
 }
 
 /**
- * ice_vc_add_vlan_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
+ * ice_vc_validate_add_vlan_filter_list - validate add filter list from the VF
+ * @vsi: VF VSI used to get number of existing VLAN filters
+ * @vfc: negotiated/supported VLAN filtering capabilities
+ * @vfl: VLAN filter list from VF to validate
  *
- * Add and program guest VLAN ID
+ * Validate all of the filters in the VLAN filter list from the VF during the
+ * VIRTCHNL_OP_ADD_VLAN_V2 opcode. If any of the checks fail then return false.
+ * Otherwise return true.
  */
-static int ice_vc_add_vlan_msg(struct ice_vf *vf, u8 *msg)
+static bool
+ice_vc_validate_add_vlan_filter_list(struct ice_vsi *vsi,
+				     struct virtchnl_vlan_filtering_caps *vfc,
+				     struct virtchnl_vlan_filter_list_v2 *vfl)
 {
-	return ice_vc_process_vlan_msg(vf, msg, true);
-}
+	u16 num_requested_filters = vsi->num_vlan + vfl->num_elements;
 
-/**
- * ice_vc_remove_vlan_msg
- * @vf: pointer to the VF info
- * @msg: pointer to the msg buffer
- *
- * remove programmed guest VLAN ID
- */
-static int ice_vc_remove_vlan_msg(struct ice_vf *vf, u8 *msg)
-{
-	return ice_vc_process_vlan_msg(vf, msg, false);
+	if (num_requested_filters > vfc->max_filters)
+		return false;
+
+	return ice_vc_validate_vlan_filter_list(vfc, vfl);
 }
 
 /**
- * ice_vc_ena_vlan_stripping
- * @vf: pointer to the VF info
- *
- * Enable VLAN header stripping for a given VF
+ * ice_vc_add_vlan_v2_msg - virtchnl handler for VIRTCHNL_OP_ADD_VLAN_V2
+ * @vf: VF the message was received from
+ * @msg: message received from the VF
  */
-static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
+static int ice_vc_add_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vlan_filter_list_v2 *vfl =
+		(struct virtchnl_vlan_filter_list_v2 *)msg;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto out;
 	}
 
-	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
+	if (!ice_vc_isvalid_vsi_id(vf, vfl->vport_id)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto out;
 	}
 
 	vsi = ice_get_vf_vsi(vf);
-	if (vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_dis_vlan_stripping
- * @vf: pointer to the VF info
- *
- * Disable VLAN header stripping for a given VF
- */
-static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
+	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto out;
 	}
 
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
+	if (!ice_vc_validate_add_vlan_filter_list(vsi,
+						  &vf->vlan_v2_caps.filtering,
+						  vfl)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
+		goto out;
 	}
 
-	if (vsi->inner_vlan_ops.dis_stripping(vsi))
+	if (ice_vc_add_vlans(vf, vsi, vfl))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
-error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
+out:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL,
+				     0);
 }
 
 /**
- * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
- * @vf: VF to enable/disable VLAN stripping for on initialization
- *
- * Set the default for VLAN stripping based on whether a port VLAN is configured
- * and the current VLAN mode of the device.
+ * ice_vc_valid_vlan_setting - validate VLAN setting
+ * @negotiated_settings: negotiated VLAN settings during VF init
+ * @ethertype_setting: ethertype(s) requested for the VLAN setting
  */
-static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
+static bool
+ice_vc_valid_vlan_setting(u32 negotiated_settings, u32 ethertype_setting)
 {
-	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-
-	if (!vsi)
-		return -EINVAL;
+	if (ethertype_setting && !(negotiated_settings & ethertype_setting))
+		return false;
 
-	/* don't modify stripping if port VLAN is configured in SVM since the
-	 * port VLAN is based on the inner/single VLAN in SVM
+	/* only allow a single VIRTCHNL_VLAN_ETHERTYPE if
+	 * VIRTHCNL_VLAN_ETHERTYPE_AND is not negotiated/supported
 	 */
-	if (ice_vf_is_port_vlan_ena(vf) && !ice_is_dvm_ena(&vsi->back->hw))
-		return 0;
-
-	if (ice_vf_vlan_offload_ena(vf->driver_caps))
-		return vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
-	else
-		return vsi->inner_vlan_ops.dis_stripping(vsi);
-}
-
-static u16 ice_vc_get_max_vlan_fltrs(struct ice_vf *vf)
-{
-	if (vf->trusted)
-		return VLAN_N_VID;
-	else
-		return ICE_MAX_VLAN_PER_VF;
-}
+	if (!(negotiated_settings & VIRTCHNL_VLAN_ETHERTYPE_AND) &&
+	    hweight32(ethertype_setting) > 1)
+		return false;
 
-/**
- * ice_vf_outer_vlan_not_allowed - check if outer VLAN can be used
- * @vf: VF that being checked for
- *
- * When the device is in double VLAN mode, check whether or not the outer VLAN
- * is allowed.
- */
-static bool ice_vf_outer_vlan_not_allowed(struct ice_vf *vf)
-{
-	if (ice_vf_is_port_vlan_ena(vf))
-		return true;
+	/* ability to modify the VLAN setting was not negotiated */
+	if (!(negotiated_settings & VIRTCHNL_VLAN_TOGGLE))
+		return false;
 
-	return false;
+	return true;
 }
 
 /**
- * ice_vc_set_dvm_caps - set VLAN capabilities when the device is in DVM
- * @vf: VF that capabilities are being set for
- * @caps: VLAN capabilities to populate
+ * ice_vc_valid_vlan_setting_msg - validate the VLAN setting message
+ * @caps: negotiated VLAN settings during VF init
+ * @msg: message to validate
  *
- * Determine VLAN capabilities support based on whether a port VLAN is
- * configured. If a port VLAN is configured then the VF should use the inner
- * filtering/offload capabilities since the port VLAN is using the outer VLAN
- * capabilies.
+ * Used to validate any VLAN virtchnl message sent as a
+ * virtchnl_vlan_setting structure. Validates the message against the
+ * negotiated/supported caps during VF driver init.
  */
-static void
-ice_vc_set_dvm_caps(struct ice_vf *vf, struct virtchnl_vlan_caps *caps)
+static bool
+ice_vc_valid_vlan_setting_msg(struct virtchnl_vlan_supported_caps *caps,
+			      struct virtchnl_vlan_setting *msg)
 {
-	struct virtchnl_vlan_supported_caps *supported_caps;
-
-	if (ice_vf_outer_vlan_not_allowed(vf)) {
-		/* until support for inner VLAN filtering is added when a port
-		 * VLAN is configured, only support software offloaded inner
-		 * VLANs when a port VLAN is confgured in DVM
-		 */
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		caps->offloads.ethertype_match =
-			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
-	} else {
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-					VIRTCHNL_VLAN_ETHERTYPE_9100 |
-					VIRTCHNL_VLAN_ETHERTYPE_AND;
-		caps->filtering.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-						 VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-						 VIRTCHNL_VLAN_ETHERTYPE_9100;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-					VIRTCHNL_VLAN_ETHERTYPE_9100 |
-					VIRTCHNL_VLAN_ETHERTYPE_XOR |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_ETHERTYPE_88A8 |
-					VIRTCHNL_VLAN_ETHERTYPE_9100 |
-					VIRTCHNL_VLAN_ETHERTYPE_XOR |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2;
+	if ((!msg->outer_ethertype_setting &&
+	     !msg->inner_ethertype_setting) ||
+	    (!caps->outer && !caps->inner))
+		return false;
 
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
+	if (msg->outer_ethertype_setting &&
+	    !ice_vc_valid_vlan_setting(caps->outer,
+				       msg->outer_ethertype_setting))
+		return false;
 
-		caps->offloads.ethertype_match =
-			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
-	}
+	if (msg->inner_ethertype_setting &&
+	    !ice_vc_valid_vlan_setting(caps->inner,
+				       msg->inner_ethertype_setting))
+		return false;
 
-	caps->filtering.max_filters = ice_vc_get_max_vlan_fltrs(vf);
+	return true;
 }
 
 /**
- * ice_vc_set_svm_caps - set VLAN capabilities when the device is in SVM
- * @vf: VF that capabilities are being set for
- * @caps: VLAN capabilities to populate
- *
- * Determine VLAN capabilities support based on whether a port VLAN is
- * configured. If a port VLAN is configured then the VF does not have any VLAN
- * filtering or offload capabilities since the port VLAN is using the inner VLAN
- * capabilities in single VLAN mode (SVM). Otherwise allow the VF to use inner
- * VLAN fitlering and offload capabilities.
+ * ice_vc_get_tpid - transform from VIRTCHNL_VLAN_ETHERTYPE_* to VLAN TPID
+ * @ethertype_setting: VIRTCHNL_VLAN_ETHERTYPE_* used to get VLAN TPID
+ * @tpid: VLAN TPID to populate
  */
-static void
-ice_vc_set_svm_caps(struct ice_vf *vf, struct virtchnl_vlan_caps *caps)
+static int ice_vc_get_tpid(u32 ethertype_setting, u16 *tpid)
 {
-	struct virtchnl_vlan_supported_caps *supported_caps;
-
-	if (ice_vf_is_port_vlan_ena(vf)) {
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_UNSUPPORTED;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_UNSUPPORTED;
-		caps->offloads.ethertype_match = VIRTCHNL_VLAN_UNSUPPORTED;
-		caps->filtering.max_filters = 0;
-	} else {
-		supported_caps = &caps->filtering.filtering_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-		caps->filtering.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-
-		supported_caps = &caps->offloads.stripping_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		supported_caps = &caps->offloads.insertion_support;
-		supported_caps->inner = VIRTCHNL_VLAN_ETHERTYPE_8100 |
-					VIRTCHNL_VLAN_TOGGLE |
-					VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1;
-		supported_caps->outer = VIRTCHNL_VLAN_UNSUPPORTED;
-
-		caps->offloads.ethertype_init = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		caps->offloads.ethertype_match =
-			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
-		caps->filtering.max_filters = ice_vc_get_max_vlan_fltrs(vf);
-	}
-}
-
-/**
- * ice_vc_get_offload_vlan_v2_caps - determine VF's VLAN capabilities
- * @vf: VF to determine VLAN capabilities for
- *
- * This will only be called if the VF and PF successfully negotiated
- * VIRTCHNL_VF_OFFLOAD_VLAN_V2.
- *
- * Set VLAN capabilities based on the current VLAN mode and whether a port VLAN
- * is configured or not.
- */
-static int ice_vc_get_offload_vlan_v2_caps(struct ice_vf *vf)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_caps *caps = NULL;
-	int err, len = 0;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
-	if (!caps) {
-		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
-		goto out;
-	}
-	len = sizeof(*caps);
-
-	if (ice_is_dvm_ena(&vf->pf->hw))
-		ice_vc_set_dvm_caps(vf, caps);
-	else
-		ice_vc_set_svm_caps(vf, caps);
-
-	/* store negotiated caps to prevent invalid VF messages */
-	memcpy(&vf->vlan_v2_caps, caps, sizeof(*caps));
-
-out:
-	err = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
-				    v_ret, (u8 *)caps, len);
-	kfree(caps);
-	return err;
-}
-
-/**
- * ice_vc_validate_vlan_tpid - validate VLAN TPID
- * @filtering_caps: negotiated/supported VLAN filtering capabilities
- * @tpid: VLAN TPID used for validation
- *
- * Convert the VLAN TPID to a VIRTCHNL_VLAN_ETHERTYPE_* and then compare against
- * the negotiated/supported filtering caps to see if the VLAN TPID is valid.
- */
-static bool ice_vc_validate_vlan_tpid(u16 filtering_caps, u16 tpid)
-{
-	enum virtchnl_vlan_support vlan_ethertype = VIRTCHNL_VLAN_UNSUPPORTED;
-
-	switch (tpid) {
-	case ETH_P_8021Q:
-		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_8100;
-		break;
-	case ETH_P_8021AD:
-		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_88A8;
-		break;
-	case ETH_P_QINQ1:
-		vlan_ethertype = VIRTCHNL_VLAN_ETHERTYPE_9100;
-		break;
-	}
-
-	if (!(filtering_caps & vlan_ethertype))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_is_valid_vlan - validate the virtchnl_vlan
- * @vc_vlan: virtchnl_vlan to validate
- *
- * If the VLAN TCI and VLAN TPID are 0, then this filter is invalid, so return
- * false. Otherwise return true.
- */
-static bool ice_vc_is_valid_vlan(struct virtchnl_vlan *vc_vlan)
-{
-	if (!vc_vlan->tci || !vc_vlan->tpid)
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_validate_vlan_filter_list - validate the filter list from the VF
- * @vfc: negotiated/supported VLAN filtering capabilities
- * @vfl: VLAN filter list from VF to validate
- *
- * Validate all of the filters in the VLAN filter list from the VF. If any of
- * the checks fail then return false. Otherwise return true.
- */
-static bool
-ice_vc_validate_vlan_filter_list(struct virtchnl_vlan_filtering_caps *vfc,
-				 struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	u16 i;
-
-	if (!vfl->num_elements)
-		return false;
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		struct virtchnl_vlan_supported_caps *filtering_support =
-			&vfc->filtering_support;
-		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
-		struct virtchnl_vlan *outer = &vlan_fltr->outer;
-		struct virtchnl_vlan *inner = &vlan_fltr->inner;
-
-		if ((ice_vc_is_valid_vlan(outer) &&
-		     filtering_support->outer == VIRTCHNL_VLAN_UNSUPPORTED) ||
-		    (ice_vc_is_valid_vlan(inner) &&
-		     filtering_support->inner == VIRTCHNL_VLAN_UNSUPPORTED))
-			return false;
-
-		if ((outer->tci_mask &&
-		     !(filtering_support->outer & VIRTCHNL_VLAN_FILTER_MASK)) ||
-		    (inner->tci_mask &&
-		     !(filtering_support->inner & VIRTCHNL_VLAN_FILTER_MASK)))
-			return false;
-
-		if (((outer->tci & VLAN_PRIO_MASK) &&
-		     !(filtering_support->outer & VIRTCHNL_VLAN_PRIO)) ||
-		    ((inner->tci & VLAN_PRIO_MASK) &&
-		     !(filtering_support->inner & VIRTCHNL_VLAN_PRIO)))
-			return false;
-
-		if ((ice_vc_is_valid_vlan(outer) &&
-		     !ice_vc_validate_vlan_tpid(filtering_support->outer,
-						outer->tpid)) ||
-		    (ice_vc_is_valid_vlan(inner) &&
-		     !ice_vc_validate_vlan_tpid(filtering_support->inner,
-						inner->tpid)))
-			return false;
-	}
-
-	return true;
-}
-
-/**
- * ice_vc_to_vlan - transform from struct virtchnl_vlan to struct ice_vlan
- * @vc_vlan: struct virtchnl_vlan to transform
- */
-static struct ice_vlan ice_vc_to_vlan(struct virtchnl_vlan *vc_vlan)
-{
-	struct ice_vlan vlan = { 0 };
-
-	vlan.prio = (vc_vlan->tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	vlan.vid = vc_vlan->tci & VLAN_VID_MASK;
-	vlan.tpid = vc_vlan->tpid;
-
-	return vlan;
-}
-
-/**
- * ice_vc_vlan_action - action to perform on the virthcnl_vlan
- * @vsi: VF's VSI used to perform the action
- * @vlan_action: function to perform the action with (i.e. add/del)
- * @vlan: VLAN filter to perform the action with
- */
-static int
-ice_vc_vlan_action(struct ice_vsi *vsi,
-		   int (*vlan_action)(struct ice_vsi *, struct ice_vlan *),
-		   struct ice_vlan *vlan)
-{
-	int err;
-
-	err = vlan_action(vsi, vlan);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-/**
- * ice_vc_del_vlans - delete VLAN(s) from the virtchnl filter list
- * @vf: VF used to delete the VLAN(s)
- * @vsi: VF's VSI used to delete the VLAN(s)
- * @vfl: virthchnl filter list used to delete the filters
- */
-static int
-ice_vc_del_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
-		 struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	bool vlan_promisc = ice_is_vlan_promisc_allowed(vf);
-	int err;
-	u16 i;
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
-		struct virtchnl_vlan *vc_vlan;
-
-		vc_vlan = &vlan_fltr->outer;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->outer_vlan_ops.del_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			if (vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
-		}
-
-		vc_vlan = &vlan_fltr->inner;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->inner_vlan_ops.del_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			/* no support for VLAN promiscuous on inner VLAN unless
-			 * we are in Single VLAN Mode (SVM)
-			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
-		}
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_remove_vlan_v2_msg - virtchnl handler for VIRTCHNL_OP_DEL_VLAN_V2
- * @vf: VF the message was received from
- * @msg: message received from the VF
- */
-static int ice_vc_remove_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	struct virtchnl_vlan_filter_list_v2 *vfl =
-		(struct virtchnl_vlan_filter_list_v2 *)msg;
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_vsi *vsi;
-
-	if (!ice_vc_validate_vlan_filter_list(&vf->vlan_v2_caps.filtering,
-					      vfl)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vfl->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (ice_vc_del_vlans(vf, vsi, vfl))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL,
-				     0);
-}
-
-/**
- * ice_vc_add_vlans - add VLAN(s) from the virtchnl filter list
- * @vf: VF used to add the VLAN(s)
- * @vsi: VF's VSI used to add the VLAN(s)
- * @vfl: virthchnl filter list used to add the filters
- */
-static int
-ice_vc_add_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
-		 struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	bool vlan_promisc = ice_is_vlan_promisc_allowed(vf);
-	int err;
-	u16 i;
-
-	for (i = 0; i < vfl->num_elements; i++) {
-		struct virtchnl_vlan_filter *vlan_fltr = &vfl->filters[i];
-		struct virtchnl_vlan *vc_vlan;
-
-		vc_vlan = &vlan_fltr->outer;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->outer_vlan_ops.add_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			if (vlan_promisc) {
-				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (err)
-					return err;
-			}
-		}
-
-		vc_vlan = &vlan_fltr->inner;
-		if (ice_vc_is_valid_vlan(vc_vlan)) {
-			struct ice_vlan vlan = ice_vc_to_vlan(vc_vlan);
-
-			err = ice_vc_vlan_action(vsi,
-						 vsi->inner_vlan_ops.add_vlan,
-						 &vlan);
-			if (err)
-				return err;
-
-			/* no support for VLAN promiscuous on inner VLAN unless
-			 * we are in Single VLAN Mode (SVM)
-			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc) {
-				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (err)
-					return err;
-			}
-		}
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_validate_add_vlan_filter_list - validate add filter list from the VF
- * @vsi: VF VSI used to get number of existing VLAN filters
- * @vfc: negotiated/supported VLAN filtering capabilities
- * @vfl: VLAN filter list from VF to validate
- *
- * Validate all of the filters in the VLAN filter list from the VF during the
- * VIRTCHNL_OP_ADD_VLAN_V2 opcode. If any of the checks fail then return false.
- * Otherwise return true.
- */
-static bool
-ice_vc_validate_add_vlan_filter_list(struct ice_vsi *vsi,
-				     struct virtchnl_vlan_filtering_caps *vfc,
-				     struct virtchnl_vlan_filter_list_v2 *vfl)
-{
-	u16 num_requested_filters = vsi->num_vlan + vfl->num_elements;
-
-	if (num_requested_filters > vfc->max_filters)
-		return false;
-
-	return ice_vc_validate_vlan_filter_list(vfc, vfl);
-}
-
-/**
- * ice_vc_add_vlan_v2_msg - virtchnl handler for VIRTCHNL_OP_ADD_VLAN_V2
- * @vf: VF the message was received from
- * @msg: message received from the VF
- */
-static int ice_vc_add_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_filter_list_v2 *vfl =
-		(struct virtchnl_vlan_filter_list_v2 *)msg;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, vfl->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_validate_add_vlan_filter_list(vsi,
-						  &vf->vlan_v2_caps.filtering,
-						  vfl)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (ice_vc_add_vlans(vf, vsi, vfl))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL,
-				     0);
-}
-
-/**
- * ice_vc_valid_vlan_setting - validate VLAN setting
- * @negotiated_settings: negotiated VLAN settings during VF init
- * @ethertype_setting: ethertype(s) requested for the VLAN setting
- */
-static bool
-ice_vc_valid_vlan_setting(u32 negotiated_settings, u32 ethertype_setting)
-{
-	if (ethertype_setting && !(negotiated_settings & ethertype_setting))
-		return false;
-
-	/* only allow a single VIRTCHNL_VLAN_ETHERTYPE if
-	 * VIRTHCNL_VLAN_ETHERTYPE_AND is not negotiated/supported
-	 */
-	if (!(negotiated_settings & VIRTCHNL_VLAN_ETHERTYPE_AND) &&
-	    hweight32(ethertype_setting) > 1)
-		return false;
-
-	/* ability to modify the VLAN setting was not negotiated */
-	if (!(negotiated_settings & VIRTCHNL_VLAN_TOGGLE))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_valid_vlan_setting_msg - validate the VLAN setting message
- * @caps: negotiated VLAN settings during VF init
- * @msg: message to validate
- *
- * Used to validate any VLAN virtchnl message sent as a
- * virtchnl_vlan_setting structure. Validates the message against the
- * negotiated/supported caps during VF driver init.
- */
-static bool
-ice_vc_valid_vlan_setting_msg(struct virtchnl_vlan_supported_caps *caps,
-			      struct virtchnl_vlan_setting *msg)
-{
-	if ((!msg->outer_ethertype_setting &&
-	     !msg->inner_ethertype_setting) ||
-	    (!caps->outer && !caps->inner))
-		return false;
-
-	if (msg->outer_ethertype_setting &&
-	    !ice_vc_valid_vlan_setting(caps->outer,
-				       msg->outer_ethertype_setting))
-		return false;
-
-	if (msg->inner_ethertype_setting &&
-	    !ice_vc_valid_vlan_setting(caps->inner,
-				       msg->inner_ethertype_setting))
-		return false;
-
-	return true;
-}
-
-/**
- * ice_vc_get_tpid - transform from VIRTCHNL_VLAN_ETHERTYPE_* to VLAN TPID
- * @ethertype_setting: VIRTCHNL_VLAN_ETHERTYPE_* used to get VLAN TPID
- * @tpid: VLAN TPID to populate
- */
-static int ice_vc_get_tpid(u32 ethertype_setting, u16 *tpid)
-{
-	switch (ethertype_setting) {
-	case VIRTCHNL_VLAN_ETHERTYPE_8100:
-		*tpid = ETH_P_8021Q;
-		break;
-	case VIRTCHNL_VLAN_ETHERTYPE_88A8:
-		*tpid = ETH_P_8021AD;
-		break;
-	case VIRTCHNL_VLAN_ETHERTYPE_9100:
-		*tpid = ETH_P_QINQ1;
-		break;
-	default:
-		*tpid = 0;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * ice_vc_ena_vlan_offload - enable VLAN offload based on the ethertype_setting
- * @vsi: VF's VSI used to enable the VLAN offload
- * @ena_offload: function used to enable the VLAN offload
- * @ethertype_setting: VIRTCHNL_VLAN_ETHERTYPE_* to enable offloads for
- */
-static int
-ice_vc_ena_vlan_offload(struct ice_vsi *vsi,
-			int (*ena_offload)(struct ice_vsi *vsi, u16 tpid),
-			u32 ethertype_setting)
-{
-	u16 tpid;
-	int err;
-
-	err = ice_vc_get_tpid(ethertype_setting, &tpid);
-	if (err)
-		return err;
-
-	err = ena_offload(vsi, tpid);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-#define ICE_L2TSEL_QRX_CONTEXT_REG_IDX	3
-#define ICE_L2TSEL_BIT_OFFSET		23
-enum ice_l2tsel {
-	ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND,
-	ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1,
-};
-
-/**
- * ice_vsi_update_l2tsel - update l2tsel field for all Rx rings on this VSI
- * @vsi: VSI used to update l2tsel on
- * @l2tsel: l2tsel setting requested
- *
- * Use the l2tsel setting to update all of the Rx queue context bits for l2tsel.
- * This will modify which descriptor field the first offloaded VLAN will be
- * stripped into.
- */
-static void ice_vsi_update_l2tsel(struct ice_vsi *vsi, enum ice_l2tsel l2tsel)
-{
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 l2tsel_bit;
-	int i;
-
-	if (l2tsel == ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND)
-		l2tsel_bit = 0;
-	else
-		l2tsel_bit = BIT(ICE_L2TSEL_BIT_OFFSET);
-
-	for (i = 0; i < vsi->alloc_rxq; i++) {
-		u16 pfq = vsi->rxq_map[i];
-		u32 qrx_context_offset;
-		u32 regval;
-
-		qrx_context_offset =
-			QRX_CONTEXT(ICE_L2TSEL_QRX_CONTEXT_REG_IDX, pfq);
-
-		regval = rd32(hw, qrx_context_offset);
-		regval &= ~BIT(ICE_L2TSEL_BIT_OFFSET);
-		regval |= l2tsel_bit;
-		wr32(hw, qrx_context_offset, regval);
-	}
-}
-
-/**
- * ice_vc_ena_vlan_stripping_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2
- */
-static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *stripping_support;
-	struct virtchnl_vlan_setting *strip_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, strip_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	stripping_support = &vf->vlan_v2_caps.offloads.stripping_support;
-	if (!ice_vc_valid_vlan_setting_msg(stripping_support, strip_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = strip_msg->outer_ethertype_setting;
-	if (ethertype_setting) {
-		if (ice_vc_ena_vlan_offload(vsi,
-					    vsi->outer_vlan_ops.ena_stripping,
-					    ethertype_setting)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto out;
-		} else {
-			enum ice_l2tsel l2tsel =
-				ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND;
-
-			/* PF tells the VF that the outer VLAN tag is always
-			 * extracted to VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 and
-			 * inner is always extracted to
-			 * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1. This is needed to
-			 * support outer stripping so the first tag always ends
-			 * up in L2TAG2_2ND and the second/inner tag, if
-			 * enabled, is extracted in L2TAG1.
-			 */
-			ice_vsi_update_l2tsel(vsi, l2tsel);
-		}
-	}
-
-	ethertype_setting = strip_msg->inner_ethertype_setting;
-	if (ethertype_setting &&
-	    ice_vc_ena_vlan_offload(vsi, vsi->inner_vlan_ops.ena_stripping,
-				    ethertype_setting)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_dis_vlan_stripping_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2
- */
-static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *stripping_support;
-	struct virtchnl_vlan_setting *strip_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, strip_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	stripping_support = &vf->vlan_v2_caps.offloads.stripping_support;
-	if (!ice_vc_valid_vlan_setting_msg(stripping_support, strip_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = strip_msg->outer_ethertype_setting;
-	if (ethertype_setting) {
-		if (vsi->outer_vlan_ops.dis_stripping(vsi)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto out;
-		} else {
-			enum ice_l2tsel l2tsel =
-				ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1;
-
-			/* PF tells the VF that the outer VLAN tag is always
-			 * extracted to VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 and
-			 * inner is always extracted to
-			 * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1. This is needed to
-			 * support inner stripping while outer stripping is
-			 * disabled so that the first and only tag is extracted
-			 * in L2TAG1.
-			 */
-			ice_vsi_update_l2tsel(vsi, l2tsel);
-		}
-	}
-
-	ethertype_setting = strip_msg->inner_ethertype_setting;
-	if (ethertype_setting && vsi->inner_vlan_ops.dis_stripping(vsi)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_ena_vlan_insertion_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2
- */
-static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *insertion_support;
-	struct virtchnl_vlan_setting *insertion_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, insertion_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	insertion_support = &vf->vlan_v2_caps.offloads.insertion_support;
-	if (!ice_vc_valid_vlan_setting_msg(insertion_support, insertion_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->outer_ethertype_setting;
-	if (ethertype_setting &&
-	    ice_vc_ena_vlan_offload(vsi, vsi->outer_vlan_ops.ena_insertion,
-				    ethertype_setting)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->inner_ethertype_setting;
-	if (ethertype_setting &&
-	    ice_vc_ena_vlan_offload(vsi, vsi->inner_vlan_ops.ena_insertion,
-				    ethertype_setting)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_dis_vlan_insertion_v2_msg
- * @vf: VF the message was received from
- * @msg: message received from the VF
- *
- * virthcnl handler for VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2
- */
-static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_vlan_supported_caps *insertion_support;
-	struct virtchnl_vlan_setting *insertion_msg =
-		(struct virtchnl_vlan_setting *)msg;
-	u32 ethertype_setting;
-	struct ice_vsi *vsi;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	if (!ice_vc_isvalid_vsi_id(vf, insertion_msg->vport_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	insertion_support = &vf->vlan_v2_caps.offloads.insertion_support;
-	if (!ice_vc_valid_vlan_setting_msg(insertion_support, insertion_msg)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->outer_ethertype_setting;
-	if (ethertype_setting && vsi->outer_vlan_ops.dis_insertion(vsi)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-	ethertype_setting = insertion_msg->inner_ethertype_setting;
-	if (ethertype_setting && vsi->inner_vlan_ops.dis_insertion(vsi)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto out;
-	}
-
-out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
-}
-
-static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
-	.get_ver_msg = ice_vc_get_ver_msg,
-	.get_vf_res_msg = ice_vc_get_vf_res_msg,
-	.reset_vf = ice_vc_reset_vf_msg,
-	.add_mac_addr_msg = ice_vc_add_mac_addr_msg,
-	.del_mac_addr_msg = ice_vc_del_mac_addr_msg,
-	.cfg_qs_msg = ice_vc_cfg_qs_msg,
-	.ena_qs_msg = ice_vc_ena_qs_msg,
-	.dis_qs_msg = ice_vc_dis_qs_msg,
-	.request_qs_msg = ice_vc_request_qs_msg,
-	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
-	.config_rss_key = ice_vc_config_rss_key,
-	.config_rss_lut = ice_vc_config_rss_lut,
-	.get_stats_msg = ice_vc_get_stats_msg,
-	.cfg_promiscuous_mode_msg = ice_vc_cfg_promiscuous_mode_msg,
-	.add_vlan_msg = ice_vc_add_vlan_msg,
-	.remove_vlan_msg = ice_vc_remove_vlan_msg,
-	.ena_vlan_stripping = ice_vc_ena_vlan_stripping,
-	.dis_vlan_stripping = ice_vc_dis_vlan_stripping,
-	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
-	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
-	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
-	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
-	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
-	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
-	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
-	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
-	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
-	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
-};
-
-/**
- * ice_virtchnl_set_dflt_ops - Switch to default virtchnl ops
- * @vf: the VF to switch ops
- */
-void ice_virtchnl_set_dflt_ops(struct ice_vf *vf)
-{
-	vf->virtchnl_ops = &ice_virtchnl_dflt_ops;
-}
-
-/**
- * ice_vc_repr_add_mac
- * @vf: pointer to VF
- * @msg: virtchannel message
- *
- * When port representors are created, we do not add MAC rule
- * to firmware, we store it so that PF could report same
- * MAC as VF.
- */
-static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
-{
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_ether_addr_list *al =
-	    (struct virtchnl_ether_addr_list *)msg;
-	struct ice_vsi *vsi;
-	struct ice_pf *pf;
-	int i;
-
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	pf = vf->pf;
-
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto handle_mac_exit;
-	}
-
-	for (i = 0; i < al->num_elements; i++) {
-		u8 *mac_addr = al->list[i].addr;
-		int result;
-
-		if (!is_unicast_ether_addr(mac_addr) ||
-		    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
-			continue;
-
-		if (vf->pf_set_mac) {
-			dev_err(ice_pf_to_dev(pf), "VF attempting to override administratively set MAC address\n");
-			v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-			goto handle_mac_exit;
-		}
-
-		result = ice_eswitch_add_vf_mac_rule(pf, vf, mac_addr);
-		if (result) {
-			dev_err(ice_pf_to_dev(pf), "Failed to add MAC %pM for VF %d\n, error %d\n",
-				mac_addr, vf->vf_id, result);
-			goto handle_mac_exit;
-		}
-
-		ice_vfhw_mac_add(vf, &al->list[i]);
-		vf->num_mac++;
-		break;
-	}
-
-handle_mac_exit:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				     v_ret, NULL, 0);
-}
-
-/**
- * ice_vc_repr_del_mac - response with success for deleting MAC
- * @vf: pointer to VF
- * @msg: virtchannel message
- *
- * Respond with success to not break normal VF flow.
- * For legacy VF driver try to update cached MAC address.
- */
-static int
-ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
-{
-	struct virtchnl_ether_addr_list *al =
-		(struct virtchnl_ether_addr_list *)msg;
-
-	ice_update_legacy_cached_mac(vf, &al->list[0]);
-
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_add_vlan(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't add VLAN in switchdev mode for VF %d\n", vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_del_vlan(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't delete VLAN in switchdev mode for VF %d\n", vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_ena_vlan_stripping(struct ice_vf *vf)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't enable VLAN stripping in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static int ice_vc_repr_dis_vlan_stripping(struct ice_vf *vf)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't disable VLAN stripping in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static int
-ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't config promiscuous mode in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static const struct ice_virtchnl_ops ice_virtchnl_repr_ops = {
-	.get_ver_msg = ice_vc_get_ver_msg,
-	.get_vf_res_msg = ice_vc_get_vf_res_msg,
-	.reset_vf = ice_vc_reset_vf_msg,
-	.add_mac_addr_msg = ice_vc_repr_add_mac,
-	.del_mac_addr_msg = ice_vc_repr_del_mac,
-	.cfg_qs_msg = ice_vc_cfg_qs_msg,
-	.ena_qs_msg = ice_vc_ena_qs_msg,
-	.dis_qs_msg = ice_vc_dis_qs_msg,
-	.request_qs_msg = ice_vc_request_qs_msg,
-	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
-	.config_rss_key = ice_vc_config_rss_key,
-	.config_rss_lut = ice_vc_config_rss_lut,
-	.get_stats_msg = ice_vc_get_stats_msg,
-	.cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode,
-	.add_vlan_msg = ice_vc_repr_add_vlan,
-	.remove_vlan_msg = ice_vc_repr_del_vlan,
-	.ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping,
-	.dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping,
-	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
-	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
-	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
-	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
-	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
-	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
-	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
-	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
-	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
-	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
-};
-
-/**
- * ice_virtchnl_set_repr_ops - Switch to representor virtchnl ops
- * @vf: the VF to switch ops
- */
-void ice_virtchnl_set_repr_ops(struct ice_vf *vf)
-{
-	vf->virtchnl_ops = &ice_virtchnl_repr_ops;
-}
-
-/**
- * ice_vc_process_vf_msg - Process request from VF
- * @pf: pointer to the PF structure
- * @event: pointer to the AQ event
- *
- * called from the common asq/arq handler to
- * process request from VF
- */
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
-{
-	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
-	s16 vf_id = le16_to_cpu(event->desc.retval);
-	const struct ice_virtchnl_ops *ops;
-	u16 msglen = event->msg_len;
-	u8 *msg = event->msg_buf;
-	struct ice_vf *vf = NULL;
-	struct device *dev;
-	int err = 0;
-
-	dev = ice_pf_to_dev(pf);
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf) {
-		dev_err(dev, "Unable to locate VF for message from VF ID %d, opcode %d, len %d\n",
-			vf_id, v_opcode, msglen);
-		return;
-	}
-
-	/* Check if VF is disabled. */
-	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
-		err = -EPERM;
-		goto error_handler;
-	}
-
-	ops = vf->virtchnl_ops;
-
-	/* Perform basic checks on the msg */
-	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
-	if (err) {
-		if (err == VIRTCHNL_STATUS_ERR_PARAM)
-			err = -EPERM;
-		else
-			err = -EINVAL;
-	}
-
-	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
-		ice_vc_send_msg_to_vf(vf, v_opcode,
-				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
-				      0);
-		ice_put_vf(vf);
-		return;
-	}
-
-error_handler:
-	if (err) {
-		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
-				      NULL, 0);
-		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
-			vf_id, v_opcode, msglen, err);
-		ice_put_vf(vf);
-		return;
-	}
-
-	/* VF is being configured in another context that triggers a VFR, so no
-	 * need to process this message
-	 */
-	if (!mutex_trylock(&vf->cfg_lock)) {
-		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
-			 vf->vf_id);
-		ice_put_vf(vf);
-		return;
-	}
-
-	switch (v_opcode) {
-	case VIRTCHNL_OP_VERSION:
-		err = ops->get_ver_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_GET_VF_RESOURCES:
-		err = ops->get_vf_res_msg(vf, msg);
-		if (ice_vf_init_vlan_stripping(vf))
-			dev_dbg(dev, "Failed to initialize VLAN stripping for VF %d\n",
-				vf->vf_id);
-		ice_vc_notify_vf_link_state(vf);
-		break;
-	case VIRTCHNL_OP_RESET_VF:
-		ops->reset_vf(vf);
-		break;
-	case VIRTCHNL_OP_ADD_ETH_ADDR:
-		err = ops->add_mac_addr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_ETH_ADDR:
-		err = ops->del_mac_addr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_VSI_QUEUES:
-		err = ops->cfg_qs_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_QUEUES:
-		err = ops->ena_qs_msg(vf, msg);
-		ice_vc_notify_vf_link_state(vf);
-		break;
-	case VIRTCHNL_OP_DISABLE_QUEUES:
-		err = ops->dis_qs_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_REQUEST_QUEUES:
-		err = ops->request_qs_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_IRQ_MAP:
-		err = ops->cfg_irq_map_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_RSS_KEY:
-		err = ops->config_rss_key(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_RSS_LUT:
-		err = ops->config_rss_lut(vf, msg);
-		break;
-	case VIRTCHNL_OP_GET_STATS:
-		err = ops->get_stats_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
-		err = ops->cfg_promiscuous_mode_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ADD_VLAN:
-		err = ops->add_vlan_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_VLAN:
-		err = ops->remove_vlan_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
-		err = ops->ena_vlan_stripping(vf);
-		break;
-	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
-		err = ops->dis_vlan_stripping(vf);
-		break;
-	case VIRTCHNL_OP_ADD_FDIR_FILTER:
-		err = ops->add_fdir_fltr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_FDIR_FILTER:
-		err = ops->del_fdir_fltr_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ADD_RSS_CFG:
-		err = ops->handle_rss_cfg_msg(vf, msg, true);
-		break;
-	case VIRTCHNL_OP_DEL_RSS_CFG:
-		err = ops->handle_rss_cfg_msg(vf, msg, false);
-		break;
-	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS:
-		err = ops->get_offload_vlan_v2_caps(vf);
-		break;
-	case VIRTCHNL_OP_ADD_VLAN_V2:
-		err = ops->add_vlan_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DEL_VLAN_V2:
-		err = ops->remove_vlan_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2:
-		err = ops->ena_vlan_stripping_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2:
-		err = ops->dis_vlan_stripping_v2_msg(vf, msg);
-		break;
-	case VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2:
-		err = ops->ena_vlan_insertion_v2_msg(vf, msg);
+	switch (ethertype_setting) {
+	case VIRTCHNL_VLAN_ETHERTYPE_8100:
+		*tpid = ETH_P_8021Q;
 		break;
-	case VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2:
-		err = ops->dis_vlan_insertion_v2_msg(vf, msg);
+	case VIRTCHNL_VLAN_ETHERTYPE_88A8:
+		*tpid = ETH_P_8021AD;
 		break;
-	case VIRTCHNL_OP_UNKNOWN:
-	default:
-		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
-			vf_id);
-		err = ice_vc_send_msg_to_vf(vf, v_opcode,
-					    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-					    NULL, 0);
+	case VIRTCHNL_VLAN_ETHERTYPE_9100:
+		*tpid = ETH_P_QINQ1;
 		break;
-	}
-	if (err) {
-		/* Helper function cares less about error return values here
-		 * as it is busy with pending work.
-		 */
-		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
-			 vf_id, v_opcode, err);
+	default:
+		*tpid = 0;
+		return -EINVAL;
 	}
 
-	mutex_unlock(&vf->cfg_lock);
-	ice_put_vf(vf);
+	return 0;
 }
 
 /**
- * ice_get_vf_cfg
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @ivi: VF configuration structure
- *
- * return VF configuration
+ * ice_vc_ena_vlan_offload - enable VLAN offload based on the ethertype_setting
+ * @vsi: VF's VSI used to enable the VLAN offload
+ * @ena_offload: function used to enable the VLAN offload
+ * @ethertype_setting: VIRTCHNL_VLAN_ETHERTYPE_* to enable offloads for
  */
-int
-ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
+static int
+ice_vc_ena_vlan_offload(struct ice_vsi *vsi,
+			int (*ena_offload)(struct ice_vsi *vsi, u16 tpid),
+			u32 ethertype_setting)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_vf *vf;
-	int ret;
+	u16 tpid;
+	int err;
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
+	err = ice_vc_get_tpid(ethertype_setting, &tpid);
+	if (err)
+		return err;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
+	err = ena_offload(vsi, tpid);
+	if (err)
+		return err;
 
-	ivi->vf = vf_id;
-	ether_addr_copy(ivi->mac, vf->hw_lan_addr.addr);
+	return 0;
+}
 
-	/* VF configuration for VLAN and applicable QoS */
-	ivi->vlan = ice_vf_get_port_vlan_id(vf);
-	ivi->qos = ice_vf_get_port_vlan_prio(vf);
-	if (ice_vf_is_port_vlan_ena(vf))
-		ivi->vlan_proto = cpu_to_be16(ice_vf_get_port_vlan_tpid(vf));
-
-	ivi->trusted = vf->trusted;
-	ivi->spoofchk = vf->spoofchk;
-	if (!vf->link_forced)
-		ivi->linkstate = IFLA_VF_LINK_STATE_AUTO;
-	else if (vf->link_up)
-		ivi->linkstate = IFLA_VF_LINK_STATE_ENABLE;
+#define ICE_L2TSEL_QRX_CONTEXT_REG_IDX	3
+#define ICE_L2TSEL_BIT_OFFSET		23
+enum ice_l2tsel {
+	ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND,
+	ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1,
+};
+
+/**
+ * ice_vsi_update_l2tsel - update l2tsel field for all Rx rings on this VSI
+ * @vsi: VSI used to update l2tsel on
+ * @l2tsel: l2tsel setting requested
+ *
+ * Use the l2tsel setting to update all of the Rx queue context bits for l2tsel.
+ * This will modify which descriptor field the first offloaded VLAN will be
+ * stripped into.
+ */
+static void ice_vsi_update_l2tsel(struct ice_vsi *vsi, enum ice_l2tsel l2tsel)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 l2tsel_bit;
+	int i;
+
+	if (l2tsel == ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND)
+		l2tsel_bit = 0;
 	else
-		ivi->linkstate = IFLA_VF_LINK_STATE_DISABLE;
-	ivi->max_tx_rate = vf->max_tx_rate;
-	ivi->min_tx_rate = vf->min_tx_rate;
+		l2tsel_bit = BIT(ICE_L2TSEL_BIT_OFFSET);
 
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
+	for (i = 0; i < vsi->alloc_rxq; i++) {
+		u16 pfq = vsi->rxq_map[i];
+		u32 qrx_context_offset;
+		u32 regval;
+
+		qrx_context_offset =
+			QRX_CONTEXT(ICE_L2TSEL_QRX_CONTEXT_REG_IDX, pfq);
+
+		regval = rd32(hw, qrx_context_offset);
+		regval &= ~BIT(ICE_L2TSEL_BIT_OFFSET);
+		regval |= l2tsel_bit;
+		wr32(hw, qrx_context_offset, regval);
+	}
 }
 
 /**
- * ice_unicast_mac_exists - check if the unicast MAC exists on the PF's switch
- * @pf: PF used to reference the switch's rules
- * @umac: unicast MAC to compare against existing switch rules
+ * ice_vc_ena_vlan_stripping_v2_msg
+ * @vf: VF the message was received from
+ * @msg: message received from the VF
  *
- * Return true on the first/any match, else return false
+ * virthcnl handler for VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2
  */
-static bool ice_unicast_mac_exists(struct ice_pf *pf, u8 *umac)
+static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_sw_recipe *mac_recipe_list =
-		&pf->hw.switch_info->recp_list[ICE_SW_LKUP_MAC];
-	struct ice_fltr_mgmt_list_entry *list_itr;
-	struct list_head *rule_head;
-	struct mutex *rule_lock; /* protect MAC filter list access */
-
-	rule_head = &mac_recipe_list->filt_rules;
-	rule_lock = &mac_recipe_list->filt_rule_lock;
-
-	mutex_lock(rule_lock);
-	list_for_each_entry(list_itr, rule_head, list_entry) {
-		u8 *existing_mac = &list_itr->fltr_info.l_data.mac.mac_addr[0];
-
-		if (ether_addr_equal(existing_mac, umac)) {
-			mutex_unlock(rule_lock);
-			return true;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vlan_supported_caps *stripping_support;
+	struct virtchnl_vlan_setting *strip_msg =
+		(struct virtchnl_vlan_setting *)msg;
+	u32 ethertype_setting;
+	struct ice_vsi *vsi;
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
+
+	if (!ice_vc_isvalid_vsi_id(vf, strip_msg->vport_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
+
+	stripping_support = &vf->vlan_v2_caps.offloads.stripping_support;
+	if (!ice_vc_valid_vlan_setting_msg(stripping_support, strip_msg)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
+
+	ethertype_setting = strip_msg->outer_ethertype_setting;
+	if (ethertype_setting) {
+		if (ice_vc_ena_vlan_offload(vsi,
+					    vsi->outer_vlan_ops.ena_stripping,
+					    ethertype_setting)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto out;
+		} else {
+			enum ice_l2tsel l2tsel =
+				ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND;
+
+			/* PF tells the VF that the outer VLAN tag is always
+			 * extracted to VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 and
+			 * inner is always extracted to
+			 * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1. This is needed to
+			 * support outer stripping so the first tag always ends
+			 * up in L2TAG2_2ND and the second/inner tag, if
+			 * enabled, is extracted in L2TAG1.
+			 */
+			ice_vsi_update_l2tsel(vsi, l2tsel);
 		}
 	}
 
-	mutex_unlock(rule_lock);
+	ethertype_setting = strip_msg->inner_ethertype_setting;
+	if (ethertype_setting &&
+	    ice_vc_ena_vlan_offload(vsi, vsi->inner_vlan_ops.ena_stripping,
+				    ethertype_setting)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	return false;
+out:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
+				     v_ret, NULL, 0);
 }
 
 /**
- * ice_set_vf_mac
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @mac: MAC address
+ * ice_vc_dis_vlan_stripping_v2_msg
+ * @vf: VF the message was received from
+ * @msg: message received from the VF
  *
- * program VF MAC address
+ * virthcnl handler for VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2
  */
-int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
+static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_vf *vf;
-	int ret;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vlan_supported_caps *stripping_support;
+	struct virtchnl_vlan_setting *strip_msg =
+		(struct virtchnl_vlan_setting *)msg;
+	u32 ethertype_setting;
+	struct ice_vsi *vsi;
 
-	if (is_multicast_ether_addr(mac)) {
-		netdev_err(netdev, "%pM not a valid unicast address\n", mac);
-		return -EINVAL;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
 	}
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
-	/* nothing left to do, unicast MAC already set */
-	if (ether_addr_equal(vf->dev_lan_addr.addr, mac) &&
-	    ether_addr_equal(vf->hw_lan_addr.addr, mac)) {
-		ret = 0;
-		goto out_put_vf;
+	if (!ice_vc_isvalid_vsi_id(vf, strip_msg->vport_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	if (ice_unicast_mac_exists(pf, mac)) {
-		netdev_err(netdev, "Unicast MAC %pM already exists on this PF. Preventing setting VF %u unicast MAC address to %pM\n",
-			   mac, vf_id, mac);
-		ret = -EINVAL;
-		goto out_put_vf;
+	stripping_support = &vf->vlan_v2_caps.offloads.stripping_support;
+	if (!ice_vc_valid_vlan_setting_msg(stripping_support, strip_msg)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
 	}
 
-	mutex_lock(&vf->cfg_lock);
+	ethertype_setting = strip_msg->outer_ethertype_setting;
+	if (ethertype_setting) {
+		if (vsi->outer_vlan_ops.dis_stripping(vsi)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto out;
+		} else {
+			enum ice_l2tsel l2tsel =
+				ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1;
 
-	/* VF is notified of its new MAC via the PF's response to the
-	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
-	 */
-	ether_addr_copy(vf->dev_lan_addr.addr, mac);
-	ether_addr_copy(vf->hw_lan_addr.addr, mac);
-	if (is_zero_ether_addr(mac)) {
-		/* VF will send VIRTCHNL_OP_ADD_ETH_ADDR message with its MAC */
-		vf->pf_set_mac = false;
-		netdev_info(netdev, "Removing MAC on VF %d. VF driver will be reinitialized\n",
-			    vf->vf_id);
-	} else {
-		/* PF will add MAC rule for the VF */
-		vf->pf_set_mac = true;
-		netdev_info(netdev, "Setting MAC %pM on VF %d. VF driver will be reinitialized\n",
-			    mac, vf_id);
+			/* PF tells the VF that the outer VLAN tag is always
+			 * extracted to VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 and
+			 * inner is always extracted to
+			 * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1. This is needed to
+			 * support inner stripping while outer stripping is
+			 * disabled so that the first and only tag is extracted
+			 * in L2TAG1.
+			 */
+			ice_vsi_update_l2tsel(vsi, l2tsel);
+		}
 	}
 
-	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
-	mutex_unlock(&vf->cfg_lock);
+	ethertype_setting = strip_msg->inner_ethertype_setting;
+	if (ethertype_setting && vsi->inner_vlan_ops.dis_stripping(vsi)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
+out:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
+				     v_ret, NULL, 0);
 }
 
 /**
- * ice_set_vf_trust
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @trusted: Boolean value to enable/disable trusted VF
+ * ice_vc_ena_vlan_insertion_v2_msg
+ * @vf: VF the message was received from
+ * @msg: message received from the VF
  *
- * Enable or disable a given VF as trusted
+ * virthcnl handler for VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2
  */
-int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
+static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_vf *vf;
-	int ret;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vlan_supported_caps *insertion_support;
+	struct virtchnl_vlan_setting *insertion_msg =
+		(struct virtchnl_vlan_setting *)msg;
+	u32 ethertype_setting;
+	struct ice_vsi *vsi;
 
-	if (ice_is_eswitch_mode_switchdev(pf)) {
-		dev_info(ice_pf_to_dev(pf), "Trusted VF is forbidden in switchdev mode\n");
-		return -EOPNOTSUPP;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
 	}
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
-
-	/* Check if already trusted */
-	if (trusted == vf->trusted) {
-		ret = 0;
-		goto out_put_vf;
+	if (!ice_vc_isvalid_vsi_id(vf, insertion_msg->vport_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
 	}
 
-	mutex_lock(&vf->cfg_lock);
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	vf->trusted = trusted;
-	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
-	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
-		 vf_id, trusted ? "" : "un");
+	insertion_support = &vf->vlan_v2_caps.offloads.insertion_support;
+	if (!ice_vc_valid_vlan_setting_msg(insertion_support, insertion_msg)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	mutex_unlock(&vf->cfg_lock);
+	ethertype_setting = insertion_msg->outer_ethertype_setting;
+	if (ethertype_setting &&
+	    ice_vc_ena_vlan_offload(vsi, vsi->outer_vlan_ops.ena_insertion,
+				    ethertype_setting)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
+	ethertype_setting = insertion_msg->inner_ethertype_setting;
+	if (ethertype_setting &&
+	    ice_vc_ena_vlan_offload(vsi, vsi->inner_vlan_ops.ena_insertion,
+				    ethertype_setting)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
+
+out:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
+				     v_ret, NULL, 0);
 }
 
 /**
- * ice_set_vf_link_state
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @link_state: required link state
+ * ice_vc_dis_vlan_insertion_v2_msg
+ * @vf: VF the message was received from
+ * @msg: message received from the VF
  *
- * Set VF's link state, irrespective of physical link state status
+ * virthcnl handler for VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2
  */
-int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
+static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_vf *vf;
-	int ret;
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_vlan_supported_caps *insertion_support;
+	struct virtchnl_vlan_setting *insertion_msg =
+		(struct virtchnl_vlan_setting *)msg;
+	u32 ethertype_setting;
+	struct ice_vsi *vsi;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	switch (link_state) {
-	case IFLA_VF_LINK_STATE_AUTO:
-		vf->link_forced = false;
-		break;
-	case IFLA_VF_LINK_STATE_ENABLE:
-		vf->link_forced = true;
-		vf->link_up = true;
-		break;
-	case IFLA_VF_LINK_STATE_DISABLE:
-		vf->link_forced = true;
-		vf->link_up = false;
-		break;
-	default:
-		ret = -EINVAL;
-		goto out_put_vf;
+	if (!ice_vc_isvalid_vsi_id(vf, insertion_msg->vport_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
 	}
 
-	ice_vc_notify_vf_link_state(vf);
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
-}
+	insertion_support = &vf->vlan_v2_caps.offloads.insertion_support;
+	if (!ice_vc_valid_vlan_setting_msg(insertion_support, insertion_msg)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-/**
- * ice_calc_all_vfs_min_tx_rate - calculate cumulative min Tx rate on all VFs
- * @pf: PF associated with VFs
- */
-static int ice_calc_all_vfs_min_tx_rate(struct ice_pf *pf)
-{
-	struct ice_vf *vf;
-	unsigned int bkt;
-	int rate = 0;
+	ethertype_setting = insertion_msg->outer_ethertype_setting;
+	if (ethertype_setting && vsi->outer_vlan_ops.dis_insertion(vsi)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	rcu_read_lock();
-	ice_for_each_vf_rcu(pf, bkt, vf)
-		rate += vf->min_tx_rate;
-	rcu_read_unlock();
+	ethertype_setting = insertion_msg->inner_ethertype_setting;
+	if (ethertype_setting && vsi->inner_vlan_ops.dis_insertion(vsi)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto out;
+	}
 
-	return rate;
+out:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
+				     v_ret, NULL, 0);
 }
 
+static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
+	.get_ver_msg = ice_vc_get_ver_msg,
+	.get_vf_res_msg = ice_vc_get_vf_res_msg,
+	.reset_vf = ice_vc_reset_vf_msg,
+	.add_mac_addr_msg = ice_vc_add_mac_addr_msg,
+	.del_mac_addr_msg = ice_vc_del_mac_addr_msg,
+	.cfg_qs_msg = ice_vc_cfg_qs_msg,
+	.ena_qs_msg = ice_vc_ena_qs_msg,
+	.dis_qs_msg = ice_vc_dis_qs_msg,
+	.request_qs_msg = ice_vc_request_qs_msg,
+	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
+	.config_rss_key = ice_vc_config_rss_key,
+	.config_rss_lut = ice_vc_config_rss_lut,
+	.get_stats_msg = ice_vc_get_stats_msg,
+	.cfg_promiscuous_mode_msg = ice_vc_cfg_promiscuous_mode_msg,
+	.add_vlan_msg = ice_vc_add_vlan_msg,
+	.remove_vlan_msg = ice_vc_remove_vlan_msg,
+	.ena_vlan_stripping = ice_vc_ena_vlan_stripping,
+	.dis_vlan_stripping = ice_vc_dis_vlan_stripping,
+	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
+	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
+	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
+	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
+	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
+	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
+	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
+	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
+	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
+	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
+};
+
 /**
- * ice_min_tx_rate_oversubscribed - check if min Tx rate causes oversubscription
- * @vf: VF trying to configure min_tx_rate
- * @min_tx_rate: min Tx rate in Mbps
- *
- * Check if the min_tx_rate being passed in will cause oversubscription of total
- * min_tx_rate based on the current link speed and all other VFs configured
- * min_tx_rate
- *
- * Return true if the passed min_tx_rate would cause oversubscription, else
- * return false
+ * ice_virtchnl_set_dflt_ops - Switch to default virtchnl ops
+ * @vf: the VF to switch ops
  */
-static bool
-ice_min_tx_rate_oversubscribed(struct ice_vf *vf, int min_tx_rate)
+void ice_virtchnl_set_dflt_ops(struct ice_vf *vf)
 {
-	int link_speed_mbps = ice_get_link_speed_mbps(ice_get_vf_vsi(vf));
-	int all_vfs_min_tx_rate = ice_calc_all_vfs_min_tx_rate(vf->pf);
-
-	/* this VF's previous rate is being overwritten */
-	all_vfs_min_tx_rate -= vf->min_tx_rate;
-
-	if (all_vfs_min_tx_rate + min_tx_rate > link_speed_mbps) {
-		dev_err(ice_pf_to_dev(vf->pf), "min_tx_rate of %d Mbps on VF %u would cause oversubscription of %d Mbps based on the current link speed %d Mbps\n",
-			min_tx_rate, vf->vf_id,
-			all_vfs_min_tx_rate + min_tx_rate - link_speed_mbps,
-			link_speed_mbps);
-		return true;
-	}
-
-	return false;
+	vf->virtchnl_ops = &ice_virtchnl_dflt_ops;
 }
 
 /**
- * ice_set_vf_bw - set min/max VF bandwidth
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @min_tx_rate: Minimum Tx rate in Mbps
- * @max_tx_rate: Maximum Tx rate in Mbps
+ * ice_vc_repr_add_mac
+ * @vf: pointer to VF
+ * @msg: virtchannel message
+ *
+ * When port representors are created, we do not add MAC rule
+ * to firmware, we store it so that PF could report same
+ * MAC as VF.
  */
-int
-ice_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
-	      int max_tx_rate)
+static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_ether_addr_list *al =
+	    (struct virtchnl_ether_addr_list *)msg;
 	struct ice_vsi *vsi;
-	struct device *dev;
-	struct ice_vf *vf;
-	int ret;
-
-	dev = ice_pf_to_dev(pf);
+	struct ice_pf *pf;
+	int i;
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
+	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto handle_mac_exit;
+	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
+	pf = vf->pf;
 
 	vsi = ice_get_vf_vsi(vf);
-
-	/* when max_tx_rate is zero that means no max Tx rate limiting, so only
-	 * check if max_tx_rate is non-zero
-	 */
-	if (max_tx_rate && min_tx_rate > max_tx_rate) {
-		dev_err(dev, "Cannot set min Tx rate %d Mbps greater than max Tx rate %d Mbps\n",
-			min_tx_rate, max_tx_rate);
-		ret = -EINVAL;
-		goto out_put_vf;
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto handle_mac_exit;
 	}
 
-	if (min_tx_rate && ice_is_dcb_active(pf)) {
-		dev_err(dev, "DCB on PF is currently enabled. VF min Tx rate limiting not allowed on this PF.\n");
-		ret = -EOPNOTSUPP;
-		goto out_put_vf;
-	}
+	for (i = 0; i < al->num_elements; i++) {
+		u8 *mac_addr = al->list[i].addr;
+		int result;
 
-	if (ice_min_tx_rate_oversubscribed(vf, min_tx_rate)) {
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
+		if (!is_unicast_ether_addr(mac_addr) ||
+		    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
+			continue;
 
-	if (vf->min_tx_rate != (unsigned int)min_tx_rate) {
-		ret = ice_set_min_bw_limit(vsi, (u64)min_tx_rate * 1000);
-		if (ret) {
-			dev_err(dev, "Unable to set min-tx-rate for VF %d\n",
-				vf->vf_id);
-			goto out_put_vf;
+		if (vf->pf_set_mac) {
+			dev_err(ice_pf_to_dev(pf), "VF attempting to override administratively set MAC address\n");
+			v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
+			goto handle_mac_exit;
 		}
 
-		vf->min_tx_rate = min_tx_rate;
-	}
-
-	if (vf->max_tx_rate != (unsigned int)max_tx_rate) {
-		ret = ice_set_max_bw_limit(vsi, (u64)max_tx_rate * 1000);
-		if (ret) {
-			dev_err(dev, "Unable to set max-tx-rate for VF %d\n",
-				vf->vf_id);
-			goto out_put_vf;
+		result = ice_eswitch_add_vf_mac_rule(pf, vf, mac_addr);
+		if (result) {
+			dev_err(ice_pf_to_dev(pf), "Failed to add MAC %pM for VF %d\n, error %d\n",
+				mac_addr, vf->vf_id, result);
+			goto handle_mac_exit;
 		}
 
-		vf->max_tx_rate = max_tx_rate;
+		ice_vfhw_mac_add(vf, &al->list[i]);
+		vf->num_mac++;
+		break;
 	}
 
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
+handle_mac_exit:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				     v_ret, NULL, 0);
 }
 
 /**
- * ice_get_vf_stats - populate some stats for the VF
- * @netdev: the netdev of the PF
- * @vf_id: the host OS identifier (0-255)
- * @vf_stats: pointer to the OS memory to be initialized
+ * ice_vc_repr_del_mac - response with success for deleting MAC
+ * @vf: pointer to VF
+ * @msg: virtchannel message
+ *
+ * Respond with success to not break normal VF flow.
+ * For legacy VF driver try to update cached MAC address.
  */
-int ice_get_vf_stats(struct net_device *netdev, int vf_id,
-		     struct ifla_vf_stats *vf_stats)
+static int
+ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_eth_stats *stats;
-	struct ice_vsi *vsi;
-	struct ice_vf *vf;
-	int ret;
+	struct virtchnl_ether_addr_list *al =
+		(struct virtchnl_ether_addr_list *)msg;
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
+	ice_update_legacy_cached_mac(vf, &al->list[0]);
 
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+}
 
-	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
+static int ice_vc_repr_add_vlan(struct ice_vf *vf, u8 __always_unused *msg)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't add VLAN in switchdev mode for VF %d\n", vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+}
 
-	ice_update_eth_stats(vsi);
-	stats = &vsi->eth_stats;
-
-	memset(vf_stats, 0, sizeof(*vf_stats));
-
-	vf_stats->rx_packets = stats->rx_unicast + stats->rx_broadcast +
-		stats->rx_multicast;
-	vf_stats->tx_packets = stats->tx_unicast + stats->tx_broadcast +
-		stats->tx_multicast;
-	vf_stats->rx_bytes   = stats->rx_bytes;
-	vf_stats->tx_bytes   = stats->tx_bytes;
-	vf_stats->broadcast  = stats->rx_broadcast;
-	vf_stats->multicast  = stats->rx_multicast;
-	vf_stats->rx_dropped = stats->rx_discards;
-	vf_stats->tx_dropped = stats->tx_discards;
-
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
+static int ice_vc_repr_del_vlan(struct ice_vf *vf, u8 __always_unused *msg)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't delete VLAN in switchdev mode for VF %d\n", vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+}
+
+static int ice_vc_repr_ena_vlan_stripping(struct ice_vf *vf)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't enable VLAN stripping in switchdev mode for VF %d\n",
+		vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+				     NULL, 0);
+}
+
+static int ice_vc_repr_dis_vlan_stripping(struct ice_vf *vf)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't disable VLAN stripping in switchdev mode for VF %d\n",
+		vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+				     NULL, 0);
+}
+
+static int
+ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't config promiscuous mode in switchdev mode for VF %d\n",
+		vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+				     NULL, 0);
 }
 
+static const struct ice_virtchnl_ops ice_virtchnl_repr_ops = {
+	.get_ver_msg = ice_vc_get_ver_msg,
+	.get_vf_res_msg = ice_vc_get_vf_res_msg,
+	.reset_vf = ice_vc_reset_vf_msg,
+	.add_mac_addr_msg = ice_vc_repr_add_mac,
+	.del_mac_addr_msg = ice_vc_repr_del_mac,
+	.cfg_qs_msg = ice_vc_cfg_qs_msg,
+	.ena_qs_msg = ice_vc_ena_qs_msg,
+	.dis_qs_msg = ice_vc_dis_qs_msg,
+	.request_qs_msg = ice_vc_request_qs_msg,
+	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
+	.config_rss_key = ice_vc_config_rss_key,
+	.config_rss_lut = ice_vc_config_rss_lut,
+	.get_stats_msg = ice_vc_get_stats_msg,
+	.cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode,
+	.add_vlan_msg = ice_vc_repr_add_vlan,
+	.remove_vlan_msg = ice_vc_repr_del_vlan,
+	.ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping,
+	.dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping,
+	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
+	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
+	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
+	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
+	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
+	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
+	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
+	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
+	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
+	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
+};
+
 /**
- * ice_is_supported_port_vlan_proto - make sure the vlan_proto is supported
- * @hw: hardware structure used to check the VLAN mode
- * @vlan_proto: VLAN TPID being checked
- *
- * If the device is configured in Double VLAN Mode (DVM), then both ETH_P_8021Q
- * and ETH_P_8021AD are supported. If the device is configured in Single VLAN
- * Mode (SVM), then only ETH_P_8021Q is supported.
+ * ice_virtchnl_set_repr_ops - Switch to representor virtchnl ops
+ * @vf: the VF to switch ops
  */
-static bool
-ice_is_supported_port_vlan_proto(struct ice_hw *hw, u16 vlan_proto)
+void ice_virtchnl_set_repr_ops(struct ice_vf *vf)
 {
-	bool is_supported = false;
-
-	switch (vlan_proto) {
-	case ETH_P_8021Q:
-		is_supported = true;
-		break;
-	case ETH_P_8021AD:
-		if (ice_is_dvm_ena(hw))
-			is_supported = true;
-		break;
-	}
-
-	return is_supported;
+	vf->virtchnl_ops = &ice_virtchnl_repr_ops;
 }
 
 /**
- * ice_set_vf_port_vlan
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @vlan_id: VLAN ID being set
- * @qos: priority setting
- * @vlan_proto: VLAN protocol
+ * ice_vc_process_vf_msg - Process request from VF
+ * @pf: pointer to the PF structure
+ * @event: pointer to the AQ event
  *
- * program VF Port VLAN ID and/or QoS
+ * called from the common asq/arq handler to
+ * process request from VF
  */
-int
-ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
-		     __be16 vlan_proto)
+void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 {
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	u16 local_vlan_proto = ntohs(vlan_proto);
+	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
+	s16 vf_id = le16_to_cpu(event->desc.retval);
+	const struct ice_virtchnl_ops *ops;
+	u16 msglen = event->msg_len;
+	u8 *msg = event->msg_buf;
+	struct ice_vf *vf = NULL;
 	struct device *dev;
-	struct ice_vf *vf;
-	int ret;
+	int err = 0;
 
 	dev = ice_pf_to_dev(pf);
 
-	if (vlan_id >= VLAN_N_VID || qos > 7) {
-		dev_err(dev, "Invalid Port VLAN parameters for VF %d, ID %d, QoS %d\n",
-			vf_id, vlan_id, qos);
-		return -EINVAL;
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF for message from VF ID %d, opcode %d, len %d\n",
+			vf_id, v_opcode, msglen);
+		return;
 	}
 
-	if (!ice_is_supported_port_vlan_proto(&pf->hw, local_vlan_proto)) {
-		dev_err(dev, "VF VLAN protocol 0x%04x is not supported\n",
-			local_vlan_proto);
-		return -EPROTONOSUPPORT;
+	/* Check if VF is disabled. */
+	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
+		err = -EPERM;
+		goto error_handler;
 	}
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
+	ops = vf->virtchnl_ops;
 
-	if (ice_vf_get_port_vlan_prio(vf) == qos &&
-	    ice_vf_get_port_vlan_tpid(vf) == local_vlan_proto &&
-	    ice_vf_get_port_vlan_id(vf) == vlan_id) {
-		/* duplicate request, so just return success */
-		dev_dbg(dev, "Duplicate port VLAN %u, QoS %u, TPID 0x%04x request\n",
-			vlan_id, qos, local_vlan_proto);
-		ret = 0;
-		goto out_put_vf;
+	/* Perform basic checks on the msg */
+	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
+	if (err) {
+		if (err == VIRTCHNL_STATUS_ERR_PARAM)
+			err = -EPERM;
+		else
+			err = -EINVAL;
 	}
 
-	mutex_lock(&vf->cfg_lock);
-
-	vf->port_vlan_info = ICE_VLAN(local_vlan_proto, vlan_id, qos);
-	if (ice_vf_is_port_vlan_ena(vf))
-		dev_info(dev, "Setting VLAN %u, QoS %u, TPID 0x%04x on VF %d\n",
-			 vlan_id, qos, local_vlan_proto, vf_id);
-	else
-		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
-
-	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
-	mutex_unlock(&vf->cfg_lock);
-
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
-}
-
-/**
- * ice_print_vf_rx_mdd_event - print VF Rx malicious driver detect event
- * @vf: pointer to the VF structure
- */
-void ice_print_vf_rx_mdd_event(struct ice_vf *vf)
-{
-	struct ice_pf *pf = vf->pf;
-	struct device *dev;
-
-	dev = ice_pf_to_dev(pf);
-
-	dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
-		 vf->mdd_rx_events.count, pf->hw.pf_id, vf->vf_id,
-		 vf->dev_lan_addr.addr,
-		 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
-			  ? "on" : "off");
-}
-
-/**
- * ice_print_vfs_mdd_events - print VFs malicious driver detect event
- * @pf: pointer to the PF structure
- *
- * Called from ice_handle_mdd_event to rate limit and print VFs MDD events.
- */
-void ice_print_vfs_mdd_events(struct ice_pf *pf)
-{
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_hw *hw = &pf->hw;
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	/* check that there are pending MDD events to print */
-	if (!test_and_clear_bit(ICE_MDD_VF_PRINT_PENDING, pf->state))
+	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
+		ice_vc_send_msg_to_vf(vf, v_opcode,
+				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
+				      0);
+		ice_put_vf(vf);
 		return;
+	}
 
-	/* VF MDD event logs are rate limited to one second intervals */
-	if (time_is_after_jiffies(pf->vfs.last_printed_mdd_jiffies + HZ * 1))
+error_handler:
+	if (err) {
+		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
+				      NULL, 0);
+		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
+			vf_id, v_opcode, msglen, err);
+		ice_put_vf(vf);
 		return;
-
-	pf->vfs.last_printed_mdd_jiffies = jiffies;
-
-	mutex_lock(&pf->vfs.table_lock);
-	ice_for_each_vf(pf, bkt, vf) {
-		/* only print Rx MDD event message if there are new events */
-		if (vf->mdd_rx_events.count != vf->mdd_rx_events.last_printed) {
-			vf->mdd_rx_events.last_printed =
-							vf->mdd_rx_events.count;
-			ice_print_vf_rx_mdd_event(vf);
-		}
-
-		/* only print Tx MDD event message if there are new events */
-		if (vf->mdd_tx_events.count != vf->mdd_tx_events.last_printed) {
-			vf->mdd_tx_events.last_printed =
-							vf->mdd_tx_events.count;
-
-			dev_info(dev, "%d Tx Malicious Driver Detection events detected on PF %d VF %d MAC %pM.\n",
-				 vf->mdd_tx_events.count, hw->pf_id, vf->vf_id,
-				 vf->dev_lan_addr.addr);
-		}
 	}
-	mutex_unlock(&pf->vfs.table_lock);
-}
-
-/**
- * ice_restore_all_vfs_msi_state - restore VF MSI state after PF FLR
- * @pdev: pointer to a pci_dev structure
- *
- * Called when recovering from a PF FLR to restore interrupt capability to
- * the VFs.
- */
-void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
-{
-	u16 vf_id;
-	int pos;
 
-	if (!pci_num_vf(pdev))
+	/* VF is being configured in another context that triggers a VFR, so no
+	 * need to process this message
+	 */
+	if (!mutex_trylock(&vf->cfg_lock)) {
+		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
+			 vf->vf_id);
+		ice_put_vf(vf);
 		return;
-
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
-	if (pos) {
-		struct pci_dev *vfdev;
-
-		pci_read_config_word(pdev, pos + PCI_SRIOV_VF_DID,
-				     &vf_id);
-		vfdev = pci_get_device(pdev->vendor, vf_id, NULL);
-		while (vfdev) {
-			if (vfdev->is_virtfn && vfdev->physfn == pdev)
-				pci_restore_msi_state(vfdev);
-			vfdev = pci_get_device(pdev->vendor, vf_id,
-					       vfdev);
-		}
 	}
-}
-
-/**
- * ice_is_malicious_vf - helper function to detect a malicious VF
- * @pf: ptr to struct ice_pf
- * @event: pointer to the AQ event
- * @num_msg_proc: the number of messages processed so far
- * @num_msg_pending: the number of messages peinding in admin queue
- */
-bool
-ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    u16 num_msg_proc, u16 num_msg_pending)
-{
-	s16 vf_id = le16_to_cpu(event->desc.retval);
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_mbx_data mbxdata;
-	bool malvf = false;
-	struct ice_vf *vf;
-	int status;
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return false;
-
-	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
-		goto out_put_vf;
 
-	mbxdata.num_msg_proc = num_msg_proc;
-	mbxdata.num_pending_arq = num_msg_pending;
-	mbxdata.max_num_msgs_mbx = pf->hw.mailboxq.num_rq_entries;
-#define ICE_MBX_OVERFLOW_WATERMARK 64
-	mbxdata.async_watermark_val = ICE_MBX_OVERFLOW_WATERMARK;
-
-	/* check to see if we have a malicious VF */
-	status = ice_mbx_vf_state_handler(&pf->hw, &mbxdata, vf_id, &malvf);
-	if (status)
-		goto out_put_vf;
-
-	if (malvf) {
-		bool report_vf = false;
-
-		/* if the VF is malicious and we haven't let the user
-		 * know about it, then let them know now
+	switch (v_opcode) {
+	case VIRTCHNL_OP_VERSION:
+		err = ops->get_ver_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_GET_VF_RESOURCES:
+		err = ops->get_vf_res_msg(vf, msg);
+		if (ice_vf_init_vlan_stripping(vf))
+			dev_dbg(dev, "Failed to initialize VLAN stripping for VF %d\n",
+				vf->vf_id);
+		ice_vc_notify_vf_link_state(vf);
+		break;
+	case VIRTCHNL_OP_RESET_VF:
+		ops->reset_vf(vf);
+		break;
+	case VIRTCHNL_OP_ADD_ETH_ADDR:
+		err = ops->add_mac_addr_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_DEL_ETH_ADDR:
+		err = ops->del_mac_addr_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_CONFIG_VSI_QUEUES:
+		err = ops->cfg_qs_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_ENABLE_QUEUES:
+		err = ops->ena_qs_msg(vf, msg);
+		ice_vc_notify_vf_link_state(vf);
+		break;
+	case VIRTCHNL_OP_DISABLE_QUEUES:
+		err = ops->dis_qs_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_REQUEST_QUEUES:
+		err = ops->request_qs_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_CONFIG_IRQ_MAP:
+		err = ops->cfg_irq_map_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_CONFIG_RSS_KEY:
+		err = ops->config_rss_key(vf, msg);
+		break;
+	case VIRTCHNL_OP_CONFIG_RSS_LUT:
+		err = ops->config_rss_lut(vf, msg);
+		break;
+	case VIRTCHNL_OP_GET_STATS:
+		err = ops->get_stats_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
+		err = ops->cfg_promiscuous_mode_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_ADD_VLAN:
+		err = ops->add_vlan_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_DEL_VLAN:
+		err = ops->remove_vlan_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
+		err = ops->ena_vlan_stripping(vf);
+		break;
+	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
+		err = ops->dis_vlan_stripping(vf);
+		break;
+	case VIRTCHNL_OP_ADD_FDIR_FILTER:
+		err = ops->add_fdir_fltr_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_DEL_FDIR_FILTER:
+		err = ops->del_fdir_fltr_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_ADD_RSS_CFG:
+		err = ops->handle_rss_cfg_msg(vf, msg, true);
+		break;
+	case VIRTCHNL_OP_DEL_RSS_CFG:
+		err = ops->handle_rss_cfg_msg(vf, msg, false);
+		break;
+	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS:
+		err = ops->get_offload_vlan_v2_caps(vf);
+		break;
+	case VIRTCHNL_OP_ADD_VLAN_V2:
+		err = ops->add_vlan_v2_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_DEL_VLAN_V2:
+		err = ops->remove_vlan_v2_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2:
+		err = ops->ena_vlan_stripping_v2_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2:
+		err = ops->dis_vlan_stripping_v2_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2:
+		err = ops->ena_vlan_insertion_v2_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2:
+		err = ops->dis_vlan_insertion_v2_msg(vf, msg);
+		break;
+	case VIRTCHNL_OP_UNKNOWN:
+	default:
+		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
+			vf_id);
+		err = ice_vc_send_msg_to_vf(vf, v_opcode,
+					    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+					    NULL, 0);
+		break;
+	}
+	if (err) {
+		/* Helper function cares less about error return values here
+		 * as it is busy with pending work.
 		 */
-		status = ice_mbx_report_malvf(&pf->hw, pf->vfs.malvfs,
-					      ICE_MAX_SRIOV_VFS, vf_id,
-					      &report_vf);
-		if (status)
-			dev_dbg(dev, "Error reporting malicious VF\n");
-
-		if (report_vf) {
-			struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-
-			if (pf_vsi)
-				dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-					 &vf->dev_lan_addr.addr[0],
-					 pf_vsi->netdev->dev_addr);
-		}
+		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
+			 vf_id, v_opcode, err);
 	}
 
-out_put_vf:
+	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
-	return malvf;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
new file mode 100644
index 000000000000..b5a3fd8adbb4
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2022, Intel Corporation. */
+
+#ifndef _ICE_VIRTCHNL_H_
+#define _ICE_VIRTCHNL_H_
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/if_ether.h>
+#include <linux/avf/virtchnl.h>
+#include "ice_vf_lib.h"
+
+/* Restrict number of MAC Addr and VLAN that non-trusted VF can programmed */
+#define ICE_MAX_VLAN_PER_VF		8
+
+/* MAC filters: 1 is reserved for the VF's default/perm_addr/LAA MAC, 1 for
+ * broadcast, and 16 for additional unicast/multicast filters
+ */
+#define ICE_MAX_MACADDR_PER_VF		18
+
+struct ice_virtchnl_ops {
+	int (*get_ver_msg)(struct ice_vf *vf, u8 *msg);
+	int (*get_vf_res_msg)(struct ice_vf *vf, u8 *msg);
+	void (*reset_vf)(struct ice_vf *vf);
+	int (*add_mac_addr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*del_mac_addr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*cfg_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*ena_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*dis_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*request_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*cfg_irq_map_msg)(struct ice_vf *vf, u8 *msg);
+	int (*config_rss_key)(struct ice_vf *vf, u8 *msg);
+	int (*config_rss_lut)(struct ice_vf *vf, u8 *msg);
+	int (*get_stats_msg)(struct ice_vf *vf, u8 *msg);
+	int (*cfg_promiscuous_mode_msg)(struct ice_vf *vf, u8 *msg);
+	int (*add_vlan_msg)(struct ice_vf *vf, u8 *msg);
+	int (*remove_vlan_msg)(struct ice_vf *vf, u8 *msg);
+	int (*ena_vlan_stripping)(struct ice_vf *vf);
+	int (*dis_vlan_stripping)(struct ice_vf *vf);
+	int (*handle_rss_cfg_msg)(struct ice_vf *vf, u8 *msg, bool add);
+	int (*add_fdir_fltr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*del_fdir_fltr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*get_offload_vlan_v2_caps)(struct ice_vf *vf);
+	int (*add_vlan_v2_msg)(struct ice_vf *vf, u8 *msg);
+	int (*remove_vlan_v2_msg)(struct ice_vf *vf, u8 *msg);
+	int (*ena_vlan_stripping_v2_msg)(struct ice_vf *vf, u8 *msg);
+	int (*dis_vlan_stripping_v2_msg)(struct ice_vf *vf, u8 *msg);
+	int (*ena_vlan_insertion_v2_msg)(struct ice_vf *vf, u8 *msg);
+	int (*dis_vlan_insertion_v2_msg)(struct ice_vf *vf, u8 *msg);
+};
+
+#ifdef CONFIG_PCI_IOV
+void ice_virtchnl_set_dflt_ops(struct ice_vf *vf);
+void ice_virtchnl_set_repr_ops(struct ice_vf *vf);
+void ice_vc_notify_vf_link_state(struct ice_vf *vf);
+void ice_vc_notify_link_state(struct ice_pf *pf);
+void ice_vc_notify_reset(struct ice_pf *pf);
+int
+ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
+		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
+bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
+#else /* CONFIG_PCI_IOV */
+static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
+static inline void ice_virtchnl_set_repr_ops(struct ice_vf *vf) { }
+static inline void ice_vc_notify_vf_link_state(struct ice_vf *vf) { }
+static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
+static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
+
+static inline int
+ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
+		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
+{
+	return false;
+}
+#endif /* !CONFIG_PCI_IOV */
+
+#endif /* _ICE_VIRTCHNL_H_ */
-- 
2.31.1

