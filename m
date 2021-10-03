Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537CB420376
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhJCSrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:47:45 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39510 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhJCSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 14:47:44 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 88E0A200BBBC;
        Sun,  3 Oct 2021 20:45:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 88E0A200BBBC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633286754;
        bh=FW3tm+Yb/Quw8npCQiYWXbghKSHpkOxoBG80ajmWbrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2n4UAVkf2EdQZjLqcrE7UDzJj4EN89m/ZwjLXq8trstgM547cYhB7Ca58sqaaOG4/
         nVetg/oZBLrIyrcY69QUtBVKbPX4MuQM92ojbKjWM1KohKmoyBm+RJMTx1g4gtx3jZ
         fni9OBTM0h1ewMQwFmQ/H+DeSOCNvcEYKTI3Tpkr5CFa7HdAAKyVncZhwCMPzpb1zg
         ozzo4ghviraayqsQguRoT/xF0ue4XoOEsiWrUtfYrznt/OP9SUu4MVbLaPjJI9ReSK
         GcRnoEAqy61ktYZiGqtLkfZl+YSj/HIqLpgjHROj0vC01aD+pODozqvcourNzVC9q/
         Xa/QVMFNsneTA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 1/4] ipv6: ioam: Distinguish input and output for hop-limit
Date:   Sun,  3 Oct 2021 20:45:36 +0200
Message-Id: <20211003184539.23629-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003184539.23629-1-justin.iurman@uliege.be>
References: <20211003184539.23629-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch anticipates the support for the IOAM insertion inside in-transit
packets, by making a difference between input and output in order to determine
the right value for its hop-limit (inherited from the IPv6 hop-limit).

Input case: happens before ip6_forward, the IPv6 hop-limit is not decremented
yet -> decrement the IOAM hop-limit to reflect the new hop inside the trace.

Output case: happens after ip6_forward, the IPv6 hop-limit has already been
decremented -> keep the same value for the IOAM hop-limit.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/net/ioam6.h |  3 ++-
 net/ipv6/exthdrs.c  |  2 +-
 net/ipv6/ioam6.c    | 11 ++++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/ioam6.h b/include/net/ioam6.h
index 3c2993bc48c8..3f45ba37a2c6 100644
--- a/include/net/ioam6.h
+++ b/include/net/ioam6.h
@@ -56,7 +56,8 @@ static inline struct ioam6_pernet_data *ioam6_pernet(struct net *net)
 struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id);
 void ioam6_fill_trace_data(struct sk_buff *skb,
 			   struct ioam6_namespace *ns,
-			   struct ioam6_trace_hdr *trace);
+			   struct ioam6_trace_hdr *trace,
+			   bool is_input);
 
 int ioam6_init(void);
 void ioam6_exit(void);
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 3a871a09f962..38ece3b7b839 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -979,7 +979,7 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 		if (!skb_valid_dst(skb))
 			ip6_route_input(skb);
 
-		ioam6_fill_trace_data(skb, ns, trace);
+		ioam6_fill_trace_data(skb, ns, trace, true);
 		break;
 	default:
 		break;
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 5e8961004832..4e5583dbadac 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -631,7 +631,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
 				    struct ioam6_schema *sc,
-				    u8 sclen)
+				    u8 sclen, bool is_input)
 {
 	struct __kernel_sock_timeval ts;
 	u64 raw64;
@@ -645,7 +645,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 	/* hop_lim and node_id */
 	if (trace->type.bit0) {
 		byte = ipv6_hdr(skb)->hop_limit;
-		if (skb->dev)
+		if (is_input)
 			byte--;
 
 		raw32 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id;
@@ -730,7 +730,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 	/* hop_lim and node_id (wide) */
 	if (trace->type.bit8) {
 		byte = ipv6_hdr(skb)->hop_limit;
-		if (skb->dev)
+		if (is_input)
 			byte--;
 
 		raw64 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id_wide;
@@ -786,7 +786,8 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 /* called with rcu_read_lock() */
 void ioam6_fill_trace_data(struct sk_buff *skb,
 			   struct ioam6_namespace *ns,
-			   struct ioam6_trace_hdr *trace)
+			   struct ioam6_trace_hdr *trace,
+			   bool is_input)
 {
 	struct ioam6_schema *sc;
 	u8 sclen = 0;
@@ -822,7 +823,7 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 		return;
 	}
 
-	__ioam6_fill_trace_data(skb, ns, trace, sc, sclen);
+	__ioam6_fill_trace_data(skb, ns, trace, sc, sclen, is_input);
 	trace->remlen -= trace->nodelen + sclen;
 }
 
-- 
2.25.1

