Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21221D040
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgGMHLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:11:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44866 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgGMHLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 03:11:54 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5C1546865253C73CC8A3;
        Mon, 13 Jul 2020 15:11:51 +0800 (CST)
Received: from localhost (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 13 Jul 2020
 15:11:42 +0800
From:   Weilong Chen <chenweilong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <edumazet@google.com>, <chenweilong@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] rtnetlink: Fix memory(net_device) leak when ->newlink fails
Date:   Mon, 13 Jul 2020 15:55:28 +0800
Message-ID: <20200713075528.141235-1-chenweilong@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When vlan_newlink call register_vlan_dev fails, it might return error
with dev->reg_state = NETREG_UNREGISTERED. The rtnl_newlink should
free the memory. But currently rtnl_newlink only free the memory which
state is NETREG_UNINITIALIZED.

BUG: memory leak
unreferenced object 0xffff8881051de000 (size 4096):
  comm "syz-executor139", pid 560, jiffies 4294745346 (age 32.445s)
  hex dump (first 32 bytes):
    76 6c 61 6e 32 00 00 00 00 00 00 00 00 00 00 00  vlan2...........
    00 45 28 03 81 88 ff ff 00 00 00 00 00 00 00 00  .E(.............
  backtrace:
    [<0000000047527e31>] kmalloc_node include/linux/slab.h:578 [inline]
    [<0000000047527e31>] kvmalloc_node+0x33/0xd0 mm/util.c:574
    [<000000002b59e3bc>] kvmalloc include/linux/mm.h:753 [inline]
    [<000000002b59e3bc>] kvzalloc include/linux/mm.h:761 [inline]
    [<000000002b59e3bc>] alloc_netdev_mqs+0x83/0xd90 net/core/dev.c:9929
    [<000000006076752a>] rtnl_create_link+0x2c0/0xa20 net/core/rtnetlink.c:3067
    [<00000000572b3be5>] __rtnl_newlink+0xc9c/0x1330 net/core/rtnetlink.c:3329
    [<00000000e84ea553>] rtnl_newlink+0x66/0x90 net/core/rtnetlink.c:3397
    [<0000000052c7c0a9>] rtnetlink_rcv_msg+0x540/0x990 net/core/rtnetlink.c:5460
    [<000000004b5cb379>] netlink_rcv_skb+0x12b/0x3a0 net/netlink/af_netlink.c:2469
    [<00000000c71c20d3>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<00000000c71c20d3>] netlink_unicast+0x4c6/0x690 net/netlink/af_netlink.c:1329
    [<00000000cca72fa9>] netlink_sendmsg+0x735/0xcc0 net/netlink/af_netlink.c:1918
    [<000000009221ebf7>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<000000009221ebf7>] sock_sendmsg+0x109/0x140 net/socket.c:672
    [<000000001c30ffe4>] ____sys_sendmsg+0x5f5/0x780 net/socket.c:2352
    [<00000000b71ca6f3>] ___sys_sendmsg+0x11d/0x1a0 net/socket.c:2406
    [<0000000007297384>] __sys_sendmsg+0xeb/0x1b0 net/socket.c:2439
    [<000000000eb29b11>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
    [<000000006839b4d0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
---
 net/core/rtnetlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9aedc15736ad..85a4b0101f76 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3343,7 +3343,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		 */
 		if (err < 0) {
 			/* If device is not registered at all, free it now */
-			if (dev->reg_state == NETREG_UNINITIALIZED)
+			if (dev->reg_state == NETREG_UNINITIALIZED ||
+			    dev->reg_state == NETREG_UNREGISTERED)
 				free_netdev(dev);
 			goto out;
 		}
-- 
2.17.1

