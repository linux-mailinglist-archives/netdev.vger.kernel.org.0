Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA40628753
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbiKNRn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiKNRn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:43:56 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175B2B85C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:43:49 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id s4-20020a056e02216400b003021b648144so9752251ilv.19
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:43:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PTl6Rg3r2JPqIeyzl389/JCuDD3vbaKP46h/MG4AT/o=;
        b=kZb2PrFtxvCa8pgz+nB65M8sXy2kCI6qWru3U1aibuPgSuvnaFVfCpszRP6lHnOJMd
         L+REHh3z+KBm0l0T1D+Y7hy0jv/1mcHl/Mfu/LPScqowyRirew+cqAVLZmMuJpIveC2o
         ZWLCLJG01gpYi+fASF8BTJ3YwnkvSOkPu+FF2h0jMaaMEio9+jY85+pjwQ7tYJvcFWnt
         kpbWPeVO/3WLLxrGO29fHHLQKCYNNIRg0n7ZiTfULCTjCWjNeCceMotK18fQqg5CMKiw
         s4rBMmXJQyQxwVj11nLJXh1pJGXYs7kVx6IzZGhonN+6iiIvklqnBNMkmFyeDesLhtl2
         TeEw==
X-Gm-Message-State: ANoB5pmZVt+1vHvwV0JQ0aQ5Pmfd5/xuShitA4GqLtAMe7/d+0NZDRnR
        CRjN9vMVAVw5dc69forvIv4q+CBpJugeFeAF6PDNXhIXVrR7
X-Google-Smtp-Source: AA0mqf4DJzO8d3XrkY2cYx9fUiO+ueVKZ1LqPmER/A3bI/87Xc/lNVeqlhj+ksBwwi+trIK8cfyA9UbAaS46p3SvlqxLrxVekyx5
MIME-Version: 1.0
X-Received: by 2002:a92:dc0c:0:b0:300:ece2:e3b8 with SMTP id
 t12-20020a92dc0c000000b00300ece2e3b8mr6529994iln.255.1668447828383; Mon, 14
 Nov 2022 09:43:48 -0800 (PST)
Date:   Mon, 14 Nov 2022 09:43:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000023209305ed71c833@google.com>
Subject: [syzbot] possible deadlock in nci_set_local_general_bytes
From:   syzbot <syzbot+8768e9ec924b08e63f82@syzkaller.appspotmail.com>
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

HEAD commit:    1621b6eaebf7 Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=119413e1880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=606e57fd25c5c6cc
dashboard link: https://syzkaller.appspot.com/bug?extid=8768e9ec924b08e63f82
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1097e935880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177b5b15880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/82aa7741098d/disk-1621b6ea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f6be08c4e4c2/vmlinux-1621b6ea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/296b6946258a/Image-1621b6ea.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8768e9ec924b08e63f82@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.1.0-rc4-syzkaller-31872-g1621b6eaebf7 #0 Not tainted
------------------------------------------------------
syz-executor402/3146 is trying to acquire lock:
ffff0000cad76350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_request net/nfc/nci/core.c:148 [inline]
ffff0000cad76350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_set_local_general_bytes+0xbc/0x480 net/nfc/nci/core.c:774

but task is already holding lock:
ffff0000cad73d18 (&genl_data->genl_data_mutex){+.+.}-{3:3}, at: nfc_genl_start_poll+0xc4/0x174 net/nfc/netlink.c:826

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&genl_data->genl_data_mutex){+.+.}-{3:3}:
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       nfc_urelease_event_work+0x88/0x16c net/nfc/netlink.c:1811
       process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
       worker_thread+0x340/0x610 kernel/workqueue.c:2436
       kthread+0x12c/0x158 kernel/kthread.c:376
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863

-> #2 (nfc_devlist_mutex){+.+.}-{3:3}:
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       nfc_register_device+0x34/0x208 net/nfc/core.c:1116
       nci_register_device+0x338/0x3b0 net/nfc/nci/core.c:1256
       virtual_ncidev_open+0x6c/0xd8 drivers/nfc/virtual_ncidev.c:146
       misc_open+0x1b8/0x200 drivers/char/misc.c:143
       chrdev_open+0x2b4/0x2e8 fs/char_dev.c:414
       do_dentry_open+0x364/0x748 fs/open.c:882
       vfs_open+0x38/0x48 fs/open.c:1013
       do_open fs/namei.c:3557 [inline]
       path_openat+0xe34/0x11c4 fs/namei.c:3713
       do_filp_open+0xdc/0x1b8 fs/namei.c:3740
       do_sys_openat2+0xb8/0x22c fs/open.c:1310
       do_sys_open fs/open.c:1326 [inline]
       __do_sys_openat fs/open.c:1342 [inline]
       __se_sys_openat fs/open.c:1337 [inline]
       __arm64_sys_openat+0xb0/0xe0 fs/open.c:1337
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584

