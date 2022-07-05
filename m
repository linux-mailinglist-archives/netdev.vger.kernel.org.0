Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEE4566F8A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiGENmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiGENld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:41:33 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E82275CE;
        Tue,  5 Jul 2022 06:04:11 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8iDn-000658-TB; Tue, 05 Jul 2022 15:04:07 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8iDn-000Npc-B9; Tue, 05 Jul 2022 15:04:07 +0200
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 bpf_prog_ADDR_F
To:     syzbot <syzbot+66d306fee539916084c2@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, song@kernel.org
References: <0000000000008481dc05e2e17e7d@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b510513a-6786-f10b-ad48-9f28e74202d5@iogearbox.net>
Date:   Tue, 5 Jul 2022 15:04:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0000000000008481dc05e2e17e7d@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26594/Tue Jul  5 09:24:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/22 9:23 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    179a93f74b29 fprobe, samples: Add module parameter descrip..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=17bc8604080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=70e1a4d352a3c6ae
> dashboard link: https://syzkaller.appspot.com/bug?extid=66d306fee539916084c2
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.

Cc'ing Song, looks like UAF? Could potentially be related to the other triggered
warnings around the JIT from syzkaller recently.

> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+66d306fee539916084c2@syzkaller.appspotmail.com
> 
> BUG: unable to handle page fault for address: ffffffffa0000a18
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD ba8f067 P4D ba8f067 PUD ba90063 PMD 1451e6067 PTE 0
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 10814 Comm: syz-executor.2 Not tainted 5.19.0-rc2-syzkaller-00122-g179a93f74b29 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:bpf_prog_9d4bccaf8ccaf0dc_F+0x0/0xd
> Code: Unable to access opcode bytes at RIP 0xffffffffa00009ee.
> RSP: 0018:ffffc90003517250 EFLAGS: 00010046
> RAX: dffffc0000000000 RBX: ffffc90003563000 RCX: 0000000000000000
> RDX: 1ffff920006ac606 RSI: ffffc90003563048 RDI: 00000000ffff8880
> RBP: ffffc90003517258 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
> R13: ffff88802403bb00 R14: ffff88802fa60000 R15: 0000000000000001
> FS:  00007f63ca616700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa00009ee CR3: 000000002f068000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   bpf_dispatcher_nop_func include/linux/bpf.h:869 [inline]
>   __bpf_prog_run include/linux/filter.h:628 [inline]
>   bpf_prog_run include/linux/filter.h:635 [inline]
>   __bpf_trace_run kernel/trace/bpf_trace.c:2046 [inline]
>   bpf_trace_run4+0x124/0x360 kernel/trace/bpf_trace.c:2085
>   __bpf_trace_sched_switch+0x115/0x160 include/trace/events/sched.h:222
>   __traceiter_sched_switch+0x68/0xb0 include/trace/events/sched.h:222
>   trace_sched_switch include/trace/events/sched.h:222 [inline]
>   __schedule+0x145b/0x4b30 kernel/sched/core.c:6425
>   preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6593
>   preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
>   __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
>   _raw_spin_unlock+0x36/0x40 kernel/locking/spinlock.c:186
>   spin_unlock include/linux/spinlock.h:389 [inline]
>   __cond_resched_lock+0x93/0xe0 kernel/sched/core.c:8270
>   __purge_vmap_area_lazy+0x976/0x1c50 mm/vmalloc.c:1728
>   _vm_unmap_aliases.part.0+0x3f0/0x500 mm/vmalloc.c:2125
>   _vm_unmap_aliases mm/vmalloc.c:2099 [inline]
>   vm_remove_mappings mm/vmalloc.c:2624 [inline]
>   __vunmap+0x6d5/0xd30 mm/vmalloc.c:2651
>   __vfree+0x3c/0xd0 mm/vmalloc.c:2713
>   vfree+0x5a/0x90 mm/vmalloc.c:2744
>   bpf_jit_binary_free kernel/bpf/core.c:1080 [inline]
>   bpf_jit_free+0x21a/0x2b0 kernel/bpf/core.c:1203
>   jit_subprogs kernel/bpf/verifier.c:13683 [inline]
>   fixup_call_args kernel/bpf/verifier.c:13712 [inline]
>   bpf_check+0x71ab/0xbbc0 kernel/bpf/verifier.c:15063
>   bpf_prog_load+0xfb2/0x2250 kernel/bpf/syscall.c:2575
>   __sys_bpf+0x11a1/0x5700 kernel/bpf/syscall.c:4917
>   __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5019
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f63c9489109
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f63ca616168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f63c959c030 RCX: 00007f63c9489109
> RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
> RBP: 00007f63c94e305d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffde158863f R14: 00007f63ca616300 R15: 0000000000022000
>   </TASK>
> Modules linked in:
> CR2: ffffffffa0000a18
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bpf_prog_9d4bccaf8ccaf0dc_F+0x0/0xd
> Code: Unable to access opcode bytes at RIP 0xffffffffa00009ee.
> RSP: 0018:ffffc90003517250 EFLAGS: 00010046
> 
> RAX: dffffc0000000000 RBX: ffffc90003563000 RCX: 0000000000000000
> RDX: 1ffff920006ac606 RSI: ffffc90003563048 RDI: 00000000ffff8880
> RBP: ffffc90003517258 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
> R13: ffff88802403bb00 R14: ffff88802fa60000 R15: 0000000000000001
> FS:  00007f63ca616700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa00009ee CR3: 000000002f068000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

