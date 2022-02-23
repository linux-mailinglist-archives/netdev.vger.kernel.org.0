Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B424C1EEB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244711AbiBWWpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244603AbiBWWob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3D517FC
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MO-0006fS-LP
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C49B23BBF4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7FE843BBD8;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2592e12d;
        Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 19/36] can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): factor out into separate function
Date:   Wed, 23 Feb 2022 23:43:15 +0100
Message-Id: <20220223224332.2965690-20-mkl@pengutronix.de>
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

This patch factors out mcp251xfd_chip_wait_for_osc_ready() into a
separate function, it will be used in several places in the next
patches.

Link: https://lore.kernel.org/all/20220207131047.282110-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 45 +++++++++++--------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index e8e736eeb69c..6222633ee7d9 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -246,6 +246,32 @@ mcp251xfd_chip_set_mode_nowait(const struct mcp251xfd_priv *priv,
 	return __mcp251xfd_chip_set_mode(priv, mode_req, true);
 }
 
+static int
+mcp251xfd_chip_wait_for_osc_ready(const struct mcp251xfd_priv *priv,
+				  u32 osc_reference, u32 osc_mask)
+{
+	u32 osc;
+	int err;
+
+	err = regmap_read_poll_timeout(priv->map_reg, MCP251XFD_REG_OSC, osc,
+				       (osc & osc_mask) == osc_reference,
+				       MCP251XFD_OSC_STAB_SLEEP_US,
+				       MCP251XFD_OSC_STAB_TIMEOUT_US);
+	if (mcp251xfd_reg_invalid(osc)) {
+		netdev_err(priv->ndev,
+			   "Failed to detect %s (osc=0x%08x).\n",
+			   mcp251xfd_get_model_str(priv), osc);
+		return -ENODEV;
+	} else if (err == -ETIMEDOUT) {
+		netdev_err(priv->ndev,
+			   "Timeout waiting for Oscillator Ready (osc=0x%08x, osc_reference=0x%08x)\n",
+			   osc, osc_reference);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
 {
 	u32 osc, osc_reference, osc_mask;
@@ -269,24 +295,7 @@ static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
 	if (err)
 		return err;
 
-	/* Wait for "Oscillator Ready" bit */
-	err = regmap_read_poll_timeout(priv->map_reg, MCP251XFD_REG_OSC, osc,
-				       (osc & osc_mask) == osc_reference,
-				       MCP251XFD_OSC_STAB_SLEEP_US,
-				       MCP251XFD_OSC_STAB_TIMEOUT_US);
-	if (mcp251xfd_reg_invalid(osc)) {
-		netdev_err(priv->ndev,
-			   "Failed to detect %s (osc=0x%08x).\n",
-			   mcp251xfd_get_model_str(priv), osc);
-		return -ENODEV;
-	} else if (err == -ETIMEDOUT) {
-		netdev_err(priv->ndev,
-			   "Timeout waiting for Oscillator Ready (osc=0x%08x, osc_reference=0x%08x)\n",
-			   osc, osc_reference);
-		return -ETIMEDOUT;
-	}
-
-	return err;
+	return mcp251xfd_chip_wait_for_osc_ready(priv, osc_reference, osc_mask);
 }
 
 static inline int mcp251xfd_chip_sleep(const struct mcp251xfd_priv *priv)
-- 
2.34.1


