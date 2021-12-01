Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8934464740
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346988AbhLAGk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346951AbhLAGks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DF3C06174A
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 631AECE1D6E
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48016C53FCE;
        Wed,  1 Dec 2021 06:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340643;
        bh=pFdEM2j+nNkcJUrlVkwi5wOcnJwYy/F1hSXHboeH8dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ka5zTxA1U6j2CpHM15i20ckOUn12bEeuSOQD7ZFLhcQeWb6uU9F0iuoBguL/uX6cA
         +ga7xjsZ4VFt3ovIt9zYvWdTYJU09/vihesS056FzKWzjr5X9RWfRHMmqhLAqEXZmp
         8rLSg63vBoR67k75QGWEV2uogygkg2FnYRRIzu69uXyMBj7o5La7cPje+r+FB4kWvo
         +dN+1iMwDn6CdTxdBtvziNkrdBIbuyJDA8DIqrVEsYqf/yhm+Ik18ZtdQ3GHrrvjK6
         S2ZaZ0CACGJYrr8o5QMrNU0K9c/BiSiM5wgza2vt6r/+bBOGY39NoVxrfIwejK7H/U
         cpXFfSX/OP82Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/13] net/mlx5: Lag, Fix recreation of VF LAG
Date:   Tue, 30 Nov 2021 22:37:01 -0800
Message-Id: <20211201063709.229103-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Driver needs to nullify the port select attributes of the LAG when
port selection is destroyed, otherwise it breaks recreation of the
LAG.
It fixes the below kernel oops:

 [  587.906377] BUG: kernel NULL pointer dereference, address: 0000000000000008
 [  587.908843] #PF: supervisor read access in kernel mode
 [  587.910730] #PF: error_code(0x0000) - not-present page
 [  587.912580] PGD 0 P4D 0
 [  587.913632] Oops: 0000 [#1] SMP PTI
 [  587.914644] CPU: 5 PID: 165 Comm: kworker/u20:5 Tainted: G           OE     5.9.0_mlnx #1
 [  587.916152] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [  587.918332] Workqueue: mlx5_lag mlx5_do_bond_work [mlx5_core]
 [  587.919479] RIP: 0010:mlx5_del_flow_rules+0x10/0x270 [mlx5_core]
 [  587.920568] mlx5_core 0000:08:00.1 enp8s0f1: Link up
 [  587.920680] Code: c0 09 80 a0 e8 cf 42 a4 e0 48 c7 c3 f4 ff ff ff e8 8a 88 dd e0 e9 ab fe ff ff 0f 1f 44 00 00 41 56 41 55 49 89 fd 41 54 55 53 <48> 8b 47 08 48 8b 68 28 48 85 ed 74 2e 48 8d 7d 38 e8 6a 64 34 e1
 [  587.925116] bond0: (slave enp8s0f1): Enslaving as an active interface with an up link
 [  587.930415] RSP: 0018:ffffc9000048fd88 EFLAGS: 00010282
 [  587.930417] RAX: ffff88846c14fac0 RBX: ffff88846cddcb80 RCX: 0000000080400007
 [  587.930417] RDX: 0000000080400008 RSI: ffff88846cddcb80 RDI: 0000000000000000
 [  587.930419] RBP: ffff88845fd80140 R08: 0000000000000001 R09: ffffffffa074ba00
 [  587.938132] R10: ffff88846c14fec0 R11: 0000000000000001 R12: ffff88846c122f10
 [  587.939473] R13: 0000000000000000 R14: 0000000000000001 R15: ffff88846d7a0000
 [  587.940800] FS:  0000000000000000(0000) GS:ffff88846fa80000(0000) knlGS:0000000000000000
 [  587.942416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  587.943536] CR2: 0000000000000008 CR3: 000000000240a002 CR4: 0000000000770ee0
 [  587.944904] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [  587.946308] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [  587.947639] PKRU: 55555554
 [  587.948236] Call Trace:
 [  587.948834]  mlx5_lag_destroy_definer.isra.3+0x16/0x90 [mlx5_core]
 [  587.950033]  mlx5_lag_destroy_definers+0x5b/0x80 [mlx5_core]
 [  587.951128]  mlx5_deactivate_lag+0x6e/0x80 [mlx5_core]
 [  587.952146]  mlx5_do_bond+0x150/0x450 [mlx5_core]
 [  587.953086]  mlx5_do_bond_work+0x3e/0x50 [mlx5_core]
 [  587.954086]  process_one_work+0x1eb/0x3e0
 [  587.954899]  worker_thread+0x2d/0x3c0
 [  587.955656]  ? process_one_work+0x3e0/0x3e0
 [  587.956493]  kthread+0x115/0x130
 [  587.957174]  ? kthread_park+0x90/0x90
 [  587.957929]  ret_from_fork+0x1f/0x30
 [  587.973055] ---[ end trace 71ccd6eca89f5513 ]---

Fixes: b7267869e923 ("net/mlx5: Lag, add support to create/destroy/modify port selection")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index ad63dd45c8fb..a6592f9c3c05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -608,4 +608,5 @@ void mlx5_lag_port_sel_destroy(struct mlx5_lag *ldev)
 	if (port_sel->tunnel)
 		mlx5_destroy_ttc_table(port_sel->inner.ttc);
 	mlx5_lag_destroy_definers(ldev);
+	memset(port_sel, 0, sizeof(*port_sel));
 }
-- 
2.31.1

