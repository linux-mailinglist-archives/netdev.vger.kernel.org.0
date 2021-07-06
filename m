Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D339E3BD5C2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhGFM1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245144AbhGFMM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 08:12:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C070C08EC3F
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 04:58:04 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m0jiC-0006CJ-Rh; Tue, 06 Jul 2021 13:58:00 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m0jiC-0002vb-78; Tue, 06 Jul 2021 13:58:00 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: [PATCH v1 2/2] net: j1939: extend UAPI to notify about RX status
Date:   Tue,  6 Jul 2021 13:57:58 +0200
Message-Id: <20210706115758.11196-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706115758.11196-1-o.rempel@pengutronix.de>
References: <20210706115758.11196-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be able to create applications with user friendly feedback, we need be
able to provide receive status information.

Typical ETP transfer may take seconds or even hours. To give user some
clue or show a progress bar, the stack should push status updates.
Same as for the TX information, the socket error queue will be used with
following new signals:
- J1939_EE_INFO_RX_RTS   - received and accepted request to send signal.
- J1939_EE_INFO_RX_DPO   - received data package offset signal
- J1939_EE_INFO_RX_ABORT - RX session was aborted

Instead of completion signal, user will get data package.
To activate this signals, application should set
SOF_TIMESTAMPING_RX_SOFTWARE to the SO_TIMESTAMPING socket option. This
will avoid unpredictable application behavior for the old software.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/uapi/linux/can/j1939.h |   9 +++
 net/can/j1939/j1939-priv.h     |   4 +
 net/can/j1939/socket.c         | 135 +++++++++++++++++++++++++--------
 net/can/j1939/transport.c      |  22 +++++-
 4 files changed, 136 insertions(+), 34 deletions(-)

