Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEAA3E41E7
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhHII4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:56:35 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13300 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhHII4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:56:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GjqYv5Nk6z84LP;
        Mon,  9 Aug 2021 16:51:15 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 16:56:11 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 9 Aug 2021
 16:56:11 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     <roopa@nvidia.com>, <nikolay@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH net v2] net: bridge: fix memleak in br_add_if()
Date:   Mon, 9 Aug 2021 17:02:11 +0800
Message-ID: <20210809090211.65677-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a memleak report:

BUG: memory leak
unreferenced object 0x607ee521a658 (size 240):
comm "syz-executor.0", pid 955, jiffies 4294780569 (age 16.449s)
hex dump (first 32 bytes, cpu 1):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<00000000d830ea5a>] br_multicast_add_port+0x1c2/0x300 net/bridge/br_multicast.c:1693
[<00000000274d9a71>] new_nbp net/bridge/br_if.c:435 [inline]
[<00000000274d9a71>] br_add_if+0x670/0x1740 net/bridge/br_if.c:611
[<0000000012ce888e>] do_set_master net/core/rtnetlink.c:2513 [inline]
[<0000000012ce888e>] do_set_master+0x1aa/0x210 net/core/rtnetlink.c:2487
[<0000000099d1cafc>] __rtnl_newlink+0x1095/0x13e0 net/core/rtnetlink.c:3457
[<00000000a01facc0>] rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3488
[<00000000acc9186c>] rtnetlink_rcv_msg+0x369/0xa10 net/core/rtnetlink.c:5550
[<00000000d4aabb9c>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
[<00000000bc2e12a3>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
[<00000000bc2e12a3>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
[<00000000e4dc2d0e>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
[<000000000d22c8b3>] sock_sendmsg_nosec net/socket.c:654 [inline]
[<000000000d22c8b3>] sock_sendmsg+0x139/0x170 net/socket.c:674
[<00000000e281417a>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
[<00000000237aa2ab>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
[<000000004f2dc381>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
[<0000000005feca6c>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
[<000000007304477d>] entry_SYSCALL_64_after_hwframe+0x44/0xae

On error path of br_add_if(), p->mcast_stats allocated in
new_nbp() need be freed, or it will be leaked.

Fixes: 1080ab95e3c7 ("net: bridge: add support for IGMP/MLD stats and export them via netlink")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  move free_percpu(p->mcast_stats) in release_nbp() and
  fix the compile error when CONFIG_BRIDGE_IGMP_SNOOPING
  is disabled.
---
 net/bridge/br_if.c        | 5 ++++-
 net/bridge/br_multicast.c | 1 -
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 6e4a32354a13..c5547772614a 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -250,6 +250,9 @@ static void release_nbp(struct kobject *kobj)
 {
 	struct net_bridge_port *p
 		= container_of(kobj, struct net_bridge_port, kobj);
+#if IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)
+	free_percpu(p->mcast_stats);
+#endif
 	kfree(p);
 }
 
@@ -616,7 +619,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 
 	err = dev_set_allmulti(dev, 1);
 	if (err) {
-		kfree(p);	/* kobject not yet init'd, manually free */
+		release_nbp(&p->kobj);	/* kobject not yet init'd, manually free */
 		goto err1;
 	}
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index d0434dc8c03b..1d3436279d2f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1715,7 +1715,6 @@ void br_multicast_del_port(struct net_bridge_port *port)
 #if IS_ENABLED(CONFIG_IPV6)
 	del_timer_sync(&port->ip6_mc_router_timer);
 #endif
-	free_percpu(port->mcast_stats);
 }
 
 static void br_multicast_enable(struct bridge_mcast_own_query *query)
-- 
2.25.1

