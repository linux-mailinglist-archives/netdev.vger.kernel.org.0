Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7939A7B8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFCRMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhFCRLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F259B61405;
        Thu,  3 Jun 2021 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740180;
        bh=Ja5bAS1hsg1L75SIVrXZFVHDp1orBzMzdFT05Ril3VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSpt67deaW0MPsY4r63arX0OtrxrfijSZGRAKRPNz+hZ2HBttkTT/2OzjxlK54uAO
         /HdR8LER7QeCu0gJdjzq5xsAZkXJF8icwlRZXNTHVv7wsD1cTQJe0Arc46fN1fVxtQ
         mDxdp9664CdwQk6H4YOtVKLEfpgnUX24HUQFWhHRbdmS+bMQzGo8UfrI6HOn7BSu9K
         iYnWgP5HvQ9NnSqmw/N4lgIgC14lBqBa0o+1f+fiRs4SE7E/Cf4GkQjpRWCFAFmSa6
         Cf4yulAtGIuQYy+x6Iz5bsdTLx3awTgG3WJnSejJRlo/Ftgr+sBk5i35XZ9B+rSxEF
         fcqedh+MWqQcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.4 17/31] RDS tcp loopback connection can hang
Date:   Thu,  3 Jun 2021 13:09:05 -0400
Message-Id: <20210603170919.3169112-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index ed7f2133acc2..c85bd6340eaa 100644
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
index 66121bc6f34e..1402e9166a7e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -323,8 +323,8 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
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
index 3c69361d21c7..4620549ecbeb 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -60,7 +60,8 @@ u32 rds_tcp_snd_una(struct rds_tcp_connection *tc);
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
index 810a3a49e947..26a3e18e460d 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -198,6 +198,12 @@ int rds_tcp_accept_one(struct socket *sock)
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

