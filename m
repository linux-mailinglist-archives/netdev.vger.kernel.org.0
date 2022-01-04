Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA3484244
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiADNUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiADNUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:20:49 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC78C061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 05:20:48 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z9so78513346edm.10
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 05:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EXTlrEbIep25YMOH2NjvJrmjJ2UQ4ZPPgvCMwstRzYs=;
        b=Je5OInuYwCeuqqid99x8dP/M9nTqswo6/5eTLuMk8CT4+i3OQBQE/Qoy/Cl4//U2sN
         kkHf/HeIw+kfWcuujzZ47uPQ091rGDtwEGvOCcFDkvYbrFSeMjpAiydC+kS8ybJczF25
         h9GIxDTLUB3qIJ+sdkwJ7jvi7j8DVbgk8elPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EXTlrEbIep25YMOH2NjvJrmjJ2UQ4ZPPgvCMwstRzYs=;
        b=AT1ZiLNzBGMUJuRuhCqf+SuW7pXGaok4JdiLSk3gX3InQ4n6E0AMmaXgaeX4NcJL0C
         oSyXu6k0KQmeQs6H2NQJSzXr+CC/XEt5L5qKPCG/Qee09RCFudrQv/Rr+/FVUjuxeaps
         JxLG+4PQKjBxcqe+aVpSCN0M6ugJBYzDorUgcVzc3LpokqN9DA1OMa1RqYBd1US7QXiQ
         xqSEy3mcCVvD9u/00vYR9KjcwXIrOSOhcqh9tXYMHEw7tsnvedwWvZWuD43QBNF4ux+D
         sFur8Mebvh69Xzn9DdRQakni9n/RVgjpnYt4HaqaOYUj/IQRpgQwBFHOVQhQc/khDQDK
         g0HA==
X-Gm-Message-State: AOAM533S4KoKhTsSbDkvUeb179Nnkd+fywhGQrmQUfFludP4ZapYrKnD
        d383P1p9S1YVTE44x2PTVSlCo260SDzX6w==
X-Google-Smtp-Source: ABdhPJyy2wak0di8UXHSfn9aTUQCEuSBkJAzLwhQZG4CzsOfA9RYMiZHN+Berv4lwxN2yp0TG8Sjng==
X-Received: by 2002:a17:906:3052:: with SMTP id d18mr31709177ejd.675.1641302447339;
        Tue, 04 Jan 2022 05:20:47 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-244-92-231.retail.telecomitalia.it. [95.244.92.231])
        by smtp.gmail.com with ESMTPSA id y13sm14765575edq.77.2022.01.04.05.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 05:20:46 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 1/2] can: flexcan: allow to change quirks at runtime
