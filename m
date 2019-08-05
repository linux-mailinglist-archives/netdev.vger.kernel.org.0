Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC80881974
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 14:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfHEMiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 08:38:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:37455 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfHEMiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 08:38:07 -0400
Received: by mail-io1-f70.google.com with SMTP id v3so92084520ios.4
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 05:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dUuEaFIw9PZdhN+hW3qdZNrRrDs2tAvqtjUNe0Ih1k0=;
        b=nebvjPIJkyMjykyT45Yqt+kTxuWV4zgnrWmb7JKQvwSiLa15pPJHP9mqA8lPL33VC6
         xR/lbXOxF4reCp52AEERXpXU4IV5Ua/B9mlO9XZRyg1AcX6eDO6oFO9z2en407tvUwbl
         m9sFPBwI5hLtdiTC22y/XpTa+/Ppr58bWYLd2owgNch6lVQvOi2aTyXUUDu7MIxGhWbH
         6iPWdd2nDmCZdkxz3heEU935LFVr/kmg+QP0XDtGn0qAslnuk7g4i5COjvNwvmPkZ/Cv
         YfjlEv+bVGWuWplfYcZqVoC+wtazwNLOeLg5V/+TWbM6DS/L1PcIzzz1hDGauoWBZX6o
         3JmA==
X-Gm-Message-State: APjAAAV4uey620IlSdkNxjn+1yuxYXuzJWwGi8Fhe2J56g7LZTiEBC5S
        o6JSDICyWMyEuCGIxhxOYl12Tm+aLg29EhQZdQz1jenZD1Mt
X-Google-Smtp-Source: APXvYqxgodgAYHl06isVTdmknHtDUu76Z1mMzECgwIayJT/sE+AVm55fjpPPooCBBYyUvps1D6mAr1TwJjujKavtmAWX2uuooqYu
MIME-Version: 1.0
X-Received: by 2002:a6b:fb0f:: with SMTP id h15mr35402072iog.266.1565008686959;
 Mon, 05 Aug 2019 05:38:06 -0700 (PDT)
Date:   Mon, 05 Aug 2019 05:38:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db544f058f5dfa6d@google.com>
Subject: KASAN: use-after-free Read in blkdev_bio_end_io
From:   syzbot <syzbot+2a99a1bb75e9116ec20c@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1e78030e Merge tag 'mmc-v5.3-rc1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15286cdc600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e397351d2615e10
dashboard link: https://syzkaller.appspot.com/bug?extid=2a99a1bb75e9116ec20c
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150799e8600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16aaa8c4600000

The bug was bisected to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

     hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15efbeec600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17efbeec600000
console output: https://syzkaller.appspot.com/x/log.txt?x=13efbeec600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2a99a1bb75e9116ec20c@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

==================================================================
BUG: KASAN: use-after-free in blkdev_bio_end_io+0x37e/0x430  
fs/block_dev.c:301
Read of size 1 at addr ffff8880a40928d4 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.3.0-rc2+ #59
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5b0 mm/kasan/report.c:351
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:482
  kasan_report+0x26/0x50 mm/kasan/common.c:612
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:129
  blkdev_bio_end_io+0x37e/0x430 fs/block_dev.c:301
  bio_endio+0x4ff/0x570 block/bio.c:1830
  req_bio_endio block/blk-core.c:239 [inline]
  blk_update_request+0x385/0xf80 block/blk-core.c:1424
  blk_mq_end_request+0x42/0x80 block/blk-mq.c:557
  end_cmd+0xeb/0x2d0 drivers/block/null_blk_main.c:622
  null_complete_rq+0x1c/0x20 drivers/block/null_blk_main.c:649
  blk_done_softirq+0x362/0x3e0 block/blk-softirq.c:37
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778
  run_ksoftirqd+0x64/0xf0 kernel/softirq.c:603
  smpboot_thread_fn+0x62c/0xa70 kernel/smpboot.c:165
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9743:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:487
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:495
  slab_post_alloc_hook mm/slab.h:520 [inline]
  slab_alloc mm/slab.c:3319 [inline]
  kmem_cache_alloc+0x1f5/0x2e0 mm/slab.c:3483
  mempool_alloc_slab+0x4d/0x70 mm/mempool.c:513
  mempool_alloc+0x15f/0x6c0 mm/mempool.c:393
  bio_alloc_bioset+0x210/0x670 block/bio.c:477
  __blkdev_direct_IO+0x29c/0x1310 fs/block_dev.c:363
  blkdev_direct_IO+0xbe/0xd0 fs/block_dev.c:518
  generic_file_read_iter+0x1ad3/0x21b0 mm/filemap.c:2323
  blkdev_read_iter+0x12e/0x140 fs/block_dev.c:2013
  call_read_iter include/linux/fs.h:1864 [inline]
  aio_read+0x362/0x4a0 fs/aio.c:1543
  __io_submit_one fs/aio.c:1817 [inline]
  io_submit_one+0x742/0x1ac0 fs/aio.c:1862
  __do_sys_io_submit fs/aio.c:1921 [inline]
  __se_sys_io_submit+0x18f/0x2d0 fs/aio.c:1891
  __x64_sys_io_submit+0x7b/0x90 fs/aio.c:1891
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kmem_cache_free+0x81/0xf0 mm/slab.c:3693
  mempool_free_slab+0x1d/0x30 mm/mempool.c:520
  mempool_free+0xd5/0x350 mm/mempool.c:502
  bio_put+0x35a/0x420 block/bio.c:253
  bio_check_pages_dirty+0x404/0x4e0 block/bio.c:1703
  blkdev_bio_end_io+0x345/0x430 fs/block_dev.c:330
  bio_endio+0x4ff/0x570 block/bio.c:1830
  req_bio_endio block/blk-core.c:239 [inline]
  blk_update_request+0x385/0xf80 block/blk-core.c:1424
  blk_mq_end_request+0x42/0x80 block/blk-mq.c:557
  end_cmd+0xeb/0x2d0 drivers/block/null_blk_main.c:622
  null_complete_rq+0x1c/0x20 drivers/block/null_blk_main.c:649
  blk_done_softirq+0x362/0x3e0 block/blk-softirq.c:37
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778

The buggy address belongs to the object at ffff8880a40928c0
  which belongs to the cache bio-1 of size 216
The buggy address is located 20 bytes inside of
  216-byte region [ffff8880a40928c0, ffff8880a4092998)
The buggy address belongs to the page:
page:ffffea0002902480 refcount:1 mapcount:0 mapping:ffff8880a5ad0c40  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002862888 ffffea000264a1c8 ffff8880a5ad0c40
raw: 0000000000000000 ffff8880a4092000 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a4092780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880a4092800: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
> ffff8880a4092880: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                  ^
  ffff8880a4092900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a4092980: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
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
