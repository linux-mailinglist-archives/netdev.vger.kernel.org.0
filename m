Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7605B412D63
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 05:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhIUD0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 23:26:22 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49819 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350622AbhIUC4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:56:44 -0400
Received: by mail-io1-f70.google.com with SMTP id h19-20020a056602155300b005d5f622706aso16885427iow.16
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 19:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d4R5QGLQnupcbebS30Lcro4CL6kMk66LcNL9QFcysXs=;
        b=HVeyrkkf3hWUHazN0/+LqCWAc/MfCtU2TkcDg8kFFJelczRw7er5YN7gR0VaU5lLZZ
         aYNWCM5xlw8rq8IG1688lvMC4mOPp+nHtKEwmQIJ1R73c4cKKgaNdC8d4b9WtjtusQSG
         yxA3sJb6cL0GQwDfF2dPx7qYDfhfxMWpEXCwIpASCNk9JcnyJTURLVdsB1sJmQ2MRVLE
         //Q9f5jvDietqJQNp6xYg/IzLOggP6eaPQdIMPT+z3QWTtCPTAM8SMJcRL3wX3GHGq8x
         xPQigSCe7HxfLCCOh69kIRA9Tj1RCuVhynor3a+cF/iHitvD2W6lvUlE8KRuacri5atr
         cSXw==
X-Gm-Message-State: AOAM531s7vjcKe81ynk/HCGapknB6KDrIXJ3XHg0MO1aIqk5p2YDvSy9
        u7Uoeh0A/kvXtZ4B0mznChMzEz6ntlP4y4i7jZoREuSOlrxB
X-Google-Smtp-Source: ABdhPJxjQX+yYzhafgAjaMFJ03bOgjxKloEmWs+8OY099wS939ETUUWYN0x0IvXskOzSD8IlBoE6IQDOZV/5Pa/LMRPwkA/m4z6v
MIME-Version: 1.0
X-Received: by 2002:a6b:7710:: with SMTP id n16mr20889883iom.101.1632192916142;
 Mon, 20 Sep 2021 19:55:16 -0700 (PDT)
Date:   Mon, 20 Sep 2021 19:55:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f8be2b05cc788686@google.com>
Subject: [syzbot] general protection fault in percpu_ref_put
From:   syzbot <syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        christian.brauner@ubuntu.com, christian@brauner.io,
        daniel@iogearbox.net, dkadashev@gmail.com, hannes@cmpxchg.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4357f03d6611 Merge tag 'pm-5.15-rc2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=173e2d27300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccfb8533b1cbe3b1
dashboard link: https://syzkaller.appspot.com/bug?extid=533f389d4026d86a2a95
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1395c6f1300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11568cad300000

The issue was bisected to:

commit 020250f31c4c75ac7687a673e29c00786582a5f4
Author: Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu Jul 8 06:34:43 2021 +0000

    namei: make do_linkat() take struct filename

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137e8a4b300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fe8a4b300000
console output: https://syzkaller.appspot.com/x/log.txt?x=177e8a4b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com
Fixes: 020250f31c4c ("namei: make do_linkat() take struct filename")

