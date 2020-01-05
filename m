Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02013096B
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 19:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgAESaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 13:30:09 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:32871 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgAESaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 13:30:09 -0500
Received: by mail-il1-f197.google.com with SMTP id s9so17853267ilk.0
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 10:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kOeUjzNNc8HKgxnbo2RpgTYsO85kTsjUWgOvE5aOEwI=;
        b=n+AutkJYXTgh/iNipM7t/GgG4/Wfec5Y6ih3PrrLX72fQbMpfs1pKg4Qu2Lv3VsUiJ
         LBYQdXuTytBJUrz2Og6rfvtglj8EX2+s9pNY1svhl2grhsAMbWGA5atcpqAUDfGqOikT
         3w+2oJzFQw3VCelSatsBrzrBx6cLlukU4GLw7m4i2YkYsrWuEKieJGsz/MQbPcl2nD9V
         EPS8dFQfd0pJ2WQO1jE9RkyIxHCp+uEnYVfcFl7qtZglR47q1mCGcoz4Tj8GO/M3ln/L
         Cc+iU79A9gDA73hO4oLRUW1+Ta2Y0unATtjYtIENJ+XhQEAWPFXMX8pRN9Ooi2yPseul
         B8BA==
X-Gm-Message-State: APjAAAUPlW170VAYt8jBmNXtv4Li887ShJ32vZZHUlETEhdHymz8h8vN
        2oZK+9ix04TYY3EPubsUXylg8cus876l0NMz2U3DHsIILchV
X-Google-Smtp-Source: APXvYqzEZ55Fx5Hetai6SoIv3JQmXUTZbHPhiMimkL0Vjf0BNUjGuu3w/JtZtBaG4lkavOuWchJiYPP+8S6iuLy3StpiEoyQlSaI
MIME-Version: 1.0
X-Received: by 2002:a92:c990:: with SMTP id y16mr87196379iln.105.1578249008061;
 Sun, 05 Jan 2020 10:30:08 -0800 (PST)
Date:   Sun, 05 Jan 2020 10:30:08 -0800
In-Reply-To: <000000000000ab3f800598cec624@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e2951059b68bbf0@google.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
From:   syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    36487907 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165b3e15e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=4ec99438ed7450da6272
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1722c5c1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167aee3ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
5.5.0-rc4-syzkaller #0 Not tainted
-------------------------------------
swapper/0/0 is trying to release lock (&dev->qdisc_xmit_lock_key) at:
[<ffffffff863f0dda>] spin_unlock include/linux/spinlock.h:378 [inline]
[<ffffffff863f0dda>] __netif_tx_unlock include/linux/netdevice.h:3966  
[inline]
[<ffffffff863f0dda>] sch_direct_xmit+0x3fa/0xd30 net/sched/sch_generic.c:315
but there are no more locks to release!

other info that might help us debug this:
6 locks held by swapper/0/0:
  #0: ffffc90000007d50 ((&idev->mc_dad_timer)){+.-.}, at: lockdep_copy_map  
include/linux/lockdep.h:172 [inline]
  #0: ffffc90000007d50 ((&idev->mc_dad_timer)){+.-.}, at:  
call_timer_fn+0xe0/0x780 kernel/time/timer.c:1394
  #1: ffffffff899a5600 (rcu_read_lock){....}, at: dev_net  
include/linux/netdevice.h:2188 [inline]
  #1: ffffffff899a5600 (rcu_read_lock){....}, at: mld_sendpack+0x180/0xed0  
net/ipv6/mcast.c:1649
  #2: ffffffff899a55c0 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect  
include/net/lwtunnel.h:92 [inline]
  #2: ffffffff899a55c0 (rcu_read_lock_bh){....}, at:  
ip6_finish_output2+0x214/0x25c0 net/ipv6/ip6_output.c:102
  #3: ffffffff899a55c0 (rcu_read_lock_bh){....}, at:  
__dev_queue_xmit+0x20a/0x35c0 net/core/dev.c:3948
  #4: ffff88809f1b1250 (&dev->qdisc_tx_busylock_key#3){+...}, at:  
spin_trylock include/linux/spinlock.h:348 [inline]
  #4: ffff88809f1b1250 (&dev->qdisc_tx_busylock_key#3){+...}, at:  
qdisc_run_begin include/net/sch_generic.h:159 [inline]
  #4: ffff88809f1b1250 (&dev->qdisc_tx_busylock_key#3){+...}, at:  
__dev_xmit_skb net/core/dev.c:3611 [inline]
  #4: ffff88809f1b1250 (&dev->qdisc_tx_busylock_key#3){+...}, at:  
__dev_queue_xmit+0x2412/0x35c0 net/core/dev.c:3982
  #5: ffff88809f1b1138 (&dev->qdisc_running_key#3){+...}, at:  
dev_queue_xmit+0x18/0x20 net/core/dev.c:4046

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_unlock_imbalance_bug kernel/locking/lockdep.c:4008 [inline]
  print_unlock_imbalance_bug.cold+0x114/0x123 kernel/locking/lockdep.c:3984
  __lock_release kernel/locking/lockdep.c:4242 [inline]
  lock_release+0x5f2/0x960 kernel/locking/lockdep.c:4503
  __raw_spin_unlock include/linux/spinlock_api_smp.h:150 [inline]
  _raw_spin_unlock+0x16/0x40 kernel/locking/spinlock.c:183
  spin_unlock include/linux/spinlock.h:378 [inline]
  __netif_tx_unlock include/linux/netdevice.h:3966 [inline]
  sch_direct_xmit+0x3fa/0xd30 net/sched/sch_generic.c:315
  __dev_xmit_skb net/core/dev.c:3621 [inline]
  __dev_queue_xmit+0x2707/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_hh_output include/net/neighbour.h:499 [inline]
  neigh_output include/net/neighbour.h:508 [inline]
  ip6_finish_output2+0xfbe/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  mld_sendpack+0x9c2/0xed0 net/ipv6/mcast.c:1682
  mld_send_initial_cr.part.0+0x114/0x160 net/ipv6/mcast.c:2099
  mld_send_initial_cr net/ipv6/mcast.c:2083 [inline]
  mld_dad_timer_expire+0x42/0x230 net/ipv6/mcast.c:2118
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 78 94 db f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d c4 24 51  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d b4 24 51 00 fb f4 <c3> cc 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 9e 68 8b f9 e8 09
RSP: 0018:ffffffff89807ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff132669e RBX: ffffffff8987a140 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8987a9d4
RBP: ffffffff89807d18 R08: ffffffff8987a140 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8a7bb380 R14: 0000000000000000 R15: 0000000000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
  rest_init+0x23b/0x371 init/main.c:451
  arch_call_rest_init+0xe/0x1b
  start_kernel+0x904/0x943 init/main.c:784
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
  x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
kobject: 'brport' (000000006bf26f50): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000006bf26f50): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000006a34e5a7): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000006a34e5a7): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (0000000064bee465): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (0000000064bee465): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000572b5ef3): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (00000000572b5ef3): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000c5891925): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (00000000c5891925): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000007996a1ba): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000007996a1ba): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000c48f444d): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (00000000c48f444d): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000002f26f70f): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000002f26f70f): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000009742ca09): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000009742ca09): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000b1045bd4): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (00000000b1045bd4): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000009f21e9dc): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000009f21e9dc): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000002b66d6a0): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (000000002b66d6a0): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (0000000090c92031): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (0000000090c92031): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000b4538cf1): kobject_cleanup, parent  
000000007f2d209d
kobject: 'brport' (00000000b4538cf1): calling ktype release
kobject: 'brport': free name

