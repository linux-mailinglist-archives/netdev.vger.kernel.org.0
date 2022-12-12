Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81B9649DFC
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiLLLfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiLLLfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:35:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE879FEB
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844779; x=1702380779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mqi2OHuSPRAcGS5qn801+zTuJ/queMoUZHtLnNe0JVM=;
  b=dPISZniUNvWzokgVaeMVGaxO1+/N+wrOs5Vrw5g1R4gJFXvEYZXZvATt
   tNCFXcg/0WQDnw/u/PFokd4FfBQvrM/X6vreLzLPOLfAVNGuFhklws/Or
   MzxMV1wyOwL98pE6kPLPXaHrWb/b59YJcBRxTBWNWbPWiyrh13FyMD78c
   TBdDU7l7broM7W5vCaKxZomd6mWBMLeXCTGhq4TiYcwAJioIxCP0cW8hn
   FFA4NbkKOiZvSGJXNVTYt4RAGriZ7KMsMek64lLsu7n6rjwSeOk46ffq5
   HzyhITgGV1CQWeOglgoFi6RiRZgulhl+mwNlMyfQFNNS9MPkgfkQB1g25
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861453"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861453"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:32:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459719"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459719"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:32:55 -0800
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
Subject: [PATCH net-next v1 03/10] ice: cleanup in VSI config/deconfig code
Date:   Mon, 12 Dec 2022 12:16:38 +0100
Message-Id: <20221212111645.1198680-4-michal.swiatkowski@linux.intel.com>
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

Do few small cleanups:

1) Rename the function to reflect that it doesn't configure all things
related to VSI. ice_vsi_cfg_lan() better fits to what function is doing.

ice_vsi_cfg() can be use to name function that will configure whole VSI.

2) Remove unused ethtype field from VSI. There is no need to set
ethtype here, because it is never used.

3) Remove unnecessary check for ICE_VSI_CHNL. There is check for
ICE_VSI_CHNL in ice_vsi_get_qs, so there is no need to check it before
calling the function.

4) Simplify ice_vsi_alloc() call. There is no need to check the type of
VSI before calling ice_vsi_alloc(). For ICE_VSI_CHNL vf is always NULL
(ice_vsi_setup() is called with vf=NULL).
For ICE_VSI_VF or ICE_VSI_CTRL ch is always NULL and for other VSI types
ch and vf are always NULL.

5) Remove unnecessary call to ice_vsi_dis_irq(). ice_vsi_dis_irq() will
be called in ice_vsi_close() flow (ice_vsi_close() -> ice_vsi_down() ->
ice_vsi_dis_irq()). Remove unnecessary call.

6) Don't remove specific filters in release. All hw filters are removed
in ice_fltr_remove_alli(), which is always called in VSI release flow.
There is no need to remove only ethertype filters before calling
ice_fltr_remove_all().

7) Rename ice_vsi_clear() to ice_vsi_free(). As ice_vsi_clear() only
free memory allocated in ice_vsi_alloc() rename it to ice_vsi_free()
which better shows what function is doing.

