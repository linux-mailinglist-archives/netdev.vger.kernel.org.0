Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1997914996A
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgAZGHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:62580 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgAZGHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947219"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/8] ice: Initilialize VF RSS tables
Date:   Sat, 25 Jan 2020 22:07:35 -0800
Message-Id: <20200126060737.3238027-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
References: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>

Set configuration for hardware RSS tables for VFs.

Signed-off-by: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c     | 135 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     |  59 ++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  31 +++-
 .../ethernet/intel/ice/ice_protocol_type.h    |   1 +
 4 files changed, 225 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index ffce2284d8fa..4ecac0ae565a 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -38,6 +38,11 @@ struct ice_flow_field_info ice_flds_info[ICE_FLOW_FIELD_IDX_MAX] = {
 	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_UDP, 0, sizeof(__be16)),
 	/* ICE_FLOW_FIELD_IDX_UDP_DST_PORT */
 	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_UDP, 2, sizeof(__be16)),
+	/* ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_SCTP, 0, sizeof(__be16)),
+	/* ICE_FLOW_FIELD_IDX_SCTP_DST_PORT */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_SCTP, 2, sizeof(__be16)),
+
 };
 
 /* Bitmaps indicating relevant packet types for a particular protocol header
@@ -266,6 +271,10 @@ ice_flow_xtract_fld(struct ice_hw *hw, struct ice_flow_prof_params *params,
 	case ICE_FLOW_FIELD_IDX_UDP_DST_PORT:
 		prot_id = ICE_PROT_UDP_IL_OR_S;
 		break;
+	case ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT:
+	case ICE_FLOW_FIELD_IDX_SCTP_DST_PORT:
+		prot_id = ICE_PROT_SCTP_IL;
+		break;
 	default:
 		return ICE_ERR_NOT_IMPL;
 	}
@@ -1081,6 +1090,132 @@ ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 	return status;
 }
 
+/* Mapping of AVF hash bit fields to an L3-L4 hash combination.
+ * As the ice_flow_avf_hdr_field represent individual bit shifts in a hash,
+ * convert its values to their appropriate flow L3, L4 values.
+ */
+#define ICE_FLOW_AVF_RSS_IPV4_MASKS \
+	(BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_OTHER) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_FRAG_IPV4))
+#define ICE_FLOW_AVF_RSS_TCP_IPV4_MASKS \
+	(BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_TCP_SYN_NO_ACK) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_TCP))
+#define ICE_FLOW_AVF_RSS_UDP_IPV4_MASKS \
+	(BIT_ULL(ICE_AVF_FLOW_FIELD_UNICAST_IPV4_UDP) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_MULTICAST_IPV4_UDP) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_UDP))
+#define ICE_FLOW_AVF_RSS_ALL_IPV4_MASKS \
+	(ICE_FLOW_AVF_RSS_TCP_IPV4_MASKS | ICE_FLOW_AVF_RSS_UDP_IPV4_MASKS | \
+	 ICE_FLOW_AVF_RSS_IPV4_MASKS | BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_SCTP))
+
+#define ICE_FLOW_AVF_RSS_IPV6_MASKS \
+	(BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_OTHER) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_FRAG_IPV6))
+#define ICE_FLOW_AVF_RSS_UDP_IPV6_MASKS \
+	(BIT_ULL(ICE_AVF_FLOW_FIELD_UNICAST_IPV6_UDP) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_MULTICAST_IPV6_UDP) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_UDP))
+#define ICE_FLOW_AVF_RSS_TCP_IPV6_MASKS \
+	(BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_TCP_SYN_NO_ACK) | \
+	 BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_TCP))
+#define ICE_FLOW_AVF_RSS_ALL_IPV6_MASKS \
+	(ICE_FLOW_AVF_RSS_TCP_IPV6_MASKS | ICE_FLOW_AVF_RSS_UDP_IPV6_MASKS | \
+	 ICE_FLOW_AVF_RSS_IPV6_MASKS | BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_SCTP))
+
+/**
+ * ice_add_avf_rss_cfg - add an RSS configuration for AVF driver
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ * @avf_hash: hash bit fields (ICE_AVF_FLOW_FIELD_*) to configure
+ *
+ * This function will take the hash bitmap provided by the AVF driver via a
+ * message, convert it to ICE-compatible values, and configure RSS flow
+ * profiles.
+ */
+enum ice_status
+ice_add_avf_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 avf_hash)
+{
+	enum ice_status status = 0;
+	u64 hash_flds;
+
+	if (avf_hash == ICE_AVF_FLOW_FIELD_INVALID ||
+	    !ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	/* Make sure no unsupported bits are specified */
+	if (avf_hash & ~(ICE_FLOW_AVF_RSS_ALL_IPV4_MASKS |
+			 ICE_FLOW_AVF_RSS_ALL_IPV6_MASKS))
+		return ICE_ERR_CFG;
+
+	hash_flds = avf_hash;
+
+	/* Always create an L3 RSS configuration for any L4 RSS configuration */
+	if (hash_flds & ICE_FLOW_AVF_RSS_ALL_IPV4_MASKS)
+		hash_flds |= ICE_FLOW_AVF_RSS_IPV4_MASKS;
+
+	if (hash_flds & ICE_FLOW_AVF_RSS_ALL_IPV6_MASKS)
+		hash_flds |= ICE_FLOW_AVF_RSS_IPV6_MASKS;
+
+	/* Create the corresponding RSS configuration for each valid hash bit */
+	while (hash_flds) {
+		u64 rss_hash = ICE_HASH_INVALID;
+
+		if (hash_flds & ICE_FLOW_AVF_RSS_ALL_IPV4_MASKS) {
+			if (hash_flds & ICE_FLOW_AVF_RSS_IPV4_MASKS) {
+				rss_hash = ICE_FLOW_HASH_IPV4;
+				hash_flds &= ~ICE_FLOW_AVF_RSS_IPV4_MASKS;
+			} else if (hash_flds &
+				   ICE_FLOW_AVF_RSS_TCP_IPV4_MASKS) {
+				rss_hash = ICE_FLOW_HASH_IPV4 |
+					ICE_FLOW_HASH_TCP_PORT;
+				hash_flds &= ~ICE_FLOW_AVF_RSS_TCP_IPV4_MASKS;
+			} else if (hash_flds &
+				   ICE_FLOW_AVF_RSS_UDP_IPV4_MASKS) {
+				rss_hash = ICE_FLOW_HASH_IPV4 |
+					ICE_FLOW_HASH_UDP_PORT;
+				hash_flds &= ~ICE_FLOW_AVF_RSS_UDP_IPV4_MASKS;
+			} else if (hash_flds &
+				   BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_SCTP)) {
+				rss_hash = ICE_FLOW_HASH_IPV4 |
+					ICE_FLOW_HASH_SCTP_PORT;
+				hash_flds &=
+					~BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_SCTP);
+			}
+		} else if (hash_flds & ICE_FLOW_AVF_RSS_ALL_IPV6_MASKS) {
+			if (hash_flds & ICE_FLOW_AVF_RSS_IPV6_MASKS) {
+				rss_hash = ICE_FLOW_HASH_IPV6;
+				hash_flds &= ~ICE_FLOW_AVF_RSS_IPV6_MASKS;
+			} else if (hash_flds &
+				   ICE_FLOW_AVF_RSS_TCP_IPV6_MASKS) {
+				rss_hash = ICE_FLOW_HASH_IPV6 |
+					ICE_FLOW_HASH_TCP_PORT;
+				hash_flds &= ~ICE_FLOW_AVF_RSS_TCP_IPV6_MASKS;
+			} else if (hash_flds &
+				   ICE_FLOW_AVF_RSS_UDP_IPV6_MASKS) {
+				rss_hash = ICE_FLOW_HASH_IPV6 |
+					ICE_FLOW_HASH_UDP_PORT;
+				hash_flds &= ~ICE_FLOW_AVF_RSS_UDP_IPV6_MASKS;
+			} else if (hash_flds &
+				   BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_SCTP)) {
+				rss_hash = ICE_FLOW_HASH_IPV6 |
+					ICE_FLOW_HASH_SCTP_PORT;
+				hash_flds &=
+					~BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_SCTP);
+			}
+		}
+
+		if (rss_hash == ICE_HASH_INVALID)
+			return ICE_ERR_OUT_OF_RANGE;
+
+		status = ice_add_rss_cfg(hw, vsi_handle, rss_hash,
+					 ICE_FLOW_SEG_HDR_NONE);
+		if (status)
+			break;
+	}
+
+	return status;
+}
+
 /**
  * ice_replay_rss_cfg - replay RSS configurations associated with VSI
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 38669b077209..475a025d3a2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -20,6 +20,9 @@
 #define ICE_FLOW_HASH_UDP_PORT	\
 	(BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_SRC_PORT) | \
 	 BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_DST_PORT))
+#define ICE_FLOW_HASH_SCTP_PORT	\
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT) | \
+	 BIT_ULL(ICE_FLOW_FIELD_IDX_SCTP_DST_PORT))
 
 #define ICE_HASH_INVALID	0
 #define ICE_HASH_TCP_IPV4	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_TCP_PORT)
@@ -53,10 +56,64 @@ enum ice_flow_field {
 	ICE_FLOW_FIELD_IDX_TCP_DST_PORT,
 	ICE_FLOW_FIELD_IDX_UDP_SRC_PORT,
 	ICE_FLOW_FIELD_IDX_UDP_DST_PORT,
+	ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT,
+	ICE_FLOW_FIELD_IDX_SCTP_DST_PORT,
 	/* The total number of enums must not exceed 64 */
 	ICE_FLOW_FIELD_IDX_MAX
 };
 
