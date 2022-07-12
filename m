Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FD95720E0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiGLQdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiGLQdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:33:22 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3348CB47C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657643601; x=1689179601;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IWfbGGwZ5AwqqnKgtflBoY+ldvt5ZNBTBSmqI6ADtaU=;
  b=gf98rBPMyEEn9o/9yS+kiyrtxqumHsv41XADtuycTOSdUS5WZ8S6bZCc
   f57+8BUXkiSd6o78J85sK04kayTtbDjp7Lnrth3LsLt/x2Ht24GGWCzq3
   QctCYM/8kBW1zQzcb0P8WkPhwX+9kZbQQ4vPTUGNN9ECyIGe1gBikftd+
   A=;
X-IronPort-AV: E=Sophos;i="5.92,266,1650931200"; 
   d="scan'208";a="209304230"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 12 Jul 2022 16:32:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id 4589A941FE;
        Tue, 12 Jul 2022 16:32:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 16:32:55 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.111) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 16:32:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net] tcp/udp: Make early_demux back namespacified.
Date:   Tue, 12 Jul 2022 09:32:43 -0700
Message-ID: <20220712163243.36014-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.111]
X-ClientProxiedBy: EX13P01UWB004.ant.amazon.com (10.43.161.213) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
it possible to enable/disable early_demux on a per-netns basis.  Then, we
introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
tcp and udp").  However, the .proc_handler() was wrong and actually
disabled us from changing the behaviour in each netns.

We can execute early_demux if net.ipv4.ip_early_demux is on and each proto
.early_demux() handler is not NULL.  When we toggle (tcp|udp)_early_demux,
the change itself is saved in each netns variable, but the .early_demux()
handler is a global variable, so the handler is switched based on the
init_net's sysctl variable.  Thus, netns (tcp|udp)_early_demux knobs have
nothing to do with the logic.  Whether we CAN execute proto .early_demux()
is always decided by init_net's sysctl knob, and whether we DO it or not is
by each netns ip_early_demux knob.

This patch namespacifies (tcp|udp)_early_demux again.  For now, the users
of the .early_demux() handler are TCP and UDP only, and they are called
directly to avoid retpoline.  So, we can remove the .early_demux() handler
from inet6?_protos and need not dereference them in ip6?_rcv_finish_core().
If another proto needs .early_demux(), we can restore it at that time.

Fixes: dddb64bcb346 ("net: Add sysctl to toggle early demux for tcp and udp")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/protocol.h     |  4 ---
 include/net/tcp.h          |  4 +--
 include/net/udp.h          |  2 +-
 net/ipv4/af_inet.c         | 14 ++-------
 net/ipv4/ip_input.c        | 40 ++++++++++++++----------
 net/ipv4/sysctl_net_ipv4.c | 63 ++++----------------------------------
 net/ipv4/tcp_ipv4.c        | 10 +++---
 net/ipv6/ip6_input.c       | 23 ++++++++------
 net/ipv6/tcp_ipv6.c        |  9 ++----
 net/ipv6/udp.c             |  9 ++----
 10 files changed, 56 insertions(+), 122 deletions(-)

diff --git a/include/net/protocol.h b/include/net/protocol.h
index f51c06ae365f..6aef8cb11cc8 100644
--- a/include/net/protocol.h
+++ b/include/net/protocol.h
@@ -35,8 +35,6 @@
 
 /* This is used to register protocols. */
 struct net_protocol {
-	int			(*early_demux)(struct sk_buff *skb);
-	int			(*early_demux_handler)(struct sk_buff *skb);
 	int			(*handler)(struct sk_buff *skb);
 
 	/* This returns an error if we weren't able to handle the error. */
@@ -52,8 +50,6 @@ struct net_protocol {
 
 #if IS_ENABLED(CONFIG_IPV6)
 struct inet6_protocol {
-	void	(*early_demux)(struct sk_buff *skb);
-	void    (*early_demux_handler)(struct sk_buff *skb);
 	int	(*handler)(struct sk_buff *skb);
 
 	/* This returns an error if we weren't able to handle the error. */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1e99f5c61f84..95c55e9252b9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -318,7 +318,7 @@ int tcp_v4_err(struct sk_buff *skb, u32);
 
 void tcp_shutdown(struct sock *sk, int how);
 
-int tcp_v4_early_demux(struct sk_buff *skb);
+void tcp_v4_early_demux(struct sk_buff *skb);
 int tcp_v4_rcv(struct sk_buff *skb);
 
 void tcp_remove_empty_skb(struct sock *sk);
@@ -932,7 +932,7 @@ extern const struct inet_connection_sock_af_ops ipv6_specific;
 
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
 INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *skb));
-INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
+void tcp_v6_early_demux(struct sk_buff *skb);
 
 #endif
 
diff --git a/include/net/udp.h b/include/net/udp.h
index b83a00330566..bb4c227299cc 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -167,7 +167,7 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
 typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
 				     __be16 dport);
 
-INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
+void udp_v6_early_demux(struct sk_buff *skb);
 INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 93da9f783bec..76e7a7ca6772 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1710,24 +1710,14 @@ static const struct net_protocol igmp_protocol = {
 };
 #endif
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct net_protocol tcp_protocol = {
-	.early_demux	=	tcp_v4_early_demux,
-	.early_demux_handler =  tcp_v4_early_demux,
+static const struct net_protocol tcp_protocol = {
 	.handler	=	tcp_v4_rcv,
 	.err_handler	=	tcp_v4_err,
 	.no_policy	=	1,
 	.icmp_strict_tag_validation = 1,
 };
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct net_protocol udp_protocol = {
-	.early_demux =	udp_v4_early_demux,
-	.early_demux_handler =	udp_v4_early_demux,
+static const struct net_protocol udp_protocol = {
 	.handler =	udp_rcv,
 	.err_handler =	udp_err,
 	.no_policy =	1,
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index b1165f717cd1..4afb94f66da6 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -312,14 +312,13 @@ static bool ip_can_use_hint(const struct sk_buff *skb, const struct iphdr *iph,
 	       ip_hdr(hint)->tos == iph->tos;
 }
 
-INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
+void tcp_v4_early_demux(struct sk_buff *skb);
+int udp_v4_early_demux(struct sk_buff *skb);
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			      struct sk_buff *skb, struct net_device *dev,
 			      const struct sk_buff *hint)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int (*edemux)(struct sk_buff *skb);
 	int err, drop_reason;
 	struct rtable *rt;
 
@@ -332,21 +331,28 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			goto drop_error;
 	}
 
-	if (net->ipv4.sysctl_ip_early_demux &&
-	    !skb_dst(skb) &&
-	    !skb->sk &&
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
+	    !skb_dst(skb) && !skb->sk &&
 	    !ip_is_fragment(iph)) {
-		const struct net_protocol *ipprot;
-		int protocol = iph->protocol;
-
-		ipprot = rcu_dereference(inet_protos[protocol]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
-			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
-					      udp_v4_early_demux, skb);
-			if (unlikely(err))
-				goto drop_error;
-			/* must reload iph, skb->head might have changed */
-			iph = ip_hdr(skb);
+		switch (iph->protocol) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
+				tcp_v4_early_demux(skb);
+
+				/* must reload iph, skb->head might have changed */
+				iph = ip_hdr(skb);
+			}
+			break;
+		case IPPROTO_UDP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
+				err = udp_v4_early_demux(skb);
+				if (unlikely(err))
+					goto drop_error;
+
+				/* must reload iph, skb->head might have changed */
+				iph = ip_hdr(skb);
+			}
+			break;
 		}
 	}
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index cd448cdd3b38..c6f4f8459473 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -350,61 +350,6 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 	return ret;
 }
 
-static void proc_configure_early_demux(int enabled, int protocol)
-{
-	struct net_protocol *ipprot;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct inet6_protocol *ip6prot;
-#endif
-
-	rcu_read_lock();
-
-	ipprot = rcu_dereference(inet_protos[protocol]);
-	if (ipprot)
-		ipprot->early_demux = enabled ? ipprot->early_demux_handler :
-						NULL;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	ip6prot = rcu_dereference(inet6_protos[protocol]);
-	if (ip6prot)
-		ip6prot->early_demux = enabled ? ip6prot->early_demux_handler :
-						 NULL;
-#endif
-	rcu_read_unlock();
-}
-
-static int proc_tcp_early_demux(struct ctl_table *table, int write,
-				void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret = 0;
-
-	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
-
-	if (write && !ret) {
-		int enabled = init_net.ipv4.sysctl_tcp_early_demux;
-
-		proc_configure_early_demux(enabled, IPPROTO_TCP);
-	}
-
-	return ret;
-}
-
-static int proc_udp_early_demux(struct ctl_table *table, int write,
-				void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret = 0;
-
-	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
-
-	if (write && !ret) {
-		int enabled = init_net.ipv4.sysctl_udp_early_demux;
-
-		proc_configure_early_demux(enabled, IPPROTO_UDP);
-	}
-
-	return ret;
-}
-
 static int proc_tfo_blackhole_detect_timeout(struct ctl_table *table,
 					     int write, void *buffer,
 					     size_t *lenp, loff_t *ppos)
