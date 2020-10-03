Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5922822D8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgJCJEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:04:16 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:35651 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCJEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:04:16 -0400
Received: by mail-il1-f206.google.com with SMTP id f10so3054197ilq.2
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 02:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Pdh2OQI0GV4T/rFY4m1WLv9vo8jU4IolNrdujND4j1M=;
        b=Wke3CktKCR8Fj1E2Y25r8GKV0ICcyj0oDnZpeey00Q6PIbR7oe/7Qf5ZmIkZYN8SxR
         BX78C30Ppjp6lAQCMCluOhbj5JI1UrrcBg7+bjxX8ylKSL023wFV0TQbE+SfsI0VLZxO
         xc7R5Op25Xv2Az+P/YEBukfpzCg320zjDEiq4TnP6Ewb5+nUnrp34c1D2ZMbPssyEQ1p
         kzBvsg77fnr3jYVley0blzybYIdQA58WemN/s3bAFuojuxOfGtTxicbJwtLU3tNfRZlp
         jgg1kQq+D43sIa5F7X3UxnL6+Yqb9/j4/hMhxZvuJbhSUGIW2WISZj4dgJ6OjWRxjkJG
         8E5Q==
X-Gm-Message-State: AOAM531ecwWLXnCtES2yKKntCfDTM+LpZT9xWDRN5WO8b5QofHfi1/iw
        BeFeT6BUjt84169CMqQr1W8fUwVDIT3/pE8yegADsKblhZXG
X-Google-Smtp-Source: ABdhPJxHM8i64jh0/L4j/WPJNg7f4Q1jCmcPbGIDMQxeZCrqOmDh1S6AoI6ohpz5y4zUeB22PDq9uv2rLIacJp8uODpPtDZFQ70u
MIME-Version: 1.0
X-Received: by 2002:a02:712c:: with SMTP id n44mr5831606jac.37.1601715854776;
 Sat, 03 Oct 2020 02:04:14 -0700 (PDT)
Date:   Sat, 03 Oct 2020 02:04:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008e1e2205b0c08851@google.com>
Subject: BUG: corrupted list in rxrpc_put_call
From:   syzbot <syzbot+e6326c848f3404ffb673@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fcadab74 Merge tag 'drm-fixes-2020-10-01-1' of git://anong..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143340a3900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=e6326c848f3404ffb673
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6326c848f3404ffb673@syzkaller.appspotmail.com

tipc: TX() has been purged, node left!
list_del corruption. next->prev should be ffff888000102c38, but was f000ff53f000e2c3
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:54!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 32547 Comm: kworker/u4:4 Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__list_del_entry_valid.cold+0x48/0x55 lib/list_debug.c:54
Code: e8 51 9b 9b fd 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 00 b4 d8 88 e8 3d 9b 9b fd 0f 0b 48 89 ee 48 c7 c7 c0 b4 d8 88 e8 2c 9b 9b fd <0f> 0b cc cc cc cc cc cc cc cc cc cc cc 41 57 41 56 41 55 41 54 55
RSP: 0018:ffffc900190ffa20 EFLAGS: 00010286
RAX: 0000000000000054 RBX: ffff888000102c38 RCX: 0000000000000000
RDX: ffff888097a50280 RSI: ffffffff815f59d5 RDI: fffff5200321ff36
RBP: ffff888000102c38 R08: 0000000000000054 R09: ffff8880ae4318e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88804e898010
R13: ffff888000000000 R14: ffff888000102c40 R15: 00000000000002b2
FS:  0000000000000000(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000334ea98 CR3: 000000009e10c000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_init include/linux/list.h:204 [inline]
 rxrpc_put_call+0x17d/0x300 net/rxrpc/call_object.c:567
 rxrpc_discard_prealloc+0x7e2/0xb30 net/rxrpc/call_accept.c:242
 rxrpc_listen+0x11c/0x330 net/rxrpc/af_rxrpc.c:245
 afs_close_socket+0x95/0x320 fs/afs/rxrpc.c:110
 afs_net_exit+0x1c4/0x310 fs/afs/main.c:158
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace e8b698dc6d68e2dc ]---
RIP: 0010:__list_del_entry_valid.cold+0x48/0x55 lib/list_debug.c:54
Code: e8 51 9b 9b fd 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 00 b4 d8 88 e8 3d 9b 9b fd 0f 0b 48 89 ee 48 c7 c7 c0 b4 d8 88 e8 2c 9b 9b fd <0f> 0b cc cc cc cc cc cc cc cc cc cc cc 41 57 41 56 41 55 41 54 55
RSP: 0018:ffffc900190ffa20 EFLAGS: 00010286
RAX: 0000000000000054 RBX: ffff888000102c38 RCX: 0000000000000000
RDX: ffff888097a50280 RSI: ffffffff815f59d5 RDI: fffff5200321ff36
RBP: ffff888000102c38 R08: 0000000000000054 R09: ffff8880ae4318e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88804e898010
R13: ffff888000000000 R14: ffff888000102c40 R15: 00000000000002b2
FS:  0000000000000000(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000334ea98 CR3: 000000009e10c000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
