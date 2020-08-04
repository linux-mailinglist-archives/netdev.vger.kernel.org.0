Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F9C23BD72
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgHDPp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 11:45:28 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:41738 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728745AbgHDPpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 11:45:20 -0400
Received: by mail-io1-f69.google.com with SMTP id e12so9168898ioc.8
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 08:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=teHlcAYbi+ok/LTx4VJANdq80jBucOESYR39MhGarW8=;
        b=kSQILT9Ry4NIZwmBFaXbtzsALOfyEY2QnquxpT8e4ABm7RI4dPEGE9MjIqqg1sD4R7
         IUE7VvmBSVuU0F50OxadNnZyS7WTPxsgkMsjfjpGH8C9WU7ytpIww+cFR7ke+D2pRAuA
         FNggf+D6P80DiAJ282i4qs3GlyYlp8SgsOCdGcd6lOdIhMnRZHyyb0SO2EmRDJBDEmAg
         Tdn3TX5osWqBOFklpmCMvzDq3qwJ3ky9587eUw50n7g6nuYSbcJIvh5xxLEpOjEsATnq
         qOoxYLHH47LM1sSUFtc0yUlz4pHd6ZbNQ5G+KTqJUWukW1+2PzTRSSRZ392liw7lwW0M
         kS4w==
X-Gm-Message-State: AOAM532igqLsmwETIgzfw4F7Yxz1FMvf7jm+7IbfC3Osw8f+hvLG0rCC
        0v/TR6EVvP36ACO/BzCvv9O+4+w8X4sLdaI/6D6pu1KsOL++
X-Google-Smtp-Source: ABdhPJzA7NgNLQAjeEjq1AEqh5bI5S7LSZJoBvLtJPvmA0EXPKSKEh5jxuv4jBfYNKZaoAZhgDqz5TmU+M4IzRrWIjmR9mk3Skp0
MIME-Version: 1.0
X-Received: by 2002:a92:9910:: with SMTP id p16mr5384051ili.51.1596555919572;
 Tue, 04 Aug 2020 08:45:19 -0700 (PDT)
Date:   Tue, 04 Aug 2020 08:45:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000734f2505ac0f2426@google.com>
Subject: KASAN: use-after-free Write in hci_conn_del
From:   syzbot <syzbot+7b1677fecb5976b0a099@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bcf87687 Linux 5.8
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14184392900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19b11af1e394136d
dashboard link: https://syzkaller.appspot.com/bug?extid=7b1677fecb5976b0a099
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e1ff04900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b1677fecb5976b0a099@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in hci_conn_del+0x64e/0x6a0 net/bluetooth/hci_conn.c:630
Write of size 8 at addr ffff888089f54938 by task syz-executor.1/6870

CPU: 0 PID: 6870 Comm: syz-executor.1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 hci_conn_del+0x64e/0x6a0 net/bluetooth/hci_conn.c:630
 hci_conn_hash_flush+0x189/0x220 net/bluetooth/hci_conn.c:1537
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1761
 hci_unregister_dev+0x1a3/0xe20 net/bluetooth/hci_core.c:3606
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb72/0x2a40 kernel/exit.c:805
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cce9
Code: Bad RIP value.
RSP: 002b:00007ffd598b2c88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000045cce9
RDX: 0000000000416741 RSI: 0000000000ca85f0 RDI: 0000000000000043
RBP: 00000000004c2983 R08: 000000000000000b R09: 0000000000000000
R10: 0000000002936940 R11: 0000000000000246 R12: 0000000000000008
R13: 00007ffd598b2dd0 R14: 0000000000136032 R15: 00007ffd598b2de0

Allocated by task 12376:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x17a/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:313 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:308
 security_file_open+0x52/0x3f0 security/security.c:1574
 do_dentry_open+0x3a0/0x1290 fs/open.c:815
 do_open fs/namei.c:3243 [inline]
 path_openat+0x1bb9/0x2750 fs/namei.c:3360
 do_filp_open+0x17e/0x3c0 fs/namei.c:3387
 do_sys_openat2+0x16f/0x3b0 fs/open.c:1179
 do_sys_open fs/open.c:1195 [inline]
 ksys_open include/linux/syscalls.h:1388 [inline]
 __do_sys_open fs/open.c:1201 [inline]
 __se_sys_open fs/open.c:1199 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1199
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 12376:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 tomoyo_realpath_from_path+0x191/0x620 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:313 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:308
 security_file_open+0x52/0x3f0 security/security.c:1574
 do_dentry_open+0x3a0/0x1290 fs/open.c:815
 do_open fs/namei.c:3243 [inline]
 path_openat+0x1bb9/0x2750 fs/namei.c:3360
 do_filp_open+0x17e/0x3c0 fs/namei.c:3387
 do_sys_openat2+0x16f/0x3b0 fs/open.c:1179
 do_sys_open fs/open.c:1195 [inline]
 ksys_open include/linux/syscalls.h:1388 [inline]
 __do_sys_open fs/open.c:1201 [inline]
 __se_sys_open fs/open.c:1199 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1199
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888089f54000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2360 bytes inside of
 4096-byte region [ffff888089f54000, ffff888089f55000)
The buggy address belongs to the page:
page:ffffea000227d500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea000227d500 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0001e59308 ffffea00028b3908 ffff8880aa002000
raw: 0000000000000000 ffff888089f54000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888089f54800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888089f54880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888089f54900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888089f54980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888089f54a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
