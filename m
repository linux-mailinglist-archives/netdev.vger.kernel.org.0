Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115B3628C14
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 23:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbiKNW1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 17:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbiKNW1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 17:27:52 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07DBFAFE
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 14:27:50 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id bx19-20020a056602419300b006bcbf3b91fdso6444203iob.13
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 14:27:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aJ/h9f/SR3FMr32V5ylk9Tgs538zn39F2L+7bE0Uazk=;
        b=iw1ONbxLW/ZnQzvQvT7/wmM2tY11Jn7GESIEfbqw65Rfq6cKL54cOEHve8YbNOrDum
         OpjfNoRQZYo9qejXfldDZhQdXO9zywmRHC6YWE6FBlos6ChXIGM5O+A80ug/Dj3jCoVM
         4TfUxTtT+EnDtkWcSeNklAvyClhfEggFEKKT6cToDoPgaCBQ5EaXkvCUWfL7c7OfafGA
         +tmeG5diPIZ9HyMN5OtwwrHdxvDg0HGbM5RqSAE2o3+Z1DxU2iX80NW1aJRMZNtHeFIq
         6oNZlwrnDM3Ol/9GJtuDem6zEqwggsuaS3wp1QlJmNOQxOt+XwrBgwNWkN8osQZh1tqC
         +IFw==
X-Gm-Message-State: ANoB5pl8SHUcJ9TAsDUqnOpLBu4iDvh86ljLGfKOgbtqCFePy75t4tuZ
        LD0QsRoUPtac8YErui967s20iByBhzMzf7HhtctH6VXH9Bbq
X-Google-Smtp-Source: AA0mqf5oXl1fhtVxnwMrgO0Adlf459j/Re3133B4rkm2F8080aS/E71zyq03UTGtVLNAy/MIy+e7G2Eu+wrjJ8HXpoEaQzLps9Xz
MIME-Version: 1.0
X-Received: by 2002:a02:c648:0:b0:375:cea:3c38 with SMTP id
 k8-20020a02c648000000b003750cea3c38mr6551600jan.87.1668464870225; Mon, 14 Nov
 2022 14:27:50 -0800 (PST)
Date:   Mon, 14 Nov 2022 14:27:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8fd1f05ed75bf20@google.com>
Subject: [syzbot] possible deadlock in nci_start_poll
From:   syzbot <syzbot+f1f36887d202cea1446d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    094226ad94f4 Linux 6.1-rc5
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13efcb56880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31242cbb858881d2
dashboard link: https://syzkaller.appspot.com/bug?extid=f1f36887d202cea1446d
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177ba9ae880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17458169880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ae9c102f9e6a/disk-094226ad.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c933a51b8e7e/vmlinux-094226ad.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2b6acadd6e4/bzImage-094226ad.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1f36887d202cea1446d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.1.0-rc5-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor297/3623 is trying to acquire lock:
ffff88801fc74350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_request net/nfc/nci/core.c:148 [inline]
ffff88801fc74350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_set_local_general_bytes net/nfc/nci/core.c:774 [inline]
ffff88801fc74350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_start_poll+0x57a/0xef0 net/nfc/nci/core.c:838

but task is already holding lock:
ffff888017e0d508 (&genl_data->genl_data_mutex){+.+.}-{3:3}, at: nfc_genl_start_poll+0x1d2/0x340 net/nfc/netlink.c:826

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&genl_data->genl_data_mutex){+.+.}-{3:3}:
       lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
       __mutex_lock_common+0x1de/0x26c0 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
       nfc_urelease_event_work+0x10a/0x300 net/nfc/netlink.c:1811
       process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
       worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
       kthread+0x266/0x300 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

