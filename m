Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED194488666
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiAHVoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiAHVoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758F5C061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVO-0004bs-MO
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:06 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 717FC6D3A9B
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E6F8B6D3A29;
        Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 435795e3;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/22] can: flexcan: rename RX modes
Date:   Sat,  8 Jan 2022 22:43:40 +0100
Message-Id: <20220108214345.1848470-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most flexcan IP cores support 2 RX modes:
- FIFO
- mailbox

The names for these modes were chosen to reflect the name of the
rx-offload mode they are using.

The name of the RX modes should better reflect their difference with
regards the flexcan IP core. So this patch renames the various
occurrences of OFF_FIFO to RX_FIFO and OFF_TIMESTAMP to RX_MAILBOX:

| FLEXCAN_TX_MB_RESERVED_OFF_FIFO -> FLEXCAN_TX_MB_RESERVED_RX_FIFO
| FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP -> FLEXCAN_TX_MB_RESERVED_RX_MAILBOX
| FLEXCAN_QUIRK_USE_OFF_TIMESTAMP -> FLEXCAN_QUIRK_USE_RX_MAILBOX

Link: https://lore.kernel.org/all/20220107193105.1699523-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/flexcan-core.c | 48 +++++++++++++-------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 26bf0a0a72f1..ba52e70d6a16 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -173,9 +173,9 @@
 
 /* FLEXCAN interrupt flag register (IFLAG) bits */
 /* Errata ERR005829 step7: Reserve first valid MB */
-#define FLEXCAN_TX_MB_RESERVED_OFF_FIFO		8
-#define FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP	0
-#define FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST	(FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP + 1)
+#define FLEXCAN_TX_MB_RESERVED_RX_FIFO	8
+#define FLEXCAN_TX_MB_RESERVED_RX_MAILBOX	0
+#define FLEXCAN_RX_MB_RX_MAILBOX_FIRST	(FLEXCAN_TX_MB_RESERVED_RX_MAILBOX + 1)
 #define FLEXCAN_IFLAG_MB(x)		BIT_ULL(x)
 #define FLEXCAN_IFLAG_RX_FIFO_OVERFLOW	BIT(7)
 #define FLEXCAN_IFLAG_RX_FIFO_WARN	BIT(6)
@@ -234,8 +234,8 @@
 #define FLEXCAN_QUIRK_ENABLE_EACEN_RRS  BIT(3)
 /* Disable non-correctable errors interrupt and freeze mode */
 #define FLEXCAN_QUIRK_DISABLE_MECR BIT(4)
-/* Use timestamp based offloading */
-#define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP BIT(5)
+/* Use mailboxes (not FIFO) for RX path */
+#define FLEXCAN_QUIRK_USE_RX_MAILBOX BIT(5)
 /* No interrupt for error passive */
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE BIT(6)
 /* default to BE register access */
@@ -406,38 +406,38 @@ static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR,
 };
 
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
 		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_RX_MAILBOX,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_SUPPORT_FD |
 		FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
@@ -1022,7 +1022,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 
 	mb = flexcan_get_mb(priv, n);
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
 		u32 code;
 
 		do {
@@ -1087,7 +1087,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	}
 
  mark_as_read:
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
 		flexcan_write64(priv, FLEXCAN_IFLAG_MB(n), &regs->iflag1);
 	else
 		priv->write(FLEXCAN_IFLAG_RX_FIFO_AVAILABLE, &regs->iflag1);
@@ -1113,7 +1113,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	enum can_state last_state = priv->can.state;
 
 	/* reception interrupt */
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
 		u64 reg_iflag_rx;
 		int ret;
 
@@ -1429,20 +1429,20 @@ static int flexcan_rx_offload_setup(struct net_device *dev)
 		priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
 				 (sizeof(priv->regs->mb[1]) / priv->mb_size);
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
 		priv->tx_mb_reserved =
-			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP);
+			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_RX_MAILBOX);
 	else
 		priv->tx_mb_reserved =
-			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_FIFO);
+			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_RX_FIFO);
 	priv->tx_mb_idx = priv->mb_count - 1;
 	priv->tx_mb = flexcan_get_mb(priv, priv->tx_mb_idx);
 	priv->tx_mask = FLEXCAN_IFLAG_MB(priv->tx_mb_idx);
 
 	priv->offload.mailbox_read = flexcan_mailbox_read;
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
-		priv->offload.mb_first = FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST;
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
+		priv->offload.mb_first = FLEXCAN_RX_MB_RX_MAILBOX_FIRST;
 		priv->offload.mb_last = priv->mb_count - 2;
 
 		priv->rx_mask = GENMASK_ULL(priv->offload.mb_last,
@@ -1532,10 +1532,10 @@ static int flexcan_chip_start(struct net_device *dev)
 	/* MCR
 	 *
 	 * FIFO:
-	 * - disable for timestamp mode
+	 * - disable for mailbox mode
 	 * - enable for FIFO mode
 	 */
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
 		reg_mcr &= ~FLEXCAN_MCR_FEN;
 	else
 		reg_mcr |= FLEXCAN_MCR_FEN;
@@ -1631,7 +1631,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		priv->write(reg_fdctrl, &regs->fdctrl);
 	}
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
 		for (i = priv->offload.mb_first; i <= priv->offload.mb_last; i++) {
 			mb = flexcan_get_mb(priv, i);
 			priv->write(FLEXCAN_MB_CODE_RX_EMPTY,
@@ -1639,7 +1639,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		}
 	} else {
 		/* clear and invalidate unused mailboxes first */
-		for (i = FLEXCAN_TX_MB_RESERVED_OFF_FIFO; i < priv->mb_count; i++) {
+		for (i = FLEXCAN_TX_MB_RESERVED_RX_FIFO; i < priv->mb_count; i++) {
 			mb = flexcan_get_mb(priv, i);
 			priv->write(FLEXCAN_MB_CODE_RX_INACTIVE,
 				    &mb->can_ctrl);
@@ -2164,7 +2164,7 @@ static int flexcan_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if ((devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) &&
-	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)) {
+	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)) {
 		dev_err(&pdev->dev, "CAN-FD mode doesn't work with FIFO mode!\n");
 		return -EINVAL;
 	}
-- 
2.34.1


