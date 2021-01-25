Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EA5302268
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbhAYHY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:24:58 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33764 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727242AbhAYHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:35 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 2EF8780DE;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 2EF8780DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558503;
        bh=85WyUk0/UBkZztPASYhqvO7q/uNYumjxv441uM2/iu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9pRP1i9tHxnK7cipXJTmifLHvX08c8FZ0Igq9Uly/i+FTmNf/b6lgB54Mr2Wiaif
         zp7SbYmdPVPVaYZjRi9oSYxostc9+xQDQ3HUOwFopei8Xi3yQFD4Pp1fwdalCYY59g
         00a3141QkRCSqoPBZcoIGqNEWw4wz/awe3MFiZyg=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 07/15] bnxt_en: log firmware debug notifications
Date:   Mon, 25 Jan 2021 02:08:13 -0500
Message-Id: <1611558501-11022-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Firmware is capable of generating asynchronous debug notifications.
The event data is opaque to the driver and is simply logged. Debug
notifications can be enabled by turning on hardware status messages
using the ethtool msglvl interface.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c06c5f81f087..c8c25f7644ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -255,6 +255,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
+	ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION,
 	ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG,
 };
 
@@ -2072,6 +2073,13 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
+		if (netif_msg_hw(bp)) {
+			netdev_notice(bp->dev,
+				      "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
+				      data1, data2);
+		}
+		goto async_event_process_exit;
 	case ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG: {
 		struct bnxt_rx_ring_info *rxr;
 		u16 grp_idx;
-- 
2.18.1

