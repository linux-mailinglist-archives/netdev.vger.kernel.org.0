Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9214C2628
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiBXIaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiBXI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50374279908
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:29:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9Ul-0004l2-Pe
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:29:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F38013C318
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8FBD03C2DB;
        Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0b3effbf;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/36] can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): improve chip detection and error handling
Date:   Thu, 24 Feb 2022 09:27:10 +0100
Message-Id: <20220224082726.3000007-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224082726.3000007-1-mkl@pengutronix.de>
References: <20220224082726.3000007-1-mkl@pengutronix.de>
MIME-Version: 1.0
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

The function mcp251xfd_chip_wait_for_osc_ready() polls the Oscillator
Control Register for the oscillator to get ready.

This is the first register the driver reads from. Reading implausible
values (all bits set or unset) can be caused by the chip starting up
after power on, waking up after sleep, or by the chip not being preset
at all. Add check for implausible register content
mcp251xfd_reg_invalid() to the regmap_read_poll_timeout() loop.

In case of a regmap_read_poll_timeout() returns a fatal error (and not
a timeout), forward it to the caller.

As mcp251xfd_chip_wait_for_osc_ready() will be called after the probe
function has finished, (currently during ifup), move error message
about failed chip detection from there into the probe function.

Link: https://lore.kernel.org/all/20220207131047.282110-8-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 6222633ee7d9..68518e8410dd 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -254,22 +254,25 @@ mcp251xfd_chip_wait_for_osc_ready(const struct mcp251xfd_priv *priv,
 	int err;
 
 	err = regmap_read_poll_timeout(priv->map_reg, MCP251XFD_REG_OSC, osc,
+				       !mcp251xfd_reg_invalid(osc) &&
 				       (osc & osc_mask) == osc_reference,
 				       MCP251XFD_OSC_STAB_SLEEP_US,
 				       MCP251XFD_OSC_STAB_TIMEOUT_US);
+	if (err != -ETIMEDOUT)
+		return err;
+
 	if (mcp251xfd_reg_invalid(osc)) {
 		netdev_err(priv->ndev,
-			   "Failed to detect %s (osc=0x%08x).\n",
-			   mcp251xfd_get_model_str(priv), osc);
+			   "Failed to read Oscillator Configuration Register (osc=0x%08x).\n",
+			   osc);
 		return -ENODEV;
-	} else if (err == -ETIMEDOUT) {
-		netdev_err(priv->ndev,
-			   "Timeout waiting for Oscillator Ready (osc=0x%08x, osc_reference=0x%08x)\n",
-			   osc, osc_reference);
-		return -ETIMEDOUT;
 	}
 
-	return 0;
+	netdev_err(priv->ndev,
+		   "Timeout waiting for Oscillator Ready (osc=0x%08x, osc_reference=0x%08x)\n",
+		   osc, osc_reference);
+
+	return -ETIMEDOUT;
 }
 
 static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
@@ -1965,8 +1968,11 @@ static int mcp251xfd_probe(struct spi_device *spi)
 		goto out_free_candev;
 
 	err = mcp251xfd_register(priv);
-	if (err)
+	if (err) {
+		dev_err_probe(&spi->dev, err, "Failed to detect %s.\n",
+			      mcp251xfd_get_model_str(priv));
 		goto out_can_rx_offload_del;
+	}
 
 	return 0;
 
-- 
2.34.1


