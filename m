Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417983E947F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhHKPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:25:11 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:37008 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233057AbhHKPZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:25:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uihn-IW_1628695480;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0Uihn-IW_1628695480)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Aug 2021 23:24:45 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     davem@davemloft.net, David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Wen Yang <wenyang@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] net: return early for possible invalid uaddr
Date:   Wed, 11 Aug 2021 23:24:31 +0800
Message-Id: <20210811152431.66426-2-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811152431.66426-1-wenyang@linux.alibaba.com>
References: <20210811152431.66426-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inet_dgram_connect() first calls inet_autobind() to select an
ephemeral port, then checks uaddr in udp_pre_connect() or
__ip4_datagram_connect(), but the port is not released until the socket
is closed. This could cause performance issues or even exhaust ephemeral
ports if a malicious user makes a large number of UDP connections with
invalid uaddr and/or addr_len.

We should return early for invalid uaddr to fix it.

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/net/inet_common.h |  1 +
 include/net/ipv6.h        |  2 ++
 net/ipv4/af_inet.c        |  8 +++++++-
 net/ipv4/datagram.c       |  7 -------
 net/ipv4/udp.c            |  7 -------
 net/ipv6/af_inet6.c       | 37 ++++++++++++++++++++++++++++++++++++-
 net/ipv6/datagram.c       |  8 --------
 net/ipv6/raw.c            |  2 +-
 net/ipv6/udp.c            | 11 -----------
 net/l2tp/l2tp_ip6.c       |  2 +-
 10 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cad2a61..0fc37c6 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -35,6 +35,7 @@ int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 int inet_listen(struct socket *sock, int backlog);
 void inet_sock_destruct(struct sock *sk);
 int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
+int inet_autobind(struct sock *sk);
 /* Don't allocate port at this moment, defer to connect. */
 #define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
 /* Grab and release socket lock. */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index f2d0ecc..93c1ee2 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1129,6 +1129,8 @@ int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		  int flags);
 
+int inet6_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
+		       int addr_len, int flags);
 /*
  * reassembly.c
  */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 0f6f138..8a8dba7 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -173,7 +173,7 @@ void inet_sock_destruct(struct sock *sk)
  *	Automatically bind an unbound socket.
  */
 
-static int inet_autobind(struct sock *sk)
+int inet_autobind(struct sock *sk)
 {
 	struct inet_sock *inet;
 	/* We may need to bind the socket. */
@@ -189,6 +189,7 @@ static int inet_autobind(struct sock *sk)
 	release_sock(sk);
 	return 0;
 }
+EXPORT_SYMBOL(inet_autobind);
 
 /*
  *	Move a socket into listening state.
@@ -569,6 +570,11 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (uaddr->sa_family == AF_UNSPEC)
 		return sk->sk_prot->disconnect(sk, flags);
 
+	if (uaddr->sa_family != AF_INET)
+		return -EAFNOSUPPORT;
+	if (addr_len < sizeof(struct sockaddr_in))
+		return -EINVAL;
+
 	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
 		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
 		if (err)
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4a8550c..81aae1d 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -27,13 +27,6 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	int oif;
 	int err;
 
-
-	if (addr_len < sizeof(*usin))
-		return -EINVAL;
-
-	if (usin->sin_family != AF_INET)
-		return -EAFNOSUPPORT;
-
 	sk_dst_reset(sk);
 
 	oif = sk->sk_bound_dev_if;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 62cd4cd..1ef0770 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1928,13 +1928,6 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
-	/* This check is replicated from __ip4_datagram_connect() and
-	 * intended to prevent BPF program called below from accessing bytes
-	 * that are out of the bound specified by user in addr_len.
-	 */
-	if (addr_len < sizeof(struct sockaddr_in))
-		return -EINVAL;
-
 	return BPF_CGROUP_RUN_PROG_INET4_CONNECT_LOCK(sk, uaddr);
 }
 EXPORT_SYMBOL(udp_pre_connect);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2389ff7..df1535b 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -462,6 +462,41 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 }
 EXPORT_SYMBOL(inet6_bind);
 
