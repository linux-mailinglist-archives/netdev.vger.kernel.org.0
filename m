Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35B5034B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfFXH1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:27:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54700 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfFXH1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 03:27:09 -0400
Received: by mail-io1-f69.google.com with SMTP id n8so20879982ioo.21
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 00:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q+jSIt1RbaUKJIAwoqkZbIlk6NUJrHcjgQhUeOx3Q34=;
        b=mEkKpS7KUAmk40ZXfAEnFGbQAqPas4xIvNQuMJtf87kBrJkjH9zTwJbxAoLMQ2ElZz
         WRleIgD2TTjR8u2/1M8GvW+43mil7bxYUCMAdqzyK2l7ZW5ch82ZpK1UosTIlbph0yeu
         bRWnrZX5U1lmcpK+8eDluGm1hjYQ3PBt6ecUTINEJCseibVAvXC8DScppyDkXVn49olu
         SKEfRi90CWeuumBPziZI7n2r29i5kR1/lwiijPkJEwFJO1hDC6eDemq6R8DnN4XKfs5u
         e+LAN4I28uosJOgEtoJLzJ2llAimJ0UQk+0kny8+0IAonpeKVtClogkMbuEeVXFBFQhl
         +FLA==
X-Gm-Message-State: APjAAAW5BIXxlerJjDyeFW1k5m2WRx89Q6VMT1u4N1y/kA/orIYvi6V7
        VCXNeCCDF6vWNe84HkbewvKgYwSbL0vlOtahZbl+KO02UrGh
X-Google-Smtp-Source: APXvYqy/O0/vqy+34ZnqXymFhrK27i4TCuMIDpV9S7wFv/rDi3jRPMJdVVlIpNnM5iGIXFOdrtxkM8xTE8ILETQuWcr5InsS6kHw
MIME-Version: 1.0
X-Received: by 2002:a02:1948:: with SMTP id b69mr23721911jab.55.1561361228126;
 Mon, 24 Jun 2019 00:27:08 -0700 (PDT)
Date:   Mon, 24 Jun 2019 00:27:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e6124058c0cbdbe@google.com>
Subject: memory leak in fdb_create
From:   syzbot <syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12970eb2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
dashboard link: https://syzkaller.appspot.com/bug?extid=88533dc8b582309bf3ee
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16de5c06a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10546026a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com

ffffffffda RBX: 0000000000000000 RCX: 0000000000441519
BUG: memory leak
unreferenced object 0xffff888123886800 (size 128):
   comm "softirq", pid 0, jiffies 4294945699 (age 13.160s)
   hex dump (first 32 bytes):
     81 89 f8 20 81 88 ff ff 00 00 00 00 00 00 00 00  ... ............
     32 f9 fc b7 11 e2 01 00 00 00 00 00 00 00 00 00  2...............
   backtrace:
     [<00000000ca2421fa>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000ca2421fa>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000ca2421fa>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000ca2421fa>] kmem_cache_alloc+0x134/0x270 mm/slab.c:3488
     [<000000007faade68>] fdb_create+0x49/0x5a0 net/bridge/br_fdb.c:492
     [<00000000772dfc36>] fdb_insert+0xb7/0x100 net/bridge/br_fdb.c:536
     [<00000000ded35dd0>] br_fdb_insert+0x3b/0x60 net/bridge/br_fdb.c:552
     [<00000000758ae277>] __vlan_add+0x617/0xdf0 net/bridge/br_vlan.c:284
     [<0000000054c3b165>] br_vlan_add+0x26f/0x480 net/bridge/br_vlan.c:678
     [<00000000ed895462>] br_vlan_init+0xe9/0x130 net/bridge/br_vlan.c:1061
     [<00000000f916c753>] br_dev_init+0xa6/0x170 net/bridge/br_device.c:137
     [<00000000a4e1a1ea>] register_netdevice+0xbf/0x600 net/core/dev.c:8663
     [<00000000bdcf4ebd>] register_netdev+0x24/0x40 net/core/dev.c:8851
     [<0000000042e6c0c4>] br_add_bridge+0x5e/0xa0 net/bridge/br_if.c:456
     [<0000000036402409>] br_ioctl_deviceless_stub+0x30c/0x350  
net/bridge/br_ioctl.c:374
     [<00000000e57c9a76>] sock_ioctl+0x287/0x480 net/socket.c:1141
     [<00000000109b8329>] vfs_ioctl fs/ioctl.c:46 [inline]
     [<00000000109b8329>] file_ioctl fs/ioctl.c:509 [inline]
     [<00000000109b8329>] do_vfs_ioctl+0x62a/0x810 fs/ioctl.c:696
     [<00000000d8eb5a5e>] ksys_ioctl+0x86/0xb0 fs/ioctl.c:713
     [<00000000cd162915>] __do_sys_ioctl fs/ioctl.c:720 [inline]
     [<00000000cd162915>] __se_sys_ioctl fs/ioctl.c:718 [inline]
     [<00000000cd162915>] __x64_sys_ioctl+0x1e/0x30 fs/ioctl.c:718

BUG: memory leak
unreferenced object 0xffff88811ced2de0 (size 32):
   comm "syz-executor140", pid 6998, jiffies 4294945699 (age 13.160s)
   hex dump (first 32 bytes):
     d3 d2 f1 a7 6c 83 5b 30 30 15 a1 6f 77 3f 00 00  ....l.[00..ow?..
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000d53fdc1e>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000d53fdc1e>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000d53fdc1e>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000d53fdc1e>] __do_kmalloc mm/slab.c:3658 [inline]
     [<00000000d53fdc1e>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c:3675
     [<00000000c742d29c>] kstrdup+0x3a/0x70 mm/util.c:52
     [<00000000d3df5d2b>] kstrdup_const+0x48/0x60 mm/util.c:74
     [<00000000d75a8fa8>] kvasprintf_const+0x7e/0xe0 lib/kasprintf.c:48
     [<00000000ebee37a0>] kobject_set_name_vargs+0x40/0xe0 lib/kobject.c:289
     [<00000000c23c056a>] dev_set_name+0x63/0x90 drivers/base/core.c:1915
     [<000000004c47b6d3>] netdev_register_kobject+0x5a/0x1b0  
net/core/net-sysfs.c:1727
     [<000000005fb074af>] register_netdevice+0x397/0x600 net/core/dev.c:8733
     [<00000000bdcf4ebd>] register_netdev+0x24/0x40 net/core/dev.c:8851
     [<0000000042e6c0c4>] br_add_bridge+0x5e/0xa0 net/bridge/br_if.c:456
     [<0000000036402409>] br_ioctl_deviceless_stub+0x30c/0x350  
net/bridge/br_ioctl.c:374
     [<00000000e57c9a76>] sock_ioctl+0x287/0x480 net/socket.c:1141
     [<00000000109b8329>] vfs_ioctl fs/ioctl.c:46 [inline]
     [<00000000109b8329>] file_ioctl fs/ioctl.c:509 [inline]
     [<00000000109b8329>] do_vfs_ioctl+0x62a/0x810 fs/ioctl.c:696
     [<00000000d8eb5a5e>] ksys_ioctl+0x86/0xb0 fs/ioctl.c:713
     [<00000000cd162915>] __do_sys_ioctl fs/ioctl.c:720 [inline]
     [<00000000cd162915>] __se_sys_ioctl fs/ioctl.c:718 [inline]
     [<00000000cd162915>] __x64_sys_ioctl+0x1e/0x30 fs/ioctl.c:718
     [<0000000069b4ac36>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
