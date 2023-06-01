Return-Path: <netdev+bounces-6970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C3371911A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8198F28169D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9506FCD;
	Thu,  1 Jun 2023 03:10:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDD64C7F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2BAC433D2;
	Thu,  1 Jun 2023 03:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685589055;
	bh=BQguYlZAy/pb83l5VRd3u3iP7hQ0ANoxxKLA+uspg7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7/id1TahaXiYdRXD3eo+gMDJQeU0a2eXIE960pJPkX+suSUxtvdco72eEEa7LduH
	 7dXITH6mg4iZ/Po/f9KDecYnosfE0kQPriHgGlXc9C83ADZ6IWDSKkWIqLZTyExLVN
	 2ry/nQmE5nnYiMI6UF62vwI40n1omMKRBJGxi6FtJaBm2X1AQmXHISoQXLtwqDodZx
	 gejbARG21J4pL5wJfNfigA1PC3pH9Ng6QhgWfuvu4KmE5saNz5JpNSixe8BIP3tKB2
	 WQ8UU6ubcwbInVL7uQFFupTKaFtAQxbcl87TgJjgbta263YYf6H9ApIJd2VLC0U5f3
	 1ih3eNN4rhn+w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net 1/5] net/mlx5: Remove rmap also in case dynamic MSIX not supported
Date: Wed, 31 May 2023 20:10:47 -0700
Message-Id: <20230601031051.131529-2-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601031051.131529-1-saeed@kernel.org>
References: <20230601031051.131529-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

mlx5 add IRQs to rmap upon MSIX request, and mlx5 remove rmap from
MSIX only if msi_map.index is populated. However, msi_map.index is
populated only when dynamic MSIX is supported. This results in freeing
IRQs without removing them from rmap, which triggers the bellow
WARN_ON[1].

rmap is a feature which have no relation to dynamic MSIX.
Hence, remove the check of msi_map.index when removing IRQ from rmap.

[1]
[  200.307160 ] WARNING: CPU: 20 PID: 1702 at kernel/irq/manage.c:2034 free_irq+0x2ac/0x358
[  200.316990 ] CPU: 20 PID: 1702 Comm: modprobe Not tainted 6.4.0-rc3_for_upstream_min_debug_2023_05_24_14_02 #1
[  200.318939 ] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[  200.321659 ] pc : free_irq+0x2ac/0x358
[  200.322400 ] lr : free_irq+0x20/0x358
[  200.337865 ] Call trace:
[  200.338360 ]  free_irq+0x2ac/0x358
[  200.339029 ]  irq_release+0x58/0xd0 [mlx5_core]
[  200.340093 ]  mlx5_irqs_release_vectors+0x80/0xb0 [mlx5_core]
[  200.341344 ]  destroy_comp_eqs+0x120/0x170 [mlx5_core]
[  200.342469 ]  mlx5_eq_table_destroy+0x1c/0x38 [mlx5_core]
[  200.343645 ]  mlx5_unload+0x8c/0xc8 [mlx5_core]
[  200.344652 ]  mlx5_uninit_one+0x78/0x118 [mlx5_core]
[  200.345745 ]  remove_one+0x80/0x108 [mlx5_core]
[  200.346752 ]  pci_device_remove+0x40/0xd8
[  200.347554 ]  device_remove+0x50/0x88
[  200.348272 ]  device_release_driver_internal+0x1c4/0x228
[  200.349312 ]  driver_detach+0x54/0xa0
[  200.350030 ]  bus_remove_driver+0x74/0x100
[  200.350833 ]  driver_unregister+0x34/0x68
[  200.351619 ]  pci_unregister_driver+0x28/0xa0
[  200.352476 ]  mlx5_cleanup+0x14/0x2210 [mlx5_core]
[  200.353536 ]  __arm64_sys_delete_module+0x190/0x2e8
[  200.354495 ]  el0_svc_common.constprop.0+0x6c/0x1d0
[  200.355455 ]  do_el0_svc+0x38/0x98
[  200.356122 ]  el0_svc+0x1c/0x80
[  200.356739 ]  el0t_64_sync_handler+0xb4/0x130
[  200.357604 ]  el0t_64_sync+0x174/0x178
[  200.358345 ] ---[ end trace 0000000000000000  ]---

Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index db5687d9fec9..86ac4a85fd87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -141,7 +141,7 @@ static void irq_release(struct mlx5_irq *irq)
 	irq_update_affinity_hint(irq->map.virq, NULL);
 #ifdef CONFIG_RFS_ACCEL
 	rmap = mlx5_eq_table_get_rmap(pool->dev);
-	if (rmap && irq->map.index)
+	if (rmap)
 		irq_cpu_rmap_remove(rmap, irq->map.virq);
 #endif
 
-- 
2.40.1