-> #1 (nci_mutex){+.+.}-{3:3}:
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       virtual_nci_close+0x28/0x58 drivers/nfc/virtual_ncidev.c:44
       nci_open_device+0x414/0x518 net/nfc/nci/core.c:544
       nci_dev_up+0x20/0x30 net/nfc/nci/core.c:631
       nfc_dev_up+0xcc/0x1b0 net/nfc/core.c:118
       nfc_genl_dev_up+0x40/0x78 net/nfc/netlink.c:770
       genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
       genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
       genl_rcv_msg+0x458/0x4f4 net/netlink/genetlink.c:850
       netlink_rcv_skb+0xe8/0x1d4 net/netlink/af_netlink.c:2540
       genl_rcv+0x38/0x50 net/netlink/genetlink.c:861
       netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1319
       netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       ____sys_sendmsg+0x2f8/0x440 net/socket.c:2482
       ___sys_sendmsg net/socket.c:2536 [inline]
       __sys_sendmsg+0x1ac/0x228 net/socket.c:2565
       __do_sys_sendmsg net/socket.c:2574 [inline]
       __se_sys_sendmsg net/socket.c:2572 [inline]
       __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2572
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584

-> #0 (&ndev->req_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x1530/0x3084 kernel/locking/lockdep.c:5055
       lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
       __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
       __mutex_lock kernel/locking/mutex.c:747 [inline]
       mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
       nci_request net/nfc/nci/core.c:148 [inline]
       nci_set_local_general_bytes+0xbc/0x480 net/nfc/nci/core.c:774
       nci_start_poll+0x1e8/0x474 net/nfc/nci/core.c:838
       nfc_start_poll+0xfc/0x170 net/nfc/core.c:225
       nfc_genl_start_poll+0xd4/0x174 net/nfc/netlink.c:828
       genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
       genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
       genl_rcv_msg+0x458/0x4f4 net/netlink/genetlink.c:850
       netlink_rcv_skb+0xe8/0x1d4 net/netlink/af_netlink.c:2540
       genl_rcv+0x38/0x50 net/netlink/genetlink.c:861
       netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1319
       netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       ____sys_sendmsg+0x2f8/0x440 net/socket.c:2482
       ___sys_sendmsg net/socket.c:2536 [inline]
       __sys_sendmsg+0x1ac/0x228 net/socket.c:2565
       __do_sys_sendmsg net/socket.c:2574 [inline]
       __se_sys_sendmsg net/socket.c:2572 [inline]
       __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2572
       __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
       invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
       el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
       do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
       el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
       el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584

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

4 locks held by syz-executor402/3146:
 #0: ffff80000d7c9268 (cb_lock){++++}-{3:3}, at: genl_rcv+0x28/0x50 net/netlink/genetlink.c:860
 #1: ffff80000d7c9178 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffff80000d7c9178 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x80/0x4f4 net/netlink/genetlink.c:848
 #2: ffff0000cad73d18 (&genl_data->genl_data_mutex){+.+.}-{3:3}, at: nfc_genl_start_poll+0xc4/0x174 net/nfc/netlink.c:826
 #3: ffff0000cad73900 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #3: ffff0000cad73900 (&dev->mutex){....}-{3:3}, at: nfc_start_poll+0x5c/0x170 net/nfc/core.c:208

stack backtrace:
CPU: 0 PID: 3146 Comm: syz-executor402 Not tainted 6.1.0-rc4-syzkaller-31872-g1621b6eaebf7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
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
 __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 nci_request net/nfc/nci/core.c:148 [inline]
 nci_set_local_general_bytes+0xbc/0x480 net/nfc/nci/core.c:774
 nci_start_poll+0x1e8/0x474 net/nfc/nci/core.c:838
 nfc_start_poll+0xfc/0x170 net/nfc/core.c:225
 nfc_genl_start_poll+0xd4/0x174 net/nfc/netlink.c:828
 genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
 genl_rcv_msg+0x458/0x4f4 net/netlink/genetlink.c:850
 netlink_rcv_skb+0xe8/0x1d4 net/netlink/af_netlink.c:2540
 genl_rcv+0x38/0x50 net/netlink/genetlink.c:861
 netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1319
 netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x2f8/0x440 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x1ac/0x228 net/socket.c:2565
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2572
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
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
