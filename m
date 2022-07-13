Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8575735CC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiGMLs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiGMLs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:48:57 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04B1C45F7E;
        Wed, 13 Jul 2022 04:48:55 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id B457A60046;
        Wed, 13 Jul 2022 13:48:54 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1oBarO-0007ec-KA; Wed, 13 Jul 2022 13:48:54 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stable@vger.kernel.org, Edwin Brossette <edwin.brossette@6wind.com>
Subject: [PATCH net v3 1/2] ip: fix dflt addr selection for connected nexthop
Date:   Wed, 13 Jul 2022 13:48:52 +0200
Message-Id: <20220713114853.29406-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a nexthop is added, without a gw address, the default scope was set
to 'host'. Thus, when a source address is selected, 127.0.0.1 may be chosen
but rejected when the route is used.

When using a route without a nexthop id, the scope can be configured in the
route, thus the problem doesn't exist.

To explain more deeply: when a user creates a nexthop, it cannot specify
the scope. To create it, the function nh_create_ipv4() calls fib_check_nh()
with scope set to 0. fib_check_nh() calls fib_check_nh_nongw() wich was
setting scope to 'host'. Then, nh_create_ipv4() calls
fib_info_update_nhc_saddr() with scope set to 'host'. The src addr is
chosen before the route is inserted.

When a 'standard' route (ie without a reference to a nexthop) is added,
fib_create_info() calls fib_info_update_nhc_saddr() with the scope set by
the user. iproute2 set the scope to 'link' by default.

Here is a way to reproduce the problem:
ip netns add foo
ip -n foo link set lo up
ip netns add bar
ip -n bar link set lo up
sleep 1

ip -n foo link add name eth0 type dummy
ip -n foo link set eth0 up
ip -n foo address add 192.168.0.1/24 dev eth0

ip -n foo link add name veth0 type veth peer name veth1 netns bar
ip -n foo link set veth0 up
ip -n bar link set veth1 up

ip -n bar address add 192.168.1.1/32 dev veth1
ip -n bar route add default dev veth1

ip -n foo nexthop add id 1 dev veth0
ip -n foo route add 192.168.1.1 nhid 1

Try to get/use the route:
> $ ip -n foo route get 192.168.1.1
> RTNETLINK answers: Invalid argument
> $ ip netns exec foo ping -c1 192.168.1.1
> ping: connect: Invalid argument

Try without nexthop group (iproute2 sets scope to 'link' by dflt):
ip -n foo route del 192.168.1.1
ip -n foo route add 192.168.1.1 dev veth0

Try to get/use the route:
> $ ip -n foo route get 192.168.1.1
> 192.168.1.1 dev veth0 src 192.168.0.1 uid 0
>     cache
> $ ip netns exec foo ping -c1 192.168.1.1
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.039 ms
>
> --- 192.168.1.1 ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.039/0.039/0.039/0.000 ms

CC: stable@vger.kernel.org
Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Reported-by: Edwin Brossette <edwin.brossette@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v2 -> v3:
 - no change

v1 -> v2:
 - remove useless arp off / fixed mac settings in the description

 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a57ba23571c9..20177ecf5bdd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1230,7 +1230,7 @@ static int fib_check_nh_nongw(struct net *net, struct fib_nh *nh,
 
 	nh->fib_nh_dev = in_dev->dev;
 	dev_hold_track(nh->fib_nh_dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
-	nh->fib_nh_scope = RT_SCOPE_HOST;
+	nh->fib_nh_scope = RT_SCOPE_LINK;
 	if (!netif_carrier_ok(nh->fib_nh_dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 	err = 0;
-- 
2.33.0

