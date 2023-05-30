Return-Path: <netdev+bounces-6195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD647152CF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 118361C20AF4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9BE7ED;
	Tue, 30 May 2023 01:06:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D1A7EC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:06:34 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C2C9D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408791; x=1716944791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lA+QB86VEFz9Bf9eh2GntABvInWDoHa6/AhvmqZzv3g=;
  b=D1rHJtElXep9Hpbs7cz6aTGYQqPR0H7H4BIb4MNn36nfRHDvpRWKp9K0
   POJp8LQLIP+t4xuwy1V8p+w4p6cpwqnhylTDfAO2rlkTwnjWtMI/Nv/b8
   e2q23E1YSaIA5ybU3g4qniVS2SdHhSUaK7WMWEn6+a19hzPPJ5ILzfiqA
   o=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="288205053"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:06:30 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id 477FA803C2;
	Tue, 30 May 2023 01:06:26 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:05:49 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 30 May 2023 01:05:47 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 04/14] udplite: Retire UDP-Lite for IPv4.
Date: Mon, 29 May 2023 18:03:38 -0700
Message-ID: <20230530010348.21425-5-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We no longer support IPPROTO_UDPLITE for AF_INET.

This commit removes udplite.c and udp_impl.h under net/ipv4 and makes
some functions static that UDP shared.

Also, we remove the SOCK_DIAG code for UDP-Lite.

Note that udplite.h is included in udp.c temporarily not to introduce
breakage, but we will remove it later with dead code.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/sock.h    |   4 +-
 include/net/udp.h     |   5 +-
 include/net/udplite.h |   6 --
 net/ipv4/Makefile     |   2 +-
 net/ipv4/af_inet.c    |   4 --
 net/ipv4/proc.c       |   2 -
 net/ipv4/udp.c        |  36 +++++------
 net/ipv4/udp_bpf.c    |   2 -
 net/ipv4/udp_diag.c   |  46 +-------------
 net/ipv4/udp_impl.h   |  29 ---------
 net/ipv4/udplite.c    | 136 ------------------------------------------
 11 files changed, 25 insertions(+), 247 deletions(-)
 delete mode 100644 net/ipv4/udp_impl.h
 delete mode 100644 net/ipv4/udplite.c

diff --git a/include/net/sock.h b/include/net/sock.h
index 656ea89f60ff..0b6c74bdd688 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -133,14 +133,14 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_net_refcnt: socket is using net ref counting
  *	@skc_bound_dev_if: bound device index if != 0
  *	@skc_bind_node: bind hash linkage for various protocol lookup tables
- *	@skc_portaddr_node: second hash linkage for UDP/UDP-Lite protocol
+ *	@skc_portaddr_node: second hash linkage for UDP protocol
  *	@skc_prot: protocol handlers inside a network family
  *	@skc_net: reference to the network namespace of this socket
  *	@skc_v6_daddr: IPV6 destination address
  *	@skc_v6_rcv_saddr: IPV6 source address
  *	@skc_cookie: socket's cookie value
  *	@skc_node: main hash linkage for various protocol lookup tables
- *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
+ *	@skc_nulls_node: main hash linkage for TCP protocol
  *	@skc_tx_queue_mapping: tx queue number for this connection
  *	@skc_rx_queue_mapping: rx queue number for this connection
  *	@skc_flags: place holder for sk_flags
diff --git a/include/net/udp.h b/include/net/udp.h
index 5cad44318d71..bfe62e73552a 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -76,7 +76,7 @@ struct udp_table {
 	unsigned int		log;
 };
 extern struct udp_table udp_table;
-void udp_table_init(struct udp_table *, const char *);
+
 static inline struct udp_hslot *udp_hashslot(struct udp_table *table,
 					     struct net *net, unsigned int num)
 {
@@ -183,7 +183,7 @@ static inline void udp_lib_init_sock(struct sock *sk)
 	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
 }
 
