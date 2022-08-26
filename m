Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067C25A1F8D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244298AbiHZDw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiHZDw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:52:57 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F47798A73;
        Thu, 25 Aug 2022 20:52:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VNHKDHP_1661485971;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VNHKDHP_1661485971)
          by smtp.aliyun-inc.com;
          Fri, 26 Aug 2022 11:52:52 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        edwin.brossette@6wind.com, nicolas.dichtel@6wind.com,
        pabeni@redhat.com
Subject: 747c143 caused icmp redirect to fail
Date:   Fri, 26 Aug 2022 11:52:51 +0800
Message-Id: <1661485971-57887-1-git-send-email-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The detailed description: When testing with selftests/net/icmp_redirect.sh, a redirect exception FAIL occurred for IPv4.
This is not in line with actual expectations. r1 changes the route to the destination network 172.16.2.0/24 from 10.1.1.2 to 172.16.1.254. After h1 sends the ping packet, h1 continues to obtain the route to 172.16.2.2, and the result is not as expected.
This flaw was introduced by 747c14307214b55dbd8250e1ab44cad8305756f1. When this commit is rolled back, the test will pass.

bug commit: 747c14307214b55dbd8250e1ab44cad8305756f1

Anolis bugzilla link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1843

uname -mi: aarch64 aarch64

uname -r: 6.0.0-rc2-00159-g4c612826bec1

cat /proc/version: Linux version 6.0.0-rc2-00159-g4c612826bec1 (root@iZbp1abkyymykg1xs81hoeZ) (gcc (GCC) 8.5.0 20210514 (Anolis 8.5.0-10.0.1), GNU ld version 2.30-113.0.1.an8)

#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# redirect test
#
#                     .253 +----+
#                     +----| r1 |
#                     |    +----+
# +----+              |       |.1
# | h1 |--------------+       |   10.1.1.0/30 2001:db8:1::0/126
# +----+ .1           |       |.2
#         172.16.1/24 |    +----+                   +----+
#    2001:db8:16:1/64 +----| r2 |-------------------| h2 |
#                     .254 +----+ .254           .2 +----+
#                                    172.16.2/24
#                                  2001:db8:16:2/64
#
# Route from h1 to h2 goes through r1, eth1 - connection between r1 and r2.
# Route on r1 changed to go to r2 via eth0. This causes a redirect to be sent
# from r1 to h1 telling h1 to use r2 when talking to h2.


-------------------


From 747c14307214b55dbd8250e1ab44cad8305756f1 Mon Sep 17 00:00:00 2001
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 13 Jul 2022 13:48:52 +0200
Subject: [PATCH] ip: fix dflt addr selection for connected nexthop

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
Link: https://lore.kernel.org/r/20220713114853.29406-1-nicolas.dichtel@6wind.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 16dbd5075284..d9fdcbae16ee 100644
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
2.31.1

