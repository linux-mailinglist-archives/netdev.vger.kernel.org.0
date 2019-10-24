Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F765E2759
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392839AbfJXA0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:26:10 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:49961 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392153AbfJXA0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:26:10 -0400
Received: by mail-io1-f72.google.com with SMTP id e14so24402720iot.16
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:26:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6J3Gk2vPQo6qzE0ZNBbdilVedqLgqsY0Rvrn6zwEJak=;
        b=l6yD7nUWIrMLVrGmg2Nlp1pgGLp6E6eME1dD3j7kMpt1rmGem8Mw03/V+eU2Ywepgm
         88bbYi+XhXW3uRyS+O+MfC/54eaHsHbQfMe4ecsHIIgmIA7P36K+neT3yKZ8moeY2CAE
         NQL+39QTk6Zi1HhlHKThjax4oAGVWuugCNIYqcEHg8ZfgB6pNeMv5nhhmwbvMIojrXh7
         RxDcGCv66WY63BjU6ykf0tKOG72uwjJtys/1R9E3JQHlRfBWF2f4hBoU/GASJ2UtOWAh
         SOAUoxhy2F0uJbn43CYcVxb3XPiM0A97FuVD3BEXkYA979Rl7QbfID+3l2ZCNpxmQ72T
         aTmA==
X-Gm-Message-State: APjAAAUMKWYjDQynny7b0e19ljWl8zhWTpVQ3Ubol4QzI1UcqWnW+BLZ
        cFEO4r9Sge30WWKKs0SMqR0zVhFRaCYpyJNNv1WUtAp5JKyY
X-Google-Smtp-Source: APXvYqzzCN/JQwwDL8/2ofRbYzrGhjBBwXWlSjSD1FBb2fUS+OTaPdHsrhjwOzWpYLyyHQjEO+HDO89IokShIrZEnS9pu2edepJU
MIME-Version: 1.0
X-Received: by 2002:a6b:b2cc:: with SMTP id b195mr5886685iof.21.1571876769155;
 Wed, 23 Oct 2019 17:26:09 -0700 (PDT)
Date:   Wed, 23 Oct 2019 17:26:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074d66305959d14b2@google.com>
Subject: WARNING: refcount bug in smc_release
From:   syzbot <syzbot+4c063e6dea39e4b79f29@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    406715df fq_codel: do not include <linux/jhash.h>
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=174f27f7600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f15f8f0e3274b14
dashboard link: https://syzkaller.appspot.com/bug?extid=4c063e6dea39e4b79f29
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a04def600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e456df600000

The bug was bisected to:

commit 50717a37db032ce783f50685a73bb2ac68471a5a
Author: Ursula Braun <ubraun@linux.ibm.com>
Date:   Fri Apr 12 10:57:23 2019 +0000

     net/smc: nonblocking connect rework

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=147c5954e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=167c5954e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=127c5954e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4c063e6dea39e4b79f29@syzkaller.appspotmail.com
Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 8688 at lib/refcount.c:190  
refcount_sub_and_test_checked lib/refcount.c:190 [inline]
WARNING: CPU: 0 PID: 8688 at lib/refcount.c:190  
refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8688 Comm: syz-executor713 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:refcount_sub_and_test_checked lib/refcount.c:190 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Code: 1d 24 69 7e 06 31 ff 89 de e8 bc ba 2e fe 84 db 75 94 e8 73 b9 2e fe  
48 c7 c7 00 ae e6 87 c6 05 04 69 7e 06 01 e8 18 fc ff fd <0f> 0b e9 75 ff  
ff ff e8 54 b9 2e fe e9 6e ff ff ff 48 89 df e8 d7
RSP: 0018:ffff88808bb6fcb0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815cb796 RDI: ffffed101176df88
RBP: ffff88808bb6fd48 R08: ffff8880993b2200 R09: fffffbfff14f0746
R10: fffffbfff14f0745 R11: ffffffff8a783a2f R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff88808bb6fd20 R15: 0000000000000000
  refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
  sock_put include/net/sock.h:1729 [inline]
  smc_release+0x236/0x3e0 net/smc/af_smc.c:194
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x401fb0
Code: 01 f0 ff ff 0f 83 40 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d 7d 8b 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 14 0d 00 00 c3 48 83 ec 08 e8 7a 02 00 00
RSP: 002b:00007fff583762f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000401fb0
RDX: 0000000000000017 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 0000000000010b24 R08: 0000000000000004 R09: 0000000500000000
R10: 0000000020000240 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004031e0 R14: 0000000000000000 R15: 0000000000000000
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
