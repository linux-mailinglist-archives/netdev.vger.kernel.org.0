Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCC4D59A7
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 04:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfJNCuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 22:50:10 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:32899 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729852AbfJNCuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 22:50:09 -0400
Received: by mail-io1-f71.google.com with SMTP id g15so24688440ioc.0
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 19:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CcrIogTjKFzF/l7cJ7qbuZIlf5n0t5ZZUGxaSHSOJvo=;
        b=DJdYoV6SfJ/w0IclWH8b5qihL5J0huWPAbi37iWI7QT6EbRv/qu23Z3S1YAKURyIrq
         xmtFz7h48Zg9YzQDQWAFzXLPJ+gC2PtRYtEmslfQ5ZvKauVc7OCxub0dKZaprSY1xL5A
         0UpUoZrU/xrqNzyMYnoSf7/yvjmAjbWOMfGHP4cIpJIpTmw5Ycny01r4U76rSLnBcsZ+
         wOx/b2TC7z8q+PUfMDyZYYj5ERe0HYLQOPbs4FjOWjA3lz5k4Oe+pZf7eayzmgKMIIpm
         jHBIhSIn8JTxrccGBmWrCRCUqpPHwUxjXG7EHQOi02dtkBrrdUvzcev9txoUctfnhVHd
         2cwg==
X-Gm-Message-State: APjAAAWuhmh/K8a0zdNsHFr+PamS73RxIOtXel2bBs/YQ7aofC0hQGhU
        P/ZSE/t+Z4H7oAU0X1R22xljZBYYnjHd1SmXugl6xSFt9d5B
X-Google-Smtp-Source: APXvYqy+MAKjCZSs4IU5vPLfktPF73tUQy4yGm8fYLvY7OpWigU9k595MItLfOwbcI1XjKaEd6F1rRGGgO7CgbrJafD4pZlp/fX/
MIME-Version: 1.0
X-Received: by 2002:a05:6602:240d:: with SMTP id s13mr34652998ioa.228.1571021407358;
 Sun, 13 Oct 2019 19:50:07 -0700 (PDT)
Date:   Sun, 13 Oct 2019 19:50:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eb98030594d5ecdb@google.com>
Subject: KASAN: use-after-free Read in bpf_prog_kallsyms_find (2)
From:   syzbot <syzbot+0bd67ad376a3f4a8606e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        joe@wand.net.nz, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mauricio.vasquez@polito.it,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        quentin.monnet@netronome.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b212921b elf: don't use MAP_FIXED_NOREPLACE for elf execut..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148abb3f600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ec3be9936e004f6
dashboard link: https://syzkaller.appspot.com/bug?extid=0bd67ad376a3f4a8606e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f4f6c3600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a1b857600000

The bug was bisected to:

commit 6c4fc209fcf9d27efbaa48368773e4d2bfbd59aa
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Sat Dec 15 23:49:47 2018 +0000

     bpf: remove useless version check for prog load

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16894e63600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15894e63600000
console output: https://syzkaller.appspot.com/x/log.txt?x=11894e63600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0bd67ad376a3f4a8606e@syzkaller.appspotmail.com
Fixes: 6c4fc209fcf9 ("bpf: remove useless version check for prog load")

==================================================================
BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:199  
[inline]
BUG: KASAN: use-after-free in __lt_find include/linux/rbtree_latch.h:118  
[inline]
BUG: KASAN: use-after-free in latch_tree_find  
include/linux/rbtree_latch.h:208 [inline]
BUG: KASAN: use-after-free in bpf_prog_kallsyms_find kernel/bpf/core.c:674  
[inline]
BUG: KASAN: use-after-free in bpf_prog_kallsyms_find+0x2a9/0x2c0  
kernel/bpf/core.c:667
Read of size 8 at addr ffff8880948217c8 by task syz-executor436/18258

CPU: 0 PID: 18258 Comm: syz-executor436 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __read_once_size include/linux/compiler.h:199 [inline]
  __lt_find include/linux/rbtree_latch.h:118 [inline]
  latch_tree_find include/linux/rbtree_latch.h:208 [inline]
  bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
  bpf_prog_kallsyms_find+0x2a9/0x2c0 kernel/bpf/core.c:667
  is_bpf_text_address+0x78/0x170 kernel/bpf/core.c:709
  kernel_text_address+0x73/0xf0 kernel/extable.c:147
  __kernel_text_address+0xd/0x40 kernel/extable.c:102
  unwind_get_return_address arch/x86/kernel/unwind_frame.c:19 [inline]
  unwind_get_return_address+0x61/0xa0 arch/x86/kernel/unwind_frame.c:14
  arch_stack_walk+0x97/0xf0 arch/x86/kernel/stacktrace.c:26
  stack_trace_save+0xac/0xe0 kernel/stacktrace.c:123
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:686 [inline]
  bpf_check+0xd8/0x99c0 kernel/bpf/verifier.c:9227
  bpf_prog_load+0xe68/0x1660 kernel/bpf/syscall.c:1709
  __do_sys_bpf+0xa44/0x3350 kernel/bpf/syscall.c:2866
  __se_sys_bpf kernel/bpf/syscall.c:2825 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2825
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446949
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f134f31edb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446949
RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 00007ffd29fc3fff R14: 00007f134f31f9c0 R15: 000000000000002d

Allocated by task 18255:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:686 [inline]
  bpf_prog_alloc_no_stats+0xe6/0x2b0 kernel/bpf/core.c:88
  jit_subprogs kernel/bpf/verifier.c:8716 [inline]
  fixup_call_args kernel/bpf/verifier.c:8845 [inline]
  bpf_check+0x6b3d/0x99c0 kernel/bpf/verifier.c:9349
  bpf_prog_load+0xe68/0x1660 kernel/bpf/syscall.c:1709
  __do_sys_bpf+0xa44/0x3350 kernel/bpf/syscall.c:2866
  __se_sys_bpf kernel/bpf/syscall.c:2825 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2825
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 3233:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  __bpf_prog_free+0x87/0xc0 kernel/bpf/core.c:258
  bpf_jit_free+0x64/0x1b0
  bpf_prog_free_deferred+0x1a6/0x350 kernel/bpf/core.c:1980
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888094821780
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 72 bytes inside of
  512-byte region [ffff888094821780, ffff888094821980)
The buggy address belongs to the page:
page:ffffea0002520840 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002a56b88 ffffea0002a5f048 ffff8880aa400a80
raw: 0000000000000000 ffff888094821000 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888094821680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094821700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff888094821780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff888094821800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094821880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
