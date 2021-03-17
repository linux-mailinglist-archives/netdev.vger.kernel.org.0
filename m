Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDCE33E329
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCQA4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhCQAzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21AC464F99;
        Wed, 17 Mar 2021 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942545;
        bh=YapNB5yGzktcF0FAk7iHZ6bycnfo0ewkC8im19E02XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pve15W4SQyxh8yYK4yxvVTEAOWveODdetI6WaPpPB/1U4s471pqZdyfg7scoxdxi2
         7MXPfEsN4g+3EKas2CLYowWlmQBiyqz7vPR08pqmubnXmuRxoAAnFoS0hSHclQcLG6
         rSgdvF57KCTXPCxWtjFGC5RTcOMRK378dBnxZlP4XNspkRrg/rrCYlQ5qJGdbkHxaK
         lERr2Q88zW3Ckyq5hcxmUnDok9Bb0vmLR/qIjXf8R6Lh3NfnfUJYpnllPyZblBDGab
         EjAp+CsDBMT0WCxDpkl+gxhDHx3Kvc6c4CkALOa8bzM5xzYcX91BSdVm0FiSv7re6I
         6BDJyBUfBenvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 07/61] atm: lanai: dont run lanai_dev_close if not open
Date:   Tue, 16 Mar 2021 20:54:41 -0400
Message-Id: <20210317005536.724046-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit a2bd45834e83d6c5a04d397bde13d744a4812dfc ]

lanai_dev_open() can fail. When it fail, lanai->base is unmapped and the
pci device is disabled. The caller, lanai_init_one(), then tries to run
atm_dev_deregister(). This will subsequently call lanai_dev_close() and
use the already released MMIO area.

To fix this issue, set the lanai->base to NULL if open fail,
and test the flag in lanai_dev_close().

