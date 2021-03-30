Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF8A34F3AD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhC3Vp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:45:57 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39543 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhC3VpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:45:20 -0400
Received: by mail-il1-f197.google.com with SMTP id v20so178231ile.6
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=j4vHEfDUIWjWWNIt1cQZKz6843+yacPTPceNoi6dp+k=;
        b=c0Is/YvVz4tmpk4hsdiOJrqwqdEDskffTLoy+xI44EBLQbeibvsN5v+Pg1zza2pA9L
         yza4+F8CNAnincaF4zETed1GYIol1VgBJcG/cJaPpNYlfkzX1SDj1Pmh9tIepNflCV4D
         Wvei2LG4tAjzXKCrTohvLcp9ijCayGpoxSbRix5kemCLNfTGRzS8XbVQwmky2BQCRQ0s
         M2z6E27KnvzSPCtBcHOXF3G/Ba06kdzWm0BzEdWqOhcFd/+OfpvN5wwHiqr4x0FiSx0f
         DDMsu6Db6Seaf0YqkuXlYWks0gY4i5+inOjtGVkvj1Jc4cXyYXze9S6ekXUXdUGLbgwn
         qJRA==
X-Gm-Message-State: AOAM531ExCKLVOUMnza4mKGsAAsVrpK9JHil4nkjCiEBo7IHAHq07sEL
        6tTaTd+Ey2HKJGEX7amVnX9Y3Cpktylhf3gIumjsk32m4RYV
X-Google-Smtp-Source: ABdhPJwbZG8CxUnZpgNu4ctFbqDKv1aLG61zPSABCRei5ok9bZu6sVpVSlJX/3U7bcHWX6JFtWEbSmNCJU5aBOhXjccoJFgbUv6I
MIME-Version: 1.0
X-Received: by 2002:a92:d784:: with SMTP id d4mr272151iln.184.1617140719719;
 Tue, 30 Mar 2021 14:45:19 -0700 (PDT)
Date:   Tue, 30 Mar 2021 14:45:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000269d0705bec7ea73@google.com>
Subject: [syzbot] KASAN: use-after-free Read in delete_partition (2)
From:   syzbot <syzbot+7d6c5587ec9cff5be65c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, davem@davemloft.net, hare@suse.de, hch@lst.de,
        jack@suse.cz, johannes.thumshirn@edc.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        richard@nod.at, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    93129492 Add linux-next specific files for 20210326
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1372ce62d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c9322cd4e3b7a16
dashboard link: https://syzkaller.appspot.com/bug?extid=7d6c5587ec9cff5be65c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1433834ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149c71aad00000

The issue was bisected to:

commit daaedb820ad716e00210af8859b194c404202b78
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 3 10:00:09 2020 +0000

    mtd_blkdevs: don't override BLKFLSBUF

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=102c6ddcd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=122c6ddcd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=142c6ddcd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d6c5587ec9cff5be65c@syzkaller.appspotmail.com
Fixes: daaedb820ad7 ("mtd_blkdevs: don't override BLKFLSBUF")

==================================================================
BUG: KASAN: use-after-free in kobject_put+0x493/0x540 lib/kobject.c:749
Read of size 1 at addr ffff8880135d453c by task syz-executor372/8533

CPU: 0 PID: 8533 Comm: syz-executor372 Not tainted 5.12.0-rc4-next-20210326-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 kobject_put+0x493/0x540 lib/kobject.c:749
 delete_partition+0xa4/0x170 block/partitions/core.c:291
 bdev_del_partition+0xf5/0x110 block/partitions/core.c:474
 blkpg_do_ioctl+0x2e8/0x340 block/ioctl.c:33
 blkpg_ioctl block/ioctl.c:60 [inline]
 blkdev_ioctl+0x577/0x6d0 block/ioctl.c:548
 block_ioctl+0xf9/0x140 fs/block_dev.c:1667
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x444329
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd8945e58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000487072 RCX: 0000000000444329
RDX: 0000000020000240 RSI: 0000000000001269 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0023706f6f6c2f76 R09: 0000000000000001
R10: 000000000000001f R11: 0000000000000246 R12: 0000000000012734
R13: 00007ffdd8945e6c R14: 00007ffdd8945e80 R15: 00007ffdd8945e70

Allocated by task 8534:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 kobject_create lib/kobject.c:784 [inline]
 kobject_create_and_add+0x42/0xb0 lib/kobject.c:810
 add_partition+0x56c/0x880 block/partitions/core.c:384
 bdev_add_partition+0xb6/0x130 block/partitions/core.c:449
 blkpg_do_ioctl+0x2d0/0x340 block/ioctl.c:43
 blkpg_ioctl block/ioctl.c:60 [inline]
 blkdev_ioctl+0x577/0x6d0 block/ioctl.c:548
 block_ioctl+0xf9/0x140 fs/block_dev.c:1667
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8534:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1578 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1603
 slab_free mm/slub.c:3163 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4230
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 delete_partition+0xa4/0x170 block/partitions/core.c:291
 bdev_del_partition+0xf5/0x110 block/partitions/core.c:474
 blkpg_do_ioctl+0x2e8/0x340 block/ioctl.c:33
 blkpg_ioctl block/ioctl.c:60 [inline]
 blkdev_ioctl+0x577/0x6d0 block/ioctl.c:548
 block_ioctl+0xf9/0x140 fs/block_dev.c:1667
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8880135d4500
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 60 bytes inside of
 64-byte region [ffff8880135d4500, ffff8880135d4540)
The buggy address belongs to the page:
page:ffffea00004d7500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x135d4
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 0000000000000000 0000000100000001 ffff888010841640
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880135d4400: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880135d4480: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff8880135d4500: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                        ^
 ffff8880135d4580: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff8880135d4600: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
