Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3D22C6274
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgK0KED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgK0KEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:04:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A2C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 02:04:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kiabh-0007dR-0J
        for netdev@vger.kernel.org; Fri, 27 Nov 2020 11:04:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E465859DE8D
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:03:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2331359DE6A;
        Fri, 27 Nov 2020 10:03:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8b40a735;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Niels Petter <petter@ka-long.de>
Subject: [net 2/6] can: mcp251xfd: mcp251xfd_probe(): bail out if no IRQ was given
Date:   Fri, 27 Nov 2020 11:02:57 +0100
Message-Id: <20201127100301.512603-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127100301.512603-1-mkl@pengutronix.de>
References: <20201127100301.512603-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a check to the mcp251xfd_probe() function to bail out and give
the user a proper error message if no IRQ is specified. Otherwise the driver
will probe just fine but ifup will fail with a meaningless "RTNETLINK answers:
Invalid argument" error message.

Link: https://lore.kernel.org/r/20201123113522.3820052-1-mkl@pengutronix.de
Reported-by: Niels Petter <petter@ka-long.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 9c215f7c5f81..8a39be076e14 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2738,6 +2738,10 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	u32 freq;
 	int err;
 
+	if (!spi->irq)
+		return dev_err_probe(&spi->dev, -ENXIO,
+				     "No IRQ specified (maybe node \"interrupts-extended\" in DT missing)!\n");
+
 	rx_int = devm_gpiod_get_optional(&spi->dev, "microchip,rx-int",
 					 GPIOD_IN);
 	if (PTR_ERR(rx_int) == -EPROBE_DEFER)
-- 
2.29.2


