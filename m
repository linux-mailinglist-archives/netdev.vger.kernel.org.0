Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26401312234
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 08:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBGHVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 02:21:13 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:51550 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGHVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 02:21:05 -0500
Received: by mail-io1-f70.google.com with SMTP id j2so9367974iow.18
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 23:20:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xUTyJq/1MYIrp6IYEy72AdzuPFYzDzCFxmNycYmGDEQ=;
        b=jislfIhoFkQ1GbkJ/LenmiYNGJe0sYihGgrPxv3c6IbdKKs/51K5MhT1UO1BfurqXP
         8AisA4LydeTJenij9fNlU5XRYJjCVio6exx4y1zgfDOxJDRtQKC36qADV1+Pn7x0iv7q
         jgcdcA44Y2aE5MKPHOly255vQqKI3pYuIFNrEZ0/oqIphjInDf08i2LVrq3J/Sjk5fHT
         d45lfbu2TPs8V4nTb4NYILFrnUYO2/d0f2dqGTatUvSHZod5bNaWg5mdyFvCgD6xutfC
         4dnENyjYVmUzY9z3MkXNlB7Uc64MRidycQuSJlegIsV5VAJAt2+VLwsqX+U3dxQ2KIhU
         Faxw==
X-Gm-Message-State: AOAM531L/FQNjEj3RVxUKBFH6sv2+YsenwIArcto4x3GYbQHB9bbuKil
        NxDqz7k1OTck8GfZDBseE7JpSqlLoDFqd9gR10U5iWvN63Wg
X-Google-Smtp-Source: ABdhPJy5d/CmGb6qZJzwZqyuMm66N/qCjTWrq/ZIZa5coUS04XgiYv1DEc6PTEkr04vMNbglPQDiF4Cpi8x9U8qbXRQZ25ZmcHA9
MIME-Version: 1.0
X-Received: by 2002:a05:6602:12:: with SMTP id b18mr10790843ioa.134.1612682424109;
 Sat, 06 Feb 2021 23:20:24 -0800 (PST)
Date:   Sat, 06 Feb 2021 23:20:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006536505bab9e3d4@google.com>
Subject: memory leak in __ieee80211_beacon_get
From:   syzbot <syzbot+e832ab33619901afc64a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3aaf0a27 Merge tag 'clang-format-for-linux-v5.11-rc7' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f79330d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7edd79f26f7c0c3
dashboard link: https://syzkaller.appspot.com/bug?extid=e832ab33619901afc64a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e46a40d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e832ab33619901afc64a@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88811682b500 (size 232):
  comm "softirq", pid 0, jiffies 4295119192 (age 15.070s)
  hex dump (first 32 bytes):
    10 c5 79 16 81 88 ff ff 10 c5 79 16 81 88 ff ff  ..y.......y.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000092ce1185>] __alloc_skb+0x6d/0x280 net/core/skbuff.c:198
    [<0000000027006abe>] __netdev_alloc_skb+0x6a/0x210 net/core/skbuff.c:446
    [<00000000bbb79fe8>] netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
    [<00000000bbb79fe8>] dev_alloc_skb include/linux/skbuff.h:2845 [inline]
    [<00000000bbb79fe8>] __ieee80211_beacon_get+0x662/0x7a0 net/mac80211/tx.c:4814
    [<00000000d5da7a17>] ieee80211_beacon_get_tim+0x47/0x1c0 net/mac80211/tx.c:4928
    [<0000000042c1663d>] ieee80211_beacon_get include/net/mac80211.h:4918 [inline]
    [<0000000042c1663d>] mac80211_hwsim_beacon_tx+0xa1/0x2c0 drivers/net/wireless/mac80211_hwsim.c:1729
    [<00000000681dd69b>] __iterate_interfaces+0x125/0x260 net/mac80211/util.c:793
    [<00000000025fd347>] ieee80211_iterate_active_interfaces_atomic+0x2e/0x40 net/mac80211/util.c:829
    [<00000000c135ff4a>] mac80211_hwsim_beacon+0x52/0xb0 drivers/net/wireless/mac80211_hwsim.c:1782
    [<0000000018e3b983>] __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
    [<0000000018e3b983>] __hrtimer_run_queues+0x1ba/0x470 kernel/time/hrtimer.c:1583
    [<00000000ac9fbd2f>] hrtimer_run_softirq+0x7e/0x100 kernel/time/hrtimer.c:1600
    [<000000003b2a8015>] __do_softirq+0xbf/0x2ab kernel/softirq.c:343
    [<00000000cfba3969>] asm_call_irq_on_stack+0xf/0x20
    [<00000000a2e1da95>] __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
    [<00000000a2e1da95>] run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
    [<00000000a2e1da95>] do_softirq_own_stack+0x32/0x40 arch/x86/kernel/irq_64.c:77
    [<0000000075748e36>] invoke_softirq kernel/softirq.c:226 [inline]
    [<0000000075748e36>] __irq_exit_rcu kernel/softirq.c:420 [inline]
    [<0000000075748e36>] irq_exit_rcu+0x93/0xc0 kernel/softirq.c:432
    [<000000006645e04e>] sysvec_apic_timer_interrupt+0x36/0x80 arch/x86/kernel/apic/apic.c:1096
    [<00000000cffb1ca1>] asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629

