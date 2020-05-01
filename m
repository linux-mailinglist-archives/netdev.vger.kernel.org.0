Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7430A1C1157
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 13:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgEALJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 07:09:19 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:53075 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgEALJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 07:09:18 -0400
Received: by mail-il1-f199.google.com with SMTP id l9so4398740ili.19
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 04:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6NqdmlOfSLvBUqffTv0jBBGWaw7cUouN9KdGAg4Bx/E=;
        b=jfRv/5rNe8Oh5JTcDqjAcI6uIvgDo+aOusluHo7ZXFfDyNwN87JDZzxtzUO0MHRIID
         lvM7KDdLNVjyDd+6+9XeH6H5iNaTQfCRJYpXJ5QLzLZ6cMjqldA7Ewp5JrGjVIXYANt0
         3lmx5sezmogp5CiMA1XKd40G2f5TEnOeR83/LPZfyT8P4EpeNus22ZEow2OhFO7PEEf+
         Xnzo9580IcRRDS7PC/k8znxQOOAYPnI5IctKp9G/P3SRsvn2kj3Amlf8lt3X2NiAe0Za
         y3FMNYV8343MEr1haqn9UijHRHaqPv2dJsjKeAvqW2vIhoZP4ruoOxb1Nn87C8bA9pDR
         2JSA==
X-Gm-Message-State: AGi0PubFDxjo3178fbVLtbLSRIGhuT5IwqXseIIusNCZt82uHzMP84UX
        v7crGg73nrSgPOUoHSRS5PeJW0PagF+AF/8Z6eth8QXNZq6Y
X-Google-Smtp-Source: APiQypLDPLjtEZ9aO52H75iqwbBI0TXJXelwsH8OX9v0vpsHpW5HM81A6E2w5pzvFSeE58tVjKErKzbEjn9KvdeiZE/hYMu7cPaG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2a2:: with SMTP id d2mr2772738jaq.104.1588331357046;
 Fri, 01 May 2020 04:09:17 -0700 (PDT)
Date:   Fri, 01 May 2020 04:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052913105a4943655@google.com>
Subject: KASAN: use-after-free Read in inet_diag_bc_sk
From:   syzbot <syzbot+13bef047dbfffa5cd1af@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    37ecb5b8 hinic: Use kmemdup instead of kzalloc and memcpy
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=141e54bc100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1494ce3fbc02154
dashboard link: https://syzkaller.appspot.com/bug?extid=13bef047dbfffa5cd1af
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12296e60100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150c6f02100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+13bef047dbfffa5cd1af@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cgroup_id include/linux/cgroup.h:312 [inline]
BUG: KASAN: use-after-free in inet_diag_bc_sk+0xb6e/0xc70 net/ipv4/inet_diag.c:749
Read of size 8 at addr ffff88821b2c9f08 by task syz-executor674/7229

CPU: 1 PID: 7229 Comm: syz-executor674 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 cgroup_id include/linux/cgroup.h:312 [inline]
 inet_diag_bc_sk+0xb6e/0xc70 net/ipv4/inet_diag.c:749
 inet_diag_dump_icsk+0xbe4/0x1306 net/ipv4/inet_diag.c:1061
 __inet_diag_dump+0x8d/0x240 net/ipv4/inet_diag.c:1113
 netlink_dump+0x50b/0xf50 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x63f/0x910 net/netlink/af_netlink.c:2353
 netlink_dump_start include/linux/netlink.h:246 [inline]
 inet_diag_handler_cmd+0x263/0x2c0 net/ipv4/inet_diag.c:1278
 __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 sock_diag_rcv_msg+0x2fe/0x3e0 net/core/sock_diag.c:264
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 do_iter_readv_writev+0x5a8/0x850 fs/read_write.c:694
 do_iter_write fs/read_write.c:999 [inline]
 do_iter_write+0x18b/0x600 fs/read_write.c:980
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1072
 do_writev+0x27f/0x300 fs/read_write.c:1115
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x443d69
Code: e8 8c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffea5636068 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443d69
RDX: 0000000000000001 RSI: 0000000020000200 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000e475
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 1:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x11b/0x740 mm/slab.c:3484
 kmem_cache_zalloc include/linux/slab.h:659 [inline]
 __kernfs_new_node+0xd4/0x690 fs/kernfs/dir.c:627
 kernfs_new_node+0x93/0x120 fs/kernfs/dir.c:689
 __kernfs_create_file+0x51/0x350 fs/kernfs/file.c:1001
 sysfs_add_file_mode_ns+0x224/0x520 fs/sysfs/file.c:305
 create_files fs/sysfs/group.c:64 [inline]
 internal_create_group+0x327/0xba0 fs/sysfs/group.c:149
 kernel_add_sysfs_param kernel/params.c:795 [inline]
 param_sysfs_builtin kernel/params.c:832 [inline]
 param_sysfs_init+0x3a0/0x430 kernel/params.c:953
 do_one_initcall+0x10a/0x7d0 init/main.c:1157
 do_initcall_level init/main.c:1230 [inline]
 do_initcalls init/main.c:1246 [inline]
 do_basic_setup init/main.c:1266 [inline]
 kernel_init_freeable+0x501/0x5ae init/main.c:1450
 kernel_init+0xd/0x1bb init/main.c:1357
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 1:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x7f/0x320 mm/slab.c:3694
 kernfs_put fs/kernfs/dir.c:537 [inline]
 kernfs_put+0x2f9/0x570 fs/kernfs/dir.c:506
 __kernfs_remove fs/kernfs/dir.c:1344 [inline]
 __kernfs_remove+0x690/0x950 fs/kernfs/dir.c:1282
 kernfs_remove_by_name_ns+0x51/0xb0 fs/kernfs/dir.c:1516
 kernfs_remove_by_name include/linux/kernfs.h:593 [inline]
 remove_files.isra.0+0x76/0x190 fs/sysfs/group.c:28
 sysfs_remove_group+0xb3/0x1b0 fs/sysfs/group.c:289
 kernel_add_sysfs_param kernel/params.c:790 [inline]
 param_sysfs_builtin kernel/params.c:832 [inline]
 param_sysfs_init+0x333/0x430 kernel/params.c:953
 do_one_initcall+0x10a/0x7d0 init/main.c:1157
 do_initcall_level init/main.c:1230 [inline]
 do_initcalls init/main.c:1246 [inline]
 do_basic_setup init/main.c:1266 [inline]
 kernel_init_freeable+0x501/0x5ae init/main.c:1450
 kernel_init+0xd/0x1bb init/main.c:1357
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88821b2c9e80
 which belongs to the cache kernfs_node_cache of size 168
The buggy address is located 136 bytes inside of
 168-byte region [ffff88821b2c9e80, ffff88821b2c9f28)
The buggy address belongs to the page:
page:ffffea00086cb240 refcount:1 mapcount:0 mapping:00000000c46c458d index:0xffff88821b2c9000
flags: 0x57ffe0000000200(slab)
raw: 057ffe0000000200 ffffea00086cb288 ffffea00086cb148 ffff88821bc508c0
raw: ffff88821b2c9000 ffff88821b2c9000 0000000100000009 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88821b2c9e00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff88821b2c9e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88821b2c9f00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff88821b2c9f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88821b2ca000: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
