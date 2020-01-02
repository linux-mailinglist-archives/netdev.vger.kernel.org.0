Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8002B12E875
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgABQJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:44 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42529 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgABQJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:43 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32b-0000mM-HD; Thu, 02 Jan 2020 17:09:41 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Florian Faber <faber@faberman.de>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 9/9] can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode
Date:   Thu,  2 Jan 2020 17:09:34 +0100
Message-Id: <20200102160934.1524-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102160934.1524-1-mkl@pengutronix.de>
References: <20200102160934.1524-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Faber <faber@faberman.de>

Under load, the RX side of the mscan driver can get stuck while TX still
works. Restarting the interface locks up the system. This behaviour
could be reproduced reliably on a MPC5121e based system.

The patch fixes the return value of the NAPI polling function (should be
the number of processed packets, not constant 1) and the condition under
which IRQs are enabled again after polling is finished.

With this patch, no more lockups were observed over a test period of ten
days.

Fixes: afa17a500a36 ("net/can: add driver for mscan family & mpc52xx_mscan")
Signed-off-by: Florian Faber <faber@faberman.de>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/mscan/mscan.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 8caf7af0dee2..99101d7027a8 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -381,13 +381,12 @@ static int mscan_rx_poll(struct napi_struct *napi, int quota)
 	struct net_device *dev = napi->dev;
 	struct mscan_regs __iomem *regs = priv->reg_base;
 	struct net_device_stats *stats = &dev->stats;
-	int npackets = 0;
-	int ret = 1;
+	int work_done = 0;
 	struct sk_buff *skb;
 	struct can_frame *frame;
 	u8 canrflg;
 
-	while (npackets < quota) {
+	while (work_done < quota) {
 		canrflg = in_8(&regs->canrflg);
 		if (!(canrflg & (MSCAN_RXF | MSCAN_ERR_IF)))
 			break;
@@ -408,18 +407,18 @@ static int mscan_rx_poll(struct napi_struct *napi, int quota)
 
 		stats->rx_packets++;
 		stats->rx_bytes += frame->can_dlc;
-		npackets++;
+		work_done++;
 		netif_receive_skb(skb);
 	}
 
-	if (!(in_8(&regs->canrflg) & (MSCAN_RXF | MSCAN_ERR_IF))) {
-		napi_complete(&priv->napi);
-		clear_bit(F_RX_PROGRESS, &priv->flags);
-		if (priv->can.state < CAN_STATE_BUS_OFF)
-			out_8(&regs->canrier, priv->shadow_canrier);
-		ret = 0;
+	if (work_done < quota) {
+		if (likely(napi_complete_done(&priv->napi, work_done))) {
+			clear_bit(F_RX_PROGRESS, &priv->flags);
+			if (priv->can.state < CAN_STATE_BUS_OFF)
+				out_8(&regs->canrier, priv->shadow_canrier);
+		}
 	}
-	return ret;
+	return work_done;
 }
 
 static irqreturn_t mscan_isr(int irq, void *dev_id)
-- 
2.24.1

