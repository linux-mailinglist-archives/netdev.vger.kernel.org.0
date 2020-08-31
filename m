Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57925258209
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgHaTsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:48:16 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:39610 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgHaTsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:48:14 -0400
Received: by mail-il1-f198.google.com with SMTP id o1so5960197ilk.6
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cK+cTlHrBH0I8dtFbbTlN1a0PMAtRS8/eA1z+aa58yA=;
        b=Ofs/9wEabgWuNBxaNt1TN7XYFHtZZHdYX3Sq6DpbHKZwSjnZnCebXehc5qyQBahn5E
         Pl986KNdTYM/3cfZVgt05Yuy5uFGEivI9cbJa5TuVIZipWL75wOkrWgarepzSuP/5WEw
         MK10rCF2Vxbo1yDzQQp0TOGj+Q0zRUfP6OX9lpSFvw1u29DTbKt81uVqY3gpe2OyaBvw
         mrJx7P5y10uHgLQxNCv56gz/5O/pCIvrbLTmnLr6Cx32hViCD3lYNZpPyRNbvNXsuT2U
         SVIOb6iv1qJTnFUTJe9xNwygXXR3bEBOuzhkFJm1JBhzV6FxzinDhCLbrQqj55+mUEWg
         qaiA==
X-Gm-Message-State: AOAM531j0LX88Z3yYA9vepXtv7QwH95nj1+pmpVnZxCMGMabVd7BMHio
        tr3hE+Msl5KMM/iETPmm0UnIgOhPHDd8Q599viYtOthglUDn
X-Google-Smtp-Source: ABdhPJxsRKfEFgHCrDNCyrUbVf348EO4W3juNVBYdrE4wLSpbYKHk4dges1Kr5WL+zj+suSdPTbaWeY9UumBHULiDtvlNB3TrhHL
MIME-Version: 1.0
X-Received: by 2002:a92:d4cf:: with SMTP id o15mr2870758ilm.25.1598903293869;
 Mon, 31 Aug 2020 12:48:13 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:48:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dc862405ae31ae9b@google.com>
Subject: general protection fault in sock_close
From:   syzbot <syzbot+e24baf53dc389927a7c3@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=16a85669900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=891ca5711a9f1650
dashboard link: https://syzkaller.appspot.com/bug?extid=e24baf53dc389927a7c3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127d3c99900000

The issue was bisected to:

commit a9ed4a6560b8562b7e2e2bed9527e88001f7b682
Author: Marc Zyngier <maz@kernel.org>
Date:   Wed Aug 19 16:12:17 2020 +0000

    epoll: Keep a reference on files added to the check list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1374d7c5900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10f4d7c5900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1774d7c5900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e24baf53dc389927a7c3@syzkaller.appspotmail.com
Fixes: a9ed4a6560b8 ("epoll: Keep a reference on files added to the check list")

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 10933 Comm: syz-executor.0 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__sock_release net/socket.c:596 [inline]
RIP: 0010:sock_close+0xc5/0x260 net/socket.c:1277
Code: fc ff df 41 80 3c 04 00 74 08 4c 89 ff e8 e3 cf 49 fb 49 8b 1f 48 83 c3 10 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 bd cf 49 fb 4c 89 f7 ff 13 49 8d 5e
RSP: 0018:ffffc9000535fe10 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffffffff88bbc748 R08: dffffc0000000000 R09: ffffed1010361edf
R10: ffffed1010361edf R11: 0000000000000000 R12: 1ffff11010361eac
R13: ffff888081b0f6e0 R14: ffff888081b0f540 R15: ffff888081b0f560
FS:  00007fad45047700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fad45025db8 CR3: 0000000084c1d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __fput+0x34f/0x7b0 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
 exit_to_user_mode_prepare+0xfa/0x1b0 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fad45046c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e9
RAX: 0000000000000000 RBX: 0000000000002ac0 RCX: 000000000045d5b9
RDX: 0000000000000004 RSI: 0000000000000001 RDI: 0000000000000005
RBP: 000000000118cf88 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000200003c0 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffd8c03abcf R14: 00007fad450479c0 R15: 000000000118cf4c
Modules linked in:
---[ end trace a8eab99154db8026 ]---
RIP: 0010:__sock_release net/socket.c:596 [inline]
RIP: 0010:sock_close+0xc5/0x260 net/socket.c:1277
Code: fc ff df 41 80 3c 04 00 74 08 4c 89 ff e8 e3 cf 49 fb 49 8b 1f 48 83 c3 10 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 bd cf 49 fb 4c 89 f7 ff 13 49 8d 5e
RSP: 0018:ffffc9000535fe10 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffffffff88bbc748 R08: dffffc0000000000 R09: ffffed1010361edf
R10: ffffed1010361edf R11: 0000000000000000 R12: 1ffff11010361eac
R13: ffff888081b0f6e0 R14: ffff888081b0f540 R15: ffff888081b0f560
FS:  00007fad45047700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6e37205010 CR3: 0000000084c1d000 CR4: 00000000001506e0
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
