Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D705A3685EE
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhDVRaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:60041 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238530AbhDVRaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:14 -0400
IronPort-SDR: KkwGyLPmv5B50PMUVF92D1SIscJHn2ej1ArrQ8TWkuBb6ChQ21W2PZ+FKR/b6V9BpM2PHqYfSB
 yzpzvl+jeUIg==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991484"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991484"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:36 -0700
IronPort-SDR: Gf+onW1QMylW3wMva5P85w9iWa+xveqqhUQVwhtI3umRi2W4KWt+P0nU9Z/kUx75ZX6/T+EDv1
 sTUEovJayJ8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286283"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Vignesh Sridhar <vignesh.sridhar@intel.com>,
        Jia Guo <jia.guo@intel.com>,
        Haiyue Wang <haiyue.wang@intel.com>,
        Bo Chen <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 08/12] ice: Support RSS configure removal for AVF
Date:   Thu, 22 Apr 2021 10:31:26 -0700
Message-Id: <20210422173130.1143082-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

Add the handler for virtchnl message VIRTCHNL_OP_DEL_RSS_CFG to remove
an existing RSS configuration with matching hashed fields.

Signed-off-by: Vignesh Sridhar <vignesh.sridhar@intel.com>
Co-developed-by: Jia Guo <jia.guo@intel.com>
Signed-off-by: Jia Guo <jia.guo@intel.com>
Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Bo Chen <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c     | 88 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     |  3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 16 +++-
 3 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 4d59eb96383b..f160672448a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -2149,6 +2149,94 @@ ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 	return status;
 }
 
+/**
+ * ice_rem_rss_cfg_sync - remove an existing RSS configuration
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ * @hashed_flds: Packet hash types (ICE_FLOW_HASH_*) to remove
+ * @addl_hdrs: Protocol header fields within a packet segment
+ * @segs_cnt: packet segment count
+ *
+ * Assumption: lock has already been acquired for RSS list
+ */
+static enum ice_status
+ice_rem_rss_cfg_sync(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
+		     u32 addl_hdrs, u8 segs_cnt)
+{
+	const enum ice_block blk = ICE_BLK_RSS;
+	struct ice_flow_seg_info *segs;
+	struct ice_flow_prof *prof;
+	enum ice_status status;
+
+	segs = kcalloc(segs_cnt, sizeof(*segs), GFP_KERNEL);
+	if (!segs)
+		return ICE_ERR_NO_MEMORY;
+
+	/* Construct the packet segment info from the hashed fields */
+	status = ice_flow_set_rss_seg_info(&segs[segs_cnt - 1], hashed_flds,
+					   addl_hdrs);
+	if (status)
+		goto out;
+
+	prof = ice_flow_find_prof_conds(hw, blk, ICE_FLOW_RX, segs, segs_cnt,
+					vsi_handle,
+					ICE_FLOW_FIND_PROF_CHK_FLDS);
+	if (!prof) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+		goto out;
+	}
+
+	status = ice_flow_disassoc_prof(hw, blk, prof, vsi_handle);
+	if (status)
+		goto out;
+
+	/* Remove RSS configuration from VSI context before deleting
+	 * the flow profile.
+	 */
+	ice_rem_rss_list(hw, vsi_handle, prof);
+
+	if (bitmap_empty(prof->vsis, ICE_MAX_VSI))
+		status = ice_flow_rem_prof(hw, blk, prof->id);
+
+out:
+	kfree(segs);
+	return status;
+}
+
+/**
+ * ice_rem_rss_cfg - remove an existing RSS config with matching hashed fields
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ * @hashed_flds: Packet hash types (ICE_FLOW_HASH_*) to remove
+ * @addl_hdrs: Protocol header fields within a packet segment
+ *
+ * This function will lookup the flow profile based on the input
+ * hash field bitmap, iterate through the profile entry list of
+ * that profile and find entry associated with input VSI to be
+ * removed. Calls are made to underlying flow s which will APIs
+ * turn build or update buffers for RSS XLT1 section.
+ */
+enum ice_status __maybe_unused
+ice_rem_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
+		u32 addl_hdrs)
+{
+	enum ice_status status;
+
+	if (hashed_flds == ICE_HASH_INVALID ||
+	    !ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	mutex_lock(&hw->rss_locks);
+	status = ice_rem_rss_cfg_sync(hw, vsi_handle, hashed_flds, addl_hdrs,
+				      ICE_RSS_OUTER_HEADERS);
+	if (!status)
+		status = ice_rem_rss_cfg_sync(hw, vsi_handle, hashed_flds,
+					      addl_hdrs, ICE_RSS_INNER_HEADERS);
+	mutex_unlock(&hw->rss_locks);
+
+	return status;
+}
+
 /* Mapping of AVF hash bit fields to an L3-L4 hash combination.
  * As the ice_flow_avf_hdr_field represent individual bit shifts in a hash,
  * convert its values to their appropriate flow L3, L4 values.
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 2f68b59ace7e..2a2d8c1536cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -409,5 +409,8 @@ enum ice_status ice_rem_vsi_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 		u32 addl_hdrs);
+enum ice_status
+ice_rem_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
+		u32 addl_hdrs);
 u64 ice_get_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u32 hdrs);
 #endif /* _ICE_FLOW_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ca778a80d363..a1d22d2aa0bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2672,8 +2672,20 @@ static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
 					vsi->vsi_num, v_ret);
 			}
 		} else {
-			v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-			dev_err(dev, "RSS removal not supported\n");
+			enum ice_status status;
+
+			status = ice_rem_rss_cfg(hw, vsi->idx, hash_flds,
+						 addl_hdrs);
+			/* We just ignore ICE_ERR_DOES_NOT_EXIST, because
+			 * if two configurations share the same profile remove
+			 * one of them actually removes both, since the
+			 * profile is deleted.
+			 */
+			if (status && status != ICE_ERR_DOES_NOT_EXIST) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_err(dev, "ice_rem_rss_cfg failed for VF ID:%d, error:%s\n",
+					vf->vf_id, ice_stat_str(status));
+			}
 		}
 	}
 
-- 
2.26.2

