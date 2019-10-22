Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB57BE058B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbfJVNxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 09:53:12 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46079 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387831AbfJVNxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 09:53:12 -0400
Received: by mail-io1-f70.google.com with SMTP id x8so4387223ion.12
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 06:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oI+nUJz2RUElqM4g3w3uQfGFtRWAgQT0u2wYWbO2+ek=;
        b=GKvz07nYmERZu1a5ie1eZSdgfKFvWu79k8hYsRd8eBhIaam05HkrxSA+yRO46pQ6Ff
         n+ViHFb82mw4lqeHiEcg7UPzqSFXdDNnN1QCGQX0/zM/C0q987ZBMbjrVt92+x34AQs6
         v4ZI/EXsbz6wwmpDsq2gW9qnfdfLKkt9YzkMZuegNnmZqGV5dOkOnW0HGk8MPEitGlS2
         PZDPBi4t6SVKwjwoH7pq5BamU3/BmlfEmzMV9hWRpxQ4OBq3Zyx88Y5EOqv1kwkUOJZP
         XUDz1feqcURLr33Dio/5nuNttPDYCL1ffHzdaDJiXmEqdQPuF7pNrLoSarv68XtKrFS1
         ipQA==
X-Gm-Message-State: APjAAAX7Xjrba2P0gkSEsDdGBoPW+msVVXEDI7scDj3tiSMh6IdWNfy1
        trqA+7ZDnXHatg+quOOtjjTSR8W+IRg2ggWkIqvhaLwMWIjT
X-Google-Smtp-Source: APXvYqz4QqdZ3COJAHIIAix8VGCNwT5qO1PBa6XbqYPOmgpD2phetLgPBALJJz0XzZy6XRVJxGlIvFBzLyOCUNivGgSQtwWudvM/
MIME-Version: 1.0
X-Received: by 2002:a92:5e4d:: with SMTP id s74mr32173976ilb.121.1571752389512;
 Tue, 22 Oct 2019 06:53:09 -0700 (PDT)
Date:   Tue, 22 Oct 2019 06:53:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000da1dfc0595801e46@google.com>
Subject: KASAN: use-after-free Read in is_bpf_text_address
From:   syzbot <syzbot+0cd01c9e0f5cd37a357e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4fe34d61 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b01a60e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f0a8b0a0736a2ac1
dashboard link: https://syzkaller.appspot.com/bug?extid=0cd01c9e0f5cd37a357e
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161f89f7600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e2d0f8e00000

Bisection is inconclusive: the first bad commit could be any of:

7105e828 bpf: allow for correlation of maps and helpers in dump
74661776 Merge branch 'bpftool-improvements-kallsymfix'
4f74d809 bpf: fix kallsyms handling for subprogs
c475ffad tools/bpf: adjust rlimit RLIMIT_MEMLOCK for test_dev_cgroup
5f5a6411 bpf: sparc64: Add JIT support for multi-function programs.
7d9890ef libbpf: Fix build errors.
06ef0ccb bpf/cgroup: fix a verification error for a CGROUP_DEVICE type prog
fd05e57b bpf: fix stacksafe exploration when comparing states
6b80ad29 bpf: selftest for late caller stack size increase
c060bc61 bpf: make function xdp_do_generic_redirect_map() static
4ca998fe selftests/bpf: add netdevsim to config
70a87ffe bpf: fix maximum stack depth tracking logic
5ee7f784 bpf: arm64: fix uninitialized variable
6b86c421 selftests/bpf: additional stack depth tests
aada9ce6 bpf: fix max call depth check
fa2d41ad bpf: make function skip_callee static and return NULL rather than 0
624588d9 Merge branch 'bpf-stack-depth-tracking-fixes'
e90004d5 bpf: fix spelling mistake: "funcation"-> "function"
fcffe2ed Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=131a39b0e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0cd01c9e0f5cd37a357e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lt_find include/linux/rbtree_latch.h:120  
[inline]
BUG: KASAN: use-after-free in latch_tree_find  
include/linux/rbtree_latch.h:208 [inline]
BUG: KASAN: use-after-free in bpf_prog_kallsyms_find kernel/bpf/core.c:674  
[inline]
BUG: KASAN: use-after-free in is_bpf_text_address+0x250/0x3b0  
kernel/bpf/core.c:709
Read of size 8 at addr ffff8880a366b448 by task syz-executor594/8353

