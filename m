Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AFD2BAB43
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgKTNds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbgKTNdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46776C061A48
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XZ-0006Fn-0r; Fri, 20 Nov 2020 14:33:29 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 18/25] can: flexcan: flexcan_rx_offload_setup(): factor out mailbox and rx-offload setup into separate function
Date:   Fri, 20 Nov 2020 14:33:11 +0100
Message-Id: <20201120133318.3428231-19-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an upcoming patch the order of operations in flexcan_open() are changed.
Introduce convenience function to make that patch simpler.

Link: https://lore.kernel.org/r/20201119100917.3013281-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 74 ++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 64c174aa868b..0705b6384e49 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1346,6 +1346,47 @@ static void flexcan_ram_init(struct net_device *dev)
 	priv->write(reg_ctrl2, &regs->ctrl2);
 }
 
+static int flexcan_rx_offload_setup(struct net_device *dev)
+{
+	struct flexcan_priv *priv = netdev_priv(dev);
+	int err;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		priv->mb_size = sizeof(struct flexcan_mb) + CANFD_MAX_DLEN;
+	else
+		priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
+	priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
+			 (sizeof(priv->regs->mb[1]) / priv->mb_size);
+
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+		priv->tx_mb_reserved =
+			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP);
+	else
+		priv->tx_mb_reserved =
+			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_FIFO);
+	priv->tx_mb_idx = priv->mb_count - 1;
+	priv->tx_mb = flexcan_get_mb(priv, priv->tx_mb_idx);
+	priv->tx_mask = FLEXCAN_IFLAG_MB(priv->tx_mb_idx);
+
+	priv->offload.mailbox_read = flexcan_mailbox_read;
+
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+		priv->offload.mb_first = FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST;
+		priv->offload.mb_last = priv->mb_count - 2;
+
+		priv->rx_mask = GENMASK_ULL(priv->offload.mb_last,
+					    priv->offload.mb_first);
+		err = can_rx_offload_add_timestamp(dev, &priv->offload);
+	} else {
+		priv->rx_mask = FLEXCAN_IFLAG_RX_FIFO_OVERFLOW |
+			FLEXCAN_IFLAG_RX_FIFO_AVAILABLE;
+		err = can_rx_offload_add_fifo(dev, &priv->offload,
+					      FLEXCAN_NAPI_WEIGHT);
+	}
+
+	return err;
+}
+
 static void flexcan_chip_interrupts_enable(const struct net_device *dev)
 {
 	const struct flexcan_priv *priv = netdev_priv(dev);
@@ -1675,38 +1716,7 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_transceiver_disable;
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
-		priv->mb_size = sizeof(struct flexcan_mb) + CANFD_MAX_DLEN;
-	else
-		priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
-	priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
-			 (sizeof(priv->regs->mb[1]) / priv->mb_size);
-
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
-		priv->tx_mb_reserved =
-			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP);
-	else
-		priv->tx_mb_reserved =
-			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_FIFO);
-	priv->tx_mb_idx = priv->mb_count - 1;
-	priv->tx_mb = flexcan_get_mb(priv, priv->tx_mb_idx);
-	priv->tx_mask = FLEXCAN_IFLAG_MB(priv->tx_mb_idx);
-
-	priv->offload.mailbox_read = flexcan_mailbox_read;
-
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
-		priv->offload.mb_first = FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST;
-		priv->offload.mb_last = priv->mb_count - 2;
-
-		priv->rx_mask = GENMASK_ULL(priv->offload.mb_last,
-					    priv->offload.mb_first);
-		err = can_rx_offload_add_timestamp(dev, &priv->offload);
-	} else {
-		priv->rx_mask = FLEXCAN_IFLAG_RX_FIFO_OVERFLOW |
-			FLEXCAN_IFLAG_RX_FIFO_AVAILABLE;
-		err = can_rx_offload_add_fifo(dev, &priv->offload,
-					      FLEXCAN_NAPI_WEIGHT);
-	}
+	err = flexcan_rx_offload_setup(dev);
 	if (err)
 		goto out_free_irq;
 
-- 
2.29.2

