Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECA5046E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbfFXIWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:22:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39555 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfFXIWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 04:22:05 -0400
Received: by mail-io1-f70.google.com with SMTP id y13so21063011iol.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 01:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YZgcLfRhyHL78sZ7TJjPKJ+WSFoTOyOmk/4C7t9HRo8=;
        b=Lj/K0Xn1h4mJYatJYaYMRm+oq2it1isvubCzHQfIIpObDXqeaRHGOHGZhI5Catm6i6
         7np60XTnyYngP2zE15PVjTsGKYEKfb+R0sQ+XQ390cQZT7dP/Jh4MgjehhDoQG278NBf
         eVcAVpS6g8UZqDmTyGrSsiRpxleihPVp1JmNtWIu9eo/9oIIcuXEV9JlUoilJal3MhET
         i5oh5YS2FAKITq35sC5CCNidXizdE3R97kyuVqIoOlkGmNagizOZsXHI2cOe2x3lH5MH
         za7irw5whWKhFUnO1tl/FeSz8L+jFSGQdVCe/oQdHIyWtJkDh9N4l+pqh/PM6dHIakRo
         4N2w==
X-Gm-Message-State: APjAAAW9qAFy41gu8PVkvKIG2C/D63D95glSZvw5ijQQZeMB64eGt21y
        LHU4xoGX9q3WgXddmgeOPoTwO1G8PlJWO7Qrim6mo2jVA8hV
X-Google-Smtp-Source: APXvYqyTRl/9CxZYV5oILQSkgPDgew5gV2YyknZv22+rXw/aaGKjOmEBIokdOqn2xMKmw1VGbcP/D52avGDpC4Q1rbfOebwvnId7
MIME-Version: 1.0
X-Received: by 2002:a02:5a89:: with SMTP id v131mr15706664jaa.130.1561364524867;
 Mon, 24 Jun 2019 01:22:04 -0700 (PDT)
Date:   Mon, 24 Jun 2019 01:22:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dea828058c0d815d@google.com>
Subject: KASAN: use-after-free Read in _free_event
From:   syzbot <syzbot+37100ea87beb0cac28f4@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        jolsa@redhat.com, kafai@fb.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179ccd3aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=37100ea87beb0cac28f4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+37100ea87beb0cac28f4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_sub_and_test_checked+0x87/0x200  
lib/refcount.c:182
Read of size 4 at addr ffff88804e9f06e0 by task syz-executor.5/13046

CPU: 1 PID: 13046 Comm: syz-executor.5 Not tainted 5.2.0-rc5+ #38
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
  kasan_check_read+0x11/0x20 mm/kasan/common.c:94
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_sub_and_test_checked+0x87/0x200 lib/refcount.c:182
  refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
  put_task_struct include/linux/sched/task.h:98 [inline]
  _free_event+0x3d5/0x13a0 kernel/events/core.c:4470
  free_event+0x5f/0xd0 kernel/events/core.c:4491
  perf_event_release_kernel+0x5b2/0xbe0 kernel/events/core.c:4652
  perf_release+0x37/0x50 kernel/events/core.c:4666
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x412fb1
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffe25e1b730 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000412fb1
RDX: 0000000000000000 RSI: 0000000000000081 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000760a38 R09: ffffffffffffffff
R10: 00007ffe25e1b800 R11: 0000000000000293 R12: 0000000000760a40
R13: 0000000000000003 R14: 0000000000000001 R15: 000000000075bfd4

Allocated by task 13049:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc_node mm/slab.c:3269 [inline]
  kmem_cache_alloc_node+0x131/0x710 mm/slab.c:3579
  alloc_task_struct_node kernel/fork.c:160 [inline]
  dup_task_struct kernel/fork.c:848 [inline]
  copy_process.part.0+0x43f7/0x6790 kernel/fork.c:1868
  copy_process kernel/fork.c:1800 [inline]
  _do_fork+0x25d/0xfe0 kernel/fork.c:2369
  __do_sys_clone kernel/fork.c:2476 [inline]
  __se_sys_clone kernel/fork.c:2470 [inline]
  __x64_sys_clone+0xbf/0x150 kernel/fork.c:2470
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8689:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kmem_cache_free+0x86/0x260 mm/slab.c:3698
  free_task_struct kernel/fork.c:165 [inline]
  free_task+0xdd/0x120 kernel/fork.c:460
  __delayed_free_task+0x19/0x20 kernel/fork.c:1744
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2092 [inline]
  invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
  rcu_core+0xba5/0x1500 kernel/rcu/tree.c:2291
  __do_softirq+0x25c/0x94c kernel/softirq.c:292

The buggy address belongs to the object at ffff88804e9f06c0
  which belongs to the cache task_struct(97:syz5) of size 6080
The buggy address is located 32 bytes inside of
  6080-byte region [ffff88804e9f06c0, ffff88804e9f1e80)
The buggy address belongs to the page:
page:ffffea00013a7c00 refcount:1 mapcount:0 mapping:ffff888090b5de40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0001681f88 ffffea0001576488 ffff888090b5de40
raw: 0000000000000000 ffff88804e9f06c0 0000000100000001 ffff888058fda540
page dumped because: kasan: bad access detected
page->mem_cgroup:ffff888058fda540

Memory state around the buggy address:
  ffff88804e9f0580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804e9f0600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88804e9f0680: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                        ^
  ffff88804e9f0700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804e9f0780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
