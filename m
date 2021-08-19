Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F533F1AAA
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbhHSNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbhHSNkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994D2C061764
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGW-0004Ul-2B
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:28 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8000C66A835
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2545366A816;
        Thu, 19 Aug 2021 13:39:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6da2dad2;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/22] can: rcar_canfd: Add support for RZ/G2L family
Date:   Thu, 19 Aug 2021 15:39:01 +0200
Message-Id: <20210819133913.657715-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

CANFD block on RZ/G2L SoC is almost identical to one found on
R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
are split into different sources and the IP doesn't divide (1/2)
CANFD clock within the IP.

This patch adds compatible string for RZ/G2L family and splits
the irq handlers to accommodate both RZ/G2L and R-Car Gen3 SoC's.

Link: https://lore.kernel.org/r/20210727133022.634-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
[mkl: fixed typo: recieve -> receive, thanks Geert]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 338 +++++++++++++++++++++++-------
 1 file changed, 265 insertions(+), 73 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 311e6ca3bdc4..5d4d52afde15 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -37,9 +37,15 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iopoll.h>
+#include <linux/reset.h>
 
 #define RCANFD_DRV_NAME			"rcar_canfd"
 
+enum rcanfd_chip_id {
+	RENESAS_RCAR_GEN3 = 0,
+	RENESAS_RZG2L,
+};
+
 /* Global register bits */
 
 /* RSCFDnCFDGRMCFG */
@@ -513,6 +519,9 @@ struct rcar_canfd_global {
 	enum rcar_canfd_fcanclk fcan;	/* CANFD or Ext clock */
 	unsigned long channels_mask;	/* Enabled channels mask */
 	bool fdmode;			/* CAN FD or Classical CAN only mode */
+	struct reset_control *rstc1;
+	struct reset_control *rstc2;
+	enum rcanfd_chip_id chip_id;
 };
 
 /* CAN FD mode nominal rate constants */
@@ -1070,38 +1079,70 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
 	can_led_event(ndev, CAN_LED_EVENT_TX);
 }
 
+static void rcar_canfd_handle_global_err(struct rcar_canfd_global *gpriv, u32 ch)
+{
+	struct rcar_canfd_channel *priv = gpriv->ch[ch];
+	struct net_device *ndev = priv->ndev;
+	u32 gerfl;
+
+	/* Handle global error interrupts */
+	gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
+	if (unlikely(RCANFD_GERFL_ERR(gpriv, gerfl)))
+		rcar_canfd_global_error(ndev);
+}
+
+static irqreturn_t rcar_canfd_global_err_interrupt(int irq, void *dev_id)
+{
+	struct rcar_canfd_global *gpriv = dev_id;
+	u32 ch;
+
+	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+		rcar_canfd_handle_global_err(gpriv, ch);
+
+	return IRQ_HANDLED;
+}
+
+static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u32 ch)
+{
+	struct rcar_canfd_channel *priv = gpriv->ch[ch];
+	u32 ridx = ch + RCANFD_RFFIFO_IDX;
+	u32 sts;
+
+	/* Handle Rx interrupts */
+	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
+	if (likely(sts & RCANFD_RFSTS_RFIF)) {
+		if (napi_schedule_prep(&priv->napi)) {
+			/* Disable Rx FIFO interrupts */
+			rcar_canfd_clear_bit(priv->base,
+					     RCANFD_RFCC(ridx),
+					     RCANFD_RFCC_RFIE);
+			__napi_schedule(&priv->napi);
+		}
+	}
+}
+
+static irqreturn_t rcar_canfd_global_receive_fifo_interrupt(int irq, void *dev_id)
+{
+	struct rcar_canfd_global *gpriv = dev_id;
+	u32 ch;
+
+	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+		rcar_canfd_handle_global_receive(gpriv, ch);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 {
 	struct rcar_canfd_global *gpriv = dev_id;
-	struct net_device *ndev;
-	struct rcar_canfd_channel *priv;
-	u32 sts, gerfl;
-	u32 ch, ridx;
+	u32 ch;
 
 	/* Global error interrupts still indicate a condition specific
 	 * to a channel. RxFIFO interrupt is a global interrupt.
 	 */
 	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
-		priv = gpriv->ch[ch];
-		ndev = priv->ndev;
-		ridx = ch + RCANFD_RFFIFO_IDX;
-
-		/* Global error interrupts */
-		gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
-		if (unlikely(RCANFD_GERFL_ERR(gpriv, gerfl)))
-			rcar_canfd_global_error(ndev);
-
-		/* Handle Rx interrupts */
-		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-		if (likely(sts & RCANFD_RFSTS_RFIF)) {
-			if (napi_schedule_prep(&priv->napi)) {
-				/* Disable Rx FIFO interrupts */
-				rcar_canfd_clear_bit(priv->base,
-						     RCANFD_RFCC(ridx),
-						     RCANFD_RFCC_RFIE);
-				__napi_schedule(&priv->napi);
-			}
-		}
+		rcar_canfd_handle_global_err(gpriv, ch);
+		rcar_canfd_handle_global_receive(gpriv, ch);
 	}
 	return IRQ_HANDLED;
 }
