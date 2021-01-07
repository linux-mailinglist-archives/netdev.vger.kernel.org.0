Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94B02ECDF7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbhAGKgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbhAGKgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:36:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CB5C0612FE
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 02:35:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxSdB-0008SR-Ju
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 11:35:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2B5315BBCAC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:34:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7FB8C5BBC81;
        Thu,  7 Jan 2021 10:34:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f8826be2;
        Thu, 7 Jan 2021 10:34:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 4/6] can: mcp251xfd: mcp251xfd_handle_rxif_ring(): first increment RX tail pointer in HW, then in driver
Date:   Thu,  7 Jan 2021 11:34:49 +0100
Message-Id: <20210107103451.183477-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107103451.183477-1-mkl@pengutronix.de>
References: <20210107103451.183477-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch fixes a TEF vs. TX race condition, by first updating the TEF
tail pointer in hardware, and then updating the driver internal pointer.

The same pattern exists in the RX-path, too. This should be no problem, as the
driver accesses the RX-FIFO from the interrupt handler only, thus the access is
properly serialized. Fix the order here, too, so that the TEF- and RX-path look
similar.

Fixes: 1f652bb6bae7 ("can: mcp25xxfd: rx-path: reduce number of SPI core requests to set UINC bit")
Link: https://lore.kernel.org/r/20210105214138.3150886-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 85a1a8b7c0e7..36235afb0bc6 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1552,10 +1552,8 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 
 		/* Increment the RX FIFO tail pointer 'len' times in a
 		 * single SPI message.
-		 */
-		ring->tail += len;
-
-		/* Note:
+		 *
+		 * Note:
 		 *
 		 * "cs_change == 1" on the last transfer results in an
 		 * active chip select after the complete SPI
@@ -1571,6 +1569,8 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 		last_xfer->cs_change = 1;
 		if (err)
 			return err;
+
+		ring->tail += len;
 	}
 
 	return 0;
-- 
2.29.2


