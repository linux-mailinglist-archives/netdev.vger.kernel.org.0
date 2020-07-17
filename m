Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BE02233B5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgGQGYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgGQGYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E0AC061755;
        Thu, 16 Jul 2020 23:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gprtfGHH57kbYosRry7VIZLZevW2g4f/6blQ/81HjxI=; b=dJFHTMDh0B5sK4FzdAGWodS0Do
        CJt6Voat/rSpR8bsqwNLJ1mfQqEVmSggviOKyStmYokIKb3lk+8ykgRzchSOQKar4qWMrSs8iIf+X
        HKgGh+LLHzTRsy7BUSJcNquLY0h3V1qUfH3/wxljYe9M9Trzov9lqgWBY/SFtHgoHoRalAeW1EhTE
        TafdAT3NCkCR0N4UXVeYQh+51f1h/dwhz2bCuYxgA3sQqrCSEWGiOYC/4eQUOOEMIriQAZpUnnrcX
        LSb7g2N3fQvGyfe9r7TBrlLtK5lVf2z5Xsetf/8d3acExVTNlm0+gTmPy7Cje56sFU3ZQJtjhoWGJ
        Eb7ODvpQ==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJnK-00056h-Dd; Fri, 17 Jul 2020 06:24:31 +0000
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
Subject: [PATCH 21/22] net/ipv6: remove compat_ipv6_{get,set}sockopt
Date:   Fri, 17 Jul 2020 08:23:30 +0200
Message-Id: <20200717062331.691152-22-hch@lst.de>
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

Handle the few cases that need special treatment in-line using
in_compat_syscall().  This also removes all the now unused
compat_{get,set}sockopt methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/inet_connection_sock.h |  13 --
 include/net/ipv6.h                 |   4 -
 include/net/sctp/structs.h         |  10 --
 include/net/sock.h                 |   8 --
 include/net/tcp.h                  |   4 -
 net/core/sock.c                    |  10 --
 net/dccp/dccp.h                    |   6 -
 net/dccp/ipv4.c                    |   4 -
 net/dccp/ipv6.c                    |  12 --
 net/dccp/proto.c                   |  26 ----
 net/ipv4/inet_connection_sock.c    |  28 -----
 net/ipv4/tcp.c                     |  24 ----
 net/ipv4/tcp_ipv4.c                |   4 -
 net/ipv6/ipv6_sockglue.c           | 183 ++++++++---------------------
 net/ipv6/raw.c                     |  50 --------
 net/ipv6/tcp_ipv6.c                |  12 --
 net/ipv6/udp.c                     |  25 ----
 net/ipv6/udp_impl.h                |   6 -
 net/ipv6/udplite.c                 |   4 -
 net/l2tp/l2tp_ip6.c                |   4 -
 net/sctp/ipv6.c                    |   4 -
 21 files changed, 51 insertions(+), 390 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index e5b388f5fa2099..157c60cca0ca60 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -48,14 +48,6 @@ struct inet_connection_sock_af_ops {
 				  char __user *optval, unsigned int optlen);
 	int	    (*getsockopt)(struct sock *sk, int level, int optname,
 				  char __user *optval, int __user *optlen);
-#ifdef CONFIG_COMPAT
-	int	    (*compat_setsockopt)(struct sock *sk,
-				int level, int optname,
-				char __user *optval, unsigned int optlen);
-	int	    (*compat_getsockopt)(struct sock *sk,
-				int level, int optname,
-				char __user *optval, int __user *optlen);
-#endif
 	void	    (*addr2sockaddr)(struct sock *sk, struct sockaddr *);
 	void	    (*mtu_reduced)(struct sock *sk);
 };
@@ -311,11 +303,6 @@ void inet_csk_listen_stop(struct sock *sk);
 
 void inet_csk_addr2sockaddr(struct sock *sk, struct sockaddr *uaddr);
 