@@ -1139,38 +1180,73 @@ static void rcar_canfd_state_change(struct net_device *ndev,
 	}
 }
 
-static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
+static void rcar_canfd_handle_channel_tx(struct rcar_canfd_global *gpriv, u32 ch)
+{
+	struct rcar_canfd_channel *priv = priv = gpriv->ch[ch];
+	struct net_device *ndev = priv->ndev;
+	u32 sts;
+
+	/* Handle Tx interrupts */
+	sts = rcar_canfd_read(priv->base,
+			      RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX));
+	if (likely(sts & RCANFD_CFSTS_CFTXIF))
+		rcar_canfd_tx_done(ndev);
+}
+
+static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 {
 	struct rcar_canfd_global *gpriv = dev_id;
-	struct net_device *ndev;
-	struct rcar_canfd_channel *priv;
-	u32 sts, ch, cerfl;
+	u32 ch;
+
+	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+		rcar_canfd_handle_channel_tx(gpriv, ch);
+
+	return IRQ_HANDLED;
+}
+
+static void rcar_canfd_handle_channel_err(struct rcar_canfd_global *gpriv, u32 ch)
+{
+	struct rcar_canfd_channel *priv = gpriv->ch[ch];
+	struct net_device *ndev = priv->ndev;
 	u16 txerr, rxerr;
+	u32 sts, cerfl;
+
+	/* Handle channel error interrupts */
+	cerfl = rcar_canfd_read(priv->base, RCANFD_CERFL(ch));
+	sts = rcar_canfd_read(priv->base, RCANFD_CSTS(ch));
+	txerr = RCANFD_CSTS_TECCNT(sts);
+	rxerr = RCANFD_CSTS_RECCNT(sts);
+	if (unlikely(RCANFD_CERFL_ERR(cerfl)))
+		rcar_canfd_error(ndev, cerfl, txerr, rxerr);
+
+	/* Handle state change to lower states */
+	if (unlikely(priv->can.state != CAN_STATE_ERROR_ACTIVE &&
+		     priv->can.state != CAN_STATE_BUS_OFF))
+		rcar_canfd_state_change(ndev, txerr, rxerr);
+}
+
+static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
+{
+	struct rcar_canfd_global *gpriv = dev_id;
+	u32 ch;
+
+	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
+		rcar_canfd_handle_channel_err(gpriv, ch);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
+{
+	struct rcar_canfd_global *gpriv = dev_id;
+	u32 ch;
 
 	/* Common FIFO is a per channel resource */
 	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS) {
-		priv = gpriv->ch[ch];
-		ndev = priv->ndev;
-
-		/* Channel error interrupts */
-		cerfl = rcar_canfd_read(priv->base, RCANFD_CERFL(ch));
-		sts = rcar_canfd_read(priv->base, RCANFD_CSTS(ch));
-		txerr = RCANFD_CSTS_TECCNT(sts);
-		rxerr = RCANFD_CSTS_RECCNT(sts);
-		if (unlikely(RCANFD_CERFL_ERR(cerfl)))
-			rcar_canfd_error(ndev, cerfl, txerr, rxerr);
-
-		/* Handle state change to lower states */
-		if (unlikely((priv->can.state != CAN_STATE_ERROR_ACTIVE) &&
-			     (priv->can.state != CAN_STATE_BUS_OFF)))
-			rcar_canfd_state_change(ndev, txerr, rxerr);
-
-		/* Handle Tx interrupts */
-		sts = rcar_canfd_read(priv->base,
-				      RCANFD_CFSTS(ch, RCANFD_CFFIFO_IDX));
-		if (likely(sts & RCANFD_CFSTS_CFTXIF))
-			rcar_canfd_tx_done(ndev);
+		rcar_canfd_handle_channel_err(gpriv, ch);
+		rcar_canfd_handle_channel_tx(gpriv, ch);
 	}
+
 	return IRQ_HANDLED;
 }
 
