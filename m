Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF430238
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfE3Sug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfE3Suf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:35 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Use GLINT_DYN_CTL to disable VF's interrupts
Date:   Thu, 30 May 2019 11:50:31 -0700
Message-Id: <20190530185045.3886-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently in ice_free_vf_res() we are writing to the VFINT_DYN_CTLN
register in the PF's function space to disable all VF's interrupts. This
is incorrect because this register is only for use in the VF's function
space. This becomes obvious when seeing that the valid indices used for
the VFINT_DYN_CTLN register is from 0-63, which is the maximum number of
interrupts for a VF (not including the OICR interrupt). Fix this by
writing to the GLINT_DYN_CTL register for each VF. We can do this
because we keep track of each VF's first_vector_idx inside of the PF's
function space and the number of interrupts given to each VF.

Also in ice_free_vfs() we were disabling Rx/Tx queues after calling
pci_disable_sriov(). One part of disabling the Tx queues causes the PF
driver to trigger a software interrupt, which causes the VF's napi
routine to run. This doesn't currently work because pci_disable_sriov()
causes iavf_remove() to be called which disables interrupts. Fix this by
disabling Rx/Tx queues prior to pci_disable_sriov().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 41 ++++++-------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 0f79cf0e4ee8..9c6d9c95f4f6 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -140,18 +140,6 @@ static void ice_vc_notify_vf_link_state(struct ice_vf *vf)
 			      sizeof(pfe), NULL);
 }
 
-/**
- * ice_get_vf_vector - get VF interrupt vector register offset
- * @vf_msix: number of MSIx vector per VF on a PF
- * @vf_id: VF identifier
- * @i: index of MSIx vector
- */
-static u32 ice_get_vf_vector(int vf_msix, int vf_id, int i)
-{
-	return ((i == 0) ? VFINT_DYN_CTLN(vf_id) :
-		 VFINT_DYN_CTLN(((vf_msix - 1) * (vf_id)) + (i - 1)));
-}
-
 /**
  * ice_free_vf_res - Free a VF's resources
  * @vf: pointer to the VF info
@@ -159,7 +147,7 @@ static u32 ice_get_vf_vector(int vf_msix, int vf_id, int i)
 static void ice_free_vf_res(struct ice_vf *vf)
 {
 	struct ice_pf *pf = vf->pf;
-	int i, pf_vf_msix;
+	int i, last_vector_idx;
 
 	/* First, disable VF's configuration API to prevent OS from
 	 * accessing the VF's VSI after it's freed or invalidated.
@@ -174,13 +162,10 @@ static void ice_free_vf_res(struct ice_vf *vf)
 		vf->num_mac = 0;
 	}
 
-	pf_vf_msix = pf->num_vf_msix;
+	last_vector_idx = vf->first_vector_idx + pf->num_vf_msix - 1;
 	/* Disable interrupts so that VF starts in a known state */
-	for (i = 0; i < pf_vf_msix; i++) {
-		u32 reg_idx;
-
-		reg_idx = ice_get_vf_vector(pf_vf_msix, vf->vf_id, i);
-		wr32(&pf->hw, reg_idx, VFINT_DYN_CTLN_CLEARPBA_M);
+	for (i = vf->first_vector_idx; i <= last_vector_idx; i++) {
+		wr32(&pf->hw, GLINT_DYN_CTL(i), GLINT_DYN_CTL_CLEARPBA_M);
 		ice_flush(&pf->hw);
 	}
 	/* reset some of the state variables keeping track of the resources */
@@ -281,15 +266,6 @@ void ice_free_vfs(struct ice_pf *pf)
 	while (test_and_set_bit(__ICE_VF_DIS, pf->state))
 		usleep_range(1000, 2000);
 
-	/* Disable IOV before freeing resources. This lets any VF drivers
-	 * running in the host get themselves cleaned up before we yank
-	 * the carpet out from underneath their feet.
-	 */
-	if (!pci_vfs_assigned(pf->pdev))
-		pci_disable_sriov(pf->pdev);
-	else
-		dev_warn(&pf->pdev->dev, "VFs are assigned - not disabling SR-IOV\n");
-
 	/* Avoid wait time by stopping all VFs at the same time */
 	for (i = 0; i < pf->num_alloc_vfs; i++) {
 		struct ice_vsi *vsi;
@@ -305,6 +281,15 @@ void ice_free_vfs(struct ice_pf *pf)
 		clear_bit(ICE_VF_STATE_ENA, pf->vf[i].vf_states);
 	}
 
+	/* Disable IOV before freeing resources. This lets any VF drivers
+	 * running in the host get themselves cleaned up before we yank
+	 * the carpet out from underneath their feet.
+	 */
+	if (!pci_vfs_assigned(pf->pdev))
+		pci_disable_sriov(pf->pdev);
+	else
+		dev_warn(&pf->pdev->dev, "VFs are assigned - not disabling SR-IOV\n");
+
 	tmp = pf->num_alloc_vfs;
 	pf->num_vf_qps = 0;
 	pf->num_alloc_vfs = 0;
-- 
2.21.0

