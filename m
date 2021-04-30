Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3029B370119
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhD3TTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:19:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37418 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhD3TTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:19:10 -0400
Received: by mail-io1-f72.google.com with SMTP id e18-20020a5ed5120000b029041705a6ed5cso1082287iom.4
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 12:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W21MpQbg2r+zNE3j8+vGWPwY3QTKyRcwFXVYnsEsdfk=;
        b=theYeerPPuTEzpdllIZ8gZlsyGMdM7NH2EqxctZWH0YF7v+AgmBSiAE8csgXcLy/rr
         GQKUOZwtr7tL0UpAVX05kXlNTRJDcKw1mpOBFIuEd730whEPAGQyUO8dATsMyeKkvFj8
         VqDvBfso7fGgED9v+HUj6dhfvFNRTg0rEFmV8uLA8NZtzTuwdwA0RJHUi3ID7ASfeL3S
         UXCtA9LCk41gL3kpWEY6RaUzlzgVpuLaybqaMgE6LVlp+STAK1vJTZmsWdXtqyQN9IYp
         MGbQT3+iLmYNFs8mpGQ+WkBAJUK9ItHCGzE7fsleektXsZBnre3ZfocIlHinDKLF/z/T
         t/tQ==
X-Gm-Message-State: AOAM5306rRm1mQknyHpsgBPX2rJMb+xR4K47I7p0ss0fgzGd7MZVxvMD
        POV7vrUoG4glT37io67P6P0dp1ZppSF6Rif43OfBCewa63A8
X-Google-Smtp-Source: ABdhPJwZS0tfegh2Qqjc0QKn+UUcf4HfJCvapdjl8XTuTXzuiIOy0BxLLiudFD2SpuxKFLCBNFeorHCXet+FSN9BdOrQwf79BoUu
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1526:: with SMTP id i6mr5273750ilu.270.1619810301365;
 Fri, 30 Apr 2021 12:18:21 -0700 (PDT)
Date:   Fri, 30 Apr 2021 12:18:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009dd35c05c135792d@google.com>
Subject: [syzbot] possible deadlock in sctp_addr_wq_timeout_handler
From:   syzbot <syzbot+959223586843e69a2674@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, vyasevich@gmail.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2a1d7946 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=159af1c1d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9404cfa686df2c05
dashboard link: https://syzkaller.appspot.com/bug?extid=959223586843e69a2674
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11613d71d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12be674dd00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c36a5dd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14236a5dd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10236a5dd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+959223586843e69a2674@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