@@ -1577,6 +1653,53 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
+	if (gpriv->chip_id == RENESAS_RZG2L) {
+		char *irq_name;
+		int err_irq;
+		int tx_irq;
+
+		err_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_err" : "ch1_err");
+		if (err_irq < 0) {
+			err = err_irq;
+			goto fail;
+		}
+
+		tx_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_trx" : "ch1_trx");
+		if (tx_irq < 0) {
+			err = tx_irq;
+			goto fail;
+		}
+
+		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+					  "canfd.ch%d_err", ch);
+		if (!irq_name) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		err = devm_request_irq(&pdev->dev, err_irq,
+				       rcar_canfd_channel_err_interrupt, 0,
+				       irq_name, gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
+				err_irq, err);
+			goto fail;
+		}
+		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+					  "canfd.ch%d_trx", ch);
+		if (!irq_name) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		err = devm_request_irq(&pdev->dev, tx_irq,
+				       rcar_canfd_channel_tx_interrupt, 0,
+				       irq_name, gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
+				tx_irq, err);
+			goto fail;
+		}
+	}
+
 	if (gpriv->fdmode) {
 		priv->can.bittiming_const = &rcar_canfd_nom_bittiming_const;
 		priv->can.data_bittiming_const =
@@ -1636,7 +1759,11 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	struct device_node *of_child;
 	unsigned long channels_mask = 0;
 	int err, ch_irq, g_irq;
+	int g_err_irq, g_recc_irq;
 	bool fdmode = true;			/* CAN FD only mode - default */
+	enum rcanfd_chip_id chip_id;
+
+	chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
 		fdmode = false;			/* Classical CAN only mode */
@@ -1649,16 +1776,30 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	if (of_child && of_device_is_available(of_child))
 		channels_mask |= BIT(1);	/* Channel 1 */
 
-	ch_irq = platform_get_irq(pdev, 0);
-	if (ch_irq < 0) {
-		err = ch_irq;
-		goto fail_dev;
-	}
+	if (chip_id == RENESAS_RCAR_GEN3) {
+		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
+		if (ch_irq < 0) {
+			/* For backward compatibility get irq by index */
+			ch_irq = platform_get_irq(pdev, 0);
+			if (ch_irq < 0)
+				return ch_irq;
+		}
 
-	g_irq = platform_get_irq(pdev, 1);
-	if (g_irq < 0) {
-		err = g_irq;
-		goto fail_dev;
+		g_irq = platform_get_irq_byname_optional(pdev, "g_int");
+		if (g_irq < 0) {
+			/* For backward compatibility get irq by index */
+			g_irq = platform_get_irq(pdev, 1);
+			if (g_irq < 0)
+				return g_irq;
+		}
+	} else {
+		g_err_irq = platform_get_irq_byname(pdev, "g_err");
+		if (g_err_irq < 0)
+			return g_err_irq;
+
+		g_recc_irq = platform_get_irq_byname(pdev, "g_recc");
+		if (g_recc_irq < 0)
+			return g_recc_irq;
 	}
 
 	/* Global controller context */
@@ -1670,6 +1811,19 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->pdev = pdev;
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
+	gpriv->chip_id = chip_id;
+
+	if (gpriv->chip_id == RENESAS_RZG2L) {
+		gpriv->rstc1 = devm_reset_control_get_exclusive(&pdev->dev, "rstp_n");
+		if (IS_ERR(gpriv->rstc1))
+			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc1),
+					     "failed to get rstp_n\n");
+
+		gpriv->rstc2 = devm_reset_control_get_exclusive(&pdev->dev, "rstc_n");
+		if (IS_ERR(gpriv->rstc2))
+			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc2),
+					     "failed to get rstc_n\n");
+	}
 
 	/* Peripheral clock */
 	gpriv->clkp = devm_clk_get(&pdev->dev, "fck");
