Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACE32E2B92
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 14:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLYNpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 08:45:54 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:36897 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgLYNpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 08:45:53 -0500
Received: by mail-il1-f197.google.com with SMTP id g10so3728141ile.4
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 05:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MiLat2U8UEzOxwhkBLLYRXZSjkbCjoTbUJUVgvs4p/U=;
        b=HI5KD3ZPrJml5myxX83aTacaERE14QtuvzxBDv6WHfWkFZ/Mh8RvjZZoREvAemznNs
         wTGrW7I7aNd0QWbajrh763bMt2RAQixC27sbMaoxbG19OY8X90EKeE72JeZM3UhxL/N4
         slTqYKOfowx3gUh0X3cVRIb67UxKu6Dwyph1LAigaSpXFNxK9dzu/stwkQQmEK3ME4Ms
         a6Ll49hpyMDD64P5ANECbHlA8hKZ+8ni16dliJHMf09zI3ECnGYsMKxNs8r7+/yd+iAF
         4CFB9ZLPtt2/PdAO1tGkagqzDqxJ1ngWj2h1oiU66k+4yB9mCXd3Auc0pAZ2xmzx4cnE
         cCkw==
X-Gm-Message-State: AOAM533IEBWczUflz3AVuRGhS1fh2C5hjcZpjx2RTdrxiBnFB/AEri9j
        FoeEo9mRgr/lF32oshS/2fGcpCLvP8cA7MwXi9O3Oq9PNDlJ
X-Google-Smtp-Source: ABdhPJz1FbKHY94IuX+pEbL1DG1NajS0jAZdTM2jf2z2SZfUDNUXjIm70aqEQuhfJbqmfJK83yVv5J96mG3HgtzZL7kJayEWosmM
MIME-Version: 1.0
X-Received: by 2002:a02:856d:: with SMTP id g100mr29932134jai.10.1608903912007;
 Fri, 25 Dec 2020 05:45:12 -0800 (PST)
Date:   Fri, 25 Dec 2020 05:45:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000272c1005b74a223b@google.com>
Subject: BUG: sleeping function called from invalid context in
 do_user_addr_fault (2)
From:   syzbot <syzbot+6ce719ff413f52e0a0f2@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, toke@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d467d80d bpf: Remove unused including <linux/version.h>
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=159392cb500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2764fc28a92339f9
dashboard link: https://syzkaller.appspot.com/bug?extid=6ce719ff413f52e0a0f2
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17234333500000

The issue was bisected to:

commit 64b59025c15b244c0954cf52b24fbabfcf5ed8f6
Author: David Ahern <dsahern@kernel.org>
Date:   Fri May 29 22:07:14 2020 +0000

    xdp: Add xdp_txq_info to xdp_buff

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129bcb37500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=119bcb37500000
console output: https://syzkaller.appspot.com/x/log.txt?x=169bcb37500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6ce719ff413f52e0a0f2@syzkaller.appspotmail.com
Fixes: 64b59025c15b ("xdp: Add xdp_txq_info to xdp_buff")

BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1351
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 8781, name: syz-executor.0
2 locks held by syz-executor.0/8781:
 #0: ffffffff8b33a020 (rcu_read_lock){....}-{1:2}, at: bpf_test_run+0x116/0xcc0 net/bpf/test_run.c:28
 #1: ffff888013428158 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #1: ffff888013428158 (&mm->mmap_lock#2){++++}-{3:3}, at: do_user_addr_fault+0x25f/0xc50 arch/x86/mm/fault.c:1334
Preemption disabled at:
[<ffffffff814b8a6e>] migrate_disable+0x5e/0x160 kernel/sched/core.c:1753
CPU: 0 PID: 8781 Comm: syz-executor.0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:7911
 do_user_addr_fault+0x29c/0xc50 arch/x86/mm/fault.c:1351
 handle_page_fault arch/x86/mm/fault.c:1450 [inline]
 exc_page_fault+0x9e/0x180 arch/x86/mm/fault.c:1506
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:580
RIP: 0010:bpf_prog_e48ebe87b99394c4+0x11/0xa48
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 66 90 55 48 89 e5 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 c9 c3 cc cc cc cc cc cc cc cc cc cc
RSP: 0018:ffffc9000165fb30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffffff87314b68
RDX: ffff88802bfeb580 RSI: ffffc90000e8e038 RDI: ffffc9000165fcb0
RBP: ffffc9000165fb30 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffffc90000e8e000
 bpf_prog_run_xdp include/linux/filter.h:743 [inline]
 bpf_test_run+0x21c/0xcc0 net/bpf/test_run.c:48
 bpf_prog_test_run_xdp+0x2ca/0x510 net/bpf/test_run.c:648
 bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
 __do_sys_bpf+0x2174/0x5130 kernel/bpf/syscall.c:4412
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e149
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7d79602c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e149
RDX: 0000000000000028 RSI: 00000000200000c0 RDI: 000000000000000a
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffdea4f396f R14: 00007f7d796039c0 R15: 000000000119bf8c
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 1eb8b067 P4D 1eb8b067 PUD 1cd90067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8781 Comm: syz-executor.0 Tainted: G        W         5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_prog_e48ebe87b99394c4+0x11/0xa48
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 66 90 55 48 89 e5 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 c9 c3 cc cc cc cc cc cc cc cc cc cc
RSP: 0018:ffffc9000165fb30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffffff87314b68
RDX: ffff88802bfeb580 RSI: ffffc90000e8e038 RDI: ffffc9000165fcb0
RBP: ffffc9000165fb30 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffffc90000e8e000
FS:  00007f7d79603700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb3f42c0018 CR3: 0000000014825000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bpf_prog_run_xdp include/linux/filter.h:743 [inline]
 bpf_test_run+0x21c/0xcc0 net/bpf/test_run.c:48
 bpf_prog_test_run_xdp+0x2ca/0x510 net/bpf/test_run.c:648
 bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
 __do_sys_bpf+0x2174/0x5130 kernel/bpf/syscall.c:4412
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e149
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7d79602c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e149
RDX: 0000000000000028 RSI: 00000000200000c0 RDI: 000000000000000a
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffdea4f396f R14: 00007f7d796039c0 R15: 000000000119bf8c
Modules linked in:
CR2: 0000000000000000
---[ end trace f373adf0128c937b ]---
RIP: 0010:bpf_prog_e48ebe87b99394c4+0x11/0xa48
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 66 90 55 48 89 e5 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 c9 c3 cc cc cc cc cc cc cc cc cc cc
RSP: 0018:ffffc9000165fb30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffffff87314b68
RDX: ffff88802bfeb580 RSI: ffffc90000e8e038 RDI: ffffc9000165fcb0
RBP: ffffc9000165fb30 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffffc90000e8e000
FS:  00007f7d79603700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb3f42c0018 CR3: 0000000014825000 CR4: 00000000001506f0
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
