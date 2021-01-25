Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5893830227F
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbhAYHff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:35:35 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33748 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbhAYHWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:03 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 3F70D80F6;
        Sun, 24 Jan 2021 23:08:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3F70D80F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558504;
        bh=7OAQJAYk2WiaX1DhlHfc14xyJMe3ySul0pofDnRJzZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVbXn+AKEZ7yZGPPAqZdpX8tstYM4maPUve9EHMiU/8BSrLO8XSDAxdmQLT7l2bGR
         KO9qnFfjKj1vsd316PeCwB8VOgk+2SRa9T+2RgDxSXk2W/HX/qJIkx/o0z3jzArTRA
         ppZZuVMzPDWrl1KKZoy6nv40bmjIg+hHwTsrwfdY=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 14/15] bnxt_en: Consolidate firmware reset event logging.
Date:   Mon, 25 Jan 2021 02:08:20 -0500
Message-Id: <1611558501-11022-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Combine the three netdev_warn() calls into a single call, printed at
the NETIF_MSG_HW log level.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e7abb3b7ed68..221f5437884b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2022,10 +2022,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
-	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY:
-		if (netif_msg_hw(bp))
-			netdev_warn(bp->dev, "Received RESET_NOTIFY event, data1: 0x%x, data2: 0x%x\n",
-				    data1, data2);
+	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY: {
+		char *fatal_str = "non-fatal";
+
 		if (!bp->fw_health)
 			goto async_event_process_exit;
 
@@ -2037,14 +2036,18 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!bp->fw_reset_max_dsecs)
 			bp->fw_reset_max_dsecs = BNXT_DFLT_FW_RST_MAX_DSECS;
 		if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
-			netdev_warn(bp->dev, "Firmware fatal reset event received\n");
+			fatal_str = "fatal";
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
-		} else {
-			netdev_warn(bp->dev, "Firmware non-fatal reset event received, max wait time %d msec\n",
+		}
+		if (netif_msg_hw(bp)) {
+			netdev_warn(bp->dev, "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
+				    fatal_str, data1, data2,
+				    bp->fw_reset_min_dsecs * 100,
 				    bp->fw_reset_max_dsecs * 100);
 		}
 		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
 		break;
+	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
 		struct bnxt_fw_health *fw_health = bp->fw_health;
 
-- 
2.18.1