CPU: 1 PID: 8353 Comm: syz-executor594 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5c0 mm/kasan/report.c:374
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:506
  kasan_report+0x26/0x50 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __lt_find include/linux/rbtree_latch.h:120 [inline]
  latch_tree_find include/linux/rbtree_latch.h:208 [inline]
  bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
  is_bpf_text_address+0x250/0x3b0 kernel/bpf/core.c:709
  kernel_text_address kernel/extable.c:147 [inline]
  __kernel_text_address+0x9a/0x110 kernel/extable.c:102
  unwind_get_return_address+0x4c/0x90 arch/x86/kernel/unwind_frame.c:19
  arch_stack_walk+0x98/0xe0 arch/x86/kernel/stacktrace.c:26
  stack_trace_save+0xb6/0x150 kernel/stacktrace.c:123
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:510
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:518
  slab_post_alloc_hook mm/slab.h:584 [inline]
  slab_alloc_node mm/slab.c:3262 [inline]
  kmem_cache_alloc_node+0x235/0x280 mm/slab.c:3574
  alloc_vmap_area+0x1eb/0x1b60 mm/vmalloc.c:1094
  __get_vm_area_node+0x199/0x320 mm/vmalloc.c:2063
  __vmalloc_node_range+0xea/0x860 mm/vmalloc.c:2491
  kasan_module_alloc+0x73/0xc0 mm/kasan/common.c:607
  module_alloc+0x9a/0xb0 arch/x86/kernel/module.c:80
  bpf_jit_alloc_exec+0x15/0x20
  bpf_jit_binary_alloc+0xa0/0x1b0 kernel/bpf/core.c:812
  bpf_int_jit_compile+0x6f5d/0x7a80 arch/x86/net/bpf_jit_comp.c:1151
  jit_subprogs kernel/bpf/verifier.c:8741 [inline]
  fixup_call_args kernel/bpf/verifier.c:8845 [inline]
  bpf_check+0xc423/0xe790 kernel/bpf/verifier.c:9349
  bpf_prog_load kernel/bpf/syscall.c:1709 [inline]
  __do_sys_bpf+0x7a4f/0xbef0 kernel/bpf/syscall.c:2866
  __se_sys_bpf kernel/bpf/syscall.c:2825 [inline]
  __x64_sys_bpf+0x7a/0x90 kernel/bpf/syscall.c:2825
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441449
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe2e84b718 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441449
RDX: 0000000000000032 RSI: 0000000020000440 RDI: 0000000000000005
RBP: 0000000000073d8f R08: 0000000000000004 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021c0
R13: 0000000000402250 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8355:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:510
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3550
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  bpf_prog_alloc_no_stats+0xdc/0x2b0 kernel/bpf/core.c:88
  jit_subprogs kernel/bpf/verifier.c:8716 [inline]
  fixup_call_args kernel/bpf/verifier.c:8845 [inline]
  bpf_check+0xbe9a/0xe790 kernel/bpf/verifier.c:9349
  bpf_prog_load kernel/bpf/syscall.c:1709 [inline]
  __do_sys_bpf+0x7a4f/0xbef0 kernel/bpf/syscall.c:2866
  __se_sys_bpf kernel/bpf/syscall.c:2825 [inline]
  __x64_sys_bpf+0x7a/0x90 kernel/bpf/syscall.c:2825
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2923:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  bpf_jit_free+0x189/0x1f0
  bpf_prog_free_deferred+0x1b9/0x380 kernel/bpf/core.c:1980
  process_one_work+0x7ef/0x10e0 kernel/workqueue.c:2269
  worker_thread+0xc01/0x1630 kernel/workqueue.c:2415
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a366b400
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 72 bytes inside of
  512-byte region [ffff8880a366b400, ffff8880a366b600)
The buggy address belongs to the page:
page:ffffea00028d9ac0 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00028b8608 ffffea000249f548 ffff8880aa400a80
raw: 0000000000000000 ffff8880a366b000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a366b300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a366b380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a366b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff8880a366b480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a366b500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
