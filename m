Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0581101AC
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 16:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfLCP7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 10:59:08 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:55907 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfLCP7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 10:59:08 -0500
Received: by mail-io1-f69.google.com with SMTP id z21so2690548iob.22
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 07:59:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yzLiJgJi21Wi/SkQvCRDeIHCXmWuhreNy1ag5rAyZdM=;
        b=cNgUVcxU/VbjuNPjq6GJVbEpGa1q3iIvbdjPo0YJHZ+6tZOGzt0ZdYlr0wMXnfu4vk
         XhS3ZKximnPPbhUtPjD3CM2GZlnZuzYaA2T4QB/Eyokpo9Mnw2AWXaB3g1Wz6fuKfaqg
         5y07ZLJbgR4WKBv1MuFNc1iKYysbm7x1I5D6lB9KnJ4S3rCsHbGqHBJPlTKdpbIx7yzT
         FS4NaIHzgDx/grFOyEJpFd+PgFhfxy6u5GJsnLe7xZXPo3u9rXruxXCAdxGV5LSAfhmq
         pHSGbPGoAureZqmCF3aBicWG60ndEFJqZup1Xvla6juNYhxfI2WJvGd7cJZQusU9K6s9
         CZ/w==
X-Gm-Message-State: APjAAAUSORArn8XFp48kXFOeWLf8REM+ARwapLbXxFNvdV7zCNWHlGUo
        jfs9IhJT7ZkgqQzqWp0mvct+RV4RzasKW8TaSQ5oQmkYS9RM
X-Google-Smtp-Source: APXvYqxHlgarIlI9DbrU+pYHooUkXvE9fb9mBjxo4lh+3fTa4MgmbPuJTLbysQvIAlEJGAfEIc1qm1FHERyc/PxxhSHQ59NJI1cK
MIME-Version: 1.0
X-Received: by 2002:a92:911b:: with SMTP id t27mr5334950ild.142.1575388747346;
 Tue, 03 Dec 2019 07:59:07 -0800 (PST)
Date:   Tue, 03 Dec 2019 07:59:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab3f800598cec624@google.com>
Subject: WARNING: bad unlock balance in sch_direct_xmit
From:   syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1677d882e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=773597fe8d7cb41a
dashboard link: https://syzkaller.appspot.com/bug?extid=4ec99438ed7450da6272
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
5.4.0-syzkaller #0 Not tainted
-------------------------------------
syz-executor.4/10485 is trying to release lock (&dev->qdisc_xmit_lock_key)  
at:
[<ffffffff85e7458a>] spin_unlock include/linux/spinlock.h:378 [inline]
[<ffffffff85e7458a>] __netif_tx_unlock include/linux/netdevice.h:3961  
[inline]
[<ffffffff85e7458a>] sch_direct_xmit+0x3fa/0xd30 net/sched/sch_generic.c:315
but there are no more locks to release!

other info that might help us debug this:
7 locks held by syz-executor.4/10485:
  #0: ffff88809555b060 (&pipe->mutex/1){+.+.}, at: pipe_lock_nested  
fs/pipe.c:63 [inline]
  #0: ffff88809555b060 (&pipe->mutex/1){+.+.}, at: pipe_lock fs/pipe.c:71  
[inline]
  #0: ffff88809555b060 (&pipe->mutex/1){+.+.}, at: pipe_wait+0x1ce/0x1f0  
fs/pipe.c:119
  #1: ffff8880ae809d50 ((&ndev->rs_timer)){+.-.}, at: lockdep_copy_map  
include/linux/lockdep.h:172 [inline]
  #1: ffff8880ae809d50 ((&ndev->rs_timer)){+.-.}, at:  
call_timer_fn+0xe0/0x780 kernel/time/timer.c:1394
  #2: ffffffff891a4080 (rcu_read_lock){....}, at: ip6_nd_hdr  
net/ipv6/ndisc.c:463 [inline]
  #2: ffffffff891a4080 (rcu_read_lock){....}, at:  
