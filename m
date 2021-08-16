Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1133EDA4E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhHPP5U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Aug 2021 11:57:20 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43791 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbhHPP5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:57:20 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 13C02CECC8;
        Mon, 16 Aug 2021 17:56:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [syzbot] INFO: task hung in hci_req_sync
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <9365fdfa-3cee-f22e-c53d-6536a96d27ae@gmail.com>
Date:   Mon, 16 Aug 2021 17:56:46 +0200
Cc:     syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: 8BIT
Message-Id: <57BAFAA4-3C3D-40C8-9121-44EEF44509B8@holtmann.org>
References: <000000000000c5482805c956a118@google.com>
 <9365fdfa-3cee-f22e-c53d-6536a96d27ae@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>> syzbot found the following issue on:
>> HEAD commit:    c9194f32bfd9 Merge tag 'ext4_for_linus_stable' of git://gi..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1488f59e300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=be2baed593ea56c6a84c
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b5afc6300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcd192300000
>> Bisection is inconclusive: the issue happens on the oldest tested release.
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17dce4fa300000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=143ce4fa300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=103ce4fa300000
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
>> INFO: task syz-executor446:8489 blocked for more than 143 seconds.
>>       Not tainted 5.14.0-rc4-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor446 state:D stack:28712 pid: 8489 ppid:  8452 flags:0x00000000
>> Call Trace:
>>  context_switch kernel/sched/core.c:4683 [inline]
>>  __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
>>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
>>  hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
>>  hci_inquiry+0x6f4/0x9e0 net/bluetooth/hci_core.c:1357
>>  hci_sock_ioctl+0x1a7/0x910 net/bluetooth/hci_sock.c:1060
>>  sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
>>  sock_ioctl+0x477/0x6a0 net/socket.c:1221
>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>  __do_sys_ioctl fs/ioctl.c:1069 [inline]
>>  __se_sys_ioctl fs/ioctl.c:1055 [inline]
>>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x446449
>> RSP: 002b:00007f36ab8342e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 00000000004cb400 RCX: 0000000000446449
>> RDX: 00000000200000c0 RSI: 00000000800448f0 RDI: 0000000000000004
>> RBP: 00000000004cb40c R08: 0000000000000000 R09: 0000000000000000
>> R10: ffffffffffffffff R11: 0000000000000246 R12: 0000000000000003
>> R13: 0000000000000004 R14: 00007f36ab8346b8 R15: 00000000004cb408
>> INFO: task syz-executor446:8491 blocked for more than 143 seconds.
>>       Not tainted 5.14.0-rc4-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor446 state:D stack:28176 pid: 8491 ppid:  8452 flags:0x00000004
>> Call Trace:
>>  context_switch kernel/sched/core.c:4683 [inline]
>>  __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
>>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
>>  hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
>>  hci_inquiry+0x6f4/0x9e0 net/bluetooth/hci_core.c:1357
>>  hci_sock_ioctl+0x1a7/0x910 net/bluetooth/hci_sock.c:1060
>>  sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
>>  sock_ioctl+0x477/0x6a0 net/socket.c:1221
>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>  __do_sys_ioctl fs/ioctl.c:1069 [inline]
>>  __se_sys_ioctl fs/ioctl.c:1055 [inline]
>>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x446449
>> RSP: 002b:00007f36ab8342e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 00000000004cb400 RCX: 0000000000446449
>> RDX: 00000000200000c0 RSI: 00000000800448f0 RDI: 0000000000000004
>> RBP: 00000000004cb40c R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
>> R13: 0000000000000004 R14: 00007f36ab8346b8 R15: 00000000004cb408
>> Showing all locks held in the system:
>> 6 locks held by kworker/u4:0/8:
>> 1 lock held by khungtaskd/1635:
>>  #0: ffffffff8b97c180 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
>> 1 lock held by in:imklog/8352:
>>  #0: ffff888033e1d4f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
>> 1 lock held by syz-executor446/8486:
>>  #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
>> 1 lock held by syz-executor446/8489:
>>  #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
>> 1 lock held by syz-executor446/8491:
>>  #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
> 
> Looks like too big timeout is passed from ioctl:
> 
> 
> C repro:
> 
>    *(uint16_t*)0x200000c0 = 0;
>    *(uint16_t*)0x200000c2 = 0;
>    memcpy((void*)0x200000c4, "\xf0\x08\xa7", 3);
>    *(uint8_t*)0x200000c7 = 0x81;	<- ir.length
>    *(uint8_t*)0x200000c8 = 0;
>    syscall(__NR_ioctl, r[0], 0x800448f0, 0x200000c0ul);
> 
> 
> Then ir.length * msecs_to_jiffies(2000) timeout is passed to
> hci_req_sync(). Task will stuck here
> 
> 	err = wait_event_interruptible_timeout(hdev->req_wait_q,
> 			hdev->req_status != HCI_REQ_PEND, timeout);
> 
> for 258 seconds (I guess, it's because of test environment, but, maybe, we should add sanity check for timeout value)

I agree. Feel free to send a patch.

Regards

Marcel

