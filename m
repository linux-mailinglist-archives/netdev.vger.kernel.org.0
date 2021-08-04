Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612E23DFF51
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbhHDKST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbhHDKSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:18:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9508BC061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 03:18:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDyK-00049v-Sg
        for netdev@vger.kernel.org; Wed, 04 Aug 2021 12:18:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C40956607B0
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:17:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2704366079F;
        Wed,  4 Aug 2021 10:17:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4c118f2c;
        Wed, 4 Aug 2021 10:17:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/5] can: j1939: extend UAPI to notify about RX status
Date:   Wed,  4 Aug 2021 12:17:51 +0200
Message-Id: <20210804101753.23826-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804101753.23826-1-mkl@pengutronix.de>
References: <20210804101753.23826-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

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

Link: https://lore.kernel.org/r/20210707094854.30781-3-o.rempel@pengutronix.de
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/j1939.h |   9 +++
 net/can/j1939/j1939-priv.h     |   4 +
 net/can/j1939/socket.c         | 135 +++++++++++++++++++++++++--------
 net/can/j1939/transport.c      |  22 +++++-
 4 files changed, 136 insertions(+), 34 deletions(-)

diff --git a/include/uapi/linux/can/j1939.h b/include/uapi/linux/can/j1939.h
index df6e821075c1..38936460f668 100644
--- a/include/uapi/linux/can/j1939.h
+++ b/include/uapi/linux/can/j1939.h
@@ -78,11 +78,20 @@ enum {
 enum {
 	J1939_NLA_PAD,
 	J1939_NLA_BYTES_ACKED,
+	J1939_NLA_TOTAL_SIZE,
+	J1939_NLA_PGN,
+	J1939_NLA_SRC_NAME,
+	J1939_NLA_DEST_NAME,
+	J1939_NLA_SRC_ADDR,
+	J1939_NLA_DEST_ADDR,
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
index 6f3b10472f7f..6dff4510687a 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -905,20 +905,33 @@ static struct sk_buff *j1939_sk_alloc_skb(struct net_device *ndev,
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
+			nla_total_size(sizeof(u32)) + /* J1939_NLA_TOTAL_SIZE */
+			nla_total_size(sizeof(u32)) + /* J1939_NLA_PGN */
+			nla_total_size(sizeof(u64)) + /* J1939_NLA_SRC_NAME */
+			nla_total_size(sizeof(u64)) + /* J1939_NLA_DEST_NAME */
+			nla_total_size(sizeof(u8)) +  /* J1939_NLA_SRC_ADDR */
+			nla_total_size(sizeof(u8)) +  /* J1939_NLA_DEST_ADDR */
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
 
@@ -928,32 +941,67 @@ j1939_sk_get_timestamping_opt_stats(struct j1939_session *session)
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
 
@@ -965,35 +1013,41 @@ void j1939_sk_errqueue(struct j1939_session *session,
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
@@ -1008,6 +1062,27 @@ void j1939_sk_errqueue(struct j1939_session *session,
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
index 801e700eaba6..bb5c4b8979be 100644
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
 
@@ -1116,6 +1120,8 @@ static void __j1939_session_cancel(struct j1939_session *session,
 
 	if (session->sk)
 		j1939_sk_send_loop_abort(session->sk, session->err);
+	else
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 }
 
 static void j1939_session_cancel(struct j1939_session *session,
@@ -1330,6 +1336,8 @@ static void j1939_xtp_rx_abort_one(struct j1939_priv *priv, struct sk_buff *skb,
 	session->err = j1939_xtp_abort_to_errno(priv, abort);
 	if (session->sk)
 		j1939_sk_send_loop_abort(session->sk, session->err);
+	else
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 	j1939_session_deactivate_activate_next(session);
 
 abort_put:
@@ -1630,6 +1638,9 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
 	session->pkt.rx = 0;
 	session->pkt.tx = 0;
 
+	session->tskey = priv->rx_tskey++;
+	j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_RTS);
+
 	WARN_ON_ONCE(j1939_session_activate(session));
 
 	return session;
@@ -1752,6 +1763,9 @@ static void j1939_xtp_rx_dpo_one(struct j1939_session *session,
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


