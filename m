Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A614C1E2824
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388848AbgEZROZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:14:25 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:49494 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388743AbgEZROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:14:18 -0400
Received: by mail-il1-f198.google.com with SMTP id g13so18154067ild.16
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 10:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hoPwsjIqSK0KAB7KQ3f3MXEUCtZiAG9yK7r33w+GosI=;
        b=fGF/f6JtSXEOE7eCZ16CI9zVuQ+EkjyX+et8NZTOTj+R4oSlML73hl3ARLRT0yyhBw
         zX5/8XbSg5w+WbUHO9PZhjbZ5qJqXFOTIGmdWscsoEv9uw/IJ6/5aqdR6OKP84sPO6Sm
         xaNvqmLBRxC7KMlUVCbwKf+ORF7/jdfXKFHxbpAPcYVt2MeaSmzWqxEvvniCPgpsHJ7j
         c8ipSldiOLT7khdNYuGgnqkVngZOvCVEW9CSsdEjND++zs9irMyolAdZSbm3L/YSNJlU
         ENgC4RLZH5ThiU1jQmhCd0ShKAEcrw8soye0ilgrucRarWLv8Jqjtr0q06xctYeM5oXd
         eDGw==
X-Gm-Message-State: AOAM532V4J3lRV1IE8dvI+Az0V5DrdrYioeia0Kdb5XWF1Rmn0MBAMLr
        f2RKhEInOqu17HSoxvMWIEnc6BUcdXhWbcaDBdeXfjYsl9bM
X-Google-Smtp-Source: ABdhPJx6XS3O91EfkGOLsIdQjU7Xl6bSrKSmD8nN3gbbqVb3ZgbvCWh1yrJvuSmZp9e3d8TxhUgNx8Qb8fnDKPSuDAZ/6G37IWSD
MIME-Version: 1.0
X-Received: by 2002:a92:5a4a:: with SMTP id o71mr2063560ilb.217.1590513256308;
 Tue, 26 May 2020 10:14:16 -0700 (PDT)
Date:   Tue, 26 May 2020 10:14:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a728b105a69039ce@google.com>
Subject: WARNING: locking bug in dev_mc_seq_show
From:   syzbot <syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andriin@fb.com, ast@kernel.org,
        bp@alien8.de, bpf@vger.kernel.org, christian.brauner@ubuntu.com,
        cyphar@cyphar.com, daniel@iogearbox.net,
        dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com, kafai@fb.com,
        keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        x86@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    44456565 Merge tag 'io_uring-5.7-2020-05-22' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1656ef06100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c33c7f7c5471fd39
dashboard link: https://syzkaller.appspot.com/bug?extid=f3a0e80c34b3fc28ac5e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17123f06100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ac4e72100000

The bug was bisected to:

commit 75a1a607bb7e6d918be3aca11ec2214a275392f4
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Fri Nov 1 23:17:57 2019 +0000

    uaccess: Add strict non-pagefault kernel-space read function

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14dbf8ce100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16dbf8ce100000
console output: https://syzkaller.appspot.com/x/log.txt?x=12dbf8ce100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com
Fixes: 75a1a607bb7e ("uaccess: Add strict non-pagefault kernel-space read function")

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 7235 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:183 [inline]
WARNING: CPU: 0 PID: 7235 at kernel/locking/lockdep.c:183 check_wait_context kernel/locking/lockdep.c:4029 [inline]
WARNING: CPU: 0 PID: 7235 at kernel/locking/lockdep.c:183 __lock_acquire+0x1aab/0x2c30 kernel/locking/lockdep.c:4305
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7235 Comm: syz-executor379 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:183 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4029 [inline]
RIP: 0010:__lock_acquire+0x1aab/0x2c30 kernel/locking/lockdep.c:4305
Code: 13 08 00 0f 85 8d ea ff ff 31 db 48 c7 c7 99 82 e5 88 48 c7 c6 d3 4f ea 88 31 c0 e8 7f d6 ec ff 48 ba 00 00 00 00 00 fc ff df <0f> 0b e9 81 ea ff ff 31 db e9 70 ea ff ff 48 c7 c1 30 ed 55 8b 80
RSP: 0018:ffffc90001ad74f0 EFLAGS: 00010046
RAX: 43109e3dc9d77000 RBX: 0000000000000000 RCX: ffff888096498280
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffffffff815cd136
RBP: ffffc90001ad7658 R08: ffffffff817912a6 R09: fffffbfff125cd0b
R10: fffffbfff125cd0b R11: 0000000000000000 R12: ffff888096498bb8
R13: 1ffff11012c93177 R14: 0000000000000607 R15: 0000000000000000
 lock_acquire+0x169/0x480 kernel/locking/lockdep.c:4934
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:358 [inline]
 netif_addr_lock_bh include/linux/netdevice.h:4172 [inline]
 dev_mc_seq_show+0x40/0x220 net/core/net-procfs.c:325
 seq_read+0x950/0xce0 fs/seq_file.c:247
 pde_read fs/proc/inode.c:292 [inline]
 proc_reg_read+0x27f/0x3a0 fs/proc/inode.c:304
 do_loop_readv_writev fs/read_write.c:715 [inline]
 do_iter_read+0x44b/0x550 fs/read_write.c:936
 vfs_readv+0xc2/0x120 fs/read_write.c:1054
 kernel_readv fs/splice.c:365 [inline]
 default_file_splice_read+0x579/0xa40 fs/splice.c:422
 do_splice_to fs/splice.c:892 [inline]
 splice_direct_to_actor+0x3c1/0xb40 fs/splice.c:971
 do_splice_direct+0x201/0x340 fs/splice.c:1080
 do_sendfile+0x809/0xfe0 fs/read_write.c:1521
 __do_sys_sendfile64 fs/read_write.c:1582 [inline]
 __se_sys_sendfile64 fs/read_write.c:1568 [inline]
 __x64_sys_sendfile64+0x164/0x1a0 fs/read_write.c:1568
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x448b99
Code: e8 cc 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007feaf3cdbd18 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00000000006dec58 RCX: 0000000000448b99
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000007
RBP: 00000000006dec50 R08: 65732f636f72702f R09: 65732f636f72702f
R10: 000000000000edc0 R11: 0000000000000246 R12: 00000000006dec5c
R13: 00007feaf3cdbd20 R14: 00007feaf3cdbd20 R15: 00000000006dec5c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
