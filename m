Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14417EA85B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfJaAr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:47:59 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:32679 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfJaAr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:47:59 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2019 20:47:58 EDT
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [172.25.230.4])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 743811E742;
        Wed, 30 Oct 2019 17:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1572482408;
        bh=wvYATPXpbdAfec5ZE14yws3K3Pmbmy2wNIuA+undweQ=;
        h=Date:To:Subject:Cc:From:From;
        b=UtisTx6qoNX8/oN+NHaz49UUTB420gxe+bcpU7yLzXapux/BQNElih1KrCawPooiY
         683YYoQRtmCgdWQL2MOFtQ3h00NxoX+bOZO+JrBgyvMEC3h4gXfw7N907XxtzzKbVC
         ZwcXhDiE6LV9RJsS2L7XorhtxxhmA0A+GRiPB/IVTvoaAgPFrAwRRwfT6XaH3oJDnG
         yoOyly5A3kUxjCVzA/nJnw+CUyi+UpoGETxlFys76yg38LpyBd2f7dELreNc4jHvXY
         JJDhpVYuHcV7aMzPqIMWfR5ustvhB2rhxLkGs4ywUuOQVpgGgV+oD+8uK22St1EDRb
         RRVQN/384MARQ==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 2FC7695C0964; Wed, 30 Oct 2019 17:40:02 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:40:02 -0700
To:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: icmp6: provide input address for
 traceroute6
Cc:     fruggeri@arista.com
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20191031004004.2FC7695C0964@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

traceroute6 output can be confusing, in that it shows the address
that a router would use to reach the sender, rather than the address
the packet used to reach the router.
Consider this case:

        ------------------------ N2
         |                    |
       ------              ------  N3  ----
       | R1 |              | R2 |------|H2|
       ------              ------      ----
         |                    |
        ------------------------ N1
                  |
                 ----
                 |H1|
                 ----

where H1's default route is through R1, and R1's default route is
through R2 over N2.
traceroute6 from H1 to H2 shows R2's address on N1 rather than on N2.

The script below can be used to reproduce this scenario.

traceroute6 output without this patch:

traceroute to 2000:103::4 (2000:103::4), 30 hops max, 80 byte packets
 1  2000:101::1 (2000:101::1)  0.036 ms  0.008 ms  0.006 ms
 2  2000:101::2 (2000:101::2)  0.011 ms  0.008 ms  0.007 ms
 3  2000:103::4 (2000:103::4)  0.013 ms  0.010 ms  0.009 ms

traceroute6 output with this patch:

traceroute to 2000:103::4 (2000:103::4), 30 hops max, 80 byte packets
 1  2000:101::1 (2000:101::1)  0.056 ms  0.019 ms  0.006 ms
 2  2000:102::2 (2000:102::2)  0.013 ms  0.008 ms  0.008 ms
 3  2000:103::4 (2000:103::4)  0.013 ms  0.009 ms  0.009 ms

#!/bin/bash
#
#        ------------------------ N2
#         |                    |
#       ------              ------  N3  ----
#       | R1 |              | R2 |------|H2|
#       ------              ------      ----
#         |                    |
#        ------------------------ N1
#                  |
#                 ----
#                 |H1|
#                 ----
#
# N1: 2000:101::/64
# N2: 2000:102::/64
# N3: 2000:103::/64
#
# R1's host part of address: 1
# R2's host part of address: 2
# H1's host part of address: 3
# H2's host part of address: 4
#
# For example:
# the IPv6 address of R1's interface on N2 is 2000:102::1/64
#
# Nets are implemented by macvlan interfaces (bridge mode) over
# dummy interfaces.
#

# Create net namespaces
ip netns add host1
ip netns add host2
ip netns add rtr1
ip netns add rtr2

# Create nets
ip link add net1 type dummy; ip link set net1 up
ip link add net2 type dummy; ip link set net2 up
ip link add net3 type dummy; ip link set net3 up

# Add interfaces to net1, move them to their nemaspaces
ip link add link net1 dev host1net1 type macvlan mode bridge
ip link set host1net1 netns host1
ip link add link net1 dev rtr1net1 type macvlan mode bridge
ip link set rtr1net1 netns rtr1
ip link add link net1 dev rtr2net1 type macvlan mode bridge
ip link set rtr2net1 netns rtr2