[    8.324153] lanai: lanai_start() failed, err=19
[    8.324819] lanai(itf 0): shutting down interface
[    8.325211] BUG: unable to handle page fault for address: ffffc90000180024
[    8.325781] #PF: supervisor write access in kernel mode
[    8.326215] #PF: error_code(0x0002) - not-present page
[    8.326641] PGD 100000067 P4D 100000067 PUD 100139067 PMD 10013a067 PTE 0
[    8.327206] Oops: 0002 [#1] SMP KASAN NOPTI
[    8.327557] CPU: 0 PID: 95 Comm: modprobe Not tainted 5.11.0-rc7-00090-gdcc0b49040c7 #12
[    8.328229] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-4
[    8.329145] RIP: 0010:lanai_dev_close+0x4f/0xe5 [lanai]
[    8.329587] Code: 00 48 c7 c7 00 d3 01 c0 e8 49 4e 0a c2 48 8d bd 08 02 00 00 e8 6e 52 14 c1 48 80
[    8.330917] RSP: 0018:ffff8881029ef680 EFLAGS: 00010246
[    8.331196] RAX: 000000000003fffe RBX: ffff888102fb4800 RCX: ffffffffc001a98a
[    8.331572] RDX: ffffc90000180000 RSI: 0000000000000246 RDI: ffff888102fb4000
[    8.331948] RBP: ffff888102fb4000 R08: ffffffff8115da8a R09: ffffed102053deaa
[    8.332326] R10: 0000000000000003 R11: ffffed102053dea9 R12: ffff888102fb48a4
[    8.332701] R13: ffffffffc00123c0 R14: ffff888102fb4b90 R15: ffff888102fb4b88
[    8.333077] FS:  00007f08eb9056a0(0000) GS:ffff88815b400000(0000) knlGS:0000000000000000
[    8.333502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.333806] CR2: ffffc90000180024 CR3: 0000000102a28000 CR4: 00000000000006f0
[    8.334182] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.334557] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    8.334932] Call Trace:
[    8.335066]  atm_dev_deregister+0x161/0x1a0 [atm]
[    8.335324]  lanai_init_one.cold+0x20c/0x96d [lanai]
[    8.335594]  ? lanai_send+0x2a0/0x2a0 [lanai]
[    8.335831]  local_pci_probe+0x6f/0xb0
[    8.336039]  pci_device_probe+0x171/0x240
[    8.336255]  ? pci_device_remove+0xe0/0xe0
[    8.336475]  ? kernfs_create_link+0xb6/0x110
[    8.336704]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
[    8.336983]  really_probe+0x161/0x420
[    8.337181]  driver_probe_device+0x6d/0xd0
[    8.337401]  device_driver_attach+0x82/0x90
[    8.337626]  ? device_driver_attach+0x90/0x90
[    8.337859]  __driver_attach+0x60/0x100
[    8.338065]  ? device_driver_attach+0x90/0x90
[    8.338298]  bus_for_each_dev+0xe1/0x140
[    8.338511]  ? subsys_dev_iter_exit+0x10/0x10
[    8.338745]  ? klist_node_init+0x61/0x80
[    8.338956]  bus_add_driver+0x254/0x2a0
[    8.339164]  driver_register+0xd3/0x150
[    8.339370]  ? 0xffffffffc0028000
[    8.339550]  do_one_initcall+0x84/0x250
[    8.339755]  ? trace_event_raw_event_initcall_finish+0x150/0x150
[    8.340076]  ? free_vmap_area_noflush+0x1a5/0x5c0
[    8.340329]  ? unpoison_range+0xf/0x30
[    8.340532]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    8.340806]  ? unpoison_range+0xf/0x30
[    8.341014]  ? unpoison_range+0xf/0x30
[    8.341217]  do_init_module+0xf8/0x350
[    8.341419]  load_module+0x3fe6/0x4340
[    8.341621]  ? vm_unmap_ram+0x1d0/0x1d0
[    8.341826]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    8.342101]  ? module_frob_arch_sections+0x20/0x20
[    8.342358]  ? __do_sys_finit_module+0x108/0x170
[    8.342604]  __do_sys_finit_module+0x108/0x170
[    8.342841]  ? __ia32_sys_init_module+0x40/0x40
[    8.343083]  ? file_open_root+0x200/0x200
[    8.343298]  ? do_sys_open+0x85/0xe0
[    8.343491]  ? filp_open+0x50/0x50
[    8.343675]  ? exit_to_user_mode_prepare+0xfc/0x130
[    8.343935]  do_syscall_64+0x33/0x40
[    8.344132]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    8.344401] RIP: 0033:0x7f08eb887cf7
[    8.344594] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f7 48 89 d6 41
[    8.345565] RSP: 002b:00007ffcd5c98ad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    8.345962] RAX: ffffffffffffffda RBX: 00000000008fea70 RCX: 00007f08eb887cf7
[    8.346336] RDX: 0000000000000000 RSI: 00000000008fd9e0 RDI: 0000000000000003
[    8.346711] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
[    8.347085] R10: 00007f08eb8eb300 R11: 0000000000000246 R12: 00000000008fd9e0
[    8.347460] R13: 0000000000000000 R14: 00000000008fddd0 R15: 0000000000000001
[    8.347836] Modules linked in: lanai(+) atm
[    8.348065] CR2: ffffc90000180024
[    8.348244] ---[ end trace 7fdc1c668f2003e5 ]---
[    8.348490] RIP: 0010:lanai_dev_close+0x4f/0xe5 [lanai]
[    8.348772] Code: 00 48 c7 c7 00 d3 01 c0 e8 49 4e 0a c2 48 8d bd 08 02 00 00 e8 6e 52 14 c1 48 80
[    8.349745] RSP: 0018:ffff8881029ef680 EFLAGS: 00010246
[    8.350022] RAX: 000000000003fffe RBX: ffff888102fb4800 RCX: ffffffffc001a98a
[    8.350397] RDX: ffffc90000180000 RSI: 0000000000000246 RDI: ffff888102fb4000
[    8.350772] RBP: ffff888102fb4000 R08: ffffffff8115da8a R09: ffffed102053deaa
[    8.351151] R10: 0000000000000003 R11: ffffed102053dea9 R12: ffff888102fb48a4
[    8.351525] R13: ffffffffc00123c0 R14: ffff888102fb4b90 R15: ffff888102fb4b88
[    8.351918] FS:  00007f08eb9056a0(0000) GS:ffff88815b400000(0000) knlGS:0000000000000000
[    8.352343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.352647] CR2: ffffc90000180024 CR3: 0000000102a28000 CR4: 00000000000006f0
[    8.353022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.353397] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    8.353958] modprobe (95) used greatest stack depth: 26216 bytes left

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/lanai.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index d7277c26e423..32d7aa141d96 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -2233,6 +2233,7 @@ static int lanai_dev_open(struct atm_dev *atmdev)
 	conf1_write(lanai);
 #endif
 	iounmap(lanai->base);
+	lanai->base = NULL;
     error_pci:
 	pci_disable_device(lanai->pci);
     error:
@@ -2245,6 +2246,8 @@ static int lanai_dev_open(struct atm_dev *atmdev)
 static void lanai_dev_close(struct atm_dev *atmdev)
 {
 	struct lanai_dev *lanai = (struct lanai_dev *) atmdev->dev_data;
+	if (lanai->base==NULL)
+		return;
 	printk(KERN_INFO DEV_LABEL "(itf %d): shutting down interface\n",
 	    lanai->number);
 	lanai_timed_poll_stop(lanai);
@@ -2552,7 +2555,7 @@ static int lanai_init_one(struct pci_dev *pci,
 	struct atm_dev *atmdev;
 	int result;
 
-	lanai = kmalloc(sizeof(*lanai), GFP_KERNEL);
+	lanai = kzalloc(sizeof(*lanai), GFP_KERNEL);
 	if (lanai == NULL) {
 		printk(KERN_ERR DEV_LABEL
 		       ": couldn't allocate dev_data structure!\n");
-- 
2.30.1

