Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D4E2CA4A7
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403790AbgLAN5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:57:47 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9084 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391327AbgLAN5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:57:46 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ClkCx2B1qzLxnp;
        Tue,  1 Dec 2020 21:56:29 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 21:56:52 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <toshiaki.makita1@gmail.com>, <rkovhaev@gmail.com>,
        <stephen@networkplumber.org>, <Jason@zx2c4.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH net v3] net: fix memory leak in register_netdevice() on error path
Date:   Tue, 1 Dec 2020 21:54:57 +0800
Message-ID: <20201201135457.3549435-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a memleak report when doing fault-inject test:

unreferenced object 0xffff88810ace9000 (size 1024):
  comm "ip", pid 4622, jiffies 4295457037 (age 43.378s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000008abe41>] __kmalloc+0x10f/0x210
    [<000000005d3533a6>] veth_dev_init+0x140/0x310
    [<0000000088353c64>] register_netdevice+0x496/0x7a0
    [<000000001324d322>] veth_newlink+0x40b/0x960
    [<00000000d0799866>] __rtnl_newlink+0xd8c/0x1360
    [<00000000d616040a>] rtnl_newlink+0x6b/0xa0
    [<00000000e0a1600d>] rtnetlink_rcv_msg+0x3cc/0x9e0
    [<000000009eeff98b>] netlink_rcv_skb+0x130/0x3a0
    [<00000000500f8be1>] netlink_unicast+0x4da/0x700
    [<00000000666c03b3>] netlink_sendmsg+0x7fe/0xcb0
    [<0000000073b28103>] sock_sendmsg+0x143/0x180
    [<00000000ad746a30>] ____sys_sendmsg+0x677/0x810
    [<0000000087dd98e5>] ___sys_sendmsg+0x105/0x180
    [<00000000028dd365>] __sys_sendmsg+0xf0/0x1c0
    [<00000000a6bfbae6>] do_syscall_64+0x33/0x40
    [<00000000e00521b4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

It seems ifb and loopback may also hit the leak, so I try to fix this in
register_netdevice().

In common case, priv_destructor() will be called in netdev_run_todo()
after calling ndo_uninit() in rollback_registered(), on other error
path in register_netdevice(), ndo_uninit() and priv_destructor() are
called before register_netdevice() return, but in this case,
priv_destructor() will never be called, then it causes memory leak,
so we should call priv_destructor() here.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2 -> v3: In wireguard driver, priv_destructor() will call
free_netdev(), but it is assigned after register_netdevice(),
so it will not lead a double free, drop patch#1. Also I've
test wireguard device, it's no memory leak on this error path.
---
 net/core/dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..51b9cf1ff6a1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10003,6 +10003,16 @@ int register_netdevice(struct net_device *dev)
 		rcu_barrier();
 
 		dev->reg_state = NETREG_UNREGISTERED;
+		/* In common case, priv_destructor() will be
+		 * called in netdev_run_todo() after calling
+		 * ndo_uninit() in rollback_registered().
+		 * But in this case, priv_destructor() will
+		 * never be called, then it causes memory
+		 * leak, so we should call priv_destructor()
+		 * here.
+		 */
+		if (dev->priv_destructor)
+			dev->priv_destructor(dev);
 		/* We should put the kobject that hold in
 		 * netdev_unregister_kobject(), otherwise
 		 * the net device cannot be freed when
-- 
2.25.1

