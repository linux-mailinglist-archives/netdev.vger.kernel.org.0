Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD9130038
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgADCt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:64695 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbgADCt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757862"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/16] ice: Set default value for ITR in alloc function
Date:   Fri,  3 Jan 2020 18:49:42 -0800
Message-Id: <20200104024953.2336731-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

When the user sets itr_setting to zero from ethtool -C, the driver changes
this value to default in ice_cfg_itr (for example after changing ring
param). Remove code that sets default value in ice_cfg_itr and move it to
place where the driver allocates q_vectors.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 77d6a0291e97..d4559d45288f 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -93,7 +93,8 @@ static int ice_pf_rxq_wait(struct ice_pf *pf, int pf_q, bool ena)
  * @vsi: the VSI being configured
  * @v_idx: index of the vector in the VSI struct
  *
- * We allocate one q_vector. If allocation fails we return -ENOMEM.
+ * We allocate one q_vector and set default value for ITR setting associated
+ * with this q_vector. If allocation fails we return -ENOMEM.
  */
 static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, int v_idx)
 {
@@ -108,6 +109,8 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, int v_idx)
 
 	q_vector->vsi = vsi;
 	q_vector->v_idx = v_idx;
+	q_vector->tx.itr_setting = ICE_DFLT_TX_ITR;
+	q_vector->rx.itr_setting = ICE_DFLT_RX_ITR;
 	if (vsi->type == ICE_VSI_VF)
 		goto out;
 	/* only set affinity_mask if the CPU is online */
@@ -674,10 +677,6 @@ void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
 	if (q_vector->num_ring_rx) {
 		struct ice_ring_container *rc = &q_vector->rx;
 
-		/* if this value is set then don't overwrite with default */
-		if (!rc->itr_setting)
-			rc->itr_setting = ICE_DFLT_RX_ITR;
-
 		rc->target_itr = ITR_TO_REG(rc->itr_setting);
 		rc->next_update = jiffies + 1;
 		rc->current_itr = rc->target_itr;
@@ -688,10 +687,6 @@ void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
 	if (q_vector->num_ring_tx) {
 		struct ice_ring_container *rc = &q_vector->tx;
 
-		/* if this value is set then don't overwrite with default */
-		if (!rc->itr_setting)
-			rc->itr_setting = ICE_DFLT_TX_ITR;
-
 		rc->target_itr = ITR_TO_REG(rc->itr_setting);
 		rc->next_update = jiffies + 1;
 		rc->current_itr = rc->target_itr;
-- 
2.24.1

