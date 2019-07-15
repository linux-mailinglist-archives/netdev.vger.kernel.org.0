Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C22699A9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731650AbfGORXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:23:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:23282 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730566AbfGORXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:23:02 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2019 13:22:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1563211374;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:References:To:Subject:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=K+lgMZKk2yr3MCRwh1L0ByrryPoo2B6V3LCHHOjriuk=;
        b=hxV1NHolc5AVtbkrgFaB6YiN9u0pRrlhkwCdVbkk3mYE04apY0IR+H8eMmX3xh4ii6
        z3boMwiBgGvxZFkG9gxusVt4P9se9cugOE/NqdxK+JP1132xbWYihslLS10vlcyOSnnW
        PKEknSwc4I+PGvj3ZR8L6X+ALhKqrwvfwfD86VNnReIAx8SlF0G4TkpfNn70NXZSFOZI
        rQ8zB1OkUV46lOVsYCVLrTekcTmJFxXe2vGz0uNVYbD80stwFPtxc0SnyfBK26dM1m1F
        oOeNbnQ0oe3Rg16L59Ehanz+nTecOvXIjm1/fBm1HvTcc9WJjlYU1I9E0W9vLPqExfpp
        wTGw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5lUg5"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.200]
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id k05d3bv6FHGpIfM
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 15 Jul 2019 19:16:51 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: INFO: task hung in unregister_netdevice_notifier (3)
To:     syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Kirill Tkhai <ktkhai@virtuozzo.com>
References: <000000000000d018ea058d9c46e3@google.com>
Message-ID: <be6c249e-3b99-8388-5b13-547645b2fac9@hartkopp.net>
Date:   Mon, 15 Jul 2019 19:16:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <000000000000d018ea058d9c46e3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

On 14.07.19 06:07, syzbot wrote:
> syzbot has found a reproducer for the following crash on:

the internal users of the CAN networking subsystem like CAN_BCM and 
CAN_RAW hold a number of CAN identifier subscriptions ('filters') for 
CAN netdevices (only type ARPHRD_CAN) in their socket data structures.

The per-socket netdevice notifier is used to manage the ad-hoc removal 
of these filters at netdevice removal time.

What I can see in the console output at

https://syzkaller.appspot.com/x/log.txt?x=10e45f0fa00000

seems to be a race between an unknown register_netdevice_notifier() call 
("A") and the unregister_netdevice_notifier() ("B") likely invoked by 
bcm_release() ("C"):

[ 1047.294207][ T1049]  schedule+0xa8/0x270
[ 1047.318401][ T1049]  rwsem_down_write_slowpath+0x70a/0xf70
[ 1047.324114][ T1049]  ? downgrade_write+0x3c0/0x3c0
[ 1047.438644][ T1049]  ? mark_held_locks+0xf0/0xf0
[ 1047.443483][ T1049]  ? lock_acquire+0x190/0x410
[ 1047.448191][ T1049]  ? unregister_netdevice_notifier+0x7e/0x390
[ 1047.547227][ T1049]  down_write+0x13c/0x150
[ 1047.579535][ T1049]  ? down_write+0x13c/0x150
[ 1047.584106][ T1049]  ? __down_timeout+0x2d0/0x2d0
[ 1047.635356][ T1049]  ? mark_held_locks+0xf0/0xf0
[ 1047.640721][ T1049]  unregister_netdevice_notifier+0x7e/0x390  <- "B"
[ 1047.646667][ T1049]  ? __sock_release+0x89/0x280
[ 1047.709126][ T1049]  ? register_netdevice_notifier+0x630/0x630 <- "A"
[ 1047.715203][ T1049]  ? __kasan_check_write+0x14/0x20
[ 1047.775138][ T1049]  bcm_release+0x93/0x5e0                    <- "C"
[ 1047.795337][ T1049]  __sock_release+0xce/0x280
[ 1047.829016][ T1049]  sock_close+0x1e/0x30

The question to me is now:

Is the problem located in an (un)register_netdevice_notifier race OR is 
it generally a bad idea to call unregister_netdevice_notifier() in a 
sock release?

I've never seen that kind of problem in the wild. But if it would be the 
latter case wouldn't it be the same problem when someone unloads the 
kernel module at the 'wrong' time?

In commit 328fbe747ad46 ("net: Close race between {un, 
}register_netdevice_notifier() and setup_net()/cleanup_net()") Kirill 
Tkhai reviewed the calling site in CAN_RAW raw_release() which points to 
the same situation. Therefore added him to the recipient list.

Should down_write() be replaced with something like 
rwsem_down_write_slowpath()??

Regards,
Oliver

