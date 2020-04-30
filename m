Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209B01BFE64
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgD3Odh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:33:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:47190 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgD3Odh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:33:37 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUAFo-0000Xz-Tz; Thu, 30 Apr 2020 16:33:33 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUAFo-0001Sb-H9; Thu, 30 Apr 2020 16:33:32 +0200
Subject: Re: KASAN: use-after-free Write in bpf_link_put
To:     syzbot <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000006780dc05a47ed632@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2ae442cb-b6ab-0624-a2a0-0f98a5c217bf@iogearbox.net>
Date:   Thu, 30 Apr 2020 16:33:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0000000000006780dc05a47ed632@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25798/Thu Apr 30 14:03:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 11:39 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    449e14bf bpf: Fix unused variable warning
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=109eb5f8100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=16d87c420507d444
> dashboard link: https://syzkaller.appspot.com/bug?extid=39b64425f91b5aab714d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in atomic64_dec_and_test include/asm-generic/atomic-instrumented.h:1557 [inline]
> BUG: KASAN: use-after-free in bpf_link_put+0x19/0x1b0 kernel/bpf/syscall.c:2255
> Write of size 8 at addr ffff8880a7248800 by task syz-executor.0/28011

Andrii, ptal, thanks!

> CPU: 0 PID: 28011 Comm: syz-executor.0 Not tainted 5.7.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x188/0x20d lib/dump_stack.c:118
>   print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
>   __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
>   kasan_report+0x33/0x50 mm/kasan/common.c:625
>   check_memory_region_inline mm/kasan/generic.c:187 [inline]
>   check_memory_region+0x141/0x190 mm/kasan/generic.c:193
>   atomic64_dec_and_test include/asm-generic/atomic-instrumented.h:1557 [inline]
>   bpf_link_put+0x19/0x1b0 kernel/bpf/syscall.c:2255
>   bpf_link_release+0x33/0x40 kernel/bpf/syscall.c:2270
>   __fput+0x33e/0x880 fs/file_table.c:280
>   task_work_run+0xf4/0x1b0 kernel/task_work.c:123
>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
>   prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
>   do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
>   entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x7fc891a66469
> Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007fc892156db8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: fffffffffffffff4 RBX: 000000000042c4e0 RCX: 00007fc891a66469
> RDX: 0000000000000010 RSI: 0000000020000040 RDI: 000000000000001c
> RBP: 00000000006abf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
> R13: 000000000000004f R14: 0000000000415473 R15: 00007fc8921575c0
> 
> Allocated by task 28011:
>   save_stack+0x1b/0x40 mm/kasan/common.c:49
>   set_track mm/kasan/common.c:57 [inline]
>   __kasan_kmalloc mm/kasan/common.c:495 [inline]
>   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
>   kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
>   kmalloc include/linux/slab.h:555 [inline]
>   kzalloc include/linux/slab.h:669 [inline]
>   cgroup_bpf_link_attach+0x13d/0x5b0 kernel/bpf/cgroup.c:894
>   link_create kernel/bpf/syscall.c:3765 [inline]
>   __do_sys_bpf+0x238c/0x46d0 kernel/bpf/syscall.c:3987
>   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>   entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Freed by task 28011:
>   save_stack+0x1b/0x40 mm/kasan/common.c:49
>   set_track mm/kasan/common.c:57 [inline]
>   kasan_set_free_info mm/kasan/common.c:317 [inline]
>   __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
>   __cache_free mm/slab.c:3426 [inline]
>   kfree+0x109/0x2b0 mm/slab.c:3757
>   cgroup_bpf_link_attach+0x2bc/0x5b0 kernel/bpf/cgroup.c:906
>   link_create kernel/bpf/syscall.c:3765 [inline]
>   __do_sys_bpf+0x238c/0x46d0 kernel/bpf/syscall.c:3987
>   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>   entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> The buggy address belongs to the object at ffff8880a7248800
>   which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 0 bytes inside of
>   128-byte region [ffff8880a7248800, ffff8880a7248880)
> The buggy address belongs to the page:
> page:ffffea00029c9200 refcount:1 mapcount:0 mapping:00000000a3d4ec31 index:0xffff8880a7248700
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea00024ceac8 ffffea000251d3c8 ffff8880aa000700
> raw: ffff8880a7248700 ffff8880a7248000 000000010000000f 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>   ffff8880a7248700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8880a7248780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff8880a7248800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff8880a7248880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8880a7248900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

