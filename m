Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18724C1F28
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiBWWyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBWWyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:54:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7B55BC6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:54:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0WZ-0001L6-1f
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:54:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3D4D73BC25
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 033BA3BC08;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 34f25190;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 26/36] can: mcp251xfd: mcp251xfd_chip_clock_init(): prepare for PLL support, wait for OSC ready
Date:   Wed, 23 Feb 2022 23:43:22 +0100
Message-Id: <20220223224332.2965690-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
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

This patch prepares the mcp251xfd_chip_clock_init() function for PLL
support.

If the PLL is needed is must be switched on after chip reset. This
should be done in the mcp251xfd_chip_clock_init() function. Prepare
this function to wait for the OSC and PLL to be ready.

Link: https://lore.kernel.org/all/20220207131047.282110-14-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index d08e0481df35..937424e5ac2b 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -429,7 +429,7 @@ static int mcp251xfd_chip_softreset(const struct mcp251xfd_priv *priv)
 
 static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
 {
-	u32 osc;
+	u32 osc, osc_reference, osc_mask;
 	int err;
 
 	/* Activate Low Power Mode on Oscillator Disable. This only
@@ -439,10 +439,17 @@ static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
 	osc = MCP251XFD_REG_OSC_LPMEN |
 		FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
 			   MCP251XFD_REG_OSC_CLKODIV_10);
+	osc_reference = MCP251XFD_REG_OSC_OSCRDY;
+	osc_mask = MCP251XFD_REG_OSC_OSCRDY | MCP251XFD_REG_OSC_PLLRDY;
+
 	err = regmap_write(priv->map_reg, MCP251XFD_REG_OSC, osc);
 	if (err)
 		return err;
 
+	err = mcp251xfd_chip_wait_for_osc_ready(priv, osc_reference, osc_mask);
+	if (err)
+		return err;
+
 	return 0;
 }
 
-- 
2.34.1


