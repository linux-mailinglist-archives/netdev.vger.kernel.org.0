Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7451E711D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438023AbgE2AJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:09:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:2081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437981AbgE2AIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:36 -0400
IronPort-SDR: nzSu0tsrovb1qNXOSqrA/4GJuSGdzO6thMEXKuF/9V9xPkildg67iFItqCSoP+KMlQrhJkkN+A
 QdX9kozI9M1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:34 -0700
IronPort-SDR: LpXgrYq+jFpf15w63AMUgQLGf5p4u5Jig41kWlanhPWxnIeHnhNX7vtiwXaL6C78tkbj1aafi1
 WAIkbloJ7wFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651637"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Add helper function for clearing VPGEN_VFRTRIG
Date:   Thu, 28 May 2020 17:08:24 -0700
Message-Id: <20200529000831.2803870-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Create a helper function for clearing VPGEN_VFRTRIG as this needs to be
done on reset to notify the VF that we are done resetting it. Also, it
needs to be done on SR-IOV initialization/creation in case it was left
in a bad state after SR-IOV tear down.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index b699ca81d8c4..039f0b057603 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -961,6 +961,21 @@ static int ice_set_per_vf_res(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_clear_vf_reset_trigger - enable VF to access hardware
+ * @vf: VF to enabled hardware access for
+ */
+static void ice_clear_vf_reset_trigger(struct ice_vf *vf)
+{
+	struct ice_hw *hw = &vf->pf->hw;
+	u32 reg;
+
+	reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
+	reg &= ~VPGEN_VFRTRIG_VFSWR_M;
+	wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
+	ice_flush(hw);
+}
+
 /**
  * ice_cleanup_and_realloc_vf - Clean up VF and reallocate resources after reset
  * @vf: pointer to the VF structure
@@ -974,26 +989,20 @@ static void ice_cleanup_and_realloc_vf(struct ice_vf *vf)
 {
 	struct ice_pf *pf = vf->pf;
 	struct ice_hw *hw;
-	u32 reg;
 
 	hw = &pf->hw;
 
-	/* PF software completes the flow by notifying VF that reset flow is
-	 * completed. This is done by enabling hardware by clearing the reset
-	 * bit in the VPGEN_VFRTRIG reg and setting VFR_STATE in the VFGEN_RSTAT
-	 * register to VFR completed (done at the end of this function)
-	 * By doing this we allow HW to access VF memory at any point. If we
-	 * did it any sooner, HW could access memory while it was being freed
-	 * in ice_free_vf_res(), causing an IOMMU fault.
+	/* Allow HW to access VF memory after calling
+	 * ice_clear_vf_reset_trigger(). If we did it any sooner, HW could
+	 * access memory while it was being freed in ice_free_vf_res(), causing
+	 * an IOMMU fault.
 	 *
 	 * On the other hand, this needs to be done ASAP, because the VF driver
 	 * is waiting for this to happen and may report a timeout. It's
 	 * harmless, but it gets logged into Guest OS kernel log, so best avoid
 	 * it.
 	 */
-	reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
-	reg &= ~VPGEN_VFRTRIG_VFSWR_M;
-	wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
+	ice_clear_vf_reset_trigger(vf);
 
 	/* reallocate VF resources to finish resetting the VSI state */
 	if (!ice_alloc_vf_res(vf)) {
-- 
2.26.2

