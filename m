Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A2631B330
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhBNXG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:06:58 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45604 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230210AbhBNXGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:06:43 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 0D32B7A51;
        Sun, 14 Feb 2021 15:05:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0D32B7A51
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343903;
        bh=bFwY/5TFQduYQzF+KhWuusoyYMosvcohMAgEazGhaZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBIRphjMYO25L28oMHvE09HNOR1RwNwJJo0nGfBkCnZZVmGsX7XMyPY6SGve9Ei8t
         LhItD47UsoPo5ZWzMXOhIm8e79PL7CNJ/f7pAnktgMIsKWD7Q51oVh83Wwnr7U3aa0
         XSufzA1F/DyqZEvMymnteS+lX2ja7ML/NyEtzupA=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 7/7] bnxt_en: Improve logging of error recovery settings information.
Date:   Sun, 14 Feb 2021 18:05:01 -0500
Message-Id: <1613343901-6629-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently only log the error recovery settings if it is enabled.
In some cases, firmware disables error recovery after it was
initially enabled.  Without logging anything, the user will not be
aware of this change in setting.

Log it when error recovery is disabled.  Also, change the reset count
value from hexadecimal to decimal.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 65771be802af..d0f3f68faa91 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2055,14 +2055,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 
 		fw_health->enabled = EVENT_DATA1_RECOVERY_ENABLED(data1);
 		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
-		if (!fw_health->enabled)
+		if (!fw_health->enabled) {
+			netif_info(bp, drv, bp->dev,
+				   "Error recovery info: error recovery[0]\n");
 			break;
-
-		netif_info(bp, drv, bp->dev,
-			   "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
-			   fw_health->enabled, fw_health->master,
-			   bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG),
-			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
+		}
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
@@ -2071,6 +2068,10 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
 		fw_health->last_fw_reset_cnt =
 			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		netif_info(bp, drv, bp->dev,
+			   "Error recovery info: error recovery[1], master[%d], reset count[%u], health status: 0x%x\n",
+			   fw_health->master, fw_health->last_fw_reset_cnt,
+			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
-- 
2.18.1

