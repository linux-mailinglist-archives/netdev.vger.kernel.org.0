Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBFA145B5F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgAVSKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:10:20 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36395 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgAVSKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:10:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E1C9C220EB;
        Wed, 22 Jan 2020 13:10:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 22 Jan 2020 13:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xPYsiTLag6zXqIah4
        aHgQWRJt2QFp3rWNv7fCh1ywUY=; b=Sl/1WEqLNNuON5oXlGrlZTEeJqN7AV1EI
        sF9DOYoL0vmhFKap59ZewovTRSRytuy7bmauWB/AqVgC64GsNhm69/UL4edatowD
        spqmwUNbWxQyAbJJhLqsOn0o6hoTsh+m5Nxat6i64qC/hJlY9gmJ60Uwbj7tJ9bT
        pxXzb02oZI6GeLv/pmFVrjnR3teHgUcGSFkYiDg2uKxFBVWWwjGDj6YDDfiMpIE+
        dmNSU4twC+5r79xsgvzFu6jJ++DRh5oO3m/SiExnPh4CmtsP0ZTsFqL0sGnEm4vT
        yWKhYaXqu53ZRZo2hO3lAqIXDpuvSE2Dwx5IbwYiJCfwRXtPeVDdA==
X-ME-Sender: <xms:CpAoXuXq0OArA-Ou901UFK1QHZPDJC999RFpDRWYj75yp-LOshRrCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvddtgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:CpAoXluoMC2Nmoa4foB62Tm14DhRyqykpHMrdIU5d8L5GtPEaAohEQ>
    <xmx:CpAoXpRUU1NebjY7NlMY_EhxqAH7raHEDDGWsVAGKvt_7NWejETKOQ>
    <xmx:CpAoXqopa3qwjlQhQzYDwYT5iiHHYkQuhFlm7je8NDRp79V0Rd6_QQ>
    <xmx:CpAoXlEBexzkVCLkRtYFgrxLUsC3yxdGv-tc5LfbyjFc-0SYFA7WgQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE08A30602DE;
        Wed, 22 Jan 2020 13:10:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_acl: Fix use-after-free during reload
Date:   Wed, 22 Jan 2020 20:09:52 +0200
Message-Id: <20200122180952.262582-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

During reload (or module unload), the router block is de-initialized.
Among other things, this results in the removal of a default multicast
route from each active virtual router (VRF). These default routes are
configured during initialization to trap packets to the CPU. In
Spectrum-2, unlike Spectrum-1, multicast routes are implemented using
ACL rules.

Since the router block is de-initialized before the ACL block, it is
possible that the ACL rules corresponding to the default routes are
deleted while being accessed by the ACL delayed work that queries rules'
activity from the device. This can result in a rare use-after-free [1].

Fix this by protecting the rules list accessed by the delayed work with
a lock. We cannot use a spinlock as the activity read operation is
blocking.

