Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC218302286
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbhAYHna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:43:30 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33584 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727221AbhAYHUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:20:40 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 1B0F080F5;
        Sun, 24 Jan 2021 23:08:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 1B0F080F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558504;
        bh=K40O4k5HjQw55d1yHGE6XCcdG+22ODoapSiZ/o3GHUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJVLXod3l5/dizt9ZC4BT+MRTHLOocDpsJcASrO/y/4pVqjBDEnJGLdaSfH/wD807
         Nbgmb1mX+75Dn2J+TLPZVc8CfWyDpT6W4mUPynEAst3js0Tah+2Au4H5ujvYcgEyYh
         jSnNH90fJWdjc/g598EGaz4mkuAcYo9vU4bKtr7k=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 13/15] bnxt_en: Improve firmware fatal error shutdown sequence.
Date:   Mon, 25 Jan 2021 02:08:19 -0500
Message-Id: <1611558501-11022-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the event of a fatal firmware error, firmware will notify the host
and then it will proceed to do core reset when it sees that all functions
have disabled Bus Master.  To prevent Master Aborts and other hard
errors, we need to quiesce all activities in addition to disabling Bus
Master before the chip goes into core reset.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 80dab4e622ab..e7abb3b7ed68 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10905,11 +10905,18 @@ static void bnxt_rx_ring_reset(struct bnxt *bp)
 static void bnxt_fw_reset_close(struct bnxt *bp)
 {
 	bnxt_ulp_stop(bp);
-	/* When firmware is fatal state, disable PCI device to prevent
-	 * any potential bad DMAs before freeing kernel memory.
+	/* When firmware is in fatal state, quiesce device and disable
+	 * bus master to prevent any potential bad DMAs before freeing
+	 * kernel memory.
 	 */
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
+		bnxt_tx_disable(bp);
+		bnxt_disable_napi(bp);
+		bnxt_disable_int_sync(bp);
+		bnxt_free_irq(bp);
+		bnxt_clear_int_mode(bp);
 		pci_disable_device(bp->pdev);
+	}
 	__bnxt_close_nic(bp, true, false);
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);
-- 
2.18.1