-/* hash routines shared between UDPv4/6 and UDP-Litev4/6 */
+/* hash routines shared between UDPv4/6 */
 static inline int udp_lib_hash(struct sock *sk)
 {
 	BUG();
@@ -284,7 +284,6 @@ int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
 void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
 int udp_rcv(struct sk_buff *skb);
 int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
-int udp_init_sock(struct sock *sk);
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int __udp_disconnect(struct sock *sk, int flags);
 int udp_disconnect(struct sock *sk, int flags);
diff --git a/include/net/udplite.h b/include/net/udplite.h
index 299c14ce2bb9..e436917f9b14 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -12,9 +12,6 @@
 #define UDPLITE_SEND_CSCOV   10 /* sender partial coverage (as sent)      */
 #define UDPLITE_RECV_CSCOV   11 /* receiver partial coverage (threshold ) */
 
-extern struct proto 		udplite_prot;
-extern struct udp_table		udplite_table;
-
 /*
  *	Checksum computation is all in software, hence simpler getfrag.
  */
@@ -80,7 +77,4 @@ static inline __wsum udplite_csum(struct sk_buff *skb)
 	return skb_checksum(skb, off, len, 0);
 }
 
-void udplite4_register(void);
-int udplite_get_port(struct sock *sk, unsigned short snum,
-		     int (*scmp)(const struct sock *, const struct sock *));
 #endif	/* _UDPLITE_H */
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index b18ba8ef93ad..a49e09f3f32a 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -10,7 +10,7 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     tcp.o tcp_input.o tcp_output.o tcp_timer.o tcp_ipv4.o \
 	     tcp_minisocks.o tcp_cong.o tcp_metrics.o tcp_fastopen.o \
 	     tcp_rate.o tcp_recovery.o tcp_ulp.o \
-	     tcp_offload.o tcp_plb.o datagram.o raw.o udp.o udplite.o \
+	     tcp_offload.o tcp_plb.o datagram.o raw.o udp.o \
 	     udp_offload.o arp.o icmp.o devinet.o af_inet.o igmp.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o \
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 946650036c7f..bf9fdce5bd05 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -102,7 +102,6 @@
 #include <net/gro.h>
 #include <net/tcp.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 #include <net/ping.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
@@ -2009,9 +2008,6 @@ static int __init inet_init(void)
 	/* Setup UDP memory threshold */
 	udp_init();
 
-	/* Add UDP-Lite (RFC 3828) */
-	udplite4_register();
-
 	raw_init();
 
 	ping_init();
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index eaf1d3113b62..7cf33b1763ed 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -64,8 +64,6 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "UDP: inuse %d mem %ld\n",
 		   sock_prot_inuse_get(net, &udp_prot),
 		   proto_memory_allocated(&udp_prot));
-	seq_printf(seq, "UDPLITE: inuse %d\n",
-		   sock_prot_inuse_get(net, &udplite_prot));
 	seq_printf(seq, "RAW: inuse %d\n",
 		   sock_prot_inuse_get(net, &raw_prot));
 	seq_printf(seq,  "FRAG: inuse %u memory %lu\n",
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7a874c497cbd..2e966ce4a41b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -99,6 +99,7 @@
 #include <linux/seq_file.h>
 #include <net/net_namespace.h>
 #include <net/icmp.h>
+#include <net/inet_common.h>
 #include <net/inet_hashtables.h>
 #include <net/ip_tunnels.h>
 #include <net/route.h>
@@ -109,9 +110,10 @@
 #include <linux/btf_ids.h>
 #include <trace/events/skb.h>
 #include <net/busy_poll.h>
-#include "udp_impl.h"
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
+#include <net/udp.h>
+#include <net/udplite.h>
 #include <net/udp_tunnel.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
@@ -227,7 +229,7 @@ static int udp_reuseport_add_sock(struct sock *sk, struct udp_hslot *hslot)
 }
 
 /**
- *  udp_lib_get_port  -  UDP/-Lite port lookup for IPv4 and IPv6
+ *  udp_lib_get_port  -  UDP port lookup for IPv4 and IPv6
  *
  *  @sk:          socket struct in question
  *  @snum:        port number to look up
@@ -349,7 +351,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 }
 EXPORT_SYMBOL(udp_lib_get_port);
 
-int udp_v4_get_port(struct sock *sk, unsigned short snum)
+static int udp_v4_get_port(struct sock *sk, unsigned short snum)
 {
 	unsigned int hash2_nulladdr =
 		ipv4_portaddr_hash(sock_net(sk), htonl(INADDR_ANY), snum);
@@ -712,7 +714,7 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
  * to find the appropriate port.
  */
 
