Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9F177851
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgCCOJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:09:00 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41251 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729416AbgCCOI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:08:59 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:08:50 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023E8fBl019613;
        Tue, 3 Mar 2020 16:08:48 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH] Revert "net/mlx5: Support lockless FTE read lookups"
Date:   Tue,  3 Mar 2020 08:08:33 -0600
Message-Id: <20200303140834.7501-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303140834.7501-1-parav@mellanox.com>
References: <20200303140834.7501-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 7dee607ed0e04500459db53001d8e02f8831f084.

During cleanup path, FTE's parent node group is removed which is
referenced by the FTE while freeing the FTE.
Hence FTE's lockless read lookup optimization done in cited commit is
not possible at the moment.

Hence, revert the commit.

This avoid below KAZAN call trace.

[  110.390896] BUG: KASAN: use-after-free in find_root.isra.14+0x56/0x60
[mlx5_core]
[  110.391048] Read of size 4 at addr ffff888c19e6d220 by task
swapper/12/0

[  110.391219] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 5.5.0-rc1+
[  110.391222] Hardware name: HP ProLiant DL380p Gen8, BIOS P70
08/02/2014
[  110.391225] Call Trace:
[  110.391229]  <IRQ>
[  110.391246]  dump_stack+0x95/0xd5
[  110.391307]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391320]  print_address_description.constprop.5+0x20/0x320
[  110.391379]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391435]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391441]  __kasan_report+0x149/0x18c
[  110.391499]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391504]  kasan_report+0x12/0x20
[  110.391511]  __asan_report_load4_noabort+0x14/0x20
[  110.391567]  find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391625]  del_sw_fte_rcu+0x4a/0x100 [mlx5_core]
[  110.391633]  rcu_core+0x404/0x1950
[  110.391640]  ? rcu_accelerate_cbs_unlocked+0x100/0x100
[  110.391649]  ? run_rebalance_domains+0x201/0x280
[  110.391654]  rcu_core_si+0xe/0x10
[  110.391661]  __do_softirq+0x181/0x66c
[  110.391670]  irq_exit+0x12c/0x150
[  110.391675]  smp_apic_timer_interrupt+0xf0/0x370
[  110.391681]  apic_timer_interrupt+0xf/0x20
[  110.391684]  </IRQ>
[  110.391695] RIP: 0010:cpuidle_enter_state+0xfa/0xba0
[  110.391703] Code: 3d c3 9b b5 50 e8 56 75 6e fe 48 89 45 c8 0f 1f 44
00 00 31 ff e8 a6 94 6e fe 45 84 ff 0f 85 f6 02 00 00 fb 66 0f 1f 44 00
00 <45> 85 f6 0f 88 db 06 00 00 4d 63 fe 4b 8d 04 7f 49 8d 04 87 49 8d
[  110.391706] RSP: 0018:ffff888c23a6fce8 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff13
[  110.391712] RAX: dffffc0000000000 RBX: ffffe8ffff7002f8 RCX:
000000000000001f
[  110.391715] RDX: 1ffff11184ee6cb5 RSI: 0000000040277d83 RDI:
ffff888c277365a8
[  110.391718] RBP: ffff888c23a6fd40 R08: 0000000000000002 R09:
0000000000035280
[  110.391721] R10: ffff888c23a6fc80 R11: ffffed11847485d0 R12:
ffffffffb1017740
[  110.391723] R13: 0000000000000003 R14: 0000000000000003 R15:
0000000000000000
[  110.391732]  ? cpuidle_enter_state+0xea/0xba0
[  110.391738]  cpuidle_enter+0x4f/0xa0
[  110.391747]  call_cpuidle+0x6d/0xc0
[  110.391752]  do_idle+0x360/0x430
[  110.391758]  ? arch_cpu_idle_exit+0x40/0x40
[  110.391765]  ? complete+0x67/0x80
[  110.391771]  cpu_startup_entry+0x1d/0x20
[  110.391779]  start_secondary+0x2f3/0x3c0
[  110.391784]  ? set_cpu_sibling_map+0x2500/0x2500
[  110.391795]  secondary_startup_64+0xa4/0xb0

[  110.391841] Allocated by task 290:
[  110.391917]  save_stack+0x21/0x90
[  110.391921]  __kasan_kmalloc.constprop.8+0xa7/0xd0
[  110.391925]  kasan_kmalloc+0x9/0x10
[  110.391929]  kmem_cache_alloc_trace+0xf6/0x270
[  110.391987]  create_root_ns.isra.36+0x58/0x260 [mlx5_core]
[  110.392044]  mlx5_init_fs+0x5fd/0x1ee0 [mlx5_core]
[  110.392092]  mlx5_load_one+0xc7a/0x3860 [mlx5_core]
[  110.392139]  init_one+0x6ff/0xf90 [mlx5_core]
[  110.392145]  local_pci_probe+0xde/0x190
[  110.392150]  work_for_cpu_fn+0x56/0xa0
[  110.392153]  process_one_work+0x678/0x1140
[  110.392157]  worker_thread+0x573/0xba0
[  110.392162]  kthread+0x341/0x400
[  110.392166]  ret_from_fork+0x1f/0x40

