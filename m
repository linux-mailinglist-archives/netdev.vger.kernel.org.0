Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336EF302273
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbhAYHab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:30:31 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33762 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727220AbhAYHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:35 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B53957DC2;
        Sun, 24 Jan 2021 23:08:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B53957DC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558502;
        bh=aomDbowrNA+G4BGcUBg9Lchmbjx1JNYYnV5nO0bR6EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4cGA24TUfGHcOykvd2EueN9eX6tQA6+4KCe2/fl7xhWoWSoNX8vmDVqsD/lrOEgB
         1i84G0WgcHL9Os9WuI8nDFAqH7Xg6V7QFTEkRyJQqGJdyAj/fm5yi/7v6a4K1rIMcU
         jmoVQTP3fYtstCNvnrnZw0hsZWYQAbF1aIFl0m9o=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 04/15] bnxt_en: Retry sending the first message to firmware if it is under reset.
Date:   Mon, 25 Jan 2021 02:08:10 -0500
Message-Id: <1611558501-11022-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first HWRM_VER_GET message to firmware during probe may timeout if
firmware is under reset.  This can happen during hot-plug for example.
On P5 and newer chips, we can check if firmware is in the boot stage by
reading a status register.  Retry 5 times if the status register shows
that firmware is not ready and not in error state.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 42 +++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  7 ++++
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c091a1023188..c460dd796c1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7441,9 +7441,22 @@ static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
 
 	sig = readl(hs + offsetof(struct hcomm_status, sig_ver));
 	if ((sig & HCOMM_STATUS_SIGNATURE_MASK) != HCOMM_STATUS_SIGNATURE_VAL) {
-		if (bp->fw_health)
-			bp->fw_health->status_reliable = false;
-		return;
+		if (!bp->chip_num) {
+			__bnxt_map_fw_health_reg(bp, BNXT_GRC_REG_BASE);
+			bp->chip_num = readl(bp->bar0 +
+					     BNXT_FW_HEALTH_WIN_BASE +
+					     BNXT_GRC_REG_CHIP_NUM);
+		}
+		if (!BNXT_CHIP_P5(bp)) {
+			if (bp->fw_health)
+				bp->fw_health->status_reliable = false;
+			return;
+		}
+		status_loc = BNXT_GRC_REG_STATUS_P5 |
+			     BNXT_FW_HEALTH_REG_TYPE_BAR0;
+	} else {
+		status_loc = readl(hs + offsetof(struct hcomm_status,
+						 fw_status_loc));
 	}
 
 	if (__bnxt_alloc_fw_health(bp)) {
@@ -7451,7 +7464,6 @@ static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
 		return;
 	}
 
-	status_loc = readl(hs + offsetof(struct hcomm_status, fw_status_loc));
 	bp->fw_health->regs[BNXT_FW_HEALTH_REG] = status_loc;
 	reg_type = BNXT_FW_HEALTH_REG_TYPE(status_loc);
 	if (reg_type == BNXT_FW_HEALTH_REG_TYPE_GRC) {
@@ -9355,14 +9367,30 @@ static int bnxt_fw_reset_via_optee(struct bnxt *bp)
 static int bnxt_try_recover_fw(struct bnxt *bp)
 {
 	if (bp->fw_health && bp->fw_health->status_reliable) {
-		u32 sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+		int retry = 0, rc;
+		u32 sts;
+
+		mutex_lock(&bp->hwrm_cmd_lock);
+		do {
+			rc = __bnxt_hwrm_ver_get(bp, true);
+			sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+			if (!sts || !BNXT_FW_IS_BOOTING(sts))
+				break;
+			retry++;
+		} while (rc == -EBUSY && retry < BNXT_FW_RETRY);
+		mutex_unlock(&bp->hwrm_cmd_lock);
 
-		netdev_err(bp->dev, "Firmware not responding, status: 0x%x\n",
-			   sts);
+		if (!BNXT_FW_IS_HEALTHY(sts)) {
+			netdev_err(bp->dev,
+				   "Firmware not responding, status: 0x%x\n",
+				   sts);
+			rc = -ENODEV;
+		}
 		if (sts & FW_STATUS_REG_CRASHED_NO_MASTER) {
 			netdev_warn(bp->dev, "Firmware recover via OP-TEE requested\n");
 			return bnxt_fw_reset_via_optee(bp);
 		}
+		return rc;
 	}
 
 	return -ENODEV;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a1dd80a0fcf6..867b1d3a134e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1345,9 +1345,14 @@ struct bnxt_test_info {
 #define BNXT_CAG_REG_LEGACY_INT_STATUS		0x4014
 #define BNXT_CAG_REG_BASE			0x300000
 
+#define BNXT_GRC_REG_STATUS_P5			0x520
+
 #define BNXT_GRCPF_REG_KONG_COMM		0xA00
 #define BNXT_GRCPF_REG_KONG_COMM_TRIGGER	0xB00
 
+#define BNXT_GRC_REG_CHIP_NUM			0x48
+#define BNXT_GRC_REG_BASE			0x260000
+
 #define BNXT_GRC_BASE_MASK			0xfffff000
 #define BNXT_GRC_OFFSET_MASK			0x00000ffc
 
@@ -1547,6 +1552,8 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_IS_ERR(sts)		(((sts) & BNXT_FW_STATUS_HEALTH_MSK) > \
 					 BNXT_FW_STATUS_HEALTHY)
 
+#define BNXT_FW_RETRY			5
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
-- 
2.18.1