-int inet_csk_compat_getsockopt(struct sock *sk, int level, int optname,
-			       char __user *optval, int __user *optlen);
-int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
-			       char __user *optval, unsigned int optlen);
-
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
 #define TCP_PINGPONG_THRESH	3
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5e65bf2fd32d09..262fc88dbd7e2f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1088,10 +1088,6 @@ int ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen);
 int ipv6_getsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, int __user *optlen);
-int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, unsigned int optlen);
-int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen);
 
 int __ip6_datagram_connect(struct sock *sk, struct sockaddr *addr,
 			   int addr_len);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 9bbb2f60db9262..233bbf7df5d66c 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -438,16 +438,6 @@ struct sctp_af {
 					 int optname,
 					 char __user *optval,
 					 int __user *optlen);
-	int		(*compat_setsockopt)	(struct sock *sk,
-					 int level,
-					 int optname,
-					 char __user *optval,
-					 unsigned int optlen);
-	int		(*compat_getsockopt)	(struct sock *sk,
-					 int level,
-					 int optname,
-					 char __user *optval,
-					 int __user *optlen);
 	void		(*get_dst)	(struct sctp_transport *t,
 					 union sctp_addr *saddr,
 					 struct flowi *fl,
diff --git a/include/net/sock.h b/include/net/sock.h
index 1fd7cf5fc7516c..3bd8bc578bf3e5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1147,14 +1147,6 @@ struct proto {
 					int __user *option);
 	void			(*keepalive)(struct sock *sk, int valbool);
 #ifdef CONFIG_COMPAT
-	int			(*compat_setsockopt)(struct sock *sk,
-					int level,
-					int optname, char __user *optval,
-					unsigned int optlen);
-	int			(*compat_getsockopt)(struct sock *sk,
-					int level,
-					int optname, char __user *optval,
-					int __user *option);
 	int			(*compat_ioctl)(struct sock *sk,
 					unsigned int cmd, unsigned long arg);
 #endif
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d62e24533518a7..9f7f7c0c110451 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -401,10 +401,6 @@ int tcp_getsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, int __user *optlen);
 int tcp_setsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, unsigned int optlen);
-int compat_tcp_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen);
-int compat_tcp_setsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, unsigned int optlen);
 void tcp_set_keepalive(struct sock *sk, int val);
 void tcp_syn_ack_timeout(const struct request_sock *req);
 int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
diff --git a/net/core/sock.c b/net/core/sock.c
index 018404d1762682..48655d5c4cf37a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3199,11 +3199,6 @@ int sock_common_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
-#ifdef CONFIG_COMPAT
-	if (in_compat_syscal() && sk->sk_prot->compat_getsockopt)
-		return sk->sk_prot->compat_getsockopt(sk, level, optname,
-						      optval, optlen);
-#endif
 	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_getsockopt);
@@ -3231,11 +3226,6 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
-#ifdef CONFIG_COMPAT
-	if (in_compat_syscall() && sk->sk_prot->compat_setsockopt)
-		return sk->sk_prot->compat_setsockopt(sk, level, optname,
-						      optval, optlen);
-#endif
 	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 7dce4f6c70252d..434eea91b7679d 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -296,12 +296,6 @@ int dccp_getsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, int __user *optlen);
 int dccp_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen);
