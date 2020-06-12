Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002551F75DF
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 11:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgFLJYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 05:24:13 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:52498 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgFLJYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 05:24:12 -0400
Received: by mail-il1-f197.google.com with SMTP id v14so5983538ilo.19
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 02:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=G+HZh4mhFhAwMVR6n/No7HJ3NlUbn0CRpmJVSgxGS9g=;
        b=lX+Kf/wULC5NhA+xv1p1B1OUlXdeHc3Vei99UINSW7H0ZBrv3+b+uP3NI1p4q0rg/K
         cxKvjz3yY4AwNdOP2kcm8Jff6W/G6HkRUhn1bOpoDtFL+Z8izDMWrIiE8+YqM/xMZijs
         5R4hVSGhQ9k9QXo3ogijbvj/zqGudcW9g21TIzM9/9Dr5lgqzXrx3oMIhmpNkPlDq9Yh
         16WzxTnsp4I6w9ZtEqJWJ1yaLMbJWy7On7NiTh7RaJcwp3uEH3vS/cjKtgJv5/2783Aw
         cM0ZY9eb3vc1U/w78zoPT6j1kZA/GVYBDgd5nasK23QzcoB6zAl/+siHgkw3Rwy5WbS+
         Be8A==
X-Gm-Message-State: AOAM530+RkeEyh0tVoB2Ouf6ZVNPqyLc3ZOweUNE9RgTh0qB+qc9AEVc
        UBtk3pEycEJLExQeymbD43yK34bQmjuNx5vtDdKEXbhy+nHC
X-Google-Smtp-Source: ABdhPJzjURpQ1YBkZ95I8AFVO4cvr2ERC+3dMIHpwpYHXvZTNy24xl3t5Dpe0hqVhPsYDUPT/5r7Qd2kvhLlhbo2N/xr3Jr4YiX3
MIME-Version: 1.0
X-Received: by 2002:a92:c6cd:: with SMTP id v13mr11574126ilm.150.1591953851908;
 Fri, 12 Jun 2020 02:24:11 -0700 (PDT)
Date:   Fri, 12 Jun 2020 02:24:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d788c905a7dfa3f4@google.com>
Subject: KASAN: use-after-free Write in fsnotify_detach_connector_from_object
From:   syzbot <syzbot+7d2debdcdb3cb93c1e5e@syzkaller.appspotmail.com>
To:     a@unstable.cc, adobriyan@gmail.com, akpm@linux-foundation.org,
        alex.dewar@gmx.co.uk, amir73il@gmail.com,
        anton.ivanov@cambridgegreys.com, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, ebiederm@xmission.com, jack@suse.cz,
        jdike@addtoit.com, kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org, richard@nod.at,
        sfr@canb.auug.org.au, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120b26c1100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=7d2debdcdb3cb93c1e5e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1724b246100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ceb3de100000

The bug was bisected to:

commit 76313c70c52f930af4afd21684509ca52297ea71
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Wed Feb 19 16:37:15 2020 +0000

    uml: Create a private mount of proc for mconsole

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117c4912100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=137c4912100000
console output: https://syzkaller.appspot.com/x/log.txt?x=157c4912100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7d2debdcdb3cb93c1e5e@syzkaller.appspotmail.com
Fixes: 76313c70c52f ("uml: Create a private mount of proc for mconsole")

==================================================================
BUG: KASAN: use-after-free in atomic64_inc include/asm-generic/atomic-instrumented.h:1049 [inline]
BUG: KASAN: use-after-free in atomic_long_inc include/asm-generic/atomic-long.h:160 [inline]
BUG: KASAN: use-after-free in fsnotify_detach_connector_from_object+0x25e/0x380 fs/notify/mark.c:185
Write of size 8 at addr ffff88809fd7e7c0 by task syz-executor972/8021

CPU: 1 PID: 8021 Comm: syz-executor972 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:192
 atomic64_inc include/asm-generic/atomic-instrumented.h:1049 [inline]
 atomic_long_inc include/asm-generic/atomic-long.h:160 [inline]
 fsnotify_detach_connector_from_object+0x25e/0x380 fs/notify/mark.c:185
 fsnotify_put_mark+0x367/0x580 fs/notify/mark.c:250
 fsnotify_clear_marks_by_group+0x33f/0x490 fs/notify/mark.c:764
 fsnotify_destroy_group+0xc9/0x300 fs/notify/group.c:61
 inotify_release+0x33/0x40 fs/notify/inotify/inotify_user.c:271
 __fput+0x33e/0x880 fs/file_table.c:281
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xb3f/0x2de0 kernel/exit.c:806
 do_group_exit+0x125/0x340 kernel/exit.c:904
 __do_sys_exit_group kernel/exit.c:915 [inline]
 __se_sys_exit_group kernel/exit.c:913 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:913
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x445448
Code: Bad RIP value.
RSP: 002b:00007ffe48521018 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000445448
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004cca90 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00007ffe48521060 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006e0340 R14: 0000000000000007 R15: 000000000000002d

Allocated by task 8026:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 alloc_super+0x52/0x9d0 fs/super.c:203
 sget_fc+0x13f/0x790 fs/super.c:530
 vfs_get_super+0x6d/0x2d0 fs/super.c:1186
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2874 [inline]
 do_mount+0x1306/0x1b40 fs/namespace.c:3199
 __do_sys_mount fs/namespace.c:3409 [inline]
 __se_sys_mount fs/namespace.c:3386 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3386
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 23:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

The buggy address belongs to the object at ffff88809fd7e000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1984 bytes inside of
 4096-byte region [ffff88809fd7e000, ffff88809fd7f000)
The buggy address belongs to the page:
page:ffffea00027f5f80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00027f5f80 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea000247aa88 ffffea000242ef08 ffff8880aa002000
raw: 0000000000000000 ffff88809fd7e000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809fd7e680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809fd7e700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88809fd7e780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88809fd7e800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809fd7e880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
