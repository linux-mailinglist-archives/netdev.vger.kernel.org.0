Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09991383B0
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbgAKVeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 16:34:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:32967 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbgAKVeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 16:34:09 -0500
Received: by mail-il1-f200.google.com with SMTP id s9so4585452ilk.0
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 13:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VqbC1nxtrHJL9YKC9+RGFhtSs2QRUeTPCgImLrmafhI=;
        b=iCphLc+eCROYKEJ+rzr2cgedBGlWH7aN8BU1SrwLEFIzYc+F0GV4CRuL6m2w9/TtfE
         PiQpAYcsn55DEbOMWI1BC0WSz8/oeXUQNl5we7WQGVO9NRnASSw9toWCD7s9KHDGnpDY
         7B/i0lktzcAXcdW5gYi2RnBTdwVqqoO7ZVDDqG8Mde5UzS9pU/2Rj+9C5GF7cZKeX3wv
         MaVCqXfGgGg7zDNTA1pq+LZCwEIiV9O4aW8E5GaWTC/qvCM3Lz4rwBLpYZivxuJzEwOJ
         d1BPs+WUMoQbgnK0wxlTO8MZYIK8SWZ7B0JxCc9r+BmJPSFIdjG4EVF11dvHWwLuvHXI
         svmQ==
X-Gm-Message-State: APjAAAWZmz9si23zDVeL1VXqZcjpeGptXrwn6I6z+vijcItfTiPjZ09J
        jPqYrAyAaURK5VNOStX/AgN/aH0FQ6Ekp5F5ivCiryJWImFI
X-Google-Smtp-Source: APXvYqwDMniCIY97uKhU+bnTR5FZg7/4cQZUujxBNpKp2M5D7Ocui95o3jXTTcrOoP1fS//zF8w6Rx/O5Xi/fOQoBRBdcWmrFwiI
MIME-Version: 1.0
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr8904769ilq.38.1578778448912;
 Sat, 11 Jan 2020 13:34:08 -0800 (PST)
Date:   Sat, 11 Jan 2020 13:34:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a06985059be4002e@google.com>
Subject: WARNING: bad unlock balance in __dev_queue_xmit
From:   syzbot <syzbot+ad4ea1dd5d26131a58a6@syzkaller.appspotmail.com>
To:     a@unstable.cc, alex.aring@gmail.com, allison@lohutok.net,
        andrew@lunn.ch, andy@greyhouse.net, ap420073@gmail.com,
        ast@domdv.de, b.a.t.m.a.n@lists.open-mesh.org,
        bridge@lists.linux-foundation.org, cleech@redhat.com,
        daniel@iogearbox.net, davem@davemloft.net, dsa@cumulusnetworks.com,
        f.fainelli@gmail.com, fw@strlen.de, gregkh@linuxfoundation.org,
        gustavo@embeddedor.com, haiyangz@microsoft.com, info@metux.net,
        j.vosburgh@gmail.com, j@w1.fi, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, jiri@resnulli.us, johan.hedberg@gmail.com,
        johannes.berg@intel.com, john.hurley@netronome.com,
        jwi@linux.ibm.com, kstewart@linuxfoundation.org,
        kuznet@ms2.inr.ac.ru, kvalo@codeaurora.org, kys@microsoft.com,
        linmiaohe@huawei.com, linux-bluetooth@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org,
        liuhangbin@gmail.com, marcel@holtmann.org,
        mareklindner@neomailbox.ch, mkubecek@suse.cz,
        mmanning@vyatta.att-mail.com, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, oss-drivers@netronome.com,
        pabeni@redhat.com, paulus@samba.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12abc515e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=ad4ea1dd5d26131a58a6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141051b9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125e5876e00000

The bug was bisected to:

commit ab92d68fc22f9afab480153bd82a20f6e2533769
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Mon Oct 21 18:47:51 2019 +0000

     net: core: add generic lockdep keys

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=107f969ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=127f969ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=147f969ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ad4ea1dd5d26131a58a6@syzkaller.appspotmail.com
Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")

=====================================
WARNING: bad unlock balance detected!
5.5.0-rc5-syzkaller #0 Not tainted
-------------------------------------
swapper/0/0 is trying to release lock (&dev->qdisc_xmit_lock_key) at:
[<ffffffff8625890d>] spin_unlock include/linux/spinlock.h:378 [inline]
[<ffffffff8625890d>] __netif_tx_unlock include/linux/netdevice.h:3966  
[inline]
[<ffffffff8625890d>] __dev_queue_xmit+0x2bbd/0x35c0 net/core/dev.c:4016
but there are no more locks to release!

other info that might help us debug this:
4 locks held by swapper/0/0:
  #0: ffffc90000007d50 ((&ndev->rs_timer)){+.-.}, at: lockdep_copy_map  
include/linux/lockdep.h:172 [inline]
  #0: ffffc90000007d50 ((&ndev->rs_timer)){+.-.}, at:  
call_timer_fn+0xe0/0x780 kernel/time/timer.c:1394
  #1: ffffffff899a5340 (rcu_read_lock){....}, at: ip6_nd_hdr  
net/ipv6/ndisc.c:463 [inline]
  #1: ffffffff899a5340 (rcu_read_lock){....}, at:  
ndisc_send_skb+0x7fe/0x1490 net/ipv6/ndisc.c:499
  #2: ffffffff899a5300 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect  
include/net/lwtunnel.h:92 [inline]
  #2: ffffffff899a5300 (rcu_read_lock_bh){....}, at:  
ip6_finish_output2+0x214/0x25c0 net/ipv6/ip6_output.c:102
  #3: ffffffff899a5300 (rcu_read_lock_bh){....}, at:  
__dev_queue_xmit+0x20a/0x35c0 net/core/dev.c:3948

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-rc5-syzkaller #0
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
  __dev_queue_xmit+0x2bbd/0x35c0 net/core/dev.c:4016
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
  ndisc_send_skb+0xf1f/0x1490 net/ipv6/ndisc.c:505
  ndisc_send_rs+0x134/0x720 net/ipv6/ndisc.c:699
  addrconf_rs_timer+0x30f/0x6e0 net/ipv6/addrconf.c:3879
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
Code: 38 be db f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d c4 54 51  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d b4 54 51 00 fb f4 <c3> cc 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 5e 92 8b f9 e8 c9
RSP: 0018:ffffffff89807ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff132669e RBX: ffffffff8987a140 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8987a9d4
RBP: ffffffff89807d18 R08: ffffffff8987a140 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8a7b8600 R14: 0000000000000000 R15: 0000000000000000
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
kobject: 'brport' (0000000015306f5c): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (0000000015306f5c): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000f618ced7): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (00000000f618ced7): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (0000000090c32451): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (0000000090c32451): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000009b39b612): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (000000009b39b612): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000fa23c3a6): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (00000000fa23c3a6): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (0000000059be53cf): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (0000000059be53cf): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000afda9faa): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (00000000afda9faa): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000001b8d397b): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (000000001b8d397b): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000c95708c8): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (00000000c95708c8): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (0000000021fa4c47): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (0000000021fa4c47): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (00000000e55a6ea3): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (00000000e55a6ea3): calling ktype release
kobject: 'brport': free name
kobject: 'brport' (000000005f707c44): kobject_cleanup, parent  
00000000835b0c7d
kobject: 'brport' (000000005f707c44): calling ktype release
kobject: 'brport': free name


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
