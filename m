Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79927AAD19
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391696AbfIEUed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:45332 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391661AbfIEUeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136551"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/16] ice: Reliably reset VFs
Date:   Thu,  5 Sep 2019 13:33:58 -0700
Message-Id: <20190905203406.4152-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

When a PFR (or bigger reset) occurs, the device clears the VF_MBX_ARQLEN
register for all VFs. But if a VFR is triggered by a VF, the device does
NOT clear this register, and the VF driver will never see the reset.

When this happens, the VF driver will eventually timeout and attempt
recovery, and usually it will be successful. But this makes resets take
a long time and there are occasional failures.

We cannot just blithely clear this register on every reset; this has
been shown to cause synchronization problems when a PFR is triggered
with a large number of VFs.

Fix this by clearing VF_MBX_ARQLEN when the reset source is not PFR.
GlobR will trigger PFR, so this test catches that occurrence as well.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c38939b1d496..3ba6613048ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -353,12 +353,13 @@ void ice_free_vfs(struct ice_pf *pf)
  * ice_trigger_vf_reset - Reset a VF on HW
  * @vf: pointer to the VF structure
  * @is_vflr: true if VFLR was issued, false if not
+ * @is_pfr: true if the reset was triggered due to a previous PFR
  *
  * Trigger hardware to start a reset for a particular VF. Expects the caller
  * to wait the proper amount of time to allow hardware to reset the VF before
  * it cleans up and restores VF functionality.
  */
-static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr)
+static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 {
 	struct ice_pf *pf = vf->pf;
 	u32 reg, reg_idx, bit_idx;
@@ -379,10 +380,13 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr)
 	 */
 	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
 
-	/* Clear the VF's ARQLEN register. This is how the VF detects reset,
-	 * since the VFGEN_RSTAT register doesn't stick at 0 after reset.
+	/* VF_MBX_ARQLEN is cleared by PFR, so the driver needs to clear it
+	 * in the case of VFR. If this is done for PFR, it can mess up VF
+	 * resets because the VF driver may already have started cleanup
+	 * by the time we get here.
 	 */
-	wr32(hw, VF_MBX_ARQLEN(vf_abs_id), 0);
+	if (!is_pfr)
+		wr32(hw, VF_MBX_ARQLEN(vf_abs_id), 0);
 
 	/* In the case of a VFLR, the HW has already reset the VF and we
 	 * just need to clean up, so don't hit the VFRTRIG register.
@@ -1072,7 +1076,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 
 	/* Begin reset on all VFs at once */
 	for (v = 0; v < pf->num_alloc_vfs; v++)
-		ice_trigger_vf_reset(&pf->vf[v], is_vflr);
+		ice_trigger_vf_reset(&pf->vf[v], is_vflr, true);
 
 	for (v = 0; v < pf->num_alloc_vfs; v++) {
 		struct ice_vsi *vsi;
@@ -1172,7 +1176,7 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	if (test_and_set_bit(ICE_VF_STATE_DIS, vf->vf_states))
 		return false;
 
-	ice_trigger_vf_reset(vf, is_vflr);
+	ice_trigger_vf_reset(vf, is_vflr, false);
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-- 
2.21.0

