Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9614919E7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346155AbiARC5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345317AbiARCs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:48:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA623C0612E7;
        Mon, 17 Jan 2022 18:39:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DCA0B81233;
        Tue, 18 Jan 2022 02:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D25CC36AF2;
        Tue, 18 Jan 2022 02:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473595;
        bh=3w3V3ArjONE7l5UZiyh1UENmXpAEzIWTYG+g7uhb9YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4ssHZAlqjO8Muz6UU+DeDyEJb07+0qEApPKfRmnAJ8e8zgEwNnwBnkGSmtmOjXOO
         GD+c+Xj7Ip6XGuSNaj6IuhEajL9PmwPNiwGUYk3JJwAjEwIcTPoyuOkUsGTpDzYmHd
         R2hCFbXjVN1urEkpizz7z5zXNFGIG75a9gZYhzd9ULDsY9x6X8PbqE8UobjUOu9pFo
         Da1CMAxE/bITvip73rGYRxiyb6rBI3wwkLv1GgaxP0z/fw7efwPSxLmf+rdnZaCskS
         mr3Z9LVVxu4FfK0LCL/acZ26a5SrcgkMruHdUiumq4RUEm+XHfntD7du5Fc9Sdp31n
         l4oZlbLEX75qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 184/188] can: flexcan: allow to change quirks at runtime
Date:   Mon, 17 Jan 2022 21:31:48 -0500
Message-Id: <20220118023152.1948105-184-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 01bb4dccd92b4dc21f6af3312e5696924e371111 ]

This is a preparation patch for the upcoming support to change the
rx-rtr capability via the ethtool API.

Link: https://lore.kernel.org/all/20220107193105.1699523-3-mkl@pengutronix.de
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 54 +++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 7734229aa0788..3178557e40208 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -365,7 +365,7 @@ struct flexcan_priv {
 
 	struct clk *clk_ipg;
 	struct clk *clk_per;
-	const struct flexcan_devtype_data *devtype_data;
+	struct flexcan_devtype_data devtype_data;
 	struct regulator *reg_xceiver;
 	struct flexcan_stop_mode stm;
 
@@ -596,7 +596,7 @@ static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 	priv->write(reg_mcr, &regs->mcr);
 
 	/* enable stop request */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
 		ret = flexcan_stop_mode_enable_scfw(priv, true);
 		if (ret < 0)
 			return ret;
@@ -615,7 +615,7 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 	int ret;
 
 	/* remove stop request */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) {
 		ret = flexcan_stop_mode_enable_scfw(priv, false);
 		if (ret < 0)
 			return ret;
@@ -1018,7 +1018,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 
 	mb = flexcan_get_mb(priv, n);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		u32 code;
 
 		do {
@@ -1083,7 +1083,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	}
 
  mark_as_read:
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
 		flexcan_write64(priv, FLEXCAN_IFLAG_MB(n), &regs->iflag1);
 	else
 		priv->write(FLEXCAN_IFLAG_RX_FIFO_AVAILABLE, &regs->iflag1);
@@ -1109,7 +1109,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	enum can_state last_state = priv->can.state;
 
 	/* reception interrupt */
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		u64 reg_iflag_rx;
 		int ret;
 
@@ -1169,7 +1169,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 
 	/* state change interrupt or broken error state quirk fix is enabled */
 	if ((reg_esr & FLEXCAN_ESR_ERR_STATE) ||
-	    (priv->devtype_data->quirks & (FLEXCAN_QUIRK_BROKEN_WERR_STATE |
+	    (priv->devtype_data.quirks & (FLEXCAN_QUIRK_BROKEN_WERR_STATE |
 					   FLEXCAN_QUIRK_BROKEN_PERR_STATE)))
 		flexcan_irq_state(dev, reg_esr);
 
@@ -1191,11 +1191,11 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
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
@@ -2181,9 +2181,10 @@ static int flexcan_probe(struct platform_device *pdev)
 	dev->flags |= IFF_ECHO;
 
 	priv = netdev_priv(dev);
+	priv->devtype_data = *devtype_data;
 
 	if (of_property_read_bool(pdev->dev.of_node, "big-endian") ||
-	    devtype_data->quirks & FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN) {
+	    priv->devtype_data.quirks & FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN) {
 		priv->read = flexcan_read_be;
 		priv->write = flexcan_write_be;
 	} else {
@@ -2202,10 +2203,9 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->clk_ipg = clk_ipg;
 	priv->clk_per = clk_per;
 	priv->clk_src = clk_src;
-	priv->devtype_data = devtype_data;
 	priv->reg_xceiver = reg_xceiver;
 
-	if (devtype_data->quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_NR_IRQ_3) {
 		priv->irq_boff = platform_get_irq(pdev, 1);
 		if (priv->irq_boff <= 0) {
 			err = -ENODEV;
@@ -2218,7 +2218,7 @@ static int flexcan_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
 			CAN_CTRLMODE_FD_NON_ISO;
 		priv->can.bittiming_const = &flexcan_fd_bittiming_const;
-- 
2.34.1

