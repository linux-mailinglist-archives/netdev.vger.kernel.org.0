Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08494C1F06
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbiBWWpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244628AbiBWWoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913113F324
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MV-0006oN-NY
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:55 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9930E3BC48
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1C5383BC13;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 50914cce;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Magnus=20Aagaard=20S=C3=B8rensen?= 
        <mas@csselectronics.com>
Subject: [PATCH net-next 28/36] can: mcp251xfd: add support for internal PLL
Date:   Wed, 23 Feb 2022 23:43:24 +0100
Message-Id: <20220223224332.2965690-29-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PLL is enabled if the configured clock is less than or equal to 10 times
the max clock frequency.

The device will operate with two different SPI speeds. A slow speed determined
by the clock without the PLL enabled, and a fast speed derived from the
frequency with the PLL enabled.

Link: https://lore.kernel.org/all/20220207131047.282110-16-mkl@pengutronix.de
Link: https://lore.kernel.org/all/20201015124401.2766-3-mas@csselectronics.com
Co-developed-by: Magnus Aagaard Sørensen <mas@csselectronics.com>
Signed-off-by: Magnus Aagaard Sørensen <mas@csselectronics.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 88 +++++++++++++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  7 +-
 2 files changed, 75 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 1086c8974f89..e5641696cdc2 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -326,8 +326,13 @@ static int mcp251xfd_chip_wake(const struct mcp251xfd_priv *priv)
 	 */
 	osc = FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
 			 MCP251XFD_REG_OSC_CLKODIV_10);
+
+	/* We cannot check for the PLL ready bit (either set or
+	 * unset), as the PLL might be enabled. This can happen if the
+	 * system reboots, while the mcp251xfd stays powered.
+	 */
 	osc_reference = MCP251XFD_REG_OSC_OSCRDY;
-	osc_mask = MCP251XFD_REG_OSC_OSCRDY | MCP251XFD_REG_OSC_PLLRDY;
+	osc_mask = MCP251XFD_REG_OSC_OSCRDY;
 
 	/* If the controller is in Sleep Mode the following write only
 	 * removes the "Oscillator Disable" bit and powers it up. All
@@ -346,6 +351,21 @@ static int mcp251xfd_chip_wake(const struct mcp251xfd_priv *priv)
 
 static inline int mcp251xfd_chip_sleep(const struct mcp251xfd_priv *priv)
 {
+	if (priv->pll_enable) {
+		u32 osc;
+		int err;
+
+		/* Turn off PLL */
+		osc = FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
+				 MCP251XFD_REG_OSC_CLKODIV_10);
+		err = regmap_write(priv->map_reg, MCP251XFD_REG_OSC, osc);
+		if (err)
+			netdev_err(priv->ndev,
+				   "Failed to disable PLL.\n");
+
+		priv->spi->max_speed_hz = priv->spi_max_speed_hz_slow;
+	}
+
 	return mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
 }
 
@@ -442,6 +462,11 @@ static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
 	osc_reference = MCP251XFD_REG_OSC_OSCRDY;
 	osc_mask = MCP251XFD_REG_OSC_OSCRDY | MCP251XFD_REG_OSC_PLLRDY;
 
+	if (priv->pll_enable) {
+		osc |= MCP251XFD_REG_OSC_PLLEN;
+		osc_reference |= MCP251XFD_REG_OSC_PLLRDY;
+	}
+
 	err = regmap_write(priv->map_reg, MCP251XFD_REG_OSC, osc);
 	if (err)
 		return err;
@@ -450,6 +475,8 @@ static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
 	if (err)
 		return err;
 
+	priv->spi->max_speed_hz = priv->spi_max_speed_hz_fast;
+
 	return 0;
 }
 
@@ -1692,8 +1719,9 @@ static int mcp251xfd_register_check_rx_int(struct mcp251xfd_priv *priv)
 }
 
 static int
-mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv,
-			      u32 *dev_id, u32 *effective_speed_hz)
+mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv, u32 *dev_id,
+			      u32 *effective_speed_hz_slow,
+			      u32 *effective_speed_hz_fast)
 {
 	struct mcp251xfd_map_buf_nocrc *buf_rx;
 	struct mcp251xfd_map_buf_nocrc *buf_tx;
@@ -1712,16 +1740,20 @@ mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv,
 
 	xfer[0].tx_buf = buf_tx;
 	xfer[0].len = sizeof(buf_tx->cmd);
+	xfer[0].speed_hz = priv->spi_max_speed_hz_slow;
 	xfer[1].rx_buf = buf_rx->data;
 	xfer[1].len = sizeof(dev_id);
+	xfer[1].speed_hz = priv->spi_max_speed_hz_fast;
 
 	mcp251xfd_spi_cmd_read_nocrc(&buf_tx->cmd, MCP251XFD_REG_DEVID);
+
 	err = spi_sync_transfer(priv->spi, xfer, ARRAY_SIZE(xfer));
 	if (err)
 		goto out_kfree_buf_tx;
 
 	*dev_id = be32_to_cpup((__be32 *)buf_rx->data);
-	*effective_speed_hz = xfer->effective_speed_hz;
+	*effective_speed_hz_slow = xfer[0].effective_speed_hz;
+	*effective_speed_hz_fast = xfer[1].effective_speed_hz;
 
  out_kfree_buf_tx:
 	kfree(buf_tx);
@@ -1737,34 +1769,45 @@ mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv,
 static int
 mcp251xfd_register_done(const struct mcp251xfd_priv *priv)
 {
-	u32 dev_id, effective_speed_hz;
+	u32 dev_id, effective_speed_hz_slow, effective_speed_hz_fast;
+	unsigned long clk_rate;
 	int err;
 
 	err = mcp251xfd_register_get_dev_id(priv, &dev_id,
-					    &effective_speed_hz);
+					    &effective_speed_hz_slow,
+					    &effective_speed_hz_fast);
 	if (err)
 		return err;
 
+	clk_rate = clk_get_rate(priv->clk);
+
 	netdev_info(priv->ndev,
-		    "%s rev%lu.%lu (%cRX_INT %cMAB_NO_WARN %cCRC_REG %cCRC_RX %cCRC_TX %cECC %cHD c:%u.%02uMHz m:%u.%02uMHz r:%u.%02uMHz e:%u.%02uMHz) successfully initialized.\n",
+		    "%s rev%lu.%lu (%cRX_INT %cPLL %cMAB_NO_WARN %cCRC_REG %cCRC_RX %cCRC_TX %cECC %cHD o:%lu.%02luMHz c:%u.%02uMHz m:%u.%02uMHz rs:%u.%02uMHz es:%u.%02uMHz rf:%u.%02uMHz ef:%u.%02uMHz) successfully initialized.\n",
 		    mcp251xfd_get_model_str(priv),
 		    FIELD_GET(MCP251XFD_REG_DEVID_ID_MASK, dev_id),
 		    FIELD_GET(MCP251XFD_REG_DEVID_REV_MASK, dev_id),
 		    priv->rx_int ? '+' : '-',
+		    priv->pll_enable ? '+' : '-',
 		    MCP251XFD_QUIRK_ACTIVE(MAB_NO_WARN),
 		    MCP251XFD_QUIRK_ACTIVE(CRC_REG),
 		    MCP251XFD_QUIRK_ACTIVE(CRC_RX),
 		    MCP251XFD_QUIRK_ACTIVE(CRC_TX),
 		    MCP251XFD_QUIRK_ACTIVE(ECC),
 		    MCP251XFD_QUIRK_ACTIVE(HALF_DUPLEX),
+		    clk_rate / 1000000,
+		    clk_rate % 1000000 / 1000 / 10,
 		    priv->can.clock.freq / 1000000,
 		    priv->can.clock.freq % 1000000 / 1000 / 10,
 		    priv->spi_max_speed_hz_orig / 1000000,
 		    priv->spi_max_speed_hz_orig % 1000000 / 1000 / 10,
-		    priv->spi->max_speed_hz / 1000000,
-		    priv->spi->max_speed_hz % 1000000 / 1000 / 10,
-		    effective_speed_hz / 1000000,
-		    effective_speed_hz % 1000000 / 1000 / 10);
+		    priv->spi_max_speed_hz_slow / 1000000,
+		    priv->spi_max_speed_hz_slow % 1000000 / 1000 / 10,
+		    effective_speed_hz_slow / 1000000,
+		    effective_speed_hz_slow % 1000000 / 1000 / 10,
+		    priv->spi_max_speed_hz_fast / 1000000,
+		    priv->spi_max_speed_hz_fast % 1000000 / 1000 / 10,
+		    effective_speed_hz_fast / 1000000,
+		    effective_speed_hz_fast % 1000000 / 1000 / 10);
 
 	return 0;
 }
