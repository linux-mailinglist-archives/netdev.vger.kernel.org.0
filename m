Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950B3314580
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhBIBSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:18:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:36409 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBIBR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:17:28 -0500
IronPort-SDR: NOtl21BhzatSRCsy4oXbv9vzYwH3tBiu05JDVrfEJe4J17KPA4l+RCgN1fyBw+loIpeLUGnha8
 FlQ8dCQIlQHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245879734"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245879734"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:48 -0800
IronPort-SDR: dhkD/x9+Sl28hIytiEYGNyIaJ+yN9+rZ9LbX5LAl9KtxbpYzPcJkkWCdHjgnux1+b0Hkh3dpJ/
 RFHwSetI9xdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669610"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:47 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Ben Shelton <benjamin.h.shelton@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 06/12] ice: Use PSM clock frequency to calculate RL profiles
Date:   Mon,  8 Feb 2021 17:16:30 -0800
Message-Id: <20210209011636.1989093-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Shelton <benjamin.h.shelton@intel.com>

The core clock frequency is currently hardcoded at 446 MHz for the RL
profile calculations. This causes issues since not all devices use that
clock frequency. Read the GLGEN_CLKSTAT_SRC register to determine which PSM
clock frequency is selected.  This ensures that the rate limiter profile
calculations will be correct.

Signed-off-by: Ben Shelton <benjamin.h.shelton@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   |  1 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_sched.c    | 58 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_sched.h    |  8 ++-
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
 5 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 11bb59c2ecbb..e9b40cdfeb0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -907,6 +907,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 		ice_debug(hw, ICE_DBG_SCHED, "Failed to get scheduler allocated resources\n");
 		goto err_unroll_alloc;
 	}
+	ice_sched_get_psm_clk_freq(hw);
 
 	/* Initialize port_info struct with scheduler data */
 	status = ice_sched_init_port(hw->port_info);
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 90abc8612a6a..093a1818a392 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -86,6 +86,9 @@
 #define QRXFLXP_CNTXT_RXDID_PRIO_S		8
 #define QRXFLXP_CNTXT_RXDID_PRIO_M		ICE_M(0x7, 8)
 #define QRXFLXP_CNTXT_TS_M			BIT(11)
+#define GLGEN_CLKSTAT_SRC_PSM_CLK_SRC_S		4
+#define GLGEN_CLKSTAT_SRC_PSM_CLK_SRC_M		ICE_M(0x3, 4)
+#define GLGEN_CLKSTAT_SRC			0x000B826C
 #define GLGEN_RSTAT				0x000B8188
 #define GLGEN_RSTAT_DEVSTATE_M			ICE_M(0x3, 0)
 #define GLGEN_RSTCTL				0x000B8180
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index b4f425c0b7f5..2403cb38b93c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1281,6 +1281,46 @@ enum ice_status ice_sched_query_res_alloc(struct ice_hw *hw)
 	return status;
 }
 
+/**
+ * ice_sched_get_psm_clk_freq - determine the PSM clock frequency
+ * @hw: pointer to the HW struct
+ *
+ * Determine the PSM clock frequency and store in HW struct
+ */
+void ice_sched_get_psm_clk_freq(struct ice_hw *hw)
+{
+	u32 val, clk_src;
+
+	val = rd32(hw, GLGEN_CLKSTAT_SRC);
+	clk_src = (val & GLGEN_CLKSTAT_SRC_PSM_CLK_SRC_M) >>
+		GLGEN_CLKSTAT_SRC_PSM_CLK_SRC_S;
+
+#define PSM_CLK_SRC_367_MHZ 0x0
+#define PSM_CLK_SRC_416_MHZ 0x1
+#define PSM_CLK_SRC_446_MHZ 0x2
+#define PSM_CLK_SRC_390_MHZ 0x3
+
+	switch (clk_src) {
+	case PSM_CLK_SRC_367_MHZ:
+		hw->psm_clk_freq = ICE_PSM_CLK_367MHZ_IN_HZ;
+		break;
+	case PSM_CLK_SRC_416_MHZ:
+		hw->psm_clk_freq = ICE_PSM_CLK_416MHZ_IN_HZ;
+		break;
+	case PSM_CLK_SRC_446_MHZ:
+		hw->psm_clk_freq = ICE_PSM_CLK_446MHZ_IN_HZ;
+		break;
+	case PSM_CLK_SRC_390_MHZ:
+		hw->psm_clk_freq = ICE_PSM_CLK_390MHZ_IN_HZ;
+		break;
+	default:
+		ice_debug(hw, ICE_DBG_SCHED, "PSM clk_src unexpected %u\n",
+			  clk_src);
+		/* fall back to a safe default */
+		hw->psm_clk_freq = ICE_PSM_CLK_446MHZ_IN_HZ;
+	}
+}
+
 /**
  * ice_sched_find_node_in_subtree - Find node in part of base node subtree
  * @hw: pointer to the HW struct
@@ -2856,11 +2896,12 @@ static void ice_set_clear_shared_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
 
 /**
  * ice_sched_calc_wakeup - calculate RL profile wakeup parameter
+ * @hw: pointer to the HW struct
  * @bw: bandwidth in Kbps
  *
  * This function calculates the wakeup parameter of RL profile.
  */
