Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7034D245387
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgHOWC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgHOVvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BE7C03B3E0
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 02:21:27 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1k6sNR-000762-W4; Sat, 15 Aug 2020 11:21:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4/4] can: j1939: add rxtimer for multipacket broadcast session
Date:   Sat, 15 Aug 2020 11:21:16 +0200
Message-Id: <20200815092116.424137-5-mkl@pengutronix.de>
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

According to SAE J1939/21 (Chapter 5.12.3 and APPENDIX C), for transmit side
the required time interval between packets of a multipacket broadcast message
is 50 to 200 ms, the responder shall use a timeout of 250ms (provides margin
allowing for the maximumm spacing of 200ms). For receive side a timeout will
occur when a time of greater than 750 ms elapsed between two message packets
when more packets were expected.

So this patch fix and add rxtimer for multipacket broadcast session.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1596599425-5534-5-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 047118d5270b..a8dd956b5e8e 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -723,10 +723,12 @@ static int j1939_session_tx_rts(struct j1939_session *session)
 		return ret;
 
 	session->last_txcmd = dat[0];
-	if (dat[0] == J1939_TP_CMD_BAM)
+	if (dat[0] == J1939_TP_CMD_BAM) {
 		j1939_tp_schedule_txtimer(session, 50);
-
-	j1939_tp_set_rxtimeout(session, 1250);
+		j1939_tp_set_rxtimeout(session, 250);
+	} else {
+		j1939_tp_set_rxtimeout(session, 1250);
+	}
 
 	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
 
@@ -1687,11 +1689,15 @@ static void j1939_xtp_rx_rts(struct j1939_priv *priv, struct sk_buff *skb,
 	}
 	session->last_cmd = cmd;
 
-	j1939_tp_set_rxtimeout(session, 1250);
-
-	if (cmd != J1939_TP_CMD_BAM && !session->transmission) {
-		j1939_session_txtimer_cancel(session);
-		j1939_tp_schedule_txtimer(session, 0);
+	if (cmd == J1939_TP_CMD_BAM) {
+		if (!session->transmission)
+			j1939_tp_set_rxtimeout(session, 750);
+	} else {
+		if (!session->transmission) {
+			j1939_session_txtimer_cancel(session);
+			j1939_tp_schedule_txtimer(session, 0);
+		}
+		j1939_tp_set_rxtimeout(session, 1250);
 	}
 
 	j1939_session_put(session);
@@ -1742,6 +1748,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	int offset;
 	int nbytes;
 	bool final = false;
+	bool remain = false;
 	bool do_cts_eoma = false;
 	int packet;
 
@@ -1817,6 +1824,8 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	    j1939_cb_is_broadcast(&session->skcb)) {
 		if (session->pkt.rx >= session->pkt.total)
 			final = true;
+		else
+			remain = true;
 	} else {
 		/* never final, an EOMA must follow */
 		if (session->pkt.rx >= session->pkt.last)
@@ -1826,6 +1835,9 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	if (final) {
 		j1939_session_timers_cancel(session);
 		j1939_session_completed(session);
+	} else if (remain) {
+		if (!session->transmission)
+			j1939_tp_set_rxtimeout(session, 750);
 	} else if (do_cts_eoma) {
 		j1939_tp_set_rxtimeout(session, 1250);
 		if (!session->transmission)
-- 
2.28.0

