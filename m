Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE41572835
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfGXG2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:28:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33385 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGXG2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:28:07 -0400
Received: by mail-io1-f72.google.com with SMTP id 132so49922570iou.0
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 23:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wNIEm2/0FtY//lVugKMU3Gz0oVJK8TH9pTfEQOANCms=;
        b=fNrtBaGZBiDpOP8OBjcnI3/0VsWbw5nz1tsqYDaoDxiEj5fi2ckSLefbjHfhxlADGd
         zJ1P7wKB6svCKxlNDguSfLthUTzAbDa2SlvlSoc+zsUQn8HVyxYDp9GzsaRvzoQqVMrY
         nSC3tbvIwUMLK3Xp8txpoBi0KVIwU5ohRKccS/t4A5G7meg+re6uwvQAM/pDpFhza4Du
         4weqPc4xvz9CQAw3hei4N++YqkZ6euHMc5ZZZL6Ltv5c3tGR1qldsrHq3oH1UInw9f1d
         W5fcT5Jsf+Gi7BkCfLYSvlM+0jCPADLxcjDFyFYWCeUgP1Lp50II5cvwbI3ibFoR0tGj
         XBYQ==
X-Gm-Message-State: APjAAAUIW4So5FdrxAc/04NaawugwMK7OYBfNumECJnxmb1jOjfj6nMA
        UgvL4HXgxAZDp53GdfweVQUwrMWqXuA9IZwg8lC6bDMYGzC5
X-Google-Smtp-Source: APXvYqxWRcLkFMkk5O1pvDw/zjc1KD918nHWAXkW5aaYib1CwF++l5hbrtGV1dES5e+pHVqPI78pdceJ5MI74r3EajbufWqnnJc9
MIME-Version: 1.0
X-Received: by 2002:a05:6638:38a:: with SMTP id y10mr85620119jap.104.1563949686426;
 Tue, 23 Jul 2019 23:28:06 -0700 (PDT)
Date:   Tue, 23 Jul 2019 23:28:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000819a8c058e6769e7@google.com>
Subject: KASAN: slab-out-of-bounds Read in bpf_int_jit_compile
From:   syzbot <syzbot+35101610ff3e83119b1b@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1760ff84600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7937b718ddac333b
dashboard link: https://syzkaller.appspot.com/bug?extid=35101610ff3e83119b1b
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c017a4600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173f8278600000

The bug was bisected to:

commit 2589726d12a1b12eaaa93c7f1ea64287e383c7a5
Author: Alexei Starovoitov <ast@kernel.org>
Date:   Sat Jun 15 19:12:20 2019 +0000

     bpf: introduce bounded loops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13df66afa00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=103f66afa00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17df66afa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+35101610ff3e83119b1b@syzkaller.appspotmail.com
Fixes: 2589726d12a1 ("bpf: introduce bounded loops")

==================================================================
BUG: KASAN: slab-out-of-bounds in do_jit /arch/x86/net/bpf_jit_comp.c:966  
[inline]
BUG: KASAN: slab-out-of-bounds in bpf_int_jit_compile+0x4d19/0x7530  
/arch/x86/net/bpf_jit_comp.c:1132
Read of size 4 at addr ffff8880960cc2bc by task syz-executor607/7822

CPU: 0 PID: 7822 Comm: syz-executor607 Not tainted 5.2.0+ #37
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack /lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 /lib/dump_stack.c:113
  print_address_description+0x75/0x5b0 /mm/kasan/report.c:351
  __kasan_report+0x14b/0x1c0 /mm/kasan/report.c:482
  kasan_report+0x26/0x50 /mm/kasan/common.c:612
  __asan_report_load4_noabort+0x14/0x20 /mm/kasan/generic_report.c:131
  do_jit /arch/x86/net/bpf_jit_comp.c:966 [inline]
  bpf_int_jit_compile+0x4d19/0x7530 /arch/x86/net/bpf_jit_comp.c:1132
  bpf_prog_select_runtime+0x756/0xa50 /kernel/bpf/core.c:1725
  bpf_prog_load /kernel/bpf/syscall.c:1702 [inline]
  __do_sys_bpf+0x7d4e/0xc0e0 /kernel/bpf/syscall.c:2849
  __se_sys_bpf /kernel/bpf/syscall.c:2808 [inline]
  __x64_sys_bpf+0x7a/0x90 /kernel/bpf/syscall.c:2808
  do_syscall_64+0xfe/0x140 /arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeb7a02c18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402c9
RDX: 0000000000000046 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401b50
R13: 0000000000401be0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7822:
  save_stack /mm/kasan/common.c:69 [inline]
  set_track /mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 /mm/kasan/common.c:487
  kasan_kmalloc+0x9/0x10 /mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x215/0x2f0 /mm/slab.c:3550
  kmalloc /./include/linux/slab.h:552 [inline]
  kzalloc /./include/linux/slab.h:748 [inline]
  bpf_int_jit_compile+0x1b2/0x7530 /arch/x86/net/bpf_jit_comp.c:1092
  bpf_prog_select_runtime+0x756/0xa50 /kernel/bpf/core.c:1725
  bpf_prog_load /kernel/bpf/syscall.c:1702 [inline]
  __do_sys_bpf+0x7d4e/0xc0e0 /kernel/bpf/syscall.c:2849
  __se_sys_bpf /kernel/bpf/syscall.c:2808 [inline]
  __x64_sys_bpf+0x7a/0x90 /kernel/bpf/syscall.c:2808
  do_syscall_64+0xfe/0x140 /arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7329:
  save_stack /mm/kasan/common.c:69 [inline]
  set_track /mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x12a/0x1e0 /mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 /mm/kasan/common.c:457
  __cache_free /mm/slab.c:3425 [inline]
  kfree+0x115/0x200 /mm/slab.c:3756
  tomoyo_path_perm+0x6cc/0x8b0 /security/tomoyo/file.c:842
  tomoyo_inode_getattr+0x1c/0x20 /security/tomoyo/tomoyo.c:129
  security_inode_getattr+0xd5/0x150 /security/security.c:1182
  vfs_getattr+0x2a/0x6d0 /fs/stat.c:115
  vfs_statx /fs/stat.c:191 [inline]
  vfs_stat /./include/linux/fs.h:3182 [inline]
  __do_sys_newstat /fs/stat.c:341 [inline]
  __se_sys_newstat+0x10c/0x210 /fs/stat.c:337
  __x64_sys_newstat+0x5b/0x70 /fs/stat.c:337
  do_syscall_64+0xfe/0x140 /arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880960cc280
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 28 bytes to the right of
  32-byte region [ffff8880960cc280, ffff8880960cc2a0)
The buggy address belongs to the page:
page:ffffea0002583300 refcount:1 mapcount:0 mapping:ffff8880aa4001c0  
index:0xffff8880960ccfc1
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00027f47c8 ffffea0002a53a48 ffff8880aa4001c0
raw: ffff8880960ccfc1 ffff8880960cc000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880960cc180: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8880960cc200: fb fb fb fb fc fc fc fc 00 00 01 fc fc fc fc fc
> ffff8880960cc280: 00 00 00 00 fc fc fc fc 00 00 fc fc fc fc fc fc
                                         ^
  ffff8880960cc300: fb fb fb fb fc fc fc fc 00 00 01 fc fc fc fc fc
  ffff8880960cc380: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
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