-static u16 ice_sched_calc_wakeup(s32 bw)
+static u16 ice_sched_calc_wakeup(struct ice_hw *hw, s32 bw)
 {
 	s64 bytes_per_sec, wakeup_int, wakeup_a, wakeup_b, wakeup_f;
 	s32 wakeup_f_int;
@@ -2868,7 +2909,7 @@ static u16 ice_sched_calc_wakeup(s32 bw)
 
 	/* Get the wakeup integer value */
 	bytes_per_sec = div64_long(((s64)bw * 1000), BITS_PER_BYTE);
-	wakeup_int = div64_long(ICE_RL_PROF_FREQUENCY, bytes_per_sec);
+	wakeup_int = div64_long(hw->psm_clk_freq, bytes_per_sec);
 	if (wakeup_int > 63) {
 		wakeup = (u16)((1 << 15) | wakeup_int);
 	} else {
@@ -2877,8 +2918,7 @@ static u16 ice_sched_calc_wakeup(s32 bw)
 		 */
 		wakeup_b = (s64)ICE_RL_PROF_MULTIPLIER * wakeup_int;
 		wakeup_a = div64_long((s64)ICE_RL_PROF_MULTIPLIER *
-					   ICE_RL_PROF_FREQUENCY,
-				      bytes_per_sec);
+					   hw->psm_clk_freq, bytes_per_sec);
 
 		/* Get Fraction value */
 		wakeup_f = wakeup_a - wakeup_b;
@@ -2898,13 +2938,15 @@ static u16 ice_sched_calc_wakeup(s32 bw)
 
 /**
  * ice_sched_bw_to_rl_profile - convert BW to profile parameters
+ * @hw: pointer to the HW struct
  * @bw: bandwidth in Kbps
  * @profile: profile parameters to return
  *
  * This function converts the BW to profile structure format.
  */
 static enum ice_status
-ice_sched_bw_to_rl_profile(u32 bw, struct ice_aqc_rl_profile_elem *profile)
+ice_sched_bw_to_rl_profile(struct ice_hw *hw, u32 bw,
+			   struct ice_aqc_rl_profile_elem *profile)
 {
 	enum ice_status status = ICE_ERR_PARAM;
 	s64 bytes_per_sec, ts_rate, mv_tmp;
@@ -2924,7 +2966,7 @@ ice_sched_bw_to_rl_profile(u32 bw, struct ice_aqc_rl_profile_elem *profile)
 	for (i = 0; i < 64; i++) {
 		u64 pow_result = BIT_ULL(i);
 
-		ts_rate = div64_long((s64)ICE_RL_PROF_FREQUENCY,
+		ts_rate = div64_long((s64)hw->psm_clk_freq,
 				     pow_result * ICE_RL_PROF_TS_MULTIPLIER);
 		if (ts_rate <= 0)
 			continue;
@@ -2948,7 +2990,7 @@ ice_sched_bw_to_rl_profile(u32 bw, struct ice_aqc_rl_profile_elem *profile)
 	if (found) {
 		u16 wm;
 
-		wm = ice_sched_calc_wakeup(bw);
+		wm = ice_sched_calc_wakeup(hw, bw);
 		profile->rl_multiply = cpu_to_le16(mv);
 		profile->wake_up_calc = cpu_to_le16(wm);
 		profile->rl_encode = cpu_to_le16(encode);
@@ -3017,7 +3059,7 @@ ice_sched_add_rl_profile(struct ice_port_info *pi,
 	if (!rl_prof_elem)
 		return NULL;
 
-	status = ice_sched_bw_to_rl_profile(bw, &rl_prof_elem->profile);
+	status = ice_sched_bw_to_rl_profile(hw, bw, &rl_prof_elem->profile);
 	if (status)
 		goto exit_add_rl_prof;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 8abc9e63e58d..9beef8f0ec76 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -24,12 +24,16 @@
 	((BIT(11) - 1) * 64) /* In Bytes */
 #define ICE_MAX_BURST_SIZE_KBYTE_GRANULARITY	ICE_MAX_BURST_SIZE_ALLOWED
 
-#define ICE_RL_PROF_FREQUENCY 446000000
 #define ICE_RL_PROF_ACCURACY_BYTES 128
 #define ICE_RL_PROF_MULTIPLIER 10000
 #define ICE_RL_PROF_TS_MULTIPLIER 32
 #define ICE_RL_PROF_FRACTION 512
 
+#define ICE_PSM_CLK_367MHZ_IN_HZ 367647059
+#define ICE_PSM_CLK_416MHZ_IN_HZ 416666667
+#define ICE_PSM_CLK_446MHZ_IN_HZ 446428571
+#define ICE_PSM_CLK_390MHZ_IN_HZ 390625000
+
 /* BW rate limit profile parameters list entry along
  * with bandwidth maintained per layer in port info
  */
@@ -65,6 +69,8 @@ ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
 			 u16 *elems_ret, struct ice_sq_cd *cd);
 enum ice_status ice_sched_init_port(struct ice_port_info *pi);
 enum ice_status ice_sched_query_res_alloc(struct ice_hw *hw);
+void ice_sched_get_psm_clk_freq(struct ice_hw *hw);
+
 void ice_sched_clear_port(struct ice_port_info *pi);
 void ice_sched_cleanup_all(struct ice_hw *hw);
 void ice_sched_clear_agg(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 45f735d6ab72..91b7b9d1bc7f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -618,6 +618,8 @@ struct ice_hw {
 	void *back;
 	struct ice_aqc_layer_props *layer_info;
 	struct ice_port_info *port_info;
+	/* PSM clock frequency for calculating RL profile params */
+	u32 psm_clk_freq;
 	u64 debug_mask;		/* bitmap for debug mask */
 	enum ice_mac_type mac_type;
 
-- 
2.26.2

