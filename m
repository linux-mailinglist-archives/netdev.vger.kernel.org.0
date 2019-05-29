Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08882DDB9
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfE2NH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:07:57 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:48663 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726784AbfE2NH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 09:07:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TSxxvKn_1559135274;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0TSxxvKn_1559135274)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 May 2019 21:07:54 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        laoar.shao@gmail.com, songliubraving@fb.com
Subject: [PATCH net-next 1/3] udp: introduce a new tracepoint for udp_send_skb
Date:   Wed, 29 May 2019 21:06:55 +0800
Message-Id: <20190529130656.23979-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529130656.23979-1-tonylu@linux.alibaba.com>
References: <20190529130656.23979-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a new tracepoint trace_udp_send, it will trace UDP
packets that are going to be send to the IP layer.

This exposes src and dst IP addresses and ports of the connection. We
could use kprobe or tcpdump to do similar things, however using tracepoint
makes it easier to use and to integrate into perf or ebpf.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/trace/events/udp.h | 81 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/udp.c             |  1 +
 net/ipv6/udp.c             |  2 +
 3 files changed, 84 insertions(+)

diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index 336fe272889f..f2c26780e2a9 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -7,6 +7,38 @@
 
 #include <linux/udp.h>
 #include <linux/tracepoint.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/udp.h>
+
+#define TP_STORE_V4MAPPED(__entry, saddr, daddr)		\
+	do {							\
+		struct in6_addr *pin6;				\
+								\
+		pin6 = (struct in6_addr *)__entry->saddr_v6;	\
+		ipv6_addr_set_v4mapped(saddr, pin6);		\
+		pin6 = (struct in6_addr *)__entry->daddr_v6;	\
+		ipv6_addr_set_v4mapped(daddr, pin6);		\
+	} while (0)
+
+#if IS_ENABLED(CONFIG_IPV6)
+#define TP_STORE_ADDRS(__entry, saddr, daddr, saddr6, daddr6)		\
+	do {								\
+		if (sk->sk_family == AF_INET6) {			\
+			struct in6_addr *pin6;				\
+									\
+			pin6 = (struct in6_addr *)__entry->saddr_v6;	\
+			*pin6 = saddr6;					\
+			pin6 = (struct in6_addr *)__entry->daddr_v6;	\
+			*pin6 = daddr6;					\
+		} else {						\
+			TP_STORE_V4MAPPED(__entry, saddr, daddr);	\
+		}							\
+	} while (0)
+#else
+#define TP_STORE_ADDRS(__entry, saddr, daddr, saddr6, daddr6)	\
+	TP_STORE_V4MAPPED(__entry, saddr, daddr)
+#endif
 
 TRACE_EVENT(udp_fail_queue_rcv_skb,
 
@@ -27,6 +59,55 @@ TRACE_EVENT(udp_fail_queue_rcv_skb,
 	TP_printk("rc=%d port=%hu", __entry->rc, __entry->lport)
 );
 
+DECLARE_EVENT_CLASS(udp_event_sk_skb,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+		__field(const void *, skaddr)
+		__field(__u16, sport)
+		__field(__u16, dport)
+		__array(__u8, saddr, 4)
+		__array(__u8, daddr, 4)
+		__array(__u8, saddr_v6, 16)
+		__array(__u8, daddr_v6, 16)
+	),
+
+	TP_fast_assign(
+		struct inet_sock *inet = inet_sk(sk);
+		__be32 *p32;
+
+		__entry->skbaddr = skb;
+		__entry->skaddr = sk;
+
+		__entry->sport = ntohs(inet->inet_sport);
+		__entry->dport = ntohs(inet->inet_dport);
+
+		p32 = (__be32 *) __entry->saddr;
+		*p32 = inet->inet_saddr;
+
+		p32 = (__be32 *) __entry->daddr;
+		*p32 =  inet->inet_daddr;
+
+		TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
+			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
+	),
+
+	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c",
+		  __entry->sport, __entry->dport, __entry->saddr,
+		  __entry->daddr, __entry->saddr_v6, __entry->daddr_v6)
+);
+
+DEFINE_EVENT(udp_event_sk_skb, udp_send,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb)
+);
+
 #endif /* _TRACE_UDP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8fb250ed53d4..3ff6fea9debe 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -898,6 +898,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 		uh->check = CSUM_MANGLED_0;
 
 send:
+	trace_udp_send(sk, skb);
 	err = ip_send_skb(sock_net(sk), skb);
 	if (err) {
 		if (err == -ENOBUFS && !inet->recverr) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 07fa579dfb96..3a26990d5dc8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -56,6 +56,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <trace/events/skb.h>
+#include <trace/events/udp.h>
 #include "udp_impl.h"
 
 static bool udp6_lib_exact_dif_match(struct net *net, struct sk_buff *skb)
@@ -1177,6 +1178,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 		uh->check = CSUM_MANGLED_0;
 
 send:
+	trace_udp_send(sk, skb);
 	err = ip6_send_skb(skb);
 	if (err) {
 		if (err == -ENOBUFS && !inet6_sk(sk)->recverr) {
-- 
2.21.0

