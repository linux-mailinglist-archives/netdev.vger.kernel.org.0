Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE76E8858
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjDTDFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjDTDFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:05:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED22103;
        Wed, 19 Apr 2023 20:05:09 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q22Y41wDlzsRNN;
        Thu, 20 Apr 2023 11:03:36 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 11:05:07 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 4.14 2/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
Date:   Thu, 20 Apr 2023 11:04:57 +0800
Message-ID: <b575ce980f08ffd288ee39257abb5214d217e861.1681952136.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1681952136.git.william.xuanziyang@huawei.com>
References: <cover.1681952136.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit d38afeec26ed4739c640bf286c270559aab2ba5f upstream.

Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
Add lockless sendmsg() support") added a lockless memory allocation path,
which could cause a memory leak:

setsockopt(IPV6_ADDRFORM)                 sendmsg()
+-----------------------+                 +-------+
- do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
  - sockopt_lock_sock(sk)                   ^._ called via udpv6_prot
    - lock_sock(sk)                             before WRITE_ONCE()
  - WRITE_ONCE(sk->sk_prot, &tcp_prot)
  - inet6_destroy_sock()                    - if (!corkreq)
  - sockopt_release_sock(sk)                  - ip6_make_skb(sk, ...)
    - release_sock(sk)                          ^._ lockless fast path for
                                                    the non-corking case

                                                - __ip6_append_data(sk, ...)
                                                  - ipv6_local_rxpmtu(sk, ...)
                                                    - xchg(&np->rxpmtu, skb)
                                                      ^._ rxpmtu is never freed.

                                                - goto out_no_dst;

                                            - lock_sock(sk)

For now, rxpmtu is only the case, but not to miss the future change
and a similar bug fixed in commit e27326009a3d ("net: ping6: Fix
memleak in ipv6_renew_options()."), let's set a new function to IPv6
sk->sk_destruct() and call inet6_cleanup_sock() there.  Since the
conversion does not change sk->sk_destruct(), we can guarantee that
we can clean up IPv6 resources finally.

We can now remove all inet6_destroy_sock() calls from IPv6 protocol
specific ->destroy() functions, but such changes are invasive to
backport.  So they can be posted as a follow-up later for net-next.

Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 include/net/ipv6.h    |  1 +
 include/net/udp.h     |  2 +-
 include/net/udplite.h |  8 --------
 net/ipv4/udp.c        |  9 ++++++---
 net/ipv4/udplite.c    |  8 ++++++++
 net/ipv6/af_inet6.c   |  8 +++++++-
 net/ipv6/udp.c        | 15 ++++++++++++++-
 net/ipv6/udp_impl.h   |  1 +
 net/ipv6/udplite.c    |  9 ++++++++-
 9 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c1eea6cb5bb9..7f7e90c1992f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -943,6 +943,7 @@ void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
 void inet6_cleanup_sock(struct sock *sk);
+void inet6_sock_destruct(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr, int *uaddr_len,
diff --git a/include/net/udp.h b/include/net/udp.h
index 07135de00166..d7bbb2e0c82c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -251,7 +251,7 @@ static inline int udp_rqueue_get(struct sock *sk)
 }
 
 /* net/ipv4/udp.c */
-void udp_destruct_sock(struct sock *sk);
+void udp_destruct_common(struct sock *sk);
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
 void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
diff --git a/include/net/udplite.h b/include/net/udplite.h
index 9185e45b997f..c59ba86668af 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -24,14 +24,6 @@ static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
 	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
 }
 
-/* Designate sk as UDP-Lite socket */
-static inline int udplite_sk_init(struct sock *sk)
-{
-	udp_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
-	return 0;
-}
-
 /*
  * 	Checksumming routines
  */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 16573afc3069..21429419abb5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1380,7 +1380,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
 
