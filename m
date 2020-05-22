Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC61DE060
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgEVG4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgEVG4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:14 -0400
IronPort-SDR: 5keFPsEg+iYkIs8HfS6+63nOQqGpS0G83hHfVPwAGjyL57X0w7SzQYPypW1lFmmLogTREkq5dT
 zhTxw7YIpIBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:10 -0700
IronPort-SDR: +lcc5TrZYW89RSe93NqGaBQ2Gqzy/M03RHyv+7c9rPXhrzxmTj3MIJ75hWYzUx9vBe4o8v6J0D
 jyYDeoyHoDaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017764"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/17] ice: cleanup vf_id signedness
Date:   Thu, 21 May 2020 23:56:00 -0700
Message-Id: <20200522065607.1680050-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The vf_id variable is dealt with in the code in inconsistent
ways of sign usage, preventing compilation with -Werror=sign-compare.
Fix this problem in the code by always treating vf_id as unsigned, since
there are no valid values of vf_id that are negative.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h            |  2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c    | 17 +++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h    |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cd2bf9b8e385..58d0d6436c7f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -371,7 +371,7 @@ struct ice_pf {
 	struct ice_sw *first_sw;	/* first switch created by firmware */
 	/* Virtchnl/SR-IOV config info */
 	struct ice_vf *vf;
-	int num_alloc_vfs;		/* actual number of VFs allocated */
+	u16 num_alloc_vfs;		/* actual number of VFs allocated */
 	u16 num_vfs_supported;		/* num VFs supported for this PF */
 	u16 num_qps_per_vf;
 	u16 num_msix_per_vf;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index fc03b278370b..9fb74a390b8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -10,10 +10,11 @@
  * @pf: pointer to the PF structure
  * @vf_id: the ID of the VF to check
  */
-static int ice_validate_vf_id(struct ice_pf *pf, int vf_id)
+static int ice_validate_vf_id(struct ice_pf *pf, u16 vf_id)
 {
+	/* vf_id range is only valid for 0-255, and should always be unsigned */
 	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(ice_pf_to_dev(pf), "Invalid VF ID: %d\n", vf_id);
+		dev_err(ice_pf_to_dev(pf), "Invalid VF ID: %u\n", vf_id);
 		return -EINVAL;
 	}
 	return 0;
@@ -27,7 +28,7 @@ static int ice_validate_vf_id(struct ice_pf *pf, int vf_id)
 static int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf)
 {
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(ice_pf_to_dev(pf), "VF ID: %d in reset. Try again.\n",
+		dev_err(ice_pf_to_dev(pf), "VF ID: %u in reset. Try again.\n",
 			vf->vf_id);
 		return -EBUSY;
 	}
@@ -368,7 +369,7 @@ void ice_free_vfs(struct ice_pf *pf)
 	 * before this function ever gets called.
 	 */
 	if (!pci_vfs_assigned(pf->pdev)) {
-		int vf_id;
+		unsigned int vf_id;
 
 		/* Acknowledge VFLR for all VFs. Without this, VFs will fail to
 		 * work correctly when SR-IOV gets re-enabled.
@@ -399,9 +400,9 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 {
 	struct ice_pf *pf = vf->pf;
 	u32 reg, reg_idx, bit_idx;
+	unsigned int vf_abs_id, i;
 	struct device *dev;
 	struct ice_hw *hw;
-	int vf_abs_id, i;
 
 	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
@@ -449,7 +450,7 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 		if ((reg & VF_TRANS_PENDING_M) == 0)
 			break;
 
-		dev_err(dev, "VF %d PCI transactions stuck\n", vf->vf_id);
+		dev_err(dev, "VF %u PCI transactions stuck\n", vf->vf_id);
 		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
 	}
 }
@@ -1515,7 +1516,7 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 void ice_process_vflr_event(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
-	int vf_id;
+	unsigned int vf_id;
 	u32 reg;
 
 	if (!test_and_clear_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
@@ -1556,7 +1557,7 @@ static void ice_vc_reset_vf(struct ice_vf *vf)
  */
 static struct ice_vf *ice_get_vf_from_pfq(struct ice_pf *pf, u16 pfq)
 {
-	int vf_id;
+	unsigned int vf_id;
 
 	ice_for_each_vf(pf, vf_id) {
 		struct ice_vf *vf = &pf->vf[vf_id];
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index f7fd1188efa4..474293ff4fe5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -64,7 +64,7 @@ struct ice_mdd_vf_events {
 struct ice_vf {
 	struct ice_pf *pf;
 
-	s16 vf_id;			/* VF ID in the PF space */
+	u16 vf_id;			/* VF ID in the PF space */
 	u16 lan_vsi_idx;		/* index into PF struct */
 	/* first vector index of this VF in the PF space */
 	int first_vector_idx;
-- 
2.26.2

