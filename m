Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF68668C8F4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBFVt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjBFVtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:49:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635BA298D8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720138; x=1707256138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eCGgl09p2VKM2KvKICxl68tZTGrxOGWacW7WUUOGAYw=;
  b=SAdFywgVBFr/Y9cJqwZniZAymF2U38n4JmKaL8x0lOfq4bsaAKkK4HWb
   W6WqIohDprVl3R6U90ock840dh6y8MDIUnVPn91s8IFfVgxzXAhFC8vcy
   GsE2Ux0FdzEbwgQAcyX4w890zZibtxmJFXSuhSRrjyQR2sSPEOWvKirt+
   6+dlnWy4zEFnRP8lMU35xL5FasXugaWBvTHwaiqESiLSjzt4BYOOJM/1N
   i3ixb9B4uXdCx3u80AJ485nQ/a+hy41GHeqpLloYb1DppL+89RnuLtxQK
   DeTXu4DPvMWnq37bt4QJoTagGPcix545LzFNt+OuLjenvjDN+tS9H9g/K
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338143"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338143"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576212"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576212"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 11/13] ice: introduce clear_reset_state operation
Date:   Mon,  6 Feb 2023 13:48:11 -0800
Message-Id: <20230206214813.20107-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
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

When hardware is reset, the VF relies on the VFGEN_RSTAT register to detect
when the VF is finished resetting. This is a tri-state register where 0
indicates a reset is in progress, 1 indicates the hardware is done
resetting, and 2 indicates that the software is done resetting.

Currently the PF driver relies on the device hardware resetting VFGEN_RSTAT
when a global reset occurs. This works ok, but it does mean that the VF
might not immediately notice a reset when the driver first detects that the
global reset is occurring.

This is also problematic for Scalable IOV, because there is no read/write
equivalent VFGEN_RSTAT register for the Scalable VSI type. Instead, the
Scalable IOV VFs will need to emulate this register.

To support this, introduce a new VF operation, clear_reset_state, which is
called when the PF driver first detects a global reset. The Single Root IOV
implementation can just write to VFGEN_RSTAT to ensure it's cleared
immediately, without waiting for the actual hardware reset to begin. The
Scalable IOV implementation will use this as part of its tracking of the
reset status to allow properly reporting the emulated VFGEN_RSTAT to the VF
driver.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 16 ++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 12 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  5 +++--
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e7ea63adfebb..b71ff7e2ebf2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -537,7 +537,7 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	/* Disable VFs until reset is completed */
 	mutex_lock(&pf->vfs.table_lock);
 	ice_for_each_vf(pf, bkt, vf)
-		ice_set_vf_state_qs_dis(vf);
+		ice_set_vf_state_dis(vf);
 	mutex_unlock(&pf->vfs.table_lock);
 
 	if (ice_is_eswitch_mode_switchdev(pf)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 46088c05d485..4d8930b83b35 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -654,6 +654,21 @@ static void ice_sriov_free_vf(struct ice_vf *vf)
 	kfree_rcu(vf, rcu);
 }
 
+/**
+ * ice_sriov_clear_reset_state - clears VF Reset status register
+ * @vf: the vf to configure
+ */
+static void ice_sriov_clear_reset_state(struct ice_vf *vf)
+{
+	struct ice_hw *hw = &vf->pf->hw;
+
+	/* Clear the reset status register so that VF immediately sees that
+	 * the device is resetting, even if hardware hasn't yet gotten around
+	 * to clearing VFGEN_RSTAT for us.
+	 */
+	wr32(hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_INPROGRESS);
+}
+
 /**
  * ice_sriov_clear_mbx_register - clears SRIOV VF's mailbox registers
  * @vf: the vf to configure
@@ -787,6 +802,7 @@ static void ice_sriov_post_vsi_rebuild(struct ice_vf *vf)
 static const struct ice_vf_ops ice_sriov_vf_ops = {
 	.reset_type = ICE_VF_RESET,
 	.free = ice_sriov_free_vf,
+	.clear_reset_state = ice_sriov_clear_reset_state,
 	.clear_mbx_register = ice_sriov_clear_mbx_register,
 	.trigger_reset_register = ice_sriov_trigger_reset_register,
 	.poll_reset_status = ice_sriov_poll_reset_status,
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 1a5d64454f99..2ea801ebb2ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -717,7 +717,7 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
  * ice_set_vf_state_qs_dis - Set VF queues state to disabled
  * @vf: pointer to the VF structure
  */
-void ice_set_vf_state_qs_dis(struct ice_vf *vf)
+static void ice_set_vf_state_qs_dis(struct ice_vf *vf)
 {
 	/* Clear Rx/Tx enabled queues flag */
 	bitmap_zero(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF);
@@ -725,6 +725,16 @@ void ice_set_vf_state_qs_dis(struct ice_vf *vf)
 	clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 }
 
+/**
+ * ice_set_vf_state_dis - Set VF state to disabled
+ * @vf: pointer to the VF structure
+ */
+void ice_set_vf_state_dis(struct ice_vf *vf)
+{
+	ice_set_vf_state_qs_dis(vf);
+	vf->vf_ops->clear_reset_state(vf);
+}
+
 /* Private functions only accessed from other virtualization files */
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index e3d94f3ca40d..5bb75edb6cef 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -56,6 +56,7 @@ struct ice_mdd_vf_events {
 struct ice_vf_ops {
 	enum ice_disq_rst_src reset_type;
 	void (*free)(struct ice_vf *vf);
+	void (*clear_reset_state)(struct ice_vf *vf);
 	void (*clear_mbx_register)(struct ice_vf *vf);
 	void (*trigger_reset_register)(struct ice_vf *vf, bool is_vflr);
 	bool (*poll_reset_status)(struct ice_vf *vf);
@@ -213,7 +214,7 @@ u16 ice_get_num_vfs(struct ice_pf *pf);
 struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf);
 bool ice_is_vf_disabled(struct ice_vf *vf);
 int ice_check_vf_ready_for_cfg(struct ice_vf *vf);
-void ice_set_vf_state_qs_dis(struct ice_vf *vf);
+void ice_set_vf_state_dis(struct ice_vf *vf);
 bool ice_is_any_vf_in_unicast_promisc(struct ice_pf *pf);
 void
 ice_vf_get_promisc_masks(struct ice_vf *vf, struct ice_vsi *vsi,
@@ -259,7 +260,7 @@ static inline int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
 	return -EOPNOTSUPP;
 }
 
-static inline void ice_set_vf_state_qs_dis(struct ice_vf *vf)
+static inline void ice_set_vf_state_dis(struct ice_vf *vf)
 {
 }
 
-- 
2.38.1