-#ifdef CONFIG_COMPAT
-int compat_dccp_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen);
-int compat_dccp_setsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, unsigned int optlen);
-#endif
 int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int dccp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index b91373eb1c7974..9c28c825112533 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -959,10 +959,6 @@ static struct proto dccp_v4_prot = {
 	.rsk_prot		= &dccp_request_sock_ops,
 	.twsk_prot		= &dccp_timewait_sock_ops,
 	.h.hashinfo		= &dccp_hashinfo,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt	= compat_dccp_setsockopt,
-	.compat_getsockopt	= compat_dccp_getsockopt,
-#endif
 };
 
 static const struct net_protocol dccp_v4_protocol = {
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b50f85a72cd5fc..ef4ab28cfde0e3 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -970,10 +970,6 @@ static const struct inet_connection_sock_af_ops dccp_ipv6_af_ops = {
 	.getsockopt	   = ipv6_getsockopt,
 	.addr2sockaddr	   = inet6_csk_addr2sockaddr,
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ipv6_setsockopt,
-	.compat_getsockopt = compat_ipv6_getsockopt,
-#endif
 };
 
 /*
@@ -990,10 +986,6 @@ static const struct inet_connection_sock_af_ops dccp_ipv6_mapped = {
 	.getsockopt	   = ipv6_getsockopt,
 	.addr2sockaddr	   = inet6_csk_addr2sockaddr,
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ipv6_setsockopt,
-	.compat_getsockopt = compat_ipv6_getsockopt,
-#endif
 };
 
 /* NOTE: A lot of things set to zero explicitly by call to
@@ -1049,10 +1041,6 @@ static struct proto dccp_v6_prot = {
 	.rsk_prot	   = &dccp6_request_sock_ops,
 	.twsk_prot	   = &dccp6_timewait_sock_ops,
 	.h.hashinfo	   = &dccp_hashinfo,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_dccp_setsockopt,
-	.compat_getsockopt = compat_dccp_getsockopt,
-#endif
 };
 
 static const struct inet6_protocol dccp_v6_protocol = {
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index c13b6609474b65..fd92d3fe321f08 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -575,19 +575,6 @@ int dccp_setsockopt(struct sock *sk, int level, int optname,
 
 EXPORT_SYMBOL_GPL(dccp_setsockopt);
 
-#ifdef CONFIG_COMPAT
-int compat_dccp_setsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, unsigned int optlen)
-{
-	if (level != SOL_DCCP)
-		return inet_csk_compat_setsockopt(sk, level, optname,
-						  optval, optlen);
-	return do_dccp_setsockopt(sk, level, optname, optval, optlen);
-}
-
-EXPORT_SYMBOL_GPL(compat_dccp_setsockopt);
-#endif
-
 static int dccp_getsockopt_service(struct sock *sk, int len,
 				   __be32 __user *optval,
 				   int __user *optlen)
@@ -696,19 +683,6 @@ int dccp_getsockopt(struct sock *sk, int level, int optname,
 
 EXPORT_SYMBOL_GPL(dccp_getsockopt);
 
-#ifdef CONFIG_COMPAT
-int compat_dccp_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen)
-{
-	if (level != SOL_DCCP)
-		return inet_csk_compat_getsockopt(sk, level, optname,
-						  optval, optlen);
-	return do_dccp_getsockopt(sk, level, optname, optval, optlen);
-}
-
-EXPORT_SYMBOL_GPL(compat_dccp_getsockopt);
-#endif
-
 static int dccp_msghdr_parse(struct msghdr *msg, struct sk_buff *skb)
 {
 	struct cmsghdr *cmsg;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 22b0e7336360f3..d1a3913eebe05f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1057,34 +1057,6 @@ void inet_csk_addr2sockaddr(struct sock *sk, struct sockaddr *uaddr)
 }
 EXPORT_SYMBOL_GPL(inet_csk_addr2sockaddr);
 
-#ifdef CONFIG_COMPAT
-int inet_csk_compat_getsockopt(struct sock *sk, int level, int optname,
-			       char __user *optval, int __user *optlen)
-{
-	const struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_af_ops->compat_getsockopt)
-		return icsk->icsk_af_ops->compat_getsockopt(sk, level, optname,
-							    optval, optlen);
-	return icsk->icsk_af_ops->getsockopt(sk, level, optname,
-					     optval, optlen);
-}
-EXPORT_SYMBOL_GPL(inet_csk_compat_getsockopt);
-
-int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
-			       char __user *optval, unsigned int optlen)
-{
-	const struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_af_ops->compat_setsockopt)
-		return icsk->icsk_af_ops->compat_setsockopt(sk, level, optname,
-							    optval, optlen);
-	return icsk->icsk_af_ops->setsockopt(sk, level, optname,
-					     optval, optlen);
-}
-EXPORT_SYMBOL_GPL(inet_csk_compat_setsockopt);
-#endif
-
 static struct dst_entry *inet_csk_rebuild_route(struct sock *sk, struct flowi *fl)
 {
 	const struct inet_sock *inet = inet_sk(sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 254b6a4cc95bd0..58ede3d62b2e2c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3337,18 +3337,6 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, char __user *optval,
 }
 EXPORT_SYMBOL(tcp_setsockopt);
 
-#ifdef CONFIG_COMPAT
-int compat_tcp_setsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, unsigned int optlen)
-{
-	if (level != SOL_TCP)
-		return inet_csk_compat_setsockopt(sk, level, optname,
-						  optval, optlen);
-	return do_tcp_setsockopt(sk, level, optname, optval, optlen);
-}
-EXPORT_SYMBOL(compat_tcp_setsockopt);
-#endif
-
 static void tcp_get_info_chrono_stats(const struct tcp_sock *tp,
 				      struct tcp_info *info)
 {
@@ -3896,18 +3884,6 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 }
 EXPORT_SYMBOL(tcp_getsockopt);
 
-#ifdef CONFIG_COMPAT
-int compat_tcp_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen)
-{
-	if (level != SOL_TCP)
-		return inet_csk_compat_getsockopt(sk, level, optname,
-						  optval, optlen);
-	return do_tcp_getsockopt(sk, level, optname, optval, optlen);
-}
-EXPORT_SYMBOL(compat_tcp_getsockopt);
-#endif
-
 #ifdef CONFIG_TCP_MD5SIG
 static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
 static DEFINE_MUTEX(tcp_md5sig_mutex);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e5b7ef9a288769..cd81b6e04efbfa 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2769,10 +2769,6 @@ struct proto tcp_prot = {
 	.rsk_prot		= &tcp_request_sock_ops,
 	.h.hashinfo		= &tcp_hashinfo,
 	.no_autobind		= true,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt	= compat_tcp_setsockopt,
-	.compat_getsockopt	= compat_tcp_getsockopt,
-#endif
 	.diag_destroy		= tcp_abort,
 };
 EXPORT_SYMBOL(tcp_prot);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 1ea0cd12beaee9..add8f791229945 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -136,13 +136,42 @@ static bool setsockopt_needs_rtnl(int optname)
 	return false;
 }
 
+static int copy_group_source_from_user(struct group_source_req *greqs,
+		void __user *optval, int optlen)
+{
+	if (in_compat_syscall()) {
+		struct compat_group_source_req gr32;
+
+		if (optlen < sizeof(gr32))
+			return -EINVAL;
+		if (copy_from_user(&gr32, optval, sizeof(gr32)))
+			return -EFAULT;
+		greqs->gsr_interface = gr32.gsr_interface;
+		greqs->gsr_group = gr32.gsr_group;
+		greqs->gsr_source = gr32.gsr_source;
+	} else {
+		if (optlen < sizeof(*greqs))
+			return -EINVAL;
+		if (copy_from_user(greqs, optval, sizeof(*greqs)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int do_ipv6_mcast_group_source(struct sock *sk, int optname,
-				      struct group_source_req *greqs)
+		void __user *optval, int optlen)
 {
+	struct group_source_req greqs;
 	int omode, add;
+	int ret;
+
+	ret = copy_group_source_from_user(&greqs, optval, optlen);
+	if (ret)
+		return ret;
 
-	if (greqs->gsr_group.ss_family != AF_INET6 ||
-	    greqs->gsr_source.ss_family != AF_INET6)
+	if (greqs.gsr_group.ss_family != AF_INET6 ||
+	    greqs.gsr_source.ss_family != AF_INET6)
 		return -EADDRNOTAVAIL;
 
 	if (optname == MCAST_BLOCK_SOURCE) {
@@ -155,8 +184,8 @@ static int do_ipv6_mcast_group_source(struct sock *sk, int optname,
 		struct sockaddr_in6 *psin6;
 		int retv;
 
-		psin6 = (struct sockaddr_in6 *)&greqs->gsr_group;
-		retv = ipv6_sock_mc_join_ssm(sk, greqs->gsr_interface,
+		psin6 = (struct sockaddr_in6 *)&greqs.gsr_group;
+		retv = ipv6_sock_mc_join_ssm(sk, greqs.gsr_interface,
 					     &psin6->sin6_addr,
 					     MCAST_INCLUDE);
 		/* prior join w/ different source is ok */
@@ -168,7 +197,7 @@ static int do_ipv6_mcast_group_source(struct sock *sk, int optname,
 		omode = MCAST_INCLUDE;
 		add = 0;
 	}
-	return ip6_mc_source(add, omode, sk, greqs);
+	return ip6_mc_source(add, omode, sk, &greqs);
 }
 
 static int ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
