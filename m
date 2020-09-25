Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D037278319
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgIYIsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:48:18 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:52232 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgIYIsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 04:48:18 -0400
Received: by mail-io1-f77.google.com with SMTP id m4so1334818iov.19
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LNccWS+JI9NcnbLQnvb67MfGJhsAMkaBNdUAqfdeRaQ=;
        b=lQJVIY0zUt4GxXvtaFcoDnmZ/ka1KlcPSbQCBpdIVdna+IVsvWgGM9NFKUBuSkPjPZ
         c21xHMo7JdszVGL2Qy1idixQZUQTI/drjitDYfYjPdCtfR+iAOK/+HnYbIlkulJuKYcK
         S2hmiPggD3mxtNLuR81qeyqWXapk7KeydbjYAr9tnWNG8bO6A2VTsRTaUwm0MpDeBYTA
         ALHM0LekRolTwRLxuzsMHml3nn8bWH1c+EsVhAXG7L8jJREy7unkveud8YkojM67mwxQ
         8kFegcZvhZxVsSqsLUnIvShskZt6icMhFpD1GAPJ16UQlNvbZpE46gMbBCiENWWu1sMi
         S9Vw==
X-Gm-Message-State: AOAM531GXg85fenNISNxBaYI+ipvsHhjxeA2y2kaABphAspF2L03S7BL
        AUVbhQhv6iBXAmHAMPw5jhR50dWJKKt8SM07lFnrSrkaAQ0m
X-Google-Smtp-Source: ABdhPJz5P+cWI8ssLnmLyk1FeKjIyyY3hTxep5Qm1IdQQbx5w6JqJssP0pMEuEw4vZKjNOJyV68Mb/9YeyPXourAn0NFOGejQ/so
MIME-Version: 1.0
X-Received: by 2002:a92:1b19:: with SMTP id b25mr2392302ilb.290.1601023696814;
 Fri, 25 Sep 2020 01:48:16 -0700 (PDT)
Date:   Fri, 25 Sep 2020 01:48:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9cf7105b01f60a5@google.com>
Subject: possible deadlock in x25_disconnect
From:   syzbot <syzbot+1e6138e3196ac80e99b8@syzkaller.appspotmail.com>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    77972b55 Revert "ravb: Fixed to be able to unload modules"
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=110cf809900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=1e6138e3196ac80e99b8
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e6138e3196ac80e99b8@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.9.0-rc6-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.1/12065 is trying to acquire lock:
ffffffff8b2e7318 (x25_list_lock){++..}-{2:2}, at: x25_disconnect+0x279/0x3e0 net/x25/x25_subr.c:361

but task is already holding lock:
ffffffff8b2e7318 (x25_list_lock){++..}-{2:2}, at: x25_kill_by_device net/x25/af_x25.c:209 [inline]
ffffffff8b2e7318 (x25_list_lock){++..}-{2:2}, at: x25_device_event+0x1bf/0x300 net/x25/af_x25.c:247

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(x25_list_lock);
  lock(x25_list_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.1/12065:
 #0: ffffffff8b148f28 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x1a3/0xc40 net/core/dev_ioctl.c:510
 #1: ffffffff8b2e7318 (x25_list_lock){++..}-{2:2}, at: x25_kill_by_device net/x25/af_x25.c:209 [inline]
 #1: ffffffff8b2e7318 (x25_list_lock){++..}-{2:2}, at: x25_device_event+0x1bf/0x300 net/x25/af_x25.c:247

stack backtrace:
CPU: 0 PID: 12065 Comm: syz-executor.1 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain kernel/locking/lockdep.c:3202 [inline]
 __lock_acquire.cold+0x148/0x3b0 kernel/locking/lockdep.c:4441
 lock_acquire+0x1f3/0xaf0 kernel/locking/lockdep.c:5029
 __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
 _raw_read_lock_bh+0x32/0x40 kernel/locking/spinlock.c:247
 x25_disconnect+0x279/0x3e0 net/x25/x25_subr.c:361
 x25_kill_by_device net/x25/af_x25.c:213 [inline]
 x25_device_event+0x27c/0x300 net/x25/af_x25.c:247
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8325
 dev_change_flags+0x100/0x160 net/core/dev.c:8361
 dev_ifsioc+0x210/0xa70 net/core/dev_ioctl.c:265
 dev_ioctl+0x1b1/0xc40 net/core/dev_ioctl.c:511
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1070
 sock_ioctl+0x3b8/0x730 net/socket.c:1198
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: 3d b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f623a794c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000015740 RCX: 000000000045e179
RDX: 0000000020000140 RSI: 0000000000008914 RDI: 0000000000000004
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffc0abd13ff R14: 00007f623a7959c0 R15: 000000000118cf4c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
