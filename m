Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D76E514A0D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359619AbiD2M7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359599AbiD2M7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:59:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CA8A94FD
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 05:56:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nkQAU-0000Ag-9e
        for netdev@vger.kernel.org; Fri, 29 Apr 2022 14:56:18 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 385A170F0C
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:56:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EBFAB70EEF;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e38266ba;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Andreas Larsson <andreas@gaisler.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 5/5] can: grcan: only use the NAPI poll budget for RX
Date:   Fri, 29 Apr 2022 14:56:12 +0200
Message-Id: <20220429125612.1792561-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429125612.1792561-1-mkl@pengutronix.de>
References: <20220429125612.1792561-1-mkl@pengutronix.de>
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

From: Andreas Larsson <andreas@gaisler.com>

The previous split budget between TX and RX made it return not using
the entire budget but at the same time not having calling called
napi_complete. This sometimes led to the poll to not be called, and at
the same time having TX and RX interrupts disabled resulting in the
driver getting stuck.

Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Link: https://lore.kernel.org/all/20220429084656.29788-4-andreas@gaisler.com
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/grcan.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 4ca3da56d3aa..5215bd9b2c80 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1125,7 +1125,7 @@ static int grcan_close(struct net_device *dev)
 	return 0;
 }
 
-static int grcan_transmit_catch_up(struct net_device *dev, int budget)
+static void grcan_transmit_catch_up(struct net_device *dev)
 {
 	struct grcan_priv *priv = netdev_priv(dev);
 	unsigned long flags;
@@ -1133,7 +1133,7 @@ static int grcan_transmit_catch_up(struct net_device *dev, int budget)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	work_done = catch_up_echo_skb(dev, budget, true);
+	work_done = catch_up_echo_skb(dev, -1, true);
 	if (work_done) {
 		if (!priv->resetting && !priv->closing &&
 		    !(priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
@@ -1147,8 +1147,6 @@ static int grcan_transmit_catch_up(struct net_device *dev, int budget)
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return work_done;
 }
 
 static int grcan_receive(struct net_device *dev, int budget)
@@ -1230,19 +1228,13 @@ static int grcan_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = priv->dev;
 	struct grcan_registers __iomem *regs = priv->regs;
 	unsigned long flags;
-	int tx_work_done, rx_work_done;
-	int rx_budget = budget / 2;
-	int tx_budget = budget - rx_budget;
+	int work_done;
 
-	/* Half of the budget for receiving messages */
-	rx_work_done = grcan_receive(dev, rx_budget);
+	work_done = grcan_receive(dev, budget);
 
-	/* Half of the budget for transmitting messages as that can trigger echo
-	 * frames being received
-	 */
-	tx_work_done = grcan_transmit_catch_up(dev, tx_budget);
+	grcan_transmit_catch_up(dev);
 
-	if (rx_work_done < rx_budget && tx_work_done < tx_budget) {
+	if (work_done < budget) {
 		napi_complete(napi);
 
 		/* Guarantee no interference with a running reset that otherwise
@@ -1259,7 +1251,7 @@ static int grcan_poll(struct napi_struct *napi, int budget)
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	return rx_work_done + tx_work_done;
+	return work_done;
 }
 
 /* Work tx bug by waiting while for the risky situation to clear. If that fails,
-- 
2.35.1


