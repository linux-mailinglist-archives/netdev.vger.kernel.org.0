Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFC768BDF6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjBFNT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBFNSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E255580
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NN-0008Vb-Sj
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D5C74171385
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9E3261712A0;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0807b2ae;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/47] can: rcar_canfd: Fix R-Car V3U CAN mode selection
Date:   Mon,  6 Feb 2023 14:15:40 +0100
Message-Id: <20230206131620.2758724-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

When adding support for R-Car V3U, the Global FD Configuration register
(CFDGFDCFG) and the Channel-specific CAN-FD Configuration Registers
(CFDCmFDCFG) were mixed up.  Use the correct register, and apply the
selected CAN mode to all available channels.

Annotate the corresponding register bits, to make it clear they do
not exist on older variants.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/388ddf312917eb9f6cc460a481f68402a876f9b5.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index f6fa7157b99b..88de17d0bd79 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -197,8 +197,8 @@
 #define RCANFD_DCFG_DBRP(x)		(((x) & 0xff) << 0)
 
 /* RSCFDnCFDCmFDCFG */
-#define RCANFD_FDCFG_CLOE		BIT(30)
-#define RCANFD_FDCFG_FDOE		BIT(28)
+#define RCANFD_V3U_FDCFG_CLOE		BIT(30)
+#define RCANFD_V3U_FDCFG_FDOE		BIT(28)
 #define RCANFD_FDCFG_TDCE		BIT(9)
 #define RCANFD_FDCFG_TDCOC		BIT(8)
 #define RCANFD_FDCFG_TDCO(x)		(((x) & 0x7f) >> 16)
@@ -429,8 +429,8 @@
 #define RCANFD_C_RPGACC(r)		(0x1900 + (0x04 * (r)))
 
 /* R-Car V3U Classical and CAN FD mode specific register map */
-#define RCANFD_V3U_CFDCFG		(0x1314)
 #define RCANFD_V3U_DCFG(m)		(0x1400 + (0x20 * (m)))
+#define RCANFD_V3U_FDCFG(m)		(0x1404 + (0x20 * (m)))
 
 #define RCANFD_V3U_GAFL_OFFSET		(0x1800)
 
@@ -689,12 +689,13 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
 static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
 {
 	if (is_v3u(gpriv)) {
-		if (gpriv->fdmode)
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
-					   RCANFD_FDCFG_FDOE);
-		else
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
-					   RCANFD_FDCFG_CLOE);
+		u32 ch, val = gpriv->fdmode ? RCANFD_V3U_FDCFG_FDOE
+					    : RCANFD_V3U_FDCFG_CLOE;
+
+		for_each_set_bit(ch, &gpriv->channels_mask,
+				 gpriv->info->max_channels)
+			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_FDCFG(ch),
+					   val);
 	} else {
 		if (gpriv->fdmode)
 			rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
-- 
2.39.1


