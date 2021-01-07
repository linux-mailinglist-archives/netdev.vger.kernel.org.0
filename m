Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163392ECD31
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbhAGJvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbhAGJvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDE5C0612A5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:49:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvX-00018W-E5
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:55 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 533B95BBABA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EC0EC5BBA24;
        Thu,  7 Jan 2021 09:49:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fe0cccbc;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 10/19] can: tcan4x5x: tcan4x5x_regmap_init(): use spi as context pointer
Date:   Thu,  7 Jan 2021 10:48:51 +0100
Message-Id: <20210107094900.173046-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the context pointer of the regmap callback functions by a
pointer to the spi_device. This saves one level of indirection in the
callbacks.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-11-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 6345bcb7704f..4d43c145fdec 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -18,8 +18,7 @@ static int tcan4x5x_regmap_gather_write(void *context, const void *reg,
 					size_t reg_len, const void *val,
 					size_t val_len)
 {
-	struct device *dev = context;
-	struct spi_device *spi = to_spi_device(dev);
+	struct spi_device *spi = context;
 	struct spi_message m;
 	u32 addr;
 	struct spi_transfer t[2] = {
@@ -47,8 +46,7 @@ static int tcan4x5x_regmap_read(void *context,
 				const void *reg, size_t reg_size,
 				void *val, size_t val_size)
 {
-	struct device *dev = context;
-	struct spi_device *spi = to_spi_device(dev);
+	struct spi_device *spi = context;
 
 	u32 addr = TCAN4X5X_READ_CMD | (*((u16 *)reg) << 8) | val_size >> 2;
 
@@ -73,6 +71,6 @@ static const struct regmap_bus tcan4x5x_bus = {
 int tcan4x5x_regmap_init(struct tcan4x5x_priv *priv)
 {
 	priv->regmap = devm_regmap_init(&priv->spi->dev, &tcan4x5x_bus,
-					&priv->spi->dev, &tcan4x5x_regmap);
+					priv->spi, &tcan4x5x_regmap);
 	return PTR_ERR_OR_ZERO(priv->regmap);
 }
-- 
2.29.2


