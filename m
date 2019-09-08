Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F703ACB21
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfIHGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 02:08:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53189 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfIHGIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 02:08:10 -0400
Received: by mail-io1-f70.google.com with SMTP id p25so724985ioj.19
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 23:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SZSfhtr5FqVzkjRCSV4YZtYrjPAPQfvbwX9RUVZt7aw=;
        b=RKRZTzq0bEQWvmoi09KiISOfq8blszKhScmMsMhIX7gezsqECawQIU1VWHb8X9YEye
         D1eRaIH99if2NTQbG4RgXfgK/8sg0z3eYAp8J5I/QmuQadnR3RWY4Ee7PDoMnDpUSeKw
         aJhTepYsELGEyIhqlL0jVdfNwQC5gUI192HcX3ol2ZW1HsWTQOKVWo9yJdZQvQXtDUPD
         bZEMgHHX14WWragJhtIxRu5Htuy3zPFZQObTTb4xk6GTARNTEvPd34NDzgyKGsVTig+y
         +FLKdmi9tiepiTkqZKskeZx9okz0UexcdXxJt+iL7TdiJjHbfJNsaPcG2WX7SDLRiKNl
         /50w==
X-Gm-Message-State: APjAAAUx1svADgIYjzKwg9Dw0yrHltlB+wTcxkVeDgj2EydPuYce9o9R
        Bw7wb6JxNXvf9fQ3gH0NIFnMBfW06N8B39WoM3I6tZlsAxWh
X-Google-Smtp-Source: APXvYqyhQzb8ZM+7/nKXimD/Isf74gZVw6s1V3BXV4vkPSEsIfbubF5BPjLN5g4tmvgqZENeDU9vbrHiEgMRXPr0Xf2GBrkXB3KQ
MIME-Version: 1.0
X-Received: by 2002:a02:8807:: with SMTP id r7mr19498653jai.126.1567922889924;
 Sat, 07 Sep 2019 23:08:09 -0700 (PDT)
Date:   Sat, 07 Sep 2019 23:08:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3a76c0592047ea7@google.com>
Subject: WARNING in cbs_dequeue_soft
From:   syzbot <syzbot+cdbea9b616d35e2365ae@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        leandro.maciel.dorileo@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vedang.patel@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6d028043 Add linux-next specific files for 20190830
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17f1421a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82a6bec43ab0cb69
dashboard link: https://syzkaller.appspot.com/bug?extid=cdbea9b616d35e2365ae
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147b54d1600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c5da6e600000

The bug was bisected to:

commit e0a7683d30e91e30ee6cf96314ae58a0314a095e
Author: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Date:   Mon Apr 8 17:12:18 2019 +0000

     net/sched: cbs: fix port_rate miscalculation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130c614e600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=108c614e600000
console output: https://syzkaller.appspot.com/x/log.txt?x=170c614e600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cdbea9b616d35e2365ae@syzkaller.appspotmail.com
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")

------------[ cut here ]------------
cbs: dequeue() called with unknown port rate.
WARNING: CPU: 1 PID: 8572 at net/sched/sch_cbs.c:185  
cbs_dequeue_soft+0x37e/0x4b0 net/sched/sch_cbs.c:185
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8572 Comm: kworker/1:2 Not tainted 5.3.0-rc6-next-20190830 #75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:220
  __warn.cold+0x2f/0x3c kernel/panic.c:581
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:cbs_dequeue_soft+0x37e/0x4b0 net/sched/sch_cbs.c:185
Code: 1d 2c b3 f5 03 31 ff 89 de e8 fe 6d a6 fb 84 db 75 1a e8 b5 6c a6 fb  
48 c7 c7 80 7d 4a 88 c6 05 0c b3 f5 03 01 e8 0a bb 77 fb <0f> 0b 45 31 e4  
eb b1 49 bc ff ff ff ff ff ff ff 7f 48 89 55 d0 e8
RSP: 0018:ffff8880a129f3e8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bf786 RDI: ffffed1014253e6f
RBP: ffff8880a129f430 R08: ffff8880a63f4040 R09: fffffbfff14ed341
R10: fffffbfff14ed340 R11: ffffffff8a769a07 R12: ffff8880911a5800
R13: ffff888095de92c8 R14: 0000000f8f3a4493 R15: ffffffffffffffff
  cbs_dequeue+0x34/0x40 net/sched/sch_cbs.c:237
  dequeue_skb net/sched/sch_generic.c:258 [inline]
  qdisc_restart net/sched/sch_generic.c:361 [inline]
  __qdisc_run+0x1e7/0x19d0 net/sched/sch_generic.c:379
  __dev_xmit_skb net/core/dev.c:3533 [inline]
  __dev_queue_xmit+0x16f1/0x37c0 net/core/dev.c:3838
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5a5/0x970 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x1034/0x2550 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ndisc_send_skb+0xf29/0x14a0 net/ipv6/ndisc.c:505
  ndisc_send_ns+0x3a9/0x850 net/ipv6/ndisc.c:647
  addrconf_dad_work+0xb88/0x1150 net/ipv6/addrconf.c:4120
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
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
