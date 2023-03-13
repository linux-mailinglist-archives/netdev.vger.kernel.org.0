Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC886B8067
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCMSZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCMSZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519B57FD51
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731918; x=1710267918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2OD/Ff81UHbAQ4A8rBgy4vcg0X9C1hLySVI95ExtnzM=;
  b=Zi2FVSJdO/JEehI0C/CunK4kmCxLGOWav4z3FD/GLS7AfzNGg5oUyS3E
   Oq68c3/GTeeNKyBaFpD9FwEE6Vi6dew0o+N1lg2+VPmVYIEUC+2zOhVLz
   XDBRrCRk8S30Oa/xltB2c9ZaduPQqfvT0kHpzp/tI2T1oyw8+rVrlXK8a
   Tb/CZR0M2Gj09d2kstA/24gdNs2IUEJUzZrd32QZKzx1g0obbylL7bkgG
   6+QkrGlHzly7pmYTXoVl6U2CWqe/NjZzj9cYSAc9yIrXdTdpy8ytpw2vw
   rxKiZ6DKDczCVX5AXyfkmXQJU7e6hoyQlCVWn76EKWZ50TpVxOccN6hkM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772337"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772337"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:22:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809021"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809021"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:22:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 02/14] ice: convert ice_mbx_clear_malvf to void and use WARN
Date:   Mon, 13 Mar 2023 11:21:11 -0700
Message-Id: <20230313182123.483057-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_mbx_clear_malvf function checks for a few error conditions before
clearing the appropriate data. These error conditions are really warnings
that should never occur in a properly initialized driver. Every caller of
ice_mbx_clear_malvf just prints a dev_dbg message on failure which will
generally be ignored.

Convert this function to void and switch the error return values to
WARN_ON. This will make any potentially misconfiguration more visible and
makes future refactors that involve changing how we store the malicious VF
data easier.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  |  6 ++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 12 ++++--------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 16 +++++++---------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h |  2 +-
 4 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 96a64c25e2ef..7107c279752a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -204,10 +204,8 @@ void ice_free_vfs(struct ice_pf *pf)
 		}
 
 		/* clear malicious info since the VF is getting released */
-		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-					ICE_MAX_SRIOV_VFS, vf->vf_id))
-			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
-				vf->vf_id);
+		ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
+				    ICE_MAX_SRIOV_VFS, vf->vf_id);
 
 		mutex_unlock(&vf->cfg_lock);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 0e57bd1b85fd..116b43588389 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -496,10 +496,8 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 
 	/* clear all malicious info if the VFs are getting reset */
 	ice_for_each_vf(pf, bkt, vf)
-		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-					ICE_MAX_SRIOV_VFS, vf->vf_id))
-			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
-				vf->vf_id);
+		ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
+				    ICE_MAX_SRIOV_VFS, vf->vf_id);
 
 	/* If VFs have been disabled, there is no need to reset */
 	if (test_and_set_bit(ICE_VF_DIS, pf->state)) {
@@ -705,10 +703,8 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	ice_eswitch_replay_vf_mac_rule(vf);
 
 	/* if the VF has been reset allow it to come up again */
-	if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-				ICE_MAX_SRIOV_VFS, vf->vf_id))
-		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
-			vf->vf_id);
+	ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
+			    ICE_MAX_SRIOV_VFS, vf->vf_id);
 
 out_unlock:
 	if (flags & ICE_VF_RESET_LOCK)
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index 2fe9a9504914..9f6acfeb0fc6 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -392,19 +392,19 @@ ice_mbx_report_malvf(struct ice_hw *hw, unsigned long *all_malvfs,
  * that the new VF loaded is not considered malicious before going
  * through the overflow detection algorithm.
  */
-int
+void
 ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
 		    u16 bitmap_len, u16 vf_id)
 {
-	if (!snap || !all_malvfs)
-		return -EINVAL;
+	if (WARN_ON(!snap || !all_malvfs))
+		return;
 
-	if (bitmap_len < snap->mbx_vf.vfcntr_len)
-		return -EINVAL;
+	if (WARN_ON(bitmap_len < snap->mbx_vf.vfcntr_len))
+		return;
 
 	/* Ensure VF ID value is not larger than bitmap or VF counter length */
-	if (vf_id >= bitmap_len || vf_id >= snap->mbx_vf.vfcntr_len)
-		return -EIO;
+	if (WARN_ON(vf_id >= bitmap_len || vf_id >= snap->mbx_vf.vfcntr_len))
+		return;
 
 	/* Clear VF ID bit in the bitmap tracking malicious VFs attached to PF */
 	clear_bit(vf_id, all_malvfs);
@@ -416,8 +416,6 @@ ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
 	 * values in the mailbox overflow detection algorithm.
 	 */
 	snap->mbx_vf.vf_cntr[vf_id] = 0;
-
-	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
index 582716e6d5f9..be593b951642 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
@@ -22,7 +22,7 @@ u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed);
 int
 ice_mbx_vf_state_handler(struct ice_hw *hw, struct ice_mbx_data *mbx_data,
 			 u16 vf_id, bool *is_mal_vf);
-int
+void
 ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
 		    u16 bitmap_len, u16 vf_id);
 int ice_mbx_init_snapshot(struct ice_hw *hw, u16 vf_count);
-- 
2.38.1

