Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECBF620D09
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiKHKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiKHKTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:19:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B0314D2B
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:19:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1osLhI-0006Lm-KU
        for netdev@vger.kernel.org; Tue, 08 Nov 2022 11:19:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1B346115C94
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 13:32:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 170AE115C74;
        Mon,  7 Nov 2022 13:32:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 555be2db;
        Mon, 7 Nov 2022 13:32:20 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 6/6] can: rcar_canfd: Add missing ECC error checks for channels 2-7
Date:   Mon,  7 Nov 2022 14:32:17 +0100
Message-Id: <20221107133217.59861-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107133217.59861-1-mkl@pengutronix.de>
References: <20221107133217.59861-1-mkl@pengutronix.de>
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

When introducing support for R-Car V3U, which has 8 instead of 2
channels, the ECC error bitmask was extended to take into account the
extra channels, but rcar_canfd_global_error() was not updated to act
upon the extra bits.

Replace the RCANFD_GERFL_EEF[01] macros by a new macro that takes the
channel number, fixing R-Car V3U while simplifying the code.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index d530e986f7fa..b306cf554634 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -81,8 +81,7 @@ enum rcanfd_chip_id {
 
 /* RSCFDnCFDGERFL / RSCFDnGERFL */
 #define RCANFD_GERFL_EEF0_7		GENMASK(23, 16)
-#define RCANFD_GERFL_EEF1		BIT(17)
-#define RCANFD_GERFL_EEF0		BIT(16)
+#define RCANFD_GERFL_EEF(ch)		BIT(16 + (ch))
 #define RCANFD_GERFL_CMPOF		BIT(3)	/* CAN FD only */
 #define RCANFD_GERFL_THLES		BIT(2)
 #define RCANFD_GERFL_MES		BIT(1)
@@ -90,7 +89,7 @@ enum rcanfd_chip_id {
 
 #define RCANFD_GERFL_ERR(gpriv, x) \
 	((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
-			RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
+			RCANFD_GERFL_EEF(0) | RCANFD_GERFL_EEF(1)) | \
 		RCANFD_GERFL_MES | \
 		((gpriv)->fdmode ? RCANFD_GERFL_CMPOF : 0)))
 
@@ -936,12 +935,8 @@ static void rcar_canfd_global_error(struct net_device *ndev)
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
 	gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
-	if ((gerfl & RCANFD_GERFL_EEF0) && (ch == 0)) {
-		netdev_dbg(ndev, "Ch0: ECC Error flag\n");
-		stats->tx_dropped++;
-	}
-	if ((gerfl & RCANFD_GERFL_EEF1) && (ch == 1)) {
-		netdev_dbg(ndev, "Ch1: ECC Error flag\n");
+	if (gerfl & RCANFD_GERFL_EEF(ch)) {
+		netdev_dbg(ndev, "Ch%u: ECC Error flag\n", ch);
 		stats->tx_dropped++;
 	}
 	if (gerfl & RCANFD_GERFL_MES) {
-- 
2.35.1