[1]
[  123.331662] ==================================================================
[  123.339920] BUG: KASAN: use-after-free in mlxsw_sp_acl_rule_activity_update_work+0x330/0x3b0
[  123.349381] Read of size 8 at addr ffff8881f3bb4520 by task kworker/0:2/78
[  123.357080]
[  123.358773] CPU: 0 PID: 78 Comm: kworker/0:2 Not tainted 5.5.0-rc5-custom-33108-gf5df95d3ef41 #2209
[  123.368898] Hardware name: Mellanox Technologies Ltd. MSN3700C/VMOD0008, BIOS 5.11 10/10/2018
[  123.378456] Workqueue: mlxsw_core mlxsw_sp_acl_rule_activity_update_work
[  123.385970] Call Trace:
[  123.388734]  dump_stack+0xc6/0x11e
[  123.392568]  print_address_description.constprop.4+0x21/0x340
[  123.403236]  __kasan_report.cold.8+0x76/0xb1
[  123.414884]  kasan_report+0xe/0x20
[  123.418716]  mlxsw_sp_acl_rule_activity_update_work+0x330/0x3b0
[  123.444034]  process_one_work+0xb06/0x19a0
[  123.453731]  worker_thread+0x91/0xe90
[  123.467348]  kthread+0x348/0x410
[  123.476847]  ret_from_fork+0x24/0x30
[  123.480863]
[  123.482545] Allocated by task 73:
[  123.486273]  save_stack+0x19/0x80
[  123.490000]  __kasan_kmalloc.constprop.6+0xc1/0xd0
[  123.495379]  mlxsw_sp_acl_rule_create+0xa7/0x230
[  123.500566]  mlxsw_sp2_mr_tcam_route_create+0xf6/0x3e0
[  123.506334]  mlxsw_sp_mr_tcam_route_create+0x5b4/0x820
[  123.512102]  mlxsw_sp_mr_table_create+0x3b5/0x690
[  123.517389]  mlxsw_sp_vr_get+0x289/0x4d0
[  123.521797]  mlxsw_sp_fib_node_get+0xa2/0x990
[  123.526692]  mlxsw_sp_router_fib4_event_work+0x54c/0x2d60
[  123.532752]  process_one_work+0xb06/0x19a0
[  123.537352]  worker_thread+0x91/0xe90
[  123.541471]  kthread+0x348/0x410
[  123.545103]  ret_from_fork+0x24/0x30
[  123.549113]
[  123.550795] Freed by task 518:
[  123.554231]  save_stack+0x19/0x80
[  123.557958]  __kasan_slab_free+0x125/0x170
[  123.562556]  kfree+0xd7/0x3a0
[  123.565895]  mlxsw_sp_acl_rule_destroy+0x63/0xd0
[  123.571081]  mlxsw_sp2_mr_tcam_route_destroy+0xd5/0x130
[  123.576946]  mlxsw_sp_mr_tcam_route_destroy+0xba/0x260
[  123.582714]  mlxsw_sp_mr_table_destroy+0x1ab/0x290
[  123.588091]  mlxsw_sp_vr_put+0x1db/0x350
[  123.592496]  mlxsw_sp_fib_node_put+0x298/0x4c0
[  123.597486]  mlxsw_sp_vr_fib_flush+0x15b/0x360
[  123.602476]  mlxsw_sp_router_fib_flush+0xba/0x470
[  123.607756]  mlxsw_sp_vrs_fini+0xaa/0x120
[  123.612260]  mlxsw_sp_router_fini+0x137/0x384
[  123.617152]  mlxsw_sp_fini+0x30a/0x4a0
[  123.621374]  mlxsw_core_bus_device_unregister+0x159/0x600
[  123.627435]  mlxsw_devlink_core_bus_device_reload_down+0x7e/0xb0
[  123.634176]  devlink_reload+0xb4/0x380
[  123.638391]  devlink_nl_cmd_reload+0x610/0x700
[  123.643382]  genl_rcv_msg+0x6a8/0xdc0
[  123.647497]  netlink_rcv_skb+0x134/0x3a0
[  123.651904]  genl_rcv+0x29/0x40
[  123.655436]  netlink_unicast+0x4d4/0x700
[  123.659843]  netlink_sendmsg+0x7c0/0xc70
[  123.664251]  __sys_sendto+0x265/0x3c0
[  123.668367]  __x64_sys_sendto+0xe2/0x1b0
[  123.672773]  do_syscall_64+0xa0/0x530
[  123.676892]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  123.682552]
[  123.684238] The buggy address belongs to the object at ffff8881f3bb4500
[  123.684238]  which belongs to the cache kmalloc-128 of size 128
[  123.698261] The buggy address is located 32 bytes inside of
[  123.698261]  128-byte region [ffff8881f3bb4500, ffff8881f3bb4580)
[  123.711303] The buggy address belongs to the page:
[  123.716682] page:ffffea0007ceed00 refcount:1 mapcount:0 mapping:ffff888236403500 index:0x0
[  123.725958] raw: 0200000000000200 dead000000000100 dead000000000122 ffff888236403500
[  123.734646] raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
[  123.743315] page dumped because: kasan: bad access detected
[  123.749562]
[  123.751241] Memory state around the buggy address:
[  123.756620]  ffff8881f3bb4400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  123.764716]  ffff8881f3bb4480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  123.772812] >ffff8881f3bb4500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  123.780904]                                ^
[  123.785697]  ffff8881f3bb4580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  123.793793]  ffff8881f3bb4600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  123.801883] ==================================================================

