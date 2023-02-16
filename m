Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4F5698B13
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjBPDQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBPDQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:16:55 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B773524B;
        Wed, 15 Feb 2023 19:16:54 -0800 (PST)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PHKpz5BKyzrRxZ;
        Thu, 16 Feb 2023 11:16:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 16 Feb
 2023 11:16:52 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net,v2,1/2] ipv6: Add lwtunnel encap size of all siblings in nexthop calculation
Date:   Thu, 16 Feb 2023 12:26:23 +0800
Message-ID: <20230216042624.4069910-2-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230216042624.4069910-1-luwei32@huawei.com>
References: <20230216042624.4069910-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function rt6_nlmsg_size(), the length of nexthop is calculated
by multipling the nexthop length of fib6_info and the number of
siblings. However if the fib6_info has no lwtunnel but the siblings
have lwtunnels, the nexthop length is less than it should be, and
it will trigger a warning in inet6_rt_notify() as follows:

WARNING: CPU: 0 PID: 6082 at net/ipv6/route.c:6180 inet6_rt_notify+0x120/0x130
......
Call Trace:
 <TASK>
 fib6_add_rt2node+0x685/0xa30
 fib6_add+0x96/0x1b0
 ip6_route_add+0x50/0xd0
 inet6_rtm_newroute+0x97/0xa0
 rtnetlink_rcv_msg+0x156/0x3d0
 netlink_rcv_skb+0x5a/0x110
 netlink_unicast+0x246/0x350
 netlink_sendmsg+0x250/0x4c0
 sock_sendmsg+0x66/0x70
 ___sys_sendmsg+0x7c/0xd0
 __sys_sendmsg+0x5d/0xb0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

This bug can be reproduced by script:

ip -6 addr add 2002::2/64 dev ens2
ip -6 route add 100::/64 via 2002::1 dev ens2 metric 100

for i in 10 20 30 40 50 60 70;
do
	ip link add link ens2 name ipv_$i type ipvlan
	ip -6 addr add 2002::$i/64 dev ipv_$i
	ifconfig ipv_$i up
done

for i in 10 20 30 40 50 60;
do
	ip -6 route append 100::/64 encap ip6 dst 2002::$i via 2002::1
dev ipv_$i metric 100
done

ip -6 route append 100::/64 via 2002::1 dev ipv_70 metric 100

This patch fixes it by adding nexthop_len of every siblings using
rt6_nh_nlmsg_size().

Fixes: beb1afac518d ("net: ipv6: Add support to dump multipath routes via RTA_MULTIPATH attribute")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ipv6/route.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e74e0361fd92..a6983a13dd20 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5540,16 +5540,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
 		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
 					 &nexthop_len);
 	} else {
+		struct fib6_info *sibling, *next_sibling;
 		struct fib6_nh *nh = f6i->fib6_nh;
 
 		nexthop_len = 0;
 		if (f6i->fib6_nsiblings) {
-			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
-				    + NLA_ALIGN(sizeof(struct rtnexthop))
-				    + nla_total_size(16) /* RTA_GATEWAY */
-				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
+			rt6_nh_nlmsg_size(nh, &nexthop_len);
 
-			nexthop_len *= f6i->fib6_nsiblings;
+			list_for_each_entry_safe(sibling, next_sibling,
+						 &f6i->fib6_siblings, fib6_siblings) {
+				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
+			}
 		}
 		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
 	}
-- 
2.31.1

