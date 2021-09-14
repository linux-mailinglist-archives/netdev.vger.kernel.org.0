Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8879B40A74B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 09:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbhINHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 03:25:15 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58733 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhINHZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 03:25:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UoM7Kz5_1631604232;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoM7Kz5_1631604232)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Sep 2021 15:23:53 +0800
Subject: Re: [PATCH] perf: fix panic by disable ftrace on fault.c
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:X86 MM" <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <d16e7188-1afa-7513-990c-804811747bcb@linux.alibaba.com>
 <d85f9710-67c9-2573-07c4-05d9c677d615@intel.com>
 <d8853e49-8b34-4632-3e29-012eb605bea9@linux.alibaba.com>
 <09777a57-a771-5e17-7e17-afc03ea9b83b@linux.alibaba.com>
Message-ID: <4f63c8bc-1d09-1717-cf81-f9091a9f9fb0@linux.alibaba.com>
Date:   Tue, 14 Sep 2021 15:23:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <09777a57-a771-5e17-7e17-afc03ea9b83b@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/14 上午11:02, 王贇 wrote:
[snip]
> [   44.133509][    C0] traps: PANIC: double fault, error_code: 0x0
> [   44.133519][    C0] double fault: 0000 [#1] SMP PTI
> [   44.133526][    C0] CPU: 0 PID: 743 Comm: a.out Not tainted 5.14.0-next-20210913 #469
> [   44.133532][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   44.133536][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
> [   44.133549][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 09 20 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 3b d2 7e
> [   44.133556][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046

Another information is that I have printed '__this_cpu_ist_bottom_va(NMI)'
on cpu0, which is just the RSP fffffe000000b000, does this imply
we got an overflowed NMI stack?

Regards,
Michael Wang


> [   44.133562][    C0] RAX: 0000000080120007 RBX: fffffe000000b050 RCX: 0000000000000000
> [   44.133566][    C0] RDX: ffff888106dd8000 RSI: ffffffff81269031 RDI: 000000000000001c
> [   44.133570][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
> [   44.133574][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [   44.133578][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000001
> [   44.133582][    C0] FS:  00007f5f39086740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> [   44.133588][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   44.133593][    C0] CR2: fffffe000000aff8 CR3: 0000000105894005 CR4: 00000000003606f0
> [   44.133597][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   44.133600][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   44.133604][    C0] Call Trace:
> [   44.133607][    C0]  <NMI>
> [   44.133610][    C0]  perf_trace_buf_alloc+0x26/0xd0
> [   44.133623][    C0]  ? is_prefetch.isra.25+0x260/0x260
> [   44.133631][    C0]  ? __bad_area_nosemaphore+0x1b8/0x280
> [   44.133637][    C0]  perf_ftrace_function_call+0x18f/0x2e0
> [   44.133649][    C0]  ? perf_trace_buf_alloc+0xbf/0xd0
> [   44.133687][    C0]  ? 0xffffffffa00b0083
> [   44.133714][    C0]  0xffffffffa00b0083
> [   44.133733][    C0]  ? 0xffffffffa00b0083
> [   44.133753][    C0]  ? kernelmode_fixup_or_oops+0x5/0x120
> [   44.133773][    C0]  kernelmode_fixup_or_oops+0x5/0x120
> [   44.133780][    C0]  __bad_area_nosemaphore+0x1b8/0x280
> [   44.133799][    C0]  do_user_addr_fault+0x410/0x920
> [   44.133815][    C0]  ? 0xffffffffa00b0083
> [   44.133832][    C0]  exc_page_fault+0x92/0x300
> [   44.133849][    C0]  asm_exc_page_fault+0x1e/0x30
> [   44.133857][    C0] RIP: 0010:__get_user_nocheck_8+0x6/0x13
> [   44.133866][    C0] Code: 01 ca c3 90 0f 01 cb 0f ae e8 0f b7 10 31 c0 0f 01 ca c3 90 0f 01 cb 0f ae e8 8b 10 31 c0 0f 01 ca c3 66 90 0f 01 cb 0f ae e8 <48> 8b 10 31 c0 0f 01 ca c3 90 0f 01 ca 31 d2 48 c7 c0 f2 ff ff ff
> [   44.133872][    C0] RSP: 0018:fffffe000000b370 EFLAGS: 00050046
> [   44.133877][    C0] RAX: 0000000000000000 RBX: fffffe000000b3d0 RCX: 0000000000000000
> [   44.133881][    C0] RDX: ffff888106dd8000 RSI: ffffffff8100a8ee RDI: fffffe000000b3d0
> [   44.133885][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> [   44.133889][    C0] R10: 0000000000000000 R11: 0000000000000014 R12: 00007fffffffeff0
> [   44.133893][    C0] R13: ffff888106dd8000 R14: 000000000000007f R15: 000000000000007f
> [   44.133920][    C0]  ? perf_callchain_user+0x25e/0x2f0
> [   44.133940][    C0]  perf_callchain_user+0x266/0x2f0
> [   44.133961][    C0]  get_perf_callchain+0x194/0x210
> [   44.133992][    C0]  perf_callchain+0xa3/0xc0
> [   44.134010][    C0]  perf_prepare_sample+0xa5/0xa60
> [   44.134037][    C0]  perf_event_output_forward+0x7b/0x1b0
> [   44.134051][    C0]  ? perf_swevent_get_recursion_context+0x62/0x70
> [   44.134062][    C0]  ? perf_trace_buf_alloc+0xbf/0xd0
> [   44.134080][    C0]  __perf_event_overflow+0x67/0x120
> [   44.134096][    C0]  perf_swevent_overflow+0xcb/0x110
> [   44.134114][    C0]  perf_swevent_event+0xb0/0xf0
> [   44.134128][    C0]  perf_tp_event+0x292/0x410
> [   44.134135][    C0]  ? 0xffffffffa00b0083
> [   44.134170][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xc0
> [   44.134179][    C0]  ? perf_swevent_event+0x28/0xf0
> [   44.134192][    C0]  ? perf_tp_event+0x2d7/0x410
> [   44.134200][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xc0
> [   44.134208][    C0]  ? perf_swevent_event+0x28/0xf0
> [   44.134221][    C0]  ? perf_tp_event+0x2d7/0x410
> [   44.134230][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xc0
> [   44.134250][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xc0
> [   44.134257][    C0]  ? perf_swevent_event+0x28/0xf0
> [   44.134284][    C0]  ? perf_trace_run_bpf_submit+0x87/0xc0
> [   44.134295][    C0]  ? perf_trace_buf_alloc+0x86/0xd0
> [   44.134302][    C0]  perf_trace_run_bpf_submit+0x87/0xc0
> [   44.134327][    C0]  perf_trace_lock_acquire+0x12b/0x170
> [   44.134360][    C0]  lock_acquire+0x1bf/0x2e0
> [   44.134370][    C0]  ? perf_output_begin+0x5/0x4b0
> [   44.134401][    C0]  perf_output_begin+0x70/0x4b0
> [   44.134408][    C0]  ? perf_output_begin+0x5/0x4b0
> [   44.134446][    C0]  perf_log_throttle+0xe2/0x1a0
> [   44.134484][    C0]  ? 0xffffffffa00b0083
> [   44.134500][    C0]  ? perf_event_update_userpage+0x135/0x2d0
> [   44.134515][    C0]  ? 0xffffffffa00b0083
> [   44.134524][    C0]  ? 0xffffffffa00b0083
> [   44.134548][    C0]  ? perf_event_update_userpage+0x135/0x2d0
> [   44.134559][    C0]  ? rcu_read_lock_held_common+0x5/0x40
> [   44.134573][    C0]  ? rcu_read_lock_held_common+0xe/0x40
> [   44.134582][    C0]  ? rcu_read_lock_sched_held+0x23/0x80
> [   44.134593][    C0]  ? lock_release+0xc7/0x2b0
> [   44.134615][    C0]  ? __perf_event_account_interrupt+0x116/0x160
> [   44.134631][    C0]  __perf_event_account_interrupt+0x116/0x160
> [   44.134644][    C0]  __perf_event_overflow+0x3e/0x120
> [   44.134660][    C0]  handle_pmi_common+0x30f/0x400
> [   44.134666][    C0]  ? perf_ftrace_function_call+0x268/0x2e0
> [   44.134676][    C0]  ? perf_ftrace_function_call+0x53/0x2e0
> [   44.134719][    C0]  ? 0xffffffffa00b0083
> [   44.134745][    C0]  ? 0xffffffffa00b0083
> [   44.134789][    C0]  ? intel_pmu_handle_irq+0x120/0x620
> [   44.134798][    C0]  ? handle_pmi_common+0x5/0x400
> [   44.134804][    C0]  intel_pmu_handle_irq+0x120/0x620
> [   44.134828][    C0]  perf_event_nmi_handler+0x30/0x50
> [   44.134840][    C0]  nmi_handle+0xba/0x2a0
> [   44.134866][    C0]  default_do_nmi+0x45/0xf0
> [   44.134878][    C0]  exc_nmi+0x155/0x170
> [   44.134895][    C0]  end_repeat_nmi+0x16/0x55
> [   44.134903][    C0] RIP: 0010:__sanitizer_cov_trace_pc+0x7/0x60
> [   44.134912][    C0] Code: c0 81 e2 00 01 ff 00 75 10 65 48 8b 04 25 c0 71 01 00 48 8b 80 90 15 00 00 f3 c3 0f 1f 84 00 00 00 00 00 65 8b 05 89 76 e0 7e <89> c1 48 8b 34 24 65 48 8b 14 25 c0 71 01 00 81 e1 00 01 00 00 a9
> [   44.134917][    C0] RSP: 0000:ffffc90000003dd0 EFLAGS: 00000046
> [   44.134923][    C0] RAX: 0000000080010003 RBX: ffffffff82a1db40 RCX: 0000000000000000
> [   44.134927][    C0] RDX: ffff888106dd8000 RSI: ffffffff810122fa RDI: 0000000000000000
> [   44.134931][    C0] RBP: ffff88813bc41f58 R08: ffff888106dd8a68 R09: 00000000fffffffe
> [   44.134934][    C0] R10: ffffc90000003be0 R11: 00000000ffd03bc8 R12: ffff88813bc118a0
> [   44.134938][    C0] R13: ffff88813bc41e50 R14: 0000000000000000 R15: ffffffff82a1db40
> [   44.134966][    C0]  ? __intel_pmu_enable_all.constprop.47+0x6a/0x100
> [   44.134987][    C0]  ? __sanitizer_cov_trace_pc+0x7/0x60
> [   44.135005][    C0]  ? kcov_common_handle+0x30/0x30
> [   44.135019][    C0]  </NMI>
> [   44.135021][    C0] WARNING: stack recursion on stack type 6
> [   44.135024][    C0] Modules linked in:
> [   44.252321][    C0] ---[ end trace 74f641c0b984aec5 ]---
> [   44.252325][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
> [   44.252335][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 09 20 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 3b d2 7e
> [   44.252341][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
> [   44.252347][    C0] RAX: 0000000080120007 RBX: fffffe000000b050 RCX: 0000000000000000
> [   44.252351][    C0] RDX: ffff888106dd8000 RSI: ffffffff81269031 RDI: 000000000000001c
> [   44.252355][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
> [   44.252358][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [   44.252362][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000001
> [   44.252366][    C0] FS:  00007f5f39086740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> [   44.252373][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   44.252377][    C0] CR2: fffffe000000aff8 CR3: 0000000105894005 CR4: 00000000003606f0
> [   44.252381][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   44.252384][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   44.252389][    C0] Kernel panic - not syncing: Fatal exception in interrupt
> [   44.252783][    C0] Kernel Offset: disabled
> 
> 
> 
> 
> 
> 
>>
>> [   58.999453][    C0] traps: PANIC: double fault, error_code: 0x0
>> [   58.999472][    C0] double fault: 0000 [#1] SMP PTI
>> [   58.999478][    C0] CPU: 0 PID: 799 Comm: a.out Not tainted 5.14.0+ #107
>> [   58.999485][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>> [   58.999488][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
>> [   58.999505][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 89 18 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 34 d2 7e
>> [   58.999511][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
>> [   58.999517][    C0] RAX: 0000000080120005 RBX: fffffe000000b050 RCX: 0000000000000000
>> [   58.999522][    C0] RDX: ffff888106f5a180 RSI: ffffffff812696d1 RDI: 000000000000001c
>> [   58.999526][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
>> [   58.999530][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>> [   58.999533][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000001
>> [   58.999537][    C0] FS:  00007f21fc62c740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
>> [   58.999543][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   58.999547][    C0] CR2: fffffe000000aff8 CR3: 0000000106e2e001 CR4: 00000000003606f0
>> [   58.999551][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   58.999555][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   58.999559][    C0] Call Trace:
>> [   58.999562][    C0]  <NMI>
>> [   58.999565][    C0]  perf_trace_buf_alloc+0x26/0xd0
>> [   58.999579][    C0]  ? is_prefetch.isra.25+0x260/0x260
>> [   58.999586][    C0]  ? __bad_area_nosemaphore+0x1b8/0x280
>> [   58.999592][    C0]  perf_ftrace_function_call+0x18f/0x2e0
>> [   58.999604][    C0]  ? perf_trace_buf_alloc+0xbf/0xd0
>> [   58.999642][    C0]  ? 0xffffffffa00ba083
>> [   58.999669][    C0]  0xffffffffa00ba083
>> [   58.999688][    C0]  ? 0xffffffffa00ba083
>> [   58.999708][    C0]  ? kernelmode_fixup_or_oops+0x5/0x120
>> [   58.999721][    C0]  kernelmode_fixup_or_oops+0x5/0x120
>> [   58.999728][    C0]  __bad_area_nosemaphore+0x1b8/0x280
>> [   58.999747][    C0]  do_user_addr_fault+0x410/0x920
>> [   58.999763][    C0]  ? 0xffffffffa00ba083
>> [   58.999780][    C0]  exc_page_fault+0x92/0x300
>> [   58.999796][    C0]  asm_exc_page_fault+0x1e/0x30
>> [   58.999805][    C0] RIP: 0010:__get_user_nocheck_8+0x6/0x13
>> [   58.999814][    C0] Code: 01 ca c3 90 0f 01 cb 0f ae e8 0f b7 10 31 c0 0f 01 ca c3 90 0f 01 cb 0f ae e8 8b 10 31 c0 0f 01 ca c3 66 90 0f 01 cb 0f ae e8 <48> 8b 10 31 c0 0f 01 ca c3 90 0f 01 ca 31 d2 48 c7 c0 f2 ff ff ff
>> [   58.999819][    C0] RSP: 0018:fffffe000000b370 EFLAGS: 00050046
>> [   58.999825][    C0] RAX: 0000000000000000 RBX: fffffe000000b3d0 RCX: 0000000000000000
>> [   58.999828][    C0] RDX: ffff888106f5a180 RSI: ffffffff8100a91e RDI: fffffe000000b3d0
>> [   58.999832][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
>> [   58.999836][    C0] R10: 0000000000000000 R11: 0000000000000014 R12: 00007fffffffeff0
>> [   58.999839][    C0] R13: ffff888106f5a180 R14: 000000000000007f R15: 000000000000007f
>> [   58.999867][    C0]  ? perf_callchain_user+0x25e/0x2f0
>> [   58.999886][    C0]  perf_callchain_user+0x266/0x2f0
>> [   58.999907][    C0]  get_perf_callchain+0x194/0x210
>> [   58.999938][    C0]  perf_callchain+0xa3/0xc0
>> [   58.999956][    C0]  perf_prepare_sample+0xa5/0xa60
>> [   58.999984][    C0]  perf_event_output_forward+0x7b/0x1b0
>> [   58.999996][    C0]  ? perf_swevent_get_recursion_context+0x62/0x70
>> [   59.000008][    C0]  ? perf_trace_buf_alloc+0xbf/0xd0
>> [   59.000026][    C0]  __perf_event_overflow+0x67/0x120
>> [   59.000042][    C0]  perf_swevent_overflow+0xcb/0x110
>> [   59.000065][    C0]  perf_swevent_event+0xb0/0xf0
>> [   59.000078][    C0]  perf_tp_event+0x292/0x410
>> [   59.000085][    C0]  ? 0xffffffffa00ba083
>> [   59.000120][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xa0
>> [   59.000129][    C0]  ? perf_swevent_event+0x28/0xf0
>> [   59.000142][    C0]  ? perf_tp_event+0x2d7/0x410
>> [   59.000150][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xa0
>> [   59.000157][    C0]  ? perf_swevent_event+0x28/0xf0
>> [   59.000171][    C0]  ? perf_tp_event+0x2d7/0x410
>> [   59.000179][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xa0
>> [   59.000198][    C0]  ? tracing_gen_ctx_irq_test+0x8f/0xa0
>> [   59.000206][    C0]  ? perf_swevent_event+0x28/0xf0
>> [   59.000233][    C0]  ? perf_trace_run_bpf_submit+0x87/0xc0
>> [   59.000244][    C0]  ? perf_trace_buf_alloc+0x86/0xd0
>> [   59.000250][    C0]  perf_trace_run_bpf_submit+0x87/0xc0
>> [   59.000276][    C0]  perf_trace_lock_acquire+0x12b/0x170
>> [   59.000308][    C0]  lock_acquire+0x1bf/0x2e0
>> [   59.000317][    C0]  ? perf_output_begin+0x5/0x4b0
>> [   59.000348][    C0]  perf_output_begin+0x70/0x4b0
>> [   59.000356][    C0]  ? perf_output_begin+0x5/0x4b0
>> [   59.000394][    C0]  perf_log_throttle+0xe2/0x1a0
>> [   59.000431][    C0]  ? 0xffffffffa00ba083
>> [   59.000447][    C0]  ? perf_event_update_userpage+0x135/0x2d0
>> [   59.000462][    C0]  ? 0xffffffffa00ba083
>> [   59.000471][    C0]  ? 0xffffffffa00ba083
>> [   59.000495][    C0]  ? perf_event_update_userpage+0x135/0x2d0
>> [   59.000506][    C0]  ? rcu_read_lock_held_common+0x5/0x40
>> [   59.000519][    C0]  ? rcu_read_lock_held_common+0xe/0x40
>> [   59.000528][    C0]  ? rcu_read_lock_sched_held+0x23/0x80
>> [   59.000539][    C0]  ? lock_release+0xc7/0x2b0
>> [   59.000560][    C0]  ? __perf_event_account_interrupt+0x116/0x160
>> [   59.000576][    C0]  __perf_event_account_interrupt+0x116/0x160
>> [   59.000589][    C0]  __perf_event_overflow+0x3e/0x120
>> [   59.000604][    C0]  handle_pmi_common+0x30f/0x400
>> [   59.000611][    C0]  ? perf_ftrace_function_call+0x268/0x2e0
>> [   59.000620][    C0]  ? perf_ftrace_function_call+0x53/0x2e0
>> [   59.000663][    C0]  ? 0xffffffffa00ba083
>> [   59.000689][    C0]  ? 0xffffffffa00ba083
>> [   59.000729][    C0]  ? intel_pmu_handle_irq+0x120/0x620
>> [   59.000737][    C0]  ? handle_pmi_common+0x5/0x400
>> [   59.000743][    C0]  intel_pmu_handle_irq+0x120/0x620
>> [   59.000767][    C0]  perf_event_nmi_handler+0x30/0x50
>> [   59.000779][    C0]  nmi_handle+0xba/0x2a0
>> [   59.000806][    C0]  default_do_nmi+0x45/0xf0
>> [   59.000819][    C0]  exc_nmi+0x155/0x170
>> [   59.000838][    C0]  end_repeat_nmi+0x16/0x55
>> [   59.000845][    C0] RIP: 0010:__sanitizer_cov_trace_pc+0xd/0x60
>> [   59.000853][    C0] Code: 00 75 10 65 48 8b 04 25 c0 71 01 00 48 8b 80 88 15 00 00 f3 c3 0f 1f 84 00 00 00 00 00 65 8b 05 09 77 e0 7e 89 c1 48 8b 34 24 <65> 48 8b 14 25 c0 71 01 00 81 e1 00 01 00 00 a9 00 01 ff 00 74 10
>> [   59.000858][    C0] RSP: 0000:ffffc90000003dd0 EFLAGS: 00000046
>> [   59.000863][    C0] RAX: 0000000080010001 RBX: ffffffff82a1db40 RCX: 0000000080010001
>> [   59.000867][    C0] RDX: ffff888106f5a180 RSI: ffffffff81009613 RDI: 0000000000000000
>> [   59.000871][    C0] RBP: ffff88813bc40d08 R08: ffff888106f5abb8 R09: 00000000fffffffe
>> [   59.000875][    C0] R10: ffffc90000003be0 R11: 00000000ffd17b4b R12: ffff88813bc118a0
>> [   59.000878][    C0] R13: ffff88813bc40c00 R14: 0000000000000000 R15: ffffffff82a1db40
>> [   59.000906][    C0]  ? x86_pmu_enable+0x383/0x440
>> [   59.000924][    C0]  ? __sanitizer_cov_trace_pc+0xd/0x60
>> [   59.000942][    C0]  ? intel_pmu_handle_irq+0x284/0x620
>> [   59.000954][    C0]  </NMI>
>> [   59.000957][    C0] WARNING: stack recursion on stack type 6
>> [   59.000960][    C0] Modules linked in:
>> [   59.120070][    C0] ---[ end trace 07eb1e3908914794 ]---
>> [   59.120075][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
>> [   59.120087][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 89 18 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 34 d2 7e
>> [   59.120092][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
>> [   59.120098][    C0] RAX: 0000000080120005 RBX: fffffe000000b050 RCX: 0000000000000000
>> [   59.120102][    C0] RDX: ffff888106f5a180 RSI: ffffffff812696d1 RDI: 000000000000001c
>> [   59.120106][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
>> [   59.120110][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>> [   59.120114][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000001
>> [   59.120118][    C0] FS:  00007f21fc62c740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
>> [   59.120125][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   59.120129][    C0] CR2: fffffe000000aff8 CR3: 0000000106e2e001 CR4: 00000000003606f0
>> [   59.120133][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   59.120137][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   59.120141][    C0] Kernel panic - not syncing: Fatal exception in interrupt
>> [   59.120540][    C0] Kernel Offset: disabled
>>
>> And below is the way of reproduce:
>>
>>
>> // autogenerated by syzkaller (https://github.com/google/syzkaller)
>>
>> #define _GNU_SOURCE
>>
>> #include <dirent.h>
>> #include <endian.h>
>> #include <errno.h>
>> #include <fcntl.h>
>> #include <signal.h>
>> #include <stdarg.h>
>> #include <stdbool.h>
>> #include <stdint.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <string.h>
>> #include <sys/prctl.h>
>> #include <sys/stat.h>
>> #include <sys/syscall.h>
>> #include <sys/types.h>
>> #include <sys/wait.h>
>> #include <time.h>
>> #include <unistd.h>
>>
>> static void sleep_ms(uint64_t ms)
>> {
>> 	usleep(ms * 1000);
>> }
>>
>> static uint64_t current_time_ms(void)
>> {
>> 	struct timespec ts;
>> 	if (clock_gettime(CLOCK_MONOTONIC, &ts))
>> 	exit(1);
>> 	return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
>> }
>>
>> #define BITMASK(bf_off,bf_len) (((1ull << (bf_len)) - 1) << (bf_off))
>> #define STORE_BY_BITMASK(type,htobe,addr,val,bf_off,bf_len) *(type*)(addr) = htobe((htobe(*(type*)(addr)) & ~BITMASK((bf_off), (bf_len))) | (((type)(val) << (bf_off)) & BITMASK((bf_off), (bf_len))))
>>
>> static bool write_file(const char* file, const char* what, ...)
>> {
>> 	char buf[1024];
>> 	va_list args;
>> 	va_start(args, what);
>> 	vsnprintf(buf, sizeof(buf), what, args);
>> 	va_end(args);
>> 	buf[sizeof(buf) - 1] = 0;
>> 	int len = strlen(buf);
>> 	int fd = open(file, O_WRONLY | O_CLOEXEC);
>> 	if (fd == -1)
>> 		return false;
>> 	if (write(fd, buf, len) != len) {
>> 		int err = errno;
>> 		close(fd);
>> 		errno = err;
>> 		return false;
>> 	}
>> 	close(fd);
>> 	return true;
>> }
>>
>> static void kill_and_wait(int pid, int* status)
>> {
>> 	kill(-pid, SIGKILL);
>> 	kill(pid, SIGKILL);
>> 	for (int i = 0; i < 100; i++) {
>> 		if (waitpid(-1, status, WNOHANG | __WALL) == pid)
>> 			return;
>> 		usleep(1000);
>> 	}
>> 	DIR* dir = opendir("/sys/fs/fuse/connections");
>> 	if (dir) {
>> 		for (;;) {
>> 			struct dirent* ent = readdir(dir);
>> 			if (!ent)
>> 				break;
>> 			if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
>> 				continue;
>> 			char abort[300];
>> 			snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort", ent->d_name);
>> 			int fd = open(abort, O_WRONLY);
>> 			if (fd == -1) {
>> 				continue;
>> 			}
>> 			if (write(fd, abort, 1) < 0) {
>> 			}
>> 			close(fd);
>> 		}
>> 		closedir(dir);
>> 	} else {
>> 	}
>> 	while (waitpid(-1, status, __WALL) != pid) {
>> 	}
>> }
>>
>> static void setup_test()
>> {
>> 	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
>> 	setpgrp();
>> 	write_file("/proc/self/oom_score_adj", "1000");
>> }
>>
>> static void execute_one(void);
>>
>> #define WAIT_FLAGS __WALL
>>
>> static void loop(void)
>> {
>> 	int iter = 0;
>> 	for (;; iter++) {
>> 		int pid = fork();
>> 		if (pid < 0)
>> 	exit(1);
>> 		if (pid == 0) {
>> 			setup_test();
>> 			execute_one();
>> 			exit(0);
>> 		}
>> 		int status = 0;
>> 		uint64_t start = current_time_ms();
>> 		for (;;) {
>> 			if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
>> 				break;
>> 			sleep_ms(1);
>> 		if (current_time_ms() - start < 5000) {
>> 			continue;
>> 		}
>> 			kill_and_wait(pid, &status);
>> 			break;
>> 		}
>> 	}
>> }
>>
>> void execute_one(void)
>> {
>> *(uint32_t*)0x20000380 = 2;
>> *(uint32_t*)0x20000384 = 0x70;
>> *(uint8_t*)0x20000388 = 1;
>> *(uint8_t*)0x20000389 = 0;
>> *(uint8_t*)0x2000038a = 0;
>> *(uint8_t*)0x2000038b = 0;
>> *(uint32_t*)0x2000038c = 0;
>> *(uint64_t*)0x20000390 = 0;
>> *(uint64_t*)0x20000398 = 0;
>> *(uint64_t*)0x200003a0 = 0;
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 0, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 1, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 2, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 3, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 4, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 5, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 6, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 7, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 8, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 9, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 10, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 11, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 12, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 13, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 14, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 15, 2);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 17, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 18, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 19, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 20, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 21, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 22, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 23, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 24, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 25, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 26, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 27, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 28, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200003a8, 0, 29, 35);
>> *(uint32_t*)0x200003b0 = 0;
>> *(uint32_t*)0x200003b4 = 0;
>> *(uint64_t*)0x200003b8 = 0;
>> *(uint64_t*)0x200003c0 = 0;
>> *(uint64_t*)0x200003c8 = 0;
>> *(uint64_t*)0x200003d0 = 0;
>> *(uint32_t*)0x200003d8 = 0;
>> *(uint32_t*)0x200003dc = 0;
>> *(uint64_t*)0x200003e0 = 0;
>> *(uint32_t*)0x200003e8 = 0;
>> *(uint16_t*)0x200003ec = 0;
>> *(uint16_t*)0x200003ee = 0;
>> 	syscall(__NR_perf_event_open, 0x20000380ul, -1, 0ul, -1, 0ul);
>> *(uint32_t*)0x20000080 = 0;
>> *(uint32_t*)0x20000084 = 0x70;
>> *(uint8_t*)0x20000088 = 0;
>> *(uint8_t*)0x20000089 = 0;
>> *(uint8_t*)0x2000008a = 0;
>> *(uint8_t*)0x2000008b = 0;
>> *(uint32_t*)0x2000008c = 0;
>> *(uint64_t*)0x20000090 = 0x9c;
>> *(uint64_t*)0x20000098 = 0;
>> *(uint64_t*)0x200000a0 = 0;
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 0, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 1, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 2, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 3, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 4, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 5, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 6, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 7, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 8, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 9, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 10, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 11, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 12, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 13, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 14, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 15, 2);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 17, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 18, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 19, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 20, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 21, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 22, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 23, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 24, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 25, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 26, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 27, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 28, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x200000a8, 0, 29, 35);
>> *(uint32_t*)0x200000b0 = 0;
>> *(uint32_t*)0x200000b4 = 0;
>> *(uint64_t*)0x200000b8 = 0;
>> *(uint64_t*)0x200000c0 = 0;
>> *(uint64_t*)0x200000c8 = 0;
>> *(uint64_t*)0x200000d0 = 0;
>> *(uint32_t*)0x200000d8 = 0;
>> *(uint32_t*)0x200000dc = 0;
>> *(uint64_t*)0x200000e0 = 0;
>> *(uint32_t*)0x200000e8 = 0;
>> *(uint16_t*)0x200000ec = 0;
>> *(uint16_t*)0x200000ee = 0;
>> 	syscall(__NR_perf_event_open, 0x20000080ul, -1, 0ul, -1, 0ul);
>> *(uint32_t*)0x20000140 = 2;
>> *(uint32_t*)0x20000144 = 0x70;
>> *(uint8_t*)0x20000148 = 0x47;
>> *(uint8_t*)0x20000149 = 1;
>> *(uint8_t*)0x2000014a = 0;
>> *(uint8_t*)0x2000014b = 0;
>> *(uint32_t*)0x2000014c = 0;
>> *(uint64_t*)0x20000150 = 9;
>> *(uint64_t*)0x20000158 = 0x61220;
>> *(uint64_t*)0x20000160 = 0;
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 0, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 1, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 2, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 3, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 4, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 5, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 6, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 7, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 8, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 9, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 10, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 11, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 12, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 13, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 14, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 15, 2);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 17, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 18, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 19, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 20, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 21, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 22, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 23, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 24, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 25, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 26, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 27, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 28, 1);
>> STORE_BY_BITMASK(uint64_t, , 0x20000168, 0, 29, 35);
>> *(uint32_t*)0x20000170 = 0;
>> *(uint32_t*)0x20000174 = 0;
>> *(uint64_t*)0x20000178 = 0;
>> *(uint64_t*)0x20000180 = 0;
>> *(uint64_t*)0x20000188 = 0;
>> *(uint64_t*)0x20000190 = 1;
>> *(uint32_t*)0x20000198 = 0;
>> *(uint32_t*)0x2000019c = 0;
>> *(uint64_t*)0x200001a0 = 2;
>> *(uint32_t*)0x200001a8 = 0;
>> *(uint16_t*)0x200001ac = 0;
>> *(uint16_t*)0x200001ae = 0;
>> 	syscall(__NR_perf_event_open, 0x20000140ul, 0, -1ul, -1, 0ul);
>>
>> }
>> int main(void)
>> {
>> 		syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>> 	syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>> 	syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>> 			loop();
>> 	return 0;
>> }
>>
>> Regards,
>> Michael Wang
>>
>>
>> On 2021/9/13 下午10:49, Dave Hansen wrote:
>>> On 9/12/21 8:30 PM, 王贇 wrote:
>>>> According to the trace we know the story is like this, the NMI
>>>> triggered perf IRQ throttling and call perf_log_throttle(),
>>>> which triggered the swevent overflow, and the overflow process
>>>> do perf_callchain_user() which triggered a user PF, and the PF
>>>> process triggered perf ftrace which finally lead into a suspected
>>>> stack overflow.
>>>>
>>>> This patch disable ftrace on fault.c, which help to avoid the panic.
>>> ...
>>>> +# Disable ftrace to avoid stack overflow.
>>>> +CFLAGS_REMOVE_fault.o = $(CC_FLAGS_FTRACE)
>>>
>>> Was this observed on a mainline kernel?
>>>
>>> How reproducible is this?
>>>
>>> I suspect we're going into do_user_addr_fault(), then falling in here:
>>>
>>>>         if (unlikely(faulthandler_disabled() || !mm)) {
>>>>                 bad_area_nosemaphore(regs, error_code, address);
>>>>                 return;
>>>>         }
>>>
>>> Then something double faults in perf_swevent_get_recursion_context().
>>> But, you snipped all of the register dump out so I can't quite see
>>> what's going on and what might have caused *that* fault.  But, in my
>>> kernel perf_swevent_get_recursion_context+0x0/0x70 is:
>>>
>>> 	   mov    $0x27d00,%rdx
>>>
>>> which is rather unlikely to fault.
>>>
>>> Either way, we don't want to keep ftrace out of fault.c.  This patch is
>>> just a hack, and doesn't really try to fix the underlying problem.  This
>>> situation *should* be handled today.  There's code there to handle it.
>>>
>>> Something else really funky is going on.
>>>