diff --git a/include/uapi/linux/can/j1939.h b/include/uapi/linux/can/j1939.h
index df6e821075c1..dc2a8e15c0b7 100644
--- a/include/uapi/linux/can/j1939.h
+++ b/include/uapi/linux/can/j1939.h
@@ -78,11 +78,20 @@ enum {
 enum {
 	J1939_NLA_PAD,
 	J1939_NLA_BYTES_ACKED,
+	J1939_NLA_TOTAL_SIZE,
+	J1939_NLA_DEST_ADDR,
+	J1939_NLA_DEST_NAME,
+	J1939_NLA_SRC_ADDR,
+	J1939_NLA_SRC_NAME,
+	J1939_NLA_PGN,
 };
 
 enum {
 	J1939_EE_INFO_NONE,
 	J1939_EE_INFO_TX_ABORT,
+	J1939_EE_INFO_RX_RTS,
+	J1939_EE_INFO_RX_DPO,
+	J1939_EE_INFO_RX_ABORT,
 };
 
 struct j1939_filter {
diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
index 93b8ad7f7d04..f6df20808f5e 100644
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -23,6 +23,9 @@ enum j1939_sk_errqueue_type {
 	J1939_ERRQUEUE_TX_ACK,
 	J1939_ERRQUEUE_TX_SCHED,
 	J1939_ERRQUEUE_TX_ABORT,
+	J1939_ERRQUEUE_RX_RTS,
+	J1939_ERRQUEUE_RX_DPO,
+	J1939_ERRQUEUE_RX_ABORT,
 };
 
 /* j1939 devices */
@@ -87,6 +90,7 @@ struct j1939_priv {
 	struct list_head j1939_socks;
 
 	struct kref rx_kref;
+	u32 rx_tskey;
 };
 
 void j1939_ecu_put(struct j1939_ecu *ecu);
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index c2bf1c02597e..30b99897c473 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -902,20 +902,33 @@ static struct sk_buff *j1939_sk_alloc_skb(struct net_device *ndev,
 	return NULL;
 }
 
-static size_t j1939_sk_opt_stats_get_size(void)
+static size_t j1939_sk_opt_stats_get_size(enum j1939_sk_errqueue_type type)
 {
-	return
-		nla_total_size(sizeof(u32)) + /* J1939_NLA_BYTES_ACKED */
-		0;
+	switch (type) {
+	case J1939_ERRQUEUE_RX_RTS:
+		return
+			nla_total_size(sizeof(u32)) + /* J1939_NLA_BYTES_ALL */
+			nla_total_size(sizeof(u64)) + /* J1939_NLA_DEST_ADDR */
+			nla_total_size(sizeof(u64)) + /* J1939_NLA_SRC_ADDR */
+			nla_total_size(sizeof(u64)) + /* J1939_NLA_DEST_NAME */
+			nla_total_size(sizeof(u64)) + /* J1939_NLA_SRC_NAME */
+			nla_total_size(sizeof(u32)) + /* J1939_NLA_PGN */
+			0;
+	default:
+		return
+			nla_total_size(sizeof(u32)) + /* J1939_NLA_BYTES_ACKED */
+			0;
+	}
 }
 
 static struct sk_buff *
-j1939_sk_get_timestamping_opt_stats(struct j1939_session *session)
+j1939_sk_get_timestamping_opt_stats(struct j1939_session *session,
+				    enum j1939_sk_errqueue_type type)
 {
 	struct sk_buff *stats;
 	u32 size;
 
-	stats = alloc_skb(j1939_sk_opt_stats_get_size(), GFP_ATOMIC);
+	stats = alloc_skb(j1939_sk_opt_stats_get_size(type), GFP_ATOMIC);
 	if (!stats)
 		return NULL;
 
@@ -925,32 +938,67 @@ j1939_sk_get_timestamping_opt_stats(struct j1939_session *session)
 		size = min(session->pkt.tx_acked * 7,
 			   session->total_message_size);
 
-	nla_put_u32(stats, J1939_NLA_BYTES_ACKED, size);
+	switch (type) {
+	case J1939_ERRQUEUE_RX_RTS:
+		nla_put_u32(stats, J1939_NLA_TOTAL_SIZE,
+			    session->total_message_size);
+		nla_put_u32(stats, J1939_NLA_PGN,
+			    session->skcb.addr.pgn);
+		nla_put_u64_64bit(stats, J1939_NLA_SRC_NAME,
+				  session->skcb.addr.src_name, J1939_NLA_PAD);
+		nla_put_u64_64bit(stats, J1939_NLA_DEST_NAME,
+				  session->skcb.addr.dst_name, J1939_NLA_PAD);
+		nla_put_u8(stats, J1939_NLA_SRC_ADDR,
+			   session->skcb.addr.sa);
+		nla_put_u8(stats, J1939_NLA_DEST_ADDR,
+			   session->skcb.addr.da);
+		break;
+	default:
+		nla_put_u32(stats, J1939_NLA_BYTES_ACKED, size);
+	}
 
 	return stats;
 }
 
-void j1939_sk_errqueue(struct j1939_session *session,
-		       enum j1939_sk_errqueue_type type)
+static void __j1939_sk_errqueue(struct j1939_session *session, struct sock *sk,
+				enum j1939_sk_errqueue_type type)
 {
 	struct j1939_priv *priv = session->priv;
-	struct sock *sk = session->sk;
 	struct j1939_sock *jsk;
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb;
 	char *state = "UNK";
 	int err;
 
-	/* currently we have no sk for the RX session */
-	if (!sk)
-		return;
-
 	jsk = j1939_sk(sk);
 
 	if (!(jsk->state & J1939_SOCK_ERRQUEUE))
 		return;
 
-	skb = j1939_sk_get_timestamping_opt_stats(session);
+	switch (type) {
+	case J1939_ERRQUEUE_TX_ACK:
+		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK))
+			return;
+		break;
+	case J1939_ERRQUEUE_TX_SCHED:
+		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED))
+			return;
+		break;
+	case J1939_ERRQUEUE_TX_ABORT:
+		break;
+	case J1939_ERRQUEUE_RX_RTS:
+		fallthrough;
+	case J1939_ERRQUEUE_RX_DPO:
+		fallthrough;
+	case J1939_ERRQUEUE_RX_ABORT:
+		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_RX_SOFTWARE))
+			return;
+		break;
+	default:
+		netdev_err(priv->ndev, "Unknown errqueue type %i\n", type);
+	}
+
+	skb = j1939_sk_get_timestamping_opt_stats(session, type);
 	if (!skb)
 		return;
 
@@ -962,35 +1010,41 @@ void j1939_sk_errqueue(struct j1939_session *session,
 	memset(serr, 0, sizeof(*serr));
 	switch (type) {
 	case J1939_ERRQUEUE_TX_ACK:
-		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK)) {
-			kfree_skb(skb);
-			return;
-		}
-
 		serr->ee.ee_errno = ENOMSG;
 		serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
 		serr->ee.ee_info = SCM_TSTAMP_ACK;
-		state = "ACK";
+		state = "TX ACK";
 		break;
 	case J1939_ERRQUEUE_TX_SCHED:
-		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED)) {
-			kfree_skb(skb);
-			return;
-		}
-
 		serr->ee.ee_errno = ENOMSG;
 		serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
 		serr->ee.ee_info = SCM_TSTAMP_SCHED;