[  110.392218] Freed by task 2742:
[  110.392288]  save_stack+0x21/0x90
[  110.392292]  __kasan_slab_free+0x137/0x190
[  110.392296]  kasan_slab_free+0xe/0x10
[  110.392299]  kfree+0x94/0x250
[  110.392357]  tree_put_node+0x257/0x360 [mlx5_core]
[  110.392413]  tree_remove_node+0x63/0xb0 [mlx5_core]
[  110.392469]  clean_tree+0x199/0x240 [mlx5_core]
[  110.392525]  mlx5_cleanup_fs+0x76/0x580 [mlx5_core]
[  110.392572]  mlx5_unload+0x22/0xc0 [mlx5_core]
[  110.392619]  mlx5_unload_one+0x99/0x260 [mlx5_core]
[  110.392666]  remove_one+0x61/0x160 [mlx5_core]
[  110.392671]  pci_device_remove+0x10b/0x2c0
[  110.392677]  device_release_driver_internal+0x1e4/0x490
[  110.392681]  device_driver_detach+0x36/0x40
[  110.392685]  unbind_store+0x147/0x200
[  110.392688]  drv_attr_store+0x6f/0xb0
[  110.392693]  sysfs_kf_write+0x127/0x1d0
[  110.392697]  kernfs_fop_write+0x296/0x420
[  110.392702]  __vfs_write+0x66/0x110
[  110.392707]  vfs_write+0x1a0/0x500
[  110.392711]  ksys_write+0x164/0x250
[  110.392715]  __x64_sys_write+0x73/0xb0
[  110.392720]  do_syscall_64+0x9f/0x3a0
[  110.392725]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

issue: none
Change-Id: I668429961e776a8bd290f3845068f9c7b05ec211
Fixes: 7dee607ed0e0 ("net/mlx5: Support lockless FTE read lookups")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 70 ++++---------------
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  1 -
 2 files changed, 15 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d60577484567..7eadb38fc645 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -531,16 +531,9 @@ static void del_hw_fte(struct fs_node *node)
 	}
 }
 
-static void del_sw_fte_rcu(struct rcu_head *head)
-{
-	struct fs_fte *fte = container_of(head, struct fs_fte, rcu);
-	struct mlx5_flow_steering *steering = get_steering(&fte->node);
-
-	kmem_cache_free(steering->ftes_cache, fte);
-}
-
 static void del_sw_fte(struct fs_node *node)
 {
+	struct mlx5_flow_steering *steering = get_steering(node);
 	struct mlx5_flow_group *fg;
 	struct fs_fte *fte;
 	int err;
@@ -553,8 +546,7 @@ static void del_sw_fte(struct fs_node *node)
 				     rhash_fte);
 	WARN_ON(err);
 	ida_simple_remove(&fg->fte_allocator, fte->index - fg->start_index);
-
-	call_rcu(&fte->rcu, del_sw_fte_rcu);
+	kmem_cache_free(steering->ftes_cache, fte);
 }
 
 static void del_hw_flow_group(struct fs_node *node)
@@ -1633,47 +1625,22 @@ static u64 matched_fgs_get_version(struct list_head *match_head)
 }
 
 static struct fs_fte *
-lookup_fte_for_write_locked(struct mlx5_flow_group *g, const u32 *match_value)
+lookup_fte_locked(struct mlx5_flow_group *g,
+		  const u32 *match_value,
+		  bool take_write)
 {
 	struct fs_fte *fte_tmp;
 
-	nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
-
-	fte_tmp = rhashtable_lookup_fast(&g->ftes_hash, match_value, rhash_fte);
-	if (!fte_tmp || !tree_get_node(&fte_tmp->node)) {
-		fte_tmp = NULL;
-		goto out;
-	}
-
-	if (!fte_tmp->node.active) {
-		tree_put_node(&fte_tmp->node, false);
-		fte_tmp = NULL;
-		goto out;
-	}
-	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
-
-out:
-	up_write_ref_node(&g->node, false);
-	return fte_tmp;
-}
-
-static struct fs_fte *
-lookup_fte_for_read_locked(struct mlx5_flow_group *g, const u32 *match_value)
-{
-	struct fs_fte *fte_tmp;
-
-	if (!tree_get_node(&g->node))
-		return NULL;
-
-	rcu_read_lock();
-	fte_tmp = rhashtable_lookup(&g->ftes_hash, match_value, rhash_fte);
+	if (take_write)
+		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
+	else
+		nested_down_read_ref_node(&g->node, FS_LOCK_PARENT);
+	fte_tmp = rhashtable_lookup_fast(&g->ftes_hash, match_value,
+					 rhash_fte);
 	if (!fte_tmp || !tree_get_node(&fte_tmp->node)) {
-		rcu_read_unlock();
 		fte_tmp = NULL;
 		goto out;
 	}
-	rcu_read_unlock();
-
 	if (!fte_tmp->node.active) {
 		tree_put_node(&fte_tmp->node, false);
 		fte_tmp = NULL;
@@ -1681,19 +1648,12 @@ lookup_fte_for_read_locked(struct mlx5_flow_group *g, const u32 *match_value)
 	}
 
 	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
-
 out:
-	tree_put_node(&g->node, false);
-	return fte_tmp;
-}
-
-static struct fs_fte *
-lookup_fte_locked(struct mlx5_flow_group *g, const u32 *match_value, bool write)
-{
-	if (write)
-		return lookup_fte_for_write_locked(g, match_value);
+	if (take_write)
+		up_write_ref_node(&g->node, false);
 	else
-		return lookup_fte_for_read_locked(g, match_value);
+		up_read_ref_node(&g->node);
+	return fte_tmp;
 }
 
 static struct mlx5_flow_handle *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index e8cd997f413e..c2621b911563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -203,7 +203,6 @@ struct fs_fte {
 	enum fs_fte_status		status;
 	struct mlx5_fc			*counter;
 	struct rhash_head		hash;
-	struct rcu_head	rcu;
 	int				modify_mask;
 };
 
-- 
2.19.2

