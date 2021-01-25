Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FADB3033C9
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbhAZFFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:20 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:48333 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbhAYMwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:52:04 -0500
Received: by mail-io1-f70.google.com with SMTP id v25so18721086ioj.15
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 04:51:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7yzACKBivQNVWbNjmhIg71uYXUw2G8UL5fat5y7REW4=;
        b=cCcxG5s8lEjk3LdnqytSGLSl67hjMv8XbYWzA2pNJWyR52E8r4ZldBdEbcpNZ/6mvl
         KYDRFv2K+3MllNjtC3jDrrDUAYggm9wvQAyTNDQnJVU8mifnUdV2+RA5+jwaAS/uU2Bw
         zd3kxMrOz3+yPplx5+q7ioOvqZUpTye6jiV7i6uQ3rt4y+hP7XTqXVsoTzbg+WKgS3E9
         QCRkyvOdgavuxBqVXkjBXMbDwZSn8RHjrCT4itzNGgFOx7ADcQtU7vAQIgfrQMvRdGXe
         GKxLuxKMjEtwrUD0K3fWYjWFyKequnBxU43FK7xH344JEddWORrGq0MWmCZb/OqDuY5g
         8Plg==
X-Gm-Message-State: AOAM530VXw3nVpckKrRhpk4KQ0VuuuRvh0NTcbLQnSnrhO6emg6p62iy
        yM1ZHEfLXhd85kZxX9lm5vxE/+APldxsHInckIWk91eLJ9+4
X-Google-Smtp-Source: ABdhPJzzOgJeF/k86yPx6Ztit1zKlLLNrUgdYqjd8lbjY8KSPTCNUjYPR+VhMYD1Qny61CaNhemRGItHNDiPue28Zw8h++HRxTP/
MIME-Version: 1.0
X-Received: by 2002:a02:1d0a:: with SMTP id 10mr399144jaj.122.1611579082433;
 Mon, 25 Jan 2021 04:51:22 -0800 (PST)
Date:   Mon, 25 Jan 2021 04:51:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc67d205b9b8feb2@google.com>
Subject: KASAN: slab-out-of-bounds Write in record_print_text
From:   syzbot <syzbot+a42d84593d6a89a76f26@syzkaller.appspotmail.com>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        davem@davemloft.net, john.ogness@linutronix.de, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e6806137 Merge tag 'irq_urgent_for_v5.11_rc5' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10c59c6f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be33d8015c9de024
dashboard link: https://syzkaller.appspot.com/bug?extid=a42d84593d6a89a76f26
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1575e6b4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17aea4e8d00000

The issue was bisected to:

commit f0e386ee0c0b71ea6f7238506a4d0965a2dbef11
Author: John Ogness <john.ogness@linutronix.de>
Date:   Thu Jan 14 17:04:12 2021 +0000

    printk: fix buffer overflow potential for print_text()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f30130d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=140b0130d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=100b0130d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a42d84593d6a89a76f26@syzkaller.appspotmail.com
Fixes: f0e386ee0c0b ("printk: fix buffer overflow potential for print_text()")

==================================================================
BUG: KASAN: slab-out-of-bounds in record_print_text+0x33f/0x380 kernel/printk/printk.c:1401
Write of size 1 at addr ffff88801c2faf40 by task in:imklog/8158

CPU: 1 PID: 8158 Comm: in:imklog Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 record_print_text+0x33f/0x380 kernel/printk/printk.c:1401
 syslog_print+0x2bb/0x430 kernel/printk/printk.c:1459
 do_syslog.part.0+0x2a8/0x7c0 kernel/printk/printk.c:1586
 do_syslog+0x49/0x60 kernel/printk/printk.c:1567
 kmsg_read+0x90/0xb0 fs/proc/kmsg.c:40
 pde_read fs/proc/inode.c:321 [inline]
 proc_reg_read+0x119/0x300 fs/proc/inode.c:331
 vfs_read+0x1b5/0x570 fs/read_write.c:494
 ksys_read+0x12d/0x250 fs/read_write.c:634
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f3e2eec922d
Code: c1 20 00 00 75 10 b8 00 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 4e fc ff ff 48 89 04 24 b8 00 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 97 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007f3e2c865580 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3e2eec922d
RDX: 0000000000001fa0 RSI: 00007f3e2c865da0 RDI: 0000000000000004
RBP: 000055d0880849d0 R08: 0000000000000000 R09: 0000000004000001
R10: 0000000000000001 R11: 0000000000000293 R12: 00007f3e2c865da0
R13: 0000000000001fa0 R14: 0000000000001f9f R15: 00007f3e2c865df3

Allocated by task 8158:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kmalloc include/linux/slab.h:552 [inline]
 syslog_print+0xb2/0x430 kernel/printk/printk.c:1430
 do_syslog.part.0+0x2a8/0x7c0 kernel/printk/printk.c:1586
 do_syslog+0x49/0x60 kernel/printk/printk.c:1567
 kmsg_read+0x90/0xb0 fs/proc/kmsg.c:40
 pde_read fs/proc/inode.c:321 [inline]
 proc_reg_read+0x119/0x300 fs/proc/inode.c:331
 vfs_read+0x1b5/0x570 fs/read_write.c:494
 ksys_read+0x12d/0x250 fs/read_write.c:634
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88801c2fa800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 832 bytes to the right of
 1024-byte region [ffff88801c2fa800, ffff88801c2fac00)
The buggy address belongs to the page:
page:00000000eb65f4f5 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1c2f8
head:00000000eb65f4f5 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010041140
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801c2fae00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801c2fae80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801c2faf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                           ^
 ffff88801c2faf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801c2fb000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
