Return-Path: <netdev+bounces-11577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F13733A58
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7275F1C21039
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785AD20696;
	Fri, 16 Jun 2023 20:01:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C1200D6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D1FC433AD;
	Fri, 16 Jun 2023 20:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945692;
	bh=nKfOG4ApfZRdTnERFh80h2cs+vexmhhTsxLcQ6Lio18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kqz52GIM4kw/OC9Ibe0Sd76+SXgNh1TUr/LIRET/I0kQJQ8fx5E+TRd7iH52PAtdx
	 XB2Tz8/hUDG9pptuUOKCSt3cS9rnDhFET9SAv1xopvvnQZ2XwejkpD4dGjBOTWAORE
	 PLyyUumy/7qefpZr+ruK1+Sjef08qSxK14s/ovNtzw98XVnmAaVonMK285Gix1H0HZ
	 GRbWVUDulAFUA9CyuUt9E8i73/8hHjHcAPISb7A7Q9r1ykHR3ulrI6fF14HhyHrdxB
	 wsxkFR9tqVm2xRhdMiJ1ou0Sxl3gqzSNnicU/j4rcvC62//C2tOOeaHVbuIgUH/hDQ
	 A/1eXUWeGsNKQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net 08/12] net/mlx5: Free IRQ rmap and notifier on kernel shutdown
Date: Fri, 16 Jun 2023 13:01:15 -0700
Message-Id: <20230616200119.44163-9-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

The kernel IRQ system needs the irq affinity notifier to be clear
before attempting to free the irq, see WARN_ON log below.

On a normal driver unload we don't have this issue since we do the
complete cleanup of the irq resources.

To fix this, put the important resources cleanup in a helper function
and use it in both normal driver unload and shutdown flows.

[ 4497.498434] ------------[ cut here ]------------
[ 4497.498726] WARNING: CPU: 0 PID: 9 at kernel/irq/manage.c:2034 free_irq+0x295/0x340
[ 4497.499193] Modules linked in:
[ 4497.499386] CPU: 0 PID: 9 Comm: kworker/0:1 Tainted: G        W          6.4.0-rc4+ #10
[ 4497.499876] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
[ 4497.500518] Workqueue: events do_poweroff
[ 4497.500849] RIP: 0010:free_irq+0x295/0x340
[ 4497.501132] Code: 85 c0 0f 84 1d ff ff ff 48 89 ef ff d0 0f 1f 00 e9 10 ff ff ff 0f 0b e9 72 ff ff ff 49 8d 7f 28 ff d0 0f 1f 00 e9 df fd ff ff <0f> 0b 48 c7 80 c0 008
[ 4497.502269] RSP: 0018:ffffc90000053da0 EFLAGS: 00010282
[ 4497.502589] RAX: ffff888100949600 RBX: ffff88810330b948 RCX: 0000000000000000
[ 4497.503035] RDX: ffff888100949600 RSI: ffff888100400490 RDI: 0000000000000023
[ 4497.503472] RBP: ffff88810330c7e0 R08: ffff8881004005d0 R09: ffffffff8273a260
[ 4497.503923] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881009ae000
[ 4497.504359] R13: ffff8881009ae148 R14: 0000000000000000 R15: ffff888100949600
[ 4497.504804] FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[ 4497.505302] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4497.505671] CR2: 00007fce98806298 CR3: 000000000262e005 CR4: 0000000000370ef0
[ 4497.506104] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4497.506540] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4497.507002] Call Trace:
[ 4497.507158]  <TASK>
[ 4497.507299]  ? free_irq+0x295/0x340
[ 4497.507522]  ? __warn+0x7c/0x130
[ 4497.507740]  ? free_irq+0x295/0x340
[ 4497.507963]  ? report_bug+0x171/0x1a0
[ 4497.508197]  ? handle_bug+0x3c/0x70
[ 4497.508417]  ? exc_invalid_op+0x17/0x70
[ 4497.508662]  ? asm_exc_invalid_op+0x1a/0x20
[ 4497.508926]  ? free_irq+0x295/0x340
[ 4497.509146]  mlx5_irq_pool_free_irqs+0x48/0x90
[ 4497.509421]  mlx5_irq_table_free_irqs+0x38/0x50
[ 4497.509714]  mlx5_core_eq_free_irqs+0x27/0x40
[ 4497.509984]  shutdown+0x7b/0x100
[ 4497.510184]  pci_device_shutdown+0x30/0x60
[ 4497.510440]  device_shutdown+0x14d/0x240
[ 4497.510698]  kernel_power_off+0x30/0x70
[ 4497.510938]  process_one_work+0x1e6/0x3e0
[ 4497.511183]  worker_thread+0x49/0x3b0
[ 4497.511407]  ? __pfx_worker_thread+0x10/0x10
[ 4497.511679]  kthread+0xe0/0x110
[ 4497.511879]  ? __pfx_kthread+0x10/0x10
[ 4497.512114]  ret_from_fork+0x29/0x50
[ 4497.512342]  </TASK>

Fixes: 9c2d08010963 ("net/mlx5: Free irqs only on shutdown callback")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 25 ++++++++++++++++---
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 33b9359de53d..98412bd5a696 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -126,14 +126,22 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	return ret;
 }
 
-static void irq_release(struct mlx5_irq *irq)
+/* mlx5_system_free_irq - Free an IRQ
+ * @irq: IRQ to free
+ *
+ * Free the IRQ and other resources such as rmap from the system.
+ * BUT doesn't free or remove reference from mlx5.
+ * This function is very important for the shutdown flow, where we need to
+ * cleanup system resoruces but keep mlx5 objects alive,
+ * see mlx5_irq_table_free_irqs().
+ */
+static void mlx5_system_free_irq(struct mlx5_irq *irq)
 {
 	struct mlx5_irq_pool *pool = irq->pool;
 #ifdef CONFIG_RFS_ACCEL
 	struct cpu_rmap *rmap;
 #endif
 
-	xa_erase(&pool->irqs, irq->pool_index);
 	/* free_irq requires that affinity_hint and rmap will be cleared before
 	 * calling it. To satisfy this requirement, we call
 	 * irq_cpu_rmap_remove() to remove the notifier
@@ -145,10 +153,18 @@ static void irq_release(struct mlx5_irq *irq)
 		irq_cpu_rmap_remove(rmap, irq->map.virq);
 #endif
 
-	free_cpumask_var(irq->mask);
 	free_irq(irq->map.virq, &irq->nh);
 	if (irq->map.index && pci_msix_can_alloc_dyn(pool->dev->pdev))
 		pci_msix_free_irq(pool->dev->pdev, irq->map);
+}
+
+static void irq_release(struct mlx5_irq *irq)
+{
+	struct mlx5_irq_pool *pool = irq->pool;
+
+	xa_erase(&pool->irqs, irq->pool_index);
+	mlx5_system_free_irq(irq);
+	free_cpumask_var(irq->mask);
 	kfree(irq);
 }
 
@@ -705,7 +721,8 @@ static void mlx5_irq_pool_free_irqs(struct mlx5_irq_pool *pool)
 	unsigned long index;
 
 	xa_for_each(&pool->irqs, index, irq)
-		free_irq(irq->map.virq, &irq->nh);
+		mlx5_system_free_irq(irq);
+
 }
 
 static void mlx5_irq_pools_free_irqs(struct mlx5_irq_table *table)
-- 
2.40.1


