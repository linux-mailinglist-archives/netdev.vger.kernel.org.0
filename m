Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6034C5452A6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiFIRHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344403AbiFIRHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:07:33 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FA1C5D8C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:07:30 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id n12-20020a92260c000000b002d3c9fc68d6so18038156ile.19
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 10:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Qomqaou+54axI368WL0XNwH/m5OrniWkk2TGmdoD03s=;
        b=G5GXJhsHOLMLDv+/0CRHiz5tfkBs4cWNPLwt4/zz624ixLpcvANz3gNHNsbml9p8F5
         EAEV4lx0qlNaZ3gJqIcVT7VOuAXQp6GGPqih6m3b6jKVSct3voTbGCiFe5tCFz8qd2Zx
         UyJuRm0Rh9CkRxDBFuVTF50dAPNi19a94dRSuEWsRar3p8HTqUwPVsHVJmGQB+STLyb+
         xzIr7hy+x46R6a6R225YR4wwlRSm2jtIyb9uQiRZpoDmzwsWdy5jiXbuakCScI6I6YPK
         VzMK+MW5+Wtb01YaKLDeFektejwnV345s0Y1QdJcBoDxmcWlnyVUrx3cP816Qx8vFigt
         RnwA==
X-Gm-Message-State: AOAM533Xq4bRmRAcEAEn//DQbW1PwKub2Sop77HZbEy5rHfSsL4Wm3gy
        QNrsIgCcuAk40h5GdJmAqVBY6MJHwlW47X6MYg/Hbwo1p1IG
X-Google-Smtp-Source: ABdhPJyVJHg3/m2kQwxyyCxd1zESRTo3sTeDhbK/QZnA+IOspn6syM/GFLrUeOhi2mKdxfhfBAL1NBJ3PIditxTIg9xODgH6XI/i
MIME-Version: 1.0
X-Received: by 2002:a6b:6d0d:0:b0:669:6f9b:68c7 with SMTP id
 a13-20020a6b6d0d000000b006696f9b68c7mr7846766iod.167.1654794450275; Thu, 09
 Jun 2022 10:07:30 -0700 (PDT)
Date:   Thu, 09 Jun 2022 10:07:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006294c805e106db34@google.com>
Subject: [syzbot] possible deadlock in bpf_trace_printk
From:   syzbot <syzbot+c49e17557ddb5725583d@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, boqun.feng@gmail.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        longman@redhat.com, mingo@redhat.com, netdev@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d678cbd2f867 xsk: Fix handling of invalid descriptors in X..
git tree:       bpf
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15ea1120080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc5a30a131480a80
dashboard link: https://syzkaller.appspot.com/bug?extid=c49e17557ddb5725583d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1342b1f7f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ca7880080000

The issue was bisected to:

commit dc1f7893a70fe403983bd8492f177bf993940e2c
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Mar 30 11:06:54 2022 +0000

    locking/mutex: Make contention tracepoints more consistent wrt adaptive spinning

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c55dcff00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16c55dcff00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12c55dcff00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c49e17557ddb5725583d@syzkaller.appspotmail.com
Fixes: dc1f7893a70f ("locking/mutex: Make contention tracepoints more consistent wrt adaptive spinning")

============================================
WARNING: possible recursive locking detected
5.18.0-syzkaller-12122-gd678cbd2f867 #0 Not tainted
--------------------------------------------
syz-executor354/3616 is trying to acquire lock:
ffffffff8be0d6d8 (trace_printk_lock){..-.}-{2:2}, at: ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
ffffffff8be0d6d8 (trace_printk_lock){..-.}-{2:2}, at: bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:374

but task is already holding lock:
ffffffff8be0d6d8 (trace_printk_lock){..-.}-{2:2}, at: ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
ffffffff8be0d6d8 (trace_printk_lock){..-.}-{2:2}, at: bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:374

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(trace_printk_lock);
  lock(trace_printk_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz-executor354/3616:
 #0: ffffffff8be67668 (delayed_uprobe_lock){+.+.}-{3:3}, at: uprobe_clear_state+0x47/0x420 kernel/events/uprobes.c:1544
 #1: ffffffff8bd86be0 (rcu_read_lock){....}-{1:2}, at: bpf_trace_run2+0x0/0x340 kernel/trace/./bpf_trace.h:11
 #2: ffffffff8be0d6d8 (trace_printk_lock){..-.}-{2:2}, at: ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
 #2: ffffffff8be0d6d8 (trace_printk_lock){..-.}-{2:2}, at: bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:374
 #3: ffffffff8bd86be0 (rcu_read_lock){....}-{1:2}, at: bpf_trace_run2+0x0/0x340 kernel/trace/./bpf_trace.h:11

stack backtrace:
CPU: 1 PID: 3616 Comm: syz-executor354 Not tainted 5.18.0-syzkaller-12122-gd678cbd2f867 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
 check_deadlock kernel/locking/lockdep.c:3031 [inline]
 validate_chain kernel/locking/lockdep.c:3816 [inline]
 __lock_acquire.cold+0x1f5/0x3b4 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
 bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:374
 bpf_prog_0605f9f479290f07+0x2f/0x33
 bpf_dispatcher_nop_func include/linux/bpf.h:869 [inline]
 __bpf_prog_run include/linux/filter.h:628 [inline]
 bpf_prog_run include/linux/filter.h:635 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2046 [inline]
 bpf_trace_run2+0x110/0x340 kernel/trace/bpf_trace.c:2083
 __bpf_trace_contention_begin+0xb5/0xf0 include/trace/events/lock.h:95
 trace_contention_begin.constprop.0+0xda/0x1b0 include/trace/events/lock.h:95
 __pv_queued_spin_lock_slowpath+0x103/0xb50 kernel/locking/qspinlock.c:405
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:591 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x200/0x2a0 kernel/locking/spinlock_debug.c:115
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:111 [inline]
 _raw_spin_lock_irqsave+0x41/0x50 kernel/locking/spinlock.c:162
 ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
 bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:374
 bpf_prog_0605f9f479290f07+0x2f/0x33
 bpf_dispatcher_nop_func include/linux/bpf.h:869 [inline]
 __bpf_prog_run include/linux/filter.h:628 [inline]
 bpf_prog_run include/linux/filter.h:635 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2046 [inline]
 bpf_trace_run2+0x110/0x340 kernel/trace/bpf_trace.c:2083
 __bpf_trace_contention_begin+0xb5/0xf0 include/trace/events/lock.h:95
 trace_contention_begin+0xc0/0x150 include/trace/events/lock.h:95
 __mutex_lock_common kernel/locking/mutex.c:605 [inline]
 __mutex_lock+0x13c/0x1350 kernel/locking/mutex.c:747
 uprobe_clear_state+0x47/0x420 kernel/events/uprobes.c:1544
 __mmput+0x73/0x4b0 kernel/fork.c:1183
 mmput+0x56/0x60 kernel/fork.c:1208
 exit_mm kernel/exit.c:510 [inline]
 do_exit+0xa12/0x2a00 kernel/exit.c:782
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f15c46e1139
Code: Unable to access opcode bytes at RIP 0x7f15c46e110f.
RSP: 002b:00007ffd3b43d738 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f15c475c330 RCX: 00007f15c46e1139
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00007f15c4756ec0
R10: 00007ffd3b43d200 R11: 0000000000000246 R12: 00007f15c475c330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
