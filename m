Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE839433E78
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhJSSea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:34:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:51642 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233944AbhJSSea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:34:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="226058560"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="226058560"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 11:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="444602710"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2021 11:32:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 04/10] ice: fix software generating extra interrupts
Date:   Tue, 19 Oct 2021 11:30:21 -0700
Message-Id: <20211019183027.2820413-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
References: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver tried to work around missing completion events that occurred
while interrupts are disabled, by triggering a software interrupt
whenever we exit polling (but we had to have polled at least once).

This was causing a *lot* of extra interrupts for some workloads like
NVMe over TCP, which resulted in regressions in performance. It was also
visible when polling didn't prevent interrupts when busy_poll was
enabled.

Fix the extra interrupts by utilizing our previously unused 3rd ITR
(interrupt throttle) index and set it to 20K interrupts per second, and
then trigger a software interrupt within that rate limit.

While here, slightly refactor the code to avoid an overwrite of a local
variable in the case of wb_en = true.

Fixes: b7306b42beaf ("ice: manage interrupts during poll exit")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 26 +++++++++++--------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 76021d977b60..a49082485642 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -182,6 +182,7 @@
 #define GLINT_DYN_CTL_INTERVAL_S		5
 #define GLINT_DYN_CTL_INTERVAL_M		ICE_M(0xFFF, 5)
 #define GLINT_DYN_CTL_SW_ITR_INDX_ENA_M		BIT(24)
+#define GLINT_DYN_CTL_SW_ITR_INDX_S		25
 #define GLINT_DYN_CTL_SW_ITR_INDX_M		ICE_M(0x3, 25)
 #define GLINT_DYN_CTL_WB_ON_ITR_M		BIT(30)
 #define GLINT_DYN_CTL_INTENA_MSK_M		BIT(31)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1373b97b117a..8f908af9bdd5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1361,21 +1361,25 @@ static void ice_enable_interrupt(struct ice_q_vector *q_vector)
 	if (test_bit(ICE_DOWN, vsi->state))
 		return;
 
-	/* When exiting WB_ON_ITR, let ITR resume its normal
-	 * interrupts-enabled path.
+	/* trigger an ITR delayed software interrupt when exiting busy poll, to
+	 * make sure to catch any pending cleanups that might have been missed
+	 * due to interrupt state transition. If busy poll or poll isn't
+	 * enabled, then don't update ITR, and just enable the interrupt.
 	 */
-	if (wb_en)
+	if (!wb_en) {
+		itr_val = ice_buildreg_itr(ICE_ITR_NONE, 0);
+	} else {
 		q_vector->wb_on_itr = false;
 
-	itr_val = ice_buildreg_itr(ICE_ITR_NONE, 0);
-	/* trigger an immediate software interrupt when exiting
-	 * busy poll, to make sure to catch any pending cleanups
-	 * that might have been missed due to interrupt state
-	 * transition.
-	 */
-	if (wb_en) {
+		/* do two things here with a single write. Set up the third ITR
+		 * index to be used for software interrupt moderation, and then
+		 * trigger a software interrupt with a rate limit of 20K on
+		 * software interrupts, this will help avoid high interrupt
+		 * loads due to frequently polling and exiting polling.
+		 */
+		itr_val = ice_buildreg_itr(ICE_IDX_ITR2, ICE_ITR_20K);
 		itr_val |= GLINT_DYN_CTL_SWINT_TRIG_M |
-			   GLINT_DYN_CTL_SW_ITR_INDX_M |
+			   ICE_IDX_ITR2 << GLINT_DYN_CTL_SW_ITR_INDX_S |
 			   GLINT_DYN_CTL_SW_ITR_INDX_ENA_M;
 	}
 	wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
-- 
2.31.1