@@ -695,14 +640,18 @@ static struct ctl_table ipv4_net_table[] = {
 		.data           = &init_net.ipv4.sysctl_udp_early_demux,
 		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_udp_early_demux
+		.proc_handler   = proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname       = "tcp_early_demux",
 		.data           = &init_net.ipv4.sysctl_tcp_early_demux,
 		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_tcp_early_demux
+		.proc_handler   = proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname       = "nexthop_compat_mode",
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index da5a3c44c4fb..aa7975060f06 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1705,23 +1705,23 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(tcp_v4_do_rcv);
 
-int tcp_v4_early_demux(struct sk_buff *skb)
+void tcp_v4_early_demux(struct sk_buff *skb)
 {
 	const struct iphdr *iph;
 	const struct tcphdr *th;
 	struct sock *sk;
 
 	if (skb->pkt_type != PACKET_HOST)
-		return 0;
+		return;
 
 	if (!pskb_may_pull(skb, skb_transport_offset(skb) + sizeof(struct tcphdr)))
-		return 0;
+		return;
 
 	iph = ip_hdr(skb);
 	th = tcp_hdr(skb);
 
 	if (th->doff < sizeof(struct tcphdr) / 4)
-		return 0;
+		return;
 
 	sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
 				       iph->saddr, th->source,
@@ -1740,7 +1740,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 				skb_dst_set_noref(skb, dst);
 		}
 	}
-	return 0;
+	return;
 }
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 0322cc86b84e..9b4cbc1d790b 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -45,20 +45,23 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
 
-INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 				struct sk_buff *skb)
 {
-	void (*edemux)(struct sk_buff *skb);
-
-	if (net->ipv4.sysctl_ip_early_demux && !skb_dst(skb) && skb->sk == NULL) {
-		const struct inet6_protocol *ipprot;
-
-		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
-			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
-					udp_v6_early_demux, skb);
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
+	    !skb_dst(skb) && !skb->sk) {
+		switch (ipv6_hdr(skb)->nexthdr) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux))
+				tcp_v6_early_demux(skb);
+			break;
+		case IPPROTO_UDP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux))
+				udp_v6_early_demux(skb);
+			break;
+		}
 	}
+
 	if (!skb_valid_dst(skb))
 		ip6_route_input(skb);
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f37dd4aa91c6..9d3ede293258 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1822,7 +1822,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 }
 
-INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
+void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
@@ -2176,12 +2176,7 @@ struct proto tcpv6_prot = {
 };
 EXPORT_SYMBOL_GPL(tcpv6_prot);
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct inet6_protocol tcpv6_protocol = {
-	.early_demux	=	tcp_v6_early_demux,
-	.early_demux_handler =  tcp_v6_early_demux,
+static const struct inet6_protocol tcpv6_protocol = {
 	.handler	=	tcp_v6_rcv,
 	.err_handler	=	tcp_v6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 55afd7f39c04..e2f2e087a753 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1052,7 +1052,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	return NULL;
 }
 
-INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
+void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
@@ -1660,12 +1660,7 @@ int udpv6_getsockopt(struct sock *sk, int level, int optname,
 	return ipv6_getsockopt(sk, level, optname, optval, optlen);
 }
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct inet6_protocol udpv6_protocol = {
-	.early_demux	=	udp_v6_early_demux,
-	.early_demux_handler =  udp_v6_early_demux,
+static const struct inet6_protocol udpv6_protocol = {
 	.handler	=	udpv6_rcv,
 	.err_handler	=	udpv6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
-- 
2.30.2