Date:   Tue,  4 Jan 2022 14:20:25 +0100
Message-Id: <20220104132026.3062763-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104132026.3062763-1-dario.binacchi@amarulasolutions.com>
References: <20220104132026.3062763-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch for the upcoming support to ethtool api.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

 drivers/net/can/flexcan.c | 50 +++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 12b60ad95b02..223c32bf1f6c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -369,7 +369,7 @@ struct flexcan_priv {
 
 	struct clk *clk_ipg;
 	struct clk *clk_per;
-	const struct flexcan_devtype_data *devtype_data;
+	struct flexcan_devtype_data devtype_data;
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
 
@@ -600,7 +600,7 @@ static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 	priv->write(reg_mcr, &regs->mcr);
 
 	/* enable stop request */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
 		ret = flexcan_stop_mode_enable_scfw(priv, true);
 		if (ret < 0)
 			return ret;
@@ -619,7 +619,7 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 	int ret;
 
 	/* remove stop request */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
 		ret = flexcan_stop_mode_enable_scfw(priv, false);
 		if (ret < 0)
 			return ret;
@@ -1022,7 +1022,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 
 	mb = flexcan_get_mb(priv, n);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		u32 code;
 
 		do {
@@ -1087,7 +1087,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	}
 
  mark_as_read:
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
 		flexcan_write64(priv, FLEXCAN_IFLAG_MB(n), &regs->iflag1);
 	else
 		priv->write(FLEXCAN_IFLAG_RX_FIFO_AVAILABLE, &regs->iflag1);
@@ -1113,7 +1113,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	enum can_state last_state = priv->can.state;
 
 	/* reception interrupt */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		u64 reg_iflag_rx;
 		int ret;
 
@@ -1173,7 +1173,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 
 	/* state change interrupt or broken error state quirk fix is enabled */
 	if ((reg_esr & FLEXCAN_ESR_ERR_STATE) ||
-	    (priv->devtype_data->quirks & (FLEXCAN_QUIRK_BROKEN_WERR_STATE |
+	    (priv->devtype_data.quirks & (FLEXCAN_QUIRK_BROKEN_WERR_STATE |
 					   FLEXCAN_QUIRK_BROKEN_PERR_STATE)))
 		flexcan_irq_state(dev, reg_esr);
 
@@ -1195,11 +1195,11 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	 * (1): enabled if FLEXCAN_QUIRK_BROKEN_WERR_STATE is enabled
 	 */
 	if ((last_state != priv->can.state) &&
-	    (priv->devtype_data->quirks & FLEXCAN_QUIRK_BROKEN_PERR_STATE) &&
+	    (priv->devtype_data.quirks & FLEXCAN_QUIRK_BROKEN_PERR_STATE) &&
 	    !(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)) {
 		switch (priv->can.state) {
 		case CAN_STATE_ERROR_ACTIVE:
-			if (priv->devtype_data->quirks &
+			if (priv->devtype_data.quirks &
 			    FLEXCAN_QUIRK_BROKEN_WERR_STATE)
 				flexcan_error_irq_enable(priv);
 			else
@@ -1423,13 +1423,13 @@ static int flexcan_rx_offload_setup(struct net_device *dev)
 	else
 		priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_NR_MB_16)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_NR_MB_16)
 		priv->mb_count = 16;
 	else
 		priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
 				 (sizeof(priv->regs->mb[1]) / priv->mb_size);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
 		priv->tx_mb_reserved =
 			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP);
 	else
@@ -1441,7 +1441,7 @@ static int flexcan_rx_offload_setup(struct net_device *dev)
 
 	priv->offload.mailbox_read = flexcan_mailbox_read;
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		priv->offload.mb_first = FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST;
 		priv->offload.mb_last = priv->mb_count - 2;
 
@@ -1506,7 +1506,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_ECC)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SUPPORT_ECC)
 		flexcan_ram_init(dev);
 
 	flexcan_set_bittiming(dev);
@@ -1535,7 +1535,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	 * - disable for timestamp mode
 	 * - enable for FIFO mode
 	 */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
 		reg_mcr &= ~FLEXCAN_MCR_FEN;
 	else
 		reg_mcr |= FLEXCAN_MCR_FEN;
@@ -1586,7 +1586,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	 * on most Flexcan cores, too. Otherwise we don't get
 	 * any error warning or passive interrupts.
 	 */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_BROKEN_WERR_STATE ||
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_BROKEN_WERR_STATE ||
 	    priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
 		reg_ctrl |= FLEXCAN_CTRL_ERR_MSK;
 	else
@@ -1599,7 +1599,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	priv->write(reg_ctrl, &regs->ctrl);
 
-	if ((priv->devtype_data->quirks & FLEXCAN_QUIRK_ENABLE_EACEN_RRS)) {
+	if ((priv->devtype_data.quirks & FLEXCAN_QUIRK_ENABLE_EACEN_RRS)) {
 		reg_ctrl2 = priv->read(&regs->ctrl2);
 		reg_ctrl2 |= FLEXCAN_CTRL2_EACEN | FLEXCAN_CTRL2_RRS;
 		priv->write(reg_ctrl2, &regs->ctrl2);
@@ -1631,7 +1631,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		priv->write(reg_fdctrl, &regs->fdctrl);
 	}
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		for (i = priv->offload.mb_first; i <= priv->offload.mb_last; i++) {
 			mb = flexcan_get_mb(priv, i);
 			priv->write(FLEXCAN_MB_CODE_RX_EMPTY,
@@ -1659,7 +1659,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	priv->write(0x0, &regs->rx14mask);
 	priv->write(0x0, &regs->rx15mask);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_RXFG)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_DISABLE_RXFG)
 		priv->write(0x0, &regs->rxfgmask);
 
 	/* clear acceptance filters */
@@ -1673,7 +1673,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	 * This also works around errata e5295 which generates false
 	 * positive memory errors and put the device in freeze mode.
 	 */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_DISABLE_MECR) {
 		/* Follow the protocol as described in "Detection
 		 * and Correction of Memory Errors" to write to
 		 * MECR register (step 1 - 5)
@@ -1799,7 +1799,7 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_can_rx_offload_disable;
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
 		err = request_irq(priv->irq_boff,
 				  flexcan_irq, IRQF_SHARED, dev->name, dev);
 		if (err)
@@ -1845,7 +1845,7 @@ static int flexcan_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	flexcan_chip_interrupts_disable(dev);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
 		free_irq(priv->irq_err, dev);
 		free_irq(priv->irq_boff, dev);
 	}
@@ -2051,9 +2051,9 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 	priv = netdev_priv(dev);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW)
 		ret = flexcan_setup_stop_mode_scfw(pdev);
-	else if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR)
+	else if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR)
 		ret = flexcan_setup_stop_mode_gpr(pdev);
 	else
 		/* return 0 directly if doesn't support stop mode feature */
@@ -2202,7 +2202,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->clk_ipg = clk_ipg;
 	priv->clk_per = clk_per;
 	priv->clk_src = clk_src;
-	priv->devtype_data = devtype_data;
+	memcpy(&priv->devtype_data, devtype_data, sizeof(priv->devtype_data));
 	priv->reg_xceiver = reg_xceiver;
 
 	if (devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
@@ -2218,7 +2218,7 @@ static int flexcan_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
+	if (devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
 			CAN_CTRLMODE_FD_NON_ISO;
 		priv->can.bittiming_const = &flexcan_fd_bittiming_const;
-- 
2.32.0