# Add interfaces to net2, move them to their nemaspaces
ip link add link net2 dev rtr1net2 type macvlan mode bridge
ip link set rtr1net2 netns rtr1
ip link add link net2 dev rtr2net2 type macvlan mode bridge
ip link set rtr2net2 netns rtr2

# Add interfaces to net3, move them to their nemaspaces
ip link add link net3 dev rtr2net3 type macvlan mode bridge
ip link set rtr2net3 netns rtr2
ip link add link net3 dev host2net3 type macvlan mode bridge
ip link set host2net3 netns host2

# Configure interfaces and routes in host1
ip netns exec host1 ip link set lo up
ip netns exec host1 ip link set host1net1 up
ip netns exec host1 ip -6 addr add 2000:101::3/64 dev host1net1
ip netns exec host1 ip -6 route add default via 2000:101::1

# Configure interfaces and routes in rtr1
ip netns exec rtr1 ip link set lo up
ip netns exec rtr1 ip link set rtr1net1 up
ip netns exec rtr1 ip -6 addr add 2000:101::1/64 dev rtr1net1
ip netns exec rtr1 ip link set rtr1net2 up
ip netns exec rtr1 ip -6 addr add 2000:102::1/64 dev rtr1net2
ip netns exec rtr1 ip -6 route add default via 2000:102::2
ip netns exec rtr1 sysctl net.ipv6.conf.all.forwarding=1

# Configure interfaces and routes in rtr2
ip netns exec rtr2 ip link set lo up
ip netns exec rtr2 ip link set rtr2net1 up
ip netns exec rtr2 ip -6 addr add 2000:101::2/64 dev rtr2net1
ip netns exec rtr2 ip link set rtr2net2 up
ip netns exec rtr2 ip -6 addr add 2000:102::2/64 dev rtr2net2
ip netns exec rtr2 ip link set rtr2net3 up
ip netns exec rtr2 ip -6 addr add 2000:103::2/64 dev rtr2net3
ip netns exec rtr2 sysctl net.ipv6.conf.all.forwarding=1

# Configure interfaces and routes in host2
ip netns exec host2 ip link set lo up
ip netns exec host2 ip link set host2net3 up
ip netns exec host2 ip -6 addr add 2000:103::4/64 dev host2net3
ip netns exec host2 ip -6 route add default via 2000:103::2

# Ping host2 from host1
ip netns exec host1 ping6 -c5 2000:103::4

# Traceroute host2 from host1
ip netns exec host1 traceroute6 2000:103::4

# Delete nets
ip link del net3
ip link del net2
ip link del net1

# Delete namespaces
ip netns del rtr2
ip netns del rtr1
ip netns del host2
ip netns del host1

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Original-patch-by: Honggang Xu <hxu@arista.com>

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 62c997201970..ef408a5090a2 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -516,13 +516,29 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 
 	mip6_addr_swap(skb);
 
+	sk = icmpv6_xmit_lock(net);
+	if (!sk)
+		goto out_bh_enable;
+
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
 	fl6.daddr = hdr->saddr;
 	if (force_saddr)
 		saddr = force_saddr;
-	if (saddr)
+	if (saddr) {
 		fl6.saddr = *saddr;
+	} else {
+		/* select a more meaningful saddr from input if */
+		struct net_device *in_netdev;
+
+		in_netdev = dev_get_by_index(net, IP6CB(skb)->iif);
+		if (in_netdev) {
+			ipv6_dev_get_saddr(net, in_netdev, &fl6.daddr,
+					   inet6_sk(sk)->srcprefs,
+					   &fl6.saddr);
+			dev_put(in_netdev);
+		}
+	}
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_oif = iif;
 	fl6.fl6_icmp_type = type;
@@ -531,10 +547,6 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	fl6.mp_hash = rt6_multipath_hash(net, &fl6, skb, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
 
-	sk = icmpv6_xmit_lock(net);
-	if (!sk)
-		goto out_bh_enable;
-
 	sk->sk_mark = mark;
 	np = inet6_sk(sk);
 
