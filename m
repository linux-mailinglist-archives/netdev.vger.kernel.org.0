Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E663823C429
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 05:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHEDvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 23:51:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35370 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgHEDu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 23:50:57 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EB04F3C152A363C86B4A;
        Wed,  5 Aug 2020 11:50:53 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 5 Aug 2020 11:50:50 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <robin@protonic.nl>, <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 4/4] can: j1939: add rxtimer for multipacket broadcast session
Date:   Wed, 5 Aug 2020 11:50:25 +0800
Message-ID: <1596599425-5534-5-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
References: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to SAE J1939/21 (Chapter 5.12.3 and APPENDIX C), for transmit
side the required time interval between packets of a multipacket
broadcast message is 50 to 200 ms, the responder shall use a timeout of
250ms (provides margin allowing for the maximumm spacing of 200ms). For
receive side a timeout will occur when a time of greater than 750 ms
elapsed between two message packets when more packets were expected.

So this patch fix and add rxtimer for multipacket broadcast session.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 5757f9f..fad210e 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -716,10 +716,12 @@ static int j1939_session_tx_rts(struct j1939_session *session)
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
 
@@ -1665,11 +1667,15 @@ static void j1939_xtp_rx_rts(struct j1939_priv *priv, struct sk_buff *skb,
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
@@ -1720,6 +1726,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	int offset;
 	int nbytes;
 	bool final = false;
+	bool remain = false;
 	bool do_cts_eoma = false;
 	int packet;
 
@@ -1781,6 +1788,8 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	    j1939_cb_is_broadcast(&session->skcb)) {
 		if (session->pkt.rx >= session->pkt.total)
 			final = true;
+		else
+			remain = true;
 	} else {
 		/* never final, an EOMA must follow */
 		if (session->pkt.rx >= session->pkt.last)
@@ -1790,6 +1799,9 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
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
2.9.5

