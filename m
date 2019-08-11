Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3F88EE8
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 02:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfHKAYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 20:24:12 -0400
Received: from mail-ot1-f70.google.com ([209.85.210.70]:40484 "EHLO
        mail-ot1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfHKAYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 20:24:09 -0400
Received: by mail-ot1-f70.google.com with SMTP id o21so9258439otj.7
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 17:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=H2vRAGXDItJ/VNjjUYevlCeDM+mutrWBME4liWZ/vxI=;
        b=g7l/4tH9Bl8TscgMH/Pt3NqFJOgb7aDffMKkGSPB/3Z7Ytddj9D2wb653qRYXQ+KdT
         wNyFByLjO38/DKZdoADdPdbfVjHdneAvOtFns8r3mxeJ3MGJ2OOMaMx+LdP+aBxip3uG
         09uvXF0wga5egSiZhnDjmlmlfmbkveJHw4JHXQLCmbvhU/qoXb7xwBE+lin/9WfPwOTQ
         0DmA3UCbTD5KmBfYoP7xDYDJcG0O+pC3FagFP0vTD+3NX+4eFbU5wUa0gyphiaUPi6n7
         VCUGmmmh+uw8v7zFb7c6A7XEHRdZ2nsjlfktt2Qhu7axLXKeK8C4JJ73BaSGQZWLMpxn
         cM4A==
X-Gm-Message-State: APjAAAXI2ilHhaWeHApX9YAXpqAvaVWxYjYcsht43ZnjkakAQhSI4xo8
        HtZjP5cOEHcDN1lbJimNVqzlhzap/BPBvBjaZkTwCXICrq2b
X-Google-Smtp-Source: APXvYqwiR+yG8wKO/exBWGdFrr2PYnGyqI/Nh3mkWw/1SYADvnjtKeWahIelcR919viFzWnxNNHLapW93PEoiInsKmXndrZgaqaX
MIME-Version: 1.0
X-Received: by 2002:a02:16c5:: with SMTP id a188mr13580802jaa.86.1565483046622;
 Sat, 10 Aug 2019 17:24:06 -0700 (PDT)
Date:   Sat, 10 Aug 2019 17:24:06 -0700
In-Reply-To: <00000000000000ac4f058bd50039@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e56cb0058fcc6c28@google.com>
Subject: Re: WARNING in is_bpf_text_address
From:   syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org,
        bvanassche@acm.org, daniel@iogearbox.net, davem@davemloft.net,
        dvyukov@google.com, hawk@kernel.org, hdanton@sina.com,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org,
        netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    451577f3 Merge tag 'kbuild-fixes-v5.3-3' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120850a6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2031e7d221391b8a
dashboard link: https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130ffe4a600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17137d2c600000

The bug was bisected to:

commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Thu Feb 14 23:00:46 2019 +0000

     locking/lockdep: Free lock classes that are no longer in use

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no longer  
in use")

WARNING: CPU: 0 PID: 9604 at kernel/bpf/core.c:851 bpf_jit_free+0x1a8/0x1f0
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x25c/0x799 kernel/panic.c:219
  __warn+0x22f/0x230 kernel/panic.c:576
  report_bug+0x190/0x290 lib/bug.c:186
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097eff828 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097eff860 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#2] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097eff450 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097eff488 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#3] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097eff080 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097eff0b8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#4] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efecb0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efece8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#5] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efe8e0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efe918 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#6] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efe510 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efe548 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#7] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efe140 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efe178 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#8] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efdd70 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efdda8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#9] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efd9a0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efd9d8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#10] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efd5d0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efd608 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#11] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efd200 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efd238 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#12] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efce30 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efce68 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#13] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efca60 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efca98 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#14] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efc690 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efc6c8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#15] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efc2c0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efc2f8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#16] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efbef0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efbf28 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#17] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efbb20 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efbb58 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#18] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efb750 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efb788 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#19] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efb380 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efb3b8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#20] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efafb0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efafe8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#21] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efabe0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efac18 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#22] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efa810 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efa848 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#23] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efa440 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efa478 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#24] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097efa070 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097efa0a8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#25] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097ef9ca0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097ef9cd8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#26] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097ef98d0 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097ef9908 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#27] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097ef9500 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097ef9538 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#28] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097ef9130 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097ef9168 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#29] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097ef8d60 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097ef8d98 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
Oops: 0000 [#30] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097ef8990 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097ef89c8 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4001000
==================================================================
BUG: KASAN: use-after-free in format_decode+0x52/0x1850 lib/vsprintf.c:2212
Write of size 8 at addr ffff888097ef7f88 by task kworker/0:5/9604

CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
------------[ cut here ]------------
Bad or missing usercopy whitelist? Kernel memory overwrite attempt detected  
to SLAB object 'anon_vma_chain(49:syz4)' (offset 16, size 8)!
WARNING: CPU: 0 PID: 9604 at mm/usercopy.c:79 usercopy_warn+0xb7/0xc0  
mm/usercopy.c:74
Modules linked in:
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
usercopy: Kernel memory overwrite attempt detected to SLAB  
object 'anon_vma_chain(49:syz4)' (offset 96, size 8)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:98!
invalid opcode: 0000 [#31] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
usercopy: Kernel memory overwrite attempt detected to SLAB  
object 'anon_vma_chain(49:syz4)' (offset 96, size 8)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:98!
invalid opcode: 0000 [#32] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
------------[ cut here ]------------
kernel BUG at mm/slab.c:4179!
invalid opcode: 0000 [#33] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
usercopy: Kernel memory overwrite attempt detected to SLAB  
object 'kmalloc-256' (offset 240, size 23)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:98!
invalid opcode: 0000 [#34] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
usercopy: Kernel memory overwrite attempt detected to SLAB  
object 'kmalloc-256' (offset 256, size 23)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:98!
invalid opcode: 0000 [#35] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
usercopy: Kernel memory overwrite attempt detected to SLAB  
object 'kmalloc-256' (offset 272, size 23)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:98!
invalid opcode: 0000 [#36] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
usercopy: Kernel memory overwrite attempt detected to SLAB  
object 'kmalloc-256' (offset 288, size 23)!
------------[ cut here ]------------
kernel BUG at mm/slab.c:4179!
invalid opcode: 0000 [#37] PREEMPT SMP KASAN
CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:__check_heap_object+0xcb/0xd0 mm/slab.c:4203
Code: 4c 89 d1 4d 89 c8 e8 e4 77 07 00 5b 41 5e 5d c3 49 8b 73 58 41 0f b6  
d0 48 c7 c7 c7 7e 3e 88 4c 89 d1 4d 89 c8 e8 85 78 07 00 <0f> 0b 0f 1f 00  
55 48 89 e5 53 48 83 ff 10 0f 84 90 00 00 00 48 85
RSP: 0018:ffff888097ef52e0 EFLAGS: 00010046
RAX: 0000000000001058 RBX: 0000000000001286 RCX: 000000000000000c
RDX: 000000000000000c RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff888097ef52f0 R08: 0000000000000000 R09: fffff940004bf7a1
R10: ffff888097ef53c6 R11: ffff8880aa5918c0 R12: ffff888097ef53c8
R13: 01fffc0000010200 R14: ffff888097ef4140 R15: ffff888097ef53c6
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
Modules linked in:
---[ end trace 75db6f77c2c79c0c ]---
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff888097eff828 EFLAGS: 00010806
RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
RBP: ffff888097eff860 R08: ffffffff817dc73b R09: 0000000000000001
R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

