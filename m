Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEB527264A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgIUNsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgIUNqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAE4C0613D5
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:08 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8r-0003ED-QP; Mon, 21 Sep 2020 15:46:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 12/38] can: dev: can_change_state(): print human readable state change messages
Date:   Mon, 21 Sep 2020 15:45:31 +0200
Message-Id: <20200921134557.2251383-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to ease debugging let can_change_state() print the human readable
state change messages. Also print the old and new state.

Link: https://lore.kernel.org/r/20200915223527.1417033-13-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 77a5663693af..e0caf969e342 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -371,6 +371,28 @@ static int can_rx_state_to_frame(struct net_device *dev, enum can_state state)
 	}
 }
 
+static const char *can_get_state_str(const enum can_state state)
+{
+	switch (state) {
+	case CAN_STATE_ERROR_ACTIVE:
+		return "Error Active";
+	case CAN_STATE_ERROR_WARNING:
+		return "Error Warning";
+	case CAN_STATE_ERROR_PASSIVE:
+		return "Error Passive";
+	case CAN_STATE_BUS_OFF:
+		return "Bus Off";
+	case CAN_STATE_STOPPED:
+		return "Stopped";
+	case CAN_STATE_SLEEPING:
+		return "Sleeping";
+	default:
+		return "<unknown>";
+	}
+
+	return "<unknown>";
+}
+
 void can_change_state(struct net_device *dev, struct can_frame *cf,
 		      enum can_state tx_state, enum can_state rx_state)
 {
@@ -382,7 +404,9 @@ void can_change_state(struct net_device *dev, struct can_frame *cf,
 		return;
 	}
 
-	netdev_dbg(dev, "New error state: %d\n", new_state);
+	netdev_dbg(dev, "Controller changed from %s State (%d) into %s State (%d).\n",
+		   can_get_state_str(priv->state), priv->state,
+		   can_get_state_str(new_state), new_state);
 
 	can_update_state_error_stats(dev, new_state);
 	priv->state = new_state;
-- 
2.28.0

