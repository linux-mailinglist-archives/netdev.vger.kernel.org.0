Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D29821D9F7
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgGMPUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:20:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36283 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729027AbgGMPUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:20:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 442765C01D6;
        Mon, 13 Jul 2020 11:20:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 13 Jul 2020 11:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=g7oKVZfY2czmOHqAx
        +a5cCEvGVvmrsk2F0hitom5Ygo=; b=pqojH9EA5KEqu3AQjZBJhbIKnCeFqO5Qo
        pvW0RwVY/xL1RHFQo6E3z1agfB8CAlv7LAHBfkv6O74XX8rtPdjhYjg9FjzPISMO
        Agala63Fb3axsnOefTsoun034egIMjikawU+0awBzXWPyBSn+v6oiWhU5rNXcxSj
        lxAe+H7NAIZwgMYbF6B/MNJj0GBfYh4seICjQk8wnV/ER6ikbf2cwIoZmKcUVa12
        slbCC+sl+9rEcvfXVs5bHMLbvIuNKpzqtbNOz+sjm/n1Mj//dqjfjmygRl2ry9Un
        C1fawz/7lXsLRLoQMABcxt44MabRmdlKwMaEkWLVS00pEEIxLN8Xg==
X-ME-Sender: <xms:yHsMX9stwadEiLtXEzSbfGyPjBEK9TTF97oa1XlrRpb0DCvi35TXoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdeltdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetudfhveeltdeftefhueehteeiieejvddtfe
    eiuddukeeitdevgedvveegveeljeenucffohhmrghinhepqhgvmhhurdhorhhgnecukfhp
    pedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yHsMX2dkTXR_I_4DEBnjh6oUO7QFzF-S4Amu8XLa5KM7lvq8W4lBwQ>
    <xmx:yHsMXwyifOWJT6YEBDmRmVIoNaKC_S6XMv5p-qPD7kACb8Ow13n3xw>
    <xmx:yHsMX0Mzm7_e5jtvtD2zc23DTgE2RUTwZ7GKSkrv3Qus7R4OcpUXdQ>
    <xmx:yXsMX5YzJxuTUu7JJDIvLRWttbDyKA1c1JDSuNZuaXK4Q-7RcA-T1g>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 179A5328005E;
        Mon, 13 Jul 2020 11:20:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        moshe@mellanox.com, vladyslavt@mellanox.com, cai@lca.pw,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] devlink: Fix use-after-free when destroying health reporters
Date:   Mon, 13 Jul 2020 18:20:14 +0300
Message-Id: <20200713152014.244936-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Dereferencing the reporter after it was destroyed in order to unlock the
reporters lock results in a use-after-free [1].

Fix this by storing a pointer to the lock in a local variable before
destroying the reporter.

[1]
==================================================================
BUG: KASAN: use-after-free in devlink_health_reporter_destroy+0x15c/0x1b0 net/core/devlink.c:5476
Read of size 8 at addr ffff8880650fd020 by task syz-executor.1/904

CPU: 0 PID: 904 Comm: syz-executor.1 Not tainted 5.8.0-rc2+ #35
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 devlink_health_reporter_destroy+0x15c/0x1b0 net/core/devlink.c:5476
 nsim_dev_health_exit+0x8b/0xe0 drivers/net/netdevsim/health.c:317
 nsim_dev_reload_destroy+0x7f/0x110 drivers/net/netdevsim/dev.c:1134
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:712
 devlink_reload+0xc6/0x3b0 net/core/devlink.c:2952
 devlink_nl_cmd_reload+0x2f1/0x7c0 net/core/devlink.c:2987
 genl_family_rcv_msg_doit net/netlink/genetlink.c:691 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:736 [inline]
 genl_rcv_msg+0x611/0x9d0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:672
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2363
 ___sys_sendmsg+0xff/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4748ad
Code: Bad RIP value.
RSP: 002b:00007fd0358adc38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf00 RCX: 00000000004748ad
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004d1a4b R14: 00007fd0358ae6b4 R15: 00007fd0358add80

