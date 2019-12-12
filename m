Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7865711DA0B
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 00:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbfLLXdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 18:33:11 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:46498 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731170AbfLLXdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 18:33:11 -0500
Received: by mail-io1-f72.google.com with SMTP id p206so425125iod.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 15:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uPmT7H1u4tQQr91gsmUmlGu51pKPCSerupF0+mBYR+A=;
        b=BlZnm9YH0y6rnUig/2/FVQfgklLRpgY5VW1iI5rBnfkJpV+Daqe0UX92kNxx7CrK9E
         m7CaDBT/s6CwLx2VudL6n4qjuPa77BMkMEuIjmjxErlRtOqMPAbf1Rcmh+QgqRkQkfLo
         wqK8ip7oqqNDgdygGPpjFVCEBEH1P1X6giRmmrwgP0gidwJlL2aKz3XJkhqdYynBEe+7
         vO0GATTO0FFMFj58mhVfw/++4eZrmRpUJ/GLWaG/eiXXGBWftSY5VGXW7Q/xig88BVl5
         HzHoMsoypwSXbrVgV7ihEcOdg5dJXkNNEJA533rk+Xc0X8GnTjT1lKv82tgekKDo9x8t
         a4bw==
X-Gm-Message-State: APjAAAUJgU7XZ6jleRHvZnr1IGPkL/yQm2gvq83G0KhAwX9u8JmGPytG
        TeMLOjUszY5fetRP1K73t9g4RjzQyIV6PXgWooiw3aIXJ0Rc
X-Google-Smtp-Source: APXvYqxRonIBYq3QlOSfLTDmRhr3h1LOT5KDkHtrZySgylant5xgPnByJCRl6xs7oY/bbF7kt3LOHlPciackUCos0rlrM+RWe26+
MIME-Version: 1.0
X-Received: by 2002:a92:7606:: with SMTP id r6mr10592785ilc.120.1576193590352;
 Thu, 12 Dec 2019 15:33:10 -0800 (PST)
Date:   Thu, 12 Dec 2019 15:33:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ce4b105998a2b08@google.com>
Subject: KCSAN: data-race in add_timer / timer_clear_idle (2)
From:   syzbot <syzbot+c051abeff5e2e8ac40f0@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, elver@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ef798c30 x86, kcsan: Enable KCSAN for x86
git tree:       https://github.com/google/ktsan.git kcsan
console output: https://syzkaller.appspot.com/x/log.txt?x=156e052ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8077a73bd604a9d4
dashboard link: https://syzkaller.appspot.com/bug?extid=c051abeff5e2e8ac40f0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c051abeff5e2e8ac40f0@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in add_timer / timer_clear_idle

read to 0xffff88812be1b6e4 of 1 bytes by task 23 on cpu 1:
  forward_timer_base kernel/time/timer.c:892 [inline]
  __mod_timer kernel/time/timer.c:1009 [inline]
  mod_timer kernel/time/timer.c:1100 [inline]
  add_timer+0x3a6/0x550 kernel/time/timer.c:1136
  __queue_delayed_work+0x13b/0x1d0 kernel/workqueue.c:1649
  queue_delayed_work_on+0xf3/0x110 kernel/workqueue.c:1674
  queue_delayed_work include/linux/workqueue.h:509 [inline]
  batadv_mcast_start_timer net/batman-adv/multicast.c:71 [inline]
  batadv_mcast_mla_update+0x11ad/0x19e0 net/batman-adv/multicast.c:949
  process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
  worker_thread+0xa0/0x800 kernel/workqueue.c:2415
  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

write to 0xffff88812be1b6e4 of 1 bytes by task 0 on cpu 0:
  timer_clear_idle+0x42/0x50 kernel/time/timer.c:1675
  tick_nohz_restart_sched_tick kernel/time/tick-sched.c:839 [inline]
  __tick_nohz_idle_restart_tick+0x36/0x1b0 kernel/time/tick-sched.c:1140
  tick_nohz_idle_exit+0x1af/0x1e0 kernel/time/tick-sched.c:1181
  do_idle+0xb1/0x280 kernel/sched/idle.c:276
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:355
  rest_init+0xec/0xf6 init/main.c:452
  arch_call_rest_init+0x17/0x37
  start_kernel+0x838/0x85e init/main.c:786
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
  x86_64_start_kernel+0x72/0x76 arch/x86/kernel/head64.c:471
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
