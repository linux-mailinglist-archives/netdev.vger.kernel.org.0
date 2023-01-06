Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664366050A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjAFQq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbjAFQnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:23 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C30E7CBEC
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:42:48 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id h24-20020a056e021d9800b0030be8a5dd68so1380942ila.13
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 08:42:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvnTtvXpGJN5zZbFh3jZtwrLP0BDJJ/TidQgOyTSPxA=;
        b=vEPPbWnmitYQIiexzwuM8sqhWQYNFSYJcD40zoINK+k4E1aM5BZiVio5PC3ENFDtQW
         zTnPUy37zWjGZSJIMhv13Q+OhtvxgNS2D2junn85FFuu4u3L06lWfh7tl5lMfsOnb3Xs
         5Rdmf+CZ/YuDgj71w8raY+52PK5wxntt+hJe/UDif34+swAR8TZ5qD33aSxg0zk0LSHJ
         7/6dFbrhy3xhsNSXJYwjgtPvBrN7pJE2iLeqmfkVt9IMuK2Uv17D1aI8YWMpVE7zO4NF
         X45HY7U2cKi26297LbomLyx/+O7kGaOYJyjECC8OrVjNW/Cdr+bXc7TI+k9y+PZ3QfxU
         U8Dw==
X-Gm-Message-State: AFqh2kpIkzdM5KfyBLWGCSc/DW8JgY8hvsGzknaYcb/xkH1nLMyhukEz
        rsnzir7GeK7GBmU6/vXPDV8QqdqH/oXORpc87g51wqKwyQ8A
X-Google-Smtp-Source: AMrXdXtbTKZx0xaVhZo+Va8nivpRcsV2rCU+B2IiJH+92spgN0obN1JiHO+iWTLSxyj7OH8uHEIvzW0jro+oWY+LVyoe6KCP+9rs
MIME-Version: 1.0
X-Received: by 2002:a5e:a915:0:b0:6fa:3c6a:ec69 with SMTP id
 c21-20020a5ea915000000b006fa3c6aec69mr2079121iod.66.1673023367467; Fri, 06
 Jan 2023 08:42:47 -0800 (PST)
Date:   Fri, 06 Jan 2023 08:42:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084e89f05f19b1b2c@google.com>
Subject: [syzbot] possible deadlock in rds_message_purge
From:   syzbot <syzbot+2286d16a0b79933453e5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a5541c0811a0 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15a11934480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd4e584773e9397
dashboard link: https://syzkaller.appspot.com/bug?extid=2286d16a0b79933453e5
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fe2f2a480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10badc54480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4b7702208fb9/disk-a5541c08.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9ec0153ec051/vmlinux-a5541c08.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6f8725ad290a/Image-a5541c08.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2286d16a0b79933453e5@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0 Not tainted
------------------------------------------------------
syz-executor742/13012 is trying to acquire lock:
ffff0000c7f2a100 (&rm->m_rs_lock){..-.}-{2:2}, at: rds_message_purge+0x4c/0x5c4 net/rds/message.c:138

