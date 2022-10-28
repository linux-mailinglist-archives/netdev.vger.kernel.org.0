Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39D2610E1F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJ1KKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJ1KKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:10:37 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2374CACA3C
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:10:33 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed10:53a:31ee:412:433f])
        by baptiste.telenet-ops.be with bizsmtp
        id dNAW2800L5LQXpN01NAWpm; Fri, 28 Oct 2022 12:10:31 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ooMJp-001vO6-Tb; Fri, 28 Oct 2022 12:10:29 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ooMGN-00GlS3-RV; Fri, 28 Oct 2022 12:06:55 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] can: rcar_canfd: Add missing ECC error checks for channels 2-7
Date:   Fri, 28 Oct 2022 12:06:45 +0200
Message-Id: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When introducing support for R-Car V3U, which has 8 instead of 2
channels, the ECC error bitmask was extended to take into account the
extra channels, but rcar_canfd_global_error() was not updated to act
upon the extra bits.

Replace the RCANFD_GERFL_EEF[01] macros by a new macro that takes the
channel number, fixing R-Car V3U while simplifying the code.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.

This patch conflicts with "[PATCH v3 6/6] can: rcar_canfd: Add
has_gerfl_eef to struct rcar_canfd_hw_info"[1].  Sorry for that.

[1] https://lore.kernel.org/all/20221027082158.95895-7-biju.das.jz@bp.renesas.com/
---
 drivers/net/can/rcar/rcar_canfd.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 710bd0e9c3c08c02..7cca9b7507cc6805 100644
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
2.25.1

