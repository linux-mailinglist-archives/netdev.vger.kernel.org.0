Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C66D130D1
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfECPBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:01:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60837 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbfECPBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 11:01:49 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33E2A3139C9C;
        Fri,  3 May 2019 15:01:49 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 611B050B54;
        Fri,  3 May 2019 15:01:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] net: use indirect calls helpers for L3 handler hooks
Date:   Fri,  3 May 2019 17:01:37 +0200
Message-Id: <ebe0eafed30176df954d3eb2671dbde60678e4e3.1556889691.git.pabeni@redhat.com>
In-Reply-To: <cover.1556889691.git.pabeni@redhat.com>
References: <cover.1556889691.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 03 May 2019 15:01:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that we avoid another indirect call per RX packet in the common
case.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/ip_input.c  | 6 +++++-
 net/ipv6/ip6_input.c | 7 ++++++-
 net/ipv6/tcp_ipv6.c  | 3 ++-
 net/ipv6/udp.c       | 3 ++-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 1132d6d1796a..8d78de4b0304 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -130,6 +130,7 @@
 #include <linux/inetdevice.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <net/snmp.h>
 #include <net/ip.h>
@@ -188,6 +189,8 @@ bool ip_call_ra_chain(struct sk_buff *skb)
 	return false;
 }
 
+INDIRECT_CALLABLE_DECLARE(int udp_rcv(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int tcp_v4_rcv(struct sk_buff *));
 void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 {
 	const struct net_protocol *ipprot;
@@ -205,7 +208,8 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 			}
 			nf_reset(skb);
 		}
-		ret = ipprot->handler(skb);
+		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v4_rcv, udp_rcv,
+				      skb);
 		if (ret < 0) {
 			protocol = -ret;
 			goto resubmit;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index c7ed2b6d5a1d..adf06159837f 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -29,6 +29,7 @@
 #include <linux/icmpv6.h>
 #include <linux/mroute6.h>
 #include <linux/slab.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
@@ -316,6 +317,9 @@ void ipv6_list_rcv(struct list_head *head, struct packet_type *pt,
 	ip6_sublist_rcv(&sublist, curr_dev, curr_net);
 }
 
+INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *));
+
 /*
  *	Deliver the packet to the host
  */
@@ -391,7 +395,8 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 			goto discard;
 
-		ret = ipprot->handler(skb);
+		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
+				      skb);
 		if (ret > 0) {
 			if (ipprot->flags & INET6_PROTO_FINAL) {
 				/* Not an extension header, most likely UDP
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 82018bdce863..d58bf84e0f9a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -43,6 +43,7 @@
 #include <linux/ipv6.h>
 #include <linux/icmpv6.h>
 #include <linux/random.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <net/tcp.h>
 #include <net/ndisc.h>
@@ -1435,7 +1436,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
 }
 
-static int tcp_v6_rcv(struct sk_buff *skb)
+INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
 	struct sk_buff *skb_to_free;
 	int sdif = inet6_sdif(skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 2464fba569b4..b3fcafaf5576 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -36,6 +36,7 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <net/addrconf.h>
 #include <net/ndisc.h>
@@ -1021,7 +1022,7 @@ static void udp_v6_early_demux(struct sk_buff *skb)
 	}
 }
 
-static __inline__ int udpv6_rcv(struct sk_buff *skb)
+INDIRECT_CALLABLE_SCOPE int udpv6_rcv(struct sk_buff *skb)
 {
 	return __udp6_lib_rcv(skb, &udp_table, IPPROTO_UDP);
 }
-- 
2.20.1

