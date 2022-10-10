Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA15F9DFE
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiJJLxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiJJLxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:53:40 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A626AE90
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 04:53:38 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id d6-20020a056e02214600b002fa23a188ebso8468858ilv.6
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 04:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XyjpbSAV9zKFghDaVuv2lfxXp4N8SwMG2j7ltj68tRw=;
        b=QTYeYRNa2vHIshkeGk83b+rA1LV9n95Lti8BkCPTzRr1y/iOa13t2dZJ7H1p31oPcf
         A4chqnb+mWeXirASmomLW3Czl2UAjJnGTQ8OwnH2g2aqN5iaCEVLPMqOa364s0ZXjAok
         E7OVPdNMspTYPAM+pFhJRvir/qkyn3ZDwXFv/OV6QaFCicwkfoQAQNWAcwNMzy2sMGws
         8W9FOp8sm/x663uYZwtJjeuOI8te0mU5UryccUtMyh/aM7t+rd4iSMEaveq2YNQ8YZ96
         aw51n6BLz1rKxsU9eKYlKZTy56E5bNHnKNq0rRIEwz3hhgM6SvlIA9Y/eb2HMHYAa8xe
         1Tqw==
X-Gm-Message-State: ACrzQf0p3myaOY+nr8xzu+B6xhTZhJUjwmcAUHrD3LNvwfKPKcanZieJ
        j0v6HUQo6Q8ggL2vUytosLyxBLe662MiCsFHc35nxW/iuuPH
X-Google-Smtp-Source: AMsMyM7YC7B4VX7kiFXdOMB7a29pZkwCkVNt5qw1UaWzqk9goLssAvIK1o6tAUVhb0bl2dRgcmGacK8A2UQC9IvsPMT2re3V7X3L
MIME-Version: 1.0
X-Received: by 2002:a05:6638:419f:b0:35a:286e:6bdb with SMTP id
 az31-20020a056638419f00b0035a286e6bdbmr9105823jab.295.1665402817676; Mon, 10
 Oct 2022 04:53:37 -0700 (PDT)
Date:   Mon, 10 Oct 2022 04:53:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b100405eaaccf89@google.com>
Subject: [syzbot] possible deadlock in sco_sock_timeout
From:   syzbot <syzbot+10c46e34f156f51a28ad@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1188403a880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a4a45d2d827c1e
dashboard link: https://syzkaller.appspot.com/bug?extid=10c46e34f156f51a28ad
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e91bc79312/disk-bbed346d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1cb3fb3b77e/vmlinux-bbed346d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10c46e34f156f51a28ad@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0 Not tainted
------------------------------------------------------
kworker/1:2/31873 is trying to acquire lock:
ffff000115941130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1712 [inline]
ffff000115941130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at: sco_sock_timeout+0x88/0x1b8 net/bluetooth/sco.c:97

but task is already holding lock:
ffff8000149abd80 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}:
       __flush_work+0x9c/0x144 kernel/workqueue.c:3069
       __cancel_work_timer+0x1c4/0x2ac kernel/workqueue.c:3160
       cancel_delayed_work_sync+0x24/0x38 kernel/workqueue.c:3301
       sco_conn_del+0x140/0x234 net/bluetooth/sco.c:205
       sco_disconn_cfm+0x64/0xa8 net/bluetooth/sco.c:1379
       hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
       hci_conn_hash_flush+0x88/0x148 net/bluetooth/hci_conn.c:2366
       hci_dev_close_sync+0x48c/0x9e0 net/bluetooth/hci_sync.c:4476
       hci_dev_do_close net/bluetooth/hci_core.c:554 [inline]
       hci_error_reset+0xac/0x154 net/bluetooth/hci_core.c:1050
       process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
       worker_thread+0x340/0x610 kernel/workqueue.c:2436
       kthread+0x12c/0x158 kernel/kthread.c:376
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

-> #2 (hci_cb_list_lock){+.+.}-{3:3}:
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

-> #1 (&hdev->lock){+.+.}-{3:3}:
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       sco_sock_connect+0x104/0x220 net/bluetooth/sco.c:593
       __sys_connect_file net/socket.c:1976 [inline]
       __sys_connect+0x184/0x190 net/socket.c:1993
       __do_sys_connect net/socket.c:2003 [inline]
       __se_sys_connect net/socket.c:2000 [inline]
       __arm64_sys_connect+0x28/0x3c net/socket.c:2000
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
       el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581

-> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x1530/0x30a4 kernel/locking/lockdep.c:5053
       lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
       lock_sock_nested+0x70/0xd8 net/core/sock.c:3393
       lock_sock include/net/sock.h:1712 [inline]
       sco_sock_timeout+0x88/0x1b8 net/bluetooth/sco.c:97
       process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
       worker_thread+0x340/0x610 kernel/workqueue.c:2436
       kthread+0x12c/0x158 kernel/kthread.c:376
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

other info that might help us debug this:

Chain exists of:
  sk_lock-AF_BLUETOOTH-BTPROTO_SCO --> hci_cb_list_lock --> (work_completion)(&(&conn->timeout_work)->work)

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&(&conn->timeout_work)->work));
                               lock(hci_cb_list_lock);
                               lock((work_completion)(&(&conn->timeout_work)->work));
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

2 locks held by kworker/1:2/31873:
 #0: ffff0000c0010738 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x270/0x504 kernel/workqueue.c:2262
 #1: ffff8000149abd80 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264

stack backtrace:
CPU: 1 PID: 31873 Comm: kworker/1:2 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: events sco_sock_timeout
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
 lock_sock_nested+0x70/0xd8 net/core/sock.c:3393
 lock_sock include/net/sock.h:1712 [inline]
 sco_sock_timeout+0x88/0x1b8 net/bluetooth/sco.c:97
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
