Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9953ADF30
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFTP0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 11:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFTP0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 11:26:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD673C06175F;
        Sun, 20 Jun 2021 08:24:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id e33so12075790pgm.3;
        Sun, 20 Jun 2021 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NH9CnDCf4dOIi/MyttcxHJ///GcGlwnO6jHm1dl6ihs=;
        b=Ws8GjxQtg5jiSYyz5VkGO8KBhHvdsLjD0RGrrJgWMedBo6PKaa45rR9poe21ipN2O0
         vFHCAIZa1yuSuTdjBQjzvm2o/BIpGJnFGxoyU9szuDacB32KIzMmpE0nABQPjjmXYd8H
         SrainT7BZ+AusfR50thnMOMhkyU2Jd7icRBZhYsLrPnZAH0O/3bSC+Wq1s5t2qR2+EcT
         XjWF6imQ7kxqydFpdrgXvkbQ9tmDyWRgOnd1HBgPRpsExIFipzYIdAwf/pghE3QQtDBr
         qapI263/VS4rWxXTHhxCqqR25X5lmfy2yU/+odlp9mpB5iVfgt5nTIQz3KOxGQ5QG+WR
         nAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NH9CnDCf4dOIi/MyttcxHJ///GcGlwnO6jHm1dl6ihs=;
        b=PjyQGcyC426OIfH2KyQyNMJfwEMKrgmkcSISzqyIU7i+sLC7NByvBW5BKigZD17ThW
         vCoJ59Q6ctbrD6TP7qK/FIMfjms5MgLm3vERzWuFOlP9Fn1gT78jYn5OKMhWfhAsNQAQ
         LcwuOIPJXqjcOr0k/tC9HQa7dcJbmQVkyU3AjZ0h+nuPSXcKHUQ8fjdjYxuDpAlEKlVH
         x9pljXjboM37MrWQnrGvnl5dZFrNlt+LOlzltYj6C20061/z1wJxnHfbLqQXVmlWHXrX
         Wcd2OKidnkbO0PQi2gcmtEeD1uBIdCwf/MFcEcE+gWEcdLxhCb2jB55NCofe5zMtAqDo
         j6uw==
X-Gm-Message-State: AOAM532ggUOtNWCAqClNC2iNvFLMrl6qk5dwIjdpBluMFNKOIytoRuR7
        GP6qFfKXeXhsVVrJdx+dVw==
X-Google-Smtp-Source: ABdhPJw7dIdj+f5JUhn7TnaA1YmYHKcLH8d+q1JuIsxh3FIy8PQuWS99Y4IdzTkXtscKpFe8mjdhEA==
X-Received: by 2002:a63:921e:: with SMTP id o30mr11834589pgd.346.1624202673364;
        Sun, 20 Jun 2021 08:24:33 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id a15sm13250356pfl.100.2021.06.20.08.24.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jun 2021 08:24:33 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH 1/2] atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
Date:   Sun, 20 Jun 2021 15:24:14 +0000
Message-Id: <1624202655-6766-2-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624202655-6766-1-git-send-email-zheyuma97@gmail.com>
References: <1624202655-6766-1-git-send-email-zheyuma97@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/atm/nicstar.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 5c7e4df159b9..e031f6d74e7e 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -839,10 +839,12 @@ static void ns_init_card_error(ns_dev *card, int error)
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
2.17.6

