Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6855D458869
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 04:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbhKVDo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 22:44:58 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:47319 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229862AbhKVDo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 22:44:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Uxb59a4_1637552508;
Received: from guwendeMacBook-Pro.local(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Uxb59a4_1637552508)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Nov 2021 11:41:49 +0800
Subject: Re: [syzbot] possible deadlock in smc_switch_to_fallback
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Dust Li <dust.li@linux.alibaba.com>, paskripkin@gmail.com
References: <0000000000003c221105d12f69e3@google.com>
 <20211119194813.179310a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <e99b6fae-8ba5-2b7b-87dc-01421790ec46@linux.alibaba.com>
Date:   Mon, 22 Nov 2021 11:41:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119194813.179310a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/20 11:48 am, Jakub Kicinski wrote:
> Adding Alibaba folks to CC.
> 
> On Fri, 19 Nov 2021 18:47:22 -0800 syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    9539ba4308ad Merge tag 'riscv-for-linus-5.16-rc2' of git:/..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17f79d01b00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e979d3597f48262cb4ee
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com
>>
>> ============================================
>> WARNING: possible recursive locking detected
>> 5.16.0-rc1-syzkaller #0 Not tainted
>> --------------------------------------------
>> syz-executor.3/1337 is trying to acquire lock:
>> ffff88809466ce58 (&ei->socket.wq.wait){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
>> ffff88809466ce58 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3d5/0x8c0 net/smc/af_smc.c:588
>>
>> but task is already holding lock:
>> ffff88809466c258 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3ca/0x8c0 net/smc/af_smc.c:587
>>
>> other info that might help us debug this:
>>   Possible unsafe locking scenario:
>>
>>         CPU0
>>         ----
>>    lock(&ei->socket.wq.wait);
>>    lock(&ei->socket.wq.wait);
>>
>>   *** DEADLOCK ***
>>
>>   May be due to missing lock nesting notation
>>
>> 2 locks held by syz-executor.3/1337:
>>   #0:
>> ffff888082ba8120 (sk_lock-AF_SMC){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1645 [inline]
>> ffff888082ba8120 (sk_lock-AF_SMC){+.+.}-{0:0}, at: smc_setsockopt+0x2b7/0xa40 net/smc/af_smc.c:2449
>>   #1: ffff88809466c258 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3ca/0x8c0 net/smc/af_smc.c:587
>>
>> stack backtrace:
>> CPU: 1 PID: 1337 Comm: syz-executor.3 Not tainted 5.16.0-rc1-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>   print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
>>   check_deadlock kernel/locking/lockdep.c:2999 [inline]
>>   validate_chain kernel/locking/lockdep.c:3788 [inline]
>>   __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5027
>>   lock_acquire kernel/locking/lockdep.c:5637 [inline]
>>   lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
>>   __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
>>   spin_lock include/linux/spinlock.h:349 [inline]
>>   smc_switch_to_fallback+0x3d5/0x8c0 net/smc/af_smc.c:588
>>   smc_setsockopt+0x8ee/0xa40 net/smc/af_smc.c:2459
>>   __sys_setsockopt+0x2db/0x610 net/socket.c:2176
>>   __do_sys_setsockopt net/socket.c:2187 [inline]
>>   __se_sys_setsockopt net/socket.c:2184 [inline]
>>   __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x7fa2a8fceae9
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fa2a6544188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
>> RAX: ffffffffffffffda RBX: 00007fa2a90e1f60 RCX: 00007fa2a8fceae9
>> RDX: 0000000000000021 RSI: 0000000000000006 RDI: 0000000000000005
>> RBP: 00007fa2a9028f6d R08: 0000000000000010 R09: 0000000000000000
>> R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007ffc2297067f R14: 00007fa2a6544300 R15: 0000000000022000
>>   </TASK>
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

We take this issue seriously and have started an investigation.

Thanks,
Wen Gu