> HEAD commit:    a2d79c71 Merge tag 'for-5.3/io_uring-20190711' of 
> git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e45f0fa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3539b1747f03988e
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=0f1827363a305f74996f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1765c52fa00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com
> 
> INFO: task syz-executor.4:9527 blocked for more than 143 seconds.
>        Not tainted 5.2.0+ #80
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor.4  D28136  9527   9356 0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:3252 [inline]
>   __schedule+0x755/0x1580 kernel/sched/core.c:3878
>   schedule+0xa8/0x270 kernel/sched/core.c:3942
>   rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
>   __down_write kernel/locking/rwsem.c:1349 [inline]
>   down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
>   unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
>   bcm_release+0x93/0x5e0 net/can/bcm.c:1525
>   __sock_release+0xce/0x280 net/socket.c:586
>   sock_close+0x1e/0x30 net/socket.c:1264
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:185 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413501
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 
> 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 
> 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
> R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
> INFO: task syz-executor.2:9528 blocked for more than 145 seconds.
>        Not tainted 5.2.0+ #80
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor.2  D28136  9528   9354 0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:3252 [inline]
>   __schedule+0x755/0x1580 kernel/sched/core.c:3878
>   schedule+0xa8/0x270 kernel/sched/core.c:3942
>   rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
>   __down_write kernel/locking/rwsem.c:1349 [inline]
>   down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
>   unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
>   bcm_release+0x93/0x5e0 net/can/bcm.c:1525
>   __sock_release+0xce/0x280 net/socket.c:586
>   sock_close+0x1e/0x30 net/socket.c:1264
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:185 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413501
> Code: 5f fe ff ff 31 c9 31 f6 41 b9 b0 20 41 00 41 b8 8c d6 65 00 ba 02 
> 00 00 00 bf 28 38 44 00 ff 15 7d a1 24 00 85 c0 0f 85 37 fe <ff> ff 31 
> c9 31 f6 41 b9 b0 20 41 00 41 b8 90 d6 65 00 ba 03 00 00
> RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
> R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
> INFO: task syz-executor.0:9529 blocked for more than 147 seconds.
>        Not tainted 5.2.0+ #80
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor.0  D28136  9529   9353 0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:3252 [inline]
>   __schedule+0x755/0x1580 kernel/sched/core.c:3878
>   schedule+0xa8/0x270 kernel/sched/core.c:3942
>   rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
>   __down_write kernel/locking/rwsem.c:1349 [inline]
>   down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
>   unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
>   bcm_release+0x93/0x5e0 net/can/bcm.c:1525
>   __sock_release+0xce/0x280 net/socket.c:586
>   sock_close+0x1e/0x30 net/socket.c:1264
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:185 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413501
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 
> 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 
> 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
> R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
> INFO: task syz-executor.5:9533 blocked for more than 148 seconds.
>        Not tainted 5.2.0+ #80
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor.5  D28136  9533   9358 0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:3252 [inline]
>   __schedule+0x755/0x1580 kernel/sched/core.c:3878
>   schedule+0xa8/0x270 kernel/sched/core.c:3942
>   rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
>   __down_write kernel/locking/rwsem.c:1349 [inline]
>   down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
>   unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
>   bcm_release+0x93/0x5e0 net/can/bcm.c:1525
>   __sock_release+0xce/0x280 net/socket.c:586
>   sock_close+0x1e/0x30 net/socket.c:1264
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:185 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413501
> Code: 5f fe ff ff 31 c9 31 f6 41 b9 b0 20 41 00 41 b8 8c d6 65 00 ba 02 
> 00 00 00 bf 28 38 44 00 ff 15 7d a1 24 00 85 c0 0f 85 37 fe <ff> ff 31 
> c9 31 f6 41 b9 b0 20 41 00 41 b8 90 d6 65 00 ba 03 00 00
> RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
> R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
> INFO: task syz-executor.1:9534 blocked for more than 148 seconds.
>        Not tainted 5.2.0+ #80
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor.1  D28136  9534   9359 0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:3252 [inline]
>   __schedule+0x755/0x1580 kernel/sched/core.c:3878
>   schedule+0xa8/0x270 kernel/sched/core.c:3942
>   rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
>   __down_write kernel/locking/rwsem.c:1349 [inline]
>   down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
>   unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
>   bcm_release+0x93/0x5e0 net/can/bcm.c:1525
>   __sock_release+0xce/0x280 net/socket.c:586
>   sock_close+0x1e/0x30 net/socket.c:1264
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:185 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413501
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 
> 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 
> 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
> R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
> INFO: task syz-executor.3:9535 blocked for more than 150 seconds.
>        Not tainted 5.2.0+ #80
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor.3  D28136  9535   9351 0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:3252 [inline]
>   __schedule+0x755/0x1580 kernel/sched/core.c:3878
>   schedule+0xa8/0x270 kernel/sched/core.c:3942
>   rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
>   __down_write kernel/locking/rwsem.c:1349 [inline]
>   down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
>   unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
>   bcm_release+0x93/0x5e0 net/can/bcm.c:1525
>   __sock_release+0xce/0x280 net/socket.c:586
>   sock_close+0x1e/0x30 net/socket.c:1264
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:185 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413501
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 
> 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 
> 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
> R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/1049:
>   #0: 00000000ede263b0 (rcu_read_lock){....}, at: 
> debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:5257
> 1 lock held by rsyslogd/9208:
>   #0: 00000000da20b59a (&f->f_pos_lock){+.+.}, at: 
> __fdget_pos+0xee/0x110 fs/file.c:801
> 2 locks held by getty/9298:
>   #0: 00000000e9efae0d (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
>   #1: 0000000007287a12 (&ldata->atomic_read_lock){+.+.}, at: 
> n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9299:
>   #0: 00000000ad0733b0 (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
>   #1: 0000000094dd5193 (&ldata->atomic_read_lock){+.+.}, at: 
> n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9300:
>   #0: 00000000692c340f (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
>   #1: 00000000538c7d7d (&ldata->atomic_read_lock){+.+.}, at: 
> n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9301:
>   #0: 00000000116ea6c7 (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
>   #1: 00000000a908a9f7 (&ldata->atomic_read_lock){+.+.}, at: 
> n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9302:
>   #0: 0000000042704f01 (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
>   #1: 0000000041cc8671 (&ldata->atomic_read_lock){+.+.}, at: 
> n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9303:
>   #0: 000000001ef3b293 (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
>   #1: 000000008b703302 (&ldata->atomic_read_lock){+.+.}, at: 
> n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9304:
>   #0: 0000000095601bb0 (&tty->ldisc_sem){++++}, at: 
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
> 
