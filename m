Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D727592EE2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 14:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241906AbiHOM3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 08:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241894AbiHOM3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 08:29:03 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45FE25EAC;
        Mon, 15 Aug 2022 05:29:02 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNZDH-0002QY-Cc; Mon, 15 Aug 2022 14:28:59 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNZDH-000CiP-10; Mon, 15 Aug 2022 14:28:59 +0200
Subject: Re: [syzbot] WARNING: suspicious RCU usage in bpf_sk_reuseport_detach
To:     syzbot <syzbot+24bcff6e82ce253f23ec@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, ecree.xilinx@gmail.com,
        edumazet@google.com, habetsm.xilinx@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
References: <0000000000007902fc05e6458697@google.com>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7119881e-5a7a-fd90-8d2f-87ce9cd45831@iogearbox.net>
Date:   Mon, 15 Aug 2022 14:28:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0000000000007902fc05e6458697@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26628/Mon Aug 15 09:51:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +Hawkins ]

On 8/15/22 12:59 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    94ce3b64c62d net/tls: Use RCU API to access tls_ctx->netdev
> git tree:       net
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14641e15080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53da55f2bdeb0d4c
> dashboard link: https://syzkaller.appspot.com/bug?extid=24bcff6e82ce253f23ec
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106c89fd080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ead885080000
> 
> The issue was bisected to:
> 
> commit f72c38fad234759fe943cb2e40bf3d0f7de1d4d9
> Author: Edward Cree <ecree.xilinx@gmail.com>
> Date:   Wed Jul 20 18:33:48 2022 +0000
> 
>      sfc: hook up ef100 representor TX

Looks rather related to:

commit 2a0133723f9ebeb751cfce19f74ec07e108bef1f
Author: Hawkins Jiawei <yin31149@gmail.com>
Date:   Fri Aug 5 15:48:34 2022 +0800

     net: fix refcount bug in sk_psock_get (2)

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=125bf9fd080000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=115bf9fd080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=165bf9fd080000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+24bcff6e82ce253f23ec@syzkaller.appspotmail.com
> Fixes: f72c38fad234 ("sfc: hook up ef100 representor TX")
> 
> =============================
> WARNING: suspicious RCU usage
> 5.19.0-syzkaller-05408-g94ce3b64c62d #0 Not tainted
> -----------------------------
> include/net/sock.h:592 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 4 locks held by syz-executor334/3611:
>   #0: ffff888073b7be10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:760 [inline]
>   #0: ffff888073b7be10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
>   #1: ffffc900014e5c28 (&table->hash[i].lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
>   #1: ffffc900014e5c28 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash net/ipv4/udp.c:2014 [inline]
>   #1: ffffc900014e5c28 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash+0x1d5/0x730 net/ipv4/udp.c:2004
>   #2: ffffffff8d7a9a78 (reuseport_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
>   #2: ffffffff8d7a9a78 (reuseport_lock){+...}-{2:2}, at: reuseport_detach_sock+0x22/0x4a0 net/core/sock_reuseport.c:346
>   #3: ffff888145f9a0b8 (clock-AF_INET){++..}-{2:2}, at: bpf_sk_reuseport_detach+0x26/0x190 kernel/bpf/reuseport_array.c:26
> 
> stack backtrace:
> CPU: 1 PID: 3611 Comm: syz-executor334 Not tainted 5.19.0-syzkaller-05408-g94ce3b64c62d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   __rcu_dereference_sk_user_data_with_flags include/net/sock.h:592 [inline]
>   bpf_sk_reuseport_detach+0x156/0x190 kernel/bpf/reuseport_array.c:27
>   reuseport_detach_sock+0x8c/0x4a0 net/core/sock_reuseport.c:362
>   udp_lib_unhash net/ipv4/udp.c:2016 [inline]
>   udp_lib_unhash+0x210/0x730 net/ipv4/udp.c:2004
>   sk_common_release+0xba/0x390 net/core/sock.c:3600
>   inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
>   __sock_release+0xcd/0x280 net/socket.c:650
>   sock_close+0x18/0x20 net/socket.c:1365
>   __fput+0x277/0x9d0 fs/file_table.c:320
>   task_work_run+0xdd/0x1a0 kernel/task_work.c:177
>   exit_task_work include/linux/task_work.h:38 [inline]
>   do_exit+0xade/0x29d0 kernel/exit.c:795
>   do_group_exit+0xd2/0x2f0 kernel/exit.c:925
>   __do_sys_exit_group kernel/exit.c:936 [inline]
>   __se_sys_exit_group kernel/exit.c:934 [inline]
>   __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fe407d09699
> Code: Unable to access opcode bytes at RIP 0x7fe407d0966f.
> RSP: 002b:00007ffc0ff152a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

