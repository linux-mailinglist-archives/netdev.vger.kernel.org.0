Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645794C2638
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiBXI3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiBXI3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C51276D78
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:28:43 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9UP-0003v5-Ns
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:28:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1B81C3C334
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:30 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AF6973C2F5;
        Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6932ce59;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 22/36] can: mcp251xfd: mcp251xfd_chip_softreset_check(): wait for OSC ready before accessing chip
Date:   Thu, 24 Feb 2022 09:27:12 +0100
Message-Id: <20220224082726.3000007-23-mkl@pengutronix.de>
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

This patch changes the order of reading the Mode and Oscillator Ready
bits.

Instead of reading the Mode of the chip directly after reset, first
wait for the oscillator to get ready and the chip to fully start up.
Read the Mode after this.

Link: https://lore.kernel.org/all/20220207131047.282110-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 29 ++++++++-----------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f2aac990d285..9b94272da8bc 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -349,34 +349,29 @@ static int mcp251xfd_chip_softreset_do(const struct mcp251xfd_priv *priv)
 
 static int mcp251xfd_chip_softreset_check(const struct mcp251xfd_priv *priv)
 {
-	u32 osc, osc_reference;
+	u32 osc_reference, osc_mask;
 	u8 mode;
 	int err;
 
-	err = mcp251xfd_chip_get_mode(priv, &mode);
-	if (err)
-		return err;
-
-	if (mode != MCP251XFD_REG_CON_MODE_CONFIG) {
-		netdev_info(priv->ndev,
-			    "Controller not in Config Mode after reset, but in %s Mode (%u).\n",
-			    mcp251xfd_get_mode_str(mode), mode);
-		return -ETIMEDOUT;
-	}
-
+	/* Check for reset defaults of OSC reg.
+	 * This will take care of stabilization period.
+	 */
 	osc_reference = MCP251XFD_REG_OSC_OSCRDY |
 		FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
 			   MCP251XFD_REG_OSC_CLKODIV_10);
+	osc_mask = osc_reference | MCP251XFD_REG_OSC_PLLRDY;
+	err = mcp251xfd_chip_wait_for_osc_ready(priv, osc_reference, osc_mask);
+	if (err)
+		return err;
 
-	/* check reset defaults of OSC reg */
-	err = regmap_read(priv->map_reg, MCP251XFD_REG_OSC, &osc);
+	err = mcp251xfd_chip_get_mode(priv, &mode);
 	if (err)
 		return err;
 
-	if (osc != osc_reference) {
+	if (mode != MCP251XFD_REG_CON_MODE_CONFIG) {
 		netdev_info(priv->ndev,
-			    "Controller failed to reset. osc=0x%08x, reference value=0x%08x.\n",
-			    osc, osc_reference);
+			    "Controller not in Config Mode after reset, but in %s Mode (%u).\n",
+			    mcp251xfd_get_mode_str(mode), mode);
 		return -ETIMEDOUT;
 	}
 
-- 
2.34.1


