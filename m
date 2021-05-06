Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B537637504C
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhEFHl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhEFHlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 03:41:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F11C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 00:40:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leYcQ-0003Ca-9i
        for netdev@vger.kernel.org; Thu, 06 May 2021 09:40:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4D2BA61DD82
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:40:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 37A6861DD6F;
        Thu,  6 May 2021 07:40:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5d0cfd0a;
        Thu, 6 May 2021 07:40:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 2/4] can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
Date:   Thu,  6 May 2021 09:40:13 +0200
Message-Id: <20210506074015.1300591-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210506074015.1300591-1-mkl@pengutronix.de>
References: <20210506074015.1300591-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the missing can_rx_offload_del(), that must be called
if mcp251xfd_register() fails.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Link: https://lore.kernel.org/r/20210504091838.1109047-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f122976e90da..e0ae00e34c7b 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2986,10 +2986,12 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
 	err = mcp251xfd_register(priv);
 	if (err)
-		goto out_free_candev;
+		goto out_can_rx_offload_del;
 
 	return 0;
 
+ out_can_rx_offload_del:
+	can_rx_offload_del(&priv->offload);
  out_free_candev:
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 
-- 
2.30.2


