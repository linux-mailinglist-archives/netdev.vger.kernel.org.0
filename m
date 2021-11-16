Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469A5453AE7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhKPU0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhKPU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113BE61BBD;
        Tue, 16 Nov 2021 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094218;
        bh=ZqjtUtTjw3AuotciGM3HZtOU1DDic6sjAZ27EYUY60s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8F3YkWpwiU6wjouu5H+dItHLQcncSp1cH1mBVLEl9JvbSdYlvOAAqql+Ux0Eg0tI
         v6lkax9Q12s4DsS4FlIJjkjuMKmCeIC7NUOvMECXlrp5wB7DE+iWS578oMNrIDxv3V
         JAXrJrm/XKde4fBv6jnFVvVQdhzLkQKCZ+V73AJWYqL39wLFCDc4LIc/TrLWUKPzN9
         PDUYbeTcqEeR5TzRV/pZSjvpSfs09KCF9pHVRS9XjFJgVPFIEKV80yPe/XDx7eDR0b
         iB/08SXymkBCeh9rh64jkeJDKnt1eoFMZjeqtLDAdlsq4rDvxGizBaQW78RLPud3yp
         PNQk1DyPGqIdQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Neta Ostrovsky <netao@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/12] net/mlx5: Update error handler for UCTX and UMEM
Date:   Tue, 16 Nov 2021 12:23:16 -0800
Message-Id: <20211116202321.283874-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

In the fast unload flow, the device state is set to internal error,
which indicates that the driver started the destroy process.
In this case, when a destroy command is being executed, it should return
MLX5_CMD_STAT_OK.
Fix MLX5_CMD_OP_DESTROY_UCTX and MLX5_CMD_OP_DESTROY_UMEM to return OK
instead of EIO.

This fixes a call trace in the umem release process -
[ 2633.536695] Call Trace:
[ 2633.537518]  ib_uverbs_remove_one+0xc3/0x140 [ib_uverbs]
[ 2633.538596]  remove_client_context+0x8b/0xd0 [ib_core]
[ 2633.539641]  disable_device+0x8c/0x130 [ib_core]
[ 2633.540615]  __ib_unregister_device+0x35/0xa0 [ib_core]
[ 2633.541640]  ib_unregister_device+0x21/0x30 [ib_core]
[ 2633.542663]  __mlx5_ib_remove+0x38/0x90 [mlx5_ib]
[ 2633.543640]  auxiliary_bus_remove+0x1e/0x30 [auxiliary]
[ 2633.544661]  device_release_driver_internal+0x103/0x1f0
[ 2633.545679]  bus_remove_device+0xf7/0x170
[ 2633.546640]  device_del+0x181/0x410
[ 2633.547606]  mlx5_rescan_drivers_locked.part.10+0x63/0x160 [mlx5_core]
[ 2633.548777]  mlx5_unregister_device+0x27/0x40 [mlx5_core]
[ 2633.549841]  mlx5_uninit_one+0x21/0xc0 [mlx5_core]
[ 2633.550864]  remove_one+0x69/0xe0 [mlx5_core]
[ 2633.551819]  pci_device_remove+0x3b/0xc0
[ 2633.552731]  device_release_driver_internal+0x103/0x1f0
[ 2633.553746]  unbind_store+0xf6/0x130
[ 2633.554657]  kernfs_fop_write+0x116/0x190
[ 2633.555567]  vfs_write+0xa5/0x1a0
[ 2633.556407]  ksys_write+0x4f/0xb0
[ 2633.557233]  do_syscall_64+0x5b/0x1a0
[ 2633.558071]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[ 2633.559018] RIP: 0033:0x7f9977132648
[ 2633.559821] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 55 6f 2d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
[ 2633.562332] RSP: 002b:00007fffb1a83888 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 2633.563472] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f9977132648
[ 2633.564541] RDX: 000000000000000c RSI: 000055b90546e230 RDI: 0000000000000001
[ 2633.565596] RBP: 000055b90546e230 R08: 00007f9977406860 R09: 00007f9977a54740
[ 2633.566653] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f99774056e0
[ 2633.567692] R13: 000000000000000c R14: 00007f9977400880 R15: 000000000000000c
[ 2633.568725] ---[ end trace 10b4fe52945e544d ]---

Fixes: 6a6fabbfa3e8 ("net/mlx5: Update pci error handler entries and command translation")
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index f71ec4d9d68e..8eaa24d865c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -339,6 +339,8 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
 	case MLX5_CMD_OP_QUERY_ESW_FUNCTIONS:
 	case MLX5_CMD_OP_DEALLOC_SF:
+	case MLX5_CMD_OP_DESTROY_UCTX:
+	case MLX5_CMD_OP_DESTROY_UMEM:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -464,9 +466,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_MODIFY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_QUERY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_CREATE_UCTX:
-	case MLX5_CMD_OP_DESTROY_UCTX:
 	case MLX5_CMD_OP_CREATE_UMEM:
-	case MLX5_CMD_OP_DESTROY_UMEM:
 	case MLX5_CMD_OP_ALLOC_MEMIC:
 	case MLX5_CMD_OP_MODIFY_XRQ:
 	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
-- 
2.31.1

