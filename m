Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585392D57C7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgLJJ6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgLJJ4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:56:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BBEC0611CC
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:55:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1knIfP-00015n-UR
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 10:55:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D09B85AA1D8
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:55:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D955E5AA1AD;
        Thu, 10 Dec 2020 09:55:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b24df1dd;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 7/7] can: mcp251xfd: Add support for internal loopback mode
Date:   Thu, 10 Dec 2020 10:55:07 +0100
Message-Id: <20201210095507.1551220-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210095507.1551220-1-mkl@pengutronix.de>
References: <20201210095507.1551220-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

MCP251xFD supports internal loopback mode which can be used to verify CAN
functionality in the absence of a real CAN device.

Link: https://lore.kernel.org/r/20201201054019.11012-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[mkl: mcp251xfd_get_normal_mode(): move CAN_CTRLMODE_LOOPBACK check to front]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 20cbd5c446f5..77129d5f410b 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -965,7 +965,10 @@ static u8 mcp251xfd_get_normal_mode(const struct mcp251xfd_priv *priv)
 {
 	u8 mode;
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
+		mode = MCP251XFD_REG_CON_MODE_INT_LOOPBACK;
+	else if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		mode = MCP251XFD_REG_CON_MODE_LISTENONLY;
 	else if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
 		mode = MCP251XFD_REG_CON_MODE_MIXED;
@@ -2881,9 +2884,9 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	priv->can.do_get_berr_counter = mcp251xfd_get_berr_counter;
 	priv->can.bittiming_const = &mcp251xfd_bittiming_const;
 	priv->can.data_bittiming_const = &mcp251xfd_data_bittiming_const;
-	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
-		CAN_CTRLMODE_BERR_REPORTING | CAN_CTRLMODE_FD |
-		CAN_CTRLMODE_FD_NON_ISO;
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
+		CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_BERR_REPORTING |
+		CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO;
 	priv->ndev = ndev;
 	priv->spi = spi;
 	priv->rx_int = rx_int;
-- 
2.29.2


