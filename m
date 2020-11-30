Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774E22C8672
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgK3OQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgK3OQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:16:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3CFC061A53
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjx2-0007kN-4U
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 432DD59FB2C
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7732059FAD4;
        Mon, 30 Nov 2020 14:14:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ee4a60c9;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>
Subject: [net-next 09/14] can: tcan4x5x: remove mram_start and reg_offset from struct tcan4x5x_priv
Date:   Mon, 30 Nov 2020 15:14:27 +0100
Message-Id: <20201130141432.278219-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both struct tcan4x5x_priv::mram_start and struct tcan4x5x_priv::reg_offset are
only assigned once with a constant and then always used read-only. This patch
changes the driver to use the constant directly instead.

Link: https://lore.kernel.org/r/20201130133713.269256-2-mkl@pengutronix.de
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index a2144bbcd486..04bb392f60fa 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -123,10 +123,6 @@ struct tcan4x5x_priv {
 	struct gpio_desc *device_wake_gpio;
 	struct gpio_desc *device_state_gpio;
 	struct regulator *power;
-
-	/* Register based ip */
-	int mram_start;
-	int reg_offset;
 };
 
 static struct can_bittiming_const tcan4x5x_bittiming_const = {
@@ -260,7 +256,7 @@ static u32 tcan4x5x_read_reg(struct m_can_classdev *cdev, int reg)
 	struct tcan4x5x_priv *priv = cdev->device_data;
 	u32 val;
 
-	regmap_read(priv->regmap, priv->reg_offset + reg, &val);
+	regmap_read(priv->regmap, TCAN4X5X_MCAN_OFFSET + reg, &val);
 
 	return val;
 }
@@ -270,7 +266,7 @@ static u32 tcan4x5x_read_fifo(struct m_can_classdev *cdev, int addr_offset)
 	struct tcan4x5x_priv *priv = cdev->device_data;
 	u32 val;
 
-	regmap_read(priv->regmap, priv->mram_start + addr_offset, &val);
+	regmap_read(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, &val);
 
 	return val;
 }
@@ -279,7 +275,7 @@ static int tcan4x5x_write_reg(struct m_can_classdev *cdev, int reg, int val)
 {
 	struct tcan4x5x_priv *priv = cdev->device_data;
 
-	return regmap_write(priv->regmap, priv->reg_offset + reg, val);
+	return regmap_write(priv->regmap, TCAN4X5X_MCAN_OFFSET + reg, val);
 }
 
 static int tcan4x5x_write_fifo(struct m_can_classdev *cdev,
@@ -287,7 +283,7 @@ static int tcan4x5x_write_fifo(struct m_can_classdev *cdev,
 {
 	struct tcan4x5x_priv *priv = cdev->device_data;
 
-	return regmap_write(priv->regmap, priv->mram_start + addr_offset, val);
+	return regmap_write(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, val);
 }
 
 static int tcan4x5x_power_enable(struct regulator *reg, int enable)
@@ -465,8 +461,6 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		goto out_m_can_class_free_dev;
 	}
 
-	priv->reg_offset = TCAN4X5X_MCAN_OFFSET;
-	priv->mram_start = TCAN4X5X_MRAM_START;
 	priv->spi = spi;
 	priv->mcan_dev = mcan_class;
 
-- 
2.29.2


