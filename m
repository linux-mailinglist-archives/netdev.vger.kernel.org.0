Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2776179C50
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbgCDXWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:22:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:48334 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388389AbgCDXVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094626"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:37 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/16] ice: Fix removing driver while bare-metal VFs pass traffic
Date:   Wed,  4 Mar 2020 15:21:26 -0800
Message-Id: <20200304232136.4172118-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, if there are bare-metal VFs passing traffic and the ice
driver is removed, there is a possibility of VFs triggering a Tx timeout
right before iavf_remove(). This is causing iavf_close() to not be
called because there is a check in the beginning of iavf_remove() that
bails out early if (adapter->state < IAVF_DOWN_PENDING). This makes it
so some resources do not get cleaned up. Specifically, free_irq()
is never called for data interrupts, which results in the following line
of code to trigger:

pci_disable_msix()
	free_msi_irqs()
		...
		BUG_ON(irq_has_action(entry->irq + i));
		...

To prevent the Tx timeout from occurring on the VF during driver unload
for ice and the iavf there are a few changes that are needed.

[1] Don't disable all active VF Tx/Rx queues prior to calling
pci_disable_sriov.

[2] Call ice_free_vfs() before disabling the service task.

[3] Disable VF resets when the ice driver is being unloaded by setting
the pf->state flag __ICE_VF_RESETS_DISABLED.

Changing [1] and [2] allow each VF driver's remove flow to successfully
send VIRTCHNL requests, which includes queue disable. This prevents
unexpected Tx timeouts because the PF driver is no longer forcefully
disabling queues.

Due to [1] and [2] there is a possibility that the PF driver will get a
VFLR or reset request over VIRTCHNL from a VF during PF driver unload.
Prevent that by doing [3].

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 19 +++++++++++++++----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 19 +++++++++++++------
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 472d270ee88a..31e99f862820 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -216,6 +216,7 @@ enum ice_state {
 	__ICE_SERVICE_DIS,
 	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
 	__ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
+	__ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
 	__ICE_STATE_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3a4794c97da7..93160ba4d1bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2054,8 +2054,16 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		set_bit(__ICE_MDD_EVENT_PENDING, pf->state);
 	}
 	if (oicr & PFINT_OICR_VFLR_M) {
-		ena_mask &= ~PFINT_OICR_VFLR_M;
-		set_bit(__ICE_VFLR_EVENT_PENDING, pf->state);
+		/* disable any further VFLR event notifications */
+		if (test_bit(__ICE_VF_RESETS_DISABLED, pf->state)) {
+			u32 reg = rd32(hw, PFINT_OICR_ENA);
+
+			reg &= ~PFINT_OICR_VFLR_M;
+			wr32(hw, PFINT_OICR_ENA, reg);
+		} else {
+			ena_mask &= ~PFINT_OICR_VFLR_M;
+			set_bit(__ICE_VFLR_EVENT_PENDING, pf->state);
+		}
 	}
 
 	if (oicr & PFINT_OICR_GRST_M) {
@@ -3402,11 +3410,14 @@ static void ice_remove(struct pci_dev *pdev)
 		msleep(100);
 	}
 
+	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags)) {
+		set_bit(__ICE_VF_RESETS_DISABLED, pf->state);
+		ice_free_vfs(pf);
+	}
+
 	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
-	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags))
-		ice_free_vfs(pf);
 	ice_vsi_release_all(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e0277b49439f..6ee7f8c9449a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -300,11 +300,6 @@ void ice_free_vfs(struct ice_pf *pf)
 	while (test_and_set_bit(__ICE_VF_DIS, pf->state))
 		usleep_range(1000, 2000);
 
-	/* Avoid wait time by stopping all VFs at the same time */
-	ice_for_each_vf(pf, i)
-		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
-			ice_dis_vf_qs(&pf->vf[i]);
-
 	/* Disable IOV before freeing resources. This lets any VF drivers
 	 * running in the host get themselves cleaned up before we yank
 	 * the carpet out from underneath their feet.
@@ -314,6 +309,11 @@ void ice_free_vfs(struct ice_pf *pf)
 	else
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
+	/* Avoid wait time by stopping all VFs at the same time */
+	ice_for_each_vf(pf, i)
+		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
+			ice_dis_vf_qs(&pf->vf[i]);
+
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
 	pf->num_alloc_vfs = 0;
@@ -1155,7 +1155,8 @@ static bool ice_is_vf_disabled(struct ice_vf *vf)
  * @vf: pointer to the VF structure
  * @is_vflr: true if VFLR was issued, false if not
  *
- * Returns true if the VF is reset, false otherwise.
+ * Returns true if the VF is currently in reset, resets successfully, or resets
+ * are disabled and false otherwise.
  */
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 {
@@ -1170,6 +1171,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	dev = ice_pf_to_dev(pf);
 
+	if (test_bit(__ICE_VF_RESETS_DISABLED, pf->state)) {
+		dev_dbg(dev, "Trying to reset VF %d, but all VF resets are disabled\n",
+			vf->vf_id);
+		return true;
+	}
+
 	if (ice_is_vf_disabled(vf)) {
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
 			vf->vf_id);
-- 
2.24.1

