Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E892A4DEB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgKCSKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729002AbgKCSKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:10:12 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631F3C0613D1;
        Tue,  3 Nov 2020 10:10:12 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4CQd9M5bB2z1rsNT;
        Tue,  3 Nov 2020 19:09:59 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4CQd9M0MkDz1qtZB;
        Tue,  3 Nov 2020 19:09:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 6pvLRmTPH3AJ; Tue,  3 Nov 2020 19:09:57 +0100 (CET)
X-Auth-Info: 1U1MDOVSZ0ZB3wc9xWUKX7BNRDPK2UOjjOtadn9h+fs=
Received: from localhost.localdomain (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  3 Nov 2020 19:09:57 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 2/2] rsi: Clean up loop in the interrupt handler
Date:   Tue,  3 Nov 2020 19:09:41 +0100
Message-Id: <20201103180941.443528-2-marex@denx.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103180941.443528-1-marex@denx.de>
References: <20201103180941.443528-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inner do { ... } while loop is completely useless, all it does
is iterate over a switch-case statement, one bit at a time. This
can easily be replaced by simple if (status & bit) { ... } tests
for each bit. No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 121 ++++++++++----------
 1 file changed, 58 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 23e709aabd1f..8ace1874e5cb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -236,7 +236,6 @@ static void rsi_rx_handler(struct rsi_hw *adapter)
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	int status;
-	enum sdio_interrupt_type isr_type;
 	u8 isr_status = 0;
 	u8 fw_status = 0;
 
@@ -267,73 +266,69 @@ static void rsi_rx_handler(struct rsi_hw *adapter)
 			__func__, isr_status, (1 << MSDU_PKT_PENDING),
 			(1 << FW_ASSERT_IND));
 
-		do {
-			RSI_GET_SDIO_INTERRUPT_TYPE(isr_status, isr_type);
-
-			switch (isr_type) {
-			case BUFFER_AVAILABLE:
-				status = rsi_sdio_check_buffer_status(adapter,
-								      0);
-				if (status < 0)
-					rsi_dbg(ERR_ZONE,
-						"%s: Failed to check buffer status\n",
-						__func__);
-				rsi_sdio_ack_intr(common->priv,
-						  (1 << PKT_BUFF_AVAILABLE));
-				rsi_set_event(&common->tx_thread.event);
-
-				rsi_dbg(ISR_ZONE,
-					"%s: ==> BUFFER_AVAILABLE <==\n",
-					__func__);
-				dev->buff_status_updated = true;
-				break;
-
-			case FIRMWARE_ASSERT_IND:
+		if (isr_status & BIT(PKT_BUFF_AVAILABLE)) {
+			status = rsi_sdio_check_buffer_status(adapter, 0);
+			if (status < 0)
 				rsi_dbg(ERR_ZONE,
-					"%s: ==> FIRMWARE Assert <==\n",
+					"%s: Failed to check buffer status\n",
 					__func__);
-				status = rsi_sdio_read_register(common->priv,
+			rsi_sdio_ack_intr(common->priv,
+					  BIT(PKT_BUFF_AVAILABLE));
+			rsi_set_event(&common->tx_thread.event);
+
+			rsi_dbg(ISR_ZONE, "%s: ==> BUFFER_AVAILABLE <==\n",
+				__func__);
+			dev->buff_status_updated = true;
+
+			isr_status &= ~BIT(PKT_BUFF_AVAILABLE);
+		}
+
+		if (isr_status & BIT(FW_ASSERT_IND)) {
+			rsi_dbg(ERR_ZONE, "%s: ==> FIRMWARE Assert <==\n",
+				__func__);
+			status = rsi_sdio_read_register(common->priv,
 							SDIO_FW_STATUS_REG,
 							&fw_status);
-				if (status) {
-					rsi_dbg(ERR_ZONE,
-						"%s: Failed to read f/w reg\n",
-						__func__);
-				} else {
-					rsi_dbg(ERR_ZONE,
-						"%s: Firmware Status is 0x%x\n",
-						__func__ , fw_status);
-					rsi_sdio_ack_intr(common->priv,
-							  (1 << FW_ASSERT_IND));
-				}
-
-				common->fsm_state = FSM_CARD_NOT_READY;
-				break;
-
-			case MSDU_PACKET_PENDING:
-				rsi_dbg(ISR_ZONE, "Pkt pending interrupt\n");
-				dev->rx_info.total_sdio_msdu_pending_intr++;
-
-				status = rsi_process_pkt(common);
-				if (status) {
-					rsi_dbg(ERR_ZONE,
-						"%s: Failed to read pkt\n",
-						__func__);
-					mutex_unlock(&common->rx_lock);
-					return;
-				}
-				break;
-			default:
-				rsi_sdio_ack_intr(common->priv, isr_status);
-				dev->rx_info.total_sdio_unknown_intr++;
-				isr_status = 0;
-				rsi_dbg(ISR_ZONE,
-					"Unknown Interrupt %x\n",
-					isr_status);
-				break;
+			if (status) {
+				rsi_dbg(ERR_ZONE,
+					"%s: Failed to read f/w reg\n",
+					__func__);
+			} else {
+				rsi_dbg(ERR_ZONE,
+					"%s: Firmware Status is 0x%x\n",
+					__func__, fw_status);
+				rsi_sdio_ack_intr(common->priv,
+						  BIT(FW_ASSERT_IND));
 			}
-			isr_status ^= BIT(isr_type - 1);
-		} while (isr_status);
+
+			common->fsm_state = FSM_CARD_NOT_READY;
+
+			isr_status &= ~BIT(FW_ASSERT_IND);
+		}
+
+		if (isr_status & BIT(MSDU_PKT_PENDING)) {
+			rsi_dbg(ISR_ZONE, "Pkt pending interrupt\n");
+			dev->rx_info.total_sdio_msdu_pending_intr++;
+
+			status = rsi_process_pkt(common);
+			if (status) {
+				rsi_dbg(ERR_ZONE, "%s: Failed to read pkt\n",
+					__func__);
+				mutex_unlock(&common->rx_lock);
+				return;
+			}
+
+			isr_status &= ~BIT(MSDU_PKT_PENDING);
+		}
+
+		if (isr_status) {
+			rsi_sdio_ack_intr(common->priv, isr_status);
+			dev->rx_info.total_sdio_unknown_intr++;
+			isr_status = 0;
+			rsi_dbg(ISR_ZONE, "Unknown Interrupt %x\n",
+				isr_status);
+		}
+
 		mutex_unlock(&common->rx_lock);
 	} while (1);
 }
-- 
2.28.0

