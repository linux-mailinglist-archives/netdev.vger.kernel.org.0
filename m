Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE519C8BD
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 20:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389128AbgDBSXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 14:23:15 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55539 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgDBSXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 14:23:14 -0400
Received: by mail-io1-f70.google.com with SMTP id k5so3599614ioa.22
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 11:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NNlrRJrUXWvHWzrnTaBtXk0/+RiU5njBUqCM+N6MKjo=;
        b=SjiHJV2n0ahTkEP4ALhzFJoTO5UenmzrYzN/2pT9GMJLYV02z1WdjuAcQAniPp7KrM
         vvRwMrYqXB5/IDqJSYZwxrQDFzuVjShLpoUKpSgIm4WO47MbP0cJHDGiBdGYAZND9bbf
         QG+joMJTTRbq/wx/FO4lYbC4Mw1V6n/WjT/R3DXSck+rgKB3f01SkCJ6Lef8y6vAZqTs
         tgbB7TqsUFZb1lJZMwMC29WaFym22UYNJhEBBgToioLC1LHufLlp8eZy2BDP7m1V8NKu
         rppvz8CR8dbJjRcL+xO0jmZUS6eL+qYVVBXMnDlb6GKEGXQD0It56vivZrdt8+Twoa18
         It0g==
X-Gm-Message-State: AGi0PuZL8/lAfYhQHmKj6+8xe9cpS6pTmKVx33kR8SXidWNdfOZGeE4R
        aLd0s5dnvaJCVxMzhyxzkP6KFSo3wS1NmyS/Rdm5dbCquiEV
X-Google-Smtp-Source: APiQypL0C54pWwDAKqya6F/1DWLBx0dcmDEjT3rj11kXPMmqwIwibJF2HBXzKlfzzdkmw2F3ZvQdo2TQ1TqfUT0EjCSdpFGAA5AY
MIME-Version: 1.0
X-Received: by 2002:a5d:9c15:: with SMTP id 21mr3992216ioe.47.1585851791831;
 Thu, 02 Apr 2020 11:23:11 -0700 (PDT)
Date:   Thu, 02 Apr 2020 11:23:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7fabf05a252e486@google.com>
Subject: WARNING: refcount bug in tcindex_data_put
From:   syzbot <syzbot+8325e509a1bf83ec741d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paulmck@kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    304e0242 net_sched: add a temporary refcnt for struct tcin..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13471edbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
dashboard link: https://syzkaller.appspot.com/bug?extid=8325e509a1bf83ec741d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c6940be00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c74ba3e00000

The bug was bisected to:

commit 304e024216a802a7dc8ba75d36de82fa136bbf3e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat Mar 28 19:12:59 2020 +0000

    net_sched: add a temporary refcnt for struct tcindex_data

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=141434b7e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=161434b7e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=121434b7e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8325e509a1bf83ec741d@syzkaller.appspotmail.com
Fixes: 304e024216a8 ("net_sched: add a temporary refcnt for struct tcindex_data")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: tc_filter_workqueue tcindex_destroy_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 2c 95 1e fe e9 8a fe ff ff e8 c2 81 e1 fd 48 c7 c7 40 c6 71 88 c6 05 42 be f1 06 01 e8 17 f6 b2 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90000cdfcf0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ca861 RDI: fffff5200019bf90
RBP: 0000000000000003 R08: ffff8880a95a41c0 R09: ffffed1015cc66a1
R10: ffffed1015cc66a0 R11: ffff8880ae633507 R12: ffff8880a81c8c2c
R13: ffff8880a81c8c40 R14: ffff8880a9580e00 R15: ffff8880aa034800
 refcount_sub_and_test include/linux/refcount.h:261 [inline]
 refcount_dec_and_test include/linux/refcount.h:281 [inline]
 tcindex_data_put+0xd1/0xf0 net/sched/cls_tcindex.c:72
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
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
