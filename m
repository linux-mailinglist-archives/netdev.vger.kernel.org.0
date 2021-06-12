Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85FE3A4E6F
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 13:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFLL7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 07:59:54 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:46621 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLL7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 07:59:53 -0400
Received: by mail-pg1-f175.google.com with SMTP id n12so4650069pgs.13;
        Sat, 12 Jun 2021 04:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bwvlryTiSgujlZJpF63qtpHPRb6VSZenr+3nap8+zgc=;
        b=UhcsebIKXP2RJfb9Oc4Q32nqUTNvcCQxHOUnZxtjkJc1D3yQVE5QUgb6ljAhCaNHkY
         H/0ORk2w7QijiVWF0WJaV7W1vTRkBz3kCgOpWEaw+WhndhQhLXVjsDD/vLAROUtmjXW9
         TkZT6jeBJerRSNKSRdtRbfhU0K5SdNR8HhsiihhTI5GiieDp88yqnat+ctI+v2L15kHo
         QEQu4155yGlmOzKOcjctzgUJoi8F4B0BO3wcLO/d5zqnEJArw9PEr6MFqNeRviWdyPlB
         TlAQvW3KwTPIcmecye7hH+N2gGu2NM/SPVNnvb6Uu37qjUuH914Def2F+/IzLHV7+N1d
         Xw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bwvlryTiSgujlZJpF63qtpHPRb6VSZenr+3nap8+zgc=;
        b=lobwGVD7F97OMdDYEA/d2mEfubd0x8TlSnvoEJ+NoVRxyGGp5zgifx0Hki3Guzcykh
         hzafXQeeielCd2wRtutodkqWgHKSvWDzFj4ihjb45441/dF0HQUfqNrqZtz4nZPgU1Fw
         bVSR3C5DvSyJcmm+/kuxxHaPguD3cTqc7MRtqTqOzZFBFd8TpGK+WsiFjO/ORtEaoGFy
         qF1cgrbESYZA6FuUaM66TgbCN9/8PCNaTNpyOyNxNUpyhA7tWd2x7Bd7EP/eOIgOyFLm
         GaFL2F6jvErvs1T+yVe7BXT37OOM0XljVuouR+d45o9nHhcCKf96PD8DdtnXe9R/0qg/
         zNsg==
X-Gm-Message-State: AOAM533mLqMEEHhR6S0vTe0MGIJGr4n4rmw8cAn17+UXzD/QgkJgXiem
        TBaYQ+JkfrGIePnAU9N4JA==
X-Google-Smtp-Source: ABdhPJxPD56XPvPNxaPYIRASdNI2KnDJ9KQ5cIHWIt3JI27kJIjrn+7oP/+fJc8T6vSDpRaB1GDUjw==
X-Received: by 2002:a62:be03:0:b029:2e9:fe8c:effe with SMTP id l3-20020a62be030000b02902e9fe8ceffemr12671839pff.34.1623499003016;
        Sat, 12 Jun 2021 04:56:43 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id z6sm3359993pgs.24.2021.06.12.04.56.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jun 2021 04:56:42 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     klassert@kernel.org, davem@davemloft.net, kuba@kernel.org,
        snelson@pensando.io, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] net: 3com: 3c59x: add a check against null pointer dereference
Date:   Sat, 12 Jun 2021 11:56:18 +0000
Message-Id: <1623498978-30759-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the driver is processing the interrupt, it will read the value of
the register to determine the status of the device. If the device is in
an incorrect state, the driver may mistakenly enter this branch. At this
time, the dma buffer has not been allocated, which will result in a null
pointer dereference.

Fix this by checking whether the buffer is allocated.

This log reveals it:

