Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A980D2581E3
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgHaTiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:38:23 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:44359 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgHaTiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:38:19 -0400
Received: by mail-il1-f199.google.com with SMTP id j11so1915447ilr.11
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=m4SliDazaCKI2mSnRd41TiQtA9peqJpo0sHHFYg5U3k=;
        b=S2Lr8UJfdvuT/Re2juNBFTGApLwYaGqL8OhTQBwX0VRkfAEsVolS9lf/ZW92T/fdCu
         DqZvj4XmvSMcnrMVfIbEnN9DzzpGn7jt27FhP38gZw90SZpB9/X30F/PHcMamEMYtUEo
         dXqkO5MFlsOMoD/CxgD5fhG+5Hw04CD/HXgRkhP29FgGrl6NVjEfIgu/3Oe0hK/eImhQ
         3m6dTEtNXeOeVehtGPM1/yEXsMltu+aRxJbx91NdzQ91rI80uweH8W2BR8BrKAkVx+PV
         u8EhNZT49QVQLY+WQTS7mHH9VOx2dXfkmET0b8VBqs8mq1GdA5awGokQ2Ox91da2SEa9
         adGA==
X-Gm-Message-State: AOAM530vAo7cSzKSUk8iRja0RaGbg6uvNwFZfqiTEq3zlfiPZsC2qGLC
        Wams/5odj9O4QoUXV+RHh/PH6SibZyU7xTsu3/qw24XRE8Mm
X-Google-Smtp-Source: ABdhPJxhZWN8RKGXRXOxycv8ae9XQ+1mKP0JphK94FqsUNlpDSQ5nXyVjLiDOtpxbct+Pn+RsBadYwJZixnZTB6uTNss9SMD1eDb
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2013:: with SMTP id y19mr2567630iod.148.1598902698653;
 Mon, 31 Aug 2020 12:38:18 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:38:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006240f605ae318b1c@google.com>
Subject: general protection fault in __sock_release (3)
From:   syzbot <syzbot+0cd67947050ba830202c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        maz@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    15bc20c6 Merge tag 'tty-5.9-rc3' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b2cdd5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
dashboard link: https://syzkaller.appspot.com/bug?extid=0cd67947050ba830202c
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bd47e5900000

The issue was bisected to:

commit a9ed4a6560b8562b7e2e2bed9527e88001f7b682
Author: Marc Zyngier <maz@kernel.org>
Date:   Wed Aug 19 16:12:17 2020 +0000

    epoll: Keep a reference on files added to the check list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b440d1900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=107440d1900000
console output: https://syzkaller.appspot.com/x/log.txt?x=17b440d1900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0cd67947050ba830202c@syzkaller.appspotmail.com
Fixes: a9ed4a6560b8 ("epoll: Keep a reference on files added to the check list")

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 11412 Comm: syz-executor.0 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__sock_release+0xbb/0x280 net/socket.c:596
Code: ff df 48 c1 ea 03 80 3c 02 00 0f 85 a5 01 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 63 20 49 8d 7c 24 10 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 8e 01 00 00 48 89 df 41 ff 54 24 10 48 8d 7b 18
RSP: 0018:ffffc9000865fe28 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880859f7a80 RCX: 1ffff920010cbf67
RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000010
RBP: ffff8880859f7c20 R08: ffff8880859f7c20 R09: ffff8880859f7c33
R10: ffffed1010b3ef86 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880859f7aa0 R14: 0000000000000000 R15: ffff888089fe9818
FS:  000000000323b940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3d38ba1db8 CR3: 00000000a92fc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416f01
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffdc1b3fe40 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000416f01
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000001190358 R09: 0000000000000000
R10: 00007ffdc1b3ff20 R11: 0000000000000293 R12: 0000000001190360
R13: 0000000000000000 R14: ffffffffffffffff R15: 000000000118cf4c
Modules linked in:
---[ end trace 99238214bf463a8c ]---
RIP: 0010:__sock_release+0xbb/0x280 net/socket.c:596
Code: ff df 48 c1 ea 03 80 3c 02 00 0f 85 a5 01 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 63 20 49 8d 7c 24 10 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 8e 01 00 00 48 89 df 41 ff 54 24 10 48 8d 7b 18
RSP: 0018:ffffc9000865fe28 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880859f7a80 RCX: 1ffff920010cbf67
RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000010
RBP: ffff8880859f7c20 R08: ffff8880859f7c20 R09: ffff8880859f7c33
R10: ffffed1010b3ef86 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880859f7aa0 R14: 0000000000000000 R15: ffff888089fe9818
FS:  000000000323b940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3d38ba1db8 CR3: 00000000a92fc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
