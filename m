Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70219486F46
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbiAGA6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36516 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344870AbiAGA6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A869B82491
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3247C36AF3;
        Fri,  7 Jan 2022 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517125;
        bh=sCplI/EfGmYfpX1L4l5gK+3+jy2czuQlHTGkUEUTuls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckhmTNfU4AfJKfTIwvj+ahEFyIAJszLgmsMimdTh0iSkLQ6BCFhEbn62co0ueW5NV
         AQVf418XpYFPKBF4V5Zvs5SWcY/4g3646w38fAMjODYHPae8W7RFwi3/ipKtewYLfz
         XhmRAmNrhyjurobcEkXc5kWPMaCwtQSpk2yI3DWYlnWT9IDigexteJIZebVMtXkq9x
         cKH0cb9EyB8GX4bkCzd4piD0ckIL9iTtTWMpO6EiTzPx1vArzK8B9JvwCKuRKqFqJs
         zJG0Cto0diD59t3095609g4Pf2iPzFZ9Q2pje/tPcTeg2vpDjDZCFOqD1B6UYLpoLx
         bkBAafl/UQ0cA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/11] net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used
Date:   Thu,  6 Jan 2022 16:58:23 -0800
Message-Id: <20220107005831.78909-4-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Creating routes with nexthop objects while in switchdev mode leads to access to
un-allocated memory and trigger bellow call trace due to hitting WARN_ON.
This is caused due to illegal usage of fib_info_nh in TC tunnel FIB event handling to
resolve the FIB device while fib_info built in with nexthop.

Fixed by ignoring attempts to use nexthop objects with routes until support can be
properly added.

WARNING: CPU: 1 PID: 1724 at include/net/nexthop.h:468 mlx5e_tc_tun_fib_event+0x448/0x570 [mlx5_core]
CPU: 1 PID: 1724 Comm: ip Not tainted 5.15.0_for_upstream_min_debug_2021_11_09_02_04 #1
RIP: 0010:mlx5e_tc_tun_fib_event+0x448/0x570 [mlx5_core]
RSP: 0018:ffff8881349f7910 EFLAGS: 00010202
RAX: ffff8881492f1980 RBX: ffff8881349f79e8 RCX: 0000000000000000
RDX: ffff8881349f79e8 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8881349f7950 R08: 00000000000000fe R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811e9d0000
R13: ffff88810eb62000 R14: ffff888106710268 R15: 0000000000000018
FS:  00007f1d5ca6e800(0000) GS:ffff88852c880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffedba44ff8 CR3: 0000000129808004 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 atomic_notifier_call_chain+0x42/0x60
 call_fib_notifiers+0x21/0x40
 fib_table_insert+0x479/0x6d0
 ? try_charge_memcg+0x480/0x6d0
 inet_rtm_newroute+0x65/0xb0
 rtnetlink_rcv_msg+0x2af/0x360
 ? page_add_file_rmap+0x13/0x130
 ? do_set_pte+0xcd/0x120
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x4e/0xf0
 netlink_unicast+0x1ee/0x2b0
 netlink_sendmsg+0x22e/0x460
 sock_sendmsg+0x33/0x40
 ____sys_sendmsg+0x1d1/0x1f0
 ___sys_sendmsg+0xab/0xf0
 ? __mod_memcg_lruvec_state+0x40/0x60
 ? __mod_lruvec_page_state+0x95/0xd0
 ? page_add_new_anon_rmap+0x4e/0xf0
 ? __handle_mm_fault+0xec6/0x1470
 __sys_sendmsg+0x51/0x90
 ? internal_get_user_pages_fast+0x480/0xa10
 do_syscall_64+0x3d/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 042b1abe1437..62cbd15ffc34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1579,6 +1579,8 @@ mlx5e_init_fib_work_ipv4(struct mlx5e_priv *priv,
 	struct net_device *fib_dev;
 
 	fen_info = container_of(info, struct fib_entry_notifier_info, info);
+	if (fen_info->fi->nh)
+		return NULL;
 	fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 	if (!fib_dev || fib_dev->netdev_ops != &mlx5e_netdev_ops ||
 	    fen_info->dst_len != 32)
-- 
2.33.1

