Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F8B5F99ED
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiJJH04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiJJH0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:26:30 -0400
Received: from mail-il1-x148.google.com (mail-il1-x148.google.com [IPv6:2607:f8b0:4864:20::148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8843331EE0
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 00:20:54 -0700 (PDT)
Received: by mail-il1-x148.google.com with SMTP id i8-20020a056e0212c800b002f9a4c75658so8217487ilm.3
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 00:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4y88EBd/vb8yCVMWvZjcrFkdCPY7+pJqcZy7NSMsxM=;
        b=5uZFIWa5ZSzWJxH/1E7l2HVHvJOaLM6YcYbZ+Jw9UxwOhl+3MbEt85eBqKCrrLzv8P
         TCU6MIc1NlBFZpXH/009k9VSjLSxUILp83dyaNKMLiR0eWIcqhqMHum66+IYtSrRpRD2
         ysGZlXDqyFPUjSsW2mphPagxslXo/UqSBsbMtBg6U/rWP/ed/M9wfWh+CF4Y7vIIIyxx
         6aN6N9cHLv3fY2I2jXyzjJE2XxNDVt+hIO4gYPHwyy+yBl0oiGPZDzmjS2/qac+JY6In
         JmsWf97eSBpyNlfbaIEB1c1F+glkVR1ybEUg+fbONZqXO28DfAmIXTt/AtJNDoFI0IeI
         f8bA==
X-Gm-Message-State: ACrzQf3zKywVmgI29qp4s6WxfRD09QWJpcMptcGMraS1zRE5+GtrlPRu
        X376va3uMdfTzl7jxup2fhnZrLFDvQubrEhh3PbK/1l1e/JK
X-Google-Smtp-Source: AMsMyM7JOI3f+i2seYtu1aj5A8mpcpBQHsPGt4XiIQVb8yYLpB93xI6kd2YA0zv3NxaVXycPD3QNfNfl+zG+NuZC7VYpaqK5y+gP
MIME-Version: 1.0
X-Received: by 2002:a5e:c902:0:b0:6bc:22b7:200a with SMTP id
 z2-20020a5ec902000000b006bc22b7200amr2024601iol.126.1665386324995; Mon, 10
 Oct 2022 00:18:44 -0700 (PDT)
Date:   Mon, 10 Oct 2022 00:18:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000050b5f305eaa8f82d@google.com>
Subject: [syzbot] possible deadlock in hci_conn_hash_flush
From:   syzbot <syzbot+76a9cc07a77bc3e48ef7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1247bf82880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a4a45d2d827c1e
dashboard link: https://syzkaller.appspot.com/bug?extid=76a9cc07a77bc3e48ef7
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e91bc79312/disk-bbed346d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1cb3fb3b77e/vmlinux-bbed346d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+76a9cc07a77bc3e48ef7@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0 Not tainted
------------------------------------------------------
syz-executor.1/24281 is trying to acquire lock:
ffff000130804770 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: __flush_work+0x74/0x144 kernel/workqueue.c:3069

but task is already holding lock:
ffff80000d832b98 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1776 [inline]
ffff80000d832b98 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0x64/0x148 net/bluetooth/hci_conn.c:2366

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (hci_cb_list_lock){+.+.}-{3:3}:
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       hci_connect_cfm include/net/bluetooth/hci_core.h:1761 [inline]
       hci_remote_features_evt+0x274/0x50c net/bluetooth/hci_event.c:3757
       hci_event_func net/bluetooth/hci_event.c:7443 [inline]
       hci_event_packet+0x5c4/0x60c net/bluetooth/hci_event.c:7495
       hci_rx_work+0x1a4/0x2f4 net/bluetooth/hci_core.c:4007
       process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
       worker_thread+0x340/0x610 kernel/workqueue.c:2436
       kthread+0x12c/0x158 kernel/kthread.c:376
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

-> #2 (&hdev->lock){+.+.}-{3:3}:
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       sco_sock_connect+0x104/0x220 net/bluetooth/sco.c:593
       __sys_connect_file+0xc8/0xd0 net/socket.c:1976
       io_connect+0xc8/0x21c io_uring/net.c:1277
       io_issue_sqe+0x1c0/0x508 io_uring/io_uring.c:1577
       io_queue_sqe io_uring/io_uring.c:1755 [inline]
       io_submit_sqe io_uring/io_uring.c:2013 [inline]
       io_submit_sqes+0x18c/0x454 io_uring/io_uring.c:2124
       __do_sys_io_uring_enter+0x16c/0x8b8 io_uring/io_uring.c:3057
       __se_sys_io_uring_enter io_uring/io_uring.c:2987 [inline]
       __arm64_sys_io_uring_enter+0x30/0x40 io_uring/io_uring.c:2987
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
       el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581

-> #1 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}:
       lock_sock_nested+0x70/0xd8 net/core/sock.c:3393
       lock_sock include/net/sock.h:1712 [inline]
       sco_sock_timeout+0x88/0x1b8 net/bluetooth/sco.c:97
       process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
       worker_thread+0x340/0x610 kernel/workqueue.c:2436
       kthread+0x12c/0x158 kernel/kthread.c:376
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

-> #0 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x1530/0x30a4 kernel/locking/lockdep.c:5053
       lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
       __flush_work+0x9c/0x144 kernel/workqueue.c:3069
       __cancel_work_timer+0x1c4/0x2ac kernel/workqueue.c:3160
       cancel_delayed_work_sync+0x24/0x38 kernel/workqueue.c:3301
       sco_conn_del+0x140/0x234 net/bluetooth/sco.c:205
       sco_disconn_cfm+0x64/0xa8 net/bluetooth/sco.c:1379
       hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
       hci_conn_hash_flush+0x88/0x148 net/bluetooth/hci_conn.c:2366
       hci_dev_close_sync+0x48c/0x9e0 net/bluetooth/hci_sync.c:4476
       hci_dev_do_close net/bluetooth/hci_core.c:554 [inline]
       hci_rfkill_set_block+0x98/0x198 net/bluetooth/hci_core.c:947
       rfkill_set_block+0xb4/0x1f8 net/rfkill/core.c:345
       rfkill_fop_write+0x358/0x3f8 net/rfkill/core.c:1286
       do_iter_write+0x1f0/0x560 fs/read_write.c:857
       vfs_writev fs/read_write.c:928 [inline]
       do_writev+0x12c/0x234 fs/read_write.c:971
       __do_sys_writev fs/read_write.c:1044 [inline]
       __se_sys_writev fs/read_write.c:1041 [inline]
       __arm64_sys_writev+0x28/0x38 fs/read_write.c:1041
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
       el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581

other info that might help us debug this:

Chain exists of:
  (work_completion)(&(&conn->timeout_work)->work) --> &hdev->lock --> hci_cb_list_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(hci_cb_list_lock);
                               lock(&hdev->lock);
                               lock(hci_cb_list_lock);
  lock((work_completion)(&(&conn->timeout_work)->work));

 *** DEADLOCK ***

4 locks held by syz-executor.1/24281:
 #0: ffff80000d893400 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_write+0x18c/0x3f8 net/rfkill/core.c:1278
 #1: ffff00010c626fd0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close net/bluetooth/hci_core.c:552 [inline]
 #1: ffff00010c626fd0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_rfkill_set_block+0x90/0x198 net/bluetooth/hci_core.c:947
 #2: ffff00010c626078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_close_sync+0x200/0x9e0 net/bluetooth/hci_sync.c:4463
 #3: ffff80000d832b98 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1776 [inline]
 #3: ffff80000d832b98 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0x64/0x148 net/bluetooth/hci_conn.c:2366

stack backtrace:
CPU: 1 PID: 24281 Comm: syz-executor.1 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 print_circular_bug+0x2c4/0x2c8 kernel/locking/lockdep.c:2053
 check_noncircular+0x14c/0x154 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x1530/0x30a4 kernel/locking/lockdep.c:5053
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
 __flush_work+0x9c/0x144 kernel/workqueue.c:3069
 __cancel_work_timer+0x1c4/0x2ac kernel/workqueue.c:3160
 cancel_delayed_work_sync+0x24/0x38 kernel/workqueue.c:3301
 sco_conn_del+0x140/0x234 net/bluetooth/sco.c:205
 sco_disconn_cfm+0x64/0xa8 net/bluetooth/sco.c:1379
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x88/0x148 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x48c/0x9e0 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close net/bluetooth/hci_core.c:554 [inline]
 hci_rfkill_set_block+0x98/0x198 net/bluetooth/hci_core.c:947
 rfkill_set_block+0xb4/0x1f8 net/rfkill/core.c:345
 rfkill_fop_write+0x358/0x3f8 net/rfkill/core.c:1286
 do_iter_write+0x1f0/0x560 fs/read_write.c:857
 vfs_writev fs/read_write.c:928 [inline]
 do_writev+0x12c/0x234 fs/read_write.c:971
 __do_sys_writev fs/read_write.c:1044 [inline]
 __se_sys_writev fs/read_write.c:1041 [inline]
 __arm64_sys_writev+0x28/0x38 fs/read_write.c:1041
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
rfkill: input handler enabled


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
