Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561EA27F32F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbgI3USZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729688AbgI3USZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1495EC0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:25 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYQ-0002Qt-TA; Wed, 30 Sep 2020 22:18:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Kopp <thomas.kopp@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 01/13] can: mcp25xxfd: mcp25xxfd_handle_eccif(): add ECC related errata and update log messages
Date:   Wed, 30 Sep 2020 22:18:04 +0200
Message-Id: <20200930201816.1032054-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Kopp <thomas.kopp@microchip.com>

This patch adds a reference to the recent released MCP2517FD and MCP2518FD
errata sheets and paste the explanation.

The single error correction does not always work, so always indicate that a
single error occurred. If the location of the ECC error is outside of the
TX-RAM always use netdev_notice() to log the problem. For ECC errors in the
TX-RAM, there is a recovery procedure.

Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
Link: https://lore.kernel.org/r/20200925065606.358-1-thomas.kopp@microchip.com
[mkl: split into two patches, adjust subject and commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp25xxfd/mcp25xxfd-core.c    | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
index bd2ba981ae36..106dda8e5310 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
@@ -1973,8 +1973,20 @@ mcp25xxfd_handle_eccif(struct mcp25xxfd_priv *priv, bool set_normal_mode)
 	else
 		return err;
 
+	/* Errata Reference:
+	 * mcp2517fd: DS80000789B, mcp2518fd: DS80000792C 2.
+	 *
+	 * ECC single error correction does not work in all cases:
+	 *
+	 * Fix/Work Around:
+	 * Enable single error correction and double error detection
+	 * interrupts by setting SECIE and DEDIE. Handle SECIF as a
+	 * detection interrupt and do not rely on the error
+	 * correction. Instead, handle both interrupts as a
+	 * notification that the RAM word at ERRADDR was corrupted.
+	 */
 	if (ecc_stat & MCP25XXFD_REG_ECCSTAT_SECIF)
-		msg = "Single ECC Error corrected at address";
+		msg = "Single ECC Error detected at address";
 	else if (ecc_stat & MCP25XXFD_REG_ECCSTAT_DEDIF)
 		msg = "Double ECC Error detected at address";
 	else
@@ -1983,12 +1995,7 @@ mcp25xxfd_handle_eccif(struct mcp25xxfd_priv *priv, bool set_normal_mode)
 	if (!in_tx_ram) {
 		ecc->ecc_stat = 0;
 
-		if (ecc_stat & MCP25XXFD_REG_ECCSTAT_SECIF)
-			netdev_info(priv->ndev, "%s 0x%04x.\n",
-				    msg, addr);
-		else
-			netdev_notice(priv->ndev, "%s 0x%04x.\n",
-				      msg, addr);
+		netdev_notice(priv->ndev, "%s 0x%04x.\n", msg, addr);
 	} else {
 		/* Re-occurring error? */
 		if (ecc->ecc_stat == ecc_stat) {
-- 
2.28.0