8) Free coalesce param in rebuild. There is potential memory leak if
configuration of VSI lan fails. Free coalesce to avoid it.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  3 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     | 51 +++++++-------------
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 12 ++---
 5 files changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index f461a1b3c100..70a9609f1b80 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -354,7 +354,6 @@ struct ice_vsi {
 
 	struct ice_vf *vf;		/* VF associated with this VSI */
 
-	u16 ethtype;			/* Ethernet protocol for pause frame */
 	u16 num_gfltr;
 	u16 num_bfltr;
 
@@ -891,7 +890,7 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp,
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_down_up(struct ice_vsi *vsi);
-int ice_vsi_cfg(struct ice_vsi *vsi);
+int ice_vsi_cfg_lan(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
 int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
 int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 626480677cc1..63b7568a9d72 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -656,7 +656,7 @@ static int ice_lbtest_prepare_rings(struct ice_vsi *vsi)
 	if (status)
 		goto err_setup_rx_ring;
 
-	status = ice_vsi_cfg(vsi);
+	status = ice_vsi_cfg_lan(vsi);
 	if (status)
 		goto err_setup_rx_ring;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 703f73e54561..a7225de4a1e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -348,7 +348,7 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_clear - clean up and deallocate the provided VSI
+ * ice_vsi_free - clean up and deallocate the provided VSI
  * @vsi: pointer to VSI being cleared
  *
  * This deallocates the VSI's queue resources, removes it from the PF's
@@ -356,7 +356,7 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
  *
  * Returns 0 on success, negative on failure
  */
-int ice_vsi_clear(struct ice_vsi *vsi)
+int ice_vsi_free(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = NULL;
 	struct device *dev;
@@ -2668,12 +2668,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	struct ice_vsi *vsi;
 	int ret, i;
 
-	if (vsi_type == ICE_VSI_CHNL)
-		vsi = ice_vsi_alloc(pf, vsi_type, ch, NULL);
-	else if (vsi_type == ICE_VSI_VF || vsi_type == ICE_VSI_CTRL)
-		vsi = ice_vsi_alloc(pf, vsi_type, NULL, vf);
-	else
-		vsi = ice_vsi_alloc(pf, vsi_type, NULL, NULL);
+	vsi = ice_vsi_alloc(pf, vsi_type, ch, vf);
 
 	if (!vsi) {
 		dev_err(dev, "could not allocate VSI\n");
@@ -2682,17 +2677,13 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 	vsi->port_info = pi;
 	vsi->vsw = pf->first_sw;
-	if (vsi->type == ICE_VSI_PF)
-		vsi->ethtype = ETH_P_PAUSE;
 
 	ice_alloc_fd_res(vsi);
 
-	if (vsi_type != ICE_VSI_CHNL) {
-		if (ice_vsi_get_qs(vsi)) {
-			dev_err(dev, "Failed to allocate queues. vsi->idx = %d\n",
-				vsi->idx);
-			goto unroll_vsi_alloc;
-		}
+	if (ice_vsi_get_qs(vsi)) {
+		dev_err(dev, "Failed to allocate queues. vsi->idx = %d\n",
+			vsi->idx);
+		goto unroll_vsi_alloc;
 	}
 
 	/* set RSS capabilities */
@@ -2857,7 +2848,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 unroll_vsi_alloc:
 	if (vsi_type == ICE_VSI_VF)
 		ice_enable_lag(pf->lag);
-	ice_vsi_clear(vsi);
+	ice_vsi_free(vsi);
 
 	return NULL;
 }
@@ -3181,9 +3172,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
-	/* Disable VSI and free resources */
-	if (vsi->type != ICE_VSI_LB)
-		ice_vsi_dis_irq(vsi);
 	ice_vsi_close(vsi);
 
 	/* SR-IOV determines needed MSIX resources all at once instead of per
@@ -3199,18 +3187,12 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
 	}
 
-	if (!ice_is_safe_mode(pf)) {
-		if (vsi->type == ICE_VSI_PF) {
-			ice_fltr_remove_eth(vsi, ETH_P_PAUSE, ICE_FLTR_TX,
-					    ICE_DROP_PACKET);
-			ice_cfg_sw_lldp(vsi, true, false);
-			/* The Rx rule will only exist to remove if the LLDP FW
-			 * engine is currently stopped
-			 */
-			if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-				ice_cfg_sw_lldp(vsi, false, false);
-		}
-	}
+	/* The Rx rule will only exist to remove if the LLDP FW
+	 * engine is currently stopped
+	 */
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
+	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		ice_cfg_sw_lldp(vsi, false, false);
 
 	if (ice_is_vsi_dflt_vsi(vsi))
 		ice_clear_dflt_vsi(vsi);
@@ -3247,7 +3229,7 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	 * for ex: during rmmod.
 	 */
 	if (!ice_is_reset_in_progress(pf->state))
-		ice_vsi_clear(vsi);
+		ice_vsi_free(vsi);
 
 	return 0;
 }
@@ -3601,6 +3583,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 			ret = -EIO;
 			goto err_vectors;
 		} else {
+			kfree(coalesce);
 			return ice_schedule_reset(pf, ICE_RESET_PFR);
 		}
 	}
@@ -3621,7 +3604,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	kfree(coalesce);
 	return ret;
 err_vsi:
-	ice_vsi_clear(vsi);
+	ice_vsi_free(vsi);
 	set_bit(ICE_RESET_FAILED, pf->state);
 	kfree(coalesce);
 	return ret;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index dcdf69a693e9..6203114b805c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -42,7 +42,7 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
 int ice_set_link(struct ice_vsi *vsi, bool ena);
 
 void ice_vsi_delete(struct ice_vsi *vsi);
-int ice_vsi_clear(struct ice_vsi *vsi);
+int ice_vsi_free(struct ice_vsi *vsi);
 
 int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 59a88c00b91d..bfab9a713533 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6206,12 +6206,12 @@ static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_cfg - Setup the VSI
+ * ice_vsi_cfg_lan - Setup the VSI lan related config
  * @vsi: the VSI being configured
  *
  * Return 0 on success and negative value on error
  */
-int ice_vsi_cfg(struct ice_vsi *vsi)
+int ice_vsi_cfg_lan(struct ice_vsi *vsi)
 {
 	int err;
 
@@ -6428,7 +6428,7 @@ int ice_up(struct ice_vsi *vsi)
 {
 	int err;
 
-	err = ice_vsi_cfg(vsi);
+	err = ice_vsi_cfg_lan(vsi);
 	if (!err)
 		err = ice_up_complete(vsi);
 
@@ -6996,7 +6996,7 @@ int ice_vsi_open_ctrl(struct ice_vsi *vsi)
 	if (err)
 		goto err_setup_rx;
 
-	err = ice_vsi_cfg(vsi);
+	err = ice_vsi_cfg_lan(vsi);
 	if (err)
 		goto err_setup_rx;
 
@@ -7050,7 +7050,7 @@ int ice_vsi_open(struct ice_vsi *vsi)
 	if (err)
 		goto err_setup_rx;
 
-	err = ice_vsi_cfg(vsi);
+	err = ice_vsi_cfg_lan(vsi);
 	if (err)
 		goto err_setup_rx;
 
@@ -8484,7 +8484,7 @@ static void ice_remove_q_channels(struct ice_vsi *vsi, bool rem_fltr)
 		ice_vsi_delete(ch->ch_vsi);
 
 		/* Delete VSI from PF and HW VSI arrays */
-		ice_vsi_clear(ch->ch_vsi);
+		ice_vsi_free(ch->ch_vsi);
 
 		/* free the channel */
 		kfree(ch);
-- 
2.36.1