-int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
+static int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 {
 	struct inet_sock *inet;
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
@@ -1327,8 +1329,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 }
 EXPORT_SYMBOL(udp_sendmsg);
 
-int udp_sendpage(struct sock *sk, struct page *page, int offset,
-		 size_t size, int flags)
+static int udp_sendpage(struct sock *sk, struct page *page, int offset,
+			size_t size, int flags)
 {
 	struct bio_vec bvec;
 	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES };
@@ -1591,7 +1593,7 @@ static void udp_destruct_sock(struct sock *sk)
 	inet_sock_destruct(sk);
 }
 
-int udp_init_sock(struct sock *sk)
+static int udp_init_sock(struct sock *sk)
 {
 	udp_lib_init_sock(sk);
 	sk->sk_destruct = udp_destruct_sock;
@@ -2032,7 +2034,7 @@ void udp_lib_rehash(struct sock *sk, u16 newhash)
 }
 EXPORT_SYMBOL(udp_lib_rehash);
 
-void udp_v4_rehash(struct sock *sk)
+static void udp_v4_rehash(struct sock *sk)
 {
 	u16 new_hash = ipv4_portaddr_hash(sock_net(sk),
 					  inet_sk(sk)->inet_rcv_saddr,
@@ -2376,8 +2378,8 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
  *	All we need to do is get the socket, and then do a checksum.
  */
 
-int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-		   int proto)
+static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
+			  int proto)
 {
 	struct sock *sk;
 	struct udphdr *uh;
@@ -2619,7 +2621,7 @@ int udp_rcv(struct sk_buff *skb)
 	return __udp4_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table, IPPROTO_UDP);
 }
 
-void udp_destroy_sock(struct sock *sk)
+static void udp_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	bool slow = lock_sock_fast(sk);
@@ -2774,8 +2776,8 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 }
 EXPORT_SYMBOL(udp_lib_setsockopt);
 
-int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
-		   unsigned int optlen)
+static int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			  unsigned int optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
 		return udp_lib_setsockopt(sk, level, optname,
@@ -2845,8 +2847,8 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 }
 EXPORT_SYMBOL(udp_lib_getsockopt);
 
-int udp_getsockopt(struct sock *sk, int level, int optname,
-		   char __user *optval, int __user *optlen)
+static int udp_getsockopt(struct sock *sk, int level, int optname,
+			  char __user *optval, int __user *optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
 		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
@@ -3092,7 +3094,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 		atomic_read(&sp->sk_drops));
 }
 
-int udp4_seq_show(struct seq_file *seq, void *v)
+static int udp4_seq_show(struct seq_file *seq, void *v)
 {
 	seq_setwidth(seq, 127);
 	if (v == SEQ_START_TOKEN)
@@ -3403,7 +3405,7 @@ static int __init set_uhash_entries(char *str)
 }
 __setup("uhash_entries=", set_uhash_entries);
 