======================================================
WARNING: possible circular locking dependency detected
5.12.0-rc8-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor044/8536 is trying to acquire lock:
ffff8880183933a0 (slock-AF_INET6){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880183933a0 (slock-AF_INET6){+.-.}-{2:2}, at: sctp_addr_wq_timeout_handler+0x1a1/0x550 net/sctp/protocol.c:666

but task is already holding lock:
ffffffff8d659620 (&net->sctp.addr_wq_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
ffffffff8d659620 (&net->sctp.addr_wq_lock){+.-.}-{2:2}, at: sctp_addr_wq_timeout_handler+0x38/0x550 net/sctp/protocol.c:626

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&net->sctp.addr_wq_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
       spin_lock_bh include/linux/spinlock.h:359 [inline]
       sctp_destroy_sock+0x204/0x440 net/sctp/socket.c:5028
       sctp_v6_destroy_sock+0x11/0x20 net/sctp/socket.c:9528
       sk_common_release+0x64/0x390 net/core/sock.c:3264
       sctp_close+0x4da/0x940 net/sctp/socket.c:1531
       inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
       inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
       __sock_release+0xcd/0x280 net/socket.c:599
       sock_close+0x18/0x20 net/socket.c:1258
       __fput+0x288/0x920 fs/file_table.c:280
       task_work_run+0xdd/0x1a0 kernel/task_work.c:140
       exit_task_work include/linux/task_work.h:30 [inline]
       do_exit+0xbfc/0x2a60 kernel/exit.c:825
       do_group_exit+0x125/0x310 kernel/exit.c:922
       __do_sys_exit_group kernel/exit.c:933 [inline]
       __se_sys_exit_group kernel/exit.c:931 [inline]
       __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (slock-AF_INET6){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2937 [inline]
       check_prevs_add kernel/locking/lockdep.c:3060 [inline]
       validate_chain kernel/locking/lockdep.c:3675 [inline]
       __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4901
       lock_acquire kernel/locking/lockdep.c:5511 [inline]
       lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
       spin_lock include/linux/spinlock.h:354 [inline]
       sctp_addr_wq_timeout_handler+0x1a1/0x550 net/sctp/protocol.c:666
       call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
       expire_timers kernel/time/timer.c:1476 [inline]
       __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
       __run_timers kernel/time/timer.c:1726 [inline]
       run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
       __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
       invoke_softirq kernel/softirq.c:221 [inline]
       __irq_exit_rcu kernel/softirq.c:422 [inline]
       irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
       sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
       __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
       _raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
       __debug_check_no_obj_freed lib/debugobjects.c:997 [inline]
       debug_check_no_obj_freed+0x20c/0x420 lib/debugobjects.c:1018
       slab_free_hook mm/slub.c:1554 [inline]
       slab_free_freelist_hook+0x147/0x210 mm/slub.c:1600
       slab_free mm/slub.c:3161 [inline]
       kmem_cache_free+0x8a/0x740 mm/slub.c:3177
       free_fs_struct fs/fs_struct.c:92 [inline]
       exit_fs+0x123/0x170 fs/fs_struct.c:108
       do_exit+0xbca/0x2a60 kernel/exit.c:821
       do_group_exit+0x125/0x310 kernel/exit.c:922
       __do_sys_exit_group kernel/exit.c:933 [inline]
       __se_sys_exit_group kernel/exit.c:931 [inline]
       __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&net->sctp.addr_wq_lock);
                               lock(slock-AF_INET6);
                               lock(&net->sctp.addr_wq_lock);
  lock(slock-AF_INET6);

 *** DEADLOCK ***

2 locks held by syz-executor044/8536:
 #0: ffffc90000007d78 ((&net->sctp.addr_wq_timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #0: ffffc90000007d78 ((&net->sctp.addr_wq_timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1421
 #1: ffffffff8d659620 (&net->sctp.addr_wq_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #1: ffffffff8d659620 (&net->sctp.addr_wq_lock){+.-.}-{2:2}, at: sctp_addr_wq_timeout_handler+0x38/0x550 net/sctp/protocol.c:626

stack backtrace:
CPU: 0 PID: 8536 Comm: syz-executor044 Not tainted 5.12.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2128
 check_prev_add kernel/locking/lockdep.c:2937 [inline]
 check_prevs_add kernel/locking/lockdep.c:3060 [inline]
 validate_chain kernel/locking/lockdep.c:3675 [inline]
 __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4901
 lock_acquire kernel/locking/lockdep.c:5511 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 sctp_addr_wq_timeout_handler+0x1a1/0x550 net/sctp/protocol.c:666
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
 __run_timers kernel/time/timer.c:1726 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
Code: 74 24 10 e8 4a f9 53 f8 48 89 ef e8 82 af 54 f8 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 63 7d 48 f8 65 8b 05 0c 48 fc 76 85 c0 74 0a 5b 5d c3 e8 d0 3c
RSP: 0018:ffffc9000173fc50 EFLAGS: 00000206
RAX: 0000000000000002 RBX: 0000000000000200 RCX: 1ffffffff1b89e11
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffffffff9006cf00 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8179e4c8 R11: 000000000000003f R12: 1ffffffff200d9df
R13: 0000000000000000 R14: dead000000000100 R15: dffffc0000000000
 __debug_check_no_obj_freed lib/debugobjects.c:997 [inline]
 debug_check_no_obj_freed+0x20c/0x420 lib/debugobjects.c:1018
 slab_free_hook mm/slub.c:1554 [inline]
 slab_free_freelist_hook+0x147/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kmem_cache_free+0x8a/0x740 mm/slub.c:3177
 free_fs_struct fs/fs_struct.c:92 [inline]
 exit_fs+0x123/0x170 fs/fs_struct.c:108
 do_exit+0xbca/0x2a60 kernel/exit.c:821
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ea79
Code: Unable to access opcode bytes at RIP 0x43ea4f.
RSP: 002b:00007ffdbc348058 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b0330 RCX: 000000000043ea79
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004b0330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
