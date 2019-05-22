Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC21926623
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfEVOpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 10:45:07 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:59275 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbfEVOpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 10:45:07 -0400
Received: by mail-it1-f200.google.com with SMTP id l193so2219100ita.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 07:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JpaeHPVPGMAQdVWaQpSNuUwJ+u77xcvaRtejmYrPhNY=;
        b=h9rlL/zSI82S3h4zj+maCQSlYwgZikfWLOhgzrig3z8jGnrfTWR0KuQdDF4hwF8nHw
         ITG50unSmiOFkyGrUI8p8tkVj1ITb+DukEZesIy5+Dqzff0+Z8GwIkX7n5NSnYhBb1jZ
         jO7WnGCmqvcW1h4WGMBEKXeMYhU+MbFX1B87TWVqzbFnFF0aoTSs+GBXc/3xwDrPNc6j
         oTy6aaFrQ9bYJjU0hn+EfGPNUOeMIBA8nPKHC3c6uBSfVqgc4TSYIJKKKNFvMOd1uU4j
         DgVZMyEhBditQDAqfLKg/FHSjL9p7sP0+jJkay4h6l16Qni/jnwd3KiceC8R+DW6bXkL
         x+Ag==
X-Gm-Message-State: APjAAAUmFgCIeHNvxNB9MG77W9uoRWULeQV6SsYlP/w6a7u82TEMSiAk
        upCeb6T8ig0fKY5g3Jsqbrg8uQ8XKbAHCCYJSP2AxFLafSuE
X-Google-Smtp-Source: APXvYqxM11HZi/fHUjTi67KvUqTOIWL6MxhmD1qTj5D6j6pzNGHUvEe91+PXKsoqh7aXJqfVR6YDckyiGdDbvvpf8GcF9jYFOgha
MIME-Version: 1.0
X-Received: by 2002:a24:5c5:: with SMTP id 188mr8347085itl.10.1558536306060;
 Wed, 22 May 2019 07:45:06 -0700 (PDT)
Date:   Wed, 22 May 2019 07:45:06 -0700
In-Reply-To: <000000000000fd342e05791cc86f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e4731905897b02c7@google.com>
Subject: Re: KASAN: use-after-free Read in sk_psock_unlink
From:   syzbot <syzbot+3acd9f67a6a15766686e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17279a52a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=3acd9f67a6a15766686e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13adf56ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3acd9f67a6a15766686e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in sock_hash_delete_from_link  
net/core/sock_map.c:585 [inline]
BUG: KASAN: use-after-free in sk_psock_unlink+0x443/0x4b0  
net/core/sock_map.c:998
Read of size 8 at addr ffff88808b760600 by task syz-executor.5/26193

CPU: 1 PID: 26193 Comm: syz-executor.5 Not tainted 5.2.0-rc1+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  sock_hash_delete_from_link net/core/sock_map.c:585 [inline]
  sk_psock_unlink+0x443/0x4b0 net/core/sock_map.c:998
  tcp_bpf_remove+0x21/0x50 net/ipv4/tcp_bpf.c:535
  tcp_bpf_close+0x130/0x390 net/ipv4/tcp_bpf.c:575
  inet_release+0xff/0x1e0 net/ipv4/af_inet.c:432
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:474
  __sock_release+0xce/0x2a0 net/socket.c:607
  sock_close+0x1b/0x30 net/socket.c:1279
  __fput+0x2ff/0x890 fs/file_table.c:279
  ____fput+0x16/0x20 fs/file_table.c:312
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x412f61
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffdbbd18870 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000412f61
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000000 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007ffdbbd18950 R11: 0000000000000293 R12: 00000000007610a8
R13: 0000000000036769 R14: 0000000000036796 R15: 000000000075bfcc

Allocated by task 26195:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  kmem_cache_alloc_trace+0x151/0x750 mm/slab.c:3555
  kmalloc include/linux/slab.h:547 [inline]
  kzalloc include/linux/slab.h:742 [inline]
  sock_hash_alloc net/core/sock_map.c:802 [inline]
  sock_hash_alloc+0x1e3/0x5b0 net/core/sock_map.c:786
  find_and_alloc_map kernel/bpf/syscall.c:129 [inline]
  map_create kernel/bpf/syscall.c:570 [inline]
  __do_sys_bpf+0x730/0x43d0 kernel/bpf/syscall.c:2795
  __se_sys_bpf kernel/bpf/syscall.c:2772 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2772
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8823:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xcf/0x220 mm/slab.c:3755
  sock_hash_free+0x327/0x4a0 net/core/sock_map.c:865
  bpf_map_free_deferred+0xb4/0xe0 kernel/bpf/syscall.c:310
  process_one_work+0x989/0x1790 kernel/workqueue.c:2268
  worker_thread+0x98/0xe40 kernel/workqueue.c:2414
  kthread+0x354/0x420 kernel/kthread.c:254
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88808b760500
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 256 bytes inside of
  512-byte region [ffff88808b760500, ffff88808b760700)
The buggy address belongs to the page:
page:ffffea00022dd800 refcount:1 mapcount:0 mapping:ffff8880aa400940  
index:0xffff88808b760a00
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00029e2508 ffffea00023ff008 ffff8880aa400940
raw: ffff88808b760a00 ffff88808b760000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808b760500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808b760580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808b760600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff88808b760680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808b760700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

