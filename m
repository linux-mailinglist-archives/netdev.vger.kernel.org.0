Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD94DA54C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbiCOWX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352198AbiCOWXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6754F5C84D
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382923; x=1678918923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yHqA8JBtaO/5BK6twTbtn+ApdeazfueNzJ1RI/HABgc=;
  b=B+/COo1h1gETprPpO7wGnc518Cc5Y935toXwEd6FKCv8nmYCtkINPqoX
   Or6GuIRXp+7wgTeImrFiSaW/NMCmB0ACncxX5qeDf2aCqf20dmFBfzsKw
   WteDR1uCHjlXJaJTbFXVw5XJOSjyXEQaq1cVntpBAwk/VdpB4ywfQ3+cC
   GGFLIaiojuoKpDHKeNZjDQNKK5tbo/d3uCjetUfwHJvkAuPbBNQdqK5fI
   rqGYjFrdaujIZWUHd8IbVIGZGNMR+tYKmyW1x0KAd9A4SuvsACk6J0Mhw
   VaFu/LN7Rzxzn2NSGz2EdKPjN7fpJlQ7O0ObBQskbG4oGuyc3FZCtzy82
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264560"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264560"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362236"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:22:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 11/14] ice: introduce ICE_VF_RESET_LOCK flag
Date:   Tue, 15 Mar 2022 15:22:17 -0700
Message-Id: <20220315222220.2925324-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_reset_vf function performs actions which must be taken only
while holding the VF configuration lock. Some flows already acquired the
lock, while other flows must acquire it just for the reset function. Add
the ICE_VF_RESET_LOCK flag to the function so that it can handle taking
and releasing the lock instead at the appropriate scope.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c   |  4 +---
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 12 +++---------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 18 ++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  1 +
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2e23fdc099e0..d458932839a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1823,9 +1823,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				 * reset, so print the event prior to reset.
 				 */
 				ice_print_vf_rx_mdd_event(vf);
-				mutex_lock(&vf->cfg_lock);
-				ice_reset_vf(vf, 0);
-				mutex_unlock(&vf->cfg_lock);
+				ice_reset_vf(vf, ICE_VF_RESET_LOCK);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 46d656d385c4..f74474f8af99 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1366,12 +1366,9 @@ void ice_process_vflr_event(struct ice_pf *pf)
 		bit_idx = (hw->func_caps.vf_base_id + vf->vf_id) % 32;
 		/* read GLGEN_VFLRSTAT register to find out the flr VFs */
 		reg = rd32(hw, GLGEN_VFLRSTAT(reg_idx));
-		if (reg & BIT(bit_idx)) {
+		if (reg & BIT(bit_idx))
 			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
-			mutex_lock(&vf->cfg_lock);
-			ice_reset_vf(vf, ICE_VF_RESET_VFLR);
-			mutex_unlock(&vf->cfg_lock);
-		}
+			ice_reset_vf(vf, ICE_VF_RESET_VFLR | ICE_VF_RESET_LOCK);
 	}
 	mutex_unlock(&pf->vfs.table_lock);
 }
@@ -1453,10 +1450,7 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 	if (!vf)
 		return;
 
-	mutex_lock(&vf->cfg_lock);
-	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
-	mutex_unlock(&vf->cfg_lock);
-
+	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY | ICE_VF_RESET_LOCK);
 	ice_put_vf(vf);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index dce32bc194a0..c584f5123ba7 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -473,6 +473,7 @@ static void ice_notify_vf_reset(struct ice_vf *vf)
  * Flags:
  *   ICE_VF_RESET_VFLR - Indicates a reset is due to VFLR event
  *   ICE_VF_RESET_NOTIFY - Send VF a notification prior to reset
+ *   ICE_VF_RESET_LOCK - Acquire VF cfg_lock before resetting
  *
  * Returns 0 if the VF is currently in reset, if the resets are disabled, or
  * if the VF resets successfully. Returns an error code if the VF fails to
@@ -485,10 +486,9 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	struct device *dev;
 	struct ice_hw *hw;
 	u8 promisc_m;
+	int err = 0;
 	bool rsd;
 
-	lockdep_assert_held(&vf->cfg_lock);
-
 	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
 
@@ -507,6 +507,11 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 		return 0;
 	}
 
+	if (flags & ICE_VF_RESET_LOCK)
+		mutex_lock(&vf->cfg_lock);
+	else
+		lockdep_assert_held(&vf->cfg_lock);
+
 	/* Set VF disable bit state here, before triggering reset */
 	set_bit(ICE_VF_STATE_DIS, vf->vf_states);
 	ice_trigger_vf_reset(vf, flags & ICE_VF_RESET_VFLR, false);
@@ -564,7 +569,8 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	if (vf->vf_ops->vsi_rebuild(vf)) {
 		dev_err(dev, "Failed to release and setup the VF%u's VSI\n",
 			vf->vf_id);
-		return -EFAULT;
+		err = -EFAULT;
+		goto out_unlock;
 	}
 
 	vf->vf_ops->post_vsi_rebuild(vf);
@@ -578,7 +584,11 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
 			vf->vf_id);
 
-	return 0;
+out_unlock:
+	if (flags & ICE_VF_RESET_LOCK)
+		mutex_unlock(&vf->cfg_lock);
+
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index efa523b25bf8..831b667dc5b2 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -137,6 +137,7 @@ struct ice_vf {
 enum ice_vf_reset_flags {
 	ICE_VF_RESET_VFLR = BIT(0), /* Indicate a VFLR reset */
 	ICE_VF_RESET_NOTIFY = BIT(1), /* Notify VF prior to reset */
+	ICE_VF_RESET_LOCK = BIT(2), /* Acquire the VF cfg_lock */
 };
 
 static inline u16 ice_vf_get_port_vlan_id(struct ice_vf *vf)
-- 
2.31.1

