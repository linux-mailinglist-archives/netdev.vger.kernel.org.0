Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C9649DC6
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiLLLcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiLLLbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6979E6541
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1X-0000dE-LE
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:07 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A4FEE13CC4E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9364413CBFC;
        Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 361f1078;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 29/39] can: m_can: Eliminate double read of TXFQS in tx_handler
Date:   Mon, 12 Dec 2022 12:30:35 +0100
Message-Id: <20221212113045.222493-30-mkl@pengutronix.de>
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

The TXFQS register is read first to check if the fifo is full and then
immediately again to get the putidx. This is unnecessary and adds
significant overhead if read requests are done over a slow bus, for
example SPI with tcan4x5x.

Add a variable to store the value of the register. Split the
m_can_tx_fifo_full function into two to avoid the hidden m_can_read call
if not needed.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-2-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index be8f4b662f95..61531daf66b8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -369,9 +369,14 @@ m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
 	return cdev->ops->read_fifo(cdev, addr_offset, val, 1);
 }
 
+static inline bool _m_can_tx_fifo_full(u32 txfqs)
+{
+	return !!(txfqs & TXFQS_TFQF);
+}
+
 static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
 {
-	return !!(m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQF);
+	return _m_can_tx_fifo_full(m_can_read(cdev, M_CAN_TXFQS));
 }
 
 static void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
@@ -1609,6 +1614,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	struct sk_buff *skb = cdev->tx_skb;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
+	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1665,8 +1671,10 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	} else {
 		/* Transmit routine for version >= v3.1.x */
 
+		txfqs = m_can_read(cdev, M_CAN_TXFQS);
+
 		/* Check if FIFO full */
-		if (m_can_tx_fifo_full(cdev)) {
+		if (_m_can_tx_fifo_full(txfqs)) {
 			/* This shouldn't happen */
 			netif_stop_queue(dev);
 			netdev_warn(dev,
@@ -1682,8 +1690,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		}
 
 		/* get put index for frame */
-		putidx = FIELD_GET(TXFQS_TFQPI_MASK,
-				   m_can_read(cdev, M_CAN_TXFQS));
+		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
 
 		/* Construct DLC Field, with CAN-FD configuration.
 		 * Use the put index of the fifo as the message marker,
-- 
2.35.1


