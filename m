Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613C119DFBA
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 22:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgDCUmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 16:42:11 -0400
Received: from balrog.mythic-beasts.com ([46.235.227.24]:50607 "EHLO
        balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCUmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 16:42:11 -0400
X-Greylist: delayed 1064 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2020 16:42:10 EDT
Received: from [2001:678:634:203:cf83:32c6:10b8:3403] (port=48100 helo=phosphorus.lan.house.timstallard.me.uk)
        by balrog.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <code@timstallard.me.uk>)
        id 1jKSrZ-0001xT-Dy; Fri, 03 Apr 2020 21:24:25 +0100
From:   Tim Stallard <code@timstallard.me.uk>
To:     netdev@vger.kernel.org
Cc:     Tim Stallard <code@timstallard.me.uk>
Subject: [PATCH net] net: icmp6: do not select saddr from iif when route has prefsrc set
Date:   Fri,  3 Apr 2020 21:22:57 +0100
Message-Id: <20200403202257.1167-1-code@timstallard.me.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 50
X-Spam-Status: No, score=5.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit fac6fce9bdb5 ("net: icmp6: provide input address for
traceroute6") ICMPv6 errors have source addresses from the ingress
interface. However, this overrides when source address selection is
influenced by setting preferred source addresses on routes.

This can result in ICMP errors being lost to upstream BCP38 filters
when the wrong source addresses are used, breaking path MTU discovery
and traceroute.

This patch sets the modified source address selection to only take place
when the route used has no prefsrc set.

It can be tested with:

ip link add v1 type veth peer name v2
ip netns add test
ip netns exec test ip link set lo up
ip link set v2 netns test
ip link set v1 up
ip netns exec test ip link set v2 up
ip addr add 2001:db8::1/64 dev v1 nodad
ip addr add 2001:db8::3 dev v1 nodad
ip netns exec test ip addr add 2001:db8::2/64 dev v2 nodad
ip netns exec test ip route add unreachable 2001:db8:1::1
ip netns exec test ip addr add 2001:db8:100::1 dev lo
ip netns exec test ip route add 2001:db8::1 dev v2 src 2001:db8:100::1
ip route add 2001:db8:1000::1 via 2001:db8::2
traceroute6 -s 2001:db8::1 2001:db8:1000::1
traceroute6 -s 2001:db8::3 2001:db8:1000::1
ip netns delete test

Output before:
$ traceroute6 -s 2001:db8::1 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8::2 (2001:db8::2)  0.843 ms !N  0.396 ms !N  0.257 ms !N
$ traceroute6 -s 2001:db8::3 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8::2 (2001:db8::2)  0.772 ms !N  0.257 ms !N  0.357 ms !N

After:
$ traceroute6 -s 2001:db8::1 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8:100::1 (2001:db8:100::1)  8.885 ms !N  0.310 ms !N  0.174 ms !N
$ traceroute6 -s 2001:db8::3 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8::2 (2001:db8::2)  1.403 ms !N  0.205 ms !N  0.313 ms !N

Fixes: fac6fce9bdb5 ("net: icmp6: provide input address for traceroute6")
Signed-off-by: Tim Stallard <code@timstallard.me.uk>
---
 net/ipv6/icmp.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 2688f3e82165..fc5000370030 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -229,6 +229,25 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 	return res;
 }
 
+static bool icmpv6_rt_has_prefsrc(struct sock *sk, u8 type,
+				  struct flowi6 *fl6)
+{
+	struct net *net = sock_net(sk);
+	struct dst_entry *dst;
+	bool res = false;
+
+	dst = ip6_route_output(net, sk, fl6);
+	if (!dst->error) {
+		struct rt6_info *rt = (struct rt6_info *)dst;
+		struct in6_addr prefsrc;
+
+		rt6_get_prefsrc(rt, &prefsrc);
+		res = !ipv6_addr_any(&prefsrc);
+	}
+	dst_release(dst);
+	return res;
+}
+
 /*
  *	an inline helper for the "simple" if statement below
  *	checks if parameter problem report is caused by an
@@ -527,7 +546,7 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		saddr = force_saddr;
 	if (saddr) {
 		fl6.saddr = *saddr;
-	} else {
+	} else if (!icmpv6_rt_has_prefsrc(sk, type, &fl6)) {
 		/* select a more meaningful saddr from input if */
 		struct net_device *in_netdev;
 
-- 
2.20.1

