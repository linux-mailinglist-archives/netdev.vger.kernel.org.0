Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB6747C5DB
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbhLUSJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:9404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240933AbhLUSJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110146; x=1671646146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7nMDK9QrgPpeycNNYsj4NQNuAa8x5VuMbJxvOQ6Jls=;
  b=UlIz8mksygwrSE84WnAe4ffY4RjMTf+AtScNifNOtcD3+MpDUJYm/PnX
   vpO283kV1AYjPV2Xz0ridTByYgsUwx4aR7PxF1IklO5oJ7nxTz8VjVVqq
   N31QBztMcoyFA4jMpaeiQkPtZLCloEGUA324CRIDJ6soY+GdaKRBQ47Dh
   R2CisKm1EdyxL8SCE0NE1hR89MiNfj7lfQrQUzrGkXXwfQiTwGk0HzafB
   +DhJoOt6tT7++aoGpbtxqDBj9WhNckM3THY/jlY5rXbj0+MvO1TTaEaWE
   /oKQHNKeEt4UEXoUmKVSk5DFKYm7s2FKQrjiXtmUtJ7XIgHg5L7Z6id79
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264845"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264845"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342494"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 06/10] ice: convert clk_freq capability into time_ref
Date:   Tue, 21 Dec 2021 09:48:41 -0800
Message-Id: <20211221174845.3063640-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Convert the clk_freq value into the associated time_ref frequency value
for E822 devices. This simplifies determining the time reference value
for the clock.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 12 +++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h   | 23 ++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 157add1268d9..2a1ee60e85f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2189,6 +2189,18 @@ ice_parse_1588_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
 	info->clk_freq = (number & ICE_TS_CLK_FREQ_M) >> ICE_TS_CLK_FREQ_S;
 	info->clk_src = ((number & ICE_TS_CLK_SRC_M) != 0);
 
+	if (info->clk_freq < NUM_ICE_TIME_REF_FREQ) {
+		info->time_ref = (enum ice_time_ref_freq)info->clk_freq;
+	} else {
+		/* Unknown clock frequency, so assume a (probably incorrect)
+		 * default to avoid out-of-bounds look ups of frequency
+		 * related information.
+		 */
+		ice_debug(hw, ICE_DBG_INIT, "1588 func caps: unknown clock frequency %u\n",
+			  info->clk_freq);
+		info->time_ref = ICE_TIME_REF_FREQ_25_000;
+	}
+
 	ice_debug(hw, ICE_DBG_INIT, "func caps: ieee_1588 = %u\n",
 		  func_p->common_cap.ieee_1588);
 	ice_debug(hw, ICE_DBG_INIT, "func caps: src_tmr_owned = %u\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 58b1907e3ff1..caf0a02b25f5 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -298,9 +298,30 @@ struct ice_hw_common_caps {
 #define ICE_TS_TMR_IDX_ASSOC_S		24
 #define ICE_TS_TMR_IDX_ASSOC_M		BIT(24)
 
+/* TIME_REF clock rate specification */
+enum ice_time_ref_freq {
+	ICE_TIME_REF_FREQ_25_000	= 0,
+	ICE_TIME_REF_FREQ_122_880	= 1,
+	ICE_TIME_REF_FREQ_125_000	= 2,
+	ICE_TIME_REF_FREQ_153_600	= 3,
+	ICE_TIME_REF_FREQ_156_250	= 4,
+	ICE_TIME_REF_FREQ_245_760	= 5,
+
+	NUM_ICE_TIME_REF_FREQ
+};
+
+/* Clock source specification */
+enum ice_clk_src {
+	ICE_CLK_SRC_TCX0	= 0, /* Temperature compensated oscillator  */
+	ICE_CLK_SRC_TIME_REF	= 1, /* Use TIME_REF reference clock */
+
+	NUM_ICE_CLK_SRC
+};
+
 struct ice_ts_func_info {
 	/* Function specific info */
-	u32 clk_freq;
+	enum ice_time_ref_freq time_ref;
+	u8 clk_freq;
 	u8 clk_src;
 	u8 tmr_index_assoc;
 	u8 ena;
-- 
2.31.1

