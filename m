Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FE46D13F9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCaAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCaAXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:23:35 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E395E12CD9
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:22:57 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id w4-20020a5d9604000000b0074d326b26bcso12560605iol.9
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680222106; x=1682814106;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wU3dsEsxwHYF6HXDRCFRaWfh3xqSaIzoCCqFezx/r6I=;
        b=DYF7ftQk8ERtYbdsg5kCLeiPD6+P+BkRpegjKd1QP/d8qjsMy88QE0JPZj47gyl3M7
         D9klwnl3mSanzajWQiAayaezI3COXWTRKlXVc1l0E7/8eaPdK67dE2g+e1n4qjfalrXE
         1sN+2yBC5sQSpn6vXL06QdDbAEJf3AjlHjceEKBxhjrfSugl+F9Mjbr4wjNwzCLioR5v
         8U+ItDUmcOPQgJRMcnmGtc6mfSmF+LQpf1EwrFA+8O5GhlpqRrqvWOSD2cWVaKHDrBSI
         R7FGpN7h7ykB0couudWYZaquDcgZl0zC1slclnSB3l4a3GVgDMw6pbxBbNXtaZPvzcb0
         Hh6A==
X-Gm-Message-State: AAQBX9dSFd+Lu9VEASKsRNs77nAZiGB5qxRd+6vYK0paZfgCRw2Deb+C
        niC10ytlb+e2L1T1kX/Ayb7ofaEjEB9iMdmUvDaWTEm1MMRr
X-Google-Smtp-Source: AKy350brf8se8epDL+qiI1wWlLUR0gu8CIhNfsbUiX07/oxqiaUUVHncBye5KHlQTInZg4TXxXsEp11AGYEbME7A45PwGenmnIFr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b46:b0:316:fa49:3705 with SMTP id
 f6-20020a056e020b4600b00316fa493705mr13243005ilu.1.1680222106282; Thu, 30 Mar
 2023 17:21:46 -0700 (PDT)
Date:   Thu, 30 Mar 2023 17:21:46 -0700
In-Reply-To: <0000000000006477b305f2b48b58@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9f2ae05f82731c0@google.com>
Subject: Re: [syzbot] [bluetooth?] possible deadlock in rfcomm_dlc_exists
From:   syzbot <syzbot+b69a625d06e8ece26415@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yangyingliang@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a6d9e3034536 Add linux-next specific files for 20230330
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=152adc3ec80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aceb117f7924508e
dashboard link: https://syzkaller.appspot.com/bug?extid=b69a625d06e8ece26415
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153acb85c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179d1ed1c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ec1f900ea929/disk-a6d9e303.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fabbf89c0d22/vmlinux-a6d9e303.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1ed05d6192fa/bzImage-a6d9e303.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b69a625d06e8ece26415@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.3.0-rc4-next-20230330-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor363/5115 is trying to acquire lock:
ffffffff8e357cc8 (rfcomm_mutex){+.+.}-{3:3}, at: rfcomm_dlc_exists+0x58/0x190 net/bluetooth/rfcomm/core.c:546

