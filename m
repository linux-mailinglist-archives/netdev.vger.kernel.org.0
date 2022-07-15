Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABE3576931
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiGOVt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiGOVt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:49:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ACE4F197
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 14:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657921797; x=1689457797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w16jyCXNgEGbLtMlcwmBQj6+UkwnC02xHDYT9NfTOsc=;
  b=kBudi0M6aFL46vBVGWi4EOygljN2fpL5ebXrh89ADUfd2NepaIL2eCH4
   JrEllteI7gR8/LzrqsLIx9GQgL5Bovl+KaUGAmt5AOS+tMkyMVTpwmpFG
   cNXr59vBfb8w9bzjMxUJnZZ/k11zHkEX5vaeQ4vJdXa9cFHgIzuM5EMNx
   ltTZbJnL33jVgXbuHSQ5CkfIY+msjzx4TeqPfJ0g+xSJjbcyN4iF3dHdf
   yeJJ0Yv8IK6fk+0dS4aLnpvJiUO8vBQiBGDZo11fWxgmv81mXFMA7mEJv
   HKBDYIvZNGBghIe3PN7NveTAiQWXNgDVLgD/0UtOILXmvaLJpVk1HAzaz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="283467137"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="283467137"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="571693443"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Jul 2022 14:49:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 1/2] ice: Add EXTTS feature to the feature bitmap
Date:   Fri, 15 Jul 2022 14:46:41 -0700
Message-Id: <20220715214642.2968799-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
References: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

External time stamp sources are supported only on certain devices. Enforce
the right support matrix by adding the ICE_F_PTP_EXTTS bit to the feature
bitmap set.

Co-developed-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c |  1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c | 18 +++++++++++++-----
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..f72c5cc4e035 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -181,6 +181,7 @@
 
 enum ice_feature {
 	ICE_F_DSCP,
+	ICE_F_PTP_EXTTS,
 	ICE_F_SMA_CTRL,
 	ICE_F_GNSS,
 	ICE_F_MAX
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a6c4be5e5566..bc357dfae306 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4182,6 +4182,7 @@ void ice_init_feature_support(struct ice_pf *pf)
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
 		ice_set_feature_support(pf, ICE_F_DSCP);
+		ice_set_feature_support(pf, ICE_F_PTP_EXTTS);
 		if (ice_is_e810t(&pf->hw)) {
 			ice_set_feature_support(pf, ICE_F_SMA_CTRL);
 			if (ice_gnss_is_gps_present(&pf->hw))
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ef9344ef0d8e..29c7a0ccb3c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1900,9 +1900,12 @@ ice_ptp_setup_pins_e810t(struct ice_pf *pf, struct ptp_clock_info *info)
 	}
 
 	info->n_per_out = N_PER_OUT_E810T;
-	info->n_ext_ts = N_EXT_TS_E810;
-	info->n_pins = NUM_PTP_PINS_E810T;
-	info->verify = ice_verify_pin_e810t;
+
+	if (ice_is_feature_supported(pf, ICE_F_PTP_EXTTS)) {
+		info->n_ext_ts = N_EXT_TS_E810;
+		info->n_pins = NUM_PTP_PINS_E810T;
+		info->verify = ice_verify_pin_e810t;
+	}
 
 	/* Complete setup of the SMA pins */
 	ice_ptp_setup_sma_pins_e810t(pf, info);
@@ -1910,11 +1913,16 @@ ice_ptp_setup_pins_e810t(struct ice_pf *pf, struct ptp_clock_info *info)
 
 /**
  * ice_ptp_setup_pins_e810 - Setup PTP pins in sysfs
+ * @pf: pointer to the PF instance
  * @info: PTP clock capabilities
  */
-static void ice_ptp_setup_pins_e810(struct ptp_clock_info *info)
+static void ice_ptp_setup_pins_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 {
 	info->n_per_out = N_PER_OUT_E810;
+
+	if (!ice_is_feature_supported(pf, ICE_F_PTP_EXTTS))
+		return;
+
 	info->n_ext_ts = N_EXT_TS_E810;
 }
 
@@ -1956,7 +1964,7 @@ ice_ptp_set_funcs_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 	if (ice_is_e810t(&pf->hw))
 		ice_ptp_setup_pins_e810t(pf, info);
 	else
-		ice_ptp_setup_pins_e810(info);
+		ice_ptp_setup_pins_e810(pf, info);
 }
 
 /**
-- 
2.35.1

