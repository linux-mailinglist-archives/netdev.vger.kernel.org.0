Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1638A245029
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 01:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgHNXaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 19:30:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:46387 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgHNXaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 19:30:17 -0400
Received: by mail-il1-f199.google.com with SMTP id q19so7557660ilt.13
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 16:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SA9X8J8qG/6k9RqPtMDue8VLhzxw1Kg1UAqeNkKdQ3s=;
        b=sEXy1j7MlMRIqS0Nqru5h6k+JHlFUvwj2Tc2UKAgQFzyAc8rhcvXVPUSA9z327aict
         gH46Eq/Jc3jINQlD4/Q0qifsW6g8mChbm0InTzhbzOSVm/ahRwi8GxQUDmmahOUeMmed
         iYySRjbRHXvGHcHnoT49mrDIx9jV6zz3zzjAYNPbdU6CFGVqJOD6X5PzQdVSZoz88V8f
         Lhqarc1U7imbhY2eXGor6pWJvcolgzJj9Dkr/eFTgpqWPB31TxQBiMRXk9b8Z/011IdV
         My6qnBM/gmOuN9lXCsHQd/h78fBH3/6XJOi9dChY0yF8SATJQgMu9d7I+/BEt/YDRsuo
         FVGQ==
X-Gm-Message-State: AOAM530O89P/GBT+i8YrshT1iJwQIvBciFgBJOkDXtyJHpUaM2NKGhC9
        ifJqnF0+etQgSm3tXN7wDVs1tkEHdtBZR6sXAw62XDDijxb2
X-Google-Smtp-Source: ABdhPJz9eIGB6Ws8UTY+Q8ajVoXMDaX5s1VQsNBPUQJEiSzcKKaE0ZdxmHaR4hN3v/pddtH2CEq7UIzi+idpeuj2wETkzX+vzNXh
MIME-Version: 1.0
X-Received: by 2002:a02:3f0d:: with SMTP id d13mr4625141jaa.99.1597447816184;
 Fri, 14 Aug 2020 16:30:16 -0700 (PDT)
Date:   Fri, 14 Aug 2020 16:30:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a18a8305acdecd3e@google.com>
Subject: BUG: corrupted list in bt_accept_unlink
From:   syzbot <syzbot+7f4d3ecf4d3480301722@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a1d21081 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c77891900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c89856ae5fc8b6
dashboard link: https://syzkaller.appspot.com/bug?extid=7f4d3ecf4d3480301722
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1180847a900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f4d3ecf4d3480301722@syzkaller.appspotmail.com

list_del corruption. prev->next should be ffff8880913ab4b8, but was ffff8880890c54b8
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:51!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__list_del_entry_valid.cold+0xf/0x55 lib/list_debug.c:51
Code: e8 5a ab bf fd 0f 0b 48 89 f1 48 c7 c7 40 ff 93 88 4c 89 e6 e8 46 ab bf fd 0f 0b 48 89 ee 48 c7 c7 e0 00 94 88 e8 35 ab bf fd <0f> 0b 4c 89 ea 48 89 ee 48 c7 c7 20 00 94 88 e8 21 ab bf fd 0f 0b
RSP: 0018:ffffc90000d8fb18 EFLAGS: 00010282
RAX: 0000000000000054 RBX: ffff8880913ab4b8 RCX: 0000000000000000
RDX: ffff8880a968a480 RSI: ffffffff815dbc57 RDI: fffff520001b1f55
RBP: ffff8880913ab4b8 R08: 0000000000000054 R09: ffff8880ae7318e7
R10: 0000000000000000 R11: 00000000000c3a18 R12: ffff8880890c54b8
R13: ffff88809914f4b8 R14: ffff88809914f000 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000081570f0 CR3: 00000000a6dc2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_init include/linux/list.h:204 [inline]
 bt_accept_unlink+0x26/0x280 net/bluetooth/af_bluetooth.c:187
 l2cap_sock_teardown_cb+0x197/0x400 net/bluetooth/l2cap_sock.c:1544
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace ea2f8b77c156d63d ]---
RIP: 0010:__list_del_entry_valid.cold+0xf/0x55 lib/list_debug.c:51
Code: e8 5a ab bf fd 0f 0b 48 89 f1 48 c7 c7 40 ff 93 88 4c 89 e6 e8 46 ab bf fd 0f 0b 48 89 ee 48 c7 c7 e0 00 94 88 e8 35 ab bf fd <0f> 0b 4c 89 ea 48 89 ee 48 c7 c7 20 00 94 88 e8 21 ab bf fd 0f 0b
RSP: 0018:ffffc90000d8fb18 EFLAGS: 00010282
RAX: 0000000000000054 RBX: ffff8880913ab4b8 RCX: 0000000000000000
RDX: ffff8880a968a480 RSI: ffffffff815dbc57 RDI: fffff520001b1f55
RBP: ffff8880913ab4b8 R08: 0000000000000054 R09: ffff8880ae7318e7
R10: 0000000000000000 R11: 00000000000c3a18 R12: ffff8880890c54b8
R13: ffff88809914f4b8 R14: ffff88809914f000 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000080f0b38 CR3: 0000000009a8d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
