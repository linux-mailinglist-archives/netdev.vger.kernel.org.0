Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66EE302284
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbhAYHmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:42:39 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33568 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727208AbhAYHUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:20:40 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 908857DC5;
        Sun, 24 Jan 2021 23:08:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 908857DC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558502;
        bh=bUiy+zPCUYxmqywN6AB3sPmoRYCpg7U2j6RH2rBAZrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjRaQH3v7eDmZwWcxFLgU1KNtShHITB6LEq52sJcBb50gkoNtcguFgFgj7PZ2zruu
         VfBxVH5zBLgglqpD8fF7PFjtIb8Y8pGofecboC1i0ShaAPrfIRsQbOD1z5PC3/Hrcs
         Fjl9BZzs2BQdlGM7cUzBvx8B5T4eTVo4UIo7sT2U=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 03/15] bnxt_en: handle CRASH_NO_MASTER during bnxt_open()
Date:   Mon, 25 Jan 2021 02:08:09 -0500
Message-Id: <1611558501-11022-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Add missing support for handling NO_MASTER crashes while ports are
administratively down (ifdown). On some SoC platforms, the driver
needs to assist the firmware to recover from a crash via OP-TEE.
This is performed in a similar fashion to what is done during driver
probe.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 67 +++++++++++++----------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5daef6801512..c091a1023188 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9337,6 +9337,37 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
 
 static int bnxt_fw_init_one(struct bnxt *bp);
 
+static int bnxt_fw_reset_via_optee(struct bnxt *bp)
+{
+#ifdef CONFIG_TEE_BNXT_FW
+	int rc = tee_bnxt_fw_load();
+
+	if (rc)
+		netdev_err(bp->dev, "Failed FW reset via OP-TEE, rc=%d\n", rc);
+
+	return rc;
+#else
+	netdev_err(bp->dev, "OP-TEE not supported\n");
+	return -ENODEV;
+#endif
+}
+
+static int bnxt_try_recover_fw(struct bnxt *bp)
+{
+	if (bp->fw_health && bp->fw_health->status_reliable) {
+		u32 sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+
+		netdev_err(bp->dev, "Firmware not responding, status: 0x%x\n",
+			   sts);
+		if (sts & FW_STATUS_REG_CRASHED_NO_MASTER) {
+			netdev_warn(bp->dev, "Firmware recover via OP-TEE requested\n");
+			return bnxt_fw_reset_via_optee(bp);
+		}
+	}
+
+	return -ENODEV;
+}
+
 static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 {
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
@@ -9356,6 +9387,10 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	if (!rc)
 		flags = le32_to_cpu(resp->flags);
 	mutex_unlock(&bp->hwrm_cmd_lock);
+	if (rc && up) {
+		rc = bnxt_try_recover_fw(bp);
+		fw_reset = true;
+	}
 	if (rc)
 		return rc;
 
@@ -11183,21 +11218,6 @@ static void bnxt_init_dflt_coal(struct bnxt *bp)
 	bp->stats_coal_ticks = BNXT_DEF_STATS_COAL_TICKS;
 }
 
-static int bnxt_fw_reset_via_optee(struct bnxt *bp)
-{
-#ifdef CONFIG_TEE_BNXT_FW
-	int rc = tee_bnxt_fw_load();
-
-	if (rc)
-		netdev_err(bp->dev, "Failed FW reset via OP-TEE, rc=%d\n", rc);
-
-	return rc;
-#else
-	netdev_err(bp->dev, "OP-TEE not supported\n");
-	return -ENODEV;
-#endif
-}
-
 static int bnxt_fw_init_one_p1(struct bnxt *bp)
 {
 	int rc;
@@ -11206,19 +11226,10 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 	rc = bnxt_hwrm_ver_get(bp);
 	bnxt_try_map_fw_health_reg(bp);
 	if (rc) {
-		if (bp->fw_health && bp->fw_health->status_reliable) {
-			u32 sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
-
-			netdev_err(bp->dev,
-				   "Firmware not responding, status: 0x%x\n",
-				   sts);
-			if (sts & FW_STATUS_REG_CRASHED_NO_MASTER) {
-				netdev_warn(bp->dev, "Firmware recover via OP-TEE requested\n");
-				rc = bnxt_fw_reset_via_optee(bp);
-				if (!rc)
-					rc = bnxt_hwrm_ver_get(bp);
-			}
-		}
+		rc = bnxt_try_recover_fw(bp);
+		if (rc)
+			return rc;
+		rc = bnxt_hwrm_ver_get(bp);
 		if (rc)
 			return rc;
 	}
-- 
2.18.1

