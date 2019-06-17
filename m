Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0978D47B8D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfFQHqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:46:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39462 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfFQHqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 03:46:05 -0400
Received: by mail-io1-f72.google.com with SMTP id y13so11253843iol.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 00:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TRwP9iBnWIcCZj4VxVwQzGg8mKKux61Ksuz73VA06GU=;
        b=fZTRFUWXee/Wo/FoBfETKbmxBpilUg8LZT3VSrRz4gb3puB1FNjc/hlp8GAWz11vas
         XWs6sKOVf2k2FVJkY3fmaGmvfUvQeaq6JRSgGBeo5nwH4jqygZ1exL+lWgjnirN/OMyM
         ngsS5P+scUPG6vz6zVMRpHCzHm3ZDbEeXaEqLoudTZPb8srNI2/2ZvyHqo3iFgmNnP04
         AR7krGMnRrV+1w0XE7wCzZuQfAaxgzjl3gVPELhZn52h0mEoSekc4QU4PfkqVzaEq859
         Tirm29q/ZPpdMHITRO54jlgHXB++OJ5Tg/iMgIQl3VncLOZdsyH8gYgwZinBNHGoreob
         EaKQ==
X-Gm-Message-State: APjAAAUREysZkGLx0HJk9OdoHo5AgH0t03mUG067G3i6wwhs9BFIDD0+
        FWayHqCmcKVoArj8SZ/CBAgjeuGF6ayZ0yZaMfu8oEDzAuOt
X-Google-Smtp-Source: APXvYqy2wU5BPCaBvuETRe+d1zv8l1FuIXnavXvLXwjEVz9HnpkWjib53e2BlUB2jIZ1V13PTJg3zIpfexyycoOXMBJZIlbXV7rb
MIME-Version: 1.0
X-Received: by 2002:a6b:7b01:: with SMTP id l1mr19538142iop.60.1560757565063;
 Mon, 17 Jun 2019 00:46:05 -0700 (PDT)
Date:   Mon, 17 Jun 2019 00:46:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f07fe058b803013@google.com>
Subject: general protection fault in rb_next (3)
From:   syzbot <syzbot+ab4c44191771d56c4eda@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0011572c Merge branch 'for-5.2-fixes' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147fbc56a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9f7e1b6a8bb586
dashboard link: https://syzkaller.appspot.com/bug?extid=ab4c44191771d56c4eda
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c17076a00000

The bug was bisected to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c090eaa00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16c090eaa00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12c090eaa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ab4c44191771d56c4eda@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8856 Comm: syz-executor.2 Not tainted 5.2.0-rc4+ #32
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rb_next+0xd7/0x140 lib/rbtree.c:529
Code: 49 89 dc 4c 89 eb 48 83 e3 fc 48 89 d8 75 c8 48 83 c4 08 5b 41 5c 41  
5d 41 5e 5d c3 48 89 d0 48 8d 78 10 48 89 fa 48 c1 ea 03 <80> 3c 1a 00 75  
1a 48 8b 50 10 48 85 d2 75 e3 48 83 c4 08 5b 41 5c
RSP: 0018:ffff8880ae809d70 EFLAGS: 00010007
RAX: 26f1e8c689c389ff RBX: dffffc0000000000 RCX: ffffffff87185c81
RDX: 04de3d18d1387141 RSI: ffffffff87185d10 RDI: 26f1e8c689c38a0f
RBP: ffff8880ae809d98 R08: ffff88808a51a440 R09: ffffed1015d06be0
R10: ffffed1015d06bdf R11: ffff8880ae835efb R12: ffff8880ae8275c0
R13: ffff8880ae827861 R14: dffffc0000000000 R15: ffff8880ae826d00
FS:  0000555555728940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000a8dc78 CR3: 00000000992f7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  timerqueue_del+0xd8/0x150 lib/timerqueue.c:70
  __remove_hrtimer+0xa8/0x1c0 kernel/time/hrtimer.c:975
  __run_hrtimer kernel/time/hrtimer.c:1371 [inline]
  __hrtimer_run_queues+0x2a8/0xdd0 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
  smp_apic_timer_interrupt+0x111/0x550 arch/x86/kernel/apic/apic.c:1066
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
Modules linked in:

======================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
