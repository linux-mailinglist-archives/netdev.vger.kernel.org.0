Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9620E3A2158
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFJAYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhFJAYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFE80613F1;
        Thu, 10 Jun 2021 00:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284540;
        bh=ROJvY7jsh8mtmjJmokHYJ3LAY+I7+OzpuPuS6iN8sy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E28eexodRdQMXE9G9eVByR3GSJ51pHbd7FrlrV4QtLghjI6W9spo5dfvtuW+QPK5F
         bqZ88XKaEggo3ZKbg3DQuJKL7tsWN9EXDGxDYbrI7Btk62D19nEgXWklUSd6zFLzCS
         fLOh3x8eKPMNzi3hA5A0YIkcTLFEy/5Mnk5O4jECy+U/pqC0Yl9Kt4u/4XTUNxrK63
         efRL7VSujZBcolpI2QHXtRWgeU64ht3gM8GXGEzGj4R/Cs8AgmZIpqCgMlzjSLIwTD
         re1FVdrZQ7dgje8ectnCvsGhafioOTjRrkvGEiN7ZdKHY6wP0JFLQr4BU3YPfX1+jZ
         DF8U8cgAwESuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/12] net/mlx5e: Verify dev is present in get devlink port ndo
Date:   Wed,  9 Jun 2021 17:21:50 -0700
Message-Id: <20210610002155.196735-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

When changing eswitch mode, the netdev is detached from the
hardware resources. So verify dev is present in get devlink
port ndo. Otherwise, we will hit the following panic:

[241535.973539] RIP: 0010:__devlink_port_phys_port_name_get+0x13/0x1b0
[241535.976471] RSP: 0018:ffff9eaf0ae1b7c8 EFLAGS: 00010292
[241535.977471] RAX: 000000000002d370 RBX: 000000000002d370 RCX: 0000000000000000
[241535.978479] RDX: 0000000000000010 RSI: ffff9eaf0ae1b858 RDI: 000000000002d370
[241535.979482] RBP: ffff9eaf0ae1b7e0 R08: 000000000000002a R09: ffff8888d54d13da
[241535.980486] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8888e6700000
[241535.981491] R13: ffff9eaf0ae1b858 R14: 0000000000000010 R15: 0000000000000000
[241535.982489] FS:  00007fd374ef3740(0000) GS:ffff88909ea00000(0000) knlGS:0000000000000000
[241535.983494] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[241535.984487] CR2: 000000000002d444 CR3: 000000089fd26006 CR4: 00000000003706e0
[241535.985502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[241535.986499] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[241535.987477] Call Trace:
[241535.988426]  ? nla_put_64bit+0x71/0xa0
[241535.989368]  devlink_compat_phys_port_name_get+0x50/0xa0
[241535.990312]  dev_get_phys_port_name+0x4b/0x60
[241535.991252]  rtnl_fill_ifinfo+0x57b/0xcb0
[241535.992192]  rtnl_dump_ifinfo+0x58f/0x6d0
[241535.993123]  ? ksize+0x14/0x20
[241535.994033]  ? __alloc_skb+0xe8/0x250
[241535.994935]  netlink_dump+0x17c/0x300
[241535.995821]  netlink_recvmsg+0x1de/0x2c0
[241535.996677]  sock_recvmsg+0x70/0x80
[241535.997518]  ____sys_recvmsg+0x9b/0x1b0
[241535.998360]  ? iovec_from_user+0x82/0x120
[241535.999202]  ? __import_iovec+0x2c/0x130
[241536.000031]  ___sys_recvmsg+0x94/0x130
[241536.000850]  ? __handle_mm_fault+0x56d/0x6e0
[241536.001668]  __sys_recvmsg+0x5f/0xb0
[241536.002464]  ? syscall_enter_from_user_mode+0x2b/0x80
[241536.003242]  __x64_sys_recvmsg+0x1f/0x30
[241536.004008]  do_syscall_64+0x38/0x50
[241536.004767]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[241536.005532] RIP: 0033:0x7fd375014f47

Fixes: 2ff349c5edfe ("net/mlx5e: Verify dev is present in some ndos")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 0dd7615e5931..bc33eaada3b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -64,6 +64,8 @@ struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct devlink_port *port;
 
+	if (!netif_device_present(dev))
+		return NULL;
 	port = mlx5e_devlink_get_dl_port(priv);
 	if (port->registered)
 		return port;
-- 
2.31.1

