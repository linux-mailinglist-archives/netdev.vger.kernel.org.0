Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F7D4855FD
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiAEPha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:37:30 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:52010 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbiAEPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:37:25 -0500
Received: by mail-io1-f69.google.com with SMTP id z73-20020a6bc94c000000b00601d9159578so21106484iof.18
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 07:37:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Jy1CJc27wQ4wDQC/r+ZYnpdYqk//0eAj4PnvGdOY2/g=;
        b=KLogbDHJSZGt1ZWaYg6vRRvKGhJbuAaRMz5FzGikCIGh0/a2Bb40KIpcKcZiABQIla
         KVN88795awNhr4pw8LIAxdsOgzV4EgGUbTUYjU5KYDWGaIqOgnkZ23o9HIQMzVl7mMqS
         va5t0UDmvjGg7QhIWK65raUYsIsVVf2HVQMqGfmI2PygJgShHcoPXQROxayX1URc9YAb
         hiYYXEAXZeA4M++ZM7dhKAr6PDwzOsNRiDVDAjYql8oxxnr1jpqLtJv9iYes5EOvn2hP
         p3kLkRU1mmSdqdB/OhkDbNLnThPSip0oggo1joovONufs1fqPybSBW8kYTdg5N07wvjO
         ryRQ==
X-Gm-Message-State: AOAM530e701Vo+SIJ6t0ZnhR/iQObEYIyu8eEzmSWC7xj9WE44mIuD6G
        ZV++D9ef7xwRncqJTu5TuDZQpy2qx1XmSkiI0eGcWXRimqgE
X-Google-Smtp-Source: ABdhPJyLeZL65/iy2MGtgSk9775W6qgsdKc2IP3lJQADB3Fttr26MviFEbb5dWoHgw9SGCmR5+xtawbSgn4fWMm+x9beGySDsXzI
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b88:: with SMTP id h8mr23708673ili.263.1641397044747;
 Wed, 05 Jan 2022 07:37:24 -0800 (PST)
Date:   Wed, 05 Jan 2022 07:37:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9a3fb05d4d787a3@google.com>
Subject: [syzbot] WARNING in signalfd_cleanup
From:   syzbot <syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com>
To:     changbin.du@intel.com, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6b8d4927540e Add linux-next specific files for 20220104
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159d88e3b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45c9bbbf2ae8e3d3
dashboard link: https://syzkaller.appspot.com/bug?extid=5426c7ed6868c705ca14
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117be65db00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a75c8db00000

The issue was bisected to:

commit e4b8954074f6d0db01c8c97d338a67f9389c042f
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Dec 7 01:30:37 2021 +0000

    netlink: add net device refcount tracker to struct ethnl_req_info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12bca4e3b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11bca4e3b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16bca4e3b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3604 at kernel/sched/wait.c:245 __wake_up_pollfree+0x40/0x50 kernel/sched/wait.c:246
Modules linked in:
CPU: 0 PID: 3604 Comm: syz-executor714 Not tainted 5.16.0-rc8-next-20220104-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__wake_up_pollfree+0x40/0x50 kernel/sched/wait.c:245
Code: f3 ff ff 48 8d 6b 40 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 75 11 48 8b 43 40 48 39 c5 75 03 5b 5d c3 <0f> 0b 5b 5d c3 48 89 ef e8 13 d8 69 00 eb e5 cc 48 c1 e7 06 48 63
RSP: 0018:ffffc90001aaf9f8 EFLAGS: 00010083
RAX: ffff88801cd623f0 RBX: ffff88801bec8048 RCX: 0000000000000000
RDX: 1ffff110037d9011 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffff88801bec8088 R08: 0000000000000000 R09: ffff88801bec804b
R10: ffffed10037d9009 R11: 0000000000000000 R12: ffff88801bec8040
R13: ffff88801e029d40 R14: dffffc0000000000 R15: ffff88807eb50000
FS:  00005555573ad300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000c0 CR3: 000000001e5e4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 wake_up_pollfree include/linux/wait.h:271 [inline]
 signalfd_cleanup+0x42/0x60 fs/signalfd.c:38
 __cleanup_sighand kernel/fork.c:1596 [inline]
 __cleanup_sighand+0x72/0xb0 kernel/fork.c:1593
 __exit_signal kernel/exit.c:159 [inline]
 release_task+0xc02/0x17e0 kernel/exit.c:200
 wait_task_zombie kernel/exit.c:1117 [inline]
 wait_consider_task+0x2fa6/0x3b80 kernel/exit.c:1344
 do_wait_thread kernel/exit.c:1407 [inline]
 do_wait+0x6ca/0xce0 kernel/exit.c:1524
 kernel_wait4+0x14c/0x260 kernel/exit.c:1687
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1715
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7facd6682386
Code: 0f 1f 40 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
RSP: 002b:00007ffdb91adef8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 000000000000c646 RCX: 00007facd6682386
RDX: 0000000040000001 RSI: 00007ffdb91adf14 RDI: 00000000ffffffff
RBP: 0000000000000f17 R08: 0000000000000032 R09: 00007ffdb91ec080
R10: 0000000000000000 R11: 0000000000000246 R12: 431bde82d7b634db
R13: 00007ffdb91adf14 R14: 0000000000000000 R15: 0000000000000000
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
