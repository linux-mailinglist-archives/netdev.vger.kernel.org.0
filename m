Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7E1A52F3
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 18:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgDKQvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 12:51:15 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52168 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgDKQvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 12:51:15 -0400
Received: by mail-io1-f71.google.com with SMTP id s1so5268816iow.18
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 09:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=As0Y7ua5VMVu+Xnew9pcgqlS9YFvgOyg/T6dfPG/GCo=;
        b=OuMMo+OwAqkwHKJ9xYtCcPEGO7D36/CjgKQO0C/tLgvrENJ9eZzNp6Y+mPISjy9B+5
         vMnZGaSIptNoM/mueUKD9kXgY14ZY/7W4EZL1GTH3CTMu5zxObgEfKQN0enmVvoIJfiS
         YskeCSiNzSpOfWbvS33OJIQSnjCzWMcut3b1gDsxnl8fi5nD3CmFyXr37pvH5shO5ACw
         BNboUTLxnmZigHlvvBfTIg8zxQX+8rqcEnxw3+smy1W07uWvUpAttb9Eg5KFIzsE00dB
         k/vWDX/r2d0KDMTK3ZEWbsBCATwOBfqroWNOhNvoRiyv6bOOLhIHv7O/1HvbUk8Q2h0t
         hGOg==
X-Gm-Message-State: AGi0PuaugCZYm+82vWal4EY1dasGKxfuH1SDkbdDpUQynb1oPdgA9Yed
        Ep5hP80KQAvOkqgibM8gCiou/ScNIoG5Ww5zBcFuIMoNIlbt
X-Google-Smtp-Source: APiQypIzpK/aJKQ7FNGKbajlmICsM/z5yDKPLbWtTt0F9ofbpdFyJ6s5gBAXynyottizBtOIMAW6EUvnbu4BilsYpLd9nzZKNx7/
MIME-Version: 1.0
X-Received: by 2002:a92:c912:: with SMTP id t18mr10102944ilp.214.1586623874959;
 Sat, 11 Apr 2020 09:51:14 -0700 (PDT)
Date:   Sat, 11 Apr 2020 09:51:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000758fcf05a306a8bf@google.com>
Subject: WARNING: bad unlock balance in mptcp_poll
From:   syzbot <syzbot+e56606435b7bfeea8cf5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fw@strlen.de, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae46d2aa mm/gup: Let __get_user_pages_locked() return -EIN..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fef69fe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca75979eeebf06c2
dashboard link: https://syzkaller.appspot.com/bug?extid=e56606435b7bfeea8cf5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111ccd2be00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162b0a77e00000

The bug was bisected to:

commit 59832e246515ab6a4f5aa878073e6f415aa35166
Author: Florian Westphal <fw@strlen.de>
Date:   Thu Apr 2 11:44:52 2020 +0000

    mptcp: subflow: check parent mptcp socket on subflow state change

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c1f69fe00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16c1f69fe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12c1f69fe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e56606435b7bfeea8cf5@syzkaller.appspotmail.com
Fixes: 59832e246515 ("mptcp: subflow: check parent mptcp socket on subflow state change")

=====================================
WARNING: bad unlock balance detected!
5.6.0-syzkaller #0 Not tainted
-------------------------------------
syz-executor473/7733 is trying to release lock (sk_lock-AF_INET6) at:
[<ffffffff87c51839>] mptcp_poll+0xb9/0x530 net/mptcp/protocol.c:1856
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor473/7733:
 #0: ffff88808fe2f0a0 (slock-AF_INET6){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #0: ffff88808fe2f0a0 (slock-AF_INET6){+...}-{2:2}, at: release_sock+0x1b/0x1b0 net/core/sock.c:2974

stack backtrace:
CPU: 0 PID: 7733 Comm: syz-executor473 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __lock_release kernel/locking/lockdep.c:4633 [inline]
 lock_release+0x586/0x800 kernel/locking/lockdep.c:4941
 sock_release_ownership include/net/sock.h:1539 [inline]
 release_sock+0x177/0x1b0 net/core/sock.c:2984
 mptcp_poll+0xb9/0x530 net/mptcp/protocol.c:1856
 sock_poll+0x15c/0x470 net/socket.c:1271
 vfs_poll include/linux/poll.h:90 [inline]
 do_pollfd fs/select.c:859 [inline]
 do_poll fs/select.c:907 [inline]
 do_sys_poll+0x63c/0xdd0 fs/select.c:1001
 __do_sys_ppoll fs/select.c:1101 [inline]
 __se_sys_ppoll fs/select.c:1081 [inline]
 __x64_sys_ppoll+0x210/0x280 fs/select.c:1081
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x441219
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff9deb18e8 EFLAGS: 00000246 ORIG_RAX: 000000000000010f
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441219
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000020000080
RBP: 000000000000f233 R08: 3f00000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402040
R13: 00000000004020d0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
