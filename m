Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33122344B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgGQG04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGQGYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AA5C08C5DD;
        Thu, 16 Jul 2020 23:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=n2ODUYKF6/KbpzWzYvYsX0GmzUVJvLLKJNQfebeWuwA=; b=lXo2xnKUT2Zz9SodyFhrLMjmwS
        VsBB6iza3jroWdP5Sn+p2coUEpc32Tto0/NdonV2GZjjjUJnZLETAW3WTnagM/jxob5TZcgU+hzbC
        HBISjz1Y5i4/wF0ozC7HeooMkN7FAMd0Y4jhnbjoPpt4Ogg8KV+nfXWVILf8I4xn/BdcvhbNjRsu1
        cPnwWdGNBM1POBS/rtQa/muCTLCz27XU1JsRtKuKYcIuY5l4x10POJ5OPwtPvqn58fQvtcxG+pzZJ
        As7pZmVBUqITScc1cuBvkoDpFDT3bNTUTeT2PRKmG/D9lFTHcT++szLQhUxkig3T6vQrGWEmS+ybo
        /sfdf1DA==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJmq-00052J-2X; Fri, 17 Jul 2020 06:24:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 05/22] net: remove compat_sock_common_{get,set}sockopt
Date:   Fri, 17 Jul 2020 08:23:14 +0200
Message-Id: <20200717062331.691152-6-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the compat handling to sock_common_{get,set}sockopt instead,
keyed of in_compat_syscall().  This allow to remove the now unused
->compat_{get,set}sockopt methods from struct proto_ops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/net.h      |  6 ------
 include/net/sock.h       |  4 ----
 net/core/sock.c          | 30 ++++++------------------------
 net/dccp/ipv4.c          |  4 ----
 net/dccp/ipv6.c          |  2 --
 net/ieee802154/socket.c  |  8 --------
 net/ipv4/af_inet.c       |  6 ------
 net/ipv6/af_inet6.c      |  4 ----
 net/ipv6/ipv6_sockglue.c | 12 ++----------
 net/ipv6/raw.c           |  2 --
 net/l2tp/l2tp_ip.c       |  4 ----
 net/l2tp/l2tp_ip6.c      |  2 --
 net/mptcp/protocol.c     |  6 ------
 net/phonet/socket.c      |  8 --------
 net/sctp/ipv6.c          |  2 --
 net/sctp/protocol.c      |  4 ----
 16 files changed, 8 insertions(+), 96 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 016a9c5faa3479..858ff1d981540d 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -165,12 +165,6 @@ struct proto_ops {
 				      int optname, char __user *optval, unsigned int optlen);
 	int		(*getsockopt)(struct socket *sock, int level,
 				      int optname, char __user *optval, int __user *optlen);
-#ifdef CONFIG_COMPAT
-	int		(*compat_setsockopt)(struct socket *sock, int level,
-				      int optname, char __user *optval, unsigned int optlen);
-	int		(*compat_getsockopt)(struct socket *sock, int level,
-				      int optname, char __user *optval, int __user *optlen);
-#endif
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);
diff --git a/include/net/sock.h b/include/net/sock.h
index 4bf8841651486d..1fd7cf5fc7516c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1744,10 +1744,6 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags);
 int sock_common_setsockopt(struct socket *sock, int level, int optname,
 				  char __user *optval, unsigned int optlen);
-int compat_sock_common_getsockopt(struct socket *sock, int level,
-		int optname, char __user *optval, int __user *optlen);
-int compat_sock_common_setsockopt(struct socket *sock, int level,
-		int optname, char __user *optval, unsigned int optlen);
 
 void sk_common_release(struct sock *sk);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index e085df79482520..018404d1762682 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3199,23 +3199,14 @@ int sock_common_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
-}
-EXPORT_SYMBOL(sock_common_getsockopt);
-
 #ifdef CONFIG_COMPAT
-int compat_sock_common_getsockopt(struct socket *sock, int level, int optname,
-				  char __user *optval, int __user *optlen)
-{
-	struct sock *sk = sock->sk;
-
-	if (sk->sk_prot->compat_getsockopt != NULL)
+	if (in_compat_syscal() && sk->sk_prot->compat_getsockopt)
 		return sk->sk_prot->compat_getsockopt(sk, level, optname,
 						      optval, optlen);
+#endif
 	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
 }
-EXPORT_SYMBOL(compat_sock_common_getsockopt);
-#endif
+EXPORT_SYMBOL(sock_common_getsockopt);
 
 int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags)
@@ -3240,23 +3231,14 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
-}
-EXPORT_SYMBOL(sock_common_setsockopt);
-
 #ifdef CONFIG_COMPAT
-int compat_sock_common_setsockopt(struct socket *sock, int level, int optname,
-				  char __user *optval, unsigned int optlen)
-{
-	struct sock *sk = sock->sk;
-
-	if (sk->sk_prot->compat_setsockopt != NULL)
+	if (in_compat_syscall() && sk->sk_prot->compat_setsockopt)
 		return sk->sk_prot->compat_setsockopt(sk, level, optname,
 						      optval, optlen);
+#endif
 	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
 }
