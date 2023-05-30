Return-Path: <netdev+bounces-6192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC867152CC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9E201C20AEF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571ED7EC;
	Tue, 30 May 2023 01:05:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402AD636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:05:12 +0000 (UTC)
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50889D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408709; x=1716944709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Trw65haVVV2jwrlUGNA8F6iLiTQuI9t7nhMY+UjiLis=;
  b=LfbdaZibnpSlhQ+vJRxCxDm4LvD0bGrE5Ivtm4NWSgJuH6Y7ew8JgVTH
   oJr0LsLRNYEenjYZa0EeMQ9g7W5zAITO/mQ2pYKsqFmT3yibymPqny+wc
   CdGYueRI/U19CVcN5BAJT2qdzS36jUVbkYXC+Z96ypCREkFAT9AaBD/kz
   k=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="1134335092"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:05:02 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com (Postfix) with ESMTPS id 1CEAF80636;
	Tue, 30 May 2023 01:04:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:04:59 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:04:56 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 02/14] udplite: Retire UDP-Lite for IPv6.
Date: Mon, 29 May 2023 18:03:36 -0700
Message-ID: <20230530010348.21425-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We no longer support IPPROTO_UDPLITE for AF_INET6.

This commit removes udplite.c and udp_impl.h under net/ipv6 and makes
some functions static that UDP shared.

Note that udplite.h is included in udp.c temporarily not to introduce
breakage, but we will remove it later with dead code.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/ipv6.h      |   2 -
 include/net/transp_v6.h |   3 -
 net/ipv6/Makefile       |   2 +-
 net/ipv6/af_inet6.c     |  19 +-----
 net/ipv6/proc.c         |   2 -
 net/ipv6/udp.c          |  31 ++++-----
 net/ipv6/udp_impl.h     |  31 ---------
 net/ipv6/udplite.c      | 136 ----------------------------------------
 8 files changed, 18 insertions(+), 208 deletions(-)
 delete mode 100644 net/ipv6/udp_impl.h
 delete mode 100644 net/ipv6/udplite.c

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 7332296eca44..c180c03e4e69 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1258,8 +1258,6 @@ int tcp6_proc_init(struct net *net);
 void tcp6_proc_exit(struct net *net);
 int udp6_proc_init(struct net *net);
 void udp6_proc_exit(struct net *net);
-int udplite6_proc_init(void);
-void udplite6_proc_exit(void);
 int ipv6_misc_proc_init(void);
 void ipv6_misc_proc_exit(void);
 int snmp6_register_dev(struct inet6_dev *idev);
diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index d27b1caf3753..76211668055b 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -8,7 +8,6 @@
 /* IPv6 transport protocols */
 extern struct proto rawv6_prot;
 extern struct proto udpv6_prot;
-extern struct proto udplitev6_prot;
 extern struct proto tcpv6_prot;
 extern struct proto pingv6_prot;
 
@@ -28,8 +27,6 @@ int rawv6_init(void);
 void rawv6_exit(void);
 int udpv6_init(void);
 void udpv6_exit(void);
-int udplitev6_init(void);
-void udplitev6_exit(void);
 int tcpv6_init(void);
 void tcpv6_exit(void);
 
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 3036a45e8a1e..63b7830d8146 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_IPV6) += ipv6.o
 
 ipv6-y :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		addrlabel.o \
-		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udplite.o \
+		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o \
 		raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
 		udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2bbf13216a3d..ca360680fae0 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -43,7 +43,6 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 #include <net/tcp.h>
 #include <net/ping.h>
 #include <net/protocol.h>
@@ -1086,13 +1085,9 @@ static int __init inet6_init(void)
 	if (err)
 		goto out_unregister_tcp_proto;
 
-	err = proto_register(&udplitev6_prot, 1);
-	if (err)
-		goto out_unregister_udp_proto;
-
 	err = proto_register(&rawv6_prot, 1);
 	if (err)