+/* Flow headers and fields for AVF support */
+enum ice_flow_avf_hdr_field {
+	/* Values 0 - 28 are reserved for future use */
+	ICE_AVF_FLOW_FIELD_INVALID		= 0,
+	ICE_AVF_FLOW_FIELD_UNICAST_IPV4_UDP	= 29,
+	ICE_AVF_FLOW_FIELD_MULTICAST_IPV4_UDP,
+	ICE_AVF_FLOW_FIELD_IPV4_UDP,
+	ICE_AVF_FLOW_FIELD_IPV4_TCP_SYN_NO_ACK,
+	ICE_AVF_FLOW_FIELD_IPV4_TCP,
+	ICE_AVF_FLOW_FIELD_IPV4_SCTP,
+	ICE_AVF_FLOW_FIELD_IPV4_OTHER,
+	ICE_AVF_FLOW_FIELD_FRAG_IPV4,
+	/* Values 37-38 are reserved */
+	ICE_AVF_FLOW_FIELD_UNICAST_IPV6_UDP	= 39,
+	ICE_AVF_FLOW_FIELD_MULTICAST_IPV6_UDP,
+	ICE_AVF_FLOW_FIELD_IPV6_UDP,
+	ICE_AVF_FLOW_FIELD_IPV6_TCP_SYN_NO_ACK,
+	ICE_AVF_FLOW_FIELD_IPV6_TCP,
+	ICE_AVF_FLOW_FIELD_IPV6_SCTP,
+	ICE_AVF_FLOW_FIELD_IPV6_OTHER,
+	ICE_AVF_FLOW_FIELD_FRAG_IPV6,
+	ICE_AVF_FLOW_FIELD_RSVD47,
+	ICE_AVF_FLOW_FIELD_FCOE_OX,
+	ICE_AVF_FLOW_FIELD_FCOE_RX,
+	ICE_AVF_FLOW_FIELD_FCOE_OTHER,
+	/* Values 51-62 are reserved */
+	ICE_AVF_FLOW_FIELD_L2_PAYLOAD		= 63,
+	ICE_AVF_FLOW_FIELD_MAX
+};
+
+/* Supported RSS offloads  This macro is defined to support
+ * VIRTCHNL_OP_GET_RSS_HENA_CAPS ops. PF driver sends the RSS hardware
+ * capabilities to the caller of this ops.
+ */
+#define ICE_DEFAULT_RSS_HENA ( \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_UDP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_SCTP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_TCP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_OTHER) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_FRAG_IPV4) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_UDP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_TCP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_SCTP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_OTHER) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_FRAG_IPV6) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV4_TCP_SYN_NO_ACK) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_UNICAST_IPV4_UDP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_MULTICAST_IPV4_UDP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_IPV6_TCP_SYN_NO_ACK) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_UNICAST_IPV6_UDP) | \
+	BIT_ULL(ICE_AVF_FLOW_FIELD_MULTICAST_IPV6_UDP))
+
 enum ice_flow_dir {
 	ICE_FLOW_RX		= 0x02,
 };
