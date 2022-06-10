Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C069E546837
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345695AbiFJOXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349337AbiFJOXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:23:31 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA09170F0A
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 07:23:21 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id a2-20020a923302000000b002d1ad5053feso19697404ilf.17
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 07:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XjrtYqNiT5vEa6+Vuf9aZLxSiV1HsY2+vhx3VyfeILM=;
        b=SPZLYvwv9LbYnihT8DC3vbnnkoihozfpTZnzWrWZ3/fH+KYHXvYthiWr1wecORSmXd
         7Yvo8r2wUFZvIXmD1p2JvSR/pvLt7/XGeUJj+47h9hZVxsTOOae7ZtTIRfCwxvJTg23k
         3rdlg1yANtLf2Tq6OSe0Ny1qLtSM5etjLpIJZmK2JQ+X7kyD4EFZqhKk36SQE1mzDhrD
         lOAsFi6qhLJLFe5MdFOHPgsIxr/zi4HvNjzSs2BIa2r1qY8sjxbGfAsyr29CknRHpFsD
         Y+0wUxegUjAIoANhmRdcJ7ITyAouDDMB7VbLwcK8+kagFAyGJqqJi/MDfK6xj/NbLyyS
         +aXw==
X-Gm-Message-State: AOAM532/v38RCanKAMki2Vsw071L69g3+XfzVPW1AfGrTafTuIwL+xVQ
        PCI1mjXL2CG2kEc/G3ykdbZ2qnVAkg0PUi9bdtVLqbD4lUhk
X-Google-Smtp-Source: ABdhPJxdU7ph+1O6uNJ43i/VXnOf3VJRWymxSsZwPNYAarUi5cziesFNY651vf+6wPlOBYjUuUfeeiPPjH2vVsVR8oHmyxQcKU96
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ce:b0:2d3:de67:9f96 with SMTP id
 i14-20020a056e0212ce00b002d3de679f96mr26904551ilm.261.1654871001228; Fri, 10
 Jun 2022 07:23:21 -0700 (PDT)
Date:   Fri, 10 Jun 2022 07:23:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d6bc305e118ae24@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in sk_psock_stop
From:   syzbot <syzbot+140186ceba0c496183bc@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, wangyufen@huawei.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ff539ac73ea5 Add linux-next specific files for 20220609
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=176c121bf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5002042f00a8bce
dashboard link: https://syzkaller.appspot.com/bug?extid=140186ceba0c496183bc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13083353f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173e67f0080000

The issue was bisected to:

commit d8616ee2affcff37c5d315310da557a694a3303d
Author: Wang Yufen <wangyufen@huawei.com>
Date:   Tue May 24 07:53:11 2022 +0000

    bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1556d7cff00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1756d7cff00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1356d7cff00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+140186ceba0c496183bc@syzkaller.appspotmail.com
Fixes: d8616ee2affc ("bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues")

BUG: sleeping function called from invalid context at kernel/workqueue.c:3010
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3612, name: syz-executor475
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
3 locks held by syz-executor475/3612:
 #0: ffff888072eb9410 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:740 [inline]
 #0: ffff888072eb9410 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
 #1: ffff888027259ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1691 [inline]
 #1: ffff888027259ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tcp_close+0x1e/0xc0 net/ipv4/tcp.c:2908
 #2: ffff888027259a30 (slock-AF_INET6){+...}-{2:2}, at: spin_lock include/linux/spinlock.h:360 [inline]
 #2: ffff888027259a30 (slock-AF_INET6){+...}-{2:2}, at: __tcp_close+0x722/0x12b0 net/ipv4/tcp.c:2830
Preemption disabled at:
[<ffffffff87ddddca>] local_bh_disable include/linux/bottom_half.h:20 [inline]
[<ffffffff87ddddca>] __tcp_close+0x71a/0x12b0 net/ipv4/tcp.c:2829
CPU: 1 PID: 3612 Comm: syz-executor475 Not tainted 5.19.0-rc1-next-20220609-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9823
 start_flush_work kernel/workqueue.c:3010 [inline]
 __flush_work+0x109/0xb10 kernel/workqueue.c:3074
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 sk_psock_stop+0x4cb/0x630 net/core/skmsg.c:802
 sock_map_destroy+0x333/0x760 net/core/sock_map.c:1581
 inet_csk_destroy_sock+0x196/0x440 net/ipv4/inet_connection_sock.c:1130
 __tcp_close+0xd5b/0x12b0 net/ipv4/tcp.c:2897
 tcp_close+0x29/0xc0 net/ipv4/tcp.c:2909
 sock_map_close+0x3b9/0x780 net/core/sock_map.c:1607
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:481
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 ptrace_notify+0x114/0x140 kernel/signal.c:2353
 ptrace_report_syscall include/linux/ptrace.h:420 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
 syscall_exit_work kernel/entry/common.c:249 [inline]
 syscall_exit_to_user_mode_prepare+0xdb/0x230 kernel/entry/common.c:276
 __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
 syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe7b3b8b6a3
Code: c7 c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb ba 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
RSP: 002b:00007ffce5903258 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 00007fe7b3b8b6a3
RDX: 0000000000000020 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00007fe7b3c36e40 R09: 00007fe7b3c36e40
R10: 00007fe7b3c36e40 R11: 0000000000000246 R12: 00007ffce5903290
R13: 00007ffce5903280 R14: 00007ffce5903270 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
