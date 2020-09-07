Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0546826062A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgIGVSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:18:20 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:39647 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIGVSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 17:18:16 -0400
Received: by mail-io1-f78.google.com with SMTP id y16so2272967ioy.6
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 14:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=09pWBT/PP+tztnjAD+rcykPn+dW1XyQ4e9UmJXFSZJU=;
        b=gbNhW/jL9AS8F5hoQX7BLsm1I9ks0ISz2G8h4jmxWhC1+Bl42CCK/oRss6Xwqkn0e8
         6W8CKh05Bfaj34Y1ZuvGiqvEAtWNDyl0Y2noyLbZypbgN3CH7Eg+EsvE9b0rAF/wd0SS
         rGwTrd2cCCUowGqYh49j9iSBUNxizR0NWJDPwqN1Utnrou5BN8tvpLG9x6i2x7NHg87y
         bRFkeb3D1dC4AP3CXsbJGI0Ece4rxoLnNe6nrOvN89Q92cI0HSCGTR680PG+B5z/5UXv
         XWqXvZ9DFObBJQXnv3PwYaSBapPg4Jw4zwVc8gJGQkJV8SEIoQq6EWccZmH0qDWGJznN
         xSIg==
X-Gm-Message-State: AOAM531CJ4yZCqAFXBEfLIW1MFfb5IJxW2RC8l4VM8uyOfFkDq0oSgXg
        NTZy2drWvAFFfwoatdXqxV1EgxKiESJG1EASzrkaX/rZrWyR
X-Google-Smtp-Source: ABdhPJw8/0Pk2iEx+xwz3nBHrOjYz4yIcwj+fAcYO2wE+/5Rg3d3o/Pg2uCDoC+2doHombq06RVxXggAHy5inF/t7jmVaV0UqC8o
MIME-Version: 1.0
X-Received: by 2002:a5d:8e14:: with SMTP id e20mr18339861iod.119.1599513495433;
 Mon, 07 Sep 2020 14:18:15 -0700 (PDT)
Date:   Mon, 07 Sep 2020 14:18:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b575ab05aebfc192@google.com>
Subject: WARNING: refcount bug in qrtr_node_lookup
From:   syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9322c47b Merge tag 'xfs-5.9-fixes-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16cf729e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1c560d0f4e121c9
dashboard link: https://syzkaller.appspot.com/bug?extid=c613e88b3093ebf3686e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170c51a5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151a4245900000

The issue was bisected to:

commit e42671084361302141a09284fde9bbc14fdd16bf
Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date:   Thu May 7 12:53:06 2020 +0000

    net: qrtr: Do not depend on ARCH_QCOM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fd1a9e900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fd1a9e900000
console output: https://syzkaller.appspot.com/x/log.txt?x=14fd1a9e900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 21 at lib/refcount.c:25 refcount_warn_saturate+0x13d/0x1a0 lib/refcount.c:25
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 21 Comm: kworker/u4:1 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: qrtr_ns_handler qrtr_ns_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 panic+0x2c0/0x800 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x13d/0x1a0 lib/refcount.c:25
Code: c7 83 96 15 89 31 c0 e8 b1 34 a6 fd 0f 0b eb a3 e8 a8 94 d4 fd c6 05 04 8e ea 05 01 48 c7 c7 ba 96 15 89 31 c0 e8 93 34 a6 fd <0f> 0b eb 85 e8 8a 94 d4 fd c6 05 e7 8d ea 05 01 48 c7 c7 e6 96 15
RSP: 0018:ffffc90000dd79c0 EFLAGS: 00010046
RAX: eb7b51afe96d3100 RBX: 0000000000000002 RCX: ffff8880a9bf6580
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: 0000000000000002 R08: ffffffff815e27d0 R09: ffffed1015d241c3
R10: ffffed1015d241c3 R11: 0000000000000000 R12: ffff8880a761a898
R13: 1ffff1101517fa56 R14: 0000000000000286 R15: ffff8880a761a800
 refcount_add include/linux/refcount.h:206 [inline]
 refcount_inc include/linux/refcount.h:241 [inline]
 kref_get include/linux/kref.h:45 [inline]
 qrtr_node_acquire net/qrtr/qrtr.c:196 [inline]
 qrtr_node_lookup+0xc0/0xd0 net/qrtr/qrtr.c:388
 qrtr_send_resume_tx net/qrtr/qrtr.c:980 [inline]
 qrtr_recvmsg+0x429/0xa80 net/qrtr/qrtr.c:1043
 qrtr_ns_worker+0x176/0x45f0 net/qrtr/ns.c:624
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
