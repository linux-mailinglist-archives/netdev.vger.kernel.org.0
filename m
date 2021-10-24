Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C2C4387AE
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhJXIoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhJXIoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1427B600CD;
        Sun, 24 Oct 2021 08:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635064936;
        bh=8taORk5LytaqbLQ2C+yb36ZXgofUfKDPX6aHuXy44ZU=;
        h=From:To:Cc:Subject:Date:From;
        b=aFlfz2dTwIbpGxOJkZRnPwlZe8mZOHitqgZBB3xC3DXcFeVGFyWIOgykq1Pxbnlo8
         +bQQhQ65/9wQtXKJNZ+MR7JiSqEYTG3/ArkcwcB2LtmDXLzo875+ryTZp8O6YuFlRd
         6sxZhG60MjfYQeazdxNc6eRkv4bjzX6vmQ3SonfIfP8GG4GNopg8V/wrFYTOHk4HjJ
         WAK/qOgeVAse8EW26YSrwqvXxn6qP4W6jEdPNDjBDS9tSOj0NSgRsON2rFCmQr9vWG
         /dNXfXi8u/YH/p2+ruYhPhorSo0SohKJjCQ/OSBOTMEs8mFEclk6e34uUdVKIvzWK4
         2qcE2UWSLQciw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: [PATCH net-next] netdevsim: Register and unregister devlink traps on probe/remove device
Date:   Sun, 24 Oct 2021 11:42:11 +0300
Message-Id: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Align netdevsim to be like all other physical devices that register and
unregister devlink traps during their probe and removal respectively.

netdevsim netdevsim0 netdevsim2 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim1 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6553 at net/core/devlink.c:11162 devlink_trap_groups_unregister+0xe8/0x110 net/core/devlink.c:11162
Modules linked in:
CPU: 0 PID: 6553 Comm: syz-executor166 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:devlink_trap_groups_unregister+0xe8/0x110 net/core/devlink.c:11162
Code: ff ff 31 ff 89 de e8 97 e3 41 fa 83 fb ff 75 cc e8 4d dc 41 fa 4c 89 f7 5b 5d 41 5c 41 5d 41 5e e9 6d 79 05 02 e8 38 dc 41 fa <0f> 0b e9 71 ff ff ff 4c 89 ef e8 19 4f 89 fa e9 3b ff ff ff 48 89
RSP: 0018:ffffc90002d8f3b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000000
RDX: ffff888024a00000 RSI: ffffffff87350e68 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff87350dd7 R11: 0000000000000000 R12: ffffffff8a263c20
R13: ffff888077d36000 R14: dffffc0000000000 R15: ffff888077d36388
FS:  000055555711e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 0000000070465000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nsim_dev_traps_exit+0x67/0x170 drivers/net/netdevsim/dev.c:849
 nsim_dev_reload_destroy+0x20c/0x2f0 drivers/net/netdevsim/dev.c:1559
 nsim_dev_reload_down+0xdf/0x180 drivers/net/netdevsim/dev.c:883
 devlink_reload+0x53b/0x6b0 net/core/devlink.c:4040
 devlink_nl_cmd_reload+0x6ed/0x11d0 net/core/devlink.c:4161
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f02abf45409
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeed83e458 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffeed83e468 RCX: 00007f02abf45409
RDX: 0000000000000000 RSI: 0000000020000600 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeed83e470
R13: 00007ffeed83e490 R14: 0000000000000000 R15: 0000000000000000

Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
Reported-by: syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 9661aca35703..2698241bb886 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1400,14 +1400,10 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		return err;
 
-	err = nsim_dev_traps_init(devlink);
-	if (err)
-		goto err_dummy_region_exit;
-
 	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
 	if (IS_ERR(nsim_dev->fib_data)) {
 		err = PTR_ERR(nsim_dev->fib_data);
-		goto err_traps_exit;
+		goto err_dummy_region_exit;
 	}
 
 	err = nsim_dev_health_init(nsim_dev, devlink);
@@ -1435,8 +1431,6 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	nsim_dev_health_exit(nsim_dev);
 err_fib_destroy:
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
-err_traps_exit:
-	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
 	return err;
@@ -1556,7 +1550,6 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	nsim_dev_psample_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
-	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
 	mutex_destroy(&nsim_dev->port_list_lock);
 }
@@ -1567,6 +1560,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
 	devlink_unregister(devlink);
+	nsim_dev_traps_exit(devlink);
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
-- 
2.31.1

