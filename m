Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9813A58E7AF
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiHJHPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiHJHPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:15:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BE881B3D
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:14:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oLfva-0003TJ-K8
        for netdev@vger.kernel.org; Wed, 10 Aug 2022 09:14:54 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 04058C6576
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:14:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7D961C656B;
        Wed, 10 Aug 2022 07:14:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9743dfd9;
        Wed, 10 Aug 2022 07:14:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        =?UTF-8?q?Sebastian=20W=C3=BCrl?= <sebastian.wuerl@ororatech.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/4] can: mcp251x: Fix race condition on receive interrupt
Date:   Wed, 10 Aug 2022 09:14:48 +0200
Message-Id: <20220810071448.1627857-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220810071448.1627857-1-mkl@pengutronix.de>
References: <20220810071448.1627857-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Würl <sebastian.wuerl@ororatech.com>

The mcp251x driver uses both receiving mailboxes of the CAN controller
chips. For retrieving the CAN frames from the controller via SPI, it checks
once per interrupt which mailboxes have been filled and will retrieve the
messages accordingly.

This introduces a race condition, as another CAN frame can enter mailbox 1
while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 until
the interrupt handler is called next, mailbox 0 is emptied before
mailbox 1, leading to out-of-order CAN frames in the network device.

This is fixed by checking the interrupt flags once again after freeing
mailbox 0, to correctly also empty mailbox 1 before leaving the handler.

For reproducing the bug I created the following setup:
 - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
 - Setup CAN to 1 MHz
 - Spam bursts of 5 CAN-messages with increasing CAN-ids
 - Continue sending the bursts while sleeping a second between the bursts
 - Check on the RPi whether the received messages have increasing CAN-ids
 - Without this patch, every burst of messages will contain a flipped pair

v3: https://lore.kernel.org/all/20220804075914.67569-1-sebastian.wuerl@ororatech.com
v2: https://lore.kernel.org/all/20220804064803.63157-1-sebastian.wuerl@ororatech.com
v1: https://lore.kernel.org/all/20220803153300.58732-1-sebastian.wuerl@ororatech.com

Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead of workqueues.")
Signed-off-by: Sebastian Würl <sebastian.wuerl@ororatech.com>
Link: https://lore.kernel.org/all/20220804081411.68567-1-sebastian.wuerl@ororatech.com
[mkl: reduce scope of intf1, eflag1]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251x.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index e750d13c8841..c320de474f40 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1070,9 +1070,6 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 
 		mcp251x_read_2regs(spi, CANINTF, &intf, &eflag);
 
-		/* mask out flags we don't care about */
-		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
-
 		/* receive buffer 0 */
 		if (intf & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
@@ -1082,6 +1079,18 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF,
 						   CANINTF_RX0IF, 0x00);
+
+			/* check if buffer 1 is already known to be full, no need to re-read */
+			if (!(intf & CANINTF_RX1IF)) {
+				u8 intf1, eflag1;
+
+				/* intf needs to be read again to avoid a race condition */
+				mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);
+
+				/* combine flags from both operations for error handling */
+				intf |= intf1;
+				eflag |= eflag1;
+			}
 		}
 
 		/* receive buffer 1 */
@@ -1092,6 +1101,9 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 				clear_intf |= CANINTF_RX1IF;
 		}
 
+		/* mask out flags we don't care about */
+		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
+
 		/* any error or tx interrupt we need to clear? */
 		if (intf & (CANINTF_ERR | CANINTF_TX))
 			clear_intf |= intf & (CANINTF_ERR | CANINTF_TX);
-- 
2.35.1