general protection fault, probably for non-canonical address 0xdffffc0000000182: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000c10-0x0000000000000c17]
CPU: 1 PID: 148 Comm: kworker/u4:2 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
RIP: 0010:percpu_ref_put_many include/linux/percpu-refcount.h:319 [inline]
RIP: 0010:percpu_ref_put+0x93/0x1d0 include/linux/percpu-refcount.h:338
Code: 01 48 c7 c7 40 58 52 8a be b1 02 00 00 48 c7 c2 80 58 52 8a e8 fe 18 e9 ff 49 bd 00 00 00 00 00 fc ff df 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 9e 73 52 00 48 8b 2b 48 89 ee 48
RSP: 0018:ffffc90000dc0b30 EFLAGS: 00010206
RAX: 0000000000000182 RBX: 0000000000000c10 RCX: ffff888016781c80
RDX: 0000000080000100 RSI: 0000000000000004 RDI: ffff8880b9d32508
RBP: 000000000000003f R08: dffffc0000000000 R09: ffffed10173a64a2
R10: ffffed10173a64a2 R11: 0000000000000000 R12: ffff88806df0a000
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f853d75b740 CR3: 00000000702e7000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 cgroup_bpf_put include/linux/cgroup.h:926 [inline]
 cgroup_sk_free+0x3c/0xa0 kernel/cgroup/cgroup.c:6613
 sk_prot_free net/core/sock.c:1852 [inline]
 __sk_destruct+0x541/0x820 net/core/sock.c:1943
 call_timer_fn+0xf6/0x210 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers+0x71a/0x910 kernel/time/timer.c:1734
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1747
 __do_softirq+0x392/0x7a3 kernel/softirq.c:558
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:lock_acquire+0x21f/0x4d0 kernel/locking/lockdep.c:5629
Code: 08 4c 89 f7 e8 c2 d1 69 00 f6 84 24 81 00 00 00 02 0f 85 13 02 00 00 41 f7 c4 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 04 2f 00 00 00 00 43 c7 44 2f 09 00 00 00 00 43 c7 44 2f 11
RSP: 0018:ffffc9000170f8e0 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 1ffff920002e1f2c RCX: ffff888016782670
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000170fa40 R08: dffffc0000000000 R09: fffffbfff1fa2fc1
R10: fffffbfff1fa2fc1 R11: 0000000000000000 R12: 0000000000000246
R13: 1ffff920002e1f24 R14: ffffc9000170f960 R15: dffffc0000000000
 rcu_lock_acquire+0x2a/0x30 include/linux/rcupdate.h:267
 rcu_read_lock include/linux/rcupdate.h:687 [inline]
 inet_twsk_purge+0x11b/0x890 net/ipv4/inet_timewait_sock.c:268
 ops_exit_list net/core/net_namespace.c:171 [inline]
 cleanup_net+0x7ec/0xc50 net/core/net_namespace.c:591
 process_one_work+0x853/0x1140 kernel/workqueue.c:2297
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2444
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30
Modules linked in:
---[ end trace 6ae4e3b5aac552a5 ]---
RIP: 0010:__ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
RIP: 0010:percpu_ref_put_many include/linux/percpu-refcount.h:319 [inline]
RIP: 0010:percpu_ref_put+0x93/0x1d0 include/linux/percpu-refcount.h:338
Code: 01 48 c7 c7 40 58 52 8a be b1 02 00 00 48 c7 c2 80 58 52 8a e8 fe 18 e9 ff 49 bd 00 00 00 00 00 fc ff df 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 9e 73 52 00 48 8b 2b 48 89 ee 48
RSP: 0018:ffffc90000dc0b30 EFLAGS: 00010206
RAX: 0000000000000182 RBX: 0000000000000c10 RCX: ffff888016781c80
RDX: 0000000080000100 RSI: 0000000000000004 RDI: ffff8880b9d32508
RBP: 000000000000003f R08: dffffc0000000000 R09: ffffed10173a64a2
R10: ffffed10173a64a2 R11: 0000000000000000 R12: ffff88806df0a000
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f853d75b740 CR3: 000000000c68e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	48 c7 c7 40 58 52 8a 	mov    $0xffffffff8a525840,%rdi
   7:	be b1 02 00 00       	mov    $0x2b1,%esi
   c:	48 c7 c2 80 58 52 8a 	mov    $0xffffffff8a525880,%rdx
  13:	e8 fe 18 e9 ff       	callq  0xffe91916
  18:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  1f:	fc ff df
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 9e 73 52 00       	callq  0x5273d6
  38:	48 8b 2b             	mov    (%rbx),%rbp
  3b:	48 89 ee             	mov    %rbp,%rsi
  3e:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