+int inet6_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
+			int addr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	int err;
+
+	if (addr_len < sizeof(uaddr->sa_family))
+		return -EINVAL;
+	if (uaddr->sa_family == AF_UNSPEC)
+		return sk->sk_prot->disconnect(sk, flags);
+
+	if (uaddr->sa_family == AF_INET) {
+		if (__ipv6_only_sock(sk))
+			return -EAFNOSUPPORT;
+		if (addr_len < sizeof(struct sockaddr_in))
+			return -EINVAL;
+	} else {
+		if (uaddr->sa_family != AF_INET6)
+			return -EAFNOSUPPORT;
+		if (addr_len < SIN6_LEN_RFC2133)
+			return -EINVAL;
+	}
+
+	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
+		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
+		if (err)
+			return err;
+	}
+
+	if (data_race(!inet_sk(sk)->inet_num) && inet_autobind(sk))
+		return -EAGAIN;
+	return sk->sk_prot->connect(sk, uaddr, addr_len);
+}
+EXPORT_SYMBOL(inet6_dgram_connect);
+
 int inet6_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -701,7 +736,7 @@ int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
-	.connect	   = inet_dgram_connect,	/* ok		*/
+	.connect	   = inet6_dgram_connect,	/* ok		*/
 	.socketpair	   = sock_no_socketpair,	/* a do nothing	*/
 	.accept		   = sock_no_accept,		/* a do nothing	*/
 	.getname	   = inet6_getname,
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 206f663..731f1aa 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -145,18 +145,10 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	int			err;
 
 	if (usin->sin6_family == AF_INET) {
-		if (__ipv6_only_sock(sk))
-			return -EAFNOSUPPORT;
 		err = __ip4_datagram_connect(sk, uaddr, addr_len);
 		goto ipv4_connected;
 	}
 
-	if (addr_len < SIN6_LEN_RFC2133)
-		return -EINVAL;
-
-	if (usin->sin6_family != AF_INET6)
-		return -EAFNOSUPPORT;
-
 	if (np->sndflow)
 		fl6_flowlabel = usin->sin6_flowinfo & IPV6_FLOWINFO_MASK;
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 60f1e4f..6235447 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1311,7 +1311,7 @@ void raw6_proc_exit(void)
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
-	.connect	   = inet_dgram_connect,	/* ok		*/
+	.connect	   = inet6_dgram_connect,	/* ok		*/
 	.socketpair	   = sock_no_socketpair,	/* a do nothing	*/
 	.accept		   = sock_no_accept,		/* a do nothing	*/
 	.getname	   = inet6_getname,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0cc7ba5..9067f2f3 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1093,21 +1093,10 @@ static void udp_v6_flush_pending_frames(struct sock *sk)
 static int udpv6_pre_connect(struct sock *sk, struct sockaddr *uaddr,
 			     int addr_len)
 {
-	if (addr_len < offsetofend(struct sockaddr, sa_family))
-		return -EINVAL;
-	/* The following checks are replicated from __ip6_datagram_connect()
-	 * and intended to prevent BPF program called below from accessing
-	 * bytes that are out of the bound specified by user in addr_len.
-	 */
 	if (uaddr->sa_family == AF_INET) {
-		if (__ipv6_only_sock(sk))
-			return -EAFNOSUPPORT;
 		return udp_pre_connect(sk, uaddr, addr_len);
 	}
 
-	if (addr_len < SIN6_LEN_RFC2133)
-		return -EINVAL;
-
 	return BPF_CGROUP_RUN_PROG_INET6_CONNECT_LOCK(sk, uaddr);
 }
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 96f9757..1f4946c 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -736,7 +736,7 @@ static int l2tp_ip6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
-	.connect	   = inet_dgram_connect,
+	.connect	   = inet6_dgram_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = l2tp_ip6_getname,
-- 
1.8.3.1

