Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DA868A46D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjBCVPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjBCVPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:15:38 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A963E094
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675458925; x=1706994925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=54EIFxZf9wAIhRZSEcoIqM09Ma6L7sv4AtBXsxteUxY=;
  b=F/MjvTwtUWmLbz++aiJBUPUnL/QrHrFuiuRNQUwAOk90p5cePdatSgNv
   3alpFA2wlm3J9Ztbd92d35AVlpASDO77q93Yeoa3Co7mceQfcscn9OMmu
   D1klOxaHv1E1KL2OBdooMa2Jujqj546kIUftEPQZ/wGiyOtx8goboPIVj
   Fbk6g598CRTeGu4Ezdi4IjVmXGptIp9f0bz9Ztq28GgFPv5RZkZPus8Qr
   d5kWnurWKtvLSFJ38k7xNKj3nk63TZjFUZgUmA4AzZnjLE7FYhkbzfxn5
   P9l6OQ+xeyBRw33CUTuXn0s0qufw5bqB4zqJSbM8JxbiFxIzx/plpvG6F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="393446819"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="393446819"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 13:15:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="911280474"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="911280474"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2023 13:15:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 03/10] ice: cleanup in VSI config/deconfig code
Date:   Fri,  3 Feb 2023 13:14:49 -0800
Message-Id: <20230203211456.705649-4-anthony.l.nguyen@intel.com>
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
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  3 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     | 51 +++++++-------------
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 12 ++---
 5 files changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e8558c044155..3f8ee7c6f087 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -353,7 +353,6 @@ struct ice_vsi {
 
 	struct ice_vf *vf;		/* VF associated with this VSI */
 
-	u16 ethtype;			/* Ethernet protocol for pause frame */
 	u16 num_gfltr;
 	u16 num_bfltr;
 
@@ -889,7 +888,7 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp,
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_down_up(struct ice_vsi *vsi);
-int ice_vsi_cfg(struct ice_vsi *vsi);
+int ice_vsi_cfg_lan(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
 int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
 int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index baaeb7564b4b..6f03e9fe331a 100644
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
index 301c1efe08b4..b3f03f9932d2 100644
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
@@ -3623,7 +3606,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		vsi->netdev = NULL;
 	}
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
index 384679042bfa..703a732c421d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6128,12 +6128,12 @@ static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
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
 
@@ -6349,7 +6349,7 @@ int ice_up(struct ice_vsi *vsi)
 {
 	int err;
 
-	err = ice_vsi_cfg(vsi);
+	err = ice_vsi_cfg_lan(vsi);
 	if (!err)
 		err = ice_up_complete(vsi);
 
@@ -6917,7 +6917,7 @@ int ice_vsi_open_ctrl(struct ice_vsi *vsi)
 	if (err)
 		goto err_setup_rx;
 
-	err = ice_vsi_cfg(vsi);
+	err = ice_vsi_cfg_lan(vsi);
 	if (err)
 		goto err_setup_rx;
 
@@ -6971,7 +6971,7 @@ int ice_vsi_open(struct ice_vsi *vsi)
 	if (err)
 		goto err_setup_rx;
 
-	err = ice_vsi_cfg(vsi);
+	err = ice_vsi_cfg_lan(vsi);
 	if (err)
 		goto err_setup_rx;
 
@@ -8405,7 +8405,7 @@ static void ice_remove_q_channels(struct ice_vsi *vsi, bool rem_fltr)
 		ice_vsi_delete(ch->ch_vsi);
 
 		/* Delete VSI from PF and HW VSI arrays */
-		ice_vsi_clear(ch->ch_vsi);
+		ice_vsi_free(ch->ch_vsi);
 
 		/* free the channel */
 		kfree(ch);
-- 
2.38.1

