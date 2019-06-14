Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF146C6B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 00:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfFNWgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 18:36:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:60172 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFNWgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 18:36:43 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbuoF-0004Yi-FH; Sat, 15 Jun 2019 00:36:35 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbuoF-000ODy-6d; Sat, 15 Jun 2019 00:36:35 +0200
Subject: Re: [PATCH v2 bpf-next] bpf: sk_storage: Fix out of bounds memory
 access
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arthur Fabre <afabre@cloudflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190614093728.622-1-afabre@cloudflare.com>
 <CAEf4BzZNO8Px2BRcs5WMxfrfRaekxF=_fz_p2A+eL94L0DrfQg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6aaa3a2f-5da5-525f-89a1-59dddc1cfa53@iogearbox.net>
Date:   Sat, 15 Jun 2019 00:36:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZNO8Px2BRcs5WMxfrfRaekxF=_fz_p2A+eL94L0DrfQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/15/2019 12:31 AM, Andrii Nakryiko wrote:
> On Fri, Jun 14, 2019 at 2:45 AM Arthur Fabre <afabre@cloudflare.com> wrote:
>>
>> bpf_sk_storage maps use multiple spin locks to reduce contention.
>> The number of locks to use is determined by the number of possible CPUs.
>> With only 1 possible CPU, bucket_log == 0, and 2^0 = 1 locks are used.
>>
>> When updating elements, the correct lock is determined with hash_ptr().
>> Calling hash_ptr() with 0 bits is undefined behavior, as it does:
>>
>> x >> (64 - bits)
>>
>> Using the value results in an out of bounds memory access.
>> In my case, this manifested itself as a page fault when raw_spin_lock_bh()
>> is called later, when running the self tests:
>>
>> ./tools/testing/selftests/bpf/test_verifier 773 775
>>
>> [   16.366342] BUG: unable to handle page fault for address: ffff8fe7a66f93f8
>> [   16.367139] #PF: supervisor write access in kernel mode
>> [   16.367751] #PF: error_code(0x0002) - not-present page
>> [   16.368323] PGD 35a01067 P4D 35a01067 PUD 0
>> [   16.368796] Oops: 0002 [#1] SMP PTI
>> [   16.369175] CPU: 0 PID: 189 Comm: test_verifier Not tainted 5.2.0-rc2+ #10
>> [   16.369960] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>> [   16.371021] RIP: 0010:_raw_spin_lock_bh (/home/afabre/linux/./include/trace/events/initcall.h:48)
>> [ 16.371571] Code: 02 00 00 31 c0 ba ff 00 00 00 3e 0f b1 17 75 01 c3 e9 82 12 5f ff 66 90 65 81 05 ad 14 6f 41 00 02 00 00 31 c0 ba 01 00 00 00 <3e> 0f b1 17 75 01 c3 89 c6 e9 f0 02 5f ff b8 00 02 00 00 3e 0f c1
>> All code
>> ========
>>    0:   02 00                   add    (%rax),%al
>>    2:   00 31                   add    %dh,(%rcx)
>>    4:   c0 ba ff 00 00 00 3e    sarb   $0x3e,0xff(%rdx)
>>    b:   0f b1 17                cmpxchg %edx,(%rdi)
>>    e:   75 01                   jne    0x11
>>   10:   c3                      retq
>>   11:   e9 82 12 5f ff          jmpq   0xffffffffff5f1298
>>   16:   66 90                   xchg   %ax,%ax
>>   18:   65 81 05 ad 14 6f 41    addl   $0x200,%gs:0x416f14ad(%rip)        # 0x416f14d0
>>   1f:   00 02 00 00
>>   23:   31 c0                   xor    %eax,%eax
>>   25:   ba 01 00 00 00          mov    $0x1,%edx
>>   2a:   3e 0f b1 17             cmpxchg %edx,%ds:*(%rdi)                <-- trapping instruction
>>   2e:   75 01                   jne    0x31
>>   30:   c3                      retq
>>   31:   89 c6                   mov    %eax,%esi
>>   33:   e9 f0 02 5f ff          jmpq   0xffffffffff5f0328
>>   38:   b8 00 02 00 00          mov    $0x200,%eax
>>   3d:   3e                      ds
>>   3e:   0f                      .byte 0xf
>>   3f:   c1                      .byte 0xc1
>>
>> Code starting with the faulting instruction
>> ===========================================
>>    0:   3e 0f b1 17             cmpxchg %edx,%ds:(%rdi)
>>    4:   75 01                   jne    0x7
>>    6:   c3                      retq
>>    7:   89 c6                   mov    %eax,%esi
>>    9:   e9 f0 02 5f ff          jmpq   0xffffffffff5f02fe
>>    e:   b8 00 02 00 00          mov    $0x200,%eax
>>   13:   3e                      ds
>>   14:   0f                      .byte 0xf
>>   15:   c1                      .byte 0xc1
>> [   16.373398] RSP: 0018:ffffa759809d3be0 EFLAGS: 00010246
>> [   16.373954] RAX: 0000000000000000 RBX: ffff8fe7a66f93f0 RCX: 0000000000000040
>> [   16.374645] RDX: 0000000000000001 RSI: ffff8fdaf9f0d180 RDI: ffff8fe7a66f93f8
>> [   16.375338] RBP: ffff8fdaf9f0d180 R08: ffff8fdafba2c320 R09: ffff8fdaf9f0d0c0
>> [   16.376028] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8fdafa346700
>> [   16.376719] R13: ffff8fe7a66f93f8 R14: ffff8fdaf9f0d0c0 R15: 0000000000000001
>> [   16.377413] FS:  00007fda724c0740(0000) GS:ffff8fdafba00000(0000) knlGS:0000000000000000
>> [   16.378204] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   16.378763] CR2: ffff8fe7a66f93f8 CR3: 0000000139d1c006 CR4: 0000000000360ef0
>> [   16.379453] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   16.380144] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   16.380864] Call Trace:
>> [   16.381112] selem_link_map (/home/afabre/linux/./include/linux/compiler.h:221 /home/afabre/linux/net/core/bpf_sk_storage.c:243)
>> [   16.381476] sk_storage_update (/home/afabre/linux/net/core/bpf_sk_storage.c:355 /home/afabre/linux/net/core/bpf_sk_storage.c:414)
>> [   16.381888] bpf_sk_storage_get (/home/afabre/linux/net/core/bpf_sk_storage.c:760 /home/afabre/linux/net/core/bpf_sk_storage.c:741)
>> [   16.382285] ___bpf_prog_run (/home/afabre/linux/kernel/bpf/core.c:1447)
>> [   16.382679] ? __bpf_prog_run32 (/home/afabre/linux/kernel/bpf/core.c:1603)
>> [   16.383074] ? alloc_file_pseudo (/home/afabre/linux/fs/file_table.c:232)
>> [   16.383486] ? kvm_clock_get_cycles (/home/afabre/linux/arch/x86/kernel/kvmclock.c:98)
>> [   16.383906] ? ktime_get (/home/afabre/linux/kernel/time/timekeeping.c:265 /home/afabre/linux/kernel/time/timekeeping.c:369 /home/afabre/linux/kernel/time/timekeeping.c:754)
>> [   16.384243] ? bpf_test_run (/home/afabre/linux/net/bpf/test_run.c:47)
>> [   16.384613] ? bpf_prog_test_run_skb (/home/afabre/linux/net/bpf/test_run.c:313)
>> [   16.385065] ? security_capable (/home/afabre/linux/security/security.c:696 (discriminator 19))
>> [   16.385460] ? __do_sys_bpf (/home/afabre/linux/kernel/bpf/syscall.c:2072 /home/afabre/linux/kernel/bpf/syscall.c:2848)
>> [   16.385854] ? __handle_mm_fault (/home/afabre/linux/mm/memory.c:3507 /home/afabre/linux/mm/memory.c:3532 /home/afabre/linux/mm/memory.c:3666 /home/afabre/linux/mm/memory.c:3897 /home/afabre/linux/mm/memory.c:4021)
>> [   16.386273] ? __dentry_kill (/home/afabre/linux/fs/dcache.c:595)
>> [   16.386652] ? do_syscall_64 (/home/afabre/linux/arch/x86/entry/common.c:301)
>> [   16.387031] ? entry_SYSCALL_64_after_hwframe (/home/afabre/linux/./include/trace/events/initcall.h:10 /home/afabre/linux/./include/trace/events/initcall.h:10)
>> [   16.387541] Modules linked in:
>> [   16.387846] CR2: ffff8fe7a66f93f8
>> [   16.388175] ---[ end trace 891cf27b5b9c9cc6 ]---
>> [   16.388628] RIP: 0010:_raw_spin_lock_bh (/home/afabre/linux/./include/trace/events/initcall.h:48)
>> [ 16.389089] Code: 02 00 00 31 c0 ba ff 00 00 00 3e 0f b1 17 75 01 c3 e9 82 12 5f ff 66 90 65 81 05 ad 14 6f 41 00 02 00 00 31 c0 ba 01 00 00 00 <3e> 0f b1 17 75 01 c3 89 c6 e9 f0 02 5f ff b8 00 02 00 00 3e 0f c1
>> All code
>> ========
>>    0:   02 00                   add    (%rax),%al
>>    2:   00 31                   add    %dh,(%rcx)
>>    4:   c0 ba ff 00 00 00 3e    sarb   $0x3e,0xff(%rdx)
>>    b:   0f b1 17                cmpxchg %edx,(%rdi)
>>    e:   75 01                   jne    0x11
>>   10:   c3                      retq
>>   11:   e9 82 12 5f ff          jmpq   0xffffffffff5f1298
>>   16:   66 90                   xchg   %ax,%ax
>>   18:   65 81 05 ad 14 6f 41    addl   $0x200,%gs:0x416f14ad(%rip)        # 0x416f14d0
>>   1f:   00 02 00 00
>>   23:   31 c0                   xor    %eax,%eax
>>   25:   ba 01 00 00 00          mov    $0x1,%edx
>>   2a:   3e 0f b1 17             cmpxchg %edx,%ds:*(%rdi)                <-- trapping instruction
>>   2e:   75 01                   jne    0x31
>>   30:   c3                      retq
>>   31:   89 c6                   mov    %eax,%esi
>>   33:   e9 f0 02 5f ff          jmpq   0xffffffffff5f0328
>>   38:   b8 00 02 00 00          mov    $0x200,%eax
>>   3d:   3e                      ds
>>   3e:   0f                      .byte 0xf
>>   3f:   c1                      .byte 0xc1
>>
>> Code starting with the faulting instruction
>> ===========================================
>>    0:   3e 0f b1 17             cmpxchg %edx,%ds:(%rdi)
>>    4:   75 01                   jne    0x7
>>    6:   c3                      retq
>>    7:   89 c6                   mov    %eax,%esi
>>    9:   e9 f0 02 5f ff          jmpq   0xffffffffff5f02fe
>>    e:   b8 00 02 00 00          mov    $0x200,%eax
>>   13:   3e                      ds
>>   14:   0f                      .byte 0xf
>>   15:   c1                      .byte 0xc1
>> [   16.390899] RSP: 0018:ffffa759809d3be0 EFLAGS: 00010246
>> [   16.391410] RAX: 0000000000000000 RBX: ffff8fe7a66f93f0 RCX: 0000000000000040
>> [   16.392102] RDX: 0000000000000001 RSI: ffff8fdaf9f0d180 RDI: ffff8fe7a66f93f8
>> [   16.392795] RBP: ffff8fdaf9f0d180 R08: ffff8fdafba2c320 R09: ffff8fdaf9f0d0c0
>> [   16.393481] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8fdafa346700
>> [   16.394169] R13: ffff8fe7a66f93f8 R14: ffff8fdaf9f0d0c0 R15: 0000000000000001
>> [   16.394870] FS:  00007fda724c0740(0000) GS:ffff8fdafba00000(0000) knlGS:0000000000000000
>> [   16.395641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   16.396193] CR2: ffff8fe7a66f93f8 CR3: 0000000139d1c006 CR4: 0000000000360ef0
>> [   16.396876] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   16.397557] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   16.398246] Kernel panic - not syncing: Fatal exception in interrupt
>> [   16.399067] Kernel Offset: 0x3ce00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>> [   16.400098] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
>>
> 
> I think the bug is pretty clear without this detailed example, I'd
> remove it from commit message.
> 
>> Force the minimum number of locks to two.
>>
>> Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
>> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")

The offending commit is already in Linus tree hence if so bpf tree. Arthur, please
elaborate why bpf-next is targeted specifically here?

Thanks,
Daniel