-void udp_destruct_sock(struct sock *sk)
+void udp_destruct_common(struct sock *sk)
 {
 	/* reclaim completely the forward allocated memory */
 	struct udp_sock *up = udp_sk(sk);
@@ -1393,10 +1393,14 @@ void udp_destruct_sock(struct sock *sk)
 		kfree_skb(skb);
 	}
 	udp_rmem_release(sk, total, 0, true);
+}
+EXPORT_SYMBOL_GPL(udp_destruct_common);
 
+static void udp_destruct_sock(struct sock *sk)
+{
+	udp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
-EXPORT_SYMBOL_GPL(udp_destruct_sock);
 
 int udp_init_sock(struct sock *sk)
 {
@@ -1404,7 +1408,6 @@ int udp_init_sock(struct sock *sk)
 	sk->sk_destruct = udp_destruct_sock;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(udp_init_sock);
 
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 {
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 59f10fe9782e..460379bf7989 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -19,6 +19,14 @@
 struct udp_table 	udplite_table __read_mostly;
 EXPORT_SYMBOL(udplite_table);
 
+/* Designate sk as UDP-Lite socket */
+static int udplite_sk_init(struct sock *sk)
+{
+	udp_init_sock(sk);
+	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	return 0;
+}
+
 static int udplite_rcv(struct sk_buff *skb)
 {
 	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index f1a556d9e23b..758462576e80 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -107,6 +107,12 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
 	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
 }
 
+void inet6_sock_destruct(struct sock *sk)
+{
+	inet6_cleanup_sock(sk);
+	inet_sock_destruct(sk);
+}
+
 static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
 {
@@ -199,7 +205,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	sk->sk_destruct		= inet_sock_destruct;
+	sk->sk_destruct		= inet6_sock_destruct;
 	sk->sk_family		= PF_INET6;
 	sk->sk_protocol		= protocol;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0d4f82f9ebfd..2b1f153ad6a9 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -66,6 +66,19 @@ static bool udp6_lib_exact_dif_match(struct net *net, struct sk_buff *skb)
 	return false;
 }
 
+static void udpv6_destruct_sock(struct sock *sk)
+{
+	udp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
+int udpv6_init_sock(struct sock *sk)
+{
+	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	sk->sk_destruct = udpv6_destruct_sock;
+	return 0;
+}
+
 static u32 udp6_ehashfn(const struct net *net,
 			const struct in6_addr *laddr,
 			const u16 lport,
@@ -1552,7 +1565,7 @@ struct proto udpv6_prot = {
 	.connect	   = ip6_datagram_connect,
 	.disconnect	   = udp_disconnect,
 	.ioctl		   = udp_ioctl,
-	.init		   = udp_init_sock,
+	.init		   = udpv6_init_sock,
 	.destroy	   = udpv6_destroy_sock,
 	.setsockopt	   = udpv6_setsockopt,
 	.getsockopt	   = udpv6_getsockopt,
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 7903e21c178b..e5d067b09ccf 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -12,6 +12,7 @@ int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
 void __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
 		    __be32, struct udp_table *);
 
+int udpv6_init_sock(struct sock *sk);
 int udp_v6_get_port(struct sock *sk, unsigned short snum);
 
 int udpv6_getsockopt(struct sock *sk, int level, int optname,
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 2784cc363f2b..1724db8bd4ff 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -14,6 +14,13 @@
 #include <linux/export.h>
 #include "udp_impl.h"
 
+static int udplitev6_sk_init(struct sock *sk)
+{
+	udpv6_init_sock(sk);
+	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	return 0;
+}
+
 static int udplitev6_rcv(struct sk_buff *skb)
 {
 	return __udp6_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
@@ -39,7 +46,7 @@ struct proto udplitev6_prot = {
 	.connect	   = ip6_datagram_connect,
 	.disconnect	   = udp_disconnect,
 	.ioctl		   = udp_ioctl,
-	.init		   = udplite_sk_init,
+	.init		   = udplitev6_sk_init,
 	.destroy	   = udpv6_destroy_sock,
 	.setsockopt	   = udpv6_setsockopt,
 	.getsockopt	   = udpv6_getsockopt,
-- 
2.25.1

