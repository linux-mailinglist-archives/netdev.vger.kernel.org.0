Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C3C24D31B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgHUKsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgHUKrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:47:55 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 013F1C061385
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:47:53 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 5C0DE86BDB;
        Fri, 21 Aug 2020 11:47:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006863; bh=nbrKnCToBbnxsW7LYCqIrmOBpU+aIk1mUbCBzG4NCBc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=203/9]=20l2tp:=20use=20standard=
         20API=20for=20warning=20log=20messages|Date:=20Fri,=2021=20Aug=202
         020=2011:47:22=20+0100|Message-Id:=20<20200821104728.23530-4-tpark
         in@katalix.com>|In-Reply-To:=20<20200821104728.23530-1-tparkin@kat
         alix.com>|References:=20<20200821104728.23530-1-tparkin@katalix.co
         m>;
        b=GOqLHH0HAZuj3ajAI5qYAYghruzgs2PtknM4Be9YpcXxzXaxHzCnrXvUJ51IWxsBN
         A+200a9cgsuK9c+UdUgxuNtXamPLHPXzZT+SU3QFuLk4WjpI8iCiyyLq1ob+YFeLdH
         atHRhvi+UBkbN+jNq3FIS37Fr4fAg8CMNp6hnYD/D1fVo0t43Hvu+Y84o2qb/kmEhv
         fKlyXiwbDc2aX2UuZDbRGg05D7QWTpzg9siW/435oprbJJJysVUdd7bsSCfvBVny10
         JPnag8zCesZDeyhS4Kcng1xa2x7qdhVIHNwGC36U9NyoZzUePUYr1tlU3xdmo5ifuX
         FfZ3ei0laGHOA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 3/9] l2tp: use standard API for warning log messages
Date:   Fri, 21 Aug 2020 11:47:22 +0100
Message-Id: <20200821104728.23530-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The l2tp_* log wrappers only emit messages of a given category if the
tunnel or session structure has the appropriate flag set in its debug
field.  Flags default to being unset.

For warning messages, this doesn't make a lot of sense since an
administrator is likely to want to know about datapath warnings without
needing to tweak the debug flags setting for a given tunnel or session
instance.

Modify l2tp_warn callsites to use pr_warn_ratelimited instead for
unconditional output of warning messages.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 32 +++++++++++++-------------------
 net/l2tp/l2tp_ppp.c  |  2 +-
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 53a5556699f8..a0f982add6ad 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -666,10 +666,9 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
 		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
-			l2tp_warn(tunnel, L2TP_MSG_DATA,
-				  "%s: cookie mismatch (%u/%u). Discarding.\n",
-				  tunnel->name, tunnel->tunnel_id,
-				  session->session_id);
+			pr_warn_ratelimited("%s: cookie mismatch (%u/%u). Discarding.\n",
+					    tunnel->name, tunnel->tunnel_id,
+					    session->session_id);
 			atomic_long_inc(&session->stats.rx_cookie_discards);
 			goto discard;
 		}
@@ -725,9 +724,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * If user has configured mandatory sequence numbers, discard.
 		 */
 		if (session->recv_seq) {
-			l2tp_warn(session, L2TP_MSG_SEQ,
-				  "%s: recv data has no seq numbers when required. Discarding.\n",
-				  session->name);
+			pr_warn_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
+					    session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			goto discard;
 		}
@@ -744,9 +742,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 			session->send_seq = 0;
 			l2tp_session_set_header_len(session, tunnel->version);
 		} else if (session->send_seq) {
-			l2tp_warn(session, L2TP_MSG_SEQ,
-				  "%s: recv data has no seq numbers when required. Discarding.\n",
-				  session->name);
+			pr_warn_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
+					    session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			goto discard;
 		}
@@ -839,9 +836,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 
 	/* Short packet? */
 	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
-		l2tp_warn(tunnel, L2TP_MSG_DATA,
-			  "%s: recv short packet (len=%d)\n",
-			  tunnel->name, skb->len);
+		pr_warn_ratelimited("%s: recv short packet (len=%d)\n",
+				    tunnel->name, skb->len);
 		goto error;
 	}
 
@@ -855,9 +851,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
 	if (version != tunnel->version) {
-		l2tp_warn(tunnel, L2TP_MSG_DATA,
-			  "%s: recv protocol version mismatch: got %d expected %d\n",
-			  tunnel->name, version, tunnel->version);
+		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
+				    tunnel->name, version, tunnel->version);
 		goto error;
 	}
 
@@ -895,9 +890,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 			l2tp_session_dec_refcount(session);
 
 		/* Not found? Pass to userspace to deal with */
-		l2tp_warn(tunnel, L2TP_MSG_DATA,
-			  "%s: no session found (%u/%u). Passing up.\n",
-			  tunnel->name, tunnel_id, session_id);
+		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
+				    tunnel->name, tunnel_id, session_id);
 		goto error;
 	}
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 660ea95e0910..bd6bb17dfadb 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -251,7 +251,7 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
 
 no_sock:
 	rcu_read_unlock();
-	l2tp_warn(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
+	pr_warn_ratelimited("%s: no socket in recv\n", session->name);
 	kfree_skb(skb);
 }
 
-- 
2.17.1

