Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F68513AE1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350494AbiD1Ral (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350442AbiD1Rab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF4D3DA50
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166836; x=1682702836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O/+TwzxzQw244GhGH6MB1EY6rRS75/fNl6DIMCOwdYQ=;
  b=Nhf+CdACKyZSCYRG5lCkCGZId1cg2aWXbkPWfusMp50O8c5zvqejKHC+
   yLAJsyliAV0JeH8kkjWDDyfTnscQQjgQ+cTQx2Ze5ZcGilVDRQX4DUqz3
   pKFCwvR3RjCLUZbp/erv67UGm6xWq1qsThJBU9PQDsUiKLvrFiA4SmnFn
   WkItUisfbRMZmrSKWkIPrbuBCFR9QJAAGs75VH0IquV/4rRAJOsrUYu/z
   RaHp1m6RvmM0jKQawxYLqPqAl7Kj+EpYQIk0lx1otyGB7WaoY+ym6/DpE
   RfoAIQzKcKTHucnwRW8vuLK9NJ4xAjPqIhkRL92V/5Fo20uCdPkWIbxyC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306354"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306354"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497034"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 03/11] ice: introduce common helper for retrieving VSI by vsi_num
Date:   Thu, 28 Apr 2022 10:24:22 -0700
Message-Id: <20220428172430.1004528-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Both ice_idc.c and ice_virtchnl.c carry their own implementation of a
helper function that is looking for a given VSI based on provided
vsi_num. Their functionality is the same, so let's introduce the common
function in ice.h that both of the mentioned sites will use.

This is a strictly cleanup thing, no functionality is changed.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 15 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.c      | 15 -------------
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 22 ++-----------------
 3 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 517eb8bb0f9b..17fb1ddea7b0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -772,6 +772,21 @@ static inline struct ice_vsi *ice_get_ctrl_vsi(struct ice_pf *pf)
 	return pf->vsi[pf->ctrl_vsi_idx];
 }
 
+/**
+ * ice_find_vsi - Find the VSI from VSI ID
+ * @pf: The PF pointer to search in
+ * @vsi_num: The VSI ID to search for
+ */
+static inline struct ice_vsi *ice_find_vsi(struct ice_pf *pf, u16 vsi_num)
+{
+	int i;
+
+	ice_for_each_vsi(pf, i)
+		if (pf->vsi[i] && pf->vsi[i]->vsi_num == vsi_num)
+			return  pf->vsi[i];
+	return NULL;
+}
+
 /**
  * ice_is_switchdev_running - check if switchdev is configured
  * @pf: pointer to PF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 25a436d342c2..7e941264ae21 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -47,21 +47,6 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 	device_unlock(&pf->adev->dev);
 }
 
-/**
- * ice_find_vsi - Find the VSI from VSI ID
- * @pf: The PF pointer to search in
- * @vsi_num: The VSI ID to search for
- */
-static struct ice_vsi *ice_find_vsi(struct ice_pf *pf, u16 vsi_num)
-{
-	int i;
-
-	ice_for_each_vsi(pf, i)
-		if (pf->vsi[i] && pf->vsi[i]->vsi_num == vsi_num)
-			return  pf->vsi[i];
-	return NULL;
-}
-
 /**
  * ice_add_rdma_qset - Add Leaf Node for RDMA Qset
  * @pf: PF struct
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 69ff4b929772..9bf52fa3c1b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -514,24 +514,6 @@ static void ice_vc_reset_vf_msg(struct ice_vf *vf)
 		ice_reset_vf(vf, 0);
 }
 
-/**
- * ice_find_vsi_from_id
- * @pf: the PF structure to search for the VSI
- * @id: ID of the VSI it is searching for
- *
- * searches for the VSI with the given ID
- */
-static struct ice_vsi *ice_find_vsi_from_id(struct ice_pf *pf, u16 id)
-{
-	int i;
-
-	ice_for_each_vsi(pf, i)
-		if (pf->vsi[i] && pf->vsi[i]->vsi_num == id)
-			return pf->vsi[i];
-
-	return NULL;
-}
-
 /**
  * ice_vc_isvalid_vsi_id
  * @vf: pointer to the VF info
@@ -544,7 +526,7 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
-	vsi = ice_find_vsi_from_id(pf, vsi_id);
+	vsi = ice_find_vsi(pf, vsi_id);
 
 	return (vsi && (vsi->vf == vf));
 }
@@ -559,7 +541,7 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
  */
 static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
 {
-	struct ice_vsi *vsi = ice_find_vsi_from_id(vf->pf, vsi_id);
+	struct ice_vsi *vsi = ice_find_vsi(vf->pf, vsi_id);
 	/* allocated Tx and Rx queues should be always equal for VF VSI */
 	return (vsi && (qid < vsi->alloc_txq));
 }
-- 
2.31.1

