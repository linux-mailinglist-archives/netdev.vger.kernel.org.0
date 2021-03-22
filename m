Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B137343A49
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCVHJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:23 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:54940 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhCVHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:50 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D95882182A;
        Mon, 22 Mar 2021 00:08:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D95882182A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396930;
        bh=hmM2RQZuIuh4JRBgaPQSghYCR7SG5UO3tKoCszR6E4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crhCTSSdrW1sjZNZDId5uj6Sr8kh6OBTxDasT6sSfczbil68aJ9ihgLJBnu99nKwC
         evPJDJo7Fzq056d1zUfje/gvQF2YqmC8lLUlvncnFEdUWm+UBbUr3KgBISRNdC3zJ5
         3zAcLTMkqbMxE9yB32rJ+zDjwJwszBiecrL1IvgY=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 6/7] bnxt_en: Remove the read of BNXT_FW_RESET_INPROG_REG after firmware reset.
Date:   Mon, 22 Mar 2021 03:08:44 -0400
Message-Id: <1616396925-16596-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Once the chip goes through reset, the register mapping may be lost
and any read of the mapped health registers may return garbage value
until the registers are mapped again in the init path.

Reading BNXT_FW_RESET_INPROG_REG after firmware reset will likely
return garbage value due to the above reason.  Reading this register
is for information purpose only so remove it.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 31 ++++++++---------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index edbe5982cf41..6db5e927a473 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11769,28 +11769,19 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		return;
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
 		bnxt_inv_fw_health_reg(bp);
-		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
-			u32 val;
-
-			if (!bp->fw_reset_min_dsecs) {
-				u16 val;
-
-				pci_read_config_word(bp->pdev, PCI_SUBSYSTEM_ID,
-						     &val);
-				if (val == 0xffff) {
-					if (bnxt_fw_reset_timeout(bp)) {
-						netdev_err(bp->dev, "Firmware reset aborted, PCI config space invalid\n");
-						goto fw_reset_abort;
-					}
-					bnxt_queue_fw_reset_work(bp, HZ / 1000);
-					return;
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) &&
+		    !bp->fw_reset_min_dsecs) {
+			u16 val;
+
+			pci_read_config_word(bp->pdev, PCI_SUBSYSTEM_ID, &val);
+			if (val == 0xffff) {
+				if (bnxt_fw_reset_timeout(bp)) {
+					netdev_err(bp->dev, "Firmware reset aborted, PCI config space invalid\n");
+					goto fw_reset_abort;
 				}
+				bnxt_queue_fw_reset_work(bp, HZ / 1000);
+				return;
 			}
-			val = bnxt_fw_health_readl(bp,
-						   BNXT_FW_RESET_INPROG_REG);
-			if (val)
-				netdev_warn(bp->dev, "FW reset inprog %x after min wait time.\n",
-					    val);
 		}
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
-- 
2.18.1

