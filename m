Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434E3441C8C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhKAOZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:25:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15329 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAOZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:25:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjZxv4HhTz90jL;
        Mon,  1 Nov 2021 22:22:59 +0800 (CST)
Received: from kwepeml500002.china.huawei.com (7.221.188.128) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 22:23:06 +0800
Received: from compute.localdomain (10.175.112.70) by
 kwepeml500002.china.huawei.com (7.221.188.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 22:23:05 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed
Date:   Mon, 1 Nov 2021 22:34:33 +0800
Message-ID: <1635777273-46028-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepeml500002.china.huawei.com (7.221.188.128)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I do fuzz test for bonding device interface, I got the following
use-after-free Calltrace:

==================================================================
BUG: KASAN: use-after-free in bond_enslave+0x1521/0x24f0
Read of size 8 at addr ffff88825bc11c00 by task ifenslave/7365

CPU: 5 PID: 7365 Comm: ifenslave Tainted: G            E     5.15.0-rc1+ #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
Call Trace:
 dump_stack_lvl+0x6c/0x8b
 print_address_description.constprop.0+0x48/0x70
 kasan_report.cold+0x82/0xdb
 __asan_load8+0x69/0x90
 bond_enslave+0x1521/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f19159cf577
Code: b3 66 90 48 8b 05 11 89 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 78
RSP: 002b:00007ffeb3083c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffeb3084bca RCX: 00007f19159cf577
RDX: 00007ffeb3083ce0 RSI: 0000000000008990 RDI: 0000000000000003
RBP: 00007ffeb3084bc4 R08: 0000000000000040 R09: 0000000000000000
R10: 00007ffeb3084bc0 R11: 0000000000000246 R12: 00007ffeb3083ce0
R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffeb3083cb0

Allocated by task 7365:
 kasan_save_stack+0x23/0x50
 __kasan_kmalloc+0x83/0xa0
 kmem_cache_alloc_trace+0x22e/0x470
 bond_enslave+0x2e1/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 7365:
 kasan_save_stack+0x23/0x50
 kasan_set_track+0x20/0x30
 kasan_set_free_info+0x24/0x40
 __kasan_slab_free+0xf2/0x130
 kfree+0xd1/0x5c0
 slave_kobj_release+0x61/0x90
 kobject_put+0x102/0x180
 bond_sysfs_slave_add+0x7a/0xa0
 bond_enslave+0x11b6/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x23/0x50
 kasan_record_aux_stack+0xb7/0xd0
 insert_work+0x43/0x190
 __queue_work+0x2e3/0x970
 delayed_work_timer_fn+0x3e/0x50
 call_timer_fn+0x148/0x470
 run_timer_softirq+0x8a8/0xc50
 __do_softirq+0x107/0x55f

Second to last potentially related work creation:
 kasan_save_stack+0x23/0x50
 kasan_record_aux_stack+0xb7/0xd0
 insert_work+0x43/0x190
 __queue_work+0x2e3/0x970
 __queue_delayed_work+0x130/0x180
 queue_delayed_work_on+0xa7/0xb0
 bond_enslave+0xe25/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88825bc11c00
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 0 bytes inside of
 1024-byte region [ffff88825bc11c00, ffff88825bc12000)
The buggy address belongs to the page:
page:ffffea00096f0400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x25bc10
head:ffffea00096f0400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000010200 ffffea0009a71c08 ffff888240001968 ffff88810004dbc0
raw: 0000000000000000 00000000000a000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88825bc11b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88825bc11b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88825bc11c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88825bc11c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88825bc11d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Put new_slave in bond_sysfs_slave_add() will cause use-after-free problems
when new_slave is accessed in the subsequent error handling process. Since
new_slave will be put in the subsequent error handling process, remove the
unnecessary put to fix it.
In addition, when sysfs_create_file() fails, if some files have been crea-
ted successfully, we need to call sysfs_remove_file() to remove them.

Fixes: 7afcaec49696 (bonding: use kobject_put instead of _del after kobject_add)
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
---
 drivers/net/bonding/bond_sysfs_slave.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index fd07561..d1a5b3f 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -137,18 +137,23 @@ static ssize_t slave_show(struct kobject *kobj,
 
 int bond_sysfs_slave_add(struct slave *slave)
 {
-	const struct slave_attribute **a;
+	const struct slave_attribute **a, **b;
 	int err;
 
 	for (a = slave_attrs; *a; ++a) {
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
 		if (err) {
-			kobject_put(&slave->kobj);
-			return err;
+			goto err_remove_file;
 		}
 	}
 
 	return 0;
+
+err_remove_file:
+	for (b = slave_attrs; b < a; ++b)
+		sysfs_remove_file(&slave->kobj, &((*b)->attr));
+
+	return err;
 }
 
 void bond_sysfs_slave_del(struct slave *slave)
-- 
1.8.3.1

