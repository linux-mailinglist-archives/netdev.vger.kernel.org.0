Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D97DB55A1
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 20:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfIQStK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 14:49:10 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33693 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbfIQStJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 14:49:09 -0400
Received: by mail-io1-f70.google.com with SMTP id g15so7232484ioc.0
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 11:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NwVpGkNHgsmoaBSsh3mYYG8q0xqBQTXg+ZIgnqs4C80=;
        b=BVm7fo10wbdX1NxcAtOYNKHvqx1msv2Nv9ovq2iB0GsFlc9uIfN6Vzxxas6Vo0Wgug
         rkivZxxD14pSussqAU8Qj+T6kWU5SNQRxnErKeNojhbq7xGITyQpjRS4lbuxPL7J9O+d
         n+LRxSNycFMXa9gEFqvHwXMneL1+VTB+ru5pUu4ocUmwYxc5Y26R0VKtxu4l+LAmRuUP
         DehWJavtcEvLcqzw09SlRBj/AxmGZbNvD7Mt36hsynlT+faKRWBM450KSosYk7Bjr5Vu
         Nln7sEzQy9oNkEEnBUXpdHMtGuzxhMt7S6vOAu/03aIQc6/K0h0bgHe6ktip8eaNzrNk
         jUHg==
X-Gm-Message-State: APjAAAXfBTfU1voiABnUYUxJYiVBgT4UKnOAzug/F0o2e8cR5x8QPL1c
        B+CktbpDPIEkZQ5nXGUTqIIT+cQ548KTB+YPepVUONmc8QhT
X-Google-Smtp-Source: APXvYqzsAS0Pl7r7pEqtH8I83JX6lJEg1mRzZST37KlCqUop1Eo1ndA/srmM39ERBKIJibHr2ZgJi5S+Xu59xduJ6ApYCPrWNg9H
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr249979iot.144.1568746146283;
 Tue, 17 Sep 2019 11:49:06 -0700 (PDT)
Date:   Tue, 17 Sep 2019 11:49:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cacc7e0592c42ce3@google.com>
Subject: KASAN: slab-out-of-bounds Read in bpf_prog_create
From:   syzbot <syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com>
To:     arnd@arndb.de, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2015a28f Add linux-next specific files for 20190915
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11880d69600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=110691c2286b679a
dashboard link: https://syzkaller.appspot.com/bug?extid=eb853b51b10f1befa0b7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127c3481600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1150a70d600000

The bug was bisected to:

commit 2f4fa2db75e26995709043c8d3de4632ebed5c4b
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 18 03:48:01 2019 +0000

     compat_ioctl: unify copy-in of ppp filters

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=145eee1d600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=165eee1d600000
console output: https://syzkaller.appspot.com/x/log.txt?x=125eee1d600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com
Fixes: 2f4fa2db75e2 ("compat_ioctl: unify copy-in of ppp filters")

==================================================================
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:404 [inline]
BUG: KASAN: slab-out-of-bounds in bpf_prog_create+0xe9/0x250  
net/core/filter.c:1351
Read of size 32768 at addr ffff88809cf74000 by task syz-executor183/8575

CPU: 0 PID: 8575 Comm: syz-executor183 Not tainted 5.3.0-rc8-next-20190915  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  memcpy+0x24/0x50 mm/kasan/common.c:122
  memcpy include/linux/string.h:404 [inline]
  bpf_prog_create+0xe9/0x250 net/core/filter.c:1351
  get_filter.isra.0+0x108/0x1a0 drivers/net/ppp/ppp_generic.c:572
  ppp_get_filter drivers/net/ppp/ppp_generic.c:584 [inline]
  ppp_ioctl+0x129d/0x2590 drivers/net/ppp/ppp_generic.c:801
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:539 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:726
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:743
  __do_sys_ioctl fs/ioctl.c:750 [inline]
  __se_sys_ioctl fs/ioctl.c:748 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:748
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffebb37d0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401a9
RDX: 00000000200000c0 RSI: 0000000040107447 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a30
R13: 0000000000401ac0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8575:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc_track_caller+0x15f/0x760 mm/slab.c:3670
  memdup_user+0x26/0xb0 mm/util.c:172
  get_filter.isra.0+0xd7/0x1a0 drivers/net/ppp/ppp_generic.c:568
  ppp_get_filter drivers/net/ppp/ppp_generic.c:584 [inline]
  ppp_ioctl+0x129d/0x2590 drivers/net/ppp/ppp_generic.c:801
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:539 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:726
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:743
  __do_sys_ioctl fs/ioctl.c:750 [inline]
  __se_sys_ioctl fs/ioctl.c:748 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:748
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88809cf74000
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes inside of
  4096-byte region [ffff88809cf74000, ffff88809cf75000)
The buggy address belongs to the page:
page:ffffea000273dd00 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002672988 ffffea00027e7788 ffff8880aa402000
raw: 0000000000000000 ffff88809cf74000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809cf74f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88809cf74f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff88809cf75000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                    ^
  ffff88809cf75080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809cf75100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
