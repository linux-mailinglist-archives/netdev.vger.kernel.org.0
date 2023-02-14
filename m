Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93E5696FBB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjBNVb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjBNVb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:31:56 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B58305CF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676410298; x=1707946298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zf/zvwo0c+uCmwe/wIyG+O/K4j8XUaYa/gM9oI86ctk=;
  b=MP0RGbsAlj/arybkEJZyuWHPasl0NHLr3vyvp5qInc6mv9K8RXaJaErN
   lDQe3ouHOML9qI9nlAE2//D1DxVGWjjwHBL1uoM/CIJXxpIIxrcDV2tQ1
   4Efx//2W/d/+rbMo82xcBzZlBVQElRrkckLluEEMRoRTI/H9ul/G9HcvC
   /nP4/f/J56m2/SCSk75Bwgj+/BLc7lwlNoU8vlZPLVkfv1GOfc74URBOy
   WTNbpn56ktW2W7Dm9ncA+tHDD40oPpEHLzDdTel+OmU6RBxSz9NoNcqBM
   DCLCRbUq59uLPeSd42FlHJJNlNZ5lAADOSf4iIUNICEmfwtUKjU+BhA2w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331274566"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="331274566"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:30:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733025259"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="733025259"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 13:30:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/5] ice: Add GPIO pin support for E823 products
Date:   Tue, 14 Feb 2023 13:29:59 -0800
Message-Id: <20230214213003.2117125-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

Add GPIO pin setup for E823, which is only 1PPS input and output.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 25 ++++++++
 drivers/net/ethernet/intel/ice/ice_common.h |  1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 64 +++++++++++++++++++++
 3 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1b79bb0a4fcd..c2fda4fa4188 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -207,6 +207,31 @@ bool ice_is_e810t(struct ice_hw *hw)
 	return false;
 }
 
+/**
+ * ice_is_e823
+ * @hw: pointer to the hardware structure
+ *
+ * returns true if the device is E823-L or E823-C based, false if not.
+ */
+bool ice_is_e823(struct ice_hw *hw)
+{
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E823L_BACKPLANE:
+	case ICE_DEV_ID_E823L_SFP:
+	case ICE_DEV_ID_E823L_10G_BASE_T:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823L_QSFP:
+	case ICE_DEV_ID_E823C_BACKPLANE:
+	case ICE_DEV_ID_E823C_QSFP:
+	case ICE_DEV_ID_E823C_SFP:
+	case ICE_DEV_ID_E823C_10G_BASE_T:
+	case ICE_DEV_ID_E823C_SGMII:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * ice_clear_pf_cfg - Clear PF configuration
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 98aa8d124730..8ba5f935a092 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -199,6 +199,7 @@ void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
 bool ice_is_e810t(struct ice_hw *hw);
+bool ice_is_e823(struct ice_hw *hw);
 int
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_txsched_elem_data *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 3abc8db1d065..651dc385ff5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1769,6 +1769,38 @@ ice_ptp_gpio_enable_e810(struct ptp_clock_info *info,
 	return err;
 }
 
+/**
+ * ice_ptp_gpio_enable_e823 - Enable/disable ancillary features of PHC
+ * @info: the driver's PTP info structure
+ * @rq: The requested feature to change
+ * @on: Enable/disable flag
+ */
+static int ice_ptp_gpio_enable_e823(struct ptp_clock_info *info,
+				    struct ptp_clock_request *rq, int on)
+{
+	struct ice_pf *pf = ptp_info_to_pf(info);
+	struct ice_perout_channel clk_cfg = {0};
+	int err;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_PPS:
+		clk_cfg.gpio_pin = PPS_PIN_INDEX;
+		clk_cfg.period = NSEC_PER_SEC;
+		clk_cfg.ena = !!on;
+
+		err = ice_ptp_cfg_clkout(pf, PPS_CLK_GEN_CHAN, &clk_cfg, true);
+		break;
+	case PTP_CLK_REQ_EXTTS:
+		err = ice_ptp_cfg_extts(pf, !!on, rq->extts.index,
+					TIME_SYNC_PIN_INDEX, rq->extts.flags);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 /**
  * ice_ptp_gettimex64 - Get the time of the clock
  * @info: the driver's PTP info structure
@@ -2220,6 +2252,19 @@ ice_ptp_setup_pins_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 	}
 }
 
+/**
+ * ice_ptp_setup_pins_e823 - Setup PTP pins in sysfs
+ * @pf: pointer to the PF instance
+ * @info: PTP clock capabilities
+ */
+static void
+ice_ptp_setup_pins_e823(struct ice_pf *pf, struct ptp_clock_info *info)
+{
+	info->pps = 1;
+	info->n_per_out = 0;
+	info->n_ext_ts = 1;
+}
+
 /**
  * ice_ptp_set_funcs_e822 - Set specialized functions for E822 support
  * @pf: Board private structure
@@ -2257,6 +2302,23 @@ ice_ptp_set_funcs_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 	ice_ptp_setup_pins_e810(pf, info);
 }
 
+/**
+ * ice_ptp_set_funcs_e823 - Set specialized functions for E823 support
+ * @pf: Board private structure
+ * @info: PTP info to fill
+ *
+ * Assign functions to the PTP capabiltiies structure for E823 devices.
+ * Functions which operate across all device families should be set directly
+ * in ice_ptp_set_caps. Only add functions here which are distinct for e823
+ * devices.
+ */
+static void
+ice_ptp_set_funcs_e823(struct ice_pf *pf, struct ptp_clock_info *info)
+{
+	info->enable = ice_ptp_gpio_enable_e823;
+	ice_ptp_setup_pins_e823(pf, info);
+}
+
 /**
  * ice_ptp_set_caps - Set PTP capabilities
  * @pf: Board private structure
@@ -2277,6 +2339,8 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 
 	if (ice_is_e810(&pf->hw))
 		ice_ptp_set_funcs_e810(pf, info);
+	else if (ice_is_e823(&pf->hw))
+		ice_ptp_set_funcs_e823(pf, info);
 	else
 		ice_ptp_set_funcs_e822(pf, info);
 }
-- 
2.38.1

