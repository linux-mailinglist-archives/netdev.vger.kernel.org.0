Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868CA763F4
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 12:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfGZK7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 06:59:11 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:35234 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGZK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 06:59:07 -0400
Received: by mail-io1-f72.google.com with SMTP id w17so58342817iom.2
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 03:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WWmRsBVGmR2qQrNgLA62GMpMQKl0SNR5rBwzYzqX+MM=;
        b=M1s9TYgMkxKB4VcwCNqfhb3g3lSqyIH9WXupwHt84b4tC4gzRrexfnI4/c9qOdSlkk
         ONJyJnyMYjtJyS8rcxwI9xPYyW0ZbR1q0hofPAD0FTaenTvCyG7BLajjHkj+6pKK3y5V
         0XNchB2ACp5zauXuMexxjMIKoBB9lNlkvc672xExQPhwfmyymZT/semYEdTozXYSpBIs
         YO8eD2rWmdKagM7M65dLOoDLQX9U/pFVilAxpUFnpGvpszdJGsgtZGT9PG9QdfuXuwOQ
         qK3bm4FMTfBrSwtaa/fzWj/38XfDwwAuZI9A0tnpUO7qLBxnKdoYZcQlwaZ7GxM53rLu
         TZOA==
X-Gm-Message-State: APjAAAWyJQneNUDLd5B67LiEtM4ZsYzPSkglfQLtcbADoV8410BnsvQX
        PMN0/b/UA0cBuT0CTVMG6TCdUm+IIWJYr4ZyAXQg5/PRh9nt
X-Google-Smtp-Source: APXvYqyUVb9n5IvExk+Hf4u8c+xc2wmIDxqI5ebvGXLLMbrbGWYlLgcD7zoLSDj0MawXKzAM/zniWN5La9o4P/VZvVkwV1ViUBIg
MIME-Version: 1.0
X-Received: by 2002:a5d:8347:: with SMTP id q7mr81926091ior.277.1564138746086;
 Fri, 26 Jul 2019 03:59:06 -0700 (PDT)
Date:   Fri, 26 Jul 2019 03:59:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000570e17058e936e76@google.com>
Subject: KASAN: use-after-free Read in bpf_get_prog_name
From:   syzbot <syzbot+4d5cdc96ead2e74e7f90@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    192f0f8e Merge tag 'powerpc-5.3-1' of git://git.kernel.org..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=170afe64600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
dashboard link: https://syzkaller.appspot.com/bug?extid=4d5cdc96ead2e74e7f90
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4d5cdc96ead2e74e7f90@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in string_nocheck+0x219/0x240 lib/vsprintf.c:605
Read of size 1 at addr ffff88809fee2d70 by task syz-executor.1/30647

CPU: 1 PID: 30647 Comm: syz-executor.1 Not tainted 5.2.0+ #41
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x20 mm/kasan/common.c:612
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:129
  string_nocheck+0x219/0x240 lib/vsprintf.c:605
  string+0xed/0x100 lib/vsprintf.c:668
  vsnprintf+0x97b/0x19a0 lib/vsprintf.c:2503
  snprintf+0xbb/0xf0 lib/vsprintf.c:2636
  bpf_get_prog_name+0x159/0x360 kernel/bpf/core.c:570
  perf_event_bpf_emit_ksymbols+0x284/0x390 kernel/events/core.c:7883
  perf_event_bpf_event+0x253/0x290 kernel/events/core.c:7914
  bpf_prog_load+0x102a/0x1670 kernel/bpf/syscall.c:1723
  __do_sys_bpf+0xa46/0x42f0 kernel/bpf/syscall.c:2849
  __se_sys_bpf kernel/bpf/syscall.c:2808 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2808
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8c78cf3c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459829
RDX: 0000000000000070 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8c78cf46d4
R13: 00000000004bfc7c R14: 00000000004d16d8 R15: 00000000ffffffff

Allocated by task 30647:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  bpf_prog_alloc_no_stats+0xe6/0x2b0 kernel/bpf/core.c:88
  bpf_prog_alloc+0x31/0x230 kernel/bpf/core.c:110
  bpf_prog_load+0x400/0x1670 kernel/bpf/syscall.c:1652
  __do_sys_bpf+0xa46/0x42f0 kernel/bpf/syscall.c:2849
  __se_sys_bpf kernel/bpf/syscall.c:2808 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2808
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 12:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  __bpf_prog_free+0x87/0xc0 kernel/bpf/core.c:258
  bpf_jit_free+0x64/0x1b0
  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1982
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88809fee2cc0
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 176 bytes inside of
  512-byte region [ffff88809fee2cc0, ffff88809fee2ec0)
The buggy address belongs to the page:
page:ffffea00027fb880 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002709008 ffffea000246e348 ffff8880aa400a80
raw: 0000000000000000 ffff88809fee2040 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809fee2c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809fee2c80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff88809fee2d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                              ^
  ffff88809fee2d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809fee2e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