BUG: memory leak
unreferenced object 0xffff88811682db00 (size 232):
  comm "softirq", pid 0, jiffies 4295119192 (age 15.070s)
  hex dump (first 32 bytes):
    10 c5 6b 16 81 88 ff ff 10 c5 6b 16 81 88 ff ff  ..k.......k.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000092ce1185>] __alloc_skb+0x6d/0x280 net/core/skbuff.c:198
    [<0000000027006abe>] __netdev_alloc_skb+0x6a/0x210 net/core/skbuff.c:446
    [<00000000bbb79fe8>] netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
    [<00000000bbb79fe8>] dev_alloc_skb include/linux/skbuff.h:2845 [inline]
    [<00000000bbb79fe8>] __ieee80211_beacon_get+0x662/0x7a0 net/mac80211/tx.c:4814
    [<00000000d5da7a17>] ieee80211_beacon_get_tim+0x47/0x1c0 net/mac80211/tx.c:4928
    [<0000000042c1663d>] ieee80211_beacon_get include/net/mac80211.h:4918 [inline]
    [<0000000042c1663d>] mac80211_hwsim_beacon_tx+0xa1/0x2c0 drivers/net/wireless/mac80211_hwsim.c:1729
    [<00000000681dd69b>] __iterate_interfaces+0x125/0x260 net/mac80211/util.c:793
    [<00000000025fd347>] ieee80211_iterate_active_interfaces_atomic+0x2e/0x40 net/mac80211/util.c:829
    [<00000000c135ff4a>] mac80211_hwsim_beacon+0x52/0xb0 drivers/net/wireless/mac80211_hwsim.c:1782
    [<0000000018e3b983>] __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
    [<0000000018e3b983>] __hrtimer_run_queues+0x1ba/0x470 kernel/time/hrtimer.c:1583
    [<00000000ac9fbd2f>] hrtimer_run_softirq+0x7e/0x100 kernel/time/hrtimer.c:1600
    [<000000003b2a8015>] __do_softirq+0xbf/0x2ab kernel/softirq.c:343
    [<00000000cfba3969>] asm_call_irq_on_stack+0xf/0x20
    [<00000000a2e1da95>] __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
    [<00000000a2e1da95>] run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
    [<00000000a2e1da95>] do_softirq_own_stack+0x32/0x40 arch/x86/kernel/irq_64.c:77
    [<0000000075748e36>] invoke_softirq kernel/softirq.c:226 [inline]
    [<0000000075748e36>] __irq_exit_rcu kernel/softirq.c:420 [inline]
    [<0000000075748e36>] irq_exit_rcu+0x93/0xc0 kernel/softirq.c:432
    [<000000006645e04e>] sysvec_apic_timer_interrupt+0x36/0x80 arch/x86/kernel/apic/apic.c:1096
    [<00000000cffb1ca1>] asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629

BUG: memory leak
unreferenced object 0xffff888116604400 (size 512):
  comm "softirq", pid 0, jiffies 4295119192 (age 15.070s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d1a2675d>] __kmalloc_reserve net/core/skbuff.c:142 [inline]
    [<00000000d1a2675d>] __alloc_skb+0xab/0x280 net/core/skbuff.c:210
    [<0000000027006abe>] __netdev_alloc_skb+0x6a/0x210 net/core/skbuff.c:446
    [<00000000bbb79fe8>] netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
    [<00000000bbb79fe8>] dev_alloc_skb include/linux/skbuff.h:2845 [inline]
    [<00000000bbb79fe8>] __ieee80211_beacon_get+0x662/0x7a0 net/mac80211/tx.c:4814
    [<00000000d5da7a17>] ieee80211_beacon_get_tim+0x47/0x1c0 net/mac80211/tx.c:4928
    [<0000000042c1663d>] ieee80211_beacon_get include/net/mac80211.h:4918 [inline]
    [<0000000042c1663d>] mac80211_hwsim_beacon_tx+0xa1/0x2c0 drivers/net/wireless/mac80211_hwsim.c:1729
    [<00000000681dd69b>] __iterate_interfaces+0x125/0x260 net/mac80211/util.c:793
    [<00000000025fd347>] ieee80211_iterate_active_interfaces_atomic+0x2e/0x40 net/mac80211/util.c:829
    [<00000000c135ff4a>] mac80211_hwsim_beacon+0x52/0xb0 drivers/net/wireless/mac80211_hwsim.c:1782
    [<0000000018e3b983>] __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
    [<0000000018e3b983>] __hrtimer_run_queues+0x1ba/0x470 kernel/time/hrtimer.c:1583
    [<00000000ac9fbd2f>] hrtimer_run_softirq+0x7e/0x100 kernel/time/hrtimer.c:1600
    [<000000003b2a8015>] __do_softirq+0xbf/0x2ab kernel/softirq.c:343
    [<00000000cfba3969>] asm_call_irq_on_stack+0xf/0x20
    [<00000000a2e1da95>] __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
    [<00000000a2e1da95>] run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
    [<00000000a2e1da95>] do_softirq_own_stack+0x32/0x40 arch/x86/kernel/irq_64.c:77
    [<0000000075748e36>] invoke_softirq kernel/softirq.c:226 [inline]
    [<0000000075748e36>] __irq_exit_rcu kernel/softirq.c:420 [inline]
    [<0000000075748e36>] irq_exit_rcu+0x93/0xc0 kernel/softirq.c:432
    [<000000006645e04e>] sysvec_apic_timer_interrupt+0x36/0x80 arch/x86/kernel/apic/apic.c:1096
    [<00000000cffb1ca1>] asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
