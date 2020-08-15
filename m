Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7912453AB
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgHOWEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgHOVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E3DC03B3DE
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 02:21:27 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1k6sNQ-000762-OQ; Sat, 15 Aug 2020 11:21:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/4] can: j1939: fix support for multipacket broadcast message
Date:   Sat, 15 Aug 2020 11:21:13 +0200
Message-Id: <20200815092116.424137-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200815092116.424137-1-mkl@pengutronix.de>
References: <20200815092116.424137-1-mkl@pengutronix.de>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

Currently j1939_tp_im_involved_anydir() in j1939_tp_recv() check the previously
set flags J1939_ECU_LOCAL_DST and J1939_ECU_LOCAL_SRC of incoming skb, thus
multipacket broadcast message was aborted by receive side because it may come
from remote ECUs and have no exact dst address. Similarly, j1939_tp_cmd_recv()
and j1939_xtp_rx_dat() didn't process broadcast message.

So fix it by checking and process broadcast message in j1939_tp_recv(),
j1939_tp_cmd_recv() and j1939_xtp_rx_dat().

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1596599425-5534-2-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 5cf107cb447c..868ecb2bfa45 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1673,8 +1673,12 @@ static void j1939_xtp_rx_rts(struct j1939_priv *priv, struct sk_buff *skb,
 			return;
 		}
 		session = j1939_xtp_rx_rts_session_new(priv, skb);
-		if (!session)
+		if (!session) {
+			if (cmd == J1939_TP_CMD_BAM && j1939_sk_recv_match(priv, skcb))
+				netdev_info(priv->ndev, "%s: failed to create TP BAM session\n",
+					    __func__);
 			return;
+		}
 	} else {
 		if (j1939_xtp_rx_rts_session_active(session, skb)) {
 			j1939_session_put(session);
@@ -1865,6 +1869,13 @@ static void j1939_xtp_rx_dat(struct j1939_priv *priv, struct sk_buff *skb)
 		else
 			j1939_xtp_rx_dat_one(session, skb);
 	}
+
+	if (j1939_cb_is_broadcast(skcb)) {
+		session = j1939_session_get_by_addr(priv, &skcb->addr, false,
+						    false);
+		if (session)
+			j1939_xtp_rx_dat_one(session, skb);
+	}
 }
 
 /* j1939 main intf */
@@ -1956,7 +1967,7 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		if (j1939_tp_im_transmitter(skcb))
 			j1939_xtp_rx_rts(priv, skb, true);
 
-		if (j1939_tp_im_receiver(skcb))
+		if (j1939_tp_im_receiver(skcb) || j1939_cb_is_broadcast(skcb))
 			j1939_xtp_rx_rts(priv, skb, false);
 
 		break;
@@ -2020,7 +2031,7 @@ int j1939_tp_recv(struct j1939_priv *priv, struct sk_buff *skb)
 {
 	struct j1939_sk_buff_cb *skcb = j1939_skb_to_cb(skb);
 
-	if (!j1939_tp_im_involved_anydir(skcb))
+	if (!j1939_tp_im_involved_anydir(skcb) && !j1939_cb_is_broadcast(skcb))
 		return 0;
 
 	switch (skcb->addr.pgn) {
-- 
2.28.0

