Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874542CA49E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391467AbgLAN4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:56:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8487 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388215AbgLAN4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:56:18 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ClkBX1XnPzhlLV;
        Tue,  1 Dec 2020 21:55:16 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 21:55:31 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <roopa@nvidia.com>, <nikolay@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: bridge: Fix a warning when del bridge sysfs
Date:   Tue, 1 Dec 2020 22:01:14 +0800
Message-ID: <20201201140114.67455-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If adding bridge sysfs fails, br->ifobj will be NULL, there is no
need to delete its non-existent sysfs when deleting the bridge device,
otherwise, it will cause a warning. So, when br->ifobj == NULL,
directly return can fix this bug.

br_sysfs_addbr: can't create group bridge4/bridge
------------[ cut here ]------------
sysfs group 'bridge' not found for kobject 'bridge4'
WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
Modules linked in: iptable_nat
...
Call Trace:
  br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
  br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
  br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
  __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
  rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
  netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
  netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
  netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg+0x139/0x170 net/socket.c:671
  ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
  ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
  __sys_sendmsg+0xd3/0x190 net/socket.c:2440
  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/bridge/br_sysfs_br.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 7db06e3f642a..1e9cbf31d904 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -991,6 +991,9 @@ void br_sysfs_delbr(struct net_device *dev)
 	struct kobject *kobj = &dev->dev.kobj;
 	struct net_bridge *br = netdev_priv(dev);
 
+	if (!br->ifobj)
+		return;
+
 	kobject_put(br->ifobj);
 	sysfs_remove_bin_file(kobj, &bridge_forward);
 	sysfs_remove_group(kobj, &bridge_group);
-- 
2.17.1

