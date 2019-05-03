Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A2A130D0
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfECPBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:01:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbfECPBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 11:01:50 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CBB23139CA3;
        Fri,  3 May 2019 15:01:50 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 778BF50B54;
        Fri,  3 May 2019 15:01:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: use indirect calls helpers at early demux stage
Date:   Fri,  3 May 2019 17:01:38 +0200
Message-Id: <79e792e45a71e111f4266c0589611432b5ac1e7d.1556889691.git.pabeni@redhat.com>
In-Reply-To: <cover.1556889691.git.pabeni@redhat.com>
References: <cover.1556889691.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 03 May 2019 15:01:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that we avoid another indirect call per RX packet, if
early demux is enabled.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/ip_input.c  | 5 ++++-
 net/ipv6/ip6_input.c | 5 ++++-
 net/ipv6/tcp_ipv6.c  | 2 +-
 net/ipv6/udp.c       | 2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 8d78de4b0304..ed97724c5e33 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -309,6 +309,8 @@ static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 	return true;
 }
 
+INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			      struct sk_buff *skb, struct net_device *dev)
 {
@@ -326,7 +328,8 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 
 		ipprot = rcu_dereference(inet_protos[protocol]);
 		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
-			err = edemux(skb);
+			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
+					      udp_v4_early_demux, skb);
 			if (unlikely(err))
 				goto drop_error;
 			/* must reload iph, skb->head might have changed */
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index adf06159837f..b50b1af1f530 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -48,6 +48,8 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
 
+INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 				struct sk_buff *skb)
 {
@@ -58,7 +60,8 @@ static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 
 		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
 		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
-			edemux(skb);
+			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
+					udp_v6_early_demux, skb);
 	}
 	if (!skb_valid_dst(skb))
 		ip6_route_input(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d58bf84e0f9a..beaf28456301 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1655,7 +1655,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 }
 
-static void tcp_v6_early_demux(struct sk_buff *skb)
+INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b3fcafaf5576..07fa579dfb96 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -981,7 +981,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	return NULL;
 }
 
-static void udp_v6_early_demux(struct sk_buff *skb)
+INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
-- 
2.20.1

