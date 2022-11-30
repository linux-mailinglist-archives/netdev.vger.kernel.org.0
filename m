Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A634063E0E9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiK3Tnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiK3Tno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F43493A4E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837423; x=1701373423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KEtX6Wnp7c/y/Tcf1Fr8BJtAB6vbMi6OrKDQXqpk4ls=;
  b=JUd7NL+5eU1+FPz0RtHr3f5MqV21zIoiKhMqXnF0BF7xqcDjCpEslxS5
   v6aBIgl83pSUV7eoqyi7RTDP4/7srGi7TPDAM1ZS6U07G0sigt4LAMkDz
   39Q0RKGX/OXseg7oo39sqht9QZeuVr095JWFlDKJPDMLqvq4dr3y8wr6v
   zfmG+vtaQBedkOOiw+I1JnHh43lm72nXV2XJBCnHdFKQBvCGlhUGlZuI3
   stEmKPynjXROF2AIrYpAEyDgCarvehNbR7buNDpYVMJ6LGoVqbDaqOtmt
   gbOKa08JS9HthNgDzNLU/eCQ37IwiFkr5PzaTtvVgBSAvWRfdsaFUnNEy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098370"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098370"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752279"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752279"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 03/14] ice: Reset TS memory for all quads
Date:   Wed, 30 Nov 2022 11:43:19 -0800
Message-Id: <20221130194330.3257836-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

In E822 products, the owner PF should reset memory for all quads, not
only for the one where assigned lport is.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 29 ++--------------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 38 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |  2 ++
 3 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9539d2d37c5b..f93fa0273252 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1059,19 +1059,6 @@ static u64 ice_base_incval(struct ice_pf *pf)
 	return incval;
 }
 
-/**
- * ice_ptp_reset_ts_memory_quad - Reset timestamp memory for one quad
- * @pf: The PF private data structure
- * @quad: The quad (0-4)
- */
-static void ice_ptp_reset_ts_memory_quad(struct ice_pf *pf, int quad)
-{
-	struct ice_hw *hw = &pf->hw;
-
-	ice_write_quad_reg_e822(hw, quad, Q_REG_TS_CTRL, Q_REG_TS_CTRL_M);
-	ice_write_quad_reg_e822(hw, quad, Q_REG_TS_CTRL, ~(u32)Q_REG_TS_CTRL_M);
-}
-
 /**
  * ice_ptp_check_tx_fifo - Check whether Tx FIFO is in an OK state
  * @port: PTP port for which Tx FIFO is checked
@@ -1124,7 +1111,7 @@ static int ice_ptp_check_tx_fifo(struct ice_ptp_port *port)
 		dev_dbg(ice_pf_to_dev(pf),
 			"Port %d Tx FIFO still not empty; resetting quad %d\n",
 			port->port_num, quad);
-		ice_ptp_reset_ts_memory_quad(pf, quad);
+		ice_ptp_reset_ts_memory_quad_e822(hw, quad);
 		port->tx_fifo_busy_cnt = FIFO_OK;
 		return 0;
 	}
@@ -1370,18 +1357,6 @@ int ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
 	return ice_ptp_port_phy_restart(ptp_port);
 }
 
-/**
- * ice_ptp_reset_ts_memory - Reset timestamp memory for all quads
- * @pf: The PF private data structure
- */
-static void ice_ptp_reset_ts_memory(struct ice_pf *pf)
-{
-	int quad;
-
-	quad = pf->hw.port_info->lport / ICE_PORTS_PER_QUAD;
-	ice_ptp_reset_ts_memory_quad(pf, quad);
-}
-
 /**
  * ice_ptp_tx_ena_intr - Enable or disable the Tx timestamp interrupt
  * @pf: PF private structure
@@ -1397,7 +1372,7 @@ static int ice_ptp_tx_ena_intr(struct ice_pf *pf, bool ena, u32 threshold)
 	int quad;
 	u32 val;
 
-	ice_ptp_reset_ts_memory(pf);
+	ice_ptp_reset_ts_memory(hw);
 
 	for (quad = 0; quad < ICE_MAX_QUAD; quad++) {
 		err = ice_read_quad_reg_e822(hw, quad, Q_REG_TX_MEM_GBL_CFG,
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 242c4db65171..6c149b88c235 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -655,6 +655,32 @@ ice_clear_phy_tstamp_e822(struct ice_hw *hw, u8 quad, u8 idx)
 	return 0;
 }
 
+/**
+ * ice_ptp_reset_ts_memory_quad_e822 - Clear all timestamps from the quad block
+ * @hw: pointer to the HW struct
+ * @quad: the quad to read from
+ *
+ * Clear all timestamps from the PHY quad block that is shared between the
+ * internal PHYs on the E822 devices.
+ */
+void ice_ptp_reset_ts_memory_quad_e822(struct ice_hw *hw, u8 quad)
+{
+	ice_write_quad_reg_e822(hw, quad, Q_REG_TS_CTRL, Q_REG_TS_CTRL_M);
+	ice_write_quad_reg_e822(hw, quad, Q_REG_TS_CTRL, ~(u32)Q_REG_TS_CTRL_M);
+}
+
+/**
+ * ice_ptp_reset_ts_memory_e822 - Clear all timestamps from all quad blocks
+ * @hw: pointer to the HW struct
+ */
+static void ice_ptp_reset_ts_memory_e822(struct ice_hw *hw)
+{
+	unsigned int quad;
+
+	for (quad = 0; quad < ICE_MAX_QUAD; quad++)
+		ice_ptp_reset_ts_memory_quad_e822(hw, quad);
+}
+
 /**
  * ice_read_cgu_reg_e822 - Read a CGU register
  * @hw: pointer to the HW struct
@@ -3247,6 +3273,18 @@ bool ice_is_pca9575_present(struct ice_hw *hw)
 	return !status && handle;
 }
 
+/**
+ * ice_ptp_reset_ts_memory - Reset timestamp memory for all blocks
+ * @hw: pointer to the HW struct
+ */
+void ice_ptp_reset_ts_memory(struct ice_hw *hw)
+{
+	if (ice_is_e810(hw))
+		return;
+
+	ice_ptp_reset_ts_memory_e822(hw);
+}
+
 /**
  * ice_ptp_init_phc - Initialize PTP hardware clock
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index db4f57cb9ec9..b0cd73aaac6b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -133,6 +133,7 @@ int ice_ptp_write_incval_locked(struct ice_hw *hw, u64 incval);
 int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj);
 int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp);
 int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx);
+void ice_ptp_reset_ts_memory(struct ice_hw *hw);
 int ice_ptp_init_phc(struct ice_hw *hw);
 
 /* E822 family functions */
@@ -141,6 +142,7 @@ int ice_write_phy_reg_e822(struct ice_hw *hw, u8 port, u16 offset, u32 val);
 int ice_read_quad_reg_e822(struct ice_hw *hw, u8 quad, u16 offset, u32 *val);
 int ice_write_quad_reg_e822(struct ice_hw *hw, u8 quad, u16 offset, u32 val);
 int ice_ptp_prep_port_adj_e822(struct ice_hw *hw, u8 port, s64 time);
+void ice_ptp_reset_ts_memory_quad_e822(struct ice_hw *hw, u8 quad);
 
 /**
  * ice_e822_time_ref - Get the current TIME_REF from capabilities
-- 
2.35.1

