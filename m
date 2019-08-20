Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C82996BC9
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730989AbfHTVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:51:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:28775 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730975AbfHTVux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330524"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 09/14] ice: update GLINT_DYN_CTL and GLINT_VECT2FUNC register access
Date:   Tue, 20 Aug 2019 14:50:43 -0700
Message-Id: <20190820215048.14377-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Register access for GLINT_DYN_CTL and GLINT_VECT2FUNC should be within
the PF space and not the absolute device space.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 24 +++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  3 ++-
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 93b835a24bb1..54b0e88af4ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -474,19 +474,20 @@ ice_vf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi, u16 vf_id)
 }
 
 /**
- * ice_calc_vf_first_vector_idx - Calculate absolute MSIX vector index in HW
+ * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the PF space
  * @pf: pointer to PF structure
  * @vf: pointer to VF that the first MSIX vector index is being calculated for
  *
- * This returns the first MSIX vector index in HW that is used by this VF and
- * this will always be the OICR index in the AVF driver so any functionality
+ * This returns the first MSIX vector index in PF space that is used by this VF.
+ * This index is used when accessing PF relative registers such as
+ * GLINT_VECT2FUNC and GLINT_DYN_CTL.
+ * This will always be the OICR index in the AVF driver so any functionality
  * using vf->first_vector_idx for queue configuration will have to increment by
  * 1 to avoid meddling with the OICR index.
  */
 static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
 {
-	return pf->hw.func_caps.common_cap.msix_vector_first_id +
-		pf->sriov_base_vector + vf->vf_id * pf->num_vf_msix;
+	return pf->sriov_base_vector + vf->vf_id * pf->num_vf_msix;
 }
 
 /**
@@ -597,27 +598,30 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
  */
 static void ice_ena_vf_mappings(struct ice_vf *vf)
 {
+	int abs_vf_id, abs_first, abs_last;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	int first, last, v;
 	struct ice_hw *hw;
-	int abs_vf_id;
 	u32 reg;
 
 	hw = &pf->hw;
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	first = vf->first_vector_idx;
 	last = (first + pf->num_vf_msix) - 1;
+	abs_first = first + pf->hw.func_caps.common_cap.msix_vector_first_id;
+	abs_last = (abs_first + pf->num_vf_msix) - 1;
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
 	/* VF Vector allocation */
-	reg = (((first << VPINT_ALLOC_FIRST_S) & VPINT_ALLOC_FIRST_M) |
-	       ((last << VPINT_ALLOC_LAST_S) & VPINT_ALLOC_LAST_M) |
+	reg = (((abs_first << VPINT_ALLOC_FIRST_S) & VPINT_ALLOC_FIRST_M) |
+	       ((abs_last << VPINT_ALLOC_LAST_S) & VPINT_ALLOC_LAST_M) |
 	       VPINT_ALLOC_VALID_M);
 	wr32(hw, VPINT_ALLOC(vf->vf_id), reg);
 
-	reg = (((first << VPINT_ALLOC_PCI_FIRST_S) & VPINT_ALLOC_PCI_FIRST_M) |
-	       ((last << VPINT_ALLOC_PCI_LAST_S) & VPINT_ALLOC_PCI_LAST_M) |
+	reg = (((abs_first << VPINT_ALLOC_PCI_FIRST_S)
+		 & VPINT_ALLOC_PCI_FIRST_M) |
+	       ((abs_last << VPINT_ALLOC_PCI_LAST_S) & VPINT_ALLOC_PCI_LAST_M) |
 	       VPINT_ALLOC_PCI_VALID_M);
 	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), reg);
 	/* map the interrupts to its functions */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index ada69120ff38..424bc0538956 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -45,7 +45,8 @@ struct ice_vf {
 
 	s16 vf_id;			/* VF ID in the PF space */
 	u16 lan_vsi_idx;		/* index into PF struct */
-	int first_vector_idx;		/* first vector index of this VF */
+	/* first vector index of this VF in the PF space */
+	int first_vector_idx;
 	struct ice_sw *vf_sw_id;	/* switch ID the VF VSIs connect to */
 	struct virtchnl_version_info vf_ver;
 	u32 driver_caps;		/* reported by VF driver */
-- 
2.21.0

