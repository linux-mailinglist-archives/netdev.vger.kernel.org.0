Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A519368A473
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbjBCVQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjBCVP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:15:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676F2A4284
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675458942; x=1706994942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cMbx4hyla0O9dnu6FZ8KUNIV8u3+b4m2TFwj78tP0YM=;
  b=HurXgdsK0MSArEoUbWAh/a/1fg3ni3aCrpIPjj04NC5pBdzy284Kl5EU
   PGK5w4mkqI1JhcteHfS9r6BSYTkAabYGG2r1+o8M0EpcO+eQIYzIxIOif
   TILe4CNGvyZySpEL18oQ+9UmCdVufdfK464HrihqCkL1ZI2HBNmdQ2KYf
   8zHuCs6gCXqFn/z5kRuADPSC0cDRhZMPcFHY6uujGJK6MPtw9K2cmPz5D
   GfZxx9bzsrbzhy9iEmO+6f9qyQRBs96tEYmQAKRGU3NsJX7Cyzpv5D+1x
   tcGtYus5Diy1avNLA7dtZVo8r1ZTY9Z94FEAQLy1RcI/tcXFKMrdrf9z0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="393446849"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="393446849"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 13:15:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="911280506"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="911280506"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2023 13:15:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 08/10] ice: move VSI delete outside deconfig
Date:   Fri,  3 Feb 2023 13:14:54 -0800
Message-Id: <20230203211456.705649-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
References: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

In deconfig VSI shouldn't be deleted from hw.

Rewrite VSI delete function to reflect that sometimes it is only needed
to remove VSI from hw without freeing the memory:
ice_vsi_delete() -> delete from HW and free memory
ice_vsi_delete_from_hw() -> delete only from HW

Value returned from ice_vsi_free() is never used. Change return type to
void.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 28 +++++++++++------------
 drivers/net/ethernet/intel/ice/ice_lib.h  |  1 -
 drivers/net/ethernet/intel/ice/ice_main.c |  5 +---
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 528783de0df0..1b83f67d1029 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -282,10 +282,10 @@ static int ice_get_free_slot(void *array, int size, int curr)
 }
 
 /**
- * ice_vsi_delete - delete a VSI from the switch
+ * ice_vsi_delete_from_hw - delete a VSI from the switch
  * @vsi: pointer to VSI being removed
  */
-void ice_vsi_delete(struct ice_vsi *vsi)
+static void ice_vsi_delete_from_hw(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_vsi_ctx *ctxt;
@@ -453,26 +453,21 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
  *
  * This deallocates the VSI's queue resources, removes it from the PF's
  * VSI array if necessary, and deallocates the VSI
- *
- * Returns 0 on success, negative on failure
  */
-int ice_vsi_free(struct ice_vsi *vsi)
+static void ice_vsi_free(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = NULL;
 	struct device *dev;
 
-	if (!vsi)
-		return 0;
-
-	if (!vsi->back)
-		return -EINVAL;
+	if (!vsi || !vsi->back)
+		return;
 
 	pf = vsi->back;
 	dev = ice_pf_to_dev(pf);
 
 	if (!pf->vsi[vsi->idx] || pf->vsi[vsi->idx] != vsi) {
 		dev_dbg(dev, "vsi does not exist at pf->vsi[%d]\n", vsi->idx);
-		return -EINVAL;
+		return;
 	}
 
 	mutex_lock(&pf->sw_mutex);
@@ -485,8 +480,12 @@ int ice_vsi_free(struct ice_vsi *vsi)
 	ice_vsi_free_arrays(vsi);
 	mutex_unlock(&pf->sw_mutex);
 	devm_kfree(dev, vsi);
+}
 
-	return 0;
+void ice_vsi_delete(struct ice_vsi *vsi)
+{
+	ice_vsi_delete_from_hw(vsi);
+	ice_vsi_free(vsi);
 }
 
 /**
@@ -2851,7 +2850,7 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
 unroll_alloc_q_vector:
 	ice_vsi_free_q_vectors(vsi);
 unroll_vsi_init:
-	ice_vsi_delete(vsi);
+	ice_vsi_delete_from_hw(vsi);
 unroll_get_qs:
 	ice_vsi_put_qs(vsi);
 unroll_vsi_alloc_stat:
@@ -2914,7 +2913,6 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_q_vectors(vsi);
-	ice_vsi_delete(vsi);
 	ice_vsi_put_qs(vsi);
 	ice_vsi_free_arrays(vsi);
 
@@ -3312,7 +3310,7 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	 * for ex: during rmmod.
 	 */
 	if (!ice_is_reset_in_progress(pf->state))
-		ice_vsi_free(vsi);
+		ice_vsi_delete(vsi);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index ad4d5314ca76..8905f8721a76 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -42,7 +42,6 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
 int ice_set_link(struct ice_vsi *vsi, bool ena);
 
 void ice_vsi_delete(struct ice_vsi *vsi);
-int ice_vsi_free(struct ice_vsi *vsi);
 
 int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 77296db4aa77..a8920bc46982 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8573,12 +8573,9 @@ static void ice_remove_q_channels(struct ice_vsi *vsi, bool rem_fltr)
 		/* clear the VSI from scheduler tree */
 		ice_rm_vsi_lan_cfg(ch->ch_vsi->port_info, ch->ch_vsi->idx);
 
-		/* Delete VSI from FW */
+		/* Delete VSI from FW, PF and HW VSI arrays */
 		ice_vsi_delete(ch->ch_vsi);
 
-		/* Delete VSI from PF and HW VSI arrays */
-		ice_vsi_free(ch->ch_vsi);
-
 		/* free the channel */
 		kfree(ch);
 	}
-- 
2.38.1

