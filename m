Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610AB1FCD64
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 14:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgFQM2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 08:28:18 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33417 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgFQM2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 08:28:15 -0400
Received: by mail-il1-f197.google.com with SMTP id c11so1390190ilq.0
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 05:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=l9ONcrp7TNCnAeANXnm3Ty7lzQdXyhO/aQEZn+eKUjg=;
        b=Ftoyn3R7g8TS1r927ZEsqo807PztB7LebMQC/nIAaHtpm3UUOIuup5Eo4RDUdVp3bT
         QrbFSaPfFy0XdgFyTWaS3wXIQX0zvlIIHHf7T4dKwq9GWOLRlmjymbfQAvi0SlqH1hhY
         3zo2YWwT8Zal9jy+hXfsTu4brEY/yUyWi1X5MentuoqdUQh68CCzxZFoHuNCJ8zMzeK6
         nn2SRCuEoMSr1/rUmNl5dpyGTpxAK29MW5Erb9lx35nrC/CAnLhwTLQGM4rLMT/MLRVp
         1d/9fCzFmP6JDc3p2yB24Lyu+uuhTG9x39spXwPwh4xZVj9K7qzVR8HsCFZTEZdRMhO2
         CaCw==
X-Gm-Message-State: AOAM531/SIGMuLvSVsb1U7iW03GRovjKA4pidWkxLe7320FNIGOhmLXc
        hqR2dRxZaWp8zwb6lMmOoey3gqnk46/2oZAOQLzAR3xd4XbE
X-Google-Smtp-Source: ABdhPJwBqT6pnNHdsuMCdPCGIMaphgIb/CvR5XB68aSX6e47Ub2iegiLwnyyjGreg7uZTkA3KErjiD9FS+wfK3Wj00Il5kJ3qqpX
MIME-Version: 1.0
X-Received: by 2002:a5e:8703:: with SMTP id y3mr7926754ioj.61.1592396894147;
 Wed, 17 Jun 2020 05:28:14 -0700 (PDT)
Date:   Wed, 17 Jun 2020 05:28:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000379b5005a846cb31@google.com>
Subject: KASAN: use-after-free Read in cgroup_path_ns_locked
From:   syzbot <syzbot+3b66039191adbe4be590@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, hannes@cmpxchg.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12ad963e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=3b66039191adbe4be590
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3b66039191adbe4be590@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cgroup_path_ns_locked+0xd0/0x110 kernel/cgroup/cgroup.c:2227
Read of size 8 at addr ffff888093fc42b8 by task syz-executor.5/12988

CPU: 0 PID: 12988 Comm: syz-executor.5 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 cgroup_path_ns_locked+0xd0/0x110 kernel/cgroup/cgroup.c:2227
 cgroup_path_ns+0x43/0x70 kernel/cgroup/cgroup.c:2240
 proc_cpuset_show+0x2ad/0xad0 kernel/cgroup/cpuset.c:3599
 proc_single_show+0x116/0x1e0 fs/proc/base.c:766
 seq_read+0x432/0xfd0 fs/seq_file.c:208
 do_loop_readv_writev fs/read_write.c:715 [inline]
 do_loop_readv_writev fs/read_write.c:702 [inline]
 do_iter_read+0x483/0x650 fs/read_write.c:936
 vfs_readv+0xf0/0x160 fs/read_write.c:1054
 do_preadv+0x1bc/0x270 fs/read_write.c:1146
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca69
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f11f653cc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000004fb040 RCX: 000000000045ca69
RDX: 000000000000011c RSI: 00000000200017c0 RDI: 0000000000000004
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000879 R14: 00000000004cb670 R15: 00007f11f653d6d4

Allocated by task 1:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 cgroup1_root_to_use kernel/cgroup/cgroup-v1.c:1183 [inline]
 cgroup1_get_tree+0xcfd/0x13b6 kernel/cgroup/cgroup-v1.c:1207
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2874 [inline]
 do_mount+0x1306/0x1b40 fs/namespace.c:3199
 __do_sys_mount fs/namespace.c:3409 [inline]
 __se_sys_mount fs/namespace.c:3386 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3386
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 22806:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 cgroup_free_root kernel/cgroup/cgroup.c:1311 [inline]
 cgroup_destroy_root kernel/cgroup/cgroup.c:1353 [inline]
 css_free_rwork_fn+0x8e6/0xce0 kernel/cgroup/cgroup.c:4980
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

The buggy address belongs to the object at ffff888093fc4000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 696 bytes inside of
 8192-byte region [ffff888093fc4000, ffff888093fc6000)
The buggy address belongs to the page:
page:ffffea00024ff100 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00024ff100 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00024fe408 ffffea00024ffb08 ffff8880aa0021c0
raw: 0000000000000000 ffff888093fc4000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888093fc4180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888093fc4200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888093fc4280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888093fc4300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888093fc4380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
