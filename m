Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3084BC263
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbiBRV4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:56:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240036AbiBRV4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:56:12 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D316E6D86
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221355; x=1676757355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NEMP9Roo87t0e9+Tlx15V43e6VwiSYZVXOzPEsEgcQU=;
  b=ZmkH9wejAY9oA9AMWAh6/WuX5ZmF9SN29bjSU9ViZLYsY9RzLHpfUTYM
   42/wizuFCB1JI0yYsr3kNwWd2y3iv8vReA8okUYZPx3AohIUzR4EgODKf
   kRbgkI0jrOHYAE3Zmc2ps7qskBmuUK0T+nAADkRX/kl4gSGpcOXC0fSbn
   minKrDgo/kPPXaOtXIdV+KcwICOYIBIPUv+vvqPvvl+eQ26+YaucLk7bZ
   EXiv+jGs89e0w85VUH3bokZqSELOvlDWwbGslf3qmZ4JMkb1523q4vzcb
   9V0wytfxB1hACiU4qYcFj4IXvaVm+NXEv4KnWeNXutxzpTqRZ8uqNn1Uh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251179162"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251179162"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:55:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="626757372"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2022 13:55:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/5] ice: fix concurrent reset and removal of VFs
Date:   Fri, 18 Feb 2022 13:55:52 -0800
Message-Id: <20220218215554.415323-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
References: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Commit c503e63200c6 ("ice: Stop processing VF messages during teardown")
introduced a driver state flag, ICE_VF_DEINIT_IN_PROGRESS, which is
intended to prevent some issues with concurrently handling messages from
VFs while tearing down the VFs.

This change was motivated by crashes caused while tearing down and
bringing up VFs in rapid succession.

It turns out that the fix actually introduces issues with the VF driver
caused because the PF no longer responds to any messages sent by the VF
during its .remove routine. This results in the VF potentially removing
its DMA memory before the PF has shut down the device queues.

Additionally, the fix doesn't actually resolve concurrency issues within
the ice driver. It is possible for a VF to initiate a reset just prior
to the ice driver removing VFs. This can result in the remove task
concurrently operating while the VF is being reset. This results in
similar memory corruption and panics purportedly fixed by that commit.

Fix this concurrency at its root by protecting both the reset and
removal flows using the existing VF cfg_lock. This ensures that we
cannot remove the VF while any outstanding critical tasks such as a
virtchnl message or a reset are occurring.

This locking change also fixes the root cause originally fixed by commit
c503e63200c6 ("ice: Stop processing VF messages during teardown"), so we
can simply revert it.

Note that I kept these two changes together because simply reverting the
original commit alone would leave the driver vulnerable to worse race
conditions.

Fixes: c503e63200c6 ("ice: Stop processing VF messages during teardown")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 -
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 42 +++++++++++--------
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a9fa701aaa95..473b1f6be9de 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -280,7 +280,6 @@ enum ice_pf_state {
 	ICE_VFLR_EVENT_PENDING,
 	ICE_FLTR_OVERFLOW_PROMISC,
 	ICE_VF_DIS,
-	ICE_VF_DEINIT_IN_PROGRESS,
 	ICE_CFG_BUSY,
 	ICE_SERVICE_SCHED,
 	ICE_SERVICE_DIS,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 17a9bb461dc3..f3c346e13b7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1799,7 +1799,9 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				 * reset, so print the event prior to reset.
 				 */
 				ice_print_vf_rx_mdd_event(vf);
+				mutex_lock(&pf->vf[i].cfg_lock);
 				ice_reset_vf(&pf->vf[i], false);
+				mutex_unlock(&pf->vf[i].cfg_lock);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 39b80124d282..408f78e3eb13 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -500,8 +500,6 @@ void ice_free_vfs(struct ice_pf *pf)
 	struct ice_hw *hw = &pf->hw;
 	unsigned int tmp, i;
 
-	set_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
-
 	if (!pf->vf)
 		return;
 
@@ -519,22 +517,26 @@ void ice_free_vfs(struct ice_pf *pf)
 	else
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
-	/* Avoid wait time by stopping all VFs at the same time */
-	ice_for_each_vf(pf, i)
-		ice_dis_vf_qs(&pf->vf[i]);
-
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
 	pf->num_alloc_vfs = 0;
 	for (i = 0; i < tmp; i++) {
-		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		mutex_lock(&vf->cfg_lock);
+
+		ice_dis_vf_qs(vf);
+
+		if (test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
 			/* disable VF qp mappings and set VF disable state */
-			ice_dis_vf_mappings(&pf->vf[i]);
-			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
-			ice_free_vf_res(&pf->vf[i]);
+			ice_dis_vf_mappings(vf);
+			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
+			ice_free_vf_res(vf);
 		}
 
-		mutex_destroy(&pf->vf[i].cfg_lock);
+		mutex_unlock(&vf->cfg_lock);
+
+		mutex_destroy(&vf->cfg_lock);
 	}
 
 	if (ice_sriov_free_msix_res(pf))
@@ -570,7 +572,6 @@ void ice_free_vfs(struct ice_pf *pf)
 				i);
 
 	clear_bit(ICE_VF_DIS, pf->state);
-	clear_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
 
@@ -1498,6 +1499,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
+		mutex_lock(&vf->cfg_lock);
+
 		vf->driver_caps = 0;
 		ice_vc_set_default_allowlist(vf);
 
@@ -1512,6 +1515,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
 		ice_vf_post_vsi_rebuild(vf);
+
+		mutex_unlock(&vf->cfg_lock);
 	}
 
 	if (ice_is_eswitch_mode_switchdev(pf))
@@ -1562,6 +1567,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	u32 reg;
 	int i;
 
+	lockdep_assert_held(&vf->cfg_lock);
+
 	dev = ice_pf_to_dev(pf);
 
 	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
@@ -2061,9 +2068,12 @@ void ice_process_vflr_event(struct ice_pf *pf)
 		bit_idx = (hw->func_caps.vf_base_id + vf_id) % 32;
 		/* read GLGEN_VFLRSTAT register to find out the flr VFs */
 		reg = rd32(hw, GLGEN_VFLRSTAT(reg_idx));
-		if (reg & BIT(bit_idx))
+		if (reg & BIT(bit_idx)) {
 			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
+			mutex_lock(&vf->cfg_lock);
 			ice_reset_vf(vf, true);
+			mutex_unlock(&vf->cfg_lock);
+		}
 	}
 }
 
@@ -2140,7 +2150,9 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 	if (!vf)
 		return;
 
+	mutex_lock(&vf->cfg_lock);
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
@@ -4625,10 +4637,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	struct device *dev;
 	int err = 0;
 
-	/* if de-init is underway, don't process messages from VF */
-	if (test_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state))
-		return;
-
 	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id)) {
 		err = -EINVAL;
-- 
2.31.1