-		goto out_unregister_udplite_proto;
+		goto out_unregister_udp_proto;
 
 	err = proto_register(&pingv6_prot, 1);
 	if (err)
@@ -1143,8 +1138,6 @@ static int __init inet6_init(void)
 	err = -ENOMEM;
 	if (raw6_proc_init())
 		goto proc_raw6_fail;
-	if (udplite6_proc_init())
-		goto proc_udplite6_fail;
 	if (ipv6_misc_proc_init())
 		goto proc_misc6_fail;
 	if (if6_proc_init())
@@ -1180,10 +1173,6 @@ static int __init inet6_init(void)
 	if (err)
 		goto udpv6_fail;
 
-	err = udplitev6_init();
-	if (err)
-		goto udplitev6_fail;
-
 	err = udpv6_offload_init();
 	if (err)
 		goto udpv6_offload_fail;
@@ -1254,8 +1243,6 @@ static int __init inet6_init(void)
 tcpv6_fail:
 	udpv6_offload_exit();
 udpv6_offload_fail:
-	udplitev6_exit();
-udplitev6_fail:
 	udpv6_exit();
 udpv6_fail:
 	ipv6_frag_exit();
@@ -1277,8 +1264,6 @@ static int __init inet6_init(void)
 proc_if6_fail:
 	ipv6_misc_proc_exit();
 proc_misc6_fail:
-	udplite6_proc_exit();
-proc_udplite6_fail:
 	raw6_proc_exit();
 proc_raw6_fail:
 #endif
@@ -1302,8 +1287,6 @@ static int __init inet6_init(void)
 	proto_unregister(&pingv6_prot);
 out_unregister_raw_proto:
 	proto_unregister(&rawv6_prot);
-out_unregister_udplite_proto:
-	proto_unregister(&udplitev6_prot);
 out_unregister_udp_proto:
 	proto_unregister(&udpv6_prot);
 out_unregister_tcp_proto:
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index e20b3705c2d2..91bcd4525494 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -39,8 +39,6 @@ static int sockstat6_seq_show(struct seq_file *seq, void *v)
 		       sock_prot_inuse_get(net, &tcpv6_prot));
 	seq_printf(seq, "UDP6: inuse %d\n",
 		       sock_prot_inuse_get(net, &udpv6_prot));
-	seq_printf(seq, "UDPLITE6: inuse %d\n",
-			sock_prot_inuse_get(net, &udplitev6_prot));
 	seq_printf(seq, "RAW6: inuse %d\n",
 		       sock_prot_inuse_get(net, &rawv6_prot));
 	seq_printf(seq, "FRAG6: inuse %u memory %lu\n",
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 2ec611c2f964..bc3f7ac8c28a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -50,11 +50,12 @@
 #include <net/inet6_hashtables.h>
 #include <net/busy_poll.h>
 #include <net/sock_reuseport.h>
+#include <net/udp.h>
+#include <net/udplite.h>
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <trace/events/skb.h>
-#include "udp_impl.h"
 
 static void udpv6_destruct_sock(struct sock *sk)
 {
@@ -62,7 +63,7 @@ static void udpv6_destruct_sock(struct sock *sk)
 	inet6_sock_destruct(sk);
 }
 
-int udpv6_init_sock(struct sock *sk)
+static int udpv6_init_sock(struct sock *sk)
 {
 	udp_lib_init_sock(sk);
 	sk->sk_destruct = udpv6_destruct_sock;
@@ -93,7 +94,7 @@ static u32 udp6_ehashfn(const struct net *net,
 			       udp_ipv6_hash_secret + net_hash_mix(net));
 }
 
-int udp_v6_get_port(struct sock *sk, unsigned short snum)
+static int udp_v6_get_port(struct sock *sk, unsigned short snum)
 {
 	unsigned int hash2_nulladdr =
 		ipv6_portaddr_hash(sock_net(sk), &in6addr_any, snum);
@@ -105,7 +106,7 @@ int udp_v6_get_port(struct sock *sk, unsigned short snum)
 	return udp_lib_get_port(sk, snum, hash2_nulladdr);
 }
 
-void udp_v6_rehash(struct sock *sk)
+static void udp_v6_rehash(struct sock *sk)
 {
 	u16 new_hash = ipv6_portaddr_hash(sock_net(sk),
 					  &sk->sk_v6_rcv_saddr,
@@ -572,9 +573,9 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	return sk;
 }
 
-int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-		   u8 type, u8 code, int offset, __be32 info,
-		   struct udp_table *udptable)
+static int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+			  u8 type, u8 code, int offset, __be32 info,
+			  struct udp_table *udptable)
 {
 	struct ipv6_pinfo *np;
 	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
@@ -944,8 +945,8 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 
-int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-		   int proto)
+static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
+			  int proto)
 {
 	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct in6_addr *saddr, *daddr;
@@ -1659,7 +1660,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 }
 EXPORT_SYMBOL(udpv6_sendmsg);
 