Allocated by task 539:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:467
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 __devlink_health_reporter_create+0x91/0x2f0 net/core/devlink.c:5359
 devlink_health_reporter_create+0xa1/0x170 net/core/devlink.c:5431
 nsim_dev_health_init+0x95/0x3a0 drivers/net/netdevsim/health.c:279
 nsim_dev_probe+0xb1e/0xeb0 drivers/net/netdevsim/dev.c:1086
 really_probe+0x287/0x6d0 drivers/base/dd.c:525
 driver_probe_device+0xfe/0x1d0 drivers/base/dd.c:701
 __device_attach_driver+0x21e/0x290 drivers/base/dd.c:807
 bus_for_each_drv+0x161/0x1e0 drivers/base/bus.c:431
 __device_attach+0x21a/0x360 drivers/base/dd.c:873
 bus_probe_device+0x1e6/0x290 drivers/base/bus.c:491
 device_add+0xaf2/0x1b00 drivers/base/core.c:2680
 nsim_bus_dev_new drivers/net/netdevsim/bus.c:336 [inline]
 new_device_store+0x374/0x590 drivers/net/netdevsim/bus.c:215
 bus_attr_store+0x75/0xa0 drivers/base/bus.c:122
 sysfs_kf_write+0x113/0x170 fs/sysfs/file.c:138
 kernfs_fop_write+0x25d/0x480 fs/kernfs/file.c:315
 __vfs_write+0x7c/0x100 fs/read_write.c:495
 vfs_write+0x265/0x5e0 fs/read_write.c:559
 ksys_write+0x12d/0x250 fs/read_write.c:612
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 904:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x12c/0x170 mm/kasan/common.c:455
 slab_free_hook mm/slub.c:1474 [inline]
 slab_free_freelist_hook mm/slub.c:1507 [inline]
 slab_free mm/slub.c:3072 [inline]
 kfree+0xe6/0x320 mm/slub.c:4063
 devlink_health_reporter_free net/core/devlink.c:5449 [inline]
 devlink_health_reporter_put+0xb7/0xf0 net/core/devlink.c:5456
 __devlink_health_reporter_destroy net/core/devlink.c:5463 [inline]
 devlink_health_reporter_destroy+0x11b/0x1b0 net/core/devlink.c:5475
 nsim_dev_health_exit+0x8b/0xe0 drivers/net/netdevsim/health.c:317
 nsim_dev_reload_destroy+0x7f/0x110 drivers/net/netdevsim/dev.c:1134
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:712
 devlink_reload+0xc6/0x3b0 net/core/devlink.c:2952
 devlink_nl_cmd_reload+0x2f1/0x7c0 net/core/devlink.c:2987
 genl_family_rcv_msg_doit net/netlink/genetlink.c:691 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:736 [inline]
 genl_rcv_msg+0x611/0x9d0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:672
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2363
 ___sys_sendmsg+0xff/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880650fd000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 32 bytes inside of
 512-byte region [ffff8880650fd000, ffff8880650fd200)
The buggy address belongs to the page:
page:ffffea0001943f00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880650ff800 head:ffffea0001943f00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0x100000000010200(slab|head)
raw: 0100000000010200 ffffea0001a06a08 ffffea00010ad308 ffff88806c402500
raw: ffff8880650ff800 0000000000100009 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880650fcf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880650fcf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880650fd000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff8880650fd080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880650fd100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Fixes: 3c5584bf0a04 ("devlink: Rework devlink health reporter destructor")
Fixes: 15c724b997a8 ("devlink: Add devlink health port reporters API")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 20a83aace642..6335e1851088 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5471,9 +5471,11 @@ __devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	mutex_lock(&reporter->devlink->reporters_lock);
+	struct mutex *lock = &reporter->devlink->reporters_lock;
+
+	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(&reporter->devlink->reporters_lock);
+	mutex_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
@@ -5485,9 +5487,11 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 void
 devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	mutex_lock(&reporter->devlink_port->reporters_lock);
+	struct mutex *lock = &reporter->devlink_port->reporters_lock;
+
+	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(&reporter->devlink_port->reporters_lock);
+	mutex_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
 
-- 
2.26.2

