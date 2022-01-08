Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5672F488654
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiAHVoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiAHVoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F9C061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVG-0004NC-Oi
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:43:58 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 68C4D6D3A5A
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:51 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B722E6D3A0E;
        Sat,  8 Jan 2022 21:43:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 684339b3;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/22] can: mcp251xfd: mcp251xfd_handle_rxovif(): denote RX overflow message to debug + add rate limiting
Date:   Sat,  8 Jan 2022 22:43:30 +0100
Message-Id: <20220108214345.1848470-8-mkl@pengutronix.de>
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

A RX overflow usually happens during high system load. Printing
overflow messages to the kernel log, which on embedded systems often
is outputted on the serial console, even increases the system load.

To decrease the system load in these situations, denote the messages
to debug level and wrap them with net_ratelimit().

Link: https://lore.kernel.org/all/20220105154300.1258636-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index a01a3fc3b13c..105426dcf065 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1652,12 +1652,15 @@ static int mcp251xfd_handle_rxovif(struct mcp251xfd_priv *priv)
 
 		/* If SERRIF is active, there was a RX MAB overflow. */
 		if (priv->regs_status.intf & MCP251XFD_REG_INT_SERRIF) {
-			netdev_info(priv->ndev,
-				    "RX-%d: MAB overflow detected.\n",
-				    ring->nr);
+			if (net_ratelimit())
+				netdev_dbg(priv->ndev,
+					   "RX-%d: MAB overflow detected.\n",
+					   ring->nr);
 		} else {
-			netdev_info(priv->ndev,
-				    "RX-%d: FIFO overflow.\n", ring->nr);
+			if (net_ratelimit())
+				netdev_dbg(priv->ndev,
+					   "RX-%d: FIFO overflow.\n",
+					   ring->nr);
 		}
 
 		err = regmap_update_bits(priv->map_reg,
-- 
2.34.1


