Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4978098774
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbfHUWiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:38:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:47568 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731104AbfHUWiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:38:09 -0400
Received: by mail-io1-f69.google.com with SMTP id b22so4192320iod.14
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 15:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OvcLDGlyZApcuXSWwLIJL3Pm5pdGHjKfI+ox2HXsl2s=;
        b=RPDedXtrSInmQjH83hkhgIFb+GPt+2ypkadMdFlIRlQNP6/TpugdwYHfu2HiNKr+nk
         dNv5fRTqKsd+j1u2qxI2DEolUQaD3+2lu9g+AlOTqZbDPqZ381kmYkZc8rnRiGLIxKfV
         9a/K8xdmicX+nnjs7AaPUq6XTtFmZywcYSs2oZ0e3AULAqS7jt6AC5dGhIC5PffDCFQf
         +HBcbanfips+jNwu0VlO2nW/vyIAp2/on5XKlRTtgbC5sGEryamPY+5HafefpiNrqiqo
         a7ADvW+kD0D1YMRY/YmseLsAGdaW9BB4k0bOxe6/fUJXaK2xsSDwQFDC4Tu1ByNKxC6j
         8xVQ==
X-Gm-Message-State: APjAAAXg5bElXxUQxIqLKjSZhOMIuAGlY1eFpoWbOS/O2PhxgWx615AY
        jzxxheCKgz0sBrbit59ZLQq6ofOTlmUS5sa2AB9WXjHjGAm+
X-Google-Smtp-Source: APXvYqzF6S4ovYIYizRMwKjYTxeAyYAFuZ3RLPgkDuWmKuaomtU0MLwdY0zj/iSpH2Nmhra60tQ1pRLr2dt1szURo0+kIj/j+tKV
MIME-Version: 1.0
X-Received: by 2002:a5e:a90f:: with SMTP id c15mr1900814iod.41.1566427088386;
 Wed, 21 Aug 2019 15:38:08 -0700 (PDT)
Date:   Wed, 21 Aug 2019 15:38:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b81b70590a83ad7@google.com>
Subject: KASAN: null-ptr-deref Write in queue_work_on
From:   syzbot <syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        wg@grandegger.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6e625a1a Merge tag 'xtensa-20190816' of git://github.com/j..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=174e04ac600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3ff364e429585cf2
dashboard link: https://syzkaller.appspot.com/bug?extid=017e491ae13c0068598a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1327d9e2600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c4fc4c600000

Bisection is inconclusive: the first bad commit could be any of:

569dbb88 Linux 4.13
  that is not the commit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17520702600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in test_and_set_bit  
include/asm-generic/bitops-instrumented.h:143 [inline]
BUG: KASAN: null-ptr-deref in queue_work_on+0xa6/0x210  
kernel/workqueue.c:1517
Write of size 8 at addr 0000000000000050 by task syz-executor935/9691

CPU: 0 PID: 9691 Comm: syz-executor935 Not tainted 5.3.0-rc4+ #113
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  __kasan_report.cold+0x5/0x36 mm/kasan/report.c:486
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:98
  test_and_set_bit include/asm-generic/bitops-instrumented.h:143 [inline]
  queue_work_on+0xa6/0x210 kernel/workqueue.c:1517
  queue_work include/linux/workqueue.h:490 [inline]
  schedule_work include/linux/workqueue.h:548 [inline]
  slcan_write_wakeup+0x66/0x90 drivers/net/can/slcan.c:348
  tty_wakeup+0xe9/0x120 drivers/tty/tty_io.c:535
  pty_unthrottle+0x37/0x60 drivers/tty/pty.c:95
  tty_unthrottle+0xab/0x110 drivers/tty/tty_ioctl.c:139
  __tty_perform_flush+0x1b3/0x200 drivers/tty/tty_ioctl.c:861
  n_tty_ioctl_helper+0x1cc/0x3b0 drivers/tty/tty_ioctl.c:937
  n_tty_ioctl+0x59/0x370 drivers/tty/n_tty.c:2466
  tty_ioctl+0xaf9/0x14f0 drivers/tty/tty_io.c:2666
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446859
Code: e8 9c b4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f17a0a3fd18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446859
RDX: 0000000000000000 RSI: 000000000000540b RDI: 0000000000000003
RBP: 00000000006dbc30 R08: 00007f17a0a40700 R09: 0000000000000000
R10: 00007f17a0a40700 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 00007ffdfd0bdb5f R14: 00007f17a0a409c0 R15: 20c49ba5e353f7cf
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