BUG: kernel NULL pointer dereference, address: 0000000000000070
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.12.4-g70e7f0549188-dirty #88
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:_vortex_interrupt+0x323/0x670
Code: 84 d4 00 00 00 e8 bd e9 60 fe 48 8b 45 d8 48 83 c0 0c 48 89 c6 bf 00 10 00 00 e8 98 d0 f0 fe 48 8b 45 d0 48 8b 80 d8 01 00 00 <8b> 40 70 83 c0 03 89 c0 83 e0 fc 48 89 c2 48 8b 45 d0 48 8b b0 e0
RSP: 0018:ffffc900001a4dd0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888115da0580 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81bf710e RDI: 0000000000001000
RBP: ffffc900001a4e30 R08: ffff8881008edbc0 R09: 00000000fffffffe
R10: 0000000000000001 R11: 00000000a5c81234 R12: ffff8881049530a8
R13: 0000000000000000 R14: ffffffff87313288 R15: ffff888108c92000
FS:  0000000000000000(0000) GS:ffff88817b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000070 CR3: 00000001198c2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ? _raw_spin_lock_irqsave+0x81/0xa0
 vortex_boomerang_interrupt+0x56/0xc10
 ? __this_cpu_preempt_check+0x1c/0x20
 __handle_irq_event_percpu+0x58/0x3e0
 handle_irq_event_percpu+0x3a/0x90
 handle_irq_event+0x3e/0x60
 handle_fasteoi_irq+0xc7/0x1d0
 __common_interrupt+0x84/0x150
 common_interrupt+0xb4/0xd0
 </IRQ>
 asm_common_interrupt+0x1e/0x40
RIP: 0010:native_safe_halt+0x17/0x20
Code: 07 0f 00 2d 3b 3e 4b 00 f4 5d c3 0f 1f 84 00 00 00 00 00 8b 05 42 a9 72 02 55 48 89 e5 85 c0 7e 07 0f 00 2d 1b 3e 4b 00 fb f4 <5d> c3 cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 e8 92 4a ff
RSP: 0018:ffffc900000afe90 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8666cafb RDI: ffffffff865058de
RBP: ffffc900000afe90 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff87313288
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881008ed1c0
 default_idle+0xe/0x20
 arch_cpu_idle+0xf/0x20
 default_idle_call+0x73/0x250
 do_idle+0x1f5/0x2d0
 cpu_startup_entry+0x1d/0x20
 start_secondary+0x11f/0x160
 secondary_startup_64_no_verify+0xb0/0xbb
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: 0000000000000070
---[ end trace 0735407a540147e1 ]---
RIP: 0010:_vortex_interrupt+0x323/0x670
Code: 84 d4 00 00 00 e8 bd e9 60 fe 48 8b 45 d8 48 83 c0 0c 48 89 c6 bf 00 10 00 00 e8 98 d0 f0 fe 48 8b 45 d0 48 8b 80 d8 01 00 00 <8b> 40 70 83 c0 03 89 c0 83 e0 fc 48 89 c2 48 8b 45 d0 48 8b b0 e0
RSP: 0018:ffffc900001a4dd0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888115da0580 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81bf710e RDI: 0000000000001000
RBP: ffffc900001a4e30 R08: ffff8881008edbc0 R09: 00000000fffffffe
R10: 0000000000000001 R11: 00000000a5c81234 R12: ffff8881049530a8
R13: 0000000000000000 R14: ffffffff87313288 R15: ffff888108c92000
FS:  0000000000000000(0000) GS:ffff88817b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000070 CR3: 00000001198c2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Kernel panic - not syncing: Fatal exception in interrupt
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/3com/3c59x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 741c67e546d4..e27901ded7a0 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2300,7 +2300,7 @@ _vortex_interrupt(int irq, struct net_device *dev)
 		}
 
 		if (status & DMADone) {
-			if (ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) {
+			if ((ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) && vp->tx_skb_dma) {
 				iowrite16(0x1000, ioaddr + Wn7_MasterStatus); /* Ack the event. */
 				dma_unmap_single(vp->gendev, vp->tx_skb_dma, (vp->tx_skb->len + 3) & ~3, DMA_TO_DEVICE);
 				pkts_compl++;
-- 
2.17.6

