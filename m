Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A9519DFBB
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 22:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgDCUmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 16:42:43 -0400
Received: from balrog.mythic-beasts.com ([46.235.227.24]:38157 "EHLO
        balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCUmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 16:42:43 -0400
Received: from [2001:678:634:203:cf83:32c6:10b8:3403] (port=49362 helo=phosphorus.lan.house.timstallard.me.uk)
        by balrog.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <code@timstallard.me.uk>)
        id 1jKStp-0003As-S2; Fri, 03 Apr 2020 21:26:46 +0100
From:   Tim Stallard <code@timstallard.me.uk>
To:     netdev@vger.kernel.org
Cc:     Tim Stallard <code@timstallard.me.uk>
Subject: [PATCH net] net: ipv6: do not consider routes via gateways for anycast address check
Date:   Fri,  3 Apr 2020 21:26:21 +0100
Message-Id: <20200403202621.1657-1-code@timstallard.me.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 50
X-Spam-Status: No, score=5.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The behaviour for what is considered an anycast address changed in
commit 45e4fd26683c ("ipv6: Only create RTF_CACHE routes after
encountering pmtu exception"). This now considers the first
address in a subnet where there is a route via a gateway
to be an anycast address.

This breaks path MTU discovery and traceroutes when a host in a
remote network uses the address at the start of a prefix
(eg 2600:: advertised as 2600::/48 in the DFZ) as ICMP errors
will not be sent to anycast addresses.

This patch excludes any routes with a gateway, or via point to
point links, like the behaviour previously from
rt6_is_gw_or_nonexthop in net/ipv6/route.c.

This can be tested with:
ip link add v1 type veth peer name v2
ip netns add test
ip netns exec test ip link set lo up
ip link set v2 netns test
ip link set v1 up
ip netns exec test ip link set v2 up
ip addr add 2001:db8::1/64 dev v1 nodad
ip addr add 2001:db8:100:: dev lo nodad
ip netns exec test ip addr add 2001:db8::2/64 dev v2 nodad
ip netns exec test ip route add unreachable 2001:db8:1::1
ip netns exec test ip route add 2001:db8:100::/64 via 2001:db8::1
ip netns exec test sysctl net.ipv6.conf.all.forwarding=1
ip route add 2001:db8:1::1 via 2001:db8::2
ping -I 2001:db8::1 2001:db8:1::1 -c1
ping -I 2001:db8:100:: 2001:db8:1::1 -c1
ip addr delete 2001:db8:100:: dev lo
ip netns delete test

Currently the first ping will get back a destination unreachable ICMP
error, but the second will never get a response, with "icmp6_send:
acast source" logged. After this patch, both get destination
unreachable ICMP replies.

Fixes: 45e4fd26683c ("ipv6: Only create RTF_CACHE routes after encountering pmtu exception")
Signed-off-by: Tim Stallard <code@timstallard.me.uk>
---
 include/net/ip6_route.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index f7543c095b33..9947eb1e9eb6 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -254,6 +254,7 @@ static inline bool ipv6_anycast_destination(const struct dst_entry *dst,
 
 	return rt->rt6i_flags & RTF_ANYCAST ||
 		(rt->rt6i_dst.plen < 127 &&
+		 !(rt->rt6i_flags & (RTF_GATEWAY | RTF_NONEXTHOP)) &&
 		 ipv6_addr_equal(&rt->rt6i_dst.addr, daddr));
 }
 
-- 
2.20.1