-		state = "SCH";
+		state = "TX SCH";
 		break;
 	case J1939_ERRQUEUE_TX_ABORT:
 		serr->ee.ee_errno = session->err;
 		serr->ee.ee_origin = SO_EE_ORIGIN_LOCAL;
 		serr->ee.ee_info = J1939_EE_INFO_TX_ABORT;
-		state = "ABT";
+		state = "TX ABT";
+		break;
+	case J1939_ERRQUEUE_RX_RTS:
+		serr->ee.ee_errno = ENOMSG;
+		serr->ee.ee_origin = SO_EE_ORIGIN_LOCAL;
+		serr->ee.ee_info = J1939_EE_INFO_RX_RTS;
+		state = "RX RTS";
+		break;
+	case J1939_ERRQUEUE_RX_DPO:
+		serr->ee.ee_errno = ENOMSG;
+		serr->ee.ee_origin = SO_EE_ORIGIN_LOCAL;
+		serr->ee.ee_info = J1939_EE_INFO_RX_DPO;
+		state = "RX DPO";
+		break;
+	case J1939_ERRQUEUE_RX_ABORT:
+		serr->ee.ee_errno = session->err;
+		serr->ee.ee_origin = SO_EE_ORIGIN_LOCAL;
+		serr->ee.ee_info = J1939_EE_INFO_RX_ABORT;
+		state = "RX ABT";
 		break;
-	default:
-		netdev_err(priv->ndev, "Unknown errqueue type %i\n", type);
 	}
 
 	serr->opt_stats = true;
@@ -1005,6 +1059,27 @@ void j1939_sk_errqueue(struct j1939_session *session,
 		kfree_skb(skb);
 };
 
+void j1939_sk_errqueue(struct j1939_session *session,
+		       enum j1939_sk_errqueue_type type)
+{
+	struct j1939_priv *priv = session->priv;
+	struct j1939_sock *jsk;
+
+	if (session->sk) {
+		/* send TX notifications to the socket of origin  */
+		__j1939_sk_errqueue(session, session->sk, type);
+		return;
+	}
+
+	/* spread RX notifications to all sockets subscribed to this session */
+	spin_lock_bh(&priv->j1939_socks_lock);
+	list_for_each_entry(jsk, &priv->j1939_socks, list) {
+		if (j1939_sk_recv_match_one(jsk, &session->skcb))
+			__j1939_sk_errqueue(session, &jsk->sk, type);
+	}
+	spin_unlock_bh(&priv->j1939_socks_lock);
+};
+
 void j1939_sk_send_loop_abort(struct sock *sk, int err)
 {
 	sk->sk_err = err;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 362cf38cacca..cb358646e382 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -260,10 +260,14 @@ static void __j1939_session_drop(struct j1939_session *session)
 
 static void j1939_session_destroy(struct j1939_session *session)
 {
-	if (session->err)
-		j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
-	else
-		j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ACK);
+	if (session->transmission) {
+		if (session->err)
+			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
+		else
+			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ACK);
+	} else if (session->err) {
+			j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
+	}
 
 	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
 
@@ -1087,6 +1091,8 @@ static void __j1939_session_cancel(struct j1939_session *session,
 
 	if (session->sk)
 		j1939_sk_send_loop_abort(session->sk, session->err);
+	else
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 }
 
 static void j1939_session_cancel(struct j1939_session *session,
@@ -1297,6 +1303,8 @@ static void j1939_xtp_rx_abort_one(struct j1939_priv *priv, struct sk_buff *skb,
 	session->err = j1939_xtp_abort_to_errno(priv, abort);
 	if (session->sk)
 		j1939_sk_send_loop_abort(session->sk, session->err);
+	else
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 	j1939_session_deactivate_activate_next(session);
 
 abort_put:
@@ -1597,6 +1605,9 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
 	session->pkt.rx = 0;
 	session->pkt.tx = 0;
 
+	session->tskey = priv->rx_tskey++;
+	j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_RTS);
+
 	WARN_ON_ONCE(j1939_session_activate(session));
 
 	return session;
@@ -1719,6 +1730,9 @@ static void j1939_xtp_rx_dpo_one(struct j1939_session *session,
 	session->pkt.dpo = j1939_etp_ctl_to_packet(skb->data);
 	session->last_cmd = dat[0];
 	j1939_tp_set_rxtimeout(session, 750);
+
+	if (!session->transmission)
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_DPO);
 }
 
 static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
-- 
2.30.2

