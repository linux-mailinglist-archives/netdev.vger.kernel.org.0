Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874B7343A46
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCVHJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:17 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:54918 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhCVHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:50 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 3F33F80F0;
        Mon, 22 Mar 2021 00:08:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3F33F80F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396929;
        bh=lrrDoA8VwNVMeu4htzRf3Cq6F7DwvH8Xx7acpUUjJKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTMLQgQf6Vtd7rCCpNTT6ywOwH1fGLsmztlyC+AdF9iBzlON0zKWcXYBUhynTueQi
         cL1W8aYc3JN0ww3XfKp5alf9ibRW7kGp66BGUDdZOz+GSwFg4IPynH5/bOpOq48CNk
         hpWZtfX2ve3o8UyIHHn51h50MtTP/kVrGMRQEWIY=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 5/7] bnxt_en: Set BNXT_STATE_FW_RESET_DET flag earlier for the RDMA driver.
Date:   Mon, 22 Mar 2021 03:08:43 -0400
Message-Id: <1616396925-16596-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During ifup, if the driver detects that firmware has gone through a
reset, it will go through a re-probe sequence.  If the RDMA driver is
loaded, the re-probe sequence includes calling the RDMA driver to stop.
We need to set the BNXT_STATE_FW_RESET_DET flag earlier so that it is
visible to the RDMA driver.  The RDMA driver's stop sequence is
different if firmware has gone through a reset.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: P B S Naresh Kumar <nareshkumar.pbs@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7f40dd7d847d..edbe5982cf41 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9611,6 +9611,7 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	}
 	if (resc_reinit || fw_reset) {
 		if (fw_reset) {
+			set_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
 			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 				bnxt_ulp_stop(bp);
 			bnxt_free_ctx_mem(bp);
@@ -9619,16 +9620,17 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 			bnxt_dcb_free(bp);
 			rc = bnxt_fw_init_one(bp);
 			if (rc) {
+				clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
 				return rc;
 			}
 			bnxt_clear_int_mode(bp);
 			rc = bnxt_init_int_mode(bp);
 			if (rc) {
+				clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
 				netdev_err(bp->dev, "init int mode failed\n");
 				return rc;
 			}
-			set_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
 		}
 		if (BNXT_NEW_RM(bp)) {
 			struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-- 
2.18.1

