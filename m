Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B78E3BD5E7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343545AbhGFMZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237215AbhGFLgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B7C861EDC;
        Tue,  6 Jul 2021 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570771;
        bh=vy4RnChkAOaMSGYWO0sTaLXzSq3vBxE0L7cNyPbjSRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEmnD0bRGT9tljS4x1JwOOa9p5oRZnRClB4kRB3H8YJ1LYc6w3OVi6cAj+6di5DLF
         763OcyNh/flP3Sn3GEV4LNWGiGANonHhq9pFOBmqNAl60GhSOsIDPl0XVWXB0htgGv
         IhUaC3x7rQ2u9hVUsoIM3r7ySmjTTIcSXtpI2mnEuBewhOlM/ZsGmLT7yjQEJkKoE+
         UEwBR/j/39hcJviBJd/q4+2p02Wdq1Z0hlRNbPE/qUlvs3SGTRVo/ny6MmT7uf9q5v
         OSTnBasDqnkrGUpFxIzcrSmPD36uRARf9S/kOEPv/lh+htnuf2V4gsRcLa+lTIDk2Y
         Kzmnwd8OLr7+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 54/74] atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
Date:   Tue,  6 Jul 2021 07:24:42 -0400
Message-Id: <20210706112502.2064236-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 6a1e5a4af17e440dd82a58a2c5f40ff17a82b722 ]

When 'nicstar_init_one' fails, 'ns_init_card_error' will be executed for
error handling, but the correct memory free function should be used,
otherwise it will cause an error. Since 'card->rsq.org' and
'card->tsq.org' are allocated using 'dma_alloc_coherent' function, they
should be freed using 'dma_free_coherent'.

Fix this by using 'dma_free_coherent' instead of 'kfree'

This log reveals it:

[    3.440294] kernel BUG at mm/slub.c:4206!
[    3.441059] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[    3.441430] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.12.4-g70e7f0549188-dirty #141
[    3.441986] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    3.442780] RIP: 0010:kfree+0x26a/0x300
[    3.443065] Code: e8 3a c3 b9 ff e9 d6 fd ff ff 49 8b 45 00 31 db a9 00 00 01 00 75 4d 49 8b 45 00 a9 00 00 01 00 75 0a 49 8b 45 08 a8 01 75 02 <0f> 0b 89 d9 b8 00 10 00 00 be 06 00 00 00 48 d3 e0 f7 d8 48 63 d0
[    3.443396] RSP: 0000:ffffc90000017b70 EFLAGS: 00010246
[    3.443396] RAX: dead000000000100 RBX: 0000000000000000 RCX: 0000000000000000
[    3.443396] RDX: 0000000000000000 RSI: ffffffff85d3df94 RDI: ffffffff85df38e6
[    3.443396] RBP: ffffc90000017b90 R08: 0000000000000001 R09: 0000000000000001
[    3.443396] R10: 0000000000000000 R11: 0000000000000001 R12: ffff888107dc0000
[    3.443396] R13: ffffea00001f0100 R14: ffff888101a8bf00 R15: ffff888107dc0160
[    3.443396] FS:  0000000000000000(0000) GS:ffff88817bc80000(0000) knlGS:0000000000000000
[    3.443396] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.443396] CR2: 0000000000000000 CR3: 000000000642e000 CR4: 00000000000006e0
[    3.443396] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.443396] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.443396] Call Trace:
[    3.443396]  ns_init_card_error+0x12c/0x220
[    3.443396]  nicstar_init_one+0x10d2/0x1130
[    3.443396]  local_pci_probe+0x4a/0xb0
[    3.443396]  pci_device_probe+0x126/0x1d0
[    3.443396]  ? pci_device_remove+0x100/0x100
[    3.443396]  really_probe+0x27e/0x650
[    3.443396]  driver_probe_device+0x84/0x1d0
[    3.443396]  ? mutex_lock_nested+0x16/0x20
[    3.443396]  device_driver_attach+0x63/0x70
[    3.443396]  __driver_attach+0x117/0x1a0
[    3.443396]  ? device_driver_attach+0x70/0x70
[    3.443396]  bus_for_each_dev+0xb6/0x110
[    3.443396]  ? rdinit_setup+0x40/0x40
[    3.443396]  driver_attach+0x22/0x30
[    3.443396]  bus_add_driver+0x1e6/0x2a0
[    3.443396]  driver_register+0xa4/0x180
[    3.443396]  __pci_register_driver+0x77/0x80
[    3.443396]  ? uPD98402_module_init+0xd/0xd
[    3.443396]  nicstar_init+0x1f/0x75
[    3.443396]  do_one_initcall+0x7a/0x3d0
[    3.443396]  ? rdinit_setup+0x40/0x40
[    3.443396]  ? rcu_read_lock_sched_held+0x4a/0x70
[    3.443396]  kernel_init_freeable+0x2a7/0x2f9
[    3.443396]  ? rest_init+0x2c0/0x2c0
[    3.443396]  kernel_init+0x13/0x180
[    3.443396]  ? rest_init+0x2c0/0x2c0
[    3.443396]  ? rest_init+0x2c0/0x2c0
[    3.443396]  ret_from_fork+0x1f/0x30
[    3.443396] Modules linked in:
[    3.443396] Dumping ftrace buffer:
[    3.443396]    (ftrace buffer empty)
[    3.458593] ---[ end trace 3c6f8f0d8ef59bcd ]---
[    3.458922] RIP: 0010:kfree+0x26a/0x300
[    3.459198] Code: e8 3a c3 b9 ff e9 d6 fd ff ff 49 8b 45 00 31 db a9 00 00 01 00 75 4d 49 8b 45 00 a9 00 00 01 00 75 0a 49 8b 45 08 a8 01 75 02 <0f> 0b 89 d9 b8 00 10 00 00 be 06 00 00 00 48 d3 e0 f7 d8 48 63 d0
[    3.460499] RSP: 0000:ffffc90000017b70 EFLAGS: 00010246
[    3.460870] RAX: dead000000000100 RBX: 0000000000000000 RCX: 0000000000000000
[    3.461371] RDX: 0000000000000000 RSI: ffffffff85d3df94 RDI: ffffffff85df38e6
[    3.461873] RBP: ffffc90000017b90 R08: 0000000000000001 R09: 0000000000000001
[    3.462372] R10: 0000000000000000 R11: 0000000000000001 R12: ffff888107dc0000
[    3.462871] R13: ffffea00001f0100 R14: ffff888101a8bf00 R15: ffff888107dc0160
[    3.463368] FS:  0000000000000000(0000) GS:ffff88817bc80000(0000) knlGS:0000000000000000
[    3.463949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.464356] CR2: 0000000000000000 CR3: 000000000642e000 CR4: 00000000000006e0
[    3.464856] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.465356] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.465860] Kernel panic - not syncing: Fatal exception
[    3.466370] Dumping ftrace buffer:
[    3.466616]    (ftrace buffer empty)
[    3.466871] Kernel Offset: disabled
[    3.467122] Rebooting in 1 seconds..

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/nicstar.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 5ec7b6a60145..f1e8aa26d284 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -837,10 +837,12 @@ static void ns_init_card_error(ns_dev *card, int error)
 			dev_kfree_skb_any(hb);
 	}
 	if (error >= 12) {
-		kfree(card->rsq.org);
+		dma_free_coherent(&card->pcidev->dev, NS_RSQSIZE + NS_RSQ_ALIGNMENT,
+				card->rsq.org, card->rsq.dma);
 	}
 	if (error >= 11) {
-		kfree(card->tsq.org);
+		dma_free_coherent(&card->pcidev->dev, NS_TSQSIZE + NS_TSQ_ALIGNMENT,
+				card->tsq.org, card->tsq.dma);
 	}
 	if (error >= 10) {
 		free_irq(card->pcidev->irq, card);
-- 
2.30.2