@@ -140,6 +197,8 @@ struct ice_rss_cfg {
 enum ice_status ice_flow_rem_entry(struct ice_hw *hw, u64 entry_h);
 void ice_rem_vsi_rss_list(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
+enum ice_status
+ice_add_avf_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds);
 enum ice_status ice_rem_vsi_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index caa3edd5d3d6..1874c9f51a32 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1113,6 +1113,33 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	return err;
 }
 
+/**
+ * ice_vsi_set_vf_rss_flow_fld - Sets VF VSI RSS input set for different flows
+ * @vsi: VSI to be configured
+ *
+ * This function will only be called during the VF VSI setup. Upon successful
+ * completion of package download, this function will configure default RSS
+ * input sets for VF VSI.
+ */
+static void ice_vsi_set_vf_rss_flow_fld(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	enum ice_status status;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
+	if (ice_is_safe_mode(pf)) {
+		dev_dbg(dev, "Advanced RSS disabled. Package download failed, vsi num = %d\n",
+			vsi->vsi_num);
+		return;
+	}
+
+	status = ice_add_avf_rss_cfg(&pf->hw, vsi->idx, ICE_DEFAULT_RSS_HENA);
+	if (status)
+		dev_dbg(dev, "ice_add_avf_rss_cfg failed for vsi = %d, error = %d\n",
+			vsi->vsi_num, status);
+}
+
 /**
  * ice_vsi_set_rss_flow_fld - Sets RSS input set for different flows
  * @vsi: VSI to be configured
@@ -2037,8 +2064,10 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		 * receive traffic on first queue. Hence no need to capture
 		 * return value
 		 */
-		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
+		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 			ice_vsi_cfg_rss_lut_key(vsi);
+			ice_vsi_set_vf_rss_flow_fld(vsi);
+		}
 		break;
 	case ICE_VSI_LB:
 		ret = ice_vsi_alloc_rings(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 97db46ce7a21..71647566964e 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -18,6 +18,7 @@ enum ice_prot_id {
 	ICE_PROT_IPV6_IL	= 41,
 	ICE_PROT_TCP_IL		= 49,
 	ICE_PROT_UDP_IL_OR_S	= 53,
+	ICE_PROT_SCTP_IL	= 96,
 	ICE_PROT_META_ID	= 255, /* when offset == metadata */
 	ICE_PROT_INVALID	= 255  /* when offset == ICE_FV_OFFSET_INVAL */
 };
-- 
2.24.1

