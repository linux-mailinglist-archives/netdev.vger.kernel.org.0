Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F0931B326
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhBNXFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:05:54 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45548 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230162AbhBNXFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:05:52 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 705767A28;
        Sun, 14 Feb 2021 15:05:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 705767A28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=hEBp1gPGTlNdpsll5mqloVuS96AUHVriwZN+1hu0rVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h11xmV4qe7xFZbTOJpA3Vfi0ms3rvUUhNuGqHI9cyjyC990Bf6E7HOHlUsNpFPyeK
         M8EwLP9vpSzgU2qVSrMn4VALZt6yhBPDWtSVfXURDSiX/ZBnSs5nBOUuxOqbHAU+6t
         7l+flKCYz70YLeHpmep0CTqIxL72yM9latv7kCKE=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 3/7] bnxt_en: Implement faster recovery for firmware fatal error.
Date:   Sun, 14 Feb 2021 18:04:57 -0500
Message-Id: <1613343901-6629-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During some fatal firmware error conditions, the PCI config space
register 0x2e which normally contains the subsystem ID will become
0xffff.  This register will revert back to the normal value after
the chip has completed core reset.  If we detect this condition,
we can poll this config register immediately for the value to revert.
Because we use config read cycles to poll this register, there is no
possibility of Master Abort if we happen to read it during core reset.
This speeds up recovery significantly as we don't have to wait for the
conservative min_time before polling MMIO to see if the firmware has
come out of reset.  As soon as this register changes value we can
proceed to re-initialize the device.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7512879a551a..f2cf89d61eb2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10935,6 +10935,11 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 	 * kernel memory.
 	 */
 	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
+		u16 val = 0;
+
+		pci_read_config_word(bp->pdev, PCI_SUBSYSTEM_ID, &val);
+		if (val == 0xffff)
+			bp->fw_reset_min_dsecs = 0;
 		bnxt_tx_disable(bp);
 		bnxt_disable_napi(bp);
 		bnxt_disable_int_sync(bp);
@@ -11620,6 +11625,20 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
 			u32 val;
 
+			if (!bp->fw_reset_min_dsecs) {
+				u16 val;
+
+				pci_read_config_word(bp->pdev, PCI_SUBSYSTEM_ID,
+						     &val);
+				if (val == 0xffff) {
+					if (bnxt_fw_reset_timeout(bp)) {
+						netdev_err(bp->dev, "Firmware reset aborted, PCI config space invalid\n");
+						goto fw_reset_abort;
+					}
+					bnxt_queue_fw_reset_work(bp, HZ / 1000);
+					return;
+				}
+			}
 			val = bnxt_fw_health_readl(bp,
 						   BNXT_FW_RESET_INPROG_REG);
 			if (val)
-- 
2.18.1

