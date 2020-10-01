Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC127F7AE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgJACFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbgJACF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 22:05:27 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B68822207;
        Thu,  1 Oct 2020 02:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601517926;
        bh=3XRG8FLg/W5dYYxSPVhxu+aghy8Uax7PPuF2FP/2q34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6OlqsGtOfZIkbxtsLF2hX8U+rF6EKnYzA7gMORbkqFd4Bdz6LoEpNDBmoEt1rgv7
         Y8ZBmT0a/PGDsFIgD1FoLZz16Gy1OQcd1Ab8b52qEQvUiONV1Jz1185f++oluAzWzC
         0L+vOFCsP5Emak3HmFYkkLV+0OEybbbWzLZrp4eU=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/15] net/mlx5: Fix request_irqs error flow
Date:   Wed, 30 Sep 2020 19:05:08 -0700
Message-Id: <20201001020516.41217-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001020516.41217-1-saeed@kernel.org>
References: <20201001020516.41217-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Fix error flow handling in request_irqs which try to free irq
that we failed to request.
It fixes the below trace.

WARNING: CPU: 1 PID: 7587 at kernel/irq/manage.c:1684 free_irq+0x4d/0x60
CPU: 1 PID: 7587 Comm: bash Tainted: G        W  OE    4.15.15-1.el7MELLANOXsmp-x86_64 #1
Hardware name: Advantech SKY-6200/SKY-6200, BIOS F2.00 08/06/2020
RIP: 0010:free_irq+0x4d/0x60
RSP: 0018:ffffc9000ef47af0 EFLAGS: 00010282
RAX: ffff88001476ae00 RBX: 0000000000000655 RCX: 0000000000000000
RDX: ffff88001476ae00 RSI: ffffc9000ef47ab8 RDI: ffff8800398bb478
RBP: ffff88001476a838 R08: ffff88001476ae00 R09: 000000000000156d
R10: 0000000000000000 R11: 0000000000000004 R12: ffff88001476a838
R13: 0000000000000006 R14: ffff88001476a888 R15: 00000000ffffffe4
FS:  00007efeadd32740(0000) GS:ffff88047fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc9cc010008 CR3: 00000001a2380004 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 mlx5_irq_table_create+0x38d/0x400 [mlx5_core]
 ? atomic_notifier_chain_register+0x50/0x60
 mlx5_load_one+0x7ee/0x1130 [mlx5_core]
 init_one+0x4c9/0x650 [mlx5_core]
 pci_device_probe+0xb8/0x120
 driver_probe_device+0x2a1/0x470
 ? driver_allows_async_probing+0x30/0x30
 bus_for_each_drv+0x54/0x80
 __device_attach+0xa3/0x100
 pci_bus_add_device+0x4a/0x90
 pci_iov_add_virtfn+0x2dc/0x2f0
 pci_enable_sriov+0x32e/0x420
 mlx5_core_sriov_configure+0x61/0x1b0 [mlx5_core]
 ? kstrtoll+0x22/0x70
 num_vf_store+0x4b/0x70 [mlx5_core]
 kernfs_fop_write+0x102/0x180
 __vfs_write+0x26/0x140
 ? rcu_all_qs+0x5/0x80
 ? _cond_resched+0x15/0x30
 ? __sb_start_write+0x41/0x80
 vfs_write+0xad/0x1a0
 SyS_write+0x42/0x90
 do_syscall_64+0x60/0x110
 entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Fixes: 24163189da48 ("net/mlx5: Separate IRQ request/free from EQ life cycle")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 373981a659c7..ef26a0a6f890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -115,7 +115,7 @@ static int request_irqs(struct mlx5_core_dev *dev, int nvec)
 	return 0;
 
 err_request_irq:
-	for (; i >= 0; i--) {
+	for (--i; i >= 0; i--) {
 		struct mlx5_irq *irq = mlx5_irq_get(dev, i);
 		int irqn = pci_irq_vector(dev->pdev, i);
 
-- 
2.26.2