Fixes: cf7221a4f5a5 ("mlxsw: spectrum_router: Add Multicast routing support for Spectrum-2")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_acl.c   | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 150b3a144b83..3d3cca596116 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -8,6 +8,7 @@
 #include <linux/string.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/mutex.h>
 #include <net/net_namespace.h>
 #include <net/tc_act/tc_vlan.h>
 
@@ -25,6 +26,7 @@ struct mlxsw_sp_acl {
 	struct mlxsw_sp_fid *dummy_fid;
 	struct rhashtable ruleset_ht;
 	struct list_head rules;
+	struct mutex rules_lock; /* Protects rules list */
 	struct {
 		struct delayed_work dw;
 		unsigned long interval;	/* ms */
@@ -701,7 +703,9 @@ int mlxsw_sp_acl_rule_add(struct mlxsw_sp *mlxsw_sp,
 			goto err_ruleset_block_bind;
 	}
 
+	mutex_lock(&mlxsw_sp->acl->rules_lock);
 	list_add_tail(&rule->list, &mlxsw_sp->acl->rules);
+	mutex_unlock(&mlxsw_sp->acl->rules_lock);
 	block->rule_count++;
 	block->egress_blocker_rule_count += rule->rulei->egress_bind_blocker;
 	return 0;
@@ -723,7 +727,9 @@ void mlxsw_sp_acl_rule_del(struct mlxsw_sp *mlxsw_sp,
 
 	block->egress_blocker_rule_count -= rule->rulei->egress_bind_blocker;
 	ruleset->ht_key.block->rule_count--;
+	mutex_lock(&mlxsw_sp->acl->rules_lock);
 	list_del(&rule->list);
+	mutex_unlock(&mlxsw_sp->acl->rules_lock);
 	if (!ruleset->ht_key.chain_index &&
 	    mlxsw_sp_acl_ruleset_is_singular(ruleset))
 		mlxsw_sp_acl_ruleset_block_unbind(mlxsw_sp, ruleset,
@@ -783,19 +789,18 @@ static int mlxsw_sp_acl_rules_activity_update(struct mlxsw_sp_acl *acl)
 	struct mlxsw_sp_acl_rule *rule;
 	int err;
 
-	/* Protect internal structures from changes */
-	rtnl_lock();
+	mutex_lock(&acl->rules_lock);
 	list_for_each_entry(rule, &acl->rules, list) {
 		err = mlxsw_sp_acl_rule_activity_update(acl->mlxsw_sp,
 							rule);
 		if (err)
 			goto err_rule_update;
 	}
-	rtnl_unlock();
+	mutex_unlock(&acl->rules_lock);
 	return 0;
 
 err_rule_update:
-	rtnl_unlock();
+	mutex_unlock(&acl->rules_lock);
 	return err;
 }
 
@@ -880,6 +885,7 @@ int mlxsw_sp_acl_init(struct mlxsw_sp *mlxsw_sp)
 	acl->dummy_fid = fid;
 
 	INIT_LIST_HEAD(&acl->rules);
+	mutex_init(&acl->rules_lock);
 	err = mlxsw_sp_acl_tcam_init(mlxsw_sp, &acl->tcam);
 	if (err)
 		goto err_acl_ops_init;
@@ -892,6 +898,7 @@ int mlxsw_sp_acl_init(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 
 err_acl_ops_init:
+	mutex_destroy(&acl->rules_lock);
 	mlxsw_sp_fid_put(fid);
 err_fid_get:
 	rhashtable_destroy(&acl->ruleset_ht);
@@ -908,6 +915,7 @@ void mlxsw_sp_acl_fini(struct mlxsw_sp *mlxsw_sp)
 
 	cancel_delayed_work_sync(&mlxsw_sp->acl->rule_activity_update.dw);
 	mlxsw_sp_acl_tcam_fini(mlxsw_sp, &acl->tcam);
+	mutex_destroy(&acl->rules_lock);
 	WARN_ON(!list_empty(&acl->rules));
 	mlxsw_sp_fid_put(acl->dummy_fid);
 	rhashtable_destroy(&acl->ruleset_ht);
-- 
2.24.1