-> #2 (nfc_devlist_mutex){+.+.}-{3:3}:
       lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
       __mutex_lock_common+0x1de/0x26c0 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
       nfc_register_device+0x33/0x320 net/nfc/core.c:1116
       nci_register_device+0x7c7/0x900 net/nfc/nci/core.c:1256
       virtual_ncidev_open+0x55/0xc0 drivers/nfc/virtual_ncidev.c:146
       misc_open+0x346/0x3c0 drivers/char/misc.c:143
       chrdev_open+0x5fb/0x680 fs/char_dev.c:414
       do_dentry_open+0x85f/0x11b0 fs/open.c:882
       do_open fs/namei.c:3557 [inline]
       path_openat+0x260e/0x2e00 fs/namei.c:3713
       do_filp_open+0x275/0x500 fs/namei.c:3740
       do_sys_openat2+0x13b/0x500 fs/open.c:1310
       do_sys_open fs/open.c:1326 [inline]
       __do_sys_openat fs/open.c:1342 [inline]
       __se_sys_openat fs/open.c:1337 [inline]
       __x64_sys_openat+0x243/0x290 fs/open.c:1337
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (nci_mutex){+.+.}-{3:3}:
       lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
       __mutex_lock_common+0x1de/0x26c0 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
       virtual_nci_close+0x13/0x40 drivers/nfc/virtual_ncidev.c:44
       nci_open_device+0x918/0xd00 net/nfc/nci/core.c:544
       nfc_dev_up+0x17d/0x320 net/nfc/core.c:118
       nfc_genl_dev_up+0x7f/0xc0 net/nfc/netlink.c:770
       genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
       genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
       genl_rcv_msg+0xc02/0xf60 net/netlink/genetlink.c:850
       netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2540
       genl_rcv+0x24/0x40 net/netlink/genetlink.c:861
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       ____sys_sendmsg+0x597/0x8e0 net/socket.c:2482
       ___sys_sendmsg net/socket.c:2536 [inline]
       __sys_sendmsg+0x28e/0x390 net/socket.c:2565
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (&ndev->req_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain+0x184a/0x6470 kernel/locking/lockdep.c:3831
       __lock_acquire+0x1292/0x1f60 kernel/locking/lockdep.c:5055
       lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
       __mutex_lock_common+0x1de/0x26c0 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
       nci_request net/nfc/nci/core.c:148 [inline]
       nci_set_local_general_bytes net/nfc/nci/core.c:774 [inline]
       nci_start_poll+0x57a/0xef0 net/nfc/nci/core.c:838
       nfc_start_poll+0x185/0x2f0 net/nfc/core.c:225
       nfc_genl_start_poll+0x1df/0x340 net/nfc/netlink.c:828
       genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
       genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
       genl_rcv_msg+0xc02/0xf60 net/netlink/genetlink.c:850
       netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2540
       genl_rcv+0x24/0x40 net/netlink/genetlink.c:861
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       ____sys_sendmsg+0x597/0x8e0 net/socket.c:2482
       ___sys_sendmsg net/socket.c:2536 [inline]
       __sys_sendmsg+0x28e/0x390 net/socket.c:2565
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

Chain exists of:
  &ndev->req_lock --> nfc_devlist_mutex --> &genl_data->genl_data_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&genl_data->genl_data_mutex);
                               lock(nfc_devlist_mutex);
                               lock(&genl_data->genl_data_mutex);
  lock(&ndev->req_lock);

 *** DEADLOCK ***

4 locks held by syz-executor297/3623:
 #0: ffffffff8de415d0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:860
 #1: ffffffff8de41488 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8de41488 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x123/0xf60 net/netlink/genetlink.c:848
 #2: ffff888017e0d508 (&genl_data->genl_data_mutex){+.+.}-{3:3}, at: nfc_genl_start_poll+0x1d2/0x340 net/nfc/netlink.c:826
 #3: ffff888017e0d100 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #3: ffff888017e0d100 (&dev->mutex){....}-{3:3}, at: nfc_start_poll+0x61/0x2f0 net/nfc/core.c:208

stack backtrace:
CPU: 0 PID: 3623 Comm: syz-executor297 Not tainted 6.1.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 check_noncircular+0x2f9/0x3b0 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain+0x184a/0x6470 kernel/locking/lockdep.c:3831
 __lock_acquire+0x1292/0x1f60 kernel/locking/lockdep.c:5055
 lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
 __mutex_lock_common+0x1de/0x26c0 kernel/locking/mutex.c:603
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 nci_request net/nfc/nci/core.c:148 [inline]
 nci_set_local_general_bytes net/nfc/nci/core.c:774 [inline]
 nci_start_poll+0x57a/0xef0 net/nfc/nci/core.c:838
 nfc_start_poll+0x185/0x2f0 net/nfc/core.c:225
 nfc_genl_start_poll+0x1df/0x340 net/nfc/netlink.c:828
 genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
 genl_rcv_msg+0xc02/0xf60 net/netlink/genetlink.c:850
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2540
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:861
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x597/0x8e0 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x28e/0x390 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ff50a3c2639
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff50a373318 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff50a44a428 RCX: 00007ff50a3c2639
RDX: 0000000000000000 RSI: 0000000020000440 RDI: 0000000000000004
RBP: 00007ff50a44a420 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00007ff50a418064
R13: 00007ffeeffb422f R14: 00007ff50a373400 R15: 0000000000022000
 </TASK>
nci: __nci_request: wait_for_completion_interruptible_timeout failed -512
nci: nci_start_poll: failed to set local general bytes
nci: __nci_request: wait_for_completion_interruptible_timeout failed 0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
