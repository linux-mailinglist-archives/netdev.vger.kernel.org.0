Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF536381159
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhENUFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhENUFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 16:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C15026134F;
        Fri, 14 May 2021 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621022668;
        bh=mew8+k+DNifuS346un0o+RSG8IHqKqrNQ+9tghsxJz4=;
        h=From:To:Cc:Subject:Date:From;
        b=J6CcJMIuksZEe4yTECK/ierN8Bt7fmIvwQzLbb5t8wsV01n52b4Itxtjv4rx9O6mc
         AUrBjjkdR7uGw/IeEoQFZha6kltxvBu2P9g9FOKE2rO1mQZQ8qFnn3znQh56nicwq3
         geypbCQjeOm4M4ni3fEBchVRnFW+BDDKCQjOR5Qcmz10HYQSOi+TSdAv6O9FsqeTKf
         suNc1XS+8s0dzdkBo+++hCbQ1ox626/XLgdzn+82ZkA4G+i45RPAr/o6xHhBklMMcS
         z8Fg/6rneRC22qGSUE78rVrWdVBNMKWJ42ZpCeS2q7Yk15ImpgImqg5HHC4/MXJUYE
         iP5c1vOXtF2ag==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, rostedt@goodmis.org,
        dsahern@kernel.org, ntspring@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] tcp: add tracepoint for checksum errors
Date:   Fri, 14 May 2021 13:04:25 -0700
Message-Id: <20210514200425.279351-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint for capturing TCP segments with
a bad checksum. This makes it easy to identify
sources of bad frames in the fleet (e.g. machines
with faulty NICs).

It should also help tools like IOvisor's tcpdrop.py
which are used today to get detailed information
about such packets.

We don't have a socket in many cases so we must
open code the address extraction based just on
the skb.

v2: add missing export for ipv6=m

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/trace/events/tcp.h | 76 ++++++++++++++++++++++++++++++++++++++
 net/core/net-traces.c      |  1 +
 net/ipv4/tcp_input.c       |  1 +
 net/ipv4/tcp_ipv4.c        |  3 ++
 net/ipv6/tcp_ipv6.c        |  2 +
 5 files changed, 83 insertions(+)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index ba94857eea11..521059d8dc0a 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -295,6 +295,82 @@ TRACE_EVENT(tcp_probe,
 		  __entry->srtt, __entry->rcv_wnd, __entry->sock_cookie)
 );
 
+#define TP_STORE_ADDR_PORTS_SKB_V4(__entry, skb)			\
+	do {								\
+		const struct tcphdr *th = (const struct tcphdr *)skb->data; \
+		struct sockaddr_in *v4 = (void *)__entry->saddr;	\
+									\
+		v4->sin_family = AF_INET;				\
+		v4->sin_port = th->source;				\
+		v4->sin_addr.s_addr = ip_hdr(skb)->saddr;		\
+		v4 = (void *)__entry->daddr;				\
+		v4->sin_family = AF_INET;				\
+		v4->sin_port = th->dest;				\
+		v4->sin_addr.s_addr = ip_hdr(skb)->daddr;		\
+	} while (0)
+
+#if IS_ENABLED(CONFIG_IPV6)
+
+#define TP_STORE_ADDR_PORTS_SKB(__entry, skb)				\
+	do {								\
+		const struct iphdr *iph = ip_hdr(skb);			\
+									\
+		if (iph->version == 6) {				\
+			const struct tcphdr *th = (const struct tcphdr *)skb->data; \
+			struct sockaddr_in6 *v6 = (void *)__entry->saddr; \
+									\
+			v6->sin6_family = AF_INET6;			\
+			v6->sin6_port = th->source;			\
+			v6->sin6_addr = ipv6_hdr(skb)->saddr;		\
+			v6 = (void *)__entry->daddr;			\
+			v6->sin6_family = AF_INET6;			\
+			v6->sin6_port = th->dest;			\
+			v6->sin6_addr = ipv6_hdr(skb)->daddr;		\
+		} else							\
+			TP_STORE_ADDR_PORTS_SKB_V4(__entry, skb);	\
+	} while (0)
+
+#else
+
+#define TP_STORE_ADDR_PORTS_SKB(__entry, skb)		\
+	TP_STORE_ADDR_PORTS_SKB_V4(__entry, skb)
+
+#endif
+
+/*
+ * tcp event with only skb
+ */
+DECLARE_EVENT_CLASS(tcp_event_skb,
+
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+		__array(__u8, saddr, sizeof(struct sockaddr_in6))
+		__array(__u8, daddr, sizeof(struct sockaddr_in6))
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+
+		memset(__entry->saddr, 0, sizeof(struct sockaddr_in6));
+		memset(__entry->daddr, 0, sizeof(struct sockaddr_in6));
+
+		TP_STORE_ADDR_PORTS_SKB(__entry, skb);
+	),
+
+	TP_printk("src=%pISpc dest=%pISpc", __entry->saddr, __entry->daddr)
+);
+
+DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
+
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb)
+);
+
 #endif /* _TRACE_TCP_H */
 
 /* This part must be outside protection */
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 283ddb2dbc7d..c40cd8dd75c7 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -60,3 +60,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
 EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
+EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4cf4dd532d1c..cd52ce0a2a85 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5885,6 +5885,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	return;
 
 csum_error:
+	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 312184cead57..4f5b68a90be9 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1731,6 +1731,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 
 csum_err:
+	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 	goto discard;
@@ -1801,6 +1802,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(tcp_checksum_complete(skb))) {
 		bh_unlock_sock(sk);
+		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		return true;
@@ -2098,6 +2100,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
 		__TCP_INC_STATS(net, TCP_MIB_INERRS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5f47c0b6e3de..4435fa342e7a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1538,6 +1538,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 	return 0;
 csum_err:
+	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 	goto discard;
@@ -1754,6 +1755,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
 		__TCP_INC_STATS(net, TCP_MIB_INERRS);
-- 
2.31.1