@@ -1891,6 +1934,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	struct gpio_desc *rx_int;
 	struct regulator *reg_vdd, *reg_xceiver;
 	struct clk *clk;
+	bool pll_enable = false;
 	u32 freq = 0;
 	int err;
 
@@ -1941,12 +1985,8 @@ static int mcp251xfd_probe(struct spi_device *spi)
 		return -ERANGE;
 	}
 
-	if (freq <= MCP251XFD_SYSCLOCK_HZ_MAX / MCP251XFD_OSC_PLL_MULTIPLIER) {
-		dev_err(&spi->dev,
-			"Oscillator frequency (%u Hz) is too low and PLL is not supported.\n",
-			freq);
-		return -ERANGE;
-	}
+	if (freq <= MCP251XFD_SYSCLOCK_HZ_MAX / MCP251XFD_OSC_PLL_MULTIPLIER)
+		pll_enable = true;
 
 	ndev = alloc_candev(sizeof(struct mcp251xfd_priv),
 			    MCP251XFD_TX_OBJ_NUM_MAX);
@@ -1962,6 +2002,8 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	priv = netdev_priv(ndev);
 	spi_set_drvdata(spi, priv);
 	priv->can.clock.freq = freq;
+	if (pll_enable)
+		priv->can.clock.freq *= MCP251XFD_OSC_PLL_MULTIPLIER;
 	priv->can.do_set_mode = mcp251xfd_set_mode;
 	priv->can.do_get_berr_counter = mcp251xfd_get_berr_counter;
 	priv->can.bittiming_const = &mcp251xfd_bittiming_const;
@@ -1974,6 +2016,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	priv->spi = spi;
 	priv->rx_int = rx_int;
 	priv->clk = clk;
+	priv->pll_enable = pll_enable;
 	priv->reg_vdd = reg_vdd;
 	priv->reg_xceiver = reg_xceiver;
 
@@ -2011,7 +2054,16 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	 *
 	 */
 	priv->spi_max_speed_hz_orig = spi->max_speed_hz;
-	spi->max_speed_hz = min(spi->max_speed_hz, freq / 2 / 1000 * 850);
+	priv->spi_max_speed_hz_slow = min(spi->max_speed_hz,
+					  freq / 2 / 1000 * 850);
+	if (priv->pll_enable)
+		priv->spi_max_speed_hz_fast = min(spi->max_speed_hz,
+						  freq *
+						  MCP251XFD_OSC_PLL_MULTIPLIER /
+						  2 / 1000 * 850);
+	else
+		priv->spi_max_speed_hz_fast = priv->spi_max_speed_hz_slow;
+	spi->max_speed_hz = priv->spi_max_speed_hz_slow;
 	spi->bits_per_word = 8;
 	spi->rt = true;
 	err = spi_setup(spi);
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index f551c900803e..ded927b4873d 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -2,8 +2,8 @@
  *
  * mcp251xfd - Microchip MCP251xFD Family CAN controller driver
  *
- * Copyright (c) 2019 Pengutronix,
- *                    Marc Kleine-Budde <kernel@pengutronix.de>
+ * Copyright (c) 2019, 2020 Pengutronix,
+ *               Marc Kleine-Budde <kernel@pengutronix.de>
  * Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
  */
 
@@ -592,6 +592,8 @@ struct mcp251xfd_priv {
 
 	struct spi_device *spi;
 	u32 spi_max_speed_hz_orig;
+	u32 spi_max_speed_hz_fast;
+	u32 spi_max_speed_hz_slow;
 
 	struct mcp251xfd_tef_ring tef[1];
 	struct mcp251xfd_tx_ring tx[1];
@@ -608,6 +610,7 @@ struct mcp251xfd_priv {
 
 	struct gpio_desc *rx_int;
 	struct clk *clk;
+	bool pll_enable;
 	struct regulator *reg_vdd;
 	struct regulator *reg_xceiver;
 
-- 
2.34.1


