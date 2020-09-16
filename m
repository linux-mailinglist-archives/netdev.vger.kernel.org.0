Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4F626BFE1
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgIPIwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:52:25 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:33961 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgIPIwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:52:16 -0400
Received: by mail-il1-f205.google.com with SMTP id m1so5049738ilg.1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7FmujVyw527dTMyix7xT3Q7vQvt0jWt/737vD6yLQds=;
        b=JpWZ+GpnAhLpfv+uE8fGleJZqUsy1gmXkeDPzt0YGJZISyzEg2CPaKkegE/0E9wcos
         Vq7dDrv8cJm9lJJNbeMXWPW/QhdIB2XdZdzzxx6YENqFEgOX7hawtgG3i0TSOuoq/YS0
         5YC+pmZafneljv+YTPjUDEb/rQ7rzi3aa4D67J4m6tBH7ZRCbvU3FJstCyLKBlrBuUCz
         h5PXspZqv1j97MsM5N4PLOzGNJxUhJP2ZGwi18N7vd8WR+VFRpF8nMBRrKllR2WHkKsT
         grx1b9e1I64RsrdbIO1DWlZ7+qgjz2yhvbnEbSnK9lQOO8P3pHAMYqrbAQnBC9Q4zdoK
         JaHA==
X-Gm-Message-State: AOAM533A28p+N/JySM9VmempRt14290MyAeNhfF6eywxg4ECIIItCHwd
        z0HbfUAqoVpP4xlE/qgRd/afa+8kUzEGX0qQ9C6gLZMsDbq1
X-Google-Smtp-Source: ABdhPJxmtyVqTOLLdIRJg2jiT0iMNMVNw2ru9lTUDUM40LCxOC2erpC+jVZd6Be8h2SKjiYGsiDipYbKvjCTdnmFSLuBHlOeEoLS
MIME-Version: 1.0
X-Received: by 2002:a02:1004:: with SMTP id 4mr21639830jay.127.1600246335308;
 Wed, 16 Sep 2020 01:52:15 -0700 (PDT)
