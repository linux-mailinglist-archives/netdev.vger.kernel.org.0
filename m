Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39E3343A44
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhCVHJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:15 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:54906 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229875AbhCVHIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:47 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B20427DDA;
        Mon, 22 Mar 2021 00:08:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B20427DDA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396927;
        bh=aEfge/6x8uPvSCEUhej9zmV3y90Jb84GSTFdlZjAmHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnl+NZFH8/51W0eYItmpR2hcAgwiaI2T9l5ulXX+kbvajmD3Llxq8F3Z33e2k50+5
         54z5emVuh7fJ09gj4k75mOc551Z06bsL538peDmdCJELEVgmY4yFGy0y+9DSyI8Aud
         UAOQOWE5swWt8W1GHuCsDUjTcddRl2/no6dHf/as=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/7] bnxt_en: Improve the status_reliable flag in bp->fw_health.
Date:   Mon, 22 Mar 2021 03:08:39 -0400
Message-Id: <1616396925-16596-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to read the firmware health status, we first need to determine
the register location and then the register may need to be mapped.
There are 2 code paths to do this.  The first one is done early as a
best effort attempt by the function bnxt_try_map_fw_health_reg().  The
second one is done later in the function bnxt_map_fw_health_regs()
after establishing communications with the firmware.  We currently
only set fw_health->status_reliable if we can successfully set up the
health register in the first code path.

Improve the scheme by setting the fw_health->status_reliable flag if
either (or both) code paths can successfully set up the health
register.  This flag is relied upon during run-time when we need to
check the health status.  So this will make it work better.

During ifdown, if the health register is mapped, we need to invalidate
the health register mapping because a potential fw reset will reset
the mapping.  Similarly, we need to do the same after firmware reset
during recovery.  We'll remap it during ifup.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 31 +++++++++++++++++++----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b53a0d87371a..16cf18eb7b3d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7540,6 +7540,19 @@ static void __bnxt_map_fw_health_reg(struct bnxt *bp, u32 reg)
 					 BNXT_FW_HEALTH_WIN_MAP_OFF);
 }
 
+static void bnxt_inv_fw_health_reg(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 reg_type;
+
+	if (!fw_health || !fw_health->status_reliable)
+		return;
+
+	reg_type = BNXT_FW_HEALTH_REG_TYPE(fw_health->regs[BNXT_FW_HEALTH_REG]);
+	if (reg_type == BNXT_FW_HEALTH_REG_TYPE_GRC)
+		fw_health->status_reliable = false;
+}
+
 static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
 {
 	void __iomem *hs;
@@ -7547,6 +7560,9 @@ static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
 	u32 reg_type;
 	u32 sig;
 
+	if (bp->fw_health)
+		bp->fw_health->status_reliable = false;
+
 	__bnxt_map_fw_health_reg(bp, HCOMM_STATUS_STRUCT_LOC);
 	hs = bp->bar0 + BNXT_FW_HEALTH_WIN_OFF(HCOMM_STATUS_STRUCT_LOC);
 
@@ -7558,11 +7574,9 @@ static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
 					     BNXT_FW_HEALTH_WIN_BASE +
 					     BNXT_GRC_REG_CHIP_NUM);
 		}
-		if (!BNXT_CHIP_P5(bp)) {
-			if (bp->fw_health)
-				bp->fw_health->status_reliable = false;
+		if (!BNXT_CHIP_P5(bp))
 			return;
-		}
+
 		status_loc = BNXT_GRC_REG_STATUS_P5 |
 			     BNXT_FW_HEALTH_REG_TYPE_BAR0;
 	} else {
@@ -7592,6 +7606,7 @@ static int bnxt_map_fw_health_regs(struct bnxt *bp)
 	u32 reg_base = 0xffffffff;
 	int i;
 
+	bp->fw_health->status_reliable = false;
 	/* Only pre-map the monitoring GRC registers using window 3 */
 	for (i = 0; i < 4; i++) {
 		u32 reg = fw_health->regs[i];
@@ -7604,6 +7619,7 @@ static int bnxt_map_fw_health_regs(struct bnxt *bp)
 			return -ERANGE;
 		fw_health->mapped_regs[i] = BNXT_FW_HEALTH_WIN_OFF(reg);
 	}
+	bp->fw_health->status_reliable = true;
 	if (reg_base == 0xffffffff)
 		return 0;
 
@@ -9556,13 +9572,17 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	if (rc)
 		return rc;
 
-	if (!up)
+	if (!up) {
+		bnxt_inv_fw_health_reg(bp);
 		return 0;
+	}
 
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_RESC_CHANGE)
 		resc_reinit = true;
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
 		fw_reset = true;
+	else if (bp->fw_health && !bp->fw_health->status_reliable)
+		bnxt_try_map_fw_health_reg(bp);
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) && !fw_reset) {
 		netdev_err(bp->dev, "RESET_DONE not set during FW reset.\n");
@@ -11723,6 +11743,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
+		bnxt_inv_fw_health_reg(bp);
 		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
 			u32 val;
 
-- 
2.18.1

