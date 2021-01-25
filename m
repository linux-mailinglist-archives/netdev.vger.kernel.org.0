Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F166302287
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbhAYHnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:43:51 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33576 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727215AbhAYHUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:20:40 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 77A3E80E3;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 77A3E80E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558503;
        bh=dMOvk+Bvze9ruYPP3UO5jZlb48pLyOWb5QBorzUZKss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmTrCk6ZxrY9SL0YZVS0CGdx1V5304lG0BdfNIjmDN+ubjq4KWxcB53eAhRqQ46Bt
         JD2ANd6a5mcwT+ipseCHHsKPUKncQP/4KiMl4ntErbs9YxxnDHWqR/I8x6AM2czPe5
         zp7JuCXJzRQFBgGjbXCJGcwMByXALw3EGMrEif+o=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 09/15] bnxt_en: Retry open if firmware is in reset.
Date:   Mon, 25 Jan 2021 02:08:15 -0500
Message-Id: <1611558501-11022-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Firmware may be in the middle of reset when the driver tries to do ifup.
In that case, firmware will return a special error code and the driver
will retry 10 times with 50 msecs delay after each retry.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 +++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7f30a9fee0c8..c35a5d497c1e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9411,8 +9411,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_if_change_input req = {0};
 	bool resc_reinit = false, fw_reset = false;
+	int rc, retry = 0;
 	u32 flags = 0;
-	int rc;
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_IF_CHANGE))
 		return 0;
@@ -9421,10 +9421,21 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	if (up)
 		req.flags = cpu_to_le32(FUNC_DRV_IF_CHANGE_REQ_FLAGS_UP);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	while (retry < BNXT_FW_IF_RETRY) {
+		rc = _hwrm_send_message(bp, &req, sizeof(req),
+					HWRM_CMD_TIMEOUT);
+		if (rc != -EAGAIN)
+			break;
+
+		msleep(50);
+		retry++;
+	}
 	if (!rc)
 		flags = le32_to_cpu(resp->flags);
 	mutex_unlock(&bp->hwrm_cmd_lock);
+
+	if (rc == -EAGAIN)
+		return rc;
 	if (rc && up) {
 		rc = bnxt_try_recover_fw(bp);
 		fw_reset = true;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cbb338baab07..bd36f00ef28c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1554,6 +1554,7 @@ struct bnxt_fw_reporter_ctx {
 					 BNXT_FW_STATUS_HEALTHY)
 
 #define BNXT_FW_RETRY			5
+#define BNXT_FW_IF_RETRY		10
 
 struct bnxt {
 	void __iomem		*bar0;
-- 
2.18.1

