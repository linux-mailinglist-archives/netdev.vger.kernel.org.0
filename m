Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E6D271356
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 12:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgITKwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 06:52:22 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:43438 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgITKwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 06:52:21 -0400
Received: by mail-io1-f80.google.com with SMTP id b73so7947494iof.10
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 03:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sEzIaRwys/QIQ/izTd98t3jdkVY27DKWjlVLvODZoyM=;
        b=YwTw1m1LOLRbtnUVDvCiX92Aux9GdZVnjbTTT6oNrt+HP6Zo137Ug5niMeMYJog3wH
         L3o0bz10Ny0rU/ttMyDH8eN52zxwuCAEIFS75yX73uA09MFcWyJjxhfN8LXAwkv3Huh2
         Jl1puwmn5Zs4qo6P/Xd4wRQIjBceDY8V0Ws9s30nRam3NaY6G5joEiwcV0lxBCSez9tX
         UKOLbACzGcpMiFOtpkIYmJK5Ga9P+THyS9yU325fcrB93CT2pjtQrHtNdcqQjM0tQ4ns
         9cFpLRik6cR+oekB8an45MFn2bRTC/8U4y1EaiqoDSd2gFEp87W86qC8Zkwdr0nu2UKL
         P47A==
X-Gm-Message-State: AOAM532yZ69cW7XzVn8C+iT6a/jKFHr2islK9EhBMuODqjkma6FKP681
        Hh1CDJKVw/cBbjawbmrLf/vdE+lF4rs/zU1ht1xMl/WRBMp2
X-Google-Smtp-Source: ABdhPJyllw3NACkZbVwVhikJFEp3f40s01ePYpin0grc5y8ut/eETSQsu0O/Lmdbdor2URMebH9Dgb4vEaHMuRkgojKkVkmJTMNq
MIME-Version: 1.0
X-Received: by 2002:a92:cc83:: with SMTP id x3mr35676758ilo.232.1600599139678;
 Sun, 20 Sep 2020 03:52:19 -0700 (PDT)
Date:   Sun, 20 Sep 2020 03:52:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000025fe5805afbc876c@google.com>
Subject: possible deadlock in xfrm_policy_lookup_bytype
From:   syzbot <syzbot+4cbd5e3669aee5ac5149@syzkaller.appspotmail.com>
To:     a.darwish@linutronix.de, davem@davemloft.net,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5fa35f24 Add linux-next specific files for 20200916
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16ec67fd900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bdb7e39caf48f53
dashboard link: https://syzkaller.appspot.com/bug?extid=4cbd5e3669aee5ac5149
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ca2c73900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13668701900000

The issue was bisected to:

commit 1909760f5fc3f123e47b4e24e0ccdc0fc8f3f106
Author: Ahmed S. Darwish <a.darwish@linutronix.de>
Date:   Fri Sep 4 15:32:31 2020 +0000

    seqlock: PREEMPT_RT: Do not starve seqlock_t writers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=156b27dd900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=176b27dd900000
console output: https://syzkaller.appspot.com/x/log.txt?x=136b27dd900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4cbd5e3669aee5ac5149@syzkaller.appspotmail.com
Fixes: 1909760f5fc3 ("seqlock: PREEMPT_RT: Do not starve seqlock_t writers")