-void udpv6_destroy_sock(struct sock *sk)
+static void udpv6_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	lock_sock(sk);
@@ -1686,8 +1687,8 @@ void udpv6_destroy_sock(struct sock *sk)
 /*
  *	Socket option code for UDP
  */
-int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
-		     unsigned int optlen)
+static int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			    unsigned int optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
 		return udp_lib_setsockopt(sk, level, optname,
@@ -1696,8 +1697,8 @@ int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 	return ipv6_setsockopt(sk, level, optname, optval, optlen);
 }
 
-int udpv6_getsockopt(struct sock *sk, int level, int optname,
-		     char __user *optval, int __user *optlen)
+static int udpv6_getsockopt(struct sock *sk, int level, int optname,
+			    char __user *optval, int __user *optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
 		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
@@ -1712,7 +1713,7 @@ static const struct inet6_protocol udpv6_protocol = {
 
 /* ------------------------------------------------------------------------ */
 #ifdef CONFIG_PROC_FS
-int udp6_seq_show(struct seq_file *seq, void *v)
+static int udp6_seq_show(struct seq_file *seq, void *v)
 {
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq, IPV6_SEQ_DGRAM_HEADER);
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
deleted file mode 100644
index 0590f566379d..000000000000
--- a/net/ipv6/udp_impl.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _UDP6_IMPL_H
-#define _UDP6_IMPL_H
-#include <net/udp.h>
-#include <net/udplite.h>
-#include <net/protocol.h>
-#include <net/addrconf.h>
-#include <net/inet_common.h>
-#include <net/transp_v6.h>
-
-int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
-int __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
-		   __be32, struct udp_table *);
-
-int udpv6_init_sock(struct sock *sk);
-int udp_v6_get_port(struct sock *sk, unsigned short snum);
-void udp_v6_rehash(struct sock *sk);
-
-int udpv6_getsockopt(struct sock *sk, int level, int optname,
-		     char __user *optval, int __user *optlen);
-int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
-		     unsigned int optlen);
-int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
-int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
-		  int *addr_len);
-void udpv6_destroy_sock(struct sock *sk);
-
-#ifdef CONFIG_PROC_FS
-int udp6_seq_show(struct seq_file *seq, void *v);
-#endif
-#endif	/* _UDP6_IMPL_H */
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
deleted file mode 100644
index 3bab0cc13697..000000000000
--- a/net/ipv6/udplite.c
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *  UDPLITEv6   An implementation of the UDP-Lite protocol over IPv6.
- *              See also net/ipv4/udplite.c
- *
- *  Authors:    Gerrit Renker       <gerrit@erg.abdn.ac.uk>
- *
- *  Changes:
- *  Fixes:
- */
-#include <linux/export.h>
-#include <linux/proc_fs.h>
-#include "udp_impl.h"
-
-static int udplitev6_sk_init(struct sock *sk)
-{
-	udpv6_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
-	return 0;
-}
-
-static int udplitev6_rcv(struct sk_buff *skb)
-{
-	return __udp6_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
-}
-
-static int udplitev6_err(struct sk_buff *skb,
-			  struct inet6_skb_parm *opt,
-			  u8 type, u8 code, int offset, __be32 info)
-{
-	return __udp6_lib_err(skb, opt, type, code, offset, info,
-			      &udplite_table);
-}
-
-static const struct inet6_protocol udplitev6_protocol = {
-	.handler	=	udplitev6_rcv,
-	.err_handler	=	udplitev6_err,
-	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
-};
-
-struct proto udplitev6_prot = {
-	.name		   = "UDPLITEv6",
-	.owner		   = THIS_MODULE,
-	.close		   = udp_lib_close,
-	.connect	   = ip6_datagram_connect,
-	.disconnect	   = udp_disconnect,
-	.ioctl		   = udp_ioctl,
-	.init		   = udplitev6_sk_init,
-	.destroy	   = udpv6_destroy_sock,
-	.setsockopt	   = udpv6_setsockopt,
-	.getsockopt	   = udpv6_getsockopt,
-	.sendmsg	   = udpv6_sendmsg,
-	.recvmsg	   = udpv6_recvmsg,
-	.hash		   = udp_lib_hash,
-	.unhash		   = udp_lib_unhash,
-	.rehash		   = udp_v6_rehash,
-	.get_port	   = udp_v6_get_port,
-
-	.memory_allocated  = &udp_memory_allocated,
-	.per_cpu_fw_alloc  = &udp_memory_per_cpu_fw_alloc,
-
-	.sysctl_mem	   = sysctl_udp_mem,
-	.sysctl_wmem_offset = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
-	.sysctl_rmem_offset = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
-	.obj_size	   = sizeof(struct udp6_sock),
-	.h.udp_table	   = &udplite_table,
-};
-
-static struct inet_protosw udplite6_protosw = {
-	.type		= SOCK_DGRAM,
-	.protocol	= IPPROTO_UDPLITE,
-	.prot		= &udplitev6_prot,
-	.ops		= &inet6_dgram_ops,
-	.flags		= INET_PROTOSW_PERMANENT,
-};
-
-int __init udplitev6_init(void)
-{
-	int ret;
-
-	ret = inet6_add_protocol(&udplitev6_protocol, IPPROTO_UDPLITE);
-	if (ret)
-		goto out;
-
-	ret = inet6_register_protosw(&udplite6_protosw);
-	if (ret)
-		goto out_udplitev6_protocol;
-out:
-	return ret;
-
-out_udplitev6_protocol:
-	inet6_del_protocol(&udplitev6_protocol, IPPROTO_UDPLITE);
-	goto out;
-}
-
-void udplitev6_exit(void)
-{
-	inet6_unregister_protosw(&udplite6_protosw);
-	inet6_del_protocol(&udplitev6_protocol, IPPROTO_UDPLITE);
-}
-
-#ifdef CONFIG_PROC_FS
-static struct udp_seq_afinfo udplite6_seq_afinfo = {
-	.family		= AF_INET6,
-	.udp_table	= &udplite_table,
-};
-
-static int __net_init udplite6_proc_init_net(struct net *net)
-{
-	if (!proc_create_net_data("udplite6", 0444, net->proc_net,
-			&udp6_seq_ops, sizeof(struct udp_iter_state),
-			&udplite6_seq_afinfo))
-		return -ENOMEM;
-	return 0;
-}
-
-static void __net_exit udplite6_proc_exit_net(struct net *net)
-{
-	remove_proc_entry("udplite6", net->proc_net);
-}
-
-static struct pernet_operations udplite6_net_ops = {
-	.init = udplite6_proc_init_net,
-	.exit = udplite6_proc_exit_net,
-};
-
-int __init udplite6_proc_init(void)
-{
-	return register_pernet_subsys(&udplite6_net_ops);
-}
-
-void udplite6_proc_exit(void)
-{
-	unregister_pernet_subsys(&udplite6_net_ops);
-}
-#endif
-- 
2.30.2


