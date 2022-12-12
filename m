Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBEC649DC9
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiLLLc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiLLLbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A203A183
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:10 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1Y-0000eY-Cr
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:08 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 03E3F13CC5B
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id F346513CC09;
        Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 11d8b5fc;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 30/39] can: m_can: Avoid reading irqstatus twice
Date:   Mon, 12 Dec 2022 12:30:36 +0100
Message-Id: <20221212113045.222493-31-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Schneider-Pargmann <msp@baylibre.com>

For peripheral devices the m_can_rx_handler is called directly after
setting cdev->irqstatus. This means we don't have to read the irqstatus
again in m_can_rx_handler. Avoid this by adding a parameter that is
false for direct calls.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-3-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 61531daf66b8..8399e55a4ea6 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -905,14 +905,13 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	return work_done;
 }
 
-static int m_can_rx_handler(struct net_device *dev, int quota)
+static int m_can_rx_handler(struct net_device *dev, int quota, u32 irqstatus)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int rx_work_or_err;
 	int work_done = 0;
-	u32 irqstatus, psr;
+	u32 psr;
 
-	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 	if (!irqstatus)
 		goto end;
 
@@ -956,12 +955,12 @@ static int m_can_rx_handler(struct net_device *dev, int quota)
 	return work_done;
 }
 
-static int m_can_rx_peripheral(struct net_device *dev)
+static int m_can_rx_peripheral(struct net_device *dev, u32 irqstatus)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
 
-	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT);
+	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, irqstatus);
 
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
@@ -977,8 +976,11 @@ static int m_can_poll(struct napi_struct *napi, int quota)
 	struct net_device *dev = napi->dev;
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
+	u32 irqstatus;
+
+	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 
-	work_done = m_can_rx_handler(dev, quota);
+	work_done = m_can_rx_handler(dev, quota, irqstatus);
 
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
@@ -1088,7 +1090,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		m_can_disable_all_interrupts(cdev);
 		if (!cdev->is_peripheral)
 			napi_schedule(&cdev->napi);
-		else if (m_can_rx_peripheral(dev) < 0)
+		else if (m_can_rx_peripheral(dev, ir) < 0)
 			goto out_fail;
 	}
 
-- 
2.35.1


