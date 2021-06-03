Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E493939A6F1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhFCRJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhFCRJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F29A1613F9;
        Thu,  3 Jun 2021 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740085;
        bh=6QKkR5t4coIHM9tRx8EuV6Udze82Okir+WpbB5BRJ1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpqpMXgL/0dzbvLtm/s05y4wobMnyplPDPbULjxNhHGl+msi55tMWPOU2PTwij/Q4
         dxy6hEHqhTziEiRd2cPaUxzgo6RLI+BvhkIfxXSCJZDfA51t2Vv1ArTEZUtjxg4tAy
         t+XxWWKkNBjQTvA2rA18l1XqzSY7FCb3T6vLk8VkKUeDrVgRE9pCygzREnDiDzhCpx
         6OVjuk4H6VwEs3Y87uXluBtadVpm8eBzfH7pZMIynPlLf0in9tNsSixZymYSYUWbN9
         /d5VTvDmjw2QYms302RMIoOWYYLiS0i0dDg6utuI80hdbGCWRg4fXXS2xzgJmQuDig
         Oh7Mb8kiNn+Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.12 25/43] RDS tcp loopback connection can hang
Date:   Thu,  3 Jun 2021 13:07:15 -0400
Message-Id: <20210603170734.3168284-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

[ Upstream commit aced3ce57cd37b5ca332bcacd370d01f5a8c5371 ]

When TCP is used as transport and a program on the
system connects to RDS port 16385, connection is
accepted but denied per the rules of RDS. However,
RDS connections object is left in the list. Next
loopback connection will select that connection
object as it is at the head of list. The connection
attempt will hang as the connection object is set
to connect over TCP which is not allowed

The issue can be reproduced easily, use rds-ping
to ping a local IP address. After that use any
program like ncat to connect to the same IP
address and port 16385. This will hang so ctrl-c out.
Now try rds-ping, it will hang.

To fix the issue this patch adds checks to disallow
the connection object creation and destroys the
connection object.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 23 +++++++++++++++++------
 net/rds/tcp.c        |  4 ++--
 net/rds/tcp.h        |  3 ++-
 net/rds/tcp_listen.c |  6 ++++++
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index f2fcab182095..a3bc4b54d491 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -240,12 +240,23 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	if (loop_trans) {
 		rds_trans_put(loop_trans);
 		conn->c_loopback = 1;
-		if (is_outgoing && trans->t_prefer_loopback) {
-			/* "outgoing" connection - and the transport
-			 * says it wants the connection handled by the
-			 * loopback transport. This is what TCP does.
-			 */
-			trans = &rds_loop_transport;
+		if (trans->t_prefer_loopback) {
+			if (likely(is_outgoing)) {
+				/* "outgoing" connection to local address.
+				 * Protocol says it wants the connection
+				 * handled by the loopback transport.
+				 * This is what TCP does.
+				 */
+				trans = &rds_loop_transport;
+			} else {
+				/* No transport currently in use
+				 * should end up here, but if it
+				 * does, reset/destroy the connection.
+				 */
+				kmem_cache_free(rds_conn_slab, conn);
+				conn = ERR_PTR(-EOPNOTSUPP);
+				goto out;
+			}
 		}
 	}
 
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 43db0eca911f..abf19c0e3ba0 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -313,8 +313,8 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
 }
 #endif
 
-static int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
-			       __u32 scope_id)
+int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
+			__u32 scope_id)
 {
 	struct net_device *dev = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index bad9cf49d565..dc8d745d6857 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -59,7 +59,8 @@ u32 rds_tcp_snd_una(struct rds_tcp_connection *tc);
 u64 rds_tcp_map_seq(struct rds_tcp_connection *tc, u32 seq);
 extern struct rds_transport rds_tcp_transport;
 void rds_tcp_accept_work(struct sock *sk);
-
+int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
+			__u32 scope_id);
 /* tcp_connect.c */
 int rds_tcp_conn_path_connect(struct rds_conn_path *cp);
 void rds_tcp_conn_path_shutdown(struct rds_conn_path *conn);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 101cf14215a0..09cadd556d1e 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -167,6 +167,12 @@ int rds_tcp_accept_one(struct socket *sock)
 	}
 #endif
 
+	if (!rds_tcp_laddr_check(sock_net(sock->sk), peer_addr, dev_if)) {
+		/* local address connection is only allowed via loopback */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	conn = rds_conn_create(sock_net(sock->sk),
 			       my_addr, peer_addr,
 			       &rds_tcp_transport, 0, GFP_KERNEL, dev_if);
-- 
2.30.2

