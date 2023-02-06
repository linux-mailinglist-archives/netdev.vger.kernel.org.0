Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ABB68BD9B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjBFNRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBFNRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803FE1DB9B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1My-0007NJ-1B
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:16 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 103A4171393
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:26 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B0CC21712A3;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c1412781;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/47] can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
Date:   Mon,  6 Feb 2023 14:15:41 +0100
Message-Id: <20230206131620.2758724-9-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Each Global Acceptance Filter List Configuration Register (GAFLCFG)
contains two fields, and stores the number of channel rules for one
channel pair.

As R-Car V3U and later can have more than 2 channels, the field
selection should be based on the LSB (even or odd) of the channel
number, instead of on the full channel number.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/36bcf0ffb96d6aaed970751f9546b901af638bcf.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 88de17d0bd79..77b21c82faf3 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -92,10 +92,10 @@
 /* RSCFDnCFDGAFLCFG0 / RSCFDnGAFLCFG0 */
 #define RCANFD_GAFLCFG_SETRNC(gpriv, n, x) \
 	(((x) & reg_v3u(gpriv, 0x1ff, 0xff)) << \
-	 (reg_v3u(gpriv, 16, 24) - (n) * reg_v3u(gpriv, 16, 8)))
+	 (reg_v3u(gpriv, 16, 24) - ((n) & 1) * reg_v3u(gpriv, 16, 8)))
 
 #define RCANFD_GAFLCFG_GETRNC(gpriv, n, x) \
-	(((x) >> (reg_v3u(gpriv, 16, 24) - (n) * reg_v3u(gpriv, 16, 8))) & \
+	(((x) >> (reg_v3u(gpriv, 16, 24) - ((n) & 1) * reg_v3u(gpriv, 16, 8))) & \
 	 reg_v3u(gpriv, 0x1ff, 0xff))
 
 /* RSCFDnCFDGAFLECTR / RSCFDnGAFLECTR */
-- 
2.39.1


