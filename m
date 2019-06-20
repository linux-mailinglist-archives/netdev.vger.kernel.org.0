Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065CE4CDCC
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfFTMel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:34:41 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:33595 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfFTMel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 08:34:41 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 857B62D21BB;
        Thu, 20 Jun 2019 14:34:36 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hdwGy-0001th-7S; Thu, 20 Jun 2019 14:34:36 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] ipv6: fix neighbour resolution with raw socket
Date:   Thu, 20 Jun 2019 14:34:34 +0200
Message-Id: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scenario is the following: the user uses a raw socket to send an ipv6
packet, destinated to a not-connected network, and specify a connected nh.
Here is the corresponding python script to reproduce this scenario:

 import socket
 IPPROTO_RAW = 255
 send_s = socket.socket(socket.AF_INET6, socket.SOCK_RAW, IPPROTO_RAW)
 # scapy
 # p = IPv6(src='fd00:100::1', dst='fd00:200::fa')/ICMPv6EchoRequest()
 # str(p)
 req = b'`\x00\x00\x00\x00\x08:@\xfd\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xfd\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfa\x80\x00\x81\xc0\x00\x00\x00\x00'
 send_s.sendto(req, ('fd00:175::2', 0, 0, 0))

fd00:175::/64 is a connected route and fd00:200::fa is not a connected
host.

With this scenario, the kernel starts by sending a NS to resolve
fd00:175::2. When it receives the NA, it flushes its queue and try to send
the initial packet. But instead of sending it, it sends another NS to
resolve fd00:200::fa, which obvioulsy fails, thus the packet is dropped. If
the user sends again the packet, it now uses the right nh (fd00:175::2).

The problem is that ip6_dst_lookup_neigh() uses the rt6i_gateway, which is
:: because the associated route is a connected route, thus it uses the dst
addr of the packet. Let's use rt6_nexthop() to choose the right nh.

Note that rt and in6addr_any are const in ip6_dst_lookup_neigh(), thus
let's constify rt6_nexthop() to avoid ugly cast.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/ip6_route.h | 4 ++--
 net/ipv6/ip6_output.c   | 2 +-
 net/ipv6/route.c        | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 4790beaa86e0..ee7405e759ba 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -262,8 +262,8 @@ static inline bool ip6_sk_ignore_df(const struct sock *sk)
 	       inet6_sk(sk)->pmtudisc == IPV6_PMTUDISC_OMIT;
 }
 
-static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt,
-					   struct in6_addr *daddr)
+static inline const struct in6_addr *rt6_nexthop(const struct rt6_info *rt,
+						 const struct in6_addr *daddr)
 {
 	if (rt->rt6i_flags & RTF_GATEWAY)
 		return &rt->rt6i_gateway;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 834475717110..21efcd02f337 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -59,8 +59,8 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	const struct in6_addr *nexthop;
 	struct neighbour *neigh;
-	struct in6_addr *nexthop;
 	int ret;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 11ad62effd56..b6449bc03f11 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -218,7 +218,8 @@ static struct neighbour *ip6_dst_neigh_lookup(const struct dst_entry *dst,
 {
 	const struct rt6_info *rt = container_of(dst, struct rt6_info, dst);
 
-	return ip6_neigh_lookup(&rt->rt6i_gateway, dst->dev, skb, daddr);
+	return ip6_neigh_lookup(rt6_nexthop(rt, &in6addr_any),
+				dst->dev, skb, daddr);
 }
 
 static void ip6_confirm_neigh(const struct dst_entry *dst, const void *daddr)
-- 
2.21.0

