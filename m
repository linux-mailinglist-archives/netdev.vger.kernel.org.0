Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194AFFADB8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfKMJ4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:56:03 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58437 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfKMJz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:55:59 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iUpNV-0006Nh-Tq; Wed, 13 Nov 2019 10:55:58 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH 6/9] can: j1939: make sure socket is held as long as session exists
Date:   Wed, 13 Nov 2019 10:55:47 +0100
Message-Id: <20191113095550.26527-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113095550.26527-1-mkl@pengutronix.de>
References: <20191113095550.26527-1-mkl@pengutronix.de>
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

We link the socket to the session to be able provide socket specific
notifications. For example messages over error queue.

We need to keep the socket held, while we have a reference to it.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index ecdedfc0b10c..afc2adfd97e4 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -255,6 +255,7 @@ static void __j1939_session_drop(struct j1939_session *session)
 		return;
 
 	j1939_sock_pending_del(session->sk);
+	sock_put(session->sk);
 }
 
 static void j1939_session_destroy(struct j1939_session *session)
@@ -1875,6 +1876,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		return ERR_PTR(-ENOMEM);
 
 	/* skb is recounted in j1939_session_new() */
+	sock_hold(skb->sk);
 	session->sk = skb->sk;
 	session->transmission = true;
 	session->pkt.total = (size + 6) / 7;
-- 
2.24.0