but task is already holding lock:
ffff0000cc450d70 (&rs->rs_recv_lock){...-}-{2:2}, at: rds_clear_recv_queue+0x34/0x1a4 net/rds/recv.c:761

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&rs->rs_recv_lock){...-}-{2:2}:
       __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:160 [inline]
       _raw_read_lock_irqsave+0x7c/0xc4 kernel/locking/spinlock.c:236
       rds_wake_sk_sleep+0x28/0x88 net/rds/af_rds.c:109
       rds_send_remove_from_sock+0xcc/0x564 net/rds/send.c:634
       rds_send_path_drop_acked+0x1ac/0x1e8 net/rds/send.c:710
       rds_tcp_write_space+0xcc/0x2f0 net/rds/tcp_send.c:198
       tcp_new_space net/ipv4/tcp_input.c:5471 [inline]
       tcp_check_space+0x178/0x1c0 net/ipv4/tcp_input.c:5490
       tcp_data_snd_check net/ipv4/tcp_input.c:5499 [inline]
       tcp_rcv_established+0x6e4/0xa64 net/ipv4/tcp_input.c:6007
       tcp_v4_do_rcv+0x4b8/0x51c net/ipv4/tcp_ipv4.c:1670
       sk_backlog_rcv include/net/sock.h:1109 [inline]
       __release_sock+0xe4/0x1d0 net/core/sock.c:2906
       release_sock+0x40/0x108 net/core/sock.c:3462
       tcp_sock_set_cork+0xb4/0xc8 net/ipv4/tcp.c:3340
       rds_tcp_xmit_path_complete+0x2c/0x3c net/rds/tcp_send.c:52
       rds_send_xmit+0xa40/0xfcc net/rds/send.c:422
       rds_sendmsg+0xd20/0xf28 net/rds/send.c:1382
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       __sys_sendto+0x1e4/0x280 net/socket.c:2117
       __do_sys_sendto net/socket.c:2129 [inline]
       __se_sys_sendto net/socket.c:2125 [inline]
       __arm64_sys_sendto+0x30/0x44 net/socket.c:2125
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x140 arch/arm64/kernel/syscall.c:197
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584

-> #0 (&rm->m_rs_lock){..-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x1530/0x3084 kernel/locking/lockdep.c:5055
       lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x6c/0xb4 kernel/locking/spinlock.c:162
       rds_message_purge+0x4c/0x5c4 net/rds/message.c:138
       rds_message_put+0x88/0x120 net/rds/message.c:180
       rds_loop_inc_free+0x20/0x30 net/rds/loop.c:115
       rds_inc_put net/rds/recv.c:82 [inline]
       rds_clear_recv_queue+0xf0/0x1a4 net/rds/recv.c:767
       rds_release+0x54/0x19c net/rds/af_rds.c:73
       __sock_release net/socket.c:650 [inline]
       sock_close+0x50/0xf0 net/socket.c:1365
       __fput+0x198/0x3e4 fs/file_table.c:320
       ____fput+0x20/0x30 fs/file_table.c:348
       task_work_run+0x100/0x148 kernel/task_work.c:179
       resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
       do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1132
       prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
       exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
       el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:638
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rs->rs_recv_lock);
                               lock(&rm->m_rs_lock);
                               lock(&rs->rs_recv_lock);
  lock(&rm->m_rs_lock);

 *** DEADLOCK ***

2 locks held by syz-executor742/13012:
 #0: ffff0000ce4baa50 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
 #0: ffff0000ce4baa50 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release net/socket.c:649 [inline]
 #0: ffff0000ce4baa50 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: sock_close+0x40/0xf0 net/socket.c:1365
 #1: ffff0000cc450d70 (&rs->rs_recv_lock){...-}-{2:2}, at: rds_clear_recv_queue+0x34/0x1a4 net/rds/recv.c:761

stack backtrace:
CPU: 0 PID: 13012 Comm: syz-executor742 Not tainted 6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 print_circular_bug+0x2c4/0x2c8 kernel/locking/lockdep.c:2055
 check_noncircular+0x14c/0x154 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x1530/0x3084 kernel/locking/lockdep.c:5055
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x6c/0xb4 kernel/locking/spinlock.c:162
 rds_message_purge+0x4c/0x5c4 net/rds/message.c:138
 rds_message_put+0x88/0x120 net/rds/message.c:180
 rds_loop_inc_free+0x20/0x30 net/rds/loop.c:115
 rds_inc_put net/rds/recv.c:82 [inline]
 rds_clear_recv_queue+0xf0/0x1a4 net/rds/recv.c:767
 rds_release+0x54/0x19c net/rds/af_rds.c:73
 __sock_release net/socket.c:650 [inline]
 sock_close+0x50/0xf0 net/socket.c:1365
 __fput+0x198/0x3e4 fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:348
 task_work_run+0x100/0x148 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1132
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
