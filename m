Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63FF41C688
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343972AbhI2OUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242801AbhI2OUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1215D613CD;
        Wed, 29 Sep 2021 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632925110;
        bh=8cuoS8pblwd/YKxPn02t98/WuxuBy35ywaSCthetUcU=;
        h=From:To:Cc:Subject:Date:From;
        b=NdDe8GnDcv59lqFnvLoCpx6z7YU4Qt1Mp7VmZNa2XqDUyyXDMo5yHsliAIjxhPTZ/
         yDXTcJqI3x9MqneL97AO3rA1QbvI+J1lTDql1PdX+v+Kgqk+hYnkygTVKoSjKckcOz
         qIvzmZCJgGEe6kfWZPtyiMu2on3U3sBihTzEa7dRV4sj3LzNAdrSe3i2kC9U1U/RCm
         +xRLCWEtMjBzoAFihqYO9uQ5SigAvVC43z4B34+20iTjNc8V4hsVEJEDLGMvfSyEaU
         pll0ZT+72em4nFOBbKS3SPGAYqeJsCZ3VbV8/SknpmwP7kGVq+/NWKKIS58p/qFGg7
         17JGunfRFu55g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next] devlink: Add missed notifications iterators
Date:   Wed, 29 Sep 2021 17:18:20 +0300
Message-Id: <2ed1159291f2a589b013914f2b60d8172fc525c1.1632925030.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The commit mentioned in Fixes line missed a couple of notifications that
were registered before devlink_register() and should be delayed too.

As such, the too early placed WARN_ON() check spotted it.

WARNING: CPU: 1 PID: 6540 at net/core/devlink.c:5158 devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
Modules linked in:
CPU: 1 PID: 6540 Comm: syz-executor.0 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
Code: 38 41 b8 c0 0c 00 00 31 d2 48 89 ee 4c 89 e7 e8 72 1a 26 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e e9 01 bd 41 fa
e8 fc bc 41 fa <0f> 0b e9 f7 fe ff ff e8 f0 bc 41 fa 0f 0b eb da 4c 89 e7 e8 c4 18
RSP: 0018:ffffc90002d6f658 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801f08d580 RSI: ffffffff87344e94 RDI: 0000000000000003
RBP: ffff88801ee42100 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87344d8a R11: 0000000000000000 R12: ffff88801c1dc000
R13: 0000000000000000 R14: 000000000000002c R15: ffff88801c1dc070
FS:  0000555555e8e400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055dd7c590310 CR3: 0000000069a09000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 devlink_region_create+0x39f/0x4c0 net/core/devlink.c:10327
 nsim_dev_dummy_region_init drivers/net/netdevsim/dev.c:481 [inline]
 nsim_dev_probe+0x5f6/0x1150 drivers/net/netdevsim/dev.c:1479
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc35/0x21b0 drivers/base/core.c:3359
 nsim_bus_dev_new drivers/net/netdevsim/bus.c:435 [inline]
 new_device_store+0x48b/0x770 drivers/net/netdevsim/bus.c:302
 bus_attr_store+0x72/0xa0 drivers/base/bus.c:122
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:507
 vfs_write+0x7cf/0xae0 fs/read_write.c:594
 ksys_write+0x12d/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f328409d3ef
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01
00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
RSP: 002b:00007ffdc6851140 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f328409d3ef
RDX: 0000000000000003 RSI: 00007ffdc6851190 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000000 R09: 00007ffdc68510e0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f3284144971
R13: 00007ffdc6851190 R14: 0000000000000000 R15: 00007ffdc6851860

Fixes: 474053c980a0 ("devlink: Notify users when objects are accessible")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 06edb2f1d21e..b64303085d0e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1072,7 +1072,9 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW && cmd != DEVLINK_CMD_RATE_DEL);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -5155,7 +5157,8 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	struct sk_buff *msg;
 
 	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
 	if (IS_ERR(msg))
@@ -8981,6 +8984,8 @@ static void devlink_notify_register(struct devlink *devlink)
 	struct devlink_trap_group_item *group_item;
 	struct devlink_trap_item *trap_item;
 	struct devlink_port *devlink_port;
+	struct devlink_rate *rate_node;
+	struct devlink_region *region;
 
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	list_for_each_entry(devlink_port, &devlink->port_list, list)
@@ -8997,6 +9002,12 @@ static void devlink_notify_register(struct devlink *devlink)
 	list_for_each_entry(trap_item, &devlink->trap_list, list)
 		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
 
+	list_for_each_entry(rate_node, &devlink->rate_list, list)
+		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+
+	list_for_each_entry(region, &devlink->region_list, list)
+		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
+
 	devlink_params_publish(devlink);
 }
 
@@ -9006,9 +9017,17 @@ static void devlink_notify_unregister(struct devlink *devlink)
 	struct devlink_trap_group_item *group_item;
 	struct devlink_trap_item *trap_item;
 	struct devlink_port *devlink_port;
+	struct devlink_rate *rate_node;
+	struct devlink_region *region;
 
 	devlink_params_unpublish(devlink);
 
+	list_for_each_entry_reverse(region, &devlink->region_list, list)
+		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
+
+	list_for_each_entry_reverse(rate_node, &devlink->rate_list, list)
+		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_DEL);
+
 	list_for_each_entry_reverse(trap_item, &devlink->trap_list, list)
 		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
 
-- 
2.31.1

