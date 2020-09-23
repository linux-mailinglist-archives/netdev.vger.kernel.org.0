Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302F62753D3
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIWIy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgIWIy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C610C061755
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:28 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xi-0000uS-4J; Wed, 23 Sep 2020 10:54:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 09/20] can: flexcan: add correctable errors correction when HW supports ECC
Date:   Wed, 23 Sep 2020 10:54:07 +0200
Message-Id: <20200923085418.2685858-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923085418.2685858-1-mkl@pengutronix.de>
References: <20200923085418.2685858-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
From above commit by Stefan Agner, the patch just disables
non-correctable errors interrupt and freeze mode. It still can correct
the correctable errors since ECC enabled by default after reset (MECR[ECCDIS]=0,
enable memory error correct) if HW supports ECC.

commit 5e269324db5a ("can: flexcan: disable completely the ECC mechanism")
From above commit by Joakim Zhang, the patch disables ECC completely (assert
MECR[ECCDIS]) according to the explanation of FLEXCAN_QUIRK_DISABLE_MECR that
disable memory error detection. This cause correctable errors cannot be
corrected even HW supports ECC.

The error correction mechanism ensures that in this 13-bit word, errors
in one bit can be corrected (correctable errors) and errors in two bits can
be detected but not corrected (non-correctable errors). Errors in more than
two bits may not be detected.

If HW supports ECC, we can use this to correct the correctable errors detected
from FlexCAN memory. Then disable non-correctable errors interrupt and freeze
mode to avoid that put FlexCAN in freeze mode.

This patch adds correctable errors correction when HW supports ECC, and
modify explanation for FLEXCAN_QUIRK_DISABLE_MECR.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20200416093126.15242-1-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 5c6903e23c01..52d73115c7fd 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -190,7 +190,7 @@
 #define FLEXCAN_QUIRK_DISABLE_RXFG BIT(2)
 /* Enable EACEN and RRS bit in ctrl2 */
 #define FLEXCAN_QUIRK_ENABLE_EACEN_RRS  BIT(3)
-/* Disable Memory error detection */
+/* Disable non-correctable errors interrupt and freeze mode */
 #define FLEXCAN_QUIRK_DISABLE_MECR BIT(4)
 /* Use timestamp based offloading */
 #define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP BIT(5)
@@ -1221,28 +1221,43 @@ static int flexcan_chip_start(struct net_device *dev)
 	for (i = 0; i < priv->mb_count; i++)
 		priv->write(0, &regs->rximr[i]);
 
-	/* On Vybrid, disable memory error detection interrupts
-	 * and freeze mode.
-	 * This also works around errata e5295 which generates
-	 * false positive memory errors and put the device in
-	 * freeze mode.
+	/* On Vybrid, disable non-correctable errors interrupt and
+	 * freeze mode. It still can correct the correctable errors
+	 * when HW supports ECC.
+	 *
+	 * This also works around errata e5295 which generates false
+	 * positive memory errors and put the device in freeze mode.
 	 */
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR) {
 		/* Follow the protocol as described in "Detection
 		 * and Correction of Memory Errors" to write to
-		 * MECR register
+		 * MECR register (step 1 - 5)
+		 *
+		 * 1. By default, CTRL2[ECRWRE] = 0, MECR[ECRWRDIS] = 1
+		 * 2. set CTRL2[ECRWRE]
 		 */
 		reg_ctrl2 = priv->read(&regs->ctrl2);
 		reg_ctrl2 |= FLEXCAN_CTRL2_ECRWRE;
 		priv->write(reg_ctrl2, &regs->ctrl2);
 
+		/* 3. clear MECR[ECRWRDIS] */
 		reg_mecr = priv->read(&regs->mecr);
 		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
 		priv->write(reg_mecr, &regs->mecr);
-		reg_mecr |= FLEXCAN_MECR_ECCDIS;
+
+		/* 4. all writes to MECR must keep MECR[ECRWRDIS] cleared */
 		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		priv->write(reg_mecr, &regs->mecr);
+
+		/* 5. after configuration done, lock MECR by either
+		 * setting MECR[ECRWRDIS] or clearing CTRL2[ECRWRE]
+		 */
+		reg_mecr |= FLEXCAN_MECR_ECRWRDIS;
+		priv->write(reg_mecr, &regs->mecr);
+
+		reg_ctrl2 &= ~FLEXCAN_CTRL2_ECRWRE;
+		priv->write(reg_ctrl2, &regs->ctrl2);
 	}
 
 	err = flexcan_transceiver_enable(priv);
-- 
2.28.0

