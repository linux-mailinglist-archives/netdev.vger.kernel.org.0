Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D7D269C3D
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 05:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgIODEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 23:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgIODD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 23:03:59 -0400
Received: from Davids-MacBook-Pro.local.net (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49C9720897;
        Tue, 15 Sep 2020 03:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600139038;
        bh=NKc9oqaeexxh3U3k4jEk8eBcR3hQlq1sqpaRc//VbVg=;
        h=From:To:Cc:Subject:Date:From;
        b=TsDbkmdRTV4DBK2ZeAFm4badaqoKI9jtHRHmle9ukT+ZGUQgw7IljGD5k7X9S58Pe
         Zu+LTIJo7nd7QpqcJux79NNvWX3ovpqOUy2CtH0gLPn6ZFqGo4MJutGGNKezFiPqn+
         qfgQvGPxvRwzgO5PihfGOiy2XM/Aqn79aEeobHps=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@kernel.org>,
        Kfir Itzhak <mastertheknife@gmail.com>
Subject: [PATCH net] ipv4: Update exception handling for multipath routes via same device
Date:   Mon, 14 Sep 2020 21:03:54 -0600
Message-Id: <20200915030354.38468-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kfir reported that pmtu exceptions are not created properly for
deployments where multipath routes use the same device.

After some digging I see 2 compounding problems:
1. ip_route_output_key_hash_rcu is updating the flowi4_oif *after*
   the route lookup. This is the second use case where this has
   been a problem (the first is related to use of vti devices with
   VRF). I can not find any reason for the oif to be changed after the
   lookup; the code goes back to the start of git. It does not seem
   logical so remove it.

2. fib_lookups for exceptions do not call fib_select_path to handle
   multipath route selection based on the hash.

The end result is that the fib_lookup used to add the exception
always creates it based using the first leg of the route.

An example topology showing the problem:

                 |  host1
             +------+
             | eth0 |  .209
             +------+
                 |
             +------+
     switch  | br0  |
             +------+
                 |
       +---------+---------+
       | host2             |  host3
   +------+             +------+
   | eth0 | .250        | eth0 | 192.168.252.252
   +------+             +------+

   +-----+             +-----+
   | vti | .2          | vti | 192.168.247.3
   +-----+             +-----+
       \                  /
 =================================
 tunnels
         192.168.247.1/24

for h in host1 host2 host3; do
        ip netns add ${h}
        ip -netns ${h} link set lo up
        ip netns exec ${h} sysctl -wq net.ipv4.ip_forward=1
done

ip netns add switch
ip -netns switch li set lo up
ip -netns switch link add br0 type bridge stp 0
ip -netns switch link set br0 up

for n in 1 2 3; do
        ip -netns switch link add eth-sw type veth peer name eth-h${n}
        ip -netns switch li set eth-h${n} master br0 up
        ip -netns switch li set eth-sw netns host${n} name eth0
done

ip -netns host1 addr add 192.168.252.209/24 dev eth0
ip -netns host1 link set dev eth0 up
ip -netns host1 route add 192.168.247.0/24 \
        nexthop via 192.168.252.250 dev eth0 nexthop via 192.168.252.252 dev eth0

ip -netns host2 addr add 192.168.252.250/24 dev eth0
ip -netns host2 link set dev eth0 up

ip -netns host2 addr add 192.168.252.252/24 dev eth0
ip -netns host3 link set dev eth0 up

ip netns add tunnel
ip -netns tunnel li set lo up
ip -netns tunnel li add br0 type bridge
ip -netns tunnel li set br0 up
for n in $(seq 11 20); do
        ip -netns tunnel addr add dev br0 192.168.247.${n}/24
done

for n in 2 3
do
        ip -netns tunnel link add vti${n} type veth peer name eth${n}
        ip -netns tunnel link set eth${n} mtu 1360 master br0 up
        ip -netns tunnel link set vti${n} netns host${n} mtu 1360 up
        ip -netns host${n} addr add dev vti${n} 192.168.247.${n}/24
done
ip -netns tunnel ro add default nexthop via 192.168.247.2 nexthop via 192.168.247.3

ip netns exec host1 ping -M do -s 1400 -c3 -I 192.168.252.209 192.168.247.11
ip netns exec host1 ping -M do -s 1400 -c3 -I 192.168.252.209 192.168.247.15
ip -netns host1 ro ls cache

Before this patch the cache always shows exceptions against the first
leg in the multipath route; 192.168.252.250 per this example. Since the
hash has an initial random seed, you may need to vary the final octet
more than what is listed. In my tests, using addresses between 11 and 19
usually found 1 that used both legs.

With this patch, the cache will have exceptions for both legs.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions")
Reported-by: Kfir Itzhak <mastertheknife@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/route.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e5f210d00851..58642b29a499 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -786,8 +786,10 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 			neigh_event_send(n, NULL);
 		} else {
 			if (fib_lookup(net, fl4, &res, 0) == 0) {
-				struct fib_nh_common *nhc = FIB_RES_NHC(res);
+				struct fib_nh_common *nhc;
 
+				fib_select_path(net, &res, fl4, skb);
+				nhc = FIB_RES_NHC(res);
 				update_or_create_fnhe(nhc, fl4->daddr, new_gw,
 						0, false,
 						jiffies + ip_rt_gc_timeout);
@@ -1013,6 +1015,7 @@ out:	kfree_skb(skb);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
+	struct net *net = dev_net(dst->dev);
 	u32 old_mtu = ipv4_mtu(dst);
 	struct fib_result res;
 	bool lock = false;
@@ -1033,9 +1036,11 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		return;
 
 	rcu_read_lock();
-	if (fib_lookup(dev_net(dst->dev), fl4, &res, 0) == 0) {
-		struct fib_nh_common *nhc = FIB_RES_NHC(res);
+	if (fib_lookup(net, fl4, &res, 0) == 0) {
+		struct fib_nh_common *nhc;
 
+		fib_select_path(net, &res, fl4, NULL);
+		nhc = FIB_RES_NHC(res);
 		update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 				      jiffies + ip_rt_mtu_expires);
 	}
@@ -2668,8 +2673,6 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 	fib_select_path(net, res, fl4, skb);
 
 	dev_out = FIB_RES_DEV(*res);
-	fl4->flowi4_oif = dev_out->ifindex;
-
 
 make_route:
 	rth = __mkroute_output(res, fl4, orig_oif, dev_out, flags);
-- 
2.24.3 (Apple Git-128)