ndisc_send_skb+0x7fe/0x1490 net/ipv6/ndisc.c:499
  #3: ffffffff891a4040 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect  
include/net/lwtunnel.h:92 [inline]
  #3: ffffffff891a4040 (rcu_read_lock_bh){....}, at:  
ip6_finish_output2+0x214/0x25c0 net/ipv6/ip6_output.c:102
  #4: ffffffff891a4040 (rcu_read_lock_bh){....}, at:  
__dev_queue_xmit+0x20a/0x35c0 net/core/dev.c:3948
  #5: ffff8880a8e16250 (&dev->qdisc_tx_busylock_key#19){+...}, at:  
spin_trylock include/linux/spinlock.h:348 [inline]
  #5: ffff8880a8e16250 (&dev->qdisc_tx_busylock_key#19){+...}, at:  
qdisc_run_begin include/net/sch_generic.h:159 [inline]
  #5: ffff8880a8e16250 (&dev->qdisc_tx_busylock_key#19){+...}, at:  
__dev_xmit_skb net/core/dev.c:3611 [inline]
  #5: ffff8880a8e16250 (&dev->qdisc_tx_busylock_key#19){+...}, at:  
__dev_queue_xmit+0x2412/0x35c0 net/core/dev.c:3982
  #6: ffff8880a8e16138 (&dev->qdisc_running_key#19){+...}, at:  
dev_queue_xmit+0x18/0x20 net/core/dev.c:4046

stack backtrace:
CPU: 0 PID: 10485 Comm: syz-executor.4 Not tainted 5.4.0-syzkaller #0
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
  __netif_tx_unlock include/linux/netdevice.h:3961 [inline]
  sch_direct_xmit+0x3fa/0xd30 net/sched/sch_generic.c:315
  __dev_xmit_skb net/core/dev.c:3621 [inline]
  __dev_queue_xmit+0x2707/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_hh_output include/net/neighbour.h:500 [inline]
  neigh_output include/net/neighbour.h:509 [inline]
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
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752  
[inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160  
[inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x90/0xe0  
kernel/locking/spinlock.c:191
Code: 48 c7 c0 58 34 13 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c  
10 00 75 39 48 83 3d ff 65 96 01 00 74 24 48 89 df 57 9d <0f> 1f 44 00 00  
bf 01 00 00 00 e8 e1 a7 d3 f9 65 8b 05 12 50 85 78
RSP: 0018:ffff88805df77a30 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff122668b RBX: 0000000000000282 RCX: 0000000000000006
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000282
RBP: ffff88805df77a40 R08: 1ffffffff15377ad R09: fffffbfff15377ae
R10: fffffbfff15377ad R11: ffffffff8a9bbd6f R12: ffff88809555b080
R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000001
  spin_unlock_irqrestore include/linux/spinlock.h:393 [inline]
  __wake_up_common_lock+0xf8/0x150 kernel/sched/wait.c:125
  __wake_up+0xe/0x10 kernel/sched/wait.c:142
  wakeup_pipe_writers+0x5c/0x90 fs/splice.c:457
  splice_from_pipe_next.part.0+0x237/0x300 fs/splice.c:560
  splice_from_pipe_next fs/splice.c:543 [inline]
  __splice_from_pipe+0x10f/0x7d0 fs/splice.c:622
  vmsplice_to_user fs/splice.c:1272 [inline]
  do_vmsplice.part.0+0x249/0x2b0 fs/splice.c:1350
  do_vmsplice fs/splice.c:1344 [inline]
  __do_sys_vmsplice+0x1bc/0x210 fs/splice.c:1371
  __se_sys_vmsplice fs/splice.c:1353 [inline]
  __x64_sys_vmsplice+0x97/0xf0 fs/splice.c:1353
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f139a14ac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000116
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045a679
RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f139a14b6d4
R13: 00000000004ca80d R14: 00000000004e3128 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
