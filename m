Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5553B302285
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbhAYHnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:43:22 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33572 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727214AbhAYHUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:20:40 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9C0D980F0;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9C0D980F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558503;
        bh=UjAp/KEeiD2Pkc7/tKQbUFdrJ7OM+R/kmkRk30knHbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egsgpRvpm5xzMb5Xcg9Se/6NFWsyASGawqBBNI+wK6J8u4/Jc79mWgOJwITZJViUf
         o+84waMHoP9c+2EXrGSL0s9rzBCocIjYoMnvEbVWNlRC4aINce7CzuiYPCU15tT6Xi
         4JhkyX+XmuuQ1GrP82V6Jl8GhSi5AgqUzgcYJ3E4=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 10/15] bnxt_en: Add bnxt_fw_reset_timeout() helper.
Date:   Mon, 25 Jan 2021 02:08:16 -0500
Message-Id: <1611558501-11022-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code to check if we have reached the maximum wait time after
firmware reset is used multiple times.  Add a helper function to
do this.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c35a5d497c1e..98caac9fbdee 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11503,6 +11503,12 @@ static void bnxt_reset_all(struct bnxt *bp)
 	bp->fw_reset_timestamp = jiffies;
 }
 
+static bool bnxt_fw_reset_timeout(struct bnxt *bp)
+{
+	return time_after(jiffies, bp->fw_reset_timestamp +
+			  (bp->fw_reset_max_dsecs * HZ / 10));
+}
+
 static void bnxt_fw_reset_task(struct work_struct *work)
 {
 	struct bnxt *bp = container_of(work, struct bnxt, fw_reset_task.work);
@@ -11524,8 +11530,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 				   bp->fw_reset_timestamp));
 			goto fw_reset_abort;
 		} else if (n > 0) {
-			if (time_after(jiffies, bp->fw_reset_timestamp +
-				       (bp->fw_reset_max_dsecs * HZ / 10))) {
+			if (bnxt_fw_reset_timeout(bp)) {
 				clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 				bp->fw_reset_state = 0;
 				netdev_err(bp->dev, "Firmware reset aborted, bnxt_get_registered_vfs() returns %d\n",
@@ -11554,8 +11559,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 
 		val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
 		if (!(val & BNXT_FW_STATUS_SHUTDOWN) &&
-		    !time_after(jiffies, bp->fw_reset_timestamp +
-		    (bp->fw_reset_max_dsecs * HZ / 10))) {
+		    !bnxt_fw_reset_timeout(bp)) {
 			bnxt_queue_fw_reset_work(bp, HZ / 5);
 			return;
 		}
@@ -11597,8 +11601,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bp->hwrm_cmd_timeout = SHORT_HWRM_CMD_TIMEOUT;
 		rc = __bnxt_hwrm_ver_get(bp, true);
 		if (rc) {
-			if (time_after(jiffies, bp->fw_reset_timestamp +
-				       (bp->fw_reset_max_dsecs * HZ / 10))) {
+			if (bnxt_fw_reset_timeout(bp)) {
 				netdev_err(bp->dev, "Firmware reset aborted\n");
 				goto fw_reset_abort_status;
 			}
-- 
2.18.1

