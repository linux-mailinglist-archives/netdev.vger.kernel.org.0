Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D7305E42
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhA0O2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:28:54 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:44067 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbhA0O16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:27:58 -0500
Received: by mail-io1-f72.google.com with SMTP id e12so1730103ioh.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:27:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8VGU7lzcZPBC9+aLCSWRVDY7ZbRBLcCqKCjAuMe7EJs=;
        b=fZ9dLpOFEocwM2JGYa3kkiyXkfRrdU8o2sp30sQFsfUPC5bwD3wBTd1NvcmZI5tyaW
         uW/hl0WtRS2e/5Ozksx/SgktVeMNeyEKUamgSj/39mKpn62NUqBv/KiJiqVC8UtF001r
         EoPjIpBM5RKvpMrGP0kaslPjlD2RMB8eLTd0lVAZk7fgm+fUhJsztTvqbEti9bEgArUG
         OH/PMfrvp2xIjx5U72aKL8RyhxIkSnlEHc7zunuNrkZyUzf9RGK08mi2Fcs38JnNZG1F
         b9BRwuHD/xLutxHG0tcGSmVwwY2SA2LN6IGnh6QYZGPO5A8vz7n9UwxHop+t9Gw5d1HI
         84tg==
X-Gm-Message-State: AOAM530Oj7oFATbH+sAIjO/3gF72XMlyM9WfwQdSFRvmlQtkRj+Zi126
        FbG6GX7lp4CKZst/fpB1mpvKFQW3S2JD/hO2guYr+iG8S8wY
X-Google-Smtp-Source: ABdhPJx02bpZ3C7AxDk7opvltlU2/f4W54mUwJ+nKtavYPVvihkm7WfYoXEp56/hCu+8oiWolEf1k/0U6Dh7P5N1vXxb5bczYer1
MIME-Version: 1.0
X-Received: by 2002:a02:cf0f:: with SMTP id q15mr9429480jar.40.1611757636751;
 Wed, 27 Jan 2021 06:27:16 -0800 (PST)
Date:   Wed, 27 Jan 2021 06:27:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000672eda05b9e291ff@google.com>
Subject: KASAN: invalid-free in p9_client_create (2)
From:   syzbot <syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, asmadeus@codewreck.org,
        davem@davemloft.net, ericvh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, wanghai38@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fe75a218 Merge tag 'for-5.11/dm-fixes-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b7d52cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be33d8015c9de024
dashboard link: https://syzkaller.appspot.com/bug?extid=d0bd96b4696c1ef67991
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138a8eb4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131ac26f500000

The issue was bisected to:

commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2
Author: Wang Hai <wanghai38@huawei.com>
Date:   Wed Jun 3 22:56:21 2020 +0000

    mm/slub: fix a memory leak in sysfs_slab_add()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138e36b4d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=104e36b4d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=178e36b4d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com
Fixes: dde3c6b72a16 ("mm/slub: fix a memory leak in sysfs_slab_add()")

==================================================================
BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3142 [inline]
BUG: KASAN: double-free or invalid-free in kmem_cache_free+0x82/0x350 mm/slub.c:3158

CPU: 0 PID: 8594 Comm: syz-executor034 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:355
 ____kasan_slab_free+0xfd/0x110 mm/kasan/common.c:341
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 create_cache mm/slab_common.c:269 [inline]
 kmem_cache_create_usercopy+0x2ab/0x300 mm/slab_common.c:352
 p9_client_create+0xc9f/0x1110 net/9p/client.c:1063
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9c0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x13ad/0x20c0 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount fs/namespace.c:3409 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447579
Code: e8 ac e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fda7a63bd88 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00000000006dcc68 RCX: 0000000000447579
RDX: 0000000020000280 RSI: 00000000200002c0 RDI: 0000000000000000
RBP: 00000000006dcc60 R08: 0000000020000480 R09: 0000000000003333
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc6c
R13: 00007fda7a63bd90 R14: 0000000000000007 R15: 0000000000000064

Allocated by task 8594:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kasan_slab_alloc include/linux/kasan.h:209 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 slab_alloc mm/slub.c:2899 [inline]
 kmem_cache_alloc+0x1c6/0x440 mm/slub.c:2904
 kmem_cache_zalloc include/linux/slab.h:672 [inline]
 create_cache mm/slab_common.c:246 [inline]
 kmem_cache_create_usercopy+0x1a6/0x300 mm/slab_common.c:352
 p9_client_create+0xc9f/0x1110 net/9p/client.c:1063
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9c0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x13ad/0x20c0 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount fs/namespace.c:3409 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8594:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 sysfs_slab_add+0x164/0x1d0 mm/slub.c:5628
 __kmem_cache_create+0x471/0x5a0 mm/slub.c:4444
 create_cache mm/slab_common.c:257 [inline]
 kmem_cache_create_usercopy+0x1ed/0x300 mm/slab_common.c:352
 p9_client_create+0xc9f/0x1110 net/9p/client.c:1063
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9c0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x13ad/0x20c0 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount fs/namespace.c:3409 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888021cf28c0
 which belongs to the cache kmem_cache of size 224
The buggy address is located 0 bytes inside of
 224-byte region [ffff888021cf28c0, ffff888021cf29a0)
The buggy address belongs to the page:
page:00000000b5194f0f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21cf2
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010041000
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888021cf2780: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021cf2800: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff888021cf2880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                           ^
 ffff888021cf2900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021cf2980: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
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
