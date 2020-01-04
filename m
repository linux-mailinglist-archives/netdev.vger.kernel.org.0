Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135F5130043
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgADCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:19 -0500
Received: from mga12.intel.com ([192.55.52.136]:64694 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757859"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/16] ice: Add ice_for_each_vf() macro
Date:   Fri,  3 Jan 2020 18:49:41 -0800
Message-Id: <20200104024953.2336731-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we do "for (i = 0; i < pf->num_alloc_vfs; i++)" all over the
place. Many other places use macros to contain this repeated for loop,
So create the macro ice_for_each_vf(pf, i) that does the same thing.

There were a couple places we were using one loop variable and a VF
iterator, which were changed to using a local variable within the
ice_for_each_vf() macro.

Also in ice_alloc_vfs() we were setting pf->num_alloc_vfs after doing
"for (i = 0; i < num_alloc_vfs; i++)". Instead assign pf->num_alloc_vfs
right after allocating memory for the pf->vf array.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  7 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 ++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 23 ++++++++++---------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  3 +++
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9ebd93e79aeb..b815f1df5698 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -283,12 +283,15 @@ ice_get_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
  */
 static bool ice_active_vfs(struct ice_pf *pf)
 {
-	struct ice_vf *vf = pf->vf;
 	int i;
 
-	for (i = 0; i < pf->num_alloc_vfs; i++, vf++)
+	ice_for_each_vf(pf, i) {
+		struct ice_vf *vf = &pf->vf[i];
+
 		if (test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
 			return true;
+	}
+
 	return false;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 639de467f120..0c46e7fe7250 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -476,7 +476,7 @@ ice_prepare_for_reset(struct ice_pf *pf)
 		ice_vc_notify_reset(pf);
 
 	/* Disable VFs until reset is completed */
-	for (i = 0; i < pf->num_alloc_vfs; i++)
+	ice_for_each_vf(pf, i)
 		ice_set_vf_state_qs_dis(&pf->vf[i]);
 
 	/* clear SW filtering DB */
@@ -1295,7 +1295,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 	}
 
 	/* check to see if one of the VFs caused the MDD */
-	for (i = 0; i < pf->num_alloc_vfs; i++) {
+	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
 
 		bool vf_mdd_detected = false;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 3860e9c964b9..88cb0f9e928e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -78,10 +78,11 @@ ice_vc_vf_broadcast(struct ice_pf *pf, enum virtchnl_ops v_opcode,
 		    enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
 {
 	struct ice_hw *hw = &pf->hw;
-	struct ice_vf *vf = pf->vf;
 	int i;
 
-	for (i = 0; i < pf->num_alloc_vfs; i++, vf++) {
+	ice_for_each_vf(pf, i) {
+		struct ice_vf *vf = &pf->vf[i];
+
 		/* Not all vfs are enabled so skip the ones that are not */
 		if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states) &&
 		    !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
@@ -331,7 +332,7 @@ void ice_free_vfs(struct ice_pf *pf)
 		usleep_range(1000, 2000);
 
 	/* Avoid wait time by stopping all VFs at the same time */
-	for (i = 0; i < pf->num_alloc_vfs; i++)
+	ice_for_each_vf(pf, i)
 		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
 			ice_dis_vf_qs(&pf->vf[i]);
 
@@ -1077,7 +1078,7 @@ static bool ice_config_res_vfs(struct ice_pf *pf)
 		ice_irq_dynamic_ena(hw, NULL, NULL);
 
 	/* Finish resetting each VF and allocate resources */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
+	ice_for_each_vf(pf, v) {
 		struct ice_vf *vf = &pf->vf[v];
 
 		vf->num_vf_qs = pf->num_vf_qps;
@@ -1120,10 +1121,10 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		return false;
 
 	/* Begin reset on all VFs at once */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
+	ice_for_each_vf(pf, v)
 		ice_trigger_vf_reset(&pf->vf[v], is_vflr, true);
 
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
+	ice_for_each_vf(pf, v) {
 		struct ice_vsi *vsi;
 
 		vf = &pf->vf[v];
@@ -1168,7 +1169,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		dev_warn(dev, "VF reset check timeout\n");
 
 	/* free VF resources to begin resetting the VSI state */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
+	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
 		ice_free_vf_res(vf);
@@ -1308,7 +1309,7 @@ void ice_vc_notify_link_state(struct ice_pf *pf)
 {
 	int i;
 
-	for (i = 0; i < pf->num_alloc_vfs; i++)
+	ice_for_each_vf(pf, i)
 		ice_vc_notify_vf_link_state(&pf->vf[i]);
 }
 
@@ -1392,9 +1393,10 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 		goto err_pci_disable_sriov;
 	}
 	pf->vf = vfs;
+	pf->num_alloc_vfs = num_alloc_vfs;
 
 	/* apply default profile */
-	for (i = 0; i < num_alloc_vfs; i++) {
+	ice_for_each_vf(pf, i) {
 		vfs[i].pf = pf;
 		vfs[i].vf_sw_id = pf->first_sw;
 		vfs[i].vf_id = i;
@@ -1403,7 +1405,6 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vfs[i].vf_caps);
 		vfs[i].spoofchk = true;
 	}
-	pf->num_alloc_vfs = num_alloc_vfs;
 
 	/* VF resources get allocated with initialization */
 	if (!ice_config_res_vfs(pf)) {
@@ -1542,7 +1543,7 @@ void ice_process_vflr_event(struct ice_pf *pf)
 	    !pf->num_alloc_vfs)
 		return;
 
-	for (vf_id = 0; vf_id < pf->num_alloc_vfs; vf_id++) {
+	ice_for_each_vf(pf, vf_id) {
 		struct ice_vf *vf = &pf->vf[vf_id];
 		u32 reg_idx, bit_idx;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 611f45100438..4647d636ed36 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -40,6 +40,9 @@
 #define ICE_DFLT_INTR_PER_VF		(ICE_DFLT_QS_PER_VF + 1)
 #define ICE_MAX_VF_RESET_WAIT		15
 
+#define ice_for_each_vf(pf, i) \
+	for ((i) = 0; (i) < (pf)->num_alloc_vfs; (i)++)
+
 /* Specific VF states */
 enum ice_vf_states {
 	ICE_VF_STATE_INIT = 0,		/* PF is initializing VF */
-- 
2.24.1

