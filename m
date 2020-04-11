Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221921A53CF
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 23:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgDKViM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 17:38:12 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:41595 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgDKViM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 17:38:12 -0400
Received: by mail-il1-f200.google.com with SMTP id c10so6255741ilq.8
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 14:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qVLd3Bd3uBVfJRLs8SbZxIzd9JmqnZ3Z/DLvPZ5BOss=;
        b=GTHCwl7Lzl0crCQ+91y41IfehLFUxbHA9ZtqONKUqVAkUwjNj5YWi6I0QuL/176gaf
         EdbLax/3eV5/d8Zn0SX1lAXhoOU6Zk8sG0japOCqdziruvExMMNMxbFITk95MHDh1oRc
         AL76cX30z1tBXxVy+t3e7x1ii5NoNe5AqigHU46Ocwx0kh+gp9eQJryUvm+xjW8JkSy/
         c47mIpAzfL9pzTNSolhs8SNbEgh5xptEz5JWrJRBiHT6nqcepttYOKRWj5tfDykbU2rJ
         PgUzal1Fx1i4q4hWVBXUBqeO84w/V2z2leCXXl15g0b3POO5rE9RfMh2wJjp+En1VF7G
         uxGA==
X-Gm-Message-State: AGi0PubwpjieEk5g06pj5gpU6ZRKiAws/o0ZHOsCKEf1+ukdjxfO1iui
        9l2rcF1CWPB1oJrwth9CvzD8fASDIna4qLmHnO9+yrkvMI1b
X-Google-Smtp-Source: APiQypKE0T7vpFvxOcOZvzhUT6OjWfzmqF/bePj9rviDb2ldU3gKgTG6RE46xsPctletAp6kcGWYAiCQogSANoSlVc30WUqilVoK
MIME-Version: 1.0
X-Received: by 2002:a5d:8347:: with SMTP id q7mr10163952ior.172.1586641092063;
 Sat, 11 Apr 2020 14:38:12 -0700 (PDT)
Date:   Sat, 11 Apr 2020 14:38:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000adb83a05a30aaa04@google.com>
Subject: WARNING: bad unlock balance in mptcp_shutdown
From:   syzbot <syzbot+6ebb6d4830e8f8815623@syzkaller.appspotmail.com>
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

HEAD commit:    f5e94d10 Merge tag 'drm-next-2020-04-08' of git://anongit...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a5dbfbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca75979eeebf06c2
dashboard link: https://syzkaller.appspot.com/bug?extid=6ebb6d4830e8f8815623
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6ebb6d4830e8f8815623@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
5.6.0-syzkaller #0 Not tainted
-------------------------------------
syz-executor.5/2215 is trying to release lock (sk_lock-AF_INET6) at:
[<ffffffff87c5203b>] mptcp_shutdown+0x38b/0x550 net/mptcp/protocol.c:1889
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor.5/2215:
 #0: ffff88804a22eda0 (slock-AF_INET6){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #0: ffff88804a22eda0 (slock-AF_INET6){+.-.}-{2:2}, at: release_sock+0x1b/0x1b0 net/core/sock.c:2974

stack backtrace:
CPU: 0 PID: 2215 Comm: syz-executor.5 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __lock_release kernel/locking/lockdep.c:4633 [inline]
 lock_release+0x586/0x800 kernel/locking/lockdep.c:4941
 sock_release_ownership include/net/sock.h:1539 [inline]
 release_sock+0x177/0x1b0 net/core/sock.c:2984
 mptcp_shutdown+0x38b/0x550 net/mptcp/protocol.c:1889
 __sys_shutdown+0xf3/0x1a0 net/socket.c:2208
 __do_sys_shutdown net/socket.c:2216 [inline]
 __se_sys_shutdown net/socket.c:2214 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2214
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa67df32c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: ffffffffffffffda RBX: 00007fa67df336d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000076bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000b5e R14: 00000000004cd960 R15: 000000000076bfac


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
