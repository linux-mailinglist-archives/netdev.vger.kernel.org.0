Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0B6343A45
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhCVHJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:16 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:54918 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCVHIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:48 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id F3DD67FC9;
        Mon, 22 Mar 2021 00:08:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com F3DD67FC9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396928;
        bh=hSu17bZ8og9ruEf3zmHx05VWaArrk/1sIIaQpfTCl1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OImYte1kTJTCzy2EQzV79TiiGaTPNdvfmr3r1JbUVz78TOe6/uw4qA1i19qSyr4zs
         sjj6Bc/UTcXGFNkJxoew11i21BKgI+Ga1icEljD0hNXsdX0wKeZIGmEQb/MLrztEdA
         G3Bt9jZwXSkQBGwloADfBVkAmsEFlOBBVAnuzR2A=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 3/7] bnxt_en: don't fake firmware response success when PCI is disabled
Date:   Mon, 22 Mar 2021 03:08:41 -0400
Message-Id: <1616396925-16596-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The original intent here is to allow commands during reset to succeed
without error when the device is disabled, to ensure that cleanup
completes normally during NIC close, where firmware is not necessarily
expected to respond.

The problem with faking success during reset's PCI disablement is that
unrelated ULP commands will also see inadvertent success during reset
when failure would otherwise be appropriate. It is better to return
a different error result such that reset related code can detect
this unique condition and ignore as appropriate.

Note, the pci_disable_device() when firmware is fatally wounded in
bnxt_fw_reset_close() does not need to be addressed, as subsequent
commands are already expected to fail due to the BNXT_NO_FW_ACCESS()
check in bnxt_hwrm_do_send_msg().

Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index deba552465f6..3624e79667b6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4470,7 +4470,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	writel(1, bp->bar0 + doorbell_offset);
 
 	if (!pci_is_enabled(bp->pdev))
-		return 0;
+		return -ENODEV;
 
 	if (!timeout)
 		timeout = DFLT_HWRM_CMD_TIMEOUT;
@@ -11680,7 +11680,7 @@ static void bnxt_reset_all(struct bnxt *bp)
 		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
 		req.flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
 		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-		if (rc)
+		if (rc != -ENODEV)
 			netdev_warn(bp->dev, "Unable to reset FW rc=%d\n", rc);
 	}
 	bp->fw_reset_timestamp = jiffies;
-- 
2.18.1