@@ -1699,7 +1853,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 	fcan_freq = clk_get_rate(gpriv->can_clk);
 
-	if (gpriv->fcan == RCANFD_CANFDCLK)
+	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id == RENESAS_RCAR_GEN3)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
@@ -1711,20 +1865,51 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	err = devm_request_irq(&pdev->dev, ch_irq,
-			       rcar_canfd_channel_interrupt, 0,
-			       "canfd.chn", gpriv);
-	if (err) {
-		dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
-			ch_irq, err);
-		goto fail_dev;
+	if (gpriv->chip_id == RENESAS_RCAR_GEN3) {
+		err = devm_request_irq(&pdev->dev, ch_irq,
+				       rcar_canfd_channel_interrupt, 0,
+				       "canfd.ch_int", gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				ch_irq, err);
+			goto fail_dev;
+		}
+
+		err = devm_request_irq(&pdev->dev, g_irq,
+				       rcar_canfd_global_interrupt, 0,
+				       "canfd.g_int", gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				g_irq, err);
+			goto fail_dev;
+		}
+	} else {
+		err = devm_request_irq(&pdev->dev, g_recc_irq,
+				       rcar_canfd_global_receive_fifo_interrupt, 0,
+				       "canfd.g_recc", gpriv);
+
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				g_recc_irq, err);
+			goto fail_dev;
+		}
+
+		err = devm_request_irq(&pdev->dev, g_err_irq,
+				       rcar_canfd_global_err_interrupt, 0,
+				       "canfd.g_err", gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				g_err_irq, err);
+			goto fail_dev;
+		}
 	}
-	err = devm_request_irq(&pdev->dev, g_irq,
-			       rcar_canfd_global_interrupt, 0,
-			       "canfd.gbl", gpriv);
+
+	err = reset_control_reset(gpriv->rstc1);
+	if (err)
+		goto fail_dev;
+	err = reset_control_reset(gpriv->rstc2);
 	if (err) {
-		dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
-			g_irq, err);
+		reset_control_assert(gpriv->rstc1);
 		goto fail_dev;
 	}
 
@@ -1733,7 +1918,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"failed to enable peripheral clock, error %d\n", err);
-		goto fail_dev;
+		goto fail_reset;
 	}
 
 	err = rcar_canfd_reset_controller(gpriv);
@@ -1790,6 +1975,9 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	rcar_canfd_disable_global_interrupts(gpriv);
 fail_clk:
 	clk_disable_unprepare(gpriv->clkp);
+fail_reset:
+	reset_control_assert(gpriv->rstc1);
+	reset_control_assert(gpriv->rstc2);
 fail_dev:
 	return err;
 }
@@ -1810,6 +1998,9 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
 	clk_disable_unprepare(gpriv->clkp);
+	reset_control_assert(gpriv->rstc1);
+	reset_control_assert(gpriv->rstc2);
+
 	return 0;
 }
 
@@ -1827,7 +2018,8 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
 			 rcar_canfd_resume);
 
 static const struct of_device_id rcar_canfd_of_table[] = {
-	{ .compatible = "renesas,rcar-gen3-canfd" },
+	{ .compatible = "renesas,rcar-gen3-canfd", .data = (void *)RENESAS_RCAR_GEN3 },
+	{ .compatible = "renesas,rzg2l-canfd", .data = (void *)RENESAS_RZG2L },
 	{ }
 };
 
-- 
2.32.0


