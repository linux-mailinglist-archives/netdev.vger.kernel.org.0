Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A3E2E2327
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 02:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgLXBJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 20:09:33 -0500
Received: from www62.your-server.de ([213.133.104.62]:41302 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgLXBJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 20:09:33 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ksF7a-0004IG-GT; Thu, 24 Dec 2020 02:08:50 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ksF7a-000UMT-AK; Thu, 24 Dec 2020 02:08:50 +0100
Subject: Re: [PATCH 1/3 v4 bpf-next] bpf: save correct stopping point in file
 seq iteration.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20201218185032.2464558-1-jonathan.lemon@gmail.com>
 <20201218185032.2464558-2-jonathan.lemon@gmail.com>
 <CAEf4BzbHEjwOhFYeu2kyzZj3fROJ3RguNuWb7HJ0C2NExL+r9Q@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <12d507d3-cdc7-438d-f9c1-43cef44ba328@iogearbox.net>
Date:   Thu, 24 Dec 2020 02:08:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbHEjwOhFYeu2kyzZj3fROJ3RguNuWb7HJ0C2NExL+r9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26026/Wed Dec 23 13:53:03 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/20 10:01 PM, Andrii Nakryiko wrote:
> On Fri, Dec 18, 2020 at 12:47 PM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
>>
>> From: Jonathan Lemon <bsd@fb.com>
>>
>> On some systems, some variant of the following splat is
>> repeatedly seen.  The common factor in all traces seems
>> to be the entry point to task_file_seq_next().  With the
>> patch, all warnings go away.
>>
>>      rcu: INFO: rcu_sched self-detected stall on CPU
>>      rcu: \x0926-....: (20992 ticks this GP) idle=d7e/1/0x4000000000000002 softirq=81556231/81556231 fqs=4876
>>      \x09(t=21033 jiffies g=159148529 q=223125)
>>      NMI backtrace for cpu 26
>>      CPU: 26 PID: 2015853 Comm: bpftool Kdump: loaded Not tainted 5.6.13-0_fbk4_3876_gd8d1f9bf80bb #1
>>      Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A12 10/08/2018
>>      Call Trace:
>>       <IRQ>
>>       dump_stack+0x50/0x70
>>       nmi_cpu_backtrace.cold.6+0x13/0x50
>>       ? lapic_can_unplug_cpu.cold.30+0x40/0x40
>>       nmi_trigger_cpumask_backtrace+0xba/0xca
>>       rcu_dump_cpu_stacks+0x99/0xc7
>>       rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
>>       ? tick_sched_do_timer+0x60/0x60
>>       update_process_times+0x24/0x50
>>       tick_sched_timer+0x37/0x70
>>       __hrtimer_run_queues+0xfe/0x270
>>       hrtimer_interrupt+0xf4/0x210
>>       smp_apic_timer_interrupt+0x5e/0x120
>>       apic_timer_interrupt+0xf/0x20
>>       </IRQ>
>>      RIP: 0010:get_pid_task+0x38/0x80
>>      Code: 89 f6 48 8d 44 f7 08 48 8b 00 48 85 c0 74 2b 48 83 c6 55 48 c1 e6 04 48 29 f0 74 19 48 8d 78 20 ba 01 00 00 00 f0 0f c1 50 20 <85> d2 74 27 78 11 83 c2 01 78 0c 48 83 c4 08 c3 31 c0 48 83 c4 08
>>      RSP: 0018:ffffc9000d293dc8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
>>      RAX: ffff888637c05600 RBX: ffffc9000d293e0c RCX: 0000000000000000
>>      RDX: 0000000000000001 RSI: 0000000000000550 RDI: ffff888637c05620
>>      RBP: ffffffff8284eb80 R08: ffff88831341d300 R09: ffff88822ffd8248
>>      R10: ffff88822ffd82d0 R11: 00000000003a93c0 R12: 0000000000000001
>>      R13: 00000000ffffffff R14: ffff88831341d300 R15: 0000000000000000
>>       ? find_ge_pid+0x1b/0x20
>>       task_seq_get_next+0x52/0xc0
>>       task_file_seq_get_next+0x159/0x220
>>       task_file_seq_next+0x4f/0xa0
>>       bpf_seq_read+0x159/0x390
>>       vfs_read+0x8a/0x140
>>       ksys_read+0x59/0xd0
>>       do_syscall_64+0x42/0x110
>>       entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>      RIP: 0033:0x7f95ae73e76e
>>      Code: Bad RIP value.
>>      RSP: 002b:00007ffc02c1dbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>>      RAX: ffffffffffffffda RBX: 000000000170faa0 RCX: 00007f95ae73e76e
>>      RDX: 0000000000001000 RSI: 00007ffc02c1dc30 RDI: 0000000000000007
>>      RBP: 00007ffc02c1ec70 R08: 0000000000000005 R09: 0000000000000006
>>      R10: fffffffffffff20b R11: 0000000000000246 R12: 00000000019112a0
>>      R13: 0000000000000000 R14: 0000000000000007 R15: 00000000004283c0
>>
>> If unable to obtain the file structure for the current task,
>> proceed to the next task number after the one returned from
>> task_seq_get_next(), instead of the next task number from the
>> original iterator.
>>
>> Also, save the stopping task number from task_seq_get_next()
>> on failure in case of restarts.
>>
>> Fixes: a650da2ee52a ("bpf: Add task and task/file iterator targets")

Commit sha is non-existent, I fixed it up. Took first 2 into bpf given first in
particular is a fix. Please submit 3/3 individually once we synced trees back.

>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
> 
> LGTM, thanks!
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
