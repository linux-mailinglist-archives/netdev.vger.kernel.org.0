Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD51E4BBA
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439010AbfJYNER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:04:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49121 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409276AbfJYNER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 09:04:17 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iNzGJ-0000ca-4r; Fri, 25 Oct 2019 15:04:15 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iNzGI-0000Lv-6t; Fri, 25 Oct 2019 15:04:14 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] j1939: transport: make sure EOMA is send with the total message size set
Date:   Fri, 25 Oct 2019 15:04:13 +0200
Message-Id: <20191025130413.1298-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We was sending malformed EOMA with total message size set to 0. So, fix this
bug and add sanity check to the RX path.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/transport.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index fe000ea757ea..e5f1a56994c6 100644
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
@@ -1432,7 +1450,7 @@ j1939_session *j1939_session_fresh_new(struct j1939_priv *priv,
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
-	session = j1939_session_new(priv, skb, skb->len);
+	session = j1939_session_new(priv, skb, size);
 	if (!session) {
 		kfree_skb(skb);
 		return NULL;
-- 
2.23.0

