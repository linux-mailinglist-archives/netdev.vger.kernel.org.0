Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B339231C12
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgG2J1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39047 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726737AbgG2J1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 889DB5C00D0;
        Wed, 29 Jul 2020 05:27:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cyN9i/QzfD1V8XqDOiDpP8E+9KN8QpEeixR6YCHZafY=; b=lDwBvX4Y
        vvRaVWePL93Qnp4PjUVl8+ufuJmNhZ3VXdQ7lsfbDV01sg9boaKaLX1XadE1KTRr
        wiyRcFDvAp4lJAN8LIb0elASL5NwCJxGHrYFl48tb+VB8mZ0OPeUz1JhMYTSk+CZ
        KpY4hqrLh9Sv+u1kV4ltQhk1n1K7NHOKKo6XfHJ9wfC/9slXjF6/gKrTKmr1s689
        vCwKgjfglhCKPefTeV0cRmpKyS1xotBrGwktc9VIN8Y2TBxyQbJpzpWD7aCdJFrA
        KPZDz5KLvLxQhwibY6YWq+CxM7lENRtGHVaMevyoTZ/kENMyNH93oKoKpzeCZ5f/
        ihF+zKq/mQ5Dxg==
X-ME-Sender: <xms:AUEhX2-0qqrWIRu_lTWfQhjtQrGa7a67-0Jgx_t5diBWh8QSeN9Hkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeefteeijedugfejheffffeigeeijeehke
    eltdfgudevgfefieekgefhffetgeduudenucffohhmrghinhepqhgvmhhurdhorhhgnecu
    kfhppedutdelrdeihedrudefjedrvdehtdenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AUEhX2upFOnxuVoOVvc_CwWMteStkvXt7VjdcZ4gN267Zt7Pm1uesQ>
    <xmx:AUEhX8CcBr53n7najTWjKiHod7mKL6IqjPF8IW2RYT0e3axnWDPZ-g>
    <xmx:AUEhX-epiB912Kf87MTgMOHuHTDMRbKjQznr5Cx6er8ky93DaLufkw>
    <xmx:AUEhX0rpZ9TNhVlf4exki5B58pWUJBAV6IjiTL1MHcBLsWxHKhIf7w>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CE3C3280059;
        Wed, 29 Jul 2020 05:27:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 5/6] mlxsw: spectrum_router: Fix use-after-free in router init / de-init
Date:   Wed, 29 Jul 2020 12:26:47 +0300
Message-Id: <20200729092648.2055488-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Several notifiers are registered as part of router initialization.
Since some of these notifiers are registered before the end of the
initialization, it is possible for them to access uninitialized or freed
memory when processing notifications [1].

Additionally, some of these notifiers queue work items on a workqueue.
If these work items are executed after the router was de-initialized,
they will access freed memory.

Fix both problems by moving the registration of the notifiers to the end
of the router initialization and flush the work queue after they are
unregistered.

[1]
BUG: KASAN: use-after-free in __mutex_lock_common kernel/locking/mutex.c:938 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0xeea/0x1340 kernel/locking/mutex.c:1103
Read of size 8 at addr ffff888038c3a6e0 by task kworker/u4:1/61

CPU: 1 PID: 61 Comm: kworker/u4:1 Not tainted 5.8.0-rc2+ #36
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: mlxsw_core_ordered mlxsw_sp_inet6addr_event_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __mutex_lock_common kernel/locking/mutex.c:938 [inline]
 __mutex_lock+0xeea/0x1340 kernel/locking/mutex.c:1103
 mlxsw_sp_inet6addr_event_work+0xb3/0x1b0 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:7123
 process_one_work+0xa3e/0x17a0 kernel/workqueue.c:2269
 worker_thread+0x9e/0x1050 kernel/workqueue.c:2415
 kthread+0x355/0x470 kernel/kthread.c:291
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 1298:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:467
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 mlxsw_sp_router_init+0xb2/0x1d20 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:8074
 mlxsw_sp_init+0xbd8/0x3ac0 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:2932
 __mlxsw_core_bus_device_register+0x657/0x10d0 drivers/net/ethernet/mellanox/mlxsw/core.c:1375
 mlxsw_core_bus_device_register drivers/net/ethernet/mellanox/mlxsw/core.c:1436 [inline]
 mlxsw_devlink_core_bus_device_reload_up+0xcd/0x150 drivers/net/ethernet/mellanox/mlxsw/core.c:1133
 devlink_reload net/core/devlink.c:2959 [inline]
 devlink_reload+0x281/0x3b0 net/core/devlink.c:2944
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

