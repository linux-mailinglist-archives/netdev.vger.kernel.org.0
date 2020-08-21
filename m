Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4324D31A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgHUKsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgHUKrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:47:55 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43602C061387
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:47:53 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 3BF2786BAA;
        Fri, 21 Aug 2020 11:47:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006863; bh=RMHeZUwXKLMx1sCozDXNusJSmEgkyv6IzS6XYyuAzMk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=202/9]=20l2tp:=20remove=20noisy=
         20logging,=20use=20appropriate=20log=20levels|Date:=20Fri,=2021=20
         Aug=202020=2011:47:21=20+0100|Message-Id:=20<20200821104728.23530-
         3-tparkin@katalix.com>|In-Reply-To:=20<20200821104728.23530-1-tpar
         kin@katalix.com>|References:=20<20200821104728.23530-1-tparkin@kat
         alix.com>;
        b=sqZVEFrq6RdZAYZCh5UswuFWFW6JYvYQDmRB2UMx8aelM049jE6y1Kg7iW8tzzsof
         k0SwjrUYW13lZg/4nw6qKe2gUuu34gI2KCmC4IguclIEQVM7fxLBPnT6978icpD3kP
         DxL4w6brIDX7KU3L9h0bwa24tAMmxiw5ZIjjQ9/RkksfyBtI8OL7U3+kxth6VtvACx
         t/WPAiuyIBR47++qbBaYWWSwo85GCbz7gmwwy+HaCss1RTGA/PFGL4rB9yXRAhvA3Z
         PBGWgrDDCY9frmm0yfEAGVc71w5uWvKAAHcfwd6LiqpEMeCbO1WfGE6flyokMr4/v3
         7sjM9SqA+pXPw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 2/9] l2tp: remove noisy logging, use appropriate log levels
Date:   Fri, 21 Aug 2020 11:47:21 +0100
Message-Id: <20200821104728.23530-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
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
index ce647816da61..53a5556699f8 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -666,7 +666,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
 		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
-			l2tp_info(tunnel, L2TP_MSG_DATA,
+			l2tp_warn(tunnel, L2TP_MSG_DATA,
 				  "%s: cookie mismatch (%u/%u). Discarding.\n",
 				  tunnel->name, tunnel->tunnel_id,
 				  session->session_id);
@@ -839,7 +839,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 
 	/* Short packet? */
 	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
-		l2tp_info(tunnel, L2TP_MSG_DATA,
+		l2tp_warn(tunnel, L2TP_MSG_DATA,
 			  "%s: recv short packet (len=%d)\n",
 			  tunnel->name, skb->len);
 		goto error;
@@ -855,7 +855,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
 	if (version != tunnel->version) {
-		l2tp_info(tunnel, L2TP_MSG_DATA,
+		l2tp_warn(tunnel, L2TP_MSG_DATA,
 			  "%s: recv protocol version mismatch: got %d expected %d\n",
 			  tunnel->name, version, tunnel->version);
 		goto error;
@@ -895,7 +895,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 			l2tp_session_dec_refcount(session);
 
 		/* Not found? Pass to userspace to deal with */
-		l2tp_info(tunnel, L2TP_MSG_DATA,
+		l2tp_warn(tunnel, L2TP_MSG_DATA,
 			  "%s: no session found (%u/%u). Passing up.\n",
 			  tunnel->name, tunnel_id, session_id);
 		goto error;
@@ -1153,8 +1153,6 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	if (!tunnel)
 		goto end;
 
-	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing...\n", tunnel->name);
-
 	/* Disable udp encapsulation */
 	switch (tunnel->encap) {
 	case L2TP_ENCAPTYPE_UDP:
@@ -1213,9 +1211,6 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 	struct hlist_node *tmp;
 	struct l2tp_session *session;
 
-	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing all sessions...\n",
-		  tunnel->name);
-
 	write_lock_bh(&tunnel->hlist_lock);
 	tunnel->acpt_newsess = false;
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
@@ -1223,9 +1218,6 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
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

