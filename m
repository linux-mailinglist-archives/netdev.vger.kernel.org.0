Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8796BC4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbfHTVu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:50:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:28775 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbfHTVuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330528"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 10/14] ice: Reduce wait times during VF bringup/reset
Date:   Tue, 20 Aug 2019 14:50:44 -0700
Message-Id: <20190820215048.14377-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently there are a couple places where the VF is waiting too long when
checking the status of registers. This is causing the AVF driver to
spin for longer than necessary in the __IAVF_STARTUP state. Sometimes
it causes the AVF to go into the __IAVF_COMM_FAILED, which may retrigger
the __IAVF_STARTUP state. Try to reduce the chance of this happening by
removing unnecessary wait times in VF bringup/resets.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 26 +++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  4 +++
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 54b0e88af4ca..8a5bf9730fdf 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -382,12 +382,15 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr)
 
 	wr32(hw, PF_PCI_CIAA,
 	     VF_DEVICE_STATUS | (vf_abs_id << PF_PCI_CIAA_VF_NUM_S));
-	for (i = 0; i < 100; i++) {
+	for (i = 0; i < ICE_PCI_CIAD_WAIT_COUNT; i++) {
 		reg = rd32(hw, PF_PCI_CIAD);
-		if ((reg & VF_TRANS_PENDING_M) != 0)
-			dev_err(&pf->pdev->dev,
-				"VF %d PCI transactions stuck\n", vf->vf_id);
-		udelay(1);
+		/* no transactions pending so stop polling */
+		if ((reg & VF_TRANS_PENDING_M) == 0)
+			break;
+
+		dev_err(&pf->pdev->dev,
+			"VF %d PCI transactions stuck\n", vf->vf_id);
+		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
 	}
 }
 
@@ -1068,7 +1071,6 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	 * finished resetting.
 	 */
 	for (i = 0, v = 0; i < 10 && v < pf->num_alloc_vfs; i++) {
-		usleep_range(10000, 20000);
 
 		/* Check each VF in sequence */
 		while (v < pf->num_alloc_vfs) {
@@ -1076,8 +1078,11 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 
 			vf = &pf->vf[v];
 			reg = rd32(hw, VPGEN_VFRSTAT(vf->vf_id));
-			if (!(reg & VPGEN_VFRSTAT_VFRD_M))
+			if (!(reg & VPGEN_VFRSTAT_VFRD_M)) {
+				/* only delay if the check failed */
+				usleep_range(10, 20);
 				break;
+			}
 
 			/* If the current VF has finished resetting, move on
 			 * to the next VF in sequence.
@@ -1091,7 +1096,6 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	 */
 	if (v < pf->num_alloc_vfs)
 		dev_warn(&pf->pdev->dev, "VF reset check timeout\n");
-	usleep_range(10000, 20000);
 
 	/* free VF resources to begin resetting the VSI state */
 	for (v = 0; v < pf->num_alloc_vfs; v++) {
@@ -1165,12 +1169,14 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		 * poll the status register to make sure that the reset
 		 * completed successfully.
 		 */
-		usleep_range(10000, 20000);
 		reg = rd32(hw, VPGEN_VFRSTAT(vf->vf_id));
 		if (reg & VPGEN_VFRSTAT_VFRD_M) {
 			rsd = true;
 			break;
 		}
+
+		/* only sleep if the reset is not done */
+		usleep_range(10, 20);
 	}
 
 	/* Display a warning if VF didn't manage to reset in time, but need to
@@ -1180,8 +1186,6 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		dev_warn(&pf->pdev->dev, "VF reset check timeout on VF %d\n",
 			 vf->vf_id);
 
-	usleep_range(10000, 20000);
-
 	/* disable promiscuous modes in case they were enabled
 	 * ignore any error if disabling process failed
 	 */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 424bc0538956..79bb47f73879 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -22,6 +22,10 @@
 #define VF_DEVICE_STATUS		0xAA
 #define VF_TRANS_PENDING_M		0x20
 
+/* wait defines for polling PF_PCI_CIAD register status */
+#define ICE_PCI_CIAD_WAIT_COUNT		100
+#define ICE_PCI_CIAD_WAIT_DELAY_US	1
+
 /* Specific VF states */
 enum ice_vf_states {
 	ICE_VF_STATE_INIT = 0,
-- 
2.21.0

