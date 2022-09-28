Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7315EE6A6
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiI1Uci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI1Ucg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:32:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AD6CBADF
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664397155; x=1695933155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XtAnbFxKmQd9aLyhUNHLOmgA5XqpbJwXlqhzdefmgvk=;
  b=P92irkaVMqTdPvsd45tlvXq9EH8HcfIIA2xoVSqijjBKGoeiZxobiJ0j
   vwrUGmkpoPVJb8NCKBePj9UKAHyWW0DoRae2tW+tQDj+Uh/jgcwDndWu1
   MgUTbjCeBKDfQu6AJsWDkqdBSdxFrhGelYDHsKWzQAFaPgCm00GVW6vrs
   uLn/yb7GX0njM0Ch26CrL3RBFqtq/BQLVInjlwtJt77vaGc7ybEdIY42B
   lhYSXqXjy+7+Xk48gJaJvcANnYWqVQLn13z0QXIIGP3BLeeGWubkQGyMZ
   7Y+qf27jipAT54N8qBsCRpnCQQKN5/VVepMo6c3HwBLPKP93s36QLqysE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="299308077"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="299308077"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 13:32:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="726099953"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="726099953"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2022 13:32:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/3] ice: Merge pin initialization of E810 and E810T adapters
Date:   Wed, 28 Sep 2022 13:32:15 -0700
Message-Id: <20220928203217.411078-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
References: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Remove separate function initializing pins for E810T-based adapters
and initialize pins based on feature bits.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 47 +++++-------------------
 drivers/net/ethernet/intel/ice/ice_ptp.h |  4 +-
 2 files changed, 12 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 5e41e99e91a5..011b727ab190 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2217,49 +2217,26 @@ ice_ptp_setup_sma_pins_e810t(struct ice_pf *pf, struct ptp_clock_info *info)
 }
 
 /**
- * ice_ptp_setup_pins_e810t - Setup PTP pins in sysfs
+ * ice_ptp_setup_pins_e810 - Setup PTP pins in sysfs
  * @pf: pointer to the PF instance
  * @info: PTP clock capabilities
  */
 static void
-ice_ptp_setup_pins_e810t(struct ice_pf *pf, struct ptp_clock_info *info)
+ice_ptp_setup_pins_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 {
-	/* Check if SMA controller is in the netlist */
-	if (ice_is_feature_supported(pf, ICE_F_SMA_CTRL) &&
-	    !ice_is_pca9575_present(&pf->hw))
-		ice_clear_feature_support(pf, ICE_F_SMA_CTRL);
-
-	if (!ice_is_feature_supported(pf, ICE_F_SMA_CTRL)) {
-		info->n_ext_ts = N_EXT_TS_E810_NO_SMA;
-		info->n_per_out = N_PER_OUT_E810T_NO_SMA;
-		return;
-	}
+	info->n_per_out = N_PER_OUT_E810;
 
-	info->n_per_out = N_PER_OUT_E810T;
+	if (ice_is_feature_supported(pf, ICE_F_PTP_EXTTS))
+		info->n_ext_ts = N_EXT_TS_E810;
 
-	if (ice_is_feature_supported(pf, ICE_F_PTP_EXTTS)) {
+	if (ice_is_feature_supported(pf, ICE_F_SMA_CTRL)) {
 		info->n_ext_ts = N_EXT_TS_E810;
 		info->n_pins = NUM_PTP_PINS_E810T;
 		info->verify = ice_verify_pin_e810t;
-	}
-
-	/* Complete setup of the SMA pins */
-	ice_ptp_setup_sma_pins_e810t(pf, info);
-}
-
-/**
- * ice_ptp_setup_pins_e810 - Setup PTP pins in sysfs
- * @pf: pointer to the PF instance
- * @info: PTP clock capabilities
- */
-static void ice_ptp_setup_pins_e810(struct ice_pf *pf, struct ptp_clock_info *info)
-{
-	info->n_per_out = N_PER_OUT_E810;
 
-	if (!ice_is_feature_supported(pf, ICE_F_PTP_EXTTS))
-		return;
-
-	info->n_ext_ts = N_EXT_TS_E810;
+		/* Complete setup of the SMA pins */
+		ice_ptp_setup_sma_pins_e810t(pf, info);
+	}
 }
 
 /**
@@ -2296,11 +2273,7 @@ static void
 ice_ptp_set_funcs_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 {
 	info->enable = ice_ptp_gpio_enable_e810;
-
-	if (ice_is_e810t(&pf->hw))
-		ice_ptp_setup_pins_e810t(pf, info);
-	else
-		ice_ptp_setup_pins_e810(pf, info);
+	ice_ptp_setup_pins_e810(pf, info);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index a224b5e90386..028349295b71 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -235,8 +235,8 @@ struct ice_ptp {
 #define N_EXT_TS_E810			3
 #define N_PER_OUT_E810			4
 #define N_PER_OUT_E810T			3
-#define N_PER_OUT_E810T_NO_SMA		2
-#define N_EXT_TS_E810_NO_SMA		2
+#define N_PER_OUT_NO_SMA_E810T		2
+#define N_EXT_TS_NO_SMA_E810T		2
 #define ETH_GLTSYN_ENA(_i)		(0x03000348 + ((_i) * 4))
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
-- 
2.35.1

