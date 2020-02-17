Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A223516147E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgBQOYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:24:17 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:55723 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgBQOYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:24:15 -0500
Received: by mail-il1-f197.google.com with SMTP id w62so14341771ila.22
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 06:24:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hnJSDbHMcnssCWRWqbDwgLrcjj0vFs982qQBvNrf2ss=;
        b=rHMIQ3LlDbSt2f0Ld5qgVwGvrMD91lOkpuvfgO8y4H2dVzR6rKY6EVO5RsJi0Tx77O
         QAASZmTQCUWYdpZ10IkuUK7ec2wEB+8YP+Y/EZL04oWJjDpTjxeXxziKvc1YlWhUTakW
         ZSON8bWyNV61miFkbDsImHnemfdqbFttjH54SgLb8C1IpI8jTFUQKigEohWOOxRD9xGX
         XjWBCW71PPp02qSz9vWEKFstalD8OylYGCJv4qnkrxYuDRt8vqdDbE6TAXWSfVOMFSJ/
         6KiJ13lM+VaRYdNmRp8VTsg1m8YSLqpQCuSUmjDC2q+eAj6bbQhMbGc8v/UVEnhwshGs
         E5pw==
X-Gm-Message-State: APjAAAUOObQ+P8+j0na10gkhJ5/h8bLefxl/CAvrBVO5oB5ayaS99Inn
        9ldBpZyK2t4YmYdawKR7Y3cVpGTZwfspLmId8VHN93RfCLce
X-Google-Smtp-Source: APXvYqzQL2hTxR8fMdsQoHup4xu8dl9sqNfHTiHzCiY90UAocR1Gr7POyZuAlFVK/7/Mkv0/MM2rRcrQmNZs92PfptY7+Wzm0o1k
MIME-Version: 1.0
X-Received: by 2002:a02:cd12:: with SMTP id g18mr12660761jaq.76.1581949453102;
 Mon, 17 Feb 2020 06:24:13 -0800 (PST)
Date:   Mon, 17 Feb 2020 06:24:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003474b5059ec64f30@google.com>
Subject: KASAN: use-after-free Read in evict
From:   syzbot <syzbot+6ef7546f7398f3f97609@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fdfa3a67 Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17d4c07ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71f1d0a1df5278ab
dashboard link: https://syzkaller.appspot.com/bug?extid=6ef7546f7398f3f97609
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6ef7546f7398f3f97609@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0xdc/0xf5 lib/list_debug.c:54
Read of size 8 at addr ffff888096b35650 by task syz-executor.2/16535

CPU: 0 PID: 16535 Comm: syz-executor.2 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 __list_del_entry_valid+0xdc/0xf5 lib/list_debug.c:54
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_init include/linux/list.h:204 [inline]
 inode_io_list_del_locked+0x8b/0x200 fs/fs-writeback.c:148
 inode_io_list_del+0x32/0x40 fs/fs-writeback.c:1126
 evict+0x11d/0x680 fs/inode.c:562
 iput_final fs/inode.c:1571 [inline]
 iput+0x55d/0x900 fs/inode.c:1597
 dentry_unlink_inode+0x2d9/0x400 fs/dcache.c:374
 d_delete fs/dcache.c:2451 [inline]
 d_delete+0x128/0x160 fs/dcache.c:2440
 vfs_rmdir fs/namei.c:3966 [inline]
 vfs_rmdir+0x41f/0x4f0 fs/namei.c:3931
 do_rmdir+0x39e/0x420 fs/namei.c:4014
 __do_sys_rmdir fs/namei.c:4032 [inline]
 __se_sys_rmdir fs/namei.c:4030 [inline]
 __x64_sys_rmdir+0x36/0x40 fs/namei.c:4030
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b127
Code: 00 66 90 b8 57 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 2d b9 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 54 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 0d b9 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff57350a28 EFLAGS: 00000207 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 000000000045b127
RDX: 0000000000000000 RSI: 000000000071e698 RDI: 00007fff57351b60
RBP: 0000000000000102 R08: 0000000000000000 R09: 0000000000000001
R10: 000000000000000a R11: 0000000000000207 R12: 00007fff57351b60
R13: 0000000001773940 R14: 0000000000000000 R15: 00007fff57351b60

Allocated by task 18898:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:523
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x121/0x710 mm/slab.c:3484
 ext4_alloc_inode+0x1f/0x5c0 fs/ext4/super.c:1119
 alloc_inode+0x68/0x1e0 fs/inode.c:231
 new_inode_pseudo+0x19/0xf0 fs/inode.c:927
 new_inode+0x1f/0x40 fs/inode.c:956
 __ext4_new_inode+0x3d5/0x4fa0 fs/ext4/ialloc.c:827
 ext4_create+0x38a/0x520 fs/ext4/namei.c:2606
 lookup_open+0x12d5/0x1a90 fs/namei.c:3309
 do_last fs/namei.c:3401 [inline]
 path_openat+0xf2c/0x3490 fs/namei.c:3607
 do_filp_open+0x192/0x260 fs/namei.c:3637
 do_sys_openat2+0x5eb/0x7e0 fs/open.c:1149
 do_sys_open+0xf2/0x180 fs/open.c:1165
 __do_sys_openat fs/open.c:1179 [inline]
 __se_sys_openat fs/open.c:1174 [inline]
 __x64_sys_openat+0x9d/0x100 fs/open.c:1174
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x86/0x320 mm/slab.c:3694
 ext4_free_in_core_inode+0x28/0x30 fs/ext4/super.c:1164
 i_callback+0x44/0x80 fs/inode.c:220
 rcu_do_batch kernel/rcu/tree.c:2186 [inline]
 rcu_core+0x5e1/0x1390 kernel/rcu/tree.c:2410
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
 __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff888096b352c0
 which belongs to the cache ext4_inode_cache(49:syz2) of size 2008
The buggy address is located 912 bytes inside of
 2008-byte region [ffff888096b352c0, ffff888096b35a98)
The buggy address belongs to the page:
page:ffffea00025acd40 refcount:1 mapcount:0 mapping:ffff8880a7474380 index:0xffff888096b35fff
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00025a66c8 ffff888091161e48 ffff8880a7474380
raw: ffff888096b35fff ffff888096b352c0 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888096b35500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888096b35580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888096b35600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff888096b35680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888096b35700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
