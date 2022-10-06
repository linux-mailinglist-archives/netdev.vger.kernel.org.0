Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1DB5F6E09
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiJFTQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiJFTQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:16:12 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC5BC14A5;
        Thu,  6 Oct 2022 12:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665083770; x=1696619770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EgCLwuiXM8UTfOAqBDyvhf7DN737hT5CCNVMO/hRUtw=;
  b=c9QJJtWvezeADAtcw8lLr1Y9IFXlNn8HbTCtTzqEXCkq4fp/FY1lpUau
   i7NRU0LMoEBn6Fw8ShHnergjWXaTkaRU6H+NQGNVwZEQfLTkVerb01xdL
   ZG0ivlMuQfX72uvZJGDlrhctsNpPLwl/BCspN/EXKorS7t83us2Wesmv9
   c=;
X-IronPort-AV: E=Sophos;i="5.95,164,1661817600"; 
   d="scan'208";a="1061594702"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:54:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 3A84D203364;
        Thu,  6 Oct 2022 18:54:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 6 Oct 2022 18:54:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.176) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 6 Oct 2022 18:54:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        "Vladislav Yasevich" <vyasevic@redhat.com>
Subject: [PATCH v5 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
Date:   Thu, 6 Oct 2022 11:53:47 -0700
Message-ID: <20221006185349.74777-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221006185349.74777-1-kuniyu@amazon.com>
References: <20221006185349.74777-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D18UWA003.ant.amazon.com (10.43.160.238) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
Cc: Vladislav Yasevich <vyasevic@redhat.com>
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
index 335a49ecd8a0..37943ba3a73c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1183,6 +1183,7 @@ void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
 void inet6_cleanup_sock(struct sock *sk);
+void inet6_sock_destruct(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/include/net/udp.h b/include/net/udp.h
index 5ee88ddf79c3..fee053bcd17c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -247,7 +247,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 }
 
 /* net/ipv4/udp.c */
-void udp_destruct_sock(struct sock *sk);
+void udp_destruct_common(struct sock *sk);
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
 void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
diff --git a/include/net/udplite.h b/include/net/udplite.h
index 0143b373602e..299c14ce2bb9 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -25,14 +25,6 @@ static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
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
index d63118ce5900..8126f67d18b3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1598,7 +1598,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
 
-void udp_destruct_sock(struct sock *sk)
+void udp_destruct_common(struct sock *sk)
 {
 	/* reclaim completely the forward allocated memory */
 	struct udp_sock *up = udp_sk(sk);
@@ -1611,10 +1611,14 @@ void udp_destruct_sock(struct sock *sk)
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
@@ -1622,7 +1626,6 @@ int udp_init_sock(struct sock *sk)
 	sk->sk_destruct = udp_destruct_sock;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(udp_init_sock);
 
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 {
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 6e08a76ae1e7..e0c9cc39b81e 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -17,6 +17,14 @@
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
index ded827944fa6..024191004982 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -109,6 +109,12 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
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
@@ -201,7 +207,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	sk->sk_destruct		= inet_sock_destruct;
+	sk->sk_destruct		= inet6_sock_destruct;
 	sk->sk_family		= PF_INET6;
 	sk->sk_protocol		= protocol;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 91e795bb9ade..8d09f0ea5b8c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -56,6 +56,19 @@
 #include <trace/events/skb.h>
 #include "udp_impl.h"
 
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
@@ -1733,7 +1746,7 @@ struct proto udpv6_prot = {
 	.connect		= ip6_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
-	.init			= udp_init_sock,
+	.init			= udpv6_init_sock,
 	.destroy		= udpv6_destroy_sock,
 	.setsockopt		= udpv6_setsockopt,
 	.getsockopt		= udpv6_getsockopt,
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 4251e49d32a0..0590f566379d 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -12,6 +12,7 @@ int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
 int __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
 		   __be32, struct udp_table *);
 
+int udpv6_init_sock(struct sock *sk);
 int udp_v6_get_port(struct sock *sk, unsigned short snum);
 void udp_v6_rehash(struct sock *sk);
 
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index b70725856259..67eaf3ca14ce 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -12,6 +12,13 @@
 #include <linux/proc_fs.h>
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
@@ -38,7 +45,7 @@ struct proto udplitev6_prot = {
 	.connect	   = ip6_datagram_connect,
 	.disconnect	   = udp_disconnect,
 	.ioctl		   = udp_ioctl,
-	.init		   = udplite_sk_init,
+	.init		   = udplitev6_sk_init,
 	.destroy	   = udpv6_destroy_sock,
 	.setsockopt	   = udpv6_setsockopt,
 	.getsockopt	   = udpv6_getsockopt,
-- 
2.30.2