-EXPORT_SYMBOL(compat_sock_common_setsockopt);
-#endif
+EXPORT_SYMBOL(sock_common_setsockopt);
 
 void sk_common_release(struct sock *sk)
 {
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index a7e989919c5307..316cc5ac0da72b 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -999,10 +999,6 @@ static const struct proto_ops inet_dccp_ops = {
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 };
 
 static struct inet_protosw dccp_v4_protosw = {
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 650187d688519c..b50f85a72cd5fc 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1083,8 +1083,6 @@ static const struct proto_ops inet6_dccp_ops = {
 	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 };
 
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index d93d4531aa9bc5..94ae9662133e30 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -423,10 +423,6 @@ static const struct proto_ops ieee802154_raw_ops = {
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 };
 
 /* DGRAM Sockets (802.15.4 dataframes) */
@@ -986,10 +982,6 @@ static const struct proto_ops ieee802154_dgram_ops = {
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 };
 
 /* Create a socket. Initialise the socket, blank the addresses
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ff141d630bdf09..4307503a6f0b41 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1043,8 +1043,6 @@ const struct proto_ops inet_stream_ops = {
 	.sendpage_locked   = tcp_sendpage_locked,
 	.peek_len	   = tcp_peek_len,
 #ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 	.compat_ioctl	   = inet_compat_ioctl,
 #endif
 	.set_rcvlowat	   = tcp_set_rcvlowat,
@@ -1073,8 +1071,6 @@ const struct proto_ops inet_dgram_ops = {
 	.sendpage	   = inet_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
 #ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 	.compat_ioctl	   = inet_compat_ioctl,
 #endif
 };
@@ -1105,8 +1101,6 @@ static const struct proto_ops inet_sockraw_ops = {
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
 #ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 	.compat_ioctl	   = inet_compat_ioctl,
 #endif
 };
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b304b882e0312f..0306509ab06374 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -688,8 +688,6 @@ const struct proto_ops inet6_stream_ops = {
 	.peek_len	   = tcp_peek_len,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 	.set_rcvlowat	   = tcp_set_rcvlowat,
 };
@@ -717,8 +715,6 @@ const struct proto_ops inet6_dgram_ops = {
 	.set_peek_off	   = sk_set_peek_off,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 };
 
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 20576e87a5f7e8..6ab44ec2c369da 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -914,12 +914,8 @@ int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
 {
 	int err;
 
-	if (level == SOL_IP && sk->sk_type != SOCK_RAW) {
-		if (udp_prot.compat_setsockopt != NULL)
-			return udp_prot.compat_setsockopt(sk, level, optname,
-							  optval, optlen);
+	if (level == SOL_IP && sk->sk_type != SOCK_RAW)
 		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
-	}
 
 	if (level != SOL_IPV6)
 		return -ENOPROTOOPT;
@@ -1480,12 +1476,8 @@ int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
 {
 	int err;
 
-	if (level == SOL_IP && sk->sk_type != SOCK_RAW) {
-		if (udp_prot.compat_getsockopt != NULL)
-			return udp_prot.compat_getsockopt(sk, level, optname,
-							  optval, optlen);
+	if (level == SOL_IP && sk->sk_type != SOCK_RAW)
 		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
-	}
 
 	if (level != SOL_IPV6)
 		return -ENOPROTOOPT;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 8ef5a7b30524fd..e23c6b46175870 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1378,8 +1378,6 @@ const struct proto_ops inet6_sockraw_ops = {
 	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 };
 
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 955662a6dee754..f8d7412cfb3d37 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -638,10 +638,6 @@ static const struct proto_ops l2tp_ip_ops = {
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 };
 
 static struct inet_protosw l2tp_ip_protosw = {
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 526ed2c24dd5e0..2cdc0b7a7a43c3 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -773,8 +773,6 @@ static const struct proto_ops l2tp_ip6_ops = {
 	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 };
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dbe43e0cd734e4..f0b0b503c2628d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2166,10 +2166,6 @@ static const struct proto_ops mptcp_stream_ops = {
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 };
 
 static struct inet_protosw mptcp_protosw = {
@@ -2222,8 +2218,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 	.sendpage	   = inet_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 };
 
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 76d499f6af9ab3..87c60f83c18061 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -441,10 +441,6 @@ const struct proto_ops phonet_dgram_ops = {
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
 	.getsockopt	= sock_no_getsockopt,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = sock_no_setsockopt,
-	.compat_getsockopt = sock_no_getsockopt,
-#endif
 	.sendmsg	= pn_socket_sendmsg,
 	.recvmsg	= sock_common_recvmsg,
 	.mmap		= sock_no_mmap,
@@ -466,10 +462,6 @@ const struct proto_ops phonet_stream_ops = {
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_common_setsockopt,
 	.getsockopt	= sock_common_getsockopt,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 	.sendmsg	= pn_socket_sendmsg,
 	.recvmsg	= sock_common_recvmsg,
 	.mmap		= sock_no_mmap,
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ccfa0ab3e7f481..ebda31b7747d08 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1033,8 +1033,6 @@ static const struct proto_ops inet6_seqpacket_ops = {
 	.mmap		   = sock_no_mmap,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
 };
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index cde29f3c7fb3c4..8d25cc464efdf3 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1036,10 +1036,6 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_sock_common_setsockopt,
-	.compat_getsockopt = compat_sock_common_getsockopt,
-#endif
 };
 
 /* Registration with AF_INET family.  */
-- 
2.27.0

