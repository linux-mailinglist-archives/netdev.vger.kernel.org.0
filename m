Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE52235FEE3
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhDOA3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:27428 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhDOA2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:50 -0400
IronPort-SDR: 1SqIG/KZ9QhzV3ggpbcUGguMZRSF1kkSt/TArzXi9awruoO0fkP/vub17rbdhqUi1j7G08yPng
 I7hKFiWeAHDA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262248"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262248"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:27 -0700
IronPort-SDR: UhKiIiJTUlNdZ5OmyDspnTz8LanaGUx5BPRulkG6xAQTOAAFBX/0y3kqo5s7B7MXMbQN7mdIYe
 agPUOvfGAuyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379514"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 06/15] ice: manage interrupts during poll exit
Date:   Wed, 14 Apr 2021 17:30:04 -0700
Message-Id: <20210415003013.19717-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver would occasionally miss that there were outstanding
descriptors to clean when exiting busy/napi poll. This issue has
been in the code since the introduction of the ice driver.

Attempt to "catch" any remaining work by triggering a software
interrupt when exiting napi poll or busy-poll. This will not
cause extra interrupts in the case of normal execution.

This issue was found when running sfnt-pingpong, with busy
poll enabled, and typically with larger I/O sizes like > 8192,
the program would occasionally report > 1 second maximums
to complete a ping pong.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c       | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 67b5b9b9d009..de38a0fc9665 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -130,6 +130,7 @@
 #define GLINT_DYN_CTL_ITR_INDX_M		ICE_M(0x3, 3)
 #define GLINT_DYN_CTL_INTERVAL_S		5
 #define GLINT_DYN_CTL_INTERVAL_M		ICE_M(0xFFF, 5)
+#define GLINT_DYN_CTL_SW_ITR_INDX_ENA_M		BIT(24)
 #define GLINT_DYN_CTL_SW_ITR_INDX_M		ICE_M(0x3, 25)
 #define GLINT_DYN_CTL_WB_ON_ITR_M		BIT(30)
 #define GLINT_DYN_CTL_INTENA_MSK_M		BIT(31)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 97c3efb932dc..1ce9ad02477d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1302,6 +1302,7 @@ static u32 ice_buildreg_itr(u16 itr_idx, u16 itr)
 static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 {
 	struct ice_vsi *vsi = q_vector->vsi;
+	bool wb_en = q_vector->wb_on_itr;
 	u32 itr_val;
 
 	if (test_bit(ICE_DOWN, vsi->state))
@@ -1310,7 +1311,7 @@ static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 	/* When exiting WB_ON_ITR, let ITR resume its normal
 	 * interrupts-enabled path.
 	 */
-	if (q_vector->wb_on_itr)
+	if (wb_en)
 		q_vector->wb_on_itr = false;
 
 	/* This will do nothing if dynamic updates are not enabled. */
@@ -1318,6 +1319,16 @@ static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 
 	/* net_dim() updates ITR out-of-band using a work item */
 	itr_val = ice_buildreg_itr(ICE_ITR_NONE, 0);
+	/* trigger an immediate software interrupt when exiting
+	 * busy poll, to make sure to catch any pending cleanups
+	 * that might have been missed due to interrupt state
+	 * transition.
+	 */
+	if (wb_en) {
+		itr_val |= GLINT_DYN_CTL_SWINT_TRIG_M |
+			   GLINT_DYN_CTL_SW_ITR_INDX_M |
+			   GLINT_DYN_CTL_SW_ITR_INDX_ENA_M;
+	}
 	wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
 }
 
-- 
2.26.2

