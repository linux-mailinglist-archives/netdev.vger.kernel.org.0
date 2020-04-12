Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC11A5D28
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 09:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDLHQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 03:16:13 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37427 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgDLHQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 03:16:13 -0400
Received: by mail-io1-f71.google.com with SMTP id c26so1381879ioa.4
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 00:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=v+TCUhF73O+1SSJE4Hgt9P69vlxBjkRLsYm/3Z5y6Nc=;
        b=VK5tTVg20q5+qqaZewUSWr31O1rs3ixqF1XSdk8ZsQuUo7PQ9O+XAMIeJvpXwMCRba
         0lVuYQ9UPh9OXwDASklL67dtv3B3+JPsM9U0QB6yz/8BxBthDLOsV96RPPJuI4BBMBMS
         1NU5I5EEUBiOYwNbkHjtlNVim6MtoY5wnpFFgfYnFaDjzqPB6SITpy6mQ9OA1r7HaTo6
         +tnNuSjHa8rDeBv+OgUVY8W0sZK4xhvWGWzZ+PFRqVAEzXgPksCBZjdPe6gicaq9CgXa
         RE6ehNpBOpJlWTu0S7Z2/974iDnU6ecA0k/z5xGDJBrpe1q+1PhA3+YGuvp1aQla6IRg
         UgVg==
X-Gm-Message-State: AGi0PuaY0GMI13BPfylOo7Gw+3TIS0eZOdx6rh1nPEE9pcYQTJ1ztsom
        fsQ63nIrRacM9n17lvz/XUA+cRYSlx0/EPQeYBlw6BhWlDUk
X-Google-Smtp-Source: APiQypJ363A8CjuqZSgwp3da9Z46xXzvJS1nisdqRY6CVMSsPMrM4OzvtxdGIU4qEA58YjNmxcEtXjYllD1SqR5jD1UqcpqZxV3D
MIME-Version: 1.0
X-Received: by 2002:a5d:9c16:: with SMTP id 22mr10823384ioe.79.1586675773296;
 Sun, 12 Apr 2020 00:16:13 -0700 (PDT)
Date:   Sun, 12 Apr 2020 00:16:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d754eb05a312bd8f@google.com>
Subject: WARNING: bad unlock balance in mptcp_listen
From:   syzbot <syzbot+ffec3741d41140477097@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5b8b9d0c Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1712bdb3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23c5a352e32a1944
dashboard link: https://syzkaller.appspot.com/bug?extid=ffec3741d41140477097
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ffec3741d41140477097@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
5.6.0-syzkaller #0 Not tainted
-------------------------------------
syz-executor.0/25417 is trying to release lock (sk_lock-AF_INET6) at:
[<ffffffff87c65063>] mptcp_listen+0x1c3/0x2e0 net/mptcp/protocol.c:1783
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor.0/25417:
 #0: ffff888048fcf260 (slock-AF_INET6){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #0: ffff888048fcf260 (slock-AF_INET6){+.-.}-{2:2}, at: release_sock+0x1b/0x1b0 net/core/sock.c:2974

stack backtrace:
CPU: 0 PID: 25417 Comm: syz-executor.0 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __lock_release kernel/locking/lockdep.c:4633 [inline]
 lock_release+0x586/0x800 kernel/locking/lockdep.c:4941
 sock_release_ownership include/net/sock.h:1539 [inline]
 release_sock+0x177/0x1b0 net/core/sock.c:2984
 mptcp_listen+0x1c3/0x2e0 net/mptcp/protocol.c:1783
 __sys_listen+0x17d/0x250 net/socket.c:1696
 __do_sys_listen net/socket.c:1705 [inline]
 __se_sys_listen net/socket.c:1703 [inline]
 __x64_sys_listen+0x50/0x70 net/socket.c:1703
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fcb5e5dac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
RAX: ffffffffffffffda RBX: 00007fcb5e5db6d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000712 R14: 00000000004c9e2d R15: 000000000076bf0c


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
