Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3054F3BCD72
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhGFLWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhGFLU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 327BC61C6A;
        Tue,  6 Jul 2021 11:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570244;
        bh=aoIJEK2ctr+vblvtjuxk51ES7NtmT3py9Q2KbvuflV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+mk2JvH3uRsvlFPva0uZXb7xjsyb77O6FxRoUu+M0Wb85QHO+pqq7z0Q1HZbrYax
         5akCdkJHlX8T1hKTopeii8Y7QBbsNVHAItqQ9KJjyeW+1QXnfPUru+5IPXbbfRbJYS
         IbC96GWE68yoZW2FDTx60gdkUlrFeWJC3Y2tZl+yuJeZ096VoREQA5WwHN56pNFJdb
         yaFhN5Ug2dJx/AAqJuPZSmMxts8+8TRKk+F3yLLXEkP/sTW8DPMsT3hoQ2sdgw45f2
         1dyS4tKW7vfbtdwS98nvFtalxYP1TyWNvF/EWKIvTRK8OtXqSzlsDGZOx5paZMc02m
         K+cWsY0uhaTYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 144/189] atm: nicstar: register the interrupt handler in the right place
Date:   Tue,  6 Jul 2021 07:13:24 -0400
Message-Id: <20210706111409.2058071-144-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 70b639dc41ad499384e41e106fce72e36805c9f2 ]

Because the error handling is sequential, the application of resources
should be carried out in the order of error handling, so the operation
of registering the interrupt handler should be put in front, so as not
to free the unregistered interrupt handler during error handling.

This log reveals it:

[    3.438724] Trying to free already-free IRQ 23
[    3.439060] WARNING: CPU: 5 PID: 1 at kernel/irq/manage.c:1825 free_irq+0xfb/0x480
[    3.440039] Modules linked in:
[    3.440257] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 5.12.4-g70e7f0549188-dirty #142
[    3.440793] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    3.441561] RIP: 0010:free_irq+0xfb/0x480
[    3.441845] Code: 6e 08 74 6f 4d 89 f4 e8 c3 78 09 00 4d 8b 74 24 18 4d 85 f6 75 e3 e8 b4 78 09 00 8b 75 c8 48 c7 c7 a0 ac d5 85 e8 95 d7 f5 ff <0f> 0b 48 8b 75 c0 4c 89 ff e8 87 c5 90 03 48 8b 43 40 4c 8b a0 80
[    3.443121] RSP: 0000:ffffc90000017b50 EFLAGS: 00010086
[    3.443483] RAX: 0000000000000000 RBX: ffff888107c6f000 RCX: 0000000000000000
[    3.443972] RDX: 0000000000000000 RSI: ffffffff8123f301 RDI: 00000000ffffffff
[    3.444462] RBP: ffffc90000017b90 R08: 0000000000000001 R09: 0000000000000003
[    3.444950] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[    3.444994] R13: ffff888107dc0000 R14: ffff888104f6bf00 R15: ffff888107c6f0a8
[    3.444994] FS:  0000000000000000(0000) GS:ffff88817bd40000(0000) knlGS:0000000000000000
[    3.444994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.444994] CR2: 0000000000000000 CR3: 000000000642e000 CR4: 00000000000006e0
[    3.444994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.444994] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.444994] Call Trace:
[    3.444994]  ns_init_card_error+0x18e/0x250
[    3.444994]  nicstar_init_one+0x10d2/0x1130
[    3.444994]  local_pci_probe+0x4a/0xb0
[    3.444994]  pci_device_probe+0x126/0x1d0
[    3.444994]  ? pci_device_remove+0x100/0x100
[    3.444994]  really_probe+0x27e/0x650
[    3.444994]  driver_probe_device+0x84/0x1d0
[    3.444994]  ? mutex_lock_nested+0x16/0x20
[    3.444994]  device_driver_attach+0x63/0x70
[    3.444994]  __driver_attach+0x117/0x1a0
[    3.444994]  ? device_driver_attach+0x70/0x70
[    3.444994]  bus_for_each_dev+0xb6/0x110
[    3.444994]  ? rdinit_setup+0x40/0x40
[    3.444994]  driver_attach+0x22/0x30
[    3.444994]  bus_add_driver+0x1e6/0x2a0
[    3.444994]  driver_register+0xa4/0x180
[    3.444994]  __pci_register_driver+0x77/0x80
[    3.444994]  ? uPD98402_module_init+0xd/0xd
[    3.444994]  nicstar_init+0x1f/0x75
[    3.444994]  do_one_initcall+0x7a/0x3d0
[    3.444994]  ? rdinit_setup+0x40/0x40
[    3.444994]  ? rcu_read_lock_sched_held+0x4a/0x70
[    3.444994]  kernel_init_freeable+0x2a7/0x2f9
[    3.444994]  ? rest_init+0x2c0/0x2c0
[    3.444994]  kernel_init+0x13/0x180
[    3.444994]  ? rest_init+0x2c0/0x2c0
[    3.444994]  ? rest_init+0x2c0/0x2c0
[    3.444994]  ret_from_fork+0x1f/0x30
[    3.444994] Kernel panic - not syncing: panic_on_warn set ...
[    3.444994] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 5.12.4-g70e7f0549188-dirty #142
[    3.444994] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    3.444994] Call Trace:
[    3.444994]  dump_stack+0xba/0xf5
[    3.444994]  ? free_irq+0xfb/0x480
[    3.444994]  panic+0x155/0x3ed
[    3.444994]  ? __warn+0xed/0x150
[    3.444994]  ? free_irq+0xfb/0x480
[    3.444994]  __warn+0x103/0x150
[    3.444994]  ? free_irq+0xfb/0x480
[    3.444994]  report_bug+0x119/0x1c0
[    3.444994]  handle_bug+0x3b/0x80
[    3.444994]  exc_invalid_op+0x18/0x70
[    3.444994]  asm_exc_invalid_op+0x12/0x20
[    3.444994] RIP: 0010:free_irq+0xfb/0x480
[    3.444994] Code: 6e 08 74 6f 4d 89 f4 e8 c3 78 09 00 4d 8b 74 24 18 4d 85 f6 75 e3 e8 b4 78 09 00 8b 75 c8 48 c7 c7 a0 ac d5 85 e8 95 d7 f5 ff <0f> 0b 48 8b 75 c0 4c 89 ff e8 87 c5 90 03 48 8b 43 40 4c 8b a0 80
[    3.444994] RSP: 0000:ffffc90000017b50 EFLAGS: 00010086
[    3.444994] RAX: 0000000000000000 RBX: ffff888107c6f000 RCX: 0000000000000000
[    3.444994] RDX: 0000000000000000 RSI: ffffffff8123f301 RDI: 00000000ffffffff
[    3.444994] RBP: ffffc90000017b90 R08: 0000000000000001 R09: 0000000000000003
[    3.444994] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[    3.444994] R13: ffff888107dc0000 R14: ffff888104f6bf00 R15: ffff888107c6f0a8
[    3.444994]  ? vprintk_func+0x71/0x110
[    3.444994]  ns_init_card_error+0x18e/0x250
[    3.444994]  nicstar_init_one+0x10d2/0x1130
[    3.444994]  local_pci_probe+0x4a/0xb0
[    3.444994]  pci_device_probe+0x126/0x1d0
[    3.444994]  ? pci_device_remove+0x100/0x100
[    3.444994]  really_probe+0x27e/0x650
[    3.444994]  driver_probe_device+0x84/0x1d0
[    3.444994]  ? mutex_lock_nested+0x16/0x20
[    3.444994]  device_driver_attach+0x63/0x70
[    3.444994]  __driver_attach+0x117/0x1a0
[    3.444994]  ? device_driver_attach+0x70/0x70
[    3.444994]  bus_for_each_dev+0xb6/0x110
[    3.444994]  ? rdinit_setup+0x40/0x40
[    3.444994]  driver_attach+0x22/0x30
[    3.444994]  bus_add_driver+0x1e6/0x2a0
[    3.444994]  driver_register+0xa4/0x180
[    3.444994]  __pci_register_driver+0x77/0x80
[    3.444994]  ? uPD98402_module_init+0xd/0xd
[    3.444994]  nicstar_init+0x1f/0x75
[    3.444994]  do_one_initcall+0x7a/0x3d0
[    3.444994]  ? rdinit_setup+0x40/0x40
[    3.444994]  ? rcu_read_lock_sched_held+0x4a/0x70
[    3.444994]  kernel_init_freeable+0x2a7/0x2f9
[    3.444994]  ? rest_init+0x2c0/0x2c0
[    3.444994]  kernel_init+0x13/0x180
[    3.444994]  ? rest_init+0x2c0/0x2c0
[    3.444994]  ? rest_init+0x2c0/0x2c0
[    3.444994]  ret_from_fork+0x1f/0x30
[    3.444994] Dumping ftrace buffer:
[    3.444994]    (ftrace buffer empty)
[    3.444994] Kernel Offset: disabled
[    3.444994] Rebooting in 1 seconds..

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/nicstar.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 3a38720acd0e..bc5a6ab6fa4b 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -527,6 +527,15 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 	/* Set the VPI/VCI MSb mask to zero so we can receive OAM cells */
 	writel(0x00000000, card->membase + VPM);
 
+	card->intcnt = 0;
+	if (request_irq
+	    (pcidev->irq, &ns_irq_handler, IRQF_SHARED, "nicstar", card) != 0) {
+		pr_err("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
+		error = 9;
+		ns_init_card_error(card, error);
+		return error;
+	}
+
 	/* Initialize TSQ */
 	card->tsq.org = dma_alloc_coherent(&card->pcidev->dev,
 					   NS_TSQSIZE + NS_TSQ_ALIGNMENT,
@@ -753,15 +762,6 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 
 	card->efbie = 1;
 
-	card->intcnt = 0;
-	if (request_irq
-	    (pcidev->irq, &ns_irq_handler, IRQF_SHARED, "nicstar", card) != 0) {
-		printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
-		error = 9;
-		ns_init_card_error(card, error);
-		return error;
-	}
-
 	/* Register device */
 	card->atmdev = atm_dev_register("nicstar", &card->pcidev->dev, &atm_ops,
 					-1, NULL);
-- 
2.30.2