but task is already holding lock:
ffffffff8e35cc88 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_create_dev net/bluetooth/rfcomm/tty.c:484 [inline]
ffffffff8e35cc88 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_dev_ioctl+0x8a2/0x1c00 net/bluetooth/rfcomm/tty.c:587

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (rfcomm_ioctl_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       rfcomm_create_dev net/bluetooth/rfcomm/tty.c:484 [inline]
       rfcomm_dev_ioctl+0x8a2/0x1c00 net/bluetooth/rfcomm/tty.c:587
       rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
       sock_do_ioctl+0xcc/0x230 net/socket.c:1199
       sock_ioctl+0x1f8/0x680 net/socket.c:1316
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:870 [inline]
       __se_sys_ioctl fs/ioctl.c:856 [inline]
       __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #2 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
       lock_sock_nested+0x3a/0xf0 net/core/sock.c:3474
       lock_sock include/net/sock.h:1697 [inline]
       rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
       __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:493
       rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:524
       __rfcomm_sock_close+0x17a/0x2f0 net/bluetooth/rfcomm/sock.c:220
       rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:912
       rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:933
       __sock_release+0xcd/0x290 net/socket.c:653
       sock_close+0x1c/0x20 net/socket.c:1395
       __fput+0x27c/0xa90 fs/file_table.c:321
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       exit_task_work include/linux/task_work.h:38 [inline]
       do_exit+0xb0d/0x29f0 kernel/exit.c:869
       do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
       get_signal+0x2315/0x25b0 kernel/signal.c:2859
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:307
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
       __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (&d->lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:491
       rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:524
       __rfcomm_sock_close+0x17a/0x2f0 net/bluetooth/rfcomm/sock.c:220
       rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:912
       rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:933
       __sock_release+0xcd/0x290 net/socket.c:653
       sock_close+0x1c/0x20 net/socket.c:1395
       __fput+0x27c/0xa90 fs/file_table.c:321
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       exit_task_work include/linux/task_work.h:38 [inline]
       do_exit+0xb0d/0x29f0 kernel/exit.c:869
       do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
       get_signal+0x2315/0x25b0 kernel/signal.c:2859
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:307
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
       __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (rfcomm_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3108 [inline]
       check_prevs_add kernel/locking/lockdep.c:3227 [inline]
       validate_chain kernel/locking/lockdep.c:3842 [inline]
       __lock_acquire+0x2f21/0x5df0 kernel/locking/lockdep.c:5074
       lock_acquire.part.0+0x11c/0x370 kernel/locking/lockdep.c:5691
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       rfcomm_dlc_exists+0x58/0x190 net/bluetooth/rfcomm/core.c:546
       __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:414 [inline]
       rfcomm_create_dev net/bluetooth/rfcomm/tty.c:485 [inline]
       rfcomm_dev_ioctl+0x966/0x1c00 net/bluetooth/rfcomm/tty.c:587
       rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
       sock_do_ioctl+0xcc/0x230 net/socket.c:1199
       sock_ioctl+0x1f8/0x680 net/socket.c:1316
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:870 [inline]
       __se_sys_ioctl fs/ioctl.c:856 [inline]
       __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

Chain exists of:
  rfcomm_mutex --> sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM --> rfcomm_ioctl_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rfcomm_ioctl_mutex);
                               lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
                               lock(rfcomm_ioctl_mutex);
  lock(rfcomm_mutex);

 *** DEADLOCK ***

2 locks held by syz-executor363/5115:
 #0: ffff888146eb7130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1697 [inline]
 #0: ffff888146eb7130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sock_ioctl+0xaa/0xe0 net/bluetooth/rfcomm/sock.c:879
 #1: ffffffff8e35cc88 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_create_dev net/bluetooth/rfcomm/tty.c:484 [inline]
 #1: ffffffff8e35cc88 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_dev_ioctl+0x8a2/0x1c00 net/bluetooth/rfcomm/tty.c:587

stack backtrace:
CPU: 0 PID: 5115 Comm: syz-executor363 Not tainted 6.3.0-rc4-next-20230330-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2188
 check_prev_add kernel/locking/lockdep.c:3108 [inline]
 check_prevs_add kernel/locking/lockdep.c:3227 [inline]
 validate_chain kernel/locking/lockdep.c:3842 [inline]
 __lock_acquire+0x2f21/0x5df0 kernel/locking/lockdep.c:5074
 lock_acquire.part.0+0x11c/0x370 kernel/locking/lockdep.c:5691
 __mutex_lock_common kernel/locking/mutex.c:603 [inline]
 __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
 rfcomm_dlc_exists+0x58/0x190 net/bluetooth/rfcomm/core.c:546
 __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:414 [inline]
 rfcomm_create_dev net/bluetooth/rfcomm/tty.c:485 [inline]
 rfcomm_dev_ioctl+0x966/0x1c00 net/bluetooth/rfcomm/tty.c:587
 rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
 sock_do_ioctl+0xcc/0x230 net/socket.c:1199
 sock_ioctl+0x1f8/0x680 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fdd90dc3379
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc287c58b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fdd90dc3379
RDX: 0000000020000100 RSI: 00000000400452c8 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc287c58e8
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc287c5900
R13: 00007ffc287c5910 R14: 000000000001c039 R15: 00007ffc287c58d0
 </TASK>

