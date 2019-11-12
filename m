Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B14DF8DD3
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfKLLRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:17:12 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51303 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLLRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:17:11 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9T-0003F8-Oi; Tue, 12 Nov 2019 12:16:03 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004yA-9g; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 2/9] can: j1939: move j1939_priv_put() into sk_destruct callback
Date:   Tue, 12 Nov 2019 12:15:53 +0100
Message-Id: <20191112111600.18719-3-o.rempel@pengutronix.de>
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

This patch delays the j1939_priv_put() until the socket is destroyed via
the sk_destruct callback, to avoid use-after-free problems.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/socket.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 4d8ba701e15d..aee94b09ef08 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -78,7 +78,6 @@ static void j1939_jsk_add(struct j1939_priv *priv, struct j1939_sock *jsk)
 {
 	jsk->state |= J1939_SOCK_BOUND;
 	j1939_priv_get(priv);
-	jsk->priv = priv;
 
 	spin_lock_bh(&priv->j1939_socks_lock);
 	list_add_tail(&jsk->list, &priv->j1939_socks);
@@ -91,7 +90,6 @@ static void j1939_jsk_del(struct j1939_priv *priv, struct j1939_sock *jsk)
 	list_del_init(&jsk->list);
 	spin_unlock_bh(&priv->j1939_socks_lock);
 
-	jsk->priv = NULL;
 	j1939_priv_put(priv);
 	jsk->state &= ~J1939_SOCK_BOUND;
 }
@@ -349,6 +347,34 @@ void j1939_sk_recv(struct j1939_priv *priv, struct sk_buff *skb)
 	spin_unlock_bh(&priv->j1939_socks_lock);
 }
 
+static void j1939_sk_sock_destruct(struct sock *sk)
+{
+	struct j1939_sock *jsk = j1939_sk(sk);
+
+	/* This function will be call by the generic networking code, when then
+	 * the socket is ultimately closed (sk->sk_destruct).
+	 *
+	 * The race between
+	 * - processing a received CAN frame
+	 *   (can_receive -> j1939_can_recv)
+	 *   and accessing j1939_priv
+	 * ... and ...
+	 * - closing a socket
+	 *   (j1939_can_rx_unregister -> can_rx_unregister)
+	 *   and calling the final j1939_priv_put()
+	 *
+	 * is avoided by calling the final j1939_priv_put() from this
+	 * RCU deferred cleanup call.
+	 */
+	if (jsk->priv) {
+		j1939_priv_put(jsk->priv);
+		jsk->priv = NULL;
+	}
+
+	/* call generic CAN sock destruct */
+	can_sock_destruct(sk);
+}
+
 static int j1939_sk_init(struct sock *sk)
 {
 	struct j1939_sock *jsk = j1939_sk(sk);
@@ -371,6 +397,7 @@ static int j1939_sk_init(struct sock *sk)
 	atomic_set(&jsk->skb_pending, 0);
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
+	sk->sk_destruct = j1939_sk_sock_destruct;
 
 	return 0;
 }
@@ -443,6 +470,12 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		}
 
 		jsk->ifindex = addr->can_ifindex;
+
+		/* the corresponding j1939_priv_put() is called via
+		 * sk->sk_destruct, which points to j1939_sk_sock_destruct()
+		 */
+		j1939_priv_get(priv);
+		jsk->priv = priv;
 	}
 
 	/* set default transmit pgn */
-- 
2.24.0.rc1

