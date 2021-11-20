Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02664457AA6
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 03:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhKTCu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 21:50:26 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:52126 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbhKTCuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 21:50:25 -0500
Received: by mail-io1-f72.google.com with SMTP id b1-20020a05660214c100b005e241049240so6885421iow.18
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 18:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rwsDZ4jfpJLh86xpw4OX5pfJCwzCUpI3R6PfQFpOvGw=;
        b=Yk2IM/dxwl3kB9AQU7me4YxombC7xnzICsqH1SVg0cbPDeyA+QTo+kAmD+VToYdAyk
         XywcIaT6NCruaUwyHvjHfVXsyG4lD98XnwhH3JW73d39lc+xwtJmIuzmE53DjYDzkp68
         eOONbpiPurTPw/eZF3jU/LOZs+KvVb+iOkptRU8hagfRxvqRPorrFPjs9fcgz++eLcN0
         7FrlGCkfpRJks9GIXsUctRdY/0DQW3LYkX4ZUdQgb00sziCyj6bT8FDS4fl6hrhUiCiO
         ag8KfKEDoaGSeJc9Ly0QPvEbi7R6kxzp9+MzBHStsocDl3KqAzcJsXuq+yrhWDZtT8RR
         oOlA==
X-Gm-Message-State: AOAM532FWJkeB7KQaVPveqM2rJ9r7c0o5swe3PW5Hzn9o25ESiUmTYGS
        37iDip3lV2dnO0BD494ySRy/2miLaOGlREVe4tgL0S9ul0Pw
X-Google-Smtp-Source: ABdhPJyUoD8FMfdj7ChSiW0dQXqpo3ImIjwd4ICb0lC3aI+gMrXyRrc0BTpUKgbszh2LfNUzzdy7jp+ZhZUxNqoJWL0JkBxLguQW
MIME-Version: 1.0
X-Received: by 2002:a92:9507:: with SMTP id y7mr7929306ilh.119.1637376442767;
 Fri, 19 Nov 2021 18:47:22 -0800 (PST)
Date:   Fri, 19 Nov 2021 18:47:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c221105d12f69e3@google.com>
Subject: [syzbot] possible deadlock in smc_switch_to_fallback
From:   syzbot <syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9539ba4308ad Merge tag 'riscv-for-linus-5.16-rc2' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f79d01b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
dashboard link: https://syzkaller.appspot.com/bug?extid=e979d3597f48262cb4ee
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.16.0-rc1-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.3/1337 is trying to acquire lock:
ffff88809466ce58 (&ei->socket.wq.wait){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
ffff88809466ce58 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3d5/0x8c0 net/smc/af_smc.c:588

but task is already holding lock:
ffff88809466c258 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3ca/0x8c0 net/smc/af_smc.c:587

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ei->socket.wq.wait);
  lock(&ei->socket.wq.wait);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.3/1337:
 #0: 
ffff888082ba8120 (sk_lock-AF_SMC){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1645 [inline]
ffff888082ba8120 (sk_lock-AF_SMC){+.+.}-{0:0}, at: smc_setsockopt+0x2b7/0xa40 net/smc/af_smc.c:2449
 #1: ffff88809466c258 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3ca/0x8c0 net/smc/af_smc.c:587

stack backtrace:
CPU: 1 PID: 1337 Comm: syz-executor.3 Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
 check_deadlock kernel/locking/lockdep.c:2999 [inline]
 validate_chain kernel/locking/lockdep.c:3788 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5027
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:349 [inline]
 smc_switch_to_fallback+0x3d5/0x8c0 net/smc/af_smc.c:588
 smc_setsockopt+0x8ee/0xa40 net/smc/af_smc.c:2459
 __sys_setsockopt+0x2db/0x610 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa2a8fceae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa2a6544188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fa2a90e1f60 RCX: 00007fa2a8fceae9
RDX: 0000000000000021 RSI: 0000000000000006 RDI: 0000000000000005
RBP: 00007fa2a9028f6d R08: 0000000000000010 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc2297067f R14: 00007fa2a6544300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
