Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F59624E823
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHVO7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:59:34 -0400
Received: from mail.katalix.com ([3.9.82.81]:57974 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbgHVO7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 10:59:25 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id D628B86BDC;
        Sat, 22 Aug 2020 15:59:19 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598108359; bh=MipQImeO1RKCvTUODiJwbzSvaYjeZr5nh0owzPLmiKs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=20v2=202/9]=20l2tp:=2
         0remove=20noisy=20logging,=20use=20appropriate=20log=20levels|Date
         :=20Sat,=2022=20Aug=202020=2015:59:02=20+0100|Message-Id:=20<20200
         822145909.6381-3-tparkin@katalix.com>|In-Reply-To:=20<202008221459
         09.6381-1-tparkin@katalix.com>|References:=20<20200822145909.6381-
         1-tparkin@katalix.com>;
        b=vymirEkE3JzqQ9TcmpCO0W+yUdm/NQQbY5htZDsZ00kjkvjjn+M8zMQ2BO1jGaUry
         Bnfsay0xrJ9m5B09is6Np0oTy6PomsnxW1Sh2ZuhambQmNYD3gBSO2zbGdGWSjoNG3
         RCJjG5i06S5YlPjCxMtJlvrdO04N7KIG5DYgO1dv4/u7h+g9Zkb2B/vCfXlb4mGv6i
         0fPWd0wCnTQkJ9vwIyZeCCRqCmFemj180alswP2zXSxqDoeZ73FyGBrXnVHSBLqSGw
         IxzpthoZZASXrwtjEfGgqMqxzmRwTTuuph+5ob+YRvQJ+H8E7DZoD6tc+12cz3A8XD
         F/RrpbkyDQQgA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next v2 2/9] l2tp: remove noisy logging, use appropriate log levels
Date:   Sat, 22 Aug 2020 15:59:02 +0100
Message-Id: <20200822145909.6381-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822145909.6381-1-tparkin@katalix.com>
References: <20200822145909.6381-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_ppp in particular had a lot of log messages for tracing
[get|set]sockopt calls.  These aren't especially useful, so remove
these messages.

Several log messages flagging error conditions were logged using
l2tp_info: they're better off as l2tp_warn.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 16 ++++------------
 net/l2tp/l2tp_ppp.c  | 32 +-------------------------------
 2 files changed, 5 insertions(+), 43 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 077f7952912d..a3017c46f653 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -665,7 +665,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
 		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
-			l2tp_info(tunnel, L2TP_MSG_DATA,
+			l2tp_warn(tunnel, L2TP_MSG_DATA,
 				  "%s: cookie mismatch (%u/%u). Discarding.\n",
 				  tunnel->name, tunnel->tunnel_id,
 				  session->session_id);
@@ -835,7 +835,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 
 	/* Short packet? */
 	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
-		l2tp_info(tunnel, L2TP_MSG_DATA,
+		l2tp_warn(tunnel, L2TP_MSG_DATA,
 			  "%s: recv short packet (len=%d)\n",
 			  tunnel->name, skb->len);
 		goto error;
@@ -851,7 +851,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
 	if (version != tunnel->version) {
-		l2tp_info(tunnel, L2TP_MSG_DATA,
+		l2tp_warn(tunnel, L2TP_MSG_DATA,
 			  "%s: recv protocol version mismatch: got %d expected %d\n",
 			  tunnel->name, version, tunnel->version);
 		goto error;
@@ -891,7 +891,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 			l2tp_session_dec_refcount(session);
 
 		/* Not found? Pass to userspace to deal with */
-		l2tp_info(tunnel, L2TP_MSG_DATA,
+		l2tp_warn(tunnel, L2TP_MSG_DATA,
 			  "%s: no session found (%u/%u). Passing up.\n",
 			  tunnel->name, tunnel_id, session_id);
 		goto error;
@@ -1149,8 +1149,6 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	if (!tunnel)
 		goto end;
 
-	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing...\n", tunnel->name);
-
 	/* Disable udp encapsulation */
 	switch (tunnel->encap) {
 	case L2TP_ENCAPTYPE_UDP:
@@ -1209,9 +1207,6 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 	struct hlist_node *tmp;
 	struct l2tp_session *session;
 
-	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing all sessions...\n",
-		  tunnel->name);
-
 	write_lock_bh(&tunnel->hlist_lock);
 	tunnel->acpt_newsess = false;
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
@@ -1219,9 +1214,6 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 		hlist_for_each_safe(walk, tmp, &tunnel->session_hlist[hash]) {
 			session = hlist_entry(walk, struct l2tp_session, hlist);
 
-			l2tp_info(session, L2TP_MSG_CONTROL,
-				  "%s: closing session\n", session->name);
-
 			hlist_del_init(&session->hlist);
 
 			if (test_and_set_bit(0, &session->dead))
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index ee1663a3ca7b..660ea95e0910 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -251,7 +251,7 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
 
 no_sock:
 	rcu_read_unlock();
-	l2tp_info(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
+	l2tp_warn(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
 	kfree_skb(skb);
 }
 
@@ -832,8 +832,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	drop_refcnt = false;
 
 	sk->sk_state = PPPOX_CONNECTED;
-	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
-		  session->name);
 
 end:
 	if (error) {
@@ -1150,8 +1148,6 @@ static int pppol2tp_tunnel_setsockopt(struct sock *sk,
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		tunnel->debug = val;
-		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: set debug=%x\n",
-			  tunnel->name, tunnel->debug);
 		break;
 
 	default:
@@ -1177,9 +1173,6 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 			break;
 		}
 		session->recv_seq = !!val;
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: set recv_seq=%d\n",
-			  session->name, session->recv_seq);
 		break;
 
 	case PPPOL2TP_SO_SENDSEQ:
@@ -1195,9 +1188,6 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
 		l2tp_session_set_header_len(session, session->tunnel->version);
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: set send_seq=%d\n",
-			  session->name, session->send_seq);
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
@@ -1206,22 +1196,14 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 			break;
 		}
 		session->lns_mode = !!val;
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: set lns_mode=%d\n",
-			  session->name, session->lns_mode);
 		break;
 
 	case PPPOL2TP_SO_DEBUG:
 		session->debug = val;
-		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set debug=%x\n",
-			  session->name, session->debug);
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
 		session->reorder_timeout = msecs_to_jiffies(val);
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: set reorder_timeout=%d\n",
-			  session->name, session->reorder_timeout);
 		break;
 
 	default:
@@ -1290,8 +1272,6 @@ static int pppol2tp_tunnel_getsockopt(struct sock *sk,
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		*val = tunnel->debug;
-		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get debug=%x\n",
-			  tunnel->name, tunnel->debug);
 		break;
 
 	default:
@@ -1313,32 +1293,22 @@ static int pppol2tp_session_getsockopt(struct sock *sk,
 	switch (optname) {
 	case PPPOL2TP_SO_RECVSEQ:
 		*val = session->recv_seq;
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: get recv_seq=%d\n", session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_SENDSEQ:
 		*val = session->send_seq;
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: get send_seq=%d\n", session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
 		*val = session->lns_mode;
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: get lns_mode=%d\n", session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_DEBUG:
 		*val = session->debug;
-		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get debug=%d\n",
-			  session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
 		*val = (int)jiffies_to_msecs(session->reorder_timeout);
-		l2tp_info(session, L2TP_MSG_CONTROL,
-			  "%s: get reorder_timeout=%d\n", session->name, *val);
 		break;
 
 	default:
-- 
2.17.1

