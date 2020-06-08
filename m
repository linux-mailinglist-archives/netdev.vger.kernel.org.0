Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F441F2F39
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgFIAs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728781AbgFHXKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE4520890;
        Mon,  8 Jun 2020 23:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657852;
        bh=HeE/HJwWUMBmoDka4WbFolryeFAQ61D7D/Kmtai3kmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DKeL21O6lceXBAw4EJv2ne46NvKRPe9DCtkfU0aM/o22nCH2+GmMDJjc8OpJvT1O
         XnSgY+IIeWaTlLpqErL0yuDSeU0S6MdnZN9SJy6qIEDMKv7rUKC40OyU+giziVSbFn
         O/yXHc0jhO13w5tRnt9KFW6FCkvMMcZAvdYYhq4M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 217/274] ice: cleanup vf_id signedness
Date:   Mon,  8 Jun 2020 19:05:10 -0400
Message-Id: <20200608230607.3361041-217-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 53bb66983f34d4ff0af179fe228e2c55e1e45921 ]

The vf_id variable is dealt with in the code in inconsistent
ways of sign usage, preventing compilation with -Werror=sign-compare.
Fix this problem in the code by always treating vf_id as unsigned, since
there are no valid values of vf_id that are negative.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h            |  2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c    | 17 +++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h    |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5c11448bfbb3..020ee167f73a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -366,7 +366,7 @@ struct ice_pf {
 	struct ice_sw *first_sw;	/* first switch created by firmware */
 	/* Virtchnl/SR-IOV config info */
 	struct ice_vf *vf;
-	int num_alloc_vfs;		/* actual number of VFs allocated */
+	u16 num_alloc_vfs;		/* actual number of VFs allocated */
 	u16 num_vfs_supported;		/* num VFs supported for this PF */
 	u16 num_qps_per_vf;
 	u16 num_msix_per_vf;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 15191a325918..c9c281167873 100644
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
@@ -337,7 +338,7 @@ void ice_free_vfs(struct ice_pf *pf)
 	 * before this function ever gets called.
 	 */
 	if (!pci_vfs_assigned(pf->pdev)) {
-		int vf_id;
+		unsigned int vf_id;
 
 		/* Acknowledge VFLR for all VFs. Without this, VFs will fail to
 		 * work correctly when SR-IOV gets re-enabled.
@@ -368,9 +369,9 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 {
 	struct ice_pf *pf = vf->pf;
 	u32 reg, reg_idx, bit_idx;
+	unsigned int vf_abs_id, i;
 	struct device *dev;
 	struct ice_hw *hw;
-	int vf_abs_id, i;
 
 	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
@@ -418,7 +419,7 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 		if ((reg & VF_TRANS_PENDING_M) == 0)
 			break;
 
-		dev_err(dev, "VF %d PCI transactions stuck\n", vf->vf_id);
+		dev_err(dev, "VF %u PCI transactions stuck\n", vf->vf_id);
 		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
 	}
 }
@@ -1483,7 +1484,7 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 void ice_process_vflr_event(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
-	int vf_id;
+	unsigned int vf_id;
 	u32 reg;
 
 	if (!test_and_clear_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
@@ -1524,7 +1525,7 @@ static void ice_vc_reset_vf(struct ice_vf *vf)
  */
 static struct ice_vf *ice_get_vf_from_pfq(struct ice_pf *pf, u16 pfq)
 {
-	int vf_id;
+	unsigned int vf_id;
 
 	ice_for_each_vf(pf, vf_id) {
 		struct ice_vf *vf = &pf->vf[vf_id];
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 3f9464269bd2..62875704cecf 100644
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
2.25.1

