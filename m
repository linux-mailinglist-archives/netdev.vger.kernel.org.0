Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBB513C50
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfEDXyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:32555 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727321AbfEDXyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994659"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Always free/allocate q_vectors
Date:   Sat,  4 May 2019 16:49:21 -0700
Message-Id: <20190504234929.3005-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when probing/removing the driver we allocate/deallocate
each vsi->q_vectors array in ice_vsi_alloc_arrays() and
ice_vsi_free_arrays() respectively. However, we don't do this
during the reset and VSI rebuild flow. This is inconsistent
and unnecessary to have a difference between the two flows.

This patch makes the change to always allocate/deallocate the
vsi->q_vectors array regardless of the driver flow we are in.

Also, update the comment for ice_vsi_free_arrays() to be more
descriptive.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 34 ++++++++++--------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index caa00e8873ec..7a88bf639376 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -232,12 +232,11 @@ static int ice_vsi_ctrl_rx_rings(struct ice_vsi *vsi, bool ena)
 /**
  * ice_vsi_alloc_arrays - Allocate queue and vector pointer arrays for the VSI
  * @vsi: VSI pointer
- * @alloc_qvectors: a bool to specify if q_vectors need to be allocated.
  *
  * On error: returns error code (negative)
  * On success: returns 0
  */
-static int ice_vsi_alloc_arrays(struct ice_vsi *vsi, bool alloc_qvectors)
+static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 
@@ -252,15 +251,11 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi, bool alloc_qvectors)
 	if (!vsi->rx_rings)
 		goto err_rxrings;
 
-	if (alloc_qvectors) {
-		/* allocate memory for q_vector pointers */
-		vsi->q_vectors = devm_kcalloc(&pf->pdev->dev,
-					      vsi->num_q_vectors,
-					      sizeof(*vsi->q_vectors),
-					      GFP_KERNEL);
-		if (!vsi->q_vectors)
-			goto err_vectors;
-	}
+	/* allocate memory for q_vector pointers */
+	vsi->q_vectors = devm_kcalloc(&pf->pdev->dev, vsi->num_q_vectors,
+				      sizeof(*vsi->q_vectors), GFP_KERNEL);
+	if (!vsi->q_vectors)
+		goto err_vectors;
 
 	return 0;
 
@@ -389,16 +384,15 @@ void ice_vsi_delete(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_free_arrays - clean up VSI resources
+ * ice_vsi_free_arrays - De-allocate queue and vector pointer arrays for the VSI
  * @vsi: pointer to VSI being cleared
- * @free_qvectors: bool to specify if q_vectors should be deallocated
  */
-static void ice_vsi_free_arrays(struct ice_vsi *vsi, bool free_qvectors)
+static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 
 	/* free the ring and vector containers */
-	if (free_qvectors && vsi->q_vectors) {
+	if (vsi->q_vectors) {
 		devm_kfree(&pf->pdev->dev, vsi->q_vectors);
 		vsi->q_vectors = NULL;
 	}
@@ -446,7 +440,7 @@ int ice_vsi_clear(struct ice_vsi *vsi)
 	if (vsi->idx < pf->next_vsi)
 		pf->next_vsi = vsi->idx;
 
-	ice_vsi_free_arrays(vsi, true);
+	ice_vsi_free_arrays(vsi);
 	mutex_unlock(&pf->sw_mutex);
 	devm_kfree(&pf->pdev->dev, vsi);
 
@@ -512,14 +506,14 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-		if (ice_vsi_alloc_arrays(vsi, true))
+		if (ice_vsi_alloc_arrays(vsi))
 			goto err_rings;
 
 		/* Setup default MSIX irq handler for VSI */
 		vsi->irq_handler = ice_msix_clean_rings;
 		break;
 	case ICE_VSI_VF:
-		if (ice_vsi_alloc_arrays(vsi, true))
+		if (ice_vsi_alloc_arrays(vsi))
 			goto err_rings;
 		break;
 	default:
@@ -2809,7 +2803,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	vsi->hw_base_vector = 0;
 
 	ice_vsi_clear_rings(vsi);
-	ice_vsi_free_arrays(vsi, false);
+	ice_vsi_free_arrays(vsi);
 	ice_dev_onetime_setup(&pf->hw);
 	if (vsi->type == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf->vf_id);
@@ -2822,7 +2816,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	if (ret < 0)
 		goto err_vsi;
 
-	ret = ice_vsi_alloc_arrays(vsi, false);
+	ret = ice_vsi_alloc_arrays(vsi);
 	if (ret < 0)
 		goto err_vsi;
 
-- 
2.20.1

