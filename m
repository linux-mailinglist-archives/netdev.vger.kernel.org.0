Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D292C553C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389955AbgKZNZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:25:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7739 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389760AbgKZNZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:25:32 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ChdlY68ChzkftB;
        Thu, 26 Nov 2020 21:24:41 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 26 Nov 2020
 21:25:02 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <toshiaki.makita1@gmail.com>, <rkovhaev@gmail.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH net] net: fix memory leak in register_netdevice() on error path
Date:   Thu, 26 Nov 2020 21:23:12 +0800
Message-ID: <20201126132312.3593725-1-yangyingliang@huawei.com>
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
 net/core/dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..907204395b64 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10000,6 +10000,17 @@ int register_netdevice(struct net_device *dev)
 	ret = notifier_to_errno(ret);
 	if (ret) {
 		rollback_registered(dev);
+		/*
+		 * In common case, priv_destructor() will be
+		 * called in netdev_run_todo() after calling
+		 * ndo_uninit() in rollback_registered().
+		 * But in this case, priv_destructor() will
+		 * never be called, then it causes memory
+		 * leak, so we should call priv_destructor()
+		 * here.
+		 */
+		if (dev->priv_destructor)
+			dev->priv_destructor(dev);
 		rcu_barrier();
 
 		dev->reg_state = NETREG_UNREGISTERED;
-- 
2.25.1

