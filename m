Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE45AF02F1
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390516AbfKEQdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60163 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390425AbfKEQct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:49 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l9-0002Hp-RY; Tue, 05 Nov 2019 17:32:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 27/33] can: ti_hecc: add missing state changes
Date:   Tue,  5 Nov 2019 17:32:09 +0100
Message-Id: <20191105163215.30194-28-mkl@pengutronix.de>
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

While the ti_hecc has interrupts to report when the error counters increase
to a certain level and which change state it doesn't handle the case that
the error counters go down again, so the reported state can actually be
wrong. Since there is no interrupt for that, do update state based on the
error counters, when the state is not error active and goes down again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ti_hecc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 4c6d3ce0e8c4..31ad364a89bb 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -711,6 +711,23 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 			can_bus_off(ndev);
 			ti_hecc_change_state(ndev, rx_state, tx_state);
 		}
+	} else if (unlikely(priv->can.state != CAN_STATE_ERROR_ACTIVE)) {
+		enum can_state new_state, tx_state, rx_state;
+		u32 rec = hecc_read(priv, HECC_CANREC);
+		u32 tec = hecc_read(priv, HECC_CANTEC);
+
+		if (rec >= 128 || tec >= 128)
+			new_state = CAN_STATE_ERROR_PASSIVE;
+		else if (rec >= 96 || tec >= 96)
+			new_state = CAN_STATE_ERROR_WARNING;
+		else
+			new_state = CAN_STATE_ERROR_ACTIVE;
+
+		if (new_state < priv->can.state) {
+			rx_state = rec >= tec ? new_state : 0;
+			tx_state = rec <= tec ? new_state : 0;
+			ti_hecc_change_state(ndev, rx_state, tx_state);
+		}
 	}
 
 	if (int_status & HECC_CANGIF_GMIF) {
-- 
2.24.0.rc1