-void __init udp_table_init(struct udp_table *table, const char *name)
+static void __init udp_table_init(struct udp_table *table, const char *name)
 {
 	unsigned int i;
 
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 0735d820e413..90336d215f79 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -6,8 +6,6 @@
 #include <net/udp.h>
 #include <net/inet_common.h>
 
-#include "udp_impl.h"
-
 static struct proto *udpv6_prot_saved __read_mostly;
 
 static int sk_udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index de3f2d31f510..b8de2babfb0c 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -10,7 +10,6 @@
 #include <linux/inet_diag.h>
 #include <linux/udp.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 #include <linux/sock_diag.h>
 
 static int sk_diag_dump(struct sock *sk, struct sk_buff *skb,
@@ -228,12 +227,6 @@ static int udp_diag_destroy(struct sk_buff *in_skb,
 	return __udp_diag_destroy(in_skb, req, sock_net(in_skb->sk)->ipv4.udp_table);
 }
 
-static int udplite_diag_destroy(struct sk_buff *in_skb,
-				const struct inet_diag_req_v2 *req)
-{
-	return __udp_diag_destroy(in_skb, req, &udplite_table);
-}
-
 #endif
 
 static const struct inet_diag_handler udp_diag_handler = {
@@ -247,49 +240,13 @@ static const struct inet_diag_handler udp_diag_handler = {
 #endif
 };
 
-static void udplite_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			      const struct inet_diag_req_v2 *r)
-{
-	udp_dump(&udplite_table, skb, cb, r);
-}
-
-static int udplite_diag_dump_one(struct netlink_callback *cb,
-				 const struct inet_diag_req_v2 *req)
-{
-	return udp_dump_one(&udplite_table, cb, req);
-}
-
-static const struct inet_diag_handler udplite_diag_handler = {
-	.dump		 = udplite_diag_dump,
-	.dump_one	 = udplite_diag_dump_one,
-	.idiag_get_info  = udp_diag_get_info,
-	.idiag_type	 = IPPROTO_UDPLITE,
-	.idiag_info_size = 0,
-#ifdef CONFIG_INET_DIAG_DESTROY
-	.destroy	 = udplite_diag_destroy,
-#endif
-};
-
 static int __init udp_diag_init(void)
 {
-	int err;
-
-	err = inet_diag_register(&udp_diag_handler);
-	if (err)
-		goto out;
-	err = inet_diag_register(&udplite_diag_handler);
-	if (err)
-		goto out_lite;
-out:
-	return err;
-out_lite:
-	inet_diag_unregister(&udp_diag_handler);
-	goto out;
+	return inet_diag_register(&udp_diag_handler);
 }
 
 static void __exit udp_diag_exit(void)
 {
-	inet_diag_unregister(&udplite_diag_handler);
 	inet_diag_unregister(&udp_diag_handler);
 }
 
@@ -297,4 +254,3 @@ module_init(udp_diag_init);
 module_exit(udp_diag_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_NETLINK, NETLINK_SOCK_DIAG, 2-17 /* AF_INET - IPPROTO_UDP */);
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_NETLINK, NETLINK_SOCK_DIAG, 2-136 /* AF_INET - IPPROTO_UDPLITE */);
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
deleted file mode 100644
index 4ba7a88a1b1d..000000000000
--- a/net/ipv4/udp_impl.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _UDP4_IMPL_H
-#define _UDP4_IMPL_H
-#include <net/udp.h>
-#include <net/udplite.h>
-#include <net/protocol.h>
-#include <net/inet_common.h>
-
-int __udp4_lib_rcv(struct sk_buff *, struct udp_table *, int);
-int __udp4_lib_err(struct sk_buff *, u32, struct udp_table *);
-
-int udp_v4_get_port(struct sock *sk, unsigned short snum);
-void udp_v4_rehash(struct sock *sk);
-
-int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
-		   unsigned int optlen);
-int udp_getsockopt(struct sock *sk, int level, int optname,
-		   char __user *optval, int __user *optlen);
-
-int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
-		int *addr_len);
-int udp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
-		 int flags);
-void udp_destroy_sock(struct sock *sk);
-
-#ifdef CONFIG_PROC_FS
-int udp4_seq_show(struct seq_file *seq, void *v);
-#endif
-#endif	/* _UDP4_IMPL_H */
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
deleted file mode 100644
index 56d94d23b9e0..000000000000
--- a/net/ipv4/udplite.c
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *  UDPLITE     An implementation of the UDP-Lite protocol (RFC 3828).
- *
- *  Authors:    Gerrit Renker       <gerrit@erg.abdn.ac.uk>
- *
- *  Changes:
- *  Fixes:
- */
-
-#define pr_fmt(fmt) "UDPLite: " fmt
-
-#include <linux/export.h>
-#include <linux/proc_fs.h>
-#include "udp_impl.h"
-
-struct udp_table 	udplite_table __read_mostly;
-EXPORT_SYMBOL(udplite_table);
-
-/* Designate sk as UDP-Lite socket */
-static int udplite_sk_init(struct sock *sk)
-{
-	udp_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
-	return 0;
-}
-
-static int udplite_rcv(struct sk_buff *skb)
-{
-	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
-}
-
-static int udplite_err(struct sk_buff *skb, u32 info)
-{
-	return __udp4_lib_err(skb, info, &udplite_table);
-}
-
-static const struct net_protocol udplite_protocol = {
-	.handler	= udplite_rcv,
-	.err_handler	= udplite_err,
-	.no_policy	= 1,
-};
-
-struct proto 	udplite_prot = {
-	.name		   = "UDP-Lite",
-	.owner		   = THIS_MODULE,
-	.close		   = udp_lib_close,
-	.connect	   = ip4_datagram_connect,
-	.disconnect	   = udp_disconnect,
-	.ioctl		   = udp_ioctl,
-	.init		   = udplite_sk_init,
-	.destroy	   = udp_destroy_sock,
-	.setsockopt	   = udp_setsockopt,
-	.getsockopt	   = udp_getsockopt,
-	.sendmsg	   = udp_sendmsg,
-	.recvmsg	   = udp_recvmsg,
-	.sendpage	   = udp_sendpage,
-	.hash		   = udp_lib_hash,
-	.unhash		   = udp_lib_unhash,
-	.rehash		   = udp_v4_rehash,
-	.get_port	   = udp_v4_get_port,
-
-	.memory_allocated  = &udp_memory_allocated,
-	.per_cpu_fw_alloc  = &udp_memory_per_cpu_fw_alloc,
-
-	.sysctl_mem	   = sysctl_udp_mem,
-	.sysctl_wmem_offset = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
-	.sysctl_rmem_offset = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
-	.obj_size	   = sizeof(struct udp_sock),
-	.h.udp_table	   = &udplite_table,
-};
-EXPORT_SYMBOL(udplite_prot);
-
-static struct inet_protosw udplite4_protosw = {
-	.type		=  SOCK_DGRAM,
-	.protocol	=  IPPROTO_UDPLITE,
-	.prot		=  &udplite_prot,
-	.ops		=  &inet_dgram_ops,
-	.flags		=  INET_PROTOSW_PERMANENT,
-};
-
-#ifdef CONFIG_PROC_FS
-static struct udp_seq_afinfo udplite4_seq_afinfo = {
-	.family		= AF_INET,
-	.udp_table 	= &udplite_table,
-};
-
-static int __net_init udplite4_proc_init_net(struct net *net)
-{
-	if (!proc_create_net_data("udplite", 0444, net->proc_net, &udp_seq_ops,
-			sizeof(struct udp_iter_state), &udplite4_seq_afinfo))
-		return -ENOMEM;
-	return 0;
-}
-
-static void __net_exit udplite4_proc_exit_net(struct net *net)
-{
-	remove_proc_entry("udplite", net->proc_net);
-}
-
-static struct pernet_operations udplite4_net_ops = {
-	.init = udplite4_proc_init_net,
-	.exit = udplite4_proc_exit_net,
-};
-
-static __init int udplite4_proc_init(void)
-{
-	return register_pernet_subsys(&udplite4_net_ops);
-}
-#else
-static inline int udplite4_proc_init(void)
-{
-	return 0;
-}
-#endif
-
-void __init udplite4_register(void)
-{
-	udp_table_init(&udplite_table, "UDP-Lite");
-	if (proto_register(&udplite_prot, 1))
-		goto out_register_err;
-
-	if (inet_add_protocol(&udplite_protocol, IPPROTO_UDPLITE) < 0)
-		goto out_unregister_proto;
-
-	inet_register_protosw(&udplite4_protosw);
-
-	if (udplite4_proc_init())
-		pr_err("%s: Cannot register /proc!\n", __func__);
-	return;
-
-out_unregister_proto:
-	proto_unregister(&udplite_prot);
-out_register_err:
-	pr_crit("%s: Cannot add UDP-Lite protocol\n", __func__);
-}
-- 
2.30.2


