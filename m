Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E617DF02FC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390536AbfKEQdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:18 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59747 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390406AbfKEQcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:47 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l8-0002Hp-7V; Tue, 05 Nov 2019 17:32:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 22/33] can: ti_hecc: ti_hecc_stop(): stop the CPK on down
Date:   Tue,  5 Nov 2019 17:32:04 +0100
Message-Id: <20191105163215.30194-23-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
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
2.24.0.rc1

