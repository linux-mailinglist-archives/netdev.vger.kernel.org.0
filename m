Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2D97CEE9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbfGaUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:2714 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730821AbfGaUlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901050"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/16] ice: Remove flag to track VF interrupt status
Date:   Wed, 31 Jul 2019 13:41:46 -0700
Message-Id: <20190731204147.8582-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

As a result of refactoring of VF VSIs interrupts code, there is no
need to track its configuration status again with ICE_VF_STATE_CFG_INTR
flag - In fact, it is not being checked anywhere in the code right now, so
this patch removes the dead code as applicable to the flag.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 11 -----------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h |  5 -----
 2 files changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 00aa6364124a..ce01cbe70ea4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -297,13 +297,6 @@ void ice_free_vfs(struct ice_pf *pf)
 		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
 			/* disable VF qp mappings */
 			ice_dis_vf_mappings(&pf->vf[i]);
-
-			/* Set this state so that assigned VF vectors can be
-			 * reclaimed by PF for reuse in ice_vsi_release(). No
-			 * need to clear this bit since pf->vf array is being
-			 * freed anyways after this for loop
-			 */
-			set_bit(ICE_VF_STATE_CFG_INTR, pf->vf[i].vf_states);
 			ice_free_vf_res(&pf->vf[i]);
 		}
 	}
@@ -551,7 +544,6 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	 * expect vector assignment to be changed unless there is a request for
 	 * more vectors.
 	 */
-	clear_bit(ICE_VF_STATE_CFG_INTR, vf->vf_states);
 ice_alloc_vsi_res_exit:
 	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
 	return status;
@@ -1283,9 +1275,6 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 		/* assign default capabilities */
 		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vfs[i].vf_caps);
 		vfs[i].spoofchk = true;
-
-		/* Set this state so that PF driver does VF vector assignment */
-		set_bit(ICE_VF_STATE_CFG_INTR, vfs[i].vf_states);
 	}
 	pf->num_alloc_vfs = num_alloc_vfs;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index c3ca522c245a..ada69120ff38 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -30,11 +30,6 @@ enum ice_vf_states {
 	ICE_VF_STATE_DIS,
 	ICE_VF_STATE_MC_PROMISC,
 	ICE_VF_STATE_UC_PROMISC,
-	/* state to indicate if PF needs to do vector assignment for VF.
-	 * This needs to be set during first time VF initialization or later
-	 * when VF asks for more Vectors through virtchnl OP.
-	 */
-	ICE_VF_STATE_CFG_INTR,
 	ICE_VF_STATES_NBITS
 };
 
-- 
2.21.0

