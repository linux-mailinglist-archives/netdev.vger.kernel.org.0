Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975E4D599D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 04:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfJNCtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 22:49:11 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:47782 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729494AbfJNCtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 22:49:10 -0400
Received: by mail-io1-f69.google.com with SMTP id k14so24618019iot.14
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 19:49:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9V4klit+hozv+mbRrTrN0UpLT9Ett4RqcQ2DA9o6Nvo=;
        b=MfIFEKiD13mBOIdj2WcN5/PYy9AO2qbDUsBtBE/t3wyW12mO4r+6K4VzNuZVuHJXg3
         XS1UjQmKvDd4XGGa67zVPyTLXaPXs27ilklVwOglPR3NFC/WZdw6+Si7xbMaO/sbjws+
         EumNjy9MR2hHLmt+rDuVEV6JbHfeYRwsH4QmoQrdM2A7RMKVefnLTXLvhVhz/EMx+bWe
         bGy6XyAhYkS89PZWW8ODPI/kd1DukKOM6nlevYX/UUhTFKfzBojH/jyb7qXCLoslObJm
         /vCHYL7E8ZNKsxJ0F/DV2YDmOEZykOXDjQp7/tp+ePR/B6DRFe6c+L5EjdbU9URcKmF7
         jTWw==
X-Gm-Message-State: APjAAAXkwrRVlOVCUvONeckzAyIi7F2VPjI/KPx7IgQbT5do0aftyXdv
        UqS/wVFtEw33ADAAkQq746jzzCoWPvaWzzBO+Y/+svW44MMt
X-Google-Smtp-Source: APXvYqz5uT/zj8pn24FxdfXVgsaToFpZju09zN4x5T7bBvOevF5cYViVd4CO+zGOaNNnkRSmA46DEeA2usVGaNUrbQMHcrFcwMcf
MIME-Version: 1.0
X-Received: by 2002:a5e:d718:: with SMTP id v24mr14423069iom.24.1571021348408;
 Sun, 13 Oct 2019 19:49:08 -0700 (PDT)
Date:   Sun, 13 Oct 2019 19:49:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006819150594d5e956@google.com>
Subject: WARNING: refcount bug in sock_wfree (2)
From:   syzbot <syzbot+c0ba5b9e742f049a2edf@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, davem@davemloft.net, hare@suse.com,
        jmoyer@redhat.com, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    442630f6 Add linux-next specific files for 20191008
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=158fa6bf600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af1bfeef713eefdd
dashboard link: https://syzkaller.appspot.com/bug?extid=c0ba5b9e742f049a2edf
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a861b3600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1769f48b600000

The bug was bisected to:

commit 6c080ff07363389cb4092193eb333639f0392b8c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Oct 3 14:11:03 2019 +0000

     io_uring: allow sparse fixed file sets

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1344b993600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10c4b993600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1744b993600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c0ba5b9e742f049a2edf@syzkaller.appspotmail.com
Fixes: 6c080ff07363 ("io_uring: allow sparse fixed file sets")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 8691 at lib/refcount.c:190  
refcount_sub_and_test_checked lib/refcount.c:190 [inline]
WARNING: CPU: 0 PID: 8691 at lib/refcount.c:190  
refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8691 Comm: syz-executor322 Not tainted 5.4.0-rc2-next-20191008  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:refcount_sub_and_test_checked lib/refcount.c:190 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Code: 1d b0 f0 7f 06 31 ff 89 de e8 6c d7 30 fe 84 db 75 94 e8 23 d6 30 fe  
48 c7 c7 20 81 e6 87 c6 05 90 f0 7f 06 01 e8 e8 15 02 fe <0f> 0b e9 75 ff  
ff ff e8 04 d6 30 fe e9 6e ff ff ff 48 89 df e8 e7
RSP: 0018:ffff8880a8267a28 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815cb676 RDI: ffffed101504cf37
RBP: ffff8880a8267ac0 R08: ffff888090e363c0 R09: fffffbfff14eeb42
R10: fffffbfff14eeb41 R11: ffffffff8a775a0f R12: 00000000fffffd02
R13: 0000000000000001 R14: ffff8880a8267a98 R15: 0000000000000001
  sock_wfree+0x10c/0x190 net/core/sock.c:1958
  unix_destruct_scm+0x115/0x170 net/unix/scm.c:149
  io_destruct_skb+0x62/0x80 fs/io_uring.c:2995
  skb_release_head_state+0xeb/0x260 net/core/skbuff.c:652
  skb_release_all+0x16/0x60 net/core/skbuff.c:663
  __kfree_skb net/core/skbuff.c:679 [inline]
  kfree_skb net/core/skbuff.c:697 [inline]
  kfree_skb+0x101/0x3c0 net/core/skbuff.c:691
  __io_sqe_files_scm+0x429/0x640 fs/io_uring.c:3049
  io_sqe_files_scm fs/io_uring.c:3071 [inline]
  io_sqe_files_register fs/io_uring.c:3154 [inline]
  __io_uring_register+0x1f69/0x2d70 fs/io_uring.c:4152
  __do_sys_io_uring_register fs/io_uring.c:4204 [inline]
  __se_sys_io_uring_register fs/io_uring.c:4186 [inline]
  __x64_sys_io_uring_register+0x193/0x1f0 fs/io_uring.c:4186
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440279
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeeedc31e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440279
RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401b00
R13: 0000000000401b90 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
