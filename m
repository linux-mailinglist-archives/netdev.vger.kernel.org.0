Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6E59FABD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfH1GoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:35206 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfH1GoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443809"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] i40e: fix hw_dbg usage in i40e_hmc_get_object_va
Date:   Tue, 27 Aug 2019 23:44:02 -0700
Message-Id: <20190828064407.30168-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

The mentioned function references a i40e_hw attribute, as parameter for
hw_dbg, but it doesn't exist in the function scope.
Fixes it by changing parameters from i40e_hmc_info to i40e_hw which can
retrieve the necessary i40e_hmc_info.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
index 994011c38fb4..f059de33a0fd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include "i40e.h"
 #include "i40e_osdep.h"
 #include "i40e_register.h"
 #include "i40e_type.h"
@@ -963,7 +964,7 @@ static i40e_status i40e_set_hmc_context(u8 *context_bytes,
 
 /**
  * i40e_hmc_get_object_va - retrieves an object's virtual address
- * @hmc_info: pointer to i40e_hmc_info struct
+ * @hw: the hardware struct, from which we obtain the i40e_hmc_info pointer
  * @object_base: pointer to u64 to get the va
  * @rsrc_type: the hmc resource type
  * @obj_idx: hmc object index
@@ -972,7 +973,7 @@ static i40e_status i40e_set_hmc_context(u8 *context_bytes,
  * base pointer.  This function is used for LAN Queue contexts.
  **/
 static
-i40e_status i40e_hmc_get_object_va(struct i40e_hmc_info *hmc_info,
+i40e_status i40e_hmc_get_object_va(struct i40e_hw *hw,
 					u8 **object_base,
 					enum i40e_hmc_lan_rsrc_type rsrc_type,
 					u32 obj_idx)
@@ -982,6 +983,7 @@ i40e_status i40e_hmc_get_object_va(struct i40e_hmc_info *hmc_info,
 	struct i40e_hmc_sd_entry *sd_entry;
 	struct i40e_hmc_pd_entry *pd_entry;
 	u32 pd_idx, pd_lmt, rel_pd_idx;
+	struct i40e_hmc_info *hmc_info = &hw->hmc;
 	u64 obj_offset_in_fpm;
 	u32 sd_idx, sd_lmt;
 
@@ -1047,7 +1049,7 @@ i40e_status i40e_clear_lan_tx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_TX, queue);
 	if (err < 0)
 		return err;
@@ -1068,7 +1070,7 @@ i40e_status i40e_set_lan_tx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_TX, queue);
 	if (err < 0)
 		return err;
@@ -1088,7 +1090,7 @@ i40e_status i40e_clear_lan_rx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_RX, queue);
 	if (err < 0)
 		return err;
@@ -1109,7 +1111,7 @@ i40e_status i40e_set_lan_rx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_RX, queue);
 	if (err < 0)
 		return err;
-- 
2.21.0

