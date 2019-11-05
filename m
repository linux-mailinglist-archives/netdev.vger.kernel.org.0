Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECC6F030A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390304AbfKEQdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:35 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51215 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390354AbfKEQcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:43 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l3-0002Hp-MR; Tue, 05 Nov 2019 17:32:41 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 11/33] can: c_can: C_CAN: add bus recovery events
Date:   Tue,  5 Nov 2019 17:31:53 +0100
Message-Id: <20191105163215.30194-12-mkl@pengutronix.de>
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

While the state is updated when the error counters increase and
decrease, there is no event when the bus recovers and the error counters
decrease again. So add that event as well.

Change the state going downward to be ERROR_PASSIVE -> ERROR_WARNING ->
ERROR_ACTIVE instead of directly to ERROR_ACTIVE again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Tested-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 24c6015f6c92..8e9f5620c9a2 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -915,6 +915,9 @@ static int c_can_handle_state_change(struct net_device *dev,
 	struct can_berr_counter bec;
 
 	switch (error_type) {
+	case C_CAN_NO_ERROR:
+		priv->can.state = CAN_STATE_ERROR_ACTIVE;
+		break;
 	case C_CAN_ERROR_WARNING:
 		/* error warning state */
 		priv->can.can_stats.error_warning++;
@@ -945,6 +948,13 @@ static int c_can_handle_state_change(struct net_device *dev,
 				ERR_CNT_RP_SHIFT;
 
 	switch (error_type) {
+	case C_CAN_NO_ERROR:
+		/* error warning state */
+		cf->can_id |= CAN_ERR_CRTL;
+		cf->data[1] = CAN_ERR_CRTL_ACTIVE;
+		cf->data[6] = bec.txerr;
+		cf->data[7] = bec.rxerr;
+		break;
 	case C_CAN_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |= CAN_ERR_CRTL;
@@ -1089,11 +1099,17 @@ static int c_can_poll(struct napi_struct *napi, int quota)
 	/* handle bus recovery events */
 	if ((!(curr & STATUS_BOFF)) && (last & STATUS_BOFF)) {
 		netdev_dbg(dev, "left bus off state\n");
-		priv->can.state = CAN_STATE_ERROR_ACTIVE;
+		work_done += c_can_handle_state_change(dev, C_CAN_ERROR_PASSIVE);
 	}
+
 	if ((!(curr & STATUS_EPASS)) && (last & STATUS_EPASS)) {
 		netdev_dbg(dev, "left error passive state\n");
-		priv->can.state = CAN_STATE_ERROR_ACTIVE;
+		work_done += c_can_handle_state_change(dev, C_CAN_ERROR_WARNING);
+	}
+
+	if ((!(curr & STATUS_EWARN)) && (last & STATUS_EWARN)) {
+		netdev_dbg(dev, "left error warning state\n");
+		work_done += c_can_handle_state_change(dev, C_CAN_NO_ERROR);
 	}
 
 	/* handle lec errors on the bus */
-- 
2.24.0.rc1

