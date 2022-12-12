Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACDE649E08
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiLLLiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiLLLgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:36:40 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17A10072
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844800; x=1702380800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=De8/hoqshrRcFoO6dpkoJyws8syDggPVjTXTixkRy+E=;
  b=FxBAzD842elZaRWQHOrAb0X9XBRqNKdakOcQE5FR6v/TFqdnLAw+ad9M
   WWzzT7QEsXlBnGLskdVLPTa1al+2HgXITFqGgB84ppQ9ZHaoxRsJFwg3X
   FY9b7AIFQDQ2syCbmu9gruWuRVHYYMQgDV2ANEMOPFDAsBvpEHD8Ows5J
   pZf+ErQUg2WbVA35iqj5Hzf4Ep8e27q2OMYgmLcnA94h1c6w0LJnGoUiT
   QbGddlm6PbdOxpOBU8T1qC5Zq7S8cWGx1cj4FeE6lbiaDkk8rVxjhY2y0
   CQKcOskn1rhSEIb2zSXF9OwW+chg+gL6gPlsR7Ugku/T1SfjasMML6tw8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861533"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861533"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:33:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459833"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459833"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:33:16 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, leon@kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v1 08/10] ice: move VSI delete outside deconfig
Date:   Mon, 12 Dec 2022 12:16:43 +0100
Message-Id: <20221212111645.1198680-9-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In deconfig VSI shouldn't be deleted from hw.

Rewrite VSI delete function to reflect that sometimes it is only needed
to remove VSI from hw without freeing the memory:
ice_vsi_delete() -> delete from HW and free memory
ice_vsi_delete_from_hw() -> delete only from HW

Value returned from ice_vsi_free() is never used. Change return type to
void.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 28 +++++++++++------------
 drivers/net/ethernet/intel/ice/ice_lib.h  |  1 -
 drivers/net/ethernet/intel/ice/ice_main.c |  5 +---
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index eba990120a06..ae6ce6a74d03 100644
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
@@ -2843,7 +2842,7 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
 unroll_alloc_q_vector:
 	ice_vsi_free_q_vectors(vsi);
 unroll_vsi_init:
-	ice_vsi_delete(vsi);
+	ice_vsi_delete_from_hw(vsi);
 unroll_get_qs:
 	ice_vsi_put_qs(vsi);
 unroll_vsi_alloc:
@@ -2904,7 +2903,6 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_q_vectors(vsi);
-	ice_vsi_delete(vsi);
 	ice_vsi_put_qs(vsi);
 	ice_vsi_free_arrays(vsi);
 
@@ -3308,7 +3306,7 @@ int ice_vsi_release(struct ice_vsi *vsi)
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
index d8f51aee78ff..fbeac890a606 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8689,12 +8689,9 @@ static void ice_remove_q_channels(struct ice_vsi *vsi, bool rem_fltr)
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
2.36.1

