Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA7D2932
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfJJMSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:16 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55881 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387537AbfJJMSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:11 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOT-0006Lw-Qn; Thu, 10 Oct 2019 14:18:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 21/29] can: ti_hecc: ti_hecc_stop(): stop the CPK on down
Date:   Thu, 10 Oct 2019 14:17:42 +0200
Message-Id: <20191010121750.27237-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010121750.27237-1-mkl@pengutronix.de>
References: <20191010121750.27237-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeroen Hofstee <jhofstee@victronenergy.com>

When the interface goes down, the CPK should no longer take an active
part in the CAN-bus communication, like sending acks and error frames.
So enable configuration mode in ti_hecc_stop, so the CPK is no longer
active.

When a transceiver switch is present the acks and errors don't make it
to the bus, but disabling the CPK then does prevent oddities, like
ti_hecc_reset() failing, since the CPK can become bus-off and starts
counting the 11 bit recessive bits, which seems to block the reset. It
can also cause invalid interrupts and disrupt the CAN-bus, since
transmission can be stopped in the middle of a message, by disabling the
tranceiver while the CPK is sending.

Since the CPK is disabled after normal power on, it is typically only
seen when the interface is restarted.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ti_hecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 91188e6d4f78..eb8151154083 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -400,6 +400,9 @@ static void ti_hecc_stop(struct net_device *ndev)
 {
 	struct ti_hecc_priv *priv = netdev_priv(ndev);
 
+	/* Disable the CPK; stop sending, erroring and acking */
+	hecc_set_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
+
 	/* Disable interrupts and disable mailboxes */
 	hecc_write(priv, HECC_CANGIM, 0);
 	hecc_write(priv, HECC_CANMIM, 0);
-- 
2.23.0

