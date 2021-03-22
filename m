Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F76343A42
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCVHJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:14 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:54912 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhCVHIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:48 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 594A37DAF;
        Mon, 22 Mar 2021 00:08:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 594A37DAF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396927;
        bh=GWTf1/lVsxpf7OWEdyzaDlqIox9Y9+bxbIqpJzskGxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPYIM3xyiWDVqfd1JEF322Fy8Oqq/wxfCJ7l46mm00heeNsbXeVuPH1Fc6Ny0TCsK
         V/W+loNCuKYorBbY+YWFdwc0//mwfRsJeNGXkmU/3K1Mn1P0LEu7nlOk6mV2etCKfl
         HIuGjvVBdtLFEXVN6XTzCThfnlBhwPjLrHrGqllQ=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 2/7] bnxt_en: Improve wait for firmware commands completion
Date:   Mon, 22 Mar 2021 03:08:40 -0400
Message-Id: <1616396925-16596-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

In situations where FW has crashed, the bnxt_hwrm_do_send_msg() call
will have to wait until timeout for each firmware message.  This
generally takes about half a second for each firmware message.  If we
try to unload the driver n this state, the unload sequence will take
a long time to complete.

Improve this by checking the health register if it is available and
abort the wait for the firmware response if the register shows that
firmware is not healthy.  The very first message HWRM_VER_GET is
excluded from this check because that message is used to poll for
firmware to come out of reset during error recovery.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 28 +++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  5 ++++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 16cf18eb7b3d..deba552465f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4500,12 +4500,15 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
 				return -EBUSY;
 			/* on first few passes, just barely sleep */
-			if (i < HWRM_SHORT_TIMEOUT_COUNTER)
+			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
 					     HWRM_SHORT_MAX_TIMEOUT);
-			else
+			} else {
+				if (HWRM_WAIT_MUST_ABORT(bp, req))
+					break;
 				usleep_range(HWRM_MIN_TIMEOUT,
 					     HWRM_MAX_TIMEOUT);
+			}
 		}
 
 		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
@@ -4530,15 +4533,19 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 			if (len)
 				break;
 			/* on first few passes, just barely sleep */
-			if (i < HWRM_SHORT_TIMEOUT_COUNTER)
+			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
 					     HWRM_SHORT_MAX_TIMEOUT);
-			else
+			} else {
+				if (HWRM_WAIT_MUST_ABORT(bp, req))
+					goto timeout_abort;
 				usleep_range(HWRM_MIN_TIMEOUT,
 					     HWRM_MAX_TIMEOUT);
+			}
 		}
 
 		if (i >= tmo_count) {
+timeout_abort:
 			if (!silent)
 				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
 					   HWRM_TOTAL_TIMEOUT(i),
@@ -7540,6 +7547,19 @@ static void __bnxt_map_fw_health_reg(struct bnxt *bp, u32 reg)
 					 BNXT_FW_HEALTH_WIN_MAP_OFF);
 }
 
+bool bnxt_is_fw_healthy(struct bnxt *bp)
+{
+	if (bp->fw_health && bp->fw_health->status_reliable) {
+		u32 fw_status;
+
+		fw_status = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+		if (fw_status && !BNXT_FW_IS_HEALTHY(fw_status))
+			return false;
+	}
+
+	return true;
+}
+
 static void bnxt_inv_fw_health_reg(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1259e68cba2a..e77d60712954 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -671,6 +671,10 @@ struct nqe_cn {
 #define HWRM_MIN_TIMEOUT		25
 #define HWRM_MAX_TIMEOUT		40
 
+#define HWRM_WAIT_MUST_ABORT(bp, req)					\
+	(le16_to_cpu((req)->req_type) != HWRM_VER_GET &&		\
+	 !bnxt_is_fw_healthy(bp))
+
 #define HWRM_TOTAL_TIMEOUT(n)	(((n) <= HWRM_SHORT_TIMEOUT_COUNTER) ?	\
 	((n) * HWRM_SHORT_MIN_TIMEOUT) :				\
 	(HWRM_SHORT_TIMEOUT_COUNTER * HWRM_SHORT_MIN_TIMEOUT +		\
@@ -2228,6 +2232,7 @@ int bnxt_hwrm_set_link_setting(struct bnxt *, bool, bool);
 int bnxt_hwrm_alloc_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_free_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_func_resc_qcaps(struct bnxt *bp, bool all);
+bool bnxt_is_fw_healthy(struct bnxt *bp);
 int bnxt_hwrm_fw_set_time(struct bnxt *);
 int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
-- 
2.18.1

