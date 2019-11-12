Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85503F8DC6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLLQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:16:12 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34305 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfKLLQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:16:11 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9T-0003FC-Oi; Tue, 12 Nov 2019 12:16:03 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004yy-Dy; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 6/9] can: j1939: make sure socket is held as long as session exists
Date:   Tue, 12 Nov 2019 12:15:57 +0100
Message-Id: <20191112111600.18719-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191112111600.18719-1-o.rempel@pengutronix.de>
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
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
2.24.0.rc1

