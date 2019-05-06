Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F702150CA
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfEFP7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:59:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726413AbfEFP7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 11:59:01 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B0D711A05372C52917E0;
        Mon,  6 May 2019 23:58:57 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 6 May 2019
 23:58:50 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <vishal@chelsio.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] cxgb4: Fix error path in cxgb4_init_module
Date:   Mon, 6 May 2019 23:57:54 +0800
Message-ID: <20190506155754.42464-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG: unable to handle kernel paging request at ffffffffa016a270
PGD 3270067 P4D 3270067 PUD 3271063 PMD 230bbd067 PTE 0
Oops: 0000 [#1
CPU: 0 PID: 6134 Comm: modprobe Not tainted 5.1.0+ #33
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:atomic_notifier_chain_register+0x24/0x60
Code: 1f 80 00 00 00 00 55 48 89 e5 41 54 49 89 f4 53 48 89 fb e8 ae b4 38 01 48 8b 53 38 48 8d 4b 38 48 85 d2 74 20 45 8b 44 24 10 <44> 3b 42 10 7e 08 eb 13 44 39 42 10 7c 0d 48 8d 4a 08 48 8b 52 08
RSP: 0018:ffffc90000e2bc60 EFLAGS: 00010086
RAX: 0000000000000292 RBX: ffffffff83467240 RCX: ffffffff83467278
RDX: ffffffffa016a260 RSI: ffffffff83752140 RDI: ffffffff83467240
RBP: ffffc90000e2bc70 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 00000000014fa61f R12: ffffffffa01c8260
R13: ffff888231091e00 R14: 0000000000000000 R15: ffffc90000e2be78
FS:  00007fbd8d7cd540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa016a270 CR3: 000000022c7e3000 CR4: 00000000000006f0
Call Trace:
 register_inet6addr_notifier+0x13/0x20
 cxgb4_init_module+0x6c/0x1000 [cxgb4
 ? 0xffffffffa01d7000
 do_one_initcall+0x6c/0x3cc
 ? do_init_module+0x22/0x1f1
 ? rcu_read_lock_sched_held+0x97/0xb0
 ? kmem_cache_alloc_trace+0x325/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

If pci_register_driver fails, register inet6addr_notifier is
pointless. This patch fix the error path in cxgb4_init_module.

Fixes: b5a02f503caa ("cxgb4 : Update ipv6 address handling api")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 89179e3..4bc0c35 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6161,15 +6161,24 @@ static int __init cxgb4_init_module(void)
 
 	ret = pci_register_driver(&cxgb4_driver);
 	if (ret < 0)
-		debugfs_remove(cxgb4_debugfs_root);
+		goto err_pci;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (!inet6addr_registered) {
-		register_inet6addr_notifier(&cxgb4_inet6addr_notifier);
-		inet6addr_registered = true;
+		ret = register_inet6addr_notifier(&cxgb4_inet6addr_notifier);
+		if (ret)
+			pci_unregister_driver(&cxgb4_driver);
+		else
+			inet6addr_registered = true;
 	}
 #endif
 
+	if (ret == 0)
+		return ret;
+
+err_pci:
+	debugfs_remove(cxgb4_debugfs_root);
+
 	return ret;
 }
 
-- 
1.8.3.1


