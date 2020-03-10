Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E87180284
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCJPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:55:15 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42763 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgCJPzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:55:15 -0400
Received: by mail-il1-f198.google.com with SMTP id j88so7003862ilg.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hfYTmFBUkj/aSmF7eDTw4L8JGcK+jo9iAAdS7lmp/P4=;
        b=YdFFP1f37ov5l0S59QFoqB6dt5mgy6lIhFFjNslbTupCxs54RRtUtqjzqTIq9+JNr3
         PtS+0C6nJ4Wcwa8bcIj5HkP3oT4LEThkKkoqpLj6fUS6qMKLr4A3tuyrSMeSKZvhe7Nr
         azle/FSbMwbX1NEyzgrn+DhLXRjl8V9NO2GOrriuGr4wTGSOGCGfMlahw9FQjDCnO1BA
         fs7K0R/f5cOOkH47glz5qR/9ekV8iomVuEeWi8HfJiC2bIlO4rkD8+8GHWtg/I0n4cox
         FZilwijalyInzTkF1MYKzahPWqel7wfA5s2gxrEvSJyiL8tXCTK9PgTUUhU1XpNXf9G2
         +HPA==
X-Gm-Message-State: ANhLgQ3NqObANeKR1UHHbg9+TyFLKpoBC2XQ4gX9xAg4j7BlOEq5K9vW
        o/r2OO0omo7o3rpD0/QTImAgT6sAZyrehEvMovZVhwhkz3Yl
X-Google-Smtp-Source: ADFU+vtz6Cs7cd1vZftsLF+QYyCNMfxK6cInkd9CJ0phSyyysB1E7J7LSMbEsoUq3oywLDSov4QpZz6r4Qf+9630a68/ON9/SOSW
MIME-Version: 1.0
X-Received: by 2002:a6b:fb01:: with SMTP id h1mr18251940iog.16.1583855714812;
 Tue, 10 Mar 2020 08:55:14 -0700 (PDT)
Date:   Tue, 10 Mar 2020 08:55:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041c6c205a08225dc@google.com>
Subject: KASAN: slab-out-of-bounds Read in cgroup_file_notify
From:   syzbot <syzbot+cac0c4e204952cf449b1@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, almasrymina@google.com, andriin@fb.com,
        ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
        christian@brauner.io, daniel@iogearbox.net, hannes@cmpxchg.org,
        kafai@fb.com, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c99b17ac Add linux-next specific files for 20200225
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1610d70de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6b7ebe4bd0931c45
dashboard link: https://syzkaller.appspot.com/bug?extid=cac0c4e204952cf449b1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1242e1fde00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1110d70de00000

The bug was bisected to:

commit 6863de00e5400b534cd4e3869ffbc8f94da41dfc
Author: Mina Almasry <almasrymina@google.com>
Date:   Thu Feb 20 03:55:30 2020 +0000

    hugetlb_cgroup: add accounting for shared mappings

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a17f0de00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11a17f0de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a17f0de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cac0c4e204952cf449b1@syzkaller.appspotmail.com
Fixes: 6863de00e540 ("hugetlb_cgroup: add accounting for shared mappings")

==================================================================
BUG: KASAN: slab-out-of-bounds in cgroup_file_notify+0x16a/0x1b0 kernel/cgroup/cgroup.c:4084
Read of size 8 at addr ffff88821b77c4c8 by task syz-executor540/9589

CPU: 0 PID: 9589 Comm: syz-executor540 Not tainted 5.6.0-rc3-next-20200225-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 cgroup_file_notify+0x16a/0x1b0 kernel/cgroup/cgroup.c:4084
 hugetlb_event mm/hugetlb_cgroup.c:224 [inline]
 __hugetlb_cgroup_charge_cgroup+0x88c/0xf10 mm/hugetlb_cgroup.c:262
 hugetlb_cgroup_charge_cgroup_rsvd+0x2b/0x40 mm/hugetlb_cgroup.c:286
 hugetlb_reserve_pages+0x2c2/0xce0 mm/hugetlb.c:4891
 hugetlb_file_setup+0x26a/0x671 fs/hugetlbfs/inode.c:1423
 newseg+0x4a3/0xf40 ipc/shm.c:652
 ipcget_new ipc/util.c:344 [inline]
 ipcget+0x105/0xd40 ipc/util.c:643
 ksys_shmget ipc/shm.c:742 [inline]
 __do_sys_shmget ipc/shm.c:747 [inline]
 __se_sys_shmget ipc/shm.c:745 [inline]
 __x64_sys_shmget+0x146/0x1d0 ipc/shm.c:745
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440119
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd5e1db3e8 EFLAGS: 00000246 ORIG_RAX: 000000000000001d
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440119
RDX: 0000000000004800 RSI: fffffffffeffffff RDI: 0000000000000000
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020ffc000 R11: 0000000000000246 R12: 00000000004019a0
R13: 0000000000401a30 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 0:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hugetlb_cgroup_css_alloc+0x4f/0x320 mm/hugetlb_cgroup.c:138
 cgroup_init_subsys+0x1d9/0x4a7 kernel/cgroup/cgroup.c:5582
 cgroup_init+0x34a/0xa4c kernel/cgroup/cgroup.c:5708
 start_kernel+0xe2d/0xe8f init/main.c:987
 x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
 x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88821b77c000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1224 bytes inside of
 2048-byte region [ffff88821b77c000, ffff88821b77c800)
The buggy address belongs to the page:
page:ffffea00086ddf00 refcount:1 mapcount:0 mapping:000000005a8512d0 index:0x0
flags: 0x57ffe0000000200(slab)
raw: 057ffe0000000200 ffffea00086dde48 ffffea00086ddf88 ffff8880aa400e00
raw: 0000000000000000 ffff88821b77c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88821b77c380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88821b77c400: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>ffff88821b77c480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                              ^
 ffff88821b77c500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88821b77c580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
