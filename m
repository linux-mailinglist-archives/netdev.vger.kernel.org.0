Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559DAA3E5C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfH3T2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:28:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:51056 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfH3T2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:28:10 -0400
Received: by mail-io1-f69.google.com with SMTP id 15so9674408ioo.17
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 12:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WuWiZb77BzJY+J1MNhFVvKgsGXna89Mt8XyNjZyvad8=;
        b=Qkm6aad/QC+AS28jjhija49jVQsRguGMYxlhs3MU2hNqZLS4IDqreFgKQz5wvznzeL
         W4vvNYFUb7Gq2YdGyI26LBk8CK94ixwIzrd4GnOkh2331AJWGK19HDUxi2/4FGnXzwL4
         04IoKFDh0pie5DKm5ZgLTuIIWbhF4uJMyiFvDDMDbTw9G4MLdjzICPKrgzByq+oZX77i
         ubAY9a25HIWviZZkqvf30YF1D//AmxIT6lbId5CoOJ4xWqVcDiffp3cWb3G7pD2/E+CD
         MSXzrCFuQTwXDBCApmL3Oc/VzS2A2xHL0K04lyDTh6va7eAj8G+wWX1lYRj6NGm5TjM6
         qFbA==
X-Gm-Message-State: APjAAAXvG4r8cFB+HZDAGWza323ubPLirkjNnAR+LXmd52bxH/0W1HGH
        KGbQKwTT6aA/XlS6+3qtlxCz7G6KnbtY34AGTaD5MrgICPnj
X-Google-Smtp-Source: APXvYqziyMc7Qv/sf941HnJFhTpfPdQBt8JTF/X8VpcabVdQqFN0rG+p/2LEls5l385vlNZfFEt/WJoxnYN1vvkifTfa/61+jl/G
MIME-Version: 1.0
X-Received: by 2002:a5d:9696:: with SMTP id m22mr1153125ion.14.1567193288485;
 Fri, 30 Aug 2019 12:28:08 -0700 (PDT)
Date:   Fri, 30 Aug 2019 12:28:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004132be05915a9f7c@google.com>
Subject: memory leak in hci_inquiry_cache_update
From:   syzbot <syzbot+82e5dfb66f1a36c0ffbb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6525771f Merge tag 'arc-5.3-rc7' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ce405c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e6131eafb9408877
dashboard link: https://syzkaller.appspot.com/bug?extid=82e5dfb66f1a36c0ffbb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ef5ade600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+82e5dfb66f1a36c0ffbb@syzkaller.appspotmail.com

2019/08/30 10:10:13 executed programs: 1
2019/08/30 10:10:24 executed programs: 2
2019/08/30 10:10:39 executed programs: 3
2019/08/30 10:10:49 executed programs: 4
BUG: memory leak
unreferenced object 0xffff8881227b8ac0 (size 64):
   comm "kworker/u5:0", pid 1543, jiffies 4294990660 (age 28.050s)
   hex dump (first 32 bytes):
     70 2a b0 2a 81 88 ff ff c0 7e c6 1a 81 88 ff ff  p*.*.....~......
     80 2a b0 2a 81 88 ff ff d0 7e c6 1a 81 88 ff ff  .*.*.....~......
   backtrace:
     [<0000000003c40121>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000003c40121>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000003c40121>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000003c40121>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000bdd76485>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000bdd76485>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000bdd76485>] hci_inquiry_cache_update+0x138/0x2b0  
net/bluetooth/hci_core.c:1183
     [<000000000fa97823>] hci_inquiry_result_with_rssi_evt  
net/bluetooth/hci_event.c:4079 [inline]
     [<000000000fa97823>] hci_event_packet+0x1224/0x3453  
net/bluetooth/hci_event.c:5952
     [<0000000021923028>] hci_rx_work+0x1b6/0x2f0  
net/bluetooth/hci_core.c:4462
     [<00000000eb63bebf>] process_one_work+0x210/0x490  
kernel/workqueue.c:2269
     [<00000000873e1703>] worker_thread+0x56/0x4c0 kernel/workqueue.c:2415
     [<00000000a3c26b57>] kthread+0x13e/0x160 kernel/kthread.c:255
     [<00000000c66acc55>] ret_from_fork+0x1f/0x30  
arch/x86/entry/entry_64.S:352