Date:   Wed, 16 Sep 2020 01:52:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e8c2505af6a626a@google.com>
Subject: inconsistent lock state in xfrm_user_rcv_msg
From:   syzbot <syzbot+00c3b7dbdf97d1d36a9e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6b02addb Add linux-next specific files for 20200915
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=175c55b5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7086d0e9e44d4a14
dashboard link: https://syzkaller.appspot.com/bug?extid=00c3b7dbdf97d1d36a9e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00c3b7dbdf97d1d36a9e@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc5-next-20200915-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-R} -> {SOFTIRQ-ON-W} usage.
syz-executor.0/15304 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff88805da556d0 (&s->seqcount#11){+.+-}-{0:0}, at: xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2684
{IN-SOFTIRQ-R} state was registered at:
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
  seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
  xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909
  xfrm_policy_find_inexact_candidates+0xac/0x1d0 net/xfrm/xfrm_policy.c:1953
  xfrm_policy_lookup_bytype+0x4b8/0xa40 net/xfrm/xfrm_policy.c:2108
  xfrm_policy_lookup net/xfrm/xfrm_policy.c:2144 [inline]
  xfrm_bundle_lookup net/xfrm/xfrm_policy.c:2944 [inline]
  xfrm_lookup_with_ifid+0xaa1/0x2100 net/xfrm/xfrm_policy.c:3085
  icmp6_dst_alloc+0x489/0x6c0 net/ipv6/route.c:3187
  ndisc_send_skb+0x1207/0x1720 net/ipv6/ndisc.c:486
  ndisc_send_rs+0x12e/0x700 net/ipv6/ndisc.c:700
  addrconf_rs_timer+0x2ec/0x7c0 net/ipv6/addrconf.c:3873
  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1413
  expire_timers kernel/time/timer.c:1458 [inline]
  __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1755
  __run_timers kernel/time/timer.c:1736 [inline]
  run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
  __do_softirq+0x202/0xa42 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
  arch_local_irq_restore+0x2e/0x50 arch/x86/include/asm/paravirt.h:653
  lock_is_held_type+0xbb/0xf0 kernel/locking/lockdep.c:5439
  lock_is_held include/linux/lockdep.h:271 [inline]
  schedule_debug kernel/sched/core.c:4296 [inline]
  __schedule+0x133a/0x21b0 kernel/sched/core.c:4421
  preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:4685
  preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:40
  __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
  _raw_spin_unlock_irqrestore+0x78/0x90 kernel/locking/spinlock.c:191
  spin_unlock_irqrestore include/linux/spinlock.h:409 [inline]
  pty_write+0x15a/0x1f0 drivers/tty/pty.c:123
  tty_put_char+0x122/0x150 drivers/tty/tty_io.c:3030
  __process_echoes+0x577/0x9f0 drivers/tty/n_tty.c:728
  commit_echoes+0x148/0x210 drivers/tty/n_tty.c:794
  n_tty_receive_char_fast drivers/tty/n_tty.c:1449 [inline]
  n_tty_receive_buf_fast drivers/tty/n_tty.c:1609 [inline]
  __receive_buf drivers/tty/n_tty.c:1644 [inline]
  n_tty_receive_buf_common+0x203f/0x2bc0 drivers/tty/n_tty.c:1742
  tty_ldisc_receive_buf+0xa9/0x190 drivers/tty/tty_buffer.c:461
  tty_port_default_receive_buf+0x6e/0xa0 drivers/tty/tty_port.c:38
  receive_buf drivers/tty/tty_buffer.c:481 [inline]
  flush_to_ldisc+0x20d/0x380 drivers/tty/tty_buffer.c:533
  process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
  kthread+0x3af/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
irq event stamp: 103
hardirqs last  enabled at (103): [<ffffffff8145d97f>] __local_bh_enable_ip+0x10f/0x1f0 kernel/softirq.c:200
hardirqs last disabled at (101): [<ffffffff8145d9c4>] __local_bh_enable_ip+0x154/0x1f0 kernel/softirq.c:177
softirqs last  enabled at (102): [<ffffffff862361ae>] rcu_read_unlock_bh include/linux/rcupdate.h:726 [inline]
softirqs last  enabled at (102): [<ffffffff862361ae>] __dev_queue_xmit+0x1a7e/0x2d10 net/core/dev.c:4164
softirqs last disabled at (98): [<ffffffff86234907>] __dev_queue_xmit+0x1d7/0x2d10 net/core/dev.c:4072

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&s->seqcount#11);
  <Interrupt>
    lock(&s->seqcount#11);

 *** DEADLOCK ***

2 locks held by syz-executor.0/15304:
 #0: ffff88805da55a68 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3}, at: xfrm_netlink_rcv+0x5c/0x90 net/xfrm/xfrm_user.c:2691
 #1: ffff88805da55718
 (&(&net->xfrm.policy_hthresh.lock)->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 (&(&net->xfrm.policy_hthresh.lock)->lock){+.+.}-{2:2}, at: write_seqlock include/linux/seqlock.h:882 [inline]
 (&(&net->xfrm.policy_hthresh.lock)->lock){+.+.}-{2:2}, at: xfrm_set_spdinfo+0x2b8/0x660 net/xfrm/xfrm_user.c:1185

stack backtrace:
CPU: 1 PID: 15304 Comm: syz-executor.0 Not tainted 5.9.0-rc5-next-20200915-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:4377 [inline]
 valid_state kernel/locking/lockdep.c:3705 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3914 [inline]
 mark_lock.cold+0x6f/0x10d kernel/locking/lockdep.c:4375
 mark_usage kernel/locking/lockdep.c:4278 [inline]
 __lock_acquire+0x882/0x55d0 kernel/locking/lockdep.c:4750
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
 write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
 write_seqlock include/linux/seqlock.h:883 [inline]
 xfrm_set_spdinfo+0x302/0x660 net/xfrm/xfrm_user.c:1185
 xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2684
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2692
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5f9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f344c600c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002cf80 RCX: 000000000045d5f9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffd3e830a1f R14: 00007f344c6019c0 R15: 000000000118cf4c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
