Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7641C423
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbhI2MCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343611AbhI2MCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54F861439;
        Wed, 29 Sep 2021 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632916861;
        bh=Ydq+7Ul0lWbtQV7J2i2ywwcqha+9M/t3eBvCLaEn10A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+cqRHcodo7zx5+gcpqNEXA0ImHNnS0J7zyR8oXKs1bviHnHeS4XjYl6noRCgK3S3
         1FG9MZ0uYshEcEv1PWfZQXgUK9tl7DN+ImxQAe43wNSp3EwW3D4t0Uv2znsG+y49Hz
         FwPh22KAIg9nJ/h5JwsFteTNh9J4fcANAqf46uqLuPTOGKx8KxjuKHcNm0J+xmQTqY
         VW3OBu7m+ez3yNH4rF1p/VrgGp7YotrnMRtCufPSJ1r9jtcWJ7BGn7Cjc1YphgtPLm
         mPwtS5sugGV1zuswIHXVddxmbIAM5Ynfnws6lUzDxskjxpRGy9OvO5mGxmwyXIPftt
         qINFi8mSJshtA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v1 1/5] devlink: Add missed notifications iterators
Date:   Wed, 29 Sep 2021 15:00:42 +0300
Message-Id: <2ed1159291f2a589b013914f2b60d8172fc525c1.1632916329.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632916329.git.leonro@nvidia.com>
References: <cover.1632916329.git.leonro@nvidia.com>
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

