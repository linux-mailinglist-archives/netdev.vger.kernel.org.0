Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F21A31B32C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhBNXGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:06:46 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45602 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhBNXGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:06:43 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id DD1B37DA3;
        Sun, 14 Feb 2021 15:05:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com DD1B37DA3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=pmYpGUcPI8gceLeuc1GFJwia6mL7KpuMQFQIEQvSARI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkdYqpg3sj4eB7I8LtO+DFf8UeVCYEwholG+eN21VHaFt/h2JSY2JtAdTp9LEWV+T
         xqixJRxKTbgjpR8QuhP4VKX/ZelGQSWzjP7Im9SVG7EVX7tGRKe1BWnb/Y4b985B1r
         hhvcNAN5QmjYgzXpc8AFpDSZ+FdoKGkQA2mmpwIw=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 6/7] bnxt_en: Reply to firmware's echo request async message.
Date:   Sun, 14 Feb 2021 18:05:00 -0500
Message-Id: <1613343901-6629-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new async message that the firmware can send to check if it
can communicate with the driver.  This is an added error detection
scheme that firmware can use if it suspects errors in the PCIe
interface.  When the driver receives this async message, it will reply
back echoing some data in the async message.  If the firmware is not
getting the reply with the proper data after some retries, error
recovery will kick in.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 29 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2bd9358c11e0..65771be802af 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -257,6 +257,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 	ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION,
 	ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG,
+	ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST,
 };
 
 static struct workqueue_struct *bnxt_pf_wq;
@@ -2099,6 +2100,20 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		bnxt_sched_reset(bp, rxr);
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST: {
+		struct bnxt_fw_health *fw_health = bp->fw_health;
+
+		netif_notice(bp, hw, bp->dev,
+			     "Received firmware echo request, data1: 0x%x, data2: 0x%x\n",
+			     data1, data2);
+		if (fw_health) {
+			fw_health->echo_req_data1 = data1;
+			fw_health->echo_req_data2 = data2;
+			set_bit(BNXT_FW_ECHO_REQUEST_SP_EVENT, &bp->sp_event);
+			break;
+		}
+		goto async_event_process_exit;
+	}
 	default:
 		goto async_event_process_exit;
 	}
@@ -11208,6 +11223,17 @@ static void bnxt_init_ethtool_link_settings(struct bnxt *bp)
 		link_info->req_flow_ctrl = link_info->force_pause_setting;
 }
 
+static void bnxt_fw_echo_reply(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct hwrm_func_echo_response_input req = {0};
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_ECHO_RESPONSE, -1, -1);
+	req.event_data1 = cpu_to_le32(fw_health->echo_req_data1);
+	req.event_data2 = cpu_to_le32(fw_health->echo_req_data2);
+	hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+}
+
 static void bnxt_sp_task(struct work_struct *work)
 {
 	struct bnxt *bp = container_of(work, struct bnxt, sp_task);
@@ -11275,6 +11301,9 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_RING_COAL_NOW_SP_EVENT, &bp->sp_event))
 		bnxt_chk_missed_irq(bp);
 
+	if (test_and_clear_bit(BNXT_FW_ECHO_REQUEST_SP_EVENT, &bp->sp_event))
+		bnxt_fw_echo_reply(bp);
+
 	/* These functions below will clear BNXT_STATE_IN_SP_TASK.  They
 	 * must be the last functions to be called before exiting.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f5c45ea52b44..1259e68cba2a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1531,6 +1531,8 @@ struct bnxt_fw_health {
 	u32 fw_reset_seq_regs[16];
 	u32 fw_reset_seq_vals[16];
 	u32 fw_reset_seq_delay_msec[16];
+	u32 echo_req_data1;
+	u32 echo_req_data2;
 	struct devlink_health_reporter	*fw_reporter;
 	struct devlink_health_reporter *fw_reset_reporter;
 	struct devlink_health_reporter *fw_fatal_reporter;
@@ -1940,6 +1942,7 @@ struct bnxt {
 #define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
 #define BNXT_FW_EXCEPTION_SP_EVENT	19
 #define BNXT_LINK_CFG_CHANGE_SP_EVENT	21
+#define BNXT_FW_ECHO_REQUEST_SP_EVENT	23
 
 	struct delayed_work	fw_reset_task;
 	int			fw_reset_state;
-- 
2.18.1

