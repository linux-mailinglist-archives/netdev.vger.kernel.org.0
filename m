Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43321378D53
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348043AbhEJMjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:39:43 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44739 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345071AbhEJMVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 08:21:25 -0400
Received: by mail-io1-f71.google.com with SMTP id z25-20020a05660200d9b02903de90ff885fso10330756ioe.11
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 05:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yGybm/OKMYW9dTFg1+VqjuNHMpHtONIEX8ofI4uC37E=;
        b=f5HfeB8BFY9yZ0LLljX4KqPq+gX7Q/dOHu4YyQ2Kh6/WQ351lCMa8roj/1L43Mfxj7
         ArDWq7bFAqYqCq8vczSvQe1jVK9v9ndRFjm2FfpdBdzGX+FIzDq2rQkyoj7V3QsVbaH1
         UFeRpb4Jj9rjIOFt2EQbpprkG2COICe5z96oEJB0abC5w6X1NhGEVPAfNirBTeqOF3Pw
         CTV/LCuwpV8MLMsjO6JQWCsVt/ri51zRYEXJa9z+s1+VB52ndDdgioVR3N5YY8hKfVoC
         1e/ToJj0fgbA4scXHdzI1u5WYj4eEEywu8fnscmt7xSBy382PgFCnCO9aKD+9XA7xrCx
         T0LA==
X-Gm-Message-State: AOAM533oGf6geI93qipbYYoOAcpiZyBkE6WTWRixwQjx7CeO4e/GoF7F
        BHVXEZEcQJzyGLHsHPqfWbQlg/clzmVYD7nvo+6bB0vQJqBp
X-Google-Smtp-Source: ABdhPJyyQw3dEbRyRW4VS0DoprZBL+QwBz/A3ubXiEuokZ79wk2MeZ/DpST/4kh+m5PHrFl5BaIjFixw3WvNAt6t09iWSmhKnhRo
MIME-Version: 1.0
X-Received: by 2002:a02:a81a:: with SMTP id f26mr17370052jaj.110.1620649219813;
 Mon, 10 May 2021 05:20:19 -0700 (PDT)
Date:   Mon, 10 May 2021 05:20:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d772e05c1f8cd1f@google.com>
Subject: [syzbot] possible deadlock in cfg80211_netdev_notifier_call (2)
From:   syzbot <syzbot+452ea4fbbef700ff0a56@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b7415964 Merge tag 'riscv-for-linus-5.13-mw1' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1240ba0dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b072be26137971e1
dashboard link: https://syzkaller.appspot.com/bug?extid=452ea4fbbef700ff0a56

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+452ea4fbbef700ff0a56@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.12.0-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.1/16085 is trying to acquire lock:
ffff88804f3b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5273 [inline]
ffff88804f3b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: cfg80211_netdev_notifier_call+0x704/0x11d0 net/wireless/core.c:1429

but task is already holding lock:
ffff88804f3b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5273 [inline]
ffff88804f3b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: ieee80211_stop+0x6a/0xf0 net/mac80211/iface.c:644

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rdev->wiphy.mtx);
  lock(&rdev->wiphy.mtx);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.1/16085:
 #0: ffffffff8d6a4968 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x19f/0xb70 net/core/dev_ioctl.c:504
 #1: ffff88804f3b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5273 [inline]
 #1: ffff88804f3b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: ieee80211_stop+0x6a/0xf0 net/mac80211/iface.c:644

stack backtrace:
CPU: 0 PID: 16085 Comm: syz-executor.1 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2831 [inline]
 check_deadlock kernel/locking/lockdep.c:2874 [inline]
 validate_chain kernel/locking/lockdep.c:3663 [inline]
 __lock_acquire.cold+0x22f/0x3b4 kernel/locking/lockdep.c:4902
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
 __mutex_lock_common kernel/locking/mutex.c:949 [inline]
 __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
 wiphy_lock include/net/cfg80211.h:5273 [inline]
 cfg80211_netdev_notifier_call+0x704/0x11d0 net/wireless/core.c:1429
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 __dev_close_many+0xf3/0x2f0 net/core/dev.c:1667
 dev_close_many+0x22c/0x620 net/core/dev.c:1718
 dev_close net/core/dev.c:1744 [inline]
 dev_close+0x16d/0x210 net/core/dev.c:1738
 ieee80211_do_stop+0x1276/0x20e0 net/mac80211/iface.c:486
 ieee80211_stop+0x77/0xf0 net/mac80211/iface.c:645
 __dev_close_many+0x1b8/0x2f0 net/core/dev.c:1693
 __dev_close net/core/dev.c:1705 [inline]
 __dev_change_flags+0x2ca/0x750 net/core/dev.c:8739
 dev_change_flags+0x93/0x170 net/core/dev.c:8812
 dev_ifsioc+0x210/0xa60 net/core/dev_ioctl.c:254
 dev_ioctl+0x1ad/0xb70 net/core/dev_ioctl.c:505
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1062
 sock_ioctl+0x477/0x6a0 net/socket.c:1179
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f59aeea3188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 00000000200005c0 RSI: 0000000000008914 RDI: 0000000000000003
RBP: 00000000004bfce1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 0000000000a9fb1f R14: 00007f59aeea3300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