Freed by task 1348:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x12c/0x170 mm/kasan/common.c:455
 slab_free_hook mm/slub.c:1474 [inline]
 slab_free_freelist_hook mm/slub.c:1507 [inline]
 slab_free mm/slub.c:3072 [inline]
 kfree+0xe6/0x320 mm/slub.c:4063
 mlxsw_sp_fini+0x340/0x4e0 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3132
 mlxsw_core_bus_device_unregister+0x16c/0x6d0 drivers/net/ethernet/mellanox/mlxsw/core.c:1474
 mlxsw_devlink_core_bus_device_reload_down+0x8e/0xc0 drivers/net/ethernet/mellanox/mlxsw/core.c:1123
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

The buggy address belongs to the object at ffff888038c3a000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1760 bytes inside of
 2048-byte region [ffff888038c3a000, ffff888038c3a800)
The buggy address belongs to the page:
page:ffffea0000e30e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0000e30e00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x100000000010200(slab|head)
raw: 0100000000010200 dead000000000100 dead000000000122 ffff88806c40c000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888038c3a580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888038c3a600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888038c3a680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888038c3a700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888038c3a780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 965fa8e600d2 ("mlxsw: spectrum_router: Make RIF deletion more robust")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 50 ++++++++++---------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index bd4803074776..0521e9d48c45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8069,16 +8069,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp->router = router;
 	router->mlxsw_sp = mlxsw_sp;
 
-	router->inetaddr_nb.notifier_call = mlxsw_sp_inetaddr_event;
-	err = register_inetaddr_notifier(&router->inetaddr_nb);
-	if (err)
-		goto err_register_inetaddr_notifier;
-
-	router->inet6addr_nb.notifier_call = mlxsw_sp_inet6addr_event;
-	err = register_inet6addr_notifier(&router->inet6addr_nb);
-	if (err)
-		goto err_register_inet6addr_notifier;
-
 	INIT_LIST_HEAD(&mlxsw_sp->router->nexthop_neighs_list);
 	err = __mlxsw_sp_router_init(mlxsw_sp);
 	if (err)
@@ -8119,12 +8109,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_neigh_init;
 
-	mlxsw_sp->router->netevent_nb.notifier_call =
-		mlxsw_sp_router_netevent_event;
-	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
-	if (err)
-		goto err_register_netevent_notifier;
-
 	err = mlxsw_sp_mp_hash_init(mlxsw_sp);
 	if (err)
 		goto err_mp_hash_init;
@@ -8133,6 +8117,22 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_dscp_init;
 
+	router->inetaddr_nb.notifier_call = mlxsw_sp_inetaddr_event;
+	err = register_inetaddr_notifier(&router->inetaddr_nb);
+	if (err)
+		goto err_register_inetaddr_notifier;
+
+	router->inet6addr_nb.notifier_call = mlxsw_sp_inet6addr_event;
+	err = register_inet6addr_notifier(&router->inet6addr_nb);
+	if (err)
+		goto err_register_inet6addr_notifier;
+
+	mlxsw_sp->router->netevent_nb.notifier_call =
+		mlxsw_sp_router_netevent_event;
+	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
+	if (err)
+		goto err_register_netevent_notifier;
+
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
 	err = register_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &mlxsw_sp->router->fib_nb,
@@ -8143,10 +8143,15 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_register_fib_notifier:
-err_dscp_init:
-err_mp_hash_init:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
+	unregister_inet6addr_notifier(&router->inet6addr_nb);
+err_register_inet6addr_notifier:
+	unregister_inetaddr_notifier(&router->inetaddr_nb);
+err_register_inetaddr_notifier:
+	mlxsw_core_flush_owq();
+err_dscp_init:
+err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
 	mlxsw_sp_vrs_fini(mlxsw_sp);
@@ -8165,10 +8170,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_rifs_init:
 	__mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
-	unregister_inet6addr_notifier(&router->inet6addr_nb);
-err_register_inet6addr_notifier:
-	unregister_inetaddr_notifier(&router->inetaddr_nb);
-err_register_inetaddr_notifier:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 	return err;
@@ -8179,6 +8180,9 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				&mlxsw_sp->router->fib_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
+	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
+	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
+	mlxsw_core_flush_owq();
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
@@ -8188,8 +8192,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_ipips_fini(mlxsw_sp);
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
-	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
-	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
-- 
2.26.2