BUG: memory leak
unreferenced object 0xffff88811ac67ec0 (size 64):
   comm "kworker/u5:0", pid 1543, jiffies 4294990660 (age 28.050s)
   hex dump (first 32 bytes):
     c0 8a 7b 22 81 88 ff ff 80 7e c6 1a 81 88 ff ff  ..{".....~......
     d0 8a 7b 22 81 88 ff ff 90 7e c6 1a 81 88 ff ff  ..{".....~......
   backtrace:
     [<0000000003c40121>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000003c40121>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000003c40121>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000003c40121>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000bdd76485>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000bdd76485>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000bdd76485>] hci_inquiry_cache_update+0x138/0x2b0  
net/bluetooth/hci_core.c:1183
     [<000000000fa97823>] hci_inquiry_result_with_rssi_evt  
net/bluetooth/hci_event.c:4079 [inline]
     [<000000000fa97823>] hci_event_packet+0x1224/0x3453  
net/bluetooth/hci_event.c:5952
     [<0000000021923028>] hci_rx_work+0x1b6/0x2f0  
net/bluetooth/hci_core.c:4462
     [<00000000eb63bebf>] process_one_work+0x210/0x490  
kernel/workqueue.c:2269
     [<00000000873e1703>] worker_thread+0x56/0x4c0 kernel/workqueue.c:2415
     [<00000000a3c26b57>] kthread+0x13e/0x160 kernel/kthread.c:255
     [<00000000c66acc55>] ret_from_fork+0x1f/0x30  
arch/x86/entry/entry_64.S:352

BUG: memory leak
unreferenced object 0xffff88811ac67e80 (size 64):
   comm "kworker/u5:0", pid 1543, jiffies 4294990660 (age 28.050s)
   hex dump (first 32 bytes):
     c0 7e c6 1a 81 88 ff ff 40 7e c6 1a 81 88 ff ff  .~......@~......
     d0 7e c6 1a 81 88 ff ff 50 7e c6 1a 81 88 ff ff  .~......P~......
   backtrace:
     [<0000000003c40121>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000003c40121>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000003c40121>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000003c40121>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000bdd76485>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000bdd76485>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000bdd76485>] hci_inquiry_cache_update+0x138/0x2b0  
net/bluetooth/hci_core.c:1183
     [<000000000fa97823>] hci_inquiry_result_with_rssi_evt  
net/bluetooth/hci_event.c:4079 [inline]
     [<000000000fa97823>] hci_event_packet+0x1224/0x3453  
net/bluetooth/hci_event.c:5952
     [<0000000021923028>] hci_rx_work+0x1b6/0x2f0  
net/bluetooth/hci_core.c:4462
     [<00000000eb63bebf>] process_one_work+0x210/0x490  
kernel/workqueue.c:2269
     [<00000000873e1703>] worker_thread+0x56/0x4c0 kernel/workqueue.c:2415
     [<00000000a3c26b57>] kthread+0x13e/0x160 kernel/kthread.c:255
     [<00000000c66acc55>] ret_from_fork+0x1f/0x30  
arch/x86/entry/entry_64.S:352

BUG: memory leak
unreferenced object 0xffff88811ac67e40 (size 64):
   comm "kworker/u5:0", pid 1543, jiffies 4294990660 (age 28.050s)
   hex dump (first 32 bytes):
     80 7e c6 1a 81 88 ff ff 00 7e c6 1a 81 88 ff ff  .~.......~......
     90 7e c6 1a 81 88 ff ff 10 7e c6 1a 81 88 ff ff  .~.......~......
   backtrace:
     [<0000000003c40121>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000003c40121>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000003c40121>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000003c40121>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000bdd76485>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000bdd76485>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000bdd76485>] hci_inquiry_cache_update+0x138/0x2b0  
net/bluetooth/hci_core.c:1183
     [<000000000fa97823>] hci_inquiry_result_with_rssi_evt  
net/bluetooth/hci_event.c:4079 [inline]
     [<000000000fa97823>] hci_event_packet+0x1224/0x3453  
net/bluetooth/hci_event.c:5952
     [<0000000021923028>] hci_rx_work+0x1b6/0x2f0  
net/bluetooth/hci_core.c:4462
     [<00000000eb63bebf>] process_one_work+0x210/0x490  
kernel/workqueue.c:2269
     [<00000000873e1703>] worker_thread+0x56/0x4c0 kernel/workqueue.c:2415
     [<00000000a3c26b57>] kthread+0x13e/0x160 kernel/kthread.c:255
     [<00000000c66acc55>] ret_from_fork+0x1f/0x30  
arch/x86/entry/entry_64.S:352

BUG: memory leak
unreferenced object 0xffff88811ac67e00 (size 64):
   comm "kworker/u5:0", pid 1543, jiffies 4294990660 (age 28.050s)
   hex dump (first 32 bytes):
     40 7e c6 1a 81 88 ff ff c0 7d c6 1a 81 88 ff ff  @~.......}......
     50 7e c6 1a 81 88 ff ff d0 7d c6 1a 81 88 ff ff  P~.......}......
   backtrace:
     [<0000000003c40121>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000003c40121>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000003c40121>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000003c40121>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000bdd76485>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000bdd76485>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000bdd76485>] hci_inquiry_cache_update+0x138/0x2b0  
net/bluetooth/hci_core.c:1183
     [<000000000fa97823>] hci_inquiry_result_with_rssi_evt  
net/bluetooth/hci_event.c:4079 [inline]
     [<000000000fa97823>] hci_event_packet+0x1224/0x3453  
net/bluetooth/hci_event.c:5952
     [<0000000021923028>] hci_rx_work+0x1b6/0x2f0  
net/bluetooth/hci_core.c:4462
     [<00000000eb63bebf>] process_one_work+0x210/0x490  
kernel/workqueue.c:2269
     [<00000000873e1703>] worker_thread+0x56/0x4c0 kernel/workqueue.c:2415
     [<00000000a3c26b57>] kthread+0x13e/0x160 kernel/kthread.c:255
     [<00000000c66acc55>] ret_from_fork+0x1f/0x30  
arch/x86/entry/entry_64.S:352



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
