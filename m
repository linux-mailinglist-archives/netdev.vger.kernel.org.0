Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E87F02E5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390492AbfKEQdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:00 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50217 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390446AbfKEQcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:52 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1lB-0002Hp-8R; Tue, 05 Nov 2019 17:32:49 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 31/33] can: j1939: transport: j1939_xtp_rx_eoma_one(): Add sanity check for correct total message size
Date:   Tue,  5 Nov 2019 17:32:13 +0100
Message-Id: <20191105163215.30194-32-mkl@pengutronix.de>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

We were sending malformed EOMA with total message size set to 0. This
issue has been fixed in the previous patch.

In this patch a sanity check is added to the RX path and a error message
is displayed.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 06183d6f4fb7..e5f1a56994c6 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1273,9 +1273,27 @@ j1939_xtp_rx_abort(struct j1939_priv *priv, struct sk_buff *skb,
 static void
 j1939_xtp_rx_eoma_one(struct j1939_session *session, struct sk_buff *skb)
 {
+	struct j1939_sk_buff_cb *skcb = j1939_skb_to_cb(skb);
+	const u8 *dat;
+	int len;
+
 	if (j1939_xtp_rx_cmd_bad_pgn(session, skb))
 		return;
 
+	dat = skb->data;
+
+	if (skcb->addr.type == J1939_ETP)
+		len = j1939_etp_ctl_to_size(dat);
+	else
+		len = j1939_tp_ctl_to_size(dat);
+
+	if (session->total_message_size != len) {
+		netdev_warn_once(session->priv->ndev,
+				 "%s: 0x%p: Incorrect size. Expected: %i; got: %i.\n",
+				 __func__, session, session->total_message_size,
+				 len);
+	}
+
 	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
 
 	session->pkt.tx_acked = session->pkt.total;
-- 
2.24.0.rc1

