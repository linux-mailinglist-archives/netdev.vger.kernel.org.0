Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B04151CBE
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgBDO7R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Feb 2020 09:59:17 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:45212 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBDO7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 09:59:16 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id C4115CED29;
        Tue,  4 Feb 2020 16:08:36 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: KASAN: use-after-free Read in l2cap_sock_release
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200204094150.10272-1-hdanton@sina.com>
Date:   Tue, 4 Feb 2020 15:59:14 +0100
Cc:     syzbot <syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: 8BIT
Message-Id: <8BDF940B-F93A-40FF-AA60-334433D9A6F1@holtmann.org>
References: <20200204094150.10272-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

>> syzbot found the following crash on:
>> 
>> HEAD commit:    cee5a428 Add linux-next specific files for 20200203
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=167acbf1e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ea1325a05ecd7b98
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c3c5bdea7863886115dc
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> 
>> Unfortunately, I don't have any reproducer for this crash yet.
>> 
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com
>> 
>> can: request_module (can-proto-0) failed.
>> can: request_module (can-proto-0) failed.
>> can: request_module (can-proto-0) failed.
>> ==================================================================
>> BUG: KASAN: use-after-free in l2cap_sock_release+0x24c/0x290 net/bluetooth/l2cap_sock.c:1212
>> Read of size 8 at addr ffff8880944904a0 by task syz-fuzzer/9751
>> 
>> CPU: 0 PID: 9751 Comm: syz-fuzzer Not tainted 5.5.0-next-20200203-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>> __dump_stack lib/dump_stack.c:77 [inline]
>> dump_stack+0x197/0x210 lib/dump_stack.c:118
>> print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>> __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
>> kasan_report+0x12/0x20 mm/kasan/common.c:641
>> __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
>> l2cap_sock_release+0x24c/0x290 net/bluetooth/l2cap_sock.c:1212
>> __sock_release+0xce/0x280 net/socket.c:605
>> sock_close+0x1e/0x30 net/socket.c:1283
>> __fput+0x2ff/0x890 fs/file_table.c:280
>> ____fput+0x16/0x20 fs/file_table.c:313
>> task_work_run+0x145/0x1c0 kernel/task_work.c:113
>> tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>> exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
>> prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
>> syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
>> do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x4afb40
>> Code: 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 49 c7 c2 00 00 00 00 49 c7 c0 00 00 00 00 49 c7 c1 00 00 00 00 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
>> RSP: 002b:000000c00020b540 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
>> RAX: 0000000000000000 RBX: 000000c00002e500 RCX: 00000000004afb40
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
>> RBP: 000000c00020b580 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000000cc
>> R13: 00000000000000cb R14: 0000000000000200 R15: 0000000000000200
>> 
>> Allocated by task 9751:
>> save_stack+0x23/0x90 mm/kasan/common.c:72
>> set_track mm/kasan/common.c:80 [inline]
>> __kasan_kmalloc mm/kasan/common.c:515 [inline]
>> __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
>> kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
>> __do_kmalloc mm/slab.c:3656 [inline]
>> __kmalloc+0x163/0x770 mm/slab.c:3665
>> kmalloc include/linux/slab.h:560 [inline]
>> sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
>> sk_alloc+0x39/0xfd0 net/core/sock.c:1657
>> l2cap_sock_alloc.constprop.0+0x37/0x230 net/bluetooth/l2cap_sock.c:1603
>> l2cap_sock_create+0x11e/0x1c0 net/bluetooth/l2cap_sock.c:1649
>> bt_sock_create+0x16a/0x2d0 net/bluetooth/af_bluetooth.c:130
>> __sock_create+0x3ce/0x730 net/socket.c:1433
>> sock_create net/socket.c:1484 [inline]
>> __sys_socket+0x103/0x220 net/socket.c:1526
>> __do_sys_socket net/socket.c:1535 [inline]
>> __se_sys_socket net/socket.c:1533 [inline]
>> __x64_sys_socket+0x73/0xb0 net/socket.c:1533
>> do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> 
>> Freed by task 9751:
>> save_stack+0x23/0x90 mm/kasan/common.c:72
>> set_track mm/kasan/common.c:80 [inline]
>> kasan_set_free_info mm/kasan/common.c:337 [inline]
>> __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
>> kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
>> __cache_free mm/slab.c:3426 [inline]
>> kfree+0x10a/0x2c0 mm/slab.c:3757
>> sk_prot_free net/core/sock.c:1640 [inline]
>> __sk_destruct+0x5d8/0x7f0 net/core/sock.c:1724
>> sk_destruct+0xd5/0x110 net/core/sock.c:1739
>> __sk_free+0xfb/0x3f0 net/core/sock.c:1750
>> sk_free+0x83/0xb0 net/core/sock.c:1761
>> sock_put include/net/sock.h:1719 [inline]
>> l2cap_sock_kill+0x160/0x190 net/bluetooth/l2cap_sock.c:1058
>> l2cap_sock_release+0x1c3/0x290 net/bluetooth/l2cap_sock.c:1210
>> __sock_release+0xce/0x280 net/socket.c:605
>> sock_close+0x1e/0x30 net/socket.c:1283
>> __fput+0x2ff/0x890 fs/file_table.c:280
>> ____fput+0x16/0x20 fs/file_table.c:313
>> task_work_run+0x145/0x1c0 kernel/task_work.c:113
>> tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>> exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
>> prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
>> syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
>> do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> 
>> The buggy address belongs to the object at ffff888094490000
>> which belongs to the cache kmalloc-2k of size 2048
>> The buggy address is located 1184 bytes inside of
>> 2048-byte region [ffff888094490000, ffff888094490800)
>> The buggy address belongs to the page:
>> page:ffffea0002512400 refcount:1 mapcount:0 mapping:ffff8880aa400e00 index:0x0
>> flags: 0xfffe0000000200(slab)
>> raw: 00fffe0000000200 ffffea00025123c8 ffffea00021bf608 ffff8880aa400e00
>> raw: 0000000000000000 ffff888094490000 0000000100000001 0000000000000000
>> page dumped because: kasan: bad access detected
>> 
>> Memory state around the buggy address:
>> ffff888094490380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff888094490400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>> ffff888094490480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                               ^
>> ffff888094490500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff888094490580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ==================================================================
>> 
>> 
>> ---
>> This bug is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this bug report. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> 
> Prefetch channel before killing sock.
> 
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -1193,6 +1193,7 @@ static int l2cap_sock_release(struct soc
> {
> 	struct sock *sk = sock->sk;
> 	int err;
> +	struct l2cap_chan *chan;
> 
> 	BT_DBG("sock %p, sk %p", sock, sk);
> 
> @@ -1202,15 +1203,16 @@ static int l2cap_sock_release(struct soc
> 	bt_sock_unlink(&l2cap_sk_list, sk);
> 
> 	err = l2cap_sock_shutdown(sock, 2);
> +	chan = l2cap_pi(sk)->chan;
> 
> -	l2cap_chan_hold(l2cap_pi(sk)->chan);
> -	l2cap_chan_lock(l2cap_pi(sk)->chan);
> +	l2cap_chan_hold(chan);
> +	l2cap_chan_lock(chan);
> 
> 	sock_orphan(sk);
> 	l2cap_sock_kill(sk);
> 
> -	l2cap_chan_unlock(l2cap_pi(sk)->chan);
> -	l2cap_chan_put(l2cap_pi(sk)->chan);
> +	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
> 
> 	return err;
> }

please send a proper patch with commit message and everything. That way I can easily apply it.

Regards

Marcel

