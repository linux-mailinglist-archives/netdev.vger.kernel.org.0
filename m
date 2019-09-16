Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E6AB44A6
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 01:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfIPXjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 19:39:11 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:43787 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfIPXjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 19:39:10 -0400
Received: by mail-io1-f72.google.com with SMTP id o6so2720788ioh.10
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 16:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dsEiraNwRgm8wyCXDp8ZxBjw4VcDAPzRPxd6mM9u8sk=;
        b=CAxwwvEZ/uv+w/7IkV06CbaN//Ie+zn1MT630o7i8QQdDQemfxXLZRW/wIKqtUldTG
         xl3oRCpmMDaW5dnNAslDcV7cG4H2VhgUCG/93xR5VL0Ze5ocIt/gYwdKeGxaI+fEplri
         hEZc5qDqLiKoVOFakHHlEbxDDsizrGyEJ4bOBavSpQZRUacpcqfriBMKzWFKnCf8ZSHE
         38ksknJpkqxNZ1o5LD0HgmW5RNydeiVGzsRSsE6IbAbQ5iul/AGzZOVVX1r/4u50napi
         OyCRFqYOXrW/Km4XA/Hpaz3gSz5sCCadp09dW9sz+BRapCTo1iHbTpR4FwMSUxA+t3UI
         UqAg==
X-Gm-Message-State: APjAAAXu1NoBrs/ioNFxtzNLSeQGwlQAq0xXQj0g4lCv/ejI9m8KqWOt
        +UfgNcN0zpE5ZdhGFMNaLHcGOK3qWnAezOoLetPTGCyg059D
X-Google-Smtp-Source: APXvYqzSXv5F2fQ/LzsIQs5lD5I/baH0tP7f0G11VUkAh30cRzTKJIYiqwhn0ozvdI14GUhHsXxhZUsmLgDiP38cOIBmedzS5SYb
MIME-Version: 1.0
X-Received: by 2002:a6b:3804:: with SMTP id f4mr519700ioa.166.1568677147810;
 Mon, 16 Sep 2019 16:39:07 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:39:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029a3a00592b41c48@google.com>
Subject: BUG: sleeping function called from invalid context in tcf_chain0_head_change_cb_del
From:   syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@gmail.com, f.fainelli@gmail.com, hawk@kernel.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, jiri@mellanox.com, jiri@resnulli.us,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, petrm@mellanox.com,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, vladbu@mellanox.com,
        xdp-newbies@vger.kernel.org, xiyou.wangcong@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1609d760 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10236abe600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed2b148cd67382ec
dashboard link: https://syzkaller.appspot.com/bug?extid=ac54455281db908c581e
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116c4b11600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ff270d600000

The bug was bisected to:

commit c266f64dbfa2a970a13b0574246c0ddfec492365
Author: Vlad Buslov <vladbu@mellanox.com>
Date:   Mon Feb 11 08:55:32 2019 +0000

     net: sched: protect block state with mutex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16e7ca65600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15e7ca65600000
console output: https://syzkaller.appspot.com/x/log.txt?x=11e7ca65600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")

BUG: sleeping function called from invalid context at  
kernel/locking/mutex.c:909
in_atomic(): 1, irqs_disabled(): 0, pid: 9297, name: syz-executor942
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff8604de24>] spin_lock_bh include/linux/spinlock.h:343 [inline]
[<ffffffff8604de24>] sch_tree_lock include/net/sch_generic.h:570 [inline]
[<ffffffff8604de24>] sfb_change+0x284/0xd30 net/sched/sch_sfb.c:519
CPU: 0 PID: 9297 Comm: syz-executor942 Not tainted 5.3.0-rc8+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  ___might_sleep+0x3ff/0x530 kernel/sched/core.c:6608
  __might_sleep+0x8f/0x100 kernel/sched/core.c:6561
  __mutex_lock_common+0x4e/0x2820 kernel/locking/mutex.c:909
  __mutex_lock kernel/locking/mutex.c:1077 [inline]
  mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:1092
  tcf_chain0_head_change_cb_del+0x30/0x390 net/sched/cls_api.c:932
  tcf_block_put_ext+0x3d/0x2a0 net/sched/cls_api.c:1502
  tcf_block_put+0x6e/0x90 net/sched/cls_api.c:1515
  sfb_destroy+0x47/0x70 net/sched/sch_sfb.c:467
  qdisc_destroy+0x147/0x4d0 net/sched/sch_generic.c:968
  qdisc_put+0x58/0x90 net/sched/sch_generic.c:992
  sfb_change+0x52d/0xd30 net/sched/sch_sfb.c:522
  qdisc_change net/sched/sch_api.c:1321 [inline]
  tc_modify_qdisc+0x184d/0x1ea0 net/sched/sch_api.c:1623
  rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x19e/0x3d0 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5241
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x787/0x900 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x993/0xc50 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x60d/0x910 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x17c/0x200 net/socket.c:2363
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447509
Code: e8 5c 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 ab 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f49d6c94db8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dcc78 RCX: 0000000000447509
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000007
RBP: 00000000006dcc70 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00000000006dcc7c
R13: 00007ffc5c2e9dff R14: 00007f49d6c959c0 R15: 000000000000002d


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
