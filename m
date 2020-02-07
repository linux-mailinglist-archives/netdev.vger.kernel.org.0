Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4F155CB6
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgBGRSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:18:13 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:43728 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgBGRSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:18:12 -0500
Received: by mail-io1-f72.google.com with SMTP id v15so91306iol.10
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 09:18:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0HvboEURlu0M37qfrJEmJ30jzxW8E9Pwkrbv32SONt4=;
        b=kij0V6tCp3LpbaEKESxNj2r6I4z8yurWYy9gziMokcd5iPgihu4FFD5vIwR6V3RP83
         cNOUtvOvd1UWTCh3rnANzZ1bsSyi8/wn8L8MhT4bguZoh+EVbHnjCymd9XeD2f5LY7Di
         bOA9nZR24K/uqV68DEWNGMIsUlgfaAY3ghbGi0y5RgeMJjtdTMtQvHC2siZ8O4N6hXRu
         7QEKc58dXcmkNo5c0Y9hG9LJXcHm0Bv1n1l6IubHtGu+7sLUVERgmtLRQnePvY0B0+ds
         G5FyS17Zl/h/0uUEjND8icDqWLDn5HMLVr1fEdsa5eRvwjzYRrfcGAOl85/UBpNxvwfH
         fmkw==
X-Gm-Message-State: APjAAAV2nD3yuZ8RLlZByJnEpC9Y6fT/wQ8JXPA68CHFjmlOomAf9v+f
        AKT88KiksW45oMVmMu4a2KzJuqSjTB7JF8nzeAvs0nXCkwc/
X-Google-Smtp-Source: APXvYqwlwmy9FHs5m2Vrv7W1//evSzREdQFs/qWmaq9C71//QUywVp91jetsL4eREcwQE2RfU0SS8eStQcYstC0R83QbbnVUKkGl
MIME-Version: 1.0
X-Received: by 2002:a02:5489:: with SMTP id t131mr91096jaa.40.1581095892155;
 Fri, 07 Feb 2020 09:18:12 -0800 (PST)
Date:   Fri, 07 Feb 2020 09:18:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000202d1059dff9341@google.com>
Subject: KASAN: use-after-free Read in l2cap_chan_close
From:   syzbot <syzbot+96414aa0033c363d8458@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    90568ecf Merge tag 'kvm-5.6-2' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16fe894ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=69fa012479f9a62
dashboard link: https://syzkaller.appspot.com/bug?extid=96414aa0033c363d8458
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142dd4e9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102c37f1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+96414aa0033c363d8458@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in l2cap_chan_close+0x48/0x990 net/bluetooth/l2cap_core.c:730
Read of size 8 at addr ffff888096950000 by task kworker/1:102/2868

CPU: 1 PID: 2868 Comm: kworker/1:102 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events do_enable_set
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
 kasan_report+0x26/0x50 mm/kasan/common.c:641
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 l2cap_chan_close+0x48/0x990 net/bluetooth/l2cap_core.c:730
 do_enable_set+0x660/0x900 net/bluetooth/6lowpan.c:1074
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 2870:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:515
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 l2cap_chan_create+0x50/0x320 net/bluetooth/l2cap_core.c:446
 chan_create net/bluetooth/6lowpan.c:640 [inline]
 bt_6lowpan_listen net/bluetooth/6lowpan.c:959 [inline]
 do_enable_set+0x6a4/0x900 net/bluetooth/6lowpan.c:1078
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 2870:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:484 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x170/0x190 net/bluetooth/l2cap_core.c:498
 do_enable_set+0x66c/0x900 net/bluetooth/6lowpan.c:1075
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888096950000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 0 bytes inside of
 2048-byte region [ffff888096950000, ffff888096950800)
The buggy address belongs to the page:
page:ffffea00025a5400 refcount:1 mapcount:0 mapping:ffff8880aa400e00 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027d1548 ffffea0002397808 ffff8880aa400e00
raw: 0000000000000000 ffff888096950000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809694ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809694ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888096950000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888096950080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888096950100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
