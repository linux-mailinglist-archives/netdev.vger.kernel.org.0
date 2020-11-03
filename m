Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9B2A595D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgKCWHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731396AbgKCWG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4520EC061A4A
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:53 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4S2-0006Ui-F6; Tue, 03 Nov 2020 23:06:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: [net 21/27] can: mcp251xfd: mcp251xfd_regmap_crc_read(): increase severity of CRC read error messages
Date:   Tue,  3 Nov 2020 23:06:30 +0100
Message-Id: <20201103220636.972106-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During debugging it turned out that some people have setups where the SPI
communication is more prone to CRC errors.

Increase the severity of both the transfer retry and transfer failure message
to give users feedback without the need to recompile the driver with debug
enabled.

Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Thomas Kopp <thomas.kopp@microchip.com>
Link: http://lore.kernel.org/r/20201019190524.1285319-15-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
index ba25902dd78c..c9ffc5ea2b25 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -330,17 +330,17 @@ mcp251xfd_regmap_crc_read(void *context,
 			goto out;
 		}
 
-		netdev_dbg(priv->ndev,
-			   "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x) retrying.\n",
-			   reg, val_len, (int)val_len, buf_rx->data,
-			   get_unaligned_be16(buf_rx->data + val_len));
-	}
-
-	if (err) {
 		netdev_info(priv->ndev,
-			    "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x).\n",
+			    "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x) retrying.\n",
 			    reg, val_len, (int)val_len, buf_rx->data,
 			    get_unaligned_be16(buf_rx->data + val_len));
+	}
+
+	if (err) {
+		netdev_err(priv->ndev,
+			   "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x).\n",
+			   reg, val_len, (int)val_len, buf_rx->data,
+			   get_unaligned_be16(buf_rx->data + val_len));
 
 		return err;
 	}
-- 
2.28.0

