Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB23F8E61
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKLLSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:18:13 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50847 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbfKLLSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:18:13 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9U-0003FA-27; Tue, 12 Nov 2019 12:16:04 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004yZ-Bt; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+afd421337a736d6c1ee6@syzkaller.appspotmail.com,
        syzbot+6d04f6a1b31a0ae12ca9@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1 4/9] can: j1939: socket: rework socket locking for j1939_sk_release() and j1939_sk_sendmsg()
Date:   Tue, 12 Nov 2019 12:15:55 +0100
Message-Id: <20191112111600.18719-5-o.rempel@pengutronix.de>
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

j1939_sk_sendmsg() should be protected by lock_sock() to avoid race with
j1939_sk_bind() and j1939_sk_release().

Reported-by: syzbot+afd421337a736d6c1ee6@syzkaller.appspotmail.com
Reported-by: syzbot+6d04f6a1b31a0ae12ca9@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/socket.c | 57 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index aee94b09ef08..de09b0a65791 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -593,8 +593,8 @@ static int j1939_sk_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
-	jsk = j1939_sk(sk);
 	lock_sock(sk);
+	jsk = j1939_sk(sk);
 
 	if (jsk->state & J1939_SOCK_BOUND) {
 		struct j1939_priv *priv = jsk->priv;
@@ -1092,51 +1092,72 @@ static int j1939_sk_sendmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct j1939_sock *jsk = j1939_sk(sk);
-	struct j1939_priv *priv = jsk->priv;
+	struct j1939_priv *priv;
 	int ifindex;
 	int ret;
 
+	lock_sock(sock->sk);
 	/* various socket state tests */
-	if (!(jsk->state & J1939_SOCK_BOUND))
-		return -EBADFD;
+	if (!(jsk->state & J1939_SOCK_BOUND)) {
+		ret = -EBADFD;
+		goto sendmsg_done;
+	}
 
+	priv = jsk->priv;
 	ifindex = jsk->ifindex;
 
-	if (!jsk->addr.src_name && jsk->addr.sa == J1939_NO_ADDR)
+	if (!jsk->addr.src_name && jsk->addr.sa == J1939_NO_ADDR) {
 		/* no source address assigned yet */
-		return -EBADFD;
+		ret = -EBADFD;
+		goto sendmsg_done;
+	}
 
 	/* deal with provided destination address info */
 	if (msg->msg_name) {
 		struct sockaddr_can *addr = msg->msg_name;
 
-		if (msg->msg_namelen < J1939_MIN_NAMELEN)
-			return -EINVAL;
+		if (msg->msg_namelen < J1939_MIN_NAMELEN) {
+			ret = -EINVAL;
+			goto sendmsg_done;
+		}
 
-		if (addr->can_family != AF_CAN)
-			return -EINVAL;
+		if (addr->can_family != AF_CAN) {
+			ret = -EINVAL;
+			goto sendmsg_done;
+		}
 
-		if (addr->can_ifindex && addr->can_ifindex != ifindex)
-			return -EBADFD;
+		if (addr->can_ifindex && addr->can_ifindex != ifindex) {
+			ret = -EBADFD;
+			goto sendmsg_done;
+		}
 
 		if (j1939_pgn_is_valid(addr->can_addr.j1939.pgn) &&
-		    !j1939_pgn_is_clean_pdu(addr->can_addr.j1939.pgn))
-			return -EINVAL;
+		    !j1939_pgn_is_clean_pdu(addr->can_addr.j1939.pgn)) {
+			ret = -EINVAL;
+			goto sendmsg_done;
+		}
 
 		if (!addr->can_addr.j1939.name &&
 		    addr->can_addr.j1939.addr == J1939_NO_ADDR &&
-		    !sock_flag(sk, SOCK_BROADCAST))
+		    !sock_flag(sk, SOCK_BROADCAST)) {
 			/* broadcast, but SO_BROADCAST not set */
-			return -EACCES;
+			ret = -EACCES;
+			goto sendmsg_done;
+		}
 	} else {
 		if (!jsk->addr.dst_name && jsk->addr.da == J1939_NO_ADDR &&
-		    !sock_flag(sk, SOCK_BROADCAST))
+		    !sock_flag(sk, SOCK_BROADCAST)) {
 			/* broadcast, but SO_BROADCAST not set */
-			return -EACCES;
+			ret = -EACCES;
+			goto sendmsg_done;
+		}
 	}
 
 	ret = j1939_sk_send_loop(priv, sk, msg, size);
 
+sendmsg_done:
+	release_sock(sock->sk);
+
 	return ret;
 }
 
-- 
2.24.0.rc1

