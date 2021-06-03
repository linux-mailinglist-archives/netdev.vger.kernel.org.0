Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1639A789
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhFCRLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhFCRKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8106613F5;
        Thu,  3 Jun 2021 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740129;
        bh=Jz2m3vwdQJW755VD9qnYrdVv0PeunQwMOP0ikzH8SC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGflhgEu5Pfks9oo0AVlbD2rdcYk9t0ptElqmF6rFNnEXBjaaVyj6yWaDJ0TWNyGd
         Ki0x/syVe/PLzYkriogWYNLdgVXHy6omnPfK41DNxIUJkJm5lJ+eGVr1/+TKpwBLnj
         yVA/L4iuC/TFx7iDZElwM4lLDATrmqZF/0nk2CtixB+HbXlqZywllEk3blm/4l5fT5
         xmEC/xYV/r7LJym1mvevywLBSxbbCUtZS9SNOdeBi2F+4R0nscONXuTc/Hh90xL6Qh
         1wdYtXQK+7RbFUAPVR1tf97Y9OTxHmoAVVeLxazcW5MQGa8IBnkT/FILba403oJelr
         c+SrvYOFw8eeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/39] isdn: mISDN: netjet: Fix crash in nj_probe:
Date:   Thu,  3 Jun 2021 13:08:06 -0400
Message-Id: <20210603170829.3168708-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 9f6f852550d0e1b7735651228116ae9d300f69b3 ]

'nj_setup' in netjet.c might fail with -EIO and in this case
'card->irq' is initialized and is bigger than zero. A subsequent call to
'nj_release' will free the irq that has not been requested.

Fix this bug by deleting the previous assignment to 'card->irq' and just
keep the assignment before 'request_irq'.

The KASAN's log reveals it:

[    3.354615 ] WARNING: CPU: 0 PID: 1 at kernel/irq/manage.c:1826
free_irq+0x100/0x480
[    3.355112 ] Modules linked in:
[    3.355310 ] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
5.13.0-rc1-00144-g25a1298726e #13
[    3.355816 ] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    3.356552 ] RIP: 0010:free_irq+0x100/0x480
[    3.356820 ] Code: 6e 08 74 6f 4d 89 f4 e8 5e ac 09 00 4d 8b 74 24 18
4d 85 f6 75 e3 e8 4f ac 09 00 8b 75 c8 48 c7 c7 78 c1 2e 85 e8 e0 cf f5
ff <0f> 0b 48 8b 75 c0 4c 89 ff e8 72 33 0b 03 48 8b 43 40 4c 8b a0 80
[    3.358012 ] RSP: 0000:ffffc90000017b48 EFLAGS: 00010082
[    3.358357 ] RAX: 0000000000000000 RBX: ffff888104dc8000 RCX:
0000000000000000
[    3.358814 ] RDX: ffff8881003c8000 RSI: ffffffff8124a9e6 RDI:
00000000ffffffff
[    3.359272 ] RBP: ffffc90000017b88 R08: 0000000000000000 R09:
0000000000000000
[    3.359732 ] R10: ffffc900000179f0 R11: 0000000000001d04 R12:
0000000000000000
[    3.360195 ] R13: ffff888107dc6000 R14: ffff888107dc6928 R15:
ffff888104dc80a8
[    3.360652 ] FS:  0000000000000000(0000) GS:ffff88817bc00000(0000)
knlGS:0000000000000000
[    3.361170 ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.361538 ] CR2: 0000000000000000 CR3: 000000000582e000 CR4:
00000000000006f0
[    3.362003 ] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    3.362175 ] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[    3.362175 ] Call Trace:
[    3.362175 ]  nj_release+0x51/0x1e0
[    3.362175 ]  nj_probe+0x450/0x950
[    3.362175 ]  ? pci_device_remove+0x110/0x110
[    3.362175 ]  local_pci_probe+0x45/0xa0
[    3.362175 ]  pci_device_probe+0x12b/0x1d0
[    3.362175 ]  really_probe+0x2a9/0x610
[    3.362175 ]  driver_probe_device+0x90/0x1d0
[    3.362175 ]  ? mutex_lock_nested+0x1b/0x20
[    3.362175 ]  device_driver_attach+0x68/0x70
[    3.362175 ]  __driver_attach+0x124/0x1b0
[    3.362175 ]  ? device_driver_attach+0x70/0x70
[    3.362175 ]  bus_for_each_dev+0xbb/0x110
[    3.362175 ]  ? rdinit_setup+0x45/0x45
[    3.362175 ]  driver_attach+0x27/0x30
[    3.362175 ]  bus_add_driver+0x1eb/0x2a0
[    3.362175 ]  driver_register+0xa9/0x180
[    3.362175 ]  __pci_register_driver+0x82/0x90
[    3.362175 ]  ? w6692_init+0x38/0x38
[    3.362175 ]  nj_init+0x36/0x38
[    3.362175 ]  do_one_initcall+0x7f/0x3d0
[    3.362175 ]  ? rdinit_setup+0x45/0x45
[    3.362175 ]  ? rcu_read_lock_sched_held+0x4f/0x80
[    3.362175 ]  kernel_init_freeable+0x2aa/0x301
[    3.362175 ]  ? rest_init+0x2c0/0x2c0
[    3.362175 ]  kernel_init+0x18/0x190
[    3.362175 ]  ? rest_init+0x2c0/0x2c0
[    3.362175 ]  ? rest_init+0x2c0/0x2c0
[    3.362175 ]  ret_from_fork+0x1f/0x30
[    3.362175 ] Kernel panic - not syncing: panic_on_warn set ...
[    3.362175 ] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
5.13.0-rc1-00144-g25a1298726e #13
[    3.362175 ] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    3.362175 ] Call Trace:
[    3.362175 ]  dump_stack+0xba/0xf5
[    3.362175 ]  ? free_irq+0x100/0x480
[    3.362175 ]  panic+0x15a/0x3f2
[    3.362175 ]  ? __warn+0xf2/0x150
[    3.362175 ]  ? free_irq+0x100/0x480
[    3.362175 ]  __warn+0x108/0x150
[    3.362175 ]  ? free_irq+0x100/0x480
[    3.362175 ]  report_bug+0x119/0x1c0
[    3.362175 ]  handle_bug+0x3b/0x80
[    3.362175 ]  exc_invalid_op+0x18/0x70
[    3.362175 ]  asm_exc_invalid_op+0x12/0x20
[    3.362175 ] RIP: 0010:free_irq+0x100/0x480
[    3.362175 ] Code: 6e 08 74 6f 4d 89 f4 e8 5e ac 09 00 4d 8b 74 24 18
4d 85 f6 75 e3 e8 4f ac 09 00 8b 75 c8 48 c7 c7 78 c1 2e 85 e8 e0 cf f5
ff <0f> 0b 48 8b 75 c0 4c 89 ff e8 72 33 0b 03 48 8b 43 40 4c 8b a0 80
[    3.362175 ] RSP: 0000:ffffc90000017b48 EFLAGS: 00010082
[    3.362175 ] RAX: 0000000000000000 RBX: ffff888104dc8000 RCX:
0000000000000000
[    3.362175 ] RDX: ffff8881003c8000 RSI: ffffffff8124a9e6 RDI:
00000000ffffffff
[    3.362175 ] RBP: ffffc90000017b88 R08: 0000000000000000 R09:
0000000000000000
[    3.362175 ] R10: ffffc900000179f0 R11: 0000000000001d04 R12:
0000000000000000
[    3.362175 ] R13: ffff888107dc6000 R14: ffff888107dc6928 R15:
ffff888104dc80a8
[    3.362175 ]  ? vprintk+0x76/0x150
[    3.362175 ]  ? free_irq+0x100/0x480
[    3.362175 ]  nj_release+0x51/0x1e0
[    3.362175 ]  nj_probe+0x450/0x950
[    3.362175 ]  ? pci_device_remove+0x110/0x110
[    3.362175 ]  local_pci_probe+0x45/0xa0
[    3.362175 ]  pci_device_probe+0x12b/0x1d0
[    3.362175 ]  really_probe+0x2a9/0x610
[    3.362175 ]  driver_probe_device+0x90/0x1d0
[    3.362175 ]  ? mutex_lock_nested+0x1b/0x20
[    3.362175 ]  device_driver_attach+0x68/0x70
[    3.362175 ]  __driver_attach+0x124/0x1b0
[    3.362175 ]  ? device_driver_attach+0x70/0x70
[    3.362175 ]  bus_for_each_dev+0xbb/0x110
[    3.362175 ]  ? rdinit_setup+0x45/0x45
[    3.362175 ]  driver_attach+0x27/0x30
[    3.362175 ]  bus_add_driver+0x1eb/0x2a0
[    3.362175 ]  driver_register+0xa9/0x180
[    3.362175 ]  __pci_register_driver+0x82/0x90
[    3.362175 ]  ? w6692_init+0x38/0x38
[    3.362175 ]  nj_init+0x36/0x38
[    3.362175 ]  do_one_initcall+0x7f/0x3d0
[    3.362175 ]  ? rdinit_setup+0x45/0x45
[    3.362175 ]  ? rcu_read_lock_sched_held+0x4f/0x80
[    3.362175 ]  kernel_init_freeable+0x2aa/0x301
[    3.362175 ]  ? rest_init+0x2c0/0x2c0
[    3.362175 ]  kernel_init+0x18/0x190
[    3.362175 ]  ? rest_init+0x2c0/0x2c0
[    3.362175 ]  ? rest_init+0x2c0/0x2c0
[    3.362175 ]  ret_from_fork+0x1f/0x30
[    3.362175 ] Dumping ftrace buffer:
[    3.362175 ]    (ftrace buffer empty)
[    3.362175 ] Kernel Offset: disabled
[    3.362175 ] Rebooting in 1 seconds..

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/netjet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index ee925b58bbce..2a1ddd47a096 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -1100,7 +1100,6 @@ nj_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		card->typ = NETJET_S_TJ300;
 
 	card->base = pci_resource_start(pdev, 0);
-	card->irq = pdev->irq;
 	pci_set_drvdata(pdev, card);
 	err = setup_instance(card);
 	if (err)
-- 
2.30.2

