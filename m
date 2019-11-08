Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922B4F45EC
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbfKHLib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732645AbfKHLi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA0F21D7E;
        Fri,  8 Nov 2019 11:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213109;
        bh=XNLzB284cpGHfHfz5gqLU1Vm8NUPYzDzyp/DCxDsOQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLu/GYzTjVEHsqV6+Ur3OldF8NQbcLmdQJWRic9UE4DHYczNAmFeJZbYqspkjQUo0
         jssRGJRwCLNtkIq3EiqOfHZa4GEr+QNbNhFv9xZjD5Iy1+SKbYWb9o/imCB5M45z2T
         7W1Zm4LZIp8nT93P1U0IB4HowcmRlsWnbu6WZkOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 031/205] ice: Prevent control queue operations during reset
Date:   Fri,  8 Nov 2019 06:34:58 -0500
Message-Id: <20191108113752.12502-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit fd2a981777d911b2e94cdec50779c85c58a0dec9 ]

Once reset is issued, the driver loses all control queue interfaces.
Exercising control queue operations during reset is incorrect and
may result in long timeouts.

This patch introduces a new field 'reset_ongoing' in the hw structure.
This is set to 1 by the core driver when it receives a reset interrupt.
ice_sq_send_cmd checks reset_ongoing before actually issuing the control
queue operation. If a reset is in progress, it returns a soft error code
(ICE_ERR_RESET_PENDING) to the caller. The caller may or may not have to
take any action based on this return. Once the driver knows that the
reset is done, it has to set reset_ongoing back to 0. This will allow
control queue operations to be posted to the hardware again.

This "bail out" logic was specifically added to ice_sq_send_cmd (which
is pretty low level function) so that we have one solution in one place
that applies to all types of control queues.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c |  3 ++
 drivers/net/ethernet/intel/ice/ice_main.c     | 34 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_status.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index e783976c401d8..89f18fe18fe36 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -814,6 +814,9 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	u16 retval = 0;
 	u32 val = 0;
 
+	/* if reset is in progress return a soft error */
+	if (hw->reset_ongoing)
+		return ICE_ERR_RESET_ONGOING;
 	mutex_lock(&cq->sq_lock);
 
 	cq->sq_last_status = ICE_AQ_RC_OK;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 875f97aba6e0d..e1f95e7a51393 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -535,10 +535,13 @@ static void ice_reset_subtask(struct ice_pf *pf)
 		ice_prepare_for_reset(pf);
 
 		/* make sure we are ready to rebuild */
-		if (ice_check_reset(&pf->hw))
+		if (ice_check_reset(&pf->hw)) {
 			set_bit(__ICE_RESET_FAILED, pf->state);
-		else
+		} else {
+			/* done with reset. start rebuild */
+			pf->hw.reset_ongoing = false;
 			ice_rebuild(pf);
+		}
 		clear_bit(__ICE_RESET_RECOVERY_PENDING, pf->state);
 		goto unlock;
 	}
@@ -1757,7 +1760,8 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		 * We also make note of which reset happened so that peer
 		 * devices/drivers can be informed.
 		 */
-		if (!test_bit(__ICE_RESET_RECOVERY_PENDING, pf->state)) {
+		if (!test_and_set_bit(__ICE_RESET_RECOVERY_PENDING,
+				      pf->state)) {
 			if (reset == ICE_RESET_CORER)
 				set_bit(__ICE_CORER_RECV, pf->state);
 			else if (reset == ICE_RESET_GLOBR)
@@ -1765,7 +1769,20 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 			else
 				set_bit(__ICE_EMPR_RECV, pf->state);
 
-			set_bit(__ICE_RESET_RECOVERY_PENDING, pf->state);
+			/* There are couple of different bits at play here.
+			 * hw->reset_ongoing indicates whether the hardware is
+			 * in reset. This is set to true when a reset interrupt
+			 * is received and set back to false after the driver
+			 * has determined that the hardware is out of reset.
+			 *
+			 * __ICE_RESET_RECOVERY_PENDING in pf->state indicates
+			 * that a post reset rebuild is required before the
+			 * driver is operational again. This is set above.
+			 *
+			 * As this is the start of the reset/rebuild cycle, set
+			 * both to indicate that.
+			 */
+			hw->reset_ongoing = true;
 		}
 	}
 
@@ -4188,7 +4205,14 @@ static int ice_vsi_stop_tx_rings(struct ice_vsi *vsi)
 	}
 	status = ice_dis_vsi_txq(vsi->port_info, vsi->num_txq, q_ids, q_teids,
 				 NULL);
-	if (status) {
+	/* if the disable queue command was exercised during an active reset
+	 * flow, ICE_ERR_RESET_ONGOING is returned. This is not an error as
+	 * the reset operation disables queues at the hardware level anyway.
+	 */
+	if (status == ICE_ERR_RESET_ONGOING) {
+		dev_dbg(&pf->pdev->dev,
+			"Reset in progress. LAN Tx queues already disabled\n");
+	} else if (status) {
 		dev_err(&pf->pdev->dev,
 			"Failed to disable LAN Tx queues, error: %d\n",
 			status);
diff --git a/drivers/net/ethernet/intel/ice/ice_status.h b/drivers/net/ethernet/intel/ice/ice_status.h
index 9a95c4ffd7d79..d2dae913d81e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_status.h
+++ b/drivers/net/ethernet/intel/ice/ice_status.h
@@ -20,6 +20,7 @@ enum ice_status {
 	ICE_ERR_ALREADY_EXISTS			= -14,
 	ICE_ERR_DOES_NOT_EXIST			= -15,
 	ICE_ERR_MAX_LIMIT			= -17,
+	ICE_ERR_RESET_ONGOING			= -18,
 	ICE_ERR_BUF_TOO_SHORT			= -52,
 	ICE_ERR_NVM_BLANK_MODE			= -53,
 	ICE_ERR_AQ_ERROR			= -100,
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a509fe5f1e543..5ca9d684429d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -293,6 +293,7 @@ struct ice_hw {
 	u8 sw_entry_point_layer;
 
 	u8 evb_veb;		/* true for VEB, false for VEPA */
+	u8 reset_ongoing;	/* true if hw is in reset, false otherwise */
 	struct ice_bus_info bus;
 	struct ice_nvm_info nvm;
 	struct ice_hw_dev_caps dev_caps;	/* device capabilities */
-- 
2.20.1