========================================================
WARNING: possible irq lock inversion dependency detected
5.9.0-rc5-next-20200916-syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor974/6847 just changed the state of lock:
ffffffff8ae7a3c8 (&s->seqcount#9){+..-}-{0:0}, at: xfrm_policy_lookup_bytype+0x183/0xa40 net/xfrm/xfrm_policy.c:2088
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (&s->seqcount#8){+.+.}-{0:0}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&s->seqcount#8);
                               local_irq_disable();
                               lock(&s->seqcount#9);
                               lock(&s->seqcount#8);
  <Interrupt>
    lock(&s->seqcount#9);

 *** DEADLOCK ***

4 locks held by syz-executor974/6847:
 #0: ffffffff8aae80a8 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:687 [inline]
 #0: ffffffff8aae80a8 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3390
 #1: ffffc90000007d80 ((&idev->mc_ifc_timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #1: ffffc90000007d80 ((&idev->mc_ifc_timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1403
 #2: ffffffff89e71cc0 (rcu_read_lock){....}-{1:2}, at: read_pnet include/net/net_namespace.h:327 [inline]
 #2: ffffffff89e71cc0 (rcu_read_lock){....}-{1:2}, at: dev_net include/linux/netdevice.h:2290 [inline]
 #2: ffffffff89e71cc0 (rcu_read_lock){....}-{1:2}, at: mld_sendpack+0x165/0xdb0 net/ipv6/mcast.c:1646
 #3: ffffffff89e71cc0 (rcu_read_lock){....}-{1:2}, at: xfrm_policy_lookup_bytype+0x104/0xa40 net/xfrm/xfrm_policy.c:2082

the shortest dependencies between 2nd lock and 1st lock:
 -> (&s->seqcount#8){+.+.}-{0:0} {
    HARDIRQ-ON-W at:
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
    SOFTIRQ-ON-W at:
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
    INITIAL USE at:
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
    (null) at:
general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 PID: 6847 Comm: syz-executor974 Not tainted 5.9.0-rc5-next-20200916-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 c1 2b d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc90000007470 EFLAGS: 00010007
RAX: 0000000000000008 RBX: ffffffff8cbe3eb0 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffffff815c26b7 RDI: 000000000000001c
RBP: ffffc900000075a0 R08: 0000000000000004 R09: ffff8880ae620f8b
R10: 0000000000000000 R11: 6c756e2820202020 R12: dffffc0000000000
R13: ffffffff8ca092f8 R14: 0000000000000009 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c7fe8 CR3: 0000000009c8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 print_irq_inversion_bug.part.0+0x2c6/0x2ee kernel/locking/lockdep.c:3769
 print_irq_inversion_bug kernel/locking/lockdep.c:4377 [inline]
 check_usage_forwards kernel/locking/lockdep.c:3800 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3935 [inline]
 mark_lock.cold+0x94/0x10d kernel/locking/lockdep.c:4375
 mark_usage kernel/locking/lockdep.c:4252 [inline]
 __lock_acquire+0x1402/0x55d0 kernel/locking/lockdep.c:4750
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
 xfrm_policy_lookup_bytype+0x183/0xa40 net/xfrm/xfrm_policy.c:2088
 xfrm_policy_lookup net/xfrm/xfrm_policy.c:2139 [inline]
 xfrm_bundle_lookup net/xfrm/xfrm_policy.c:2944 [inline]
 xfrm_lookup_with_ifid+0x5e3/0x2100 net/xfrm/xfrm_policy.c:3085
 icmp6_dst_alloc+0x489/0x6c0 net/ipv6/route.c:3187
 mld_sendpack+0x5c3/0xdb0 net/ipv6/mcast.c:1668
 mld_send_cr net/ipv6/mcast.c:1975 [inline]
 mld_ifc_timer_expire+0x60a/0xf10 net/ipv6/mcast.c:2474
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1413
 expire_timers kernel/time/timer.c:1458 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1755
 __run_timers kernel/time/timer.c:1736 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
 __do_softirq+0x202/0xa42 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 do_softirq+0x154/0x1b0 kernel/softirq.c:330
 __local_bh_enable_ip+0x196/0x1f0 kernel/softirq.c:195
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 netif_tx_unlock_bh include/linux/netdevice.h:4240 [inline]
 dev_watchdog_down net/sched/sch_generic.c:479 [inline]
 dev_deactivate_many+0x47a/0xc10 net/sched/sch_generic.c:1223
 __dev_close_many+0x130/0x2e0 net/core/dev.c:1593
 dev_close_many+0x238/0x650 net/core/dev.c:1631
 rollback_registered_many+0x3a8/0x14f0 net/core/dev.c:9303
 rollback_registered net/core/dev.c:9371 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10452
 unregister_netdevice include/linux/netdevice.h:2797 [inline]
 __tun_detach+0x100b/0x1320 drivers/net/tun.c:673
 tun_detach drivers/net/tun.c:690 [inline]
 tun_chr_close+0xd9/0x180 drivers/net/tun.c:3390
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb23/0x2930 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441698
Code: Bad RIP value.
RSP: 002b:00007ffd2fddd438 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000441698
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 00000000004c7fb0 R08: 00000000000000e7 R09: ffffffffffffffd4
R10: 0000000001000002 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006da5e0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace fa8e7a53e9954f16 ]---
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 c1 2b d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc90000007470 EFLAGS: 00010007
RAX: 0000000000000008 RBX: ffffffff8cbe3eb0 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffffff815c26b7 RDI: 000000000000001c
RBP: ffffc900000075a0 R08: 0000000000000004 R09: ffff8880ae620f8b
R10: 0000000000000000 R11: 6c756e2820202020 R12: dffffc0000000000
R13: ffffffff8ca092f8 R14: 0000000000000009 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c7fe8 CR3: 0000000009c8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