@@ -202,7 +231,6 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
 static int compat_ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 		int optlen)
 {
@@ -236,21 +264,16 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 	if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen)
 		goto out_free_p;
 
-	rtnl_lock();
-	lock_sock(sk);
 	ret = ip6_mc_msfilter(sk, &(struct group_filter){
 			.gf_interface = gf32->gf_interface,
 			.gf_group = gf32->gf_group,
 			.gf_fmode = gf32->gf_fmode,
 			.gf_numsrc = gf32->gf_numsrc}, gf32->gf_slist);
-	release_sock(sk);
-	rtnl_unlock();
 
 out_free_p:
 	kfree(p);
 	return ret;
 }
-#endif
 
 static int ipv6_mcast_join_leave(struct sock *sk, int optname,
 		void __user *optval, int optlen)
@@ -272,13 +295,11 @@ static int ipv6_mcast_join_leave(struct sock *sk, int optname,
 	return ipv6_sock_mc_drop(sk, greq.gr_interface, &psin6->sin6_addr);
 }
 
-#ifdef CONFIG_COMPAT
 static int compat_ipv6_mcast_join_leave(struct sock *sk, int optname,
 		void __user *optval, int optlen)
 {
 	struct compat_group_req gr32;
 	struct sockaddr_in6 *psin6;
-	int err;
 
 	if (optlen < sizeof(gr32))
 		return -EINVAL;
@@ -287,20 +308,12 @@ static int compat_ipv6_mcast_join_leave(struct sock *sk, int optname,
 
 	if (gr32.gr_group.ss_family != AF_INET6)
 		return -EADDRNOTAVAIL;
-	rtnl_lock();
-	lock_sock(sk);
 	psin6 = (struct sockaddr_in6 *)&gr32.gr_group;
 	if (optname == MCAST_JOIN_GROUP)
-		err = ipv6_sock_mc_join(sk, gr32.gr_interface,
+		return ipv6_sock_mc_join(sk, gr32.gr_interface,
 					&psin6->sin6_addr);
-	else
-		err = ipv6_sock_mc_drop(sk, gr32.gr_interface,
-					&psin6->sin6_addr);
-	release_sock(sk);
-	rtnl_unlock();
-	return err;
+	return ipv6_sock_mc_drop(sk, gr32.gr_interface, &psin6->sin6_addr);
 }
-#endif
 
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
@@ -853,26 +866,25 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
-		retv = ipv6_mcast_join_leave(sk, optname, optval, optlen);
+		if (in_compat_syscall())
+			retv = compat_ipv6_mcast_join_leave(sk, optname, optval,
+							    optlen);
+		else
+			retv = ipv6_mcast_join_leave(sk, optname, optval,
+						     optlen);
 		break;
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
 	case MCAST_UNBLOCK_SOURCE:
-	{
-		struct group_source_req greqs;
-
-		if (optlen < sizeof(struct group_source_req))
-			goto e_inval;
-		if (copy_from_user(&greqs, optval, sizeof(greqs))) {
-			retv = -EFAULT;
-			break;
-		}
-		retv = do_ipv6_mcast_group_source(sk, optname, &greqs);
+		retv = do_ipv6_mcast_group_source(sk, optname, optval, optlen);
 		break;
-	}
 	case MCAST_MSFILTER:
-		retv = ipv6_set_mcast_msfilter(sk, optval, optlen);
+		if (in_compat_syscall())
+			retv = compat_ipv6_set_mcast_msfilter(sk, optval,
+							      optlen);
+		else
+			retv = ipv6_set_mcast_msfilter(sk, optval, optlen);
 		break;
 	case IPV6_ROUTER_ALERT:
 		if (optlen < sizeof(int))
@@ -989,64 +1001,6 @@ int ipv6_setsockopt(struct sock *sk, int level, int optname,
 }
 EXPORT_SYMBOL(ipv6_setsockopt);
 
-#ifdef CONFIG_COMPAT
-int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, unsigned int optlen)
-{
-	int err;
-
-	if (level == SOL_IP && sk->sk_type != SOCK_RAW)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
-
-	if (level != SOL_IPV6)
-		return -ENOPROTOOPT;
-
-	switch (optname) {
-	case MCAST_JOIN_GROUP:
-	case MCAST_LEAVE_GROUP:
-		return compat_ipv6_mcast_join_leave(sk, optname, optval,
-						    optlen);
-	case MCAST_JOIN_SOURCE_GROUP:
-	case MCAST_LEAVE_SOURCE_GROUP:
-	case MCAST_BLOCK_SOURCE:
-	case MCAST_UNBLOCK_SOURCE:
-	{
-		struct compat_group_source_req __user *gsr32 = (void __user *)optval;
-		struct group_source_req greqs;
-
-		if (optlen < sizeof(struct compat_group_source_req))
-			return -EINVAL;
-
-		if (get_user(greqs.gsr_interface, &gsr32->gsr_interface) ||
-		    copy_from_user(&greqs.gsr_group, &gsr32->gsr_group,
-				sizeof(greqs.gsr_group)) ||
-		    copy_from_user(&greqs.gsr_source, &gsr32->gsr_source,
-				sizeof(greqs.gsr_source)))
-			return -EFAULT;
-
-		rtnl_lock();
-		lock_sock(sk);
-		err = do_ipv6_mcast_group_source(sk, optname, &greqs);
-		release_sock(sk);
-		rtnl_unlock();
-		return err;
-	}
-	case MCAST_MSFILTER:
-		return compat_ipv6_set_mcast_msfilter(sk, optval, optlen);
-	}
-
-	err = do_ipv6_setsockopt(sk, level, optname, optval, optlen);
-#ifdef CONFIG_NETFILTER
-	/* we need to exclude all possible ENOPROTOOPTs except default case */
-	if (err == -ENOPROTOOPT && optname != IPV6_IPSEC_POLICY &&
-	    optname != IPV6_XFRM_POLICY)
-		err = nf_setsockopt(sk, PF_INET6, optname, optval, optlen);
-#endif
-	return err;
-}
-EXPORT_SYMBOL(compat_ipv6_setsockopt);
-#endif
-
 static int ipv6_getsockopt_sticky(struct sock *sk, struct ipv6_txoptions *opt,
 				  int optname, char __user *optval, int len)
 {
@@ -1110,7 +1064,6 @@ static int ipv6_get_msfilter(struct sock *sk, void __user *optval,
 	return err;
 }
 
-#ifdef CONFIG_COMPAT
 static int compat_ipv6_get_msfilter(struct sock *sk, void __user *optval,
 		int __user *optlen)
 {
@@ -1150,7 +1103,6 @@ static int compat_ipv6_get_msfilter(struct sock *sk, void __user *optval,
 		return -EFAULT;
 	return 0;
 }
-#endif
 
 static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, int __user *optlen, unsigned int flags)
@@ -1175,6 +1127,8 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		val = sk->sk_family;
 		break;
 	case MCAST_MSFILTER:
+		if (in_compat_syscall())
+			return compat_ipv6_get_msfilter(sk, optval, optlen);
 		return ipv6_get_msfilter(sk, optval, optlen, len);
 	case IPV6_2292PKTOPTIONS:
 	{
@@ -1523,38 +1477,3 @@ int ipv6_getsockopt(struct sock *sk, int level, int optname,
 	return err;
 }
 EXPORT_SYMBOL(ipv6_getsockopt);
-
-#ifdef CONFIG_COMPAT
-int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen)
-{
-	int err;
-
-	if (level == SOL_IP && sk->sk_type != SOCK_RAW)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
-
-	if (level != SOL_IPV6)
-		return -ENOPROTOOPT;
-
-	if (optname == MCAST_MSFILTER)
-		return compat_ipv6_get_msfilter(sk, optval, optlen);
-
-	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen,
-				 MSG_CMSG_COMPAT);
-#ifdef CONFIG_NETFILTER
-	/* we need to exclude all possible ENOPROTOOPTs except default case */
-	if (err == -ENOPROTOOPT && optname != IPV6_2292PKTOPTIONS) {
-		int len;
-
-		if (get_user(len, optlen))
-			return -EFAULT;
-
-		err = nf_getsockopt(sk, PF_INET6, optname, optval, &len);
-		if (err >= 0)
-			err = put_user(len, optlen);
-	}
-#endif
-	return err;
-}
-EXPORT_SYMBOL(compat_ipv6_getsockopt);
-#endif
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index e23c6b46175870..594e01ad670aa6 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1084,30 +1084,6 @@ static int rawv6_setsockopt(struct sock *sk, int level, int optname,
 	return do_rawv6_setsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-static int compat_rawv6_setsockopt(struct sock *sk, int level, int optname,
-				   char __user *optval, unsigned int optlen)
-{
-	switch (level) {
-	case SOL_RAW:
-		break;
-	case SOL_ICMPV6:
-		if (inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
-			return -EOPNOTSUPP;
-		return rawv6_seticmpfilter(sk, level, optname, optval, optlen);
-	case SOL_IPV6:
-		if (optname == IPV6_CHECKSUM ||
-		    optname == IPV6_HDRINCL)
-			break;
-		fallthrough;
-	default:
-		return compat_ipv6_setsockopt(sk, level, optname,
-					      optval, optlen);
-	}
-	return do_rawv6_setsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 static int do_rawv6_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {
@@ -1169,30 +1145,6 @@ static int rawv6_getsockopt(struct sock *sk, int level, int optname,
 	return do_rawv6_getsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-static int compat_rawv6_getsockopt(struct sock *sk, int level, int optname,
-				   char __user *optval, int __user *optlen)
-{
-	switch (level) {
-	case SOL_RAW:
-		break;
-	case SOL_ICMPV6:
-		if (inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
-			return -EOPNOTSUPP;
-		return rawv6_geticmpfilter(sk, level, optname, optval, optlen);
-	case SOL_IPV6:
-		if (optname == IPV6_CHECKSUM ||
-		    optname == IPV6_HDRINCL)
-			break;
-		fallthrough;
-	default:
-		return compat_ipv6_getsockopt(sk, level, optname,
-					      optval, optlen);
-	}
-	return do_rawv6_getsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 static int rawv6_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -1297,8 +1249,6 @@ struct proto rawv6_prot = {
 	.usersize	   = sizeof_field(struct raw6_sock, filter),
 	.h.raw_hash	   = &raw_v6_hashinfo,
 #ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_rawv6_setsockopt,
-	.compat_getsockopt = compat_rawv6_getsockopt,
 	.compat_ioctl	   = compat_rawv6_ioctl,
 #endif
 	.diag_destroy	   = raw_abort,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4502db706f7534..c34b7834fd84a8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1831,10 +1831,6 @@ const struct inet_connection_sock_af_ops ipv6_specific = {
 	.getsockopt	   = ipv6_getsockopt,
 	.addr2sockaddr	   = inet6_csk_addr2sockaddr,
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ipv6_setsockopt,
-	.compat_getsockopt = compat_ipv6_getsockopt,
-#endif
 	.mtu_reduced	   = tcp_v6_mtu_reduced,
 };
 
@@ -1861,10 +1857,6 @@ static const struct inet_connection_sock_af_ops ipv6_mapped = {
 	.getsockopt	   = ipv6_getsockopt,
 	.addr2sockaddr	   = inet6_csk_addr2sockaddr,
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ipv6_setsockopt,
-	.compat_getsockopt = compat_ipv6_getsockopt,
-#endif
 	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 
@@ -2122,10 +2114,6 @@ struct proto tcpv6_prot = {
 	.rsk_prot		= &tcp6_request_sock_ops,
 	.h.hashinfo		= &tcp_hashinfo,
 	.no_autobind		= true,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt	= compat_tcp_setsockopt,
-	.compat_getsockopt	= compat_tcp_getsockopt,
-#endif
 	.diag_destroy		= tcp_abort,
 };
 EXPORT_SYMBOL_GPL(tcpv6_prot);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 38c0d9350c6b8f..5aff0856a05b44 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1570,17 +1570,6 @@ int udpv6_setsockopt(struct sock *sk, int level, int optname,
 	return ipv6_setsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-int compat_udpv6_setsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, unsigned int optlen)
-{
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
-		return udp_lib_setsockopt(sk, level, optname, optval, optlen,
-					  udp_v6_push_pending_frames);
-	return compat_ipv6_setsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 int udpv6_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *optlen)
 {
@@ -1589,16 +1578,6 @@ int udpv6_getsockopt(struct sock *sk, int level, int optname,
 	return ipv6_getsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-int compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *optlen)
-{
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
-		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
-	return compat_ipv6_getsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 /* thinking of making this const? Don't.
  * early_demux can change based on sysctl.
  */
@@ -1681,10 +1660,6 @@ struct proto udpv6_prot = {
 	.sysctl_rmem_offset     = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp6_sock),
 	.h.udp_table		= &udp_table,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt	= compat_udpv6_setsockopt,
-	.compat_getsockopt	= compat_udpv6_getsockopt,
-#endif
 	.diag_destroy		= udp_abort,
 };
 
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 20e324b6f3584e..30dfb6f1b7622a 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -19,12 +19,6 @@ int udpv6_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *optlen);
 int udpv6_setsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, unsigned int optlen);
-#ifdef CONFIG_COMPAT
-int compat_udpv6_setsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, unsigned int optlen);
-int compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *optlen);
-#endif
 int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
 int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		  int flags, int *addr_len);
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index bf7a7acd39b1d5..fbb700d3f437ee 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -52,10 +52,6 @@ struct proto udplitev6_prot = {
 	.sysctl_mem	   = sysctl_udp_mem,
 	.obj_size	   = sizeof(struct udp6_sock),
 	.h.udp_table	   = &udplite_table,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_udpv6_setsockopt,
-	.compat_getsockopt = compat_udpv6_getsockopt,
-#endif
 };
 
 static struct inet_protosw udplite6_protosw = {
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2cdc0b7a7a43c3..4799bec87b332f 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -745,10 +745,6 @@ static struct proto l2tp_ip6_prot = {
 	.hash		   = l2tp_ip6_hash,
 	.unhash		   = l2tp_ip6_unhash,
 	.obj_size	   = sizeof(struct l2tp_ip6_sock),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ipv6_setsockopt,
-	.compat_getsockopt = compat_ipv6_getsockopt,
-#endif
 };
 
 static const struct proto_ops l2tp_ip6_ops = {
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ebda31b7747d08..aea2a982984d02 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1087,10 +1087,6 @@ static struct sctp_af sctp_af_inet6 = {
 	.net_header_len	   = sizeof(struct ipv6hdr),
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
 	.ip_options_len	   = sctp_v6_ip_options_len,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ipv6_setsockopt,
-	.compat_getsockopt = compat_ipv6_getsockopt,
-#endif
 };
 
 static struct sctp_pf sctp_pf_inet6 = {
-- 
2.27.0

