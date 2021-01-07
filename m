Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F512ECD4C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbhAGJvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbhAGJvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F44EC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:50:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvg-0001PC-J0
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:50:04 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DC8D35BBAF3
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 313165BBA3C;
        Thu,  7 Jan 2021 09:49:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id eae9bd0f;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 16/19] can: tcan4x5x: add support for half-duplex controllers
Date:   Thu,  7 Jan 2021 10:48:57 +0100
Message-Id: <20210107094900.173046-17-mkl@pengutronix.de>
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

This patch adds back support for half-duplex controllers, which was removed in
the last patch.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-17-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 660e9d87dffb..ca80dbaf7a3f 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -51,7 +51,7 @@ static int tcan4x5x_regmap_read(void *context,
 	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
 	struct tcan4x5x_map_buf *buf_rx = &priv->map_buf_rx;
 	struct tcan4x5x_map_buf *buf_tx = &priv->map_buf_tx;
-	struct spi_transfer xfer[] = {
+	struct spi_transfer xfer[2] = {
 		{
 			.tx_buf = buf_tx,
 		}
@@ -66,17 +66,26 @@ static int tcan4x5x_regmap_read(void *context,
 	       sizeof(buf_tx->cmd.addr));
 	tcan4x5x_spi_cmd_set_len(&buf_tx->cmd, val_len);
 
-	xfer[0].rx_buf = buf_rx;
-	xfer[0].len = sizeof(buf_tx->cmd) + val_len;
+	if (spi->controller->flags & SPI_CONTROLLER_HALF_DUPLEX) {
+		xfer[0].len = sizeof(buf_tx->cmd);
+
+		xfer[1].rx_buf = val_buf;
+		xfer[1].len = val_len;
+		spi_message_add_tail(&xfer[1], &msg);
+	} else {
+		xfer[0].rx_buf = buf_rx;
+		xfer[0].len = sizeof(buf_tx->cmd) + val_len;
 
-	if (TCAN4X5X_SANITIZE_SPI)
-		memset(buf_tx->data, 0x0, val_len);
+		if (TCAN4X5X_SANITIZE_SPI)
+			memset(buf_tx->data, 0x0, val_len);
+	}
 
 	err = spi_sync(spi, &msg);
 	if (err)
 		return err;
 
-	memcpy(val_buf, buf_rx->data, val_len);
+	if (!(spi->controller->flags & SPI_CONTROLLER_HALF_DUPLEX))
+		memcpy(val_buf, buf_rx->data, val_len);
 
 	return 0;
 }
-- 
2.29.2


