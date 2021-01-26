Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC8230367D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 07:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbhAZG0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 01:26:12 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:43966 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730929AbhAZGV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 01:21:29 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id DC36980F0;
        Mon, 25 Jan 2021 22:20:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com DC36980F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611642024;
        bh=tGxyxwcT076bkz/b7X0ZXw9X9+BeB6ecvObPmgUwxKM=;
        h=From:To:Cc:Subject:Date:From;
        b=aEpf/ywekc2amexo8OlIPXi9cseHPv8y8v9HxoM5JSzqKIxyAh4CxErzoDLNg9XRh
         cWIAktMVpBNXCVZ5+QBif8Lnmp87pO3X4K+PwnekuSN0+WNNYXsuvO1/X2DXttxhW1
         43ZuDeztwJv63R3IHfBKEVzRrnhjCfJlKQwNBrRM=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Joe Perches <joe@perches.com>
Subject: [PATCH net-next] bnxt_en: Convert to use netif_level() helpers.
Date:   Tue, 26 Jan 2021 01:20:24 -0500
Message-Id: <1611642024-3166-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the various netif_level() helpers to simplify the C code.  This was
suggested by Joe Perches.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 ++++++++++-------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dd7d2caa57a2..f508c5c61a30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1266,8 +1266,7 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	} else {
 		tpa_info->hash_type = PKT_HASH_TYPE_NONE;
 		tpa_info->gso_type = 0;
-		if (netif_msg_rx_err(bp))
-			netdev_warn(bp->dev, "TPA packet without valid hash\n");
+		netif_warn(bp, rx_err, bp->dev, "TPA packet without valid hash\n");
 	}
 	tpa_info->flags2 = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_flags2);
 	tpa_info->metadata = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_metadata);
@@ -2039,12 +2038,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			fatal_str = "fatal";
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		}
-		if (netif_msg_hw(bp)) {
-			netdev_warn(bp->dev, "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
-				    fatal_str, data1, data2,
-				    bp->fw_reset_min_dsecs * 100,
-				    bp->fw_reset_max_dsecs * 100);
-		}
+		netif_warn(bp, hw, bp->dev,
+			   "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
+			   fatal_str, data1, data2,
+			   bp->fw_reset_min_dsecs * 100,
+			   bp->fw_reset_max_dsecs * 100);
 		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
 		break;
 	}
@@ -2059,13 +2057,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!fw_health->enabled)
 			break;
 
-		if (netif_msg_drv(bp))
-			netdev_info(bp->dev, "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
-				    fw_health->enabled, fw_health->master,
-				    bnxt_fw_health_readl(bp,
-							 BNXT_FW_RESET_CNT_REG),
-				    bnxt_fw_health_readl(bp,
-							 BNXT_FW_HEALTH_REG));
+		netif_info(bp, drv, bp->dev,
+			   "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
+			   fw_health->enabled, fw_health->master,
+			   bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG),
+			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
@@ -2077,11 +2073,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
-		if (netif_msg_hw(bp)) {
-			netdev_notice(bp->dev,
-				      "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
-				      data1, data2);
-		}
+		netif_notice(bp, hw, bp->dev,
+			     "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
+			     data1, data2);
 		goto async_event_process_exit;
 	case ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG: {
 		struct bnxt_rx_ring_info *rxr;
-- 
2.18.1

