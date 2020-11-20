Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01B2BA63E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgKTJco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:32:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7660 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgKTJcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:32:43 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcrtJ4lbnz15LdN;
        Fri, 20 Nov 2020 17:32:24 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Nov 2020
 17:32:36 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: [PATCH] veth: fix memleak in veth_newlink()
Date:   Fri, 20 Nov 2020 17:30:57 +0800
Message-ID: <20201120093057.1477009-1-yangyingliang@huawei.com>
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

If call_netdevice_notifiers() failed in register_netdevice(),
dev->priv_destructor() is not called, it will cause memleak.
Fix this by assigning ndo_uninit with veth_dev_free(), so
the memory can be freed in rollback_registered();

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c737668008a..537d9a60028a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1217,6 +1217,7 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
+	.ndo_uninit          = veth_dev_free,
 	.ndo_open            = veth_open,
 	.ndo_stop            = veth_close,
 	.ndo_start_xmit      = veth_xmit,
@@ -1260,7 +1261,6 @@ static void veth_setup(struct net_device *dev)
 			       NETIF_F_HW_VLAN_CTAG_RX |
 			       NETIF_F_HW_VLAN_STAG_RX);
 	dev->needs_free_netdev = true;
-	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
 
 	dev->hw_features = VETH_FEATURES;
-- 
2.17.1

