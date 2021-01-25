Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C575301FCD
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 01:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAYAyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 19:54:40 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64209 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbhAYAyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 19:54:36 -0500
Received: from fsav106.sakura.ne.jp (fsav106.sakura.ne.jp [27.133.134.233])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 10P0qg09057051;
        Mon, 25 Jan 2021 09:52:42 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav106.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp);
 Mon, 25 Jan 2021 09:52:42 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 10P0qgIP057027
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 25 Jan 2021 09:52:42 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: BPF: unbounded bpf_map_free_deferred problem
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <c099ad52-0c2c-b886-bae2-c64bd8626452@ozlabs.ru>
 <CACT4Y+Z+kwPM=WUzJ-e359PWeLLqmF0w4Yxp1spzZ=+J0ekrag@mail.gmail.com>
 <6af41136-4344-73da-f821-e831674be473@i-love.sakura.ne.jp>
 <70d427e8-7281-0aae-c524-813d73eca2d7@ozlabs.ru>
 <CACT4Y+bqidtwh1HUFFoyyKyVy0jnwrzhVBgqmU+T9sN1yPMO=g@mail.gmail.com>
 <eb71cc37-afbd-5446-6305-8c7abcc6e91f@i-love.sakura.ne.jp>
 <6eaafbd8-1c10-75df-75ae-9afa0861f69b@i-love.sakura.ne.jp>
 <e4767b84-05a4-07c0-811b-b3a08cad2f43@ozlabs.ru>
 <b9e41542-5c93-9d37-d99d-acde6fb01fa1@i-love.sakura.ne.jp>
 <CAM_iQpU3P03+2QL2iDbVQSyqwHb6DXi96eXNEm3kDgFWjqAKHg@mail.gmail.com>
 <cf17e6c4-76c7-52b9-39d5-c14946070fc4@i-love.sakura.ne.jp>
 <c1aecd4e-8db7-87a5-94bf-c630f1cf0866@ozlabs.ru>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <ab49d331-c0d7-b20b-36df-848f42cca7e9@i-love.sakura.ne.jp>
Date:   Mon, 25 Jan 2021 09:52:40 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c1aecd4e-8db7-87a5-94bf-c630f1cf0866@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/01/25 8:48, Alexey Kardashevskiy wrote:
> 
> 
> On 23/01/2021 22:17, Tetsuo Handa wrote:
>> On 2021/01/23 12:27, Cong Wang wrote:
>>> On Fri, Jan 22, 2021 at 4:42 PM Tetsuo Handa
>>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>>>
>>>> Hello, BPF developers.
>>>>
>>>> Alexey Kardashevskiy is reporting that system_wq gets stuck due to flooding of
>>>> unbounded bpf_map_free_deferred work. Use of WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND
>>>> workqueue did not solve this problem. Is it possible that a refcount leak somewhere
>>>> preventing bpf_map_free_deferred from completing? Please see
>>>> https://lkml.kernel.org/r/CACT4Y+Z+kwPM=WUzJ-e359PWeLLqmF0w4Yxp1spzZ=+J0ekrag@mail.gmail.com .
>>>>
>>>
>>> Which map does the reproducer create? And where exactly do
>>> those work block on?
>>>
>>> Different map->ops->map_free() waits for different reasons,
>>> for example, htab_map_free() waits for flying htab_elem_free_rcu().
>>> I can't immediately see how they could wait for each other, if this
>>> is what you meant above.

I guess that rcu_barrier() in htab_map_free() is taking longer than it should, for
Alexey said

  The offender is htab->lockdep_key. If I run repro at the slow rate, no
  problems appears, traces show lockdep_unregister_key() is called and the
  leak is quite slow.

at https://lkml.kernel.org/r/c099ad52-0c2c-b886-bae2-c64bd8626452@ozlabs.ru and
pending works seems to be reduced by use of WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND workqueue
at https://lkml.kernel.org/r/e4767b84-05a4-07c0-811b-b3a08cad2f43@ozlabs.ru .

>>>
>>> Thanks.
>>>
>>
>> Alexey, please try below diff on top of "show_workqueue_state() right after the bug message"
>> and Hillf's patch. And please capture several times so that we can check if sched_show_task()
>> always points to the same function.
> 
> 
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 9880b6c0e272..616464dd8e92 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -50,6 +50,7 @@
>>   #include <linux/uaccess.h>
>>   #include <linux/sched/isolation.h>
>>   #include <linux/nmi.h>
>> +#include <linux/sched/debug.h>
>>     #include "workqueue_internal.h"
>>   @@ -4725,6 +4726,10 @@ static void show_pwq(struct pool_workqueue *pwq)
>>               comma = true;
>>           }
>>           pr_cont("\n");
>> +        hash_for_each(pool->busy_hash, bkt, worker, hentry) {
>> +            if (worker->current_pwq == pwq)
>> +                sched_show_task(worker->task);
>> +        }
>>       }
>>         list_for_each_entry(work, &pool->worklist, entry) {
>>
> 
> Below are 3 samples, they report:
> 
> Workqueue: events_unbound bpf_map_free_deferred
> 
> Hope that helps, i'm still getting my head around this new can of worms :) Thanks,
> 
> 
> 
> [  148.770893] hrtimer: interrupt took 1070385 ns
> [  207.882594] BUG: MAX_LOCKDEP_KEYS too low!
> [  207.886689] turning off the locking correctness validator.
> [  207.886766] CPU: 1 PID: 9448 Comm: maxlockdep Not tainted 5.11.0-rc4-le_syzkaller_a+fstn1 #64
> [  207.886882] Call Trace:
> [  207.886914] [c00000003b397690] [c000000000d112f0] dump_stack+0x13c/0x1bc (unreliable)
> [  207.887052] [c00000003b3976e0] [c0000000002edb0c] register_lock_class+0xcbc/0xe20
> [  207.887156] [c00000003b3977f0] [c0000000002e97b8] __lock_acquire+0xa8/0x21e0
> [  207.887247] [c00000003b397940] [c0000000002ec674] lock_acquire+0x2c4/0x5c0
> [  207.887328] [c00000003b397a30] [c0000000018212dc] _raw_spin_lock_irqsave+0x7c/0xb0
> [  207.887436] [c00000003b397a70] [c0000000004dc9d0] htab_lru_map_update_elem+0x3e0/0x6c0
> [  207.887537] [c00000003b397af0] [c0000000004a2b14] bpf_map_update_value.isra.24+0x734/0x820
> [  207.887631] [c00000003b397b50] [c0000000004a7d58] generic_map_update_batch+0x1b8/0x3b0
> [  207.887723] [c00000003b397bf0] [c0000000004a05e0] bpf_map_do_batch+0x1b0/0x390
> [  207.887816] [c00000003b397c50] [c0000000004aca90] __do_sys_bpf+0x13d0/0x35b0
> [  207.887905] [c00000003b397db0] [c00000000004b648] system_call_exception+0x178/0x2b0
> [  207.887998] [c00000003b397e10] [c00000000000e060] system_call_common+0xf0/0x27c
> [  207.888090] Showing busy workqueues and worker pools:
> [  207.888149] workqueue events_unbound: flags=0x2
> [  207.888206]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=1/512 refcnt=3
> [  207.888290]     in-flight: 7:bpf_map_free_deferred
> [  207.888357] ___K___ (1) show_pwq 4729
> [  207.888403] task:kworker/u16:0   state:D stack:10928 pid:    7 ppid:     2 flags:0x00000800
> [  207.888494] Workqueue: events_unbound bpf_map_free_deferred
> [  207.888559] Call Trace:
> [  207.888590] [c00000001343b4f0] [c000000013412b18] 0xc000000013412b18 (unreliable)
> [  207.888691] [c00000001343b6e0] [c0000000000271d0] __switch_to+0x3e0/0x700
> [  207.888763] [c00000001343b750] [c000000001817b48] __schedule+0x3c8/0xc80
> [  207.888828] [c00000001343b820] [c000000001818494] schedule+0x94/0x170
> [  207.888892] [c00000001343b850] [c00000000181f9ec] schedule_timeout+0x43c/0x650
> [  207.888966] [c00000001343b960] [c00000000181a194] wait_for_completion+0xb4/0x190
> [  207.889041] [c00000001343b9c0] [c000000000325904] __wait_rcu_gp+0x1c4/0x240
> [  207.889105] [c00000001343ba20] [c000000000339164] synchronize_rcu+0xa4/0x180
> [  207.889179] [c00000001343bac0] [c0000000002e54b0] lockdep_unregister_key+0x1e0/0x470
> [  207.889253] [c00000001343bb60] [c0000000004d942c] htab_map_free+0x20c/0x250
> [  207.889317] [c00000001343bbc0] [c0000000004a1934] bpf_map_free_deferred+0xa4/0x3e0
> [  207.889391] [c00000001343bc30] [c00000000026d508] process_one_work+0x468/0xb00
> [  207.889465] [c00000001343bd10] [c00000000026dc34] worker_thread+0x94/0x760
> [  207.889535] [c00000001343bda0] [c00000000027e380] kthread+0x1f0/0x200
> [  207.889598] [c00000001343be10] [c00000000000e2f0] ret_from_kernel_thread+0x5c/0x6c
> [  207.889674] workqueue events_power_efficient: flags=0x80
> [  207.889721]   pwq 12: cpus=6 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [  207.889789]     pending: gc_worker
> [  207.889894] pool 16: cpus=0-7 flags=0x4 nice=0 hung=76s workers=3 idle: 81 253
> 
> 
> 
> 
> [   29.071632] maxlockdep (2535) used greatest stack depth: 7872 bytes left
> [   30.855628] hrtimer: interrupt took 1041204 ns
> [   96.748271] BUG: MAX_LOCKDEP_KEYS too low!
> [   96.780332] turning off the locking correctness validator.
> [   96.781239] CPU: 0 PID: 9443 Comm: maxlockdep Not tainted 5.11.0-rc4-le_syzkaller_a+fstn1 #64
> [   96.782008] Call Trace:
> [   96.782571] [c00000003658b690] [c000000000d112f0] dump_stack+0x13c/0x1bc (unreliable)
> [   96.783472] [c00000003658b6e0] [c0000000002edb0c] register_lock_class+0xcbc/0xe20
> [   96.784037] [c00000003658b7f0] [c0000000002e97b8] __lock_acquire+0xa8/0x21e0
> [   96.784607] [c00000003658b940] [c0000000002ec674] lock_acquire+0x2c4/0x5c0
> [   96.785067] [c00000003658ba30] [c0000000018212dc] _raw_spin_lock_irqsave+0x7c/0xb0
> [   96.785307] [c00000003658ba70] [c0000000004dc9d0] htab_lru_map_update_elem+0x3e0/0x6c0
> [   96.785541] [c00000003658baf0] [c0000000004a2b14] bpf_map_update_value.isra.24+0x734/0x820
> [   96.785749] [c00000003658bb50] [c0000000004a7d58] generic_map_update_batch+0x1b8/0x3b0
> [   96.785963] [c00000003658bbf0] [c0000000004a05e0] bpf_map_do_batch+0x1b0/0x390
> [   96.786161] [c00000003658bc50] [c0000000004aca90] __do_sys_bpf+0x13d0/0x35b0
> [   96.786392] [c00000003658bdb0] [c00000000004b648] system_call_exception+0x178/0x2b0
> [   96.786614] [c00000003658be10] [c00000000000e060] system_call_common+0xf0/0x27c
> [   96.786819] Showing busy workqueues and worker pools:
> [   96.786942] workqueue events_unbound: flags=0x2
> [   96.787062]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=1/512 refcnt=3
> [   96.787272]     in-flight: 81:bpf_map_free_deferred
> [   96.787441] ___K___ (0) show_pwq 4729
> [   96.787538] task:kworker/u16:1   state:D stack:10928 pid:   81 ppid:     2 flags:0x00000800
> [   96.787767] Workqueue: events_unbound bpf_map_free_deferred
> [   96.787909] Call Trace:
> [   96.787975] [c000000013b57600] [c000000013b57660] 0xc000000013b57660 (unreliable)
> [   96.788222] [c000000013b577f0] [c0000000000271d0] __switch_to+0x3e0/0x700
> [   96.788417] [c000000013b57860] [c000000001817b48] __schedule+0x3c8/0xc80
> [   96.788595] [c000000013b57930] [c000000001818494] schedule+0x94/0x170
> [   96.788772] [c000000013b57960] [c00000000181f9ec] schedule_timeout+0x43c/0x650
> [   96.789002] [c000000013b57a70] [c00000000181a194] wait_for_completion+0xb4/0x190
> [   96.789222] [c000000013b57ad0] [c000000000333e8c] rcu_barrier+0x2fc/0xc70
> [   96.789402] [c000000013b57b60] [c0000000004d9258] htab_map_free+0x38/0x250
> [   96.789580] [c000000013b57bc0] [c0000000004a1934] bpf_map_free_deferred+0xa4/0x3e0
> [   96.789804] [c000000013b57c30] [c00000000026d508] process_one_work+0x468/0xb00
> [   96.790002] [c000000013b57d10] [c00000000026dc34] worker_thread+0x94/0x760
> [   96.790177] [c000000013b57da0] [c00000000027e380] kthread+0x1f0/0x200
> [   96.790346] [c000000013b57e10] [c00000000000e2f0] ret_from_kernel_thread+0x5c/0x6c
> [   96.790559] workqueue events_power_efficient: flags=0x80
> [   96.790717]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [   96.790956]     pending: gc_worker
> [   96.791215] pool 16: cpus=0-7 flags=0x4 nice=0 hung=76s workers=3 idle: 7 251
> 
> 
> 
> 
> 
> [   21.324859] hrtimer: interrupt took 383633 ns
> [   83.653616] BUG: MAX_LOCKDEP_KEYS too low!
> [   83.653806] turning off the locking correctness validator.
> [   83.653963] CPU: 4 PID: 9460 Comm: maxlockdep Not tainted 5.11.0-rc4-le_syzkaller_a+fstn1 #64
> [   83.654183] Call Trace:
> [   83.654250] [c00000004d53b690] [c000000000d112f0] dump_stack+0x13c/0x1bc (unreliable)
> [   83.654565] [c00000004d53b6e0] [c0000000002edb0c] register_lock_class+0xcbc/0xe20
> [   83.654808] [c00000004d53b7f0] [c0000000002e97b8] __lock_acquire+0xa8/0x21e0
> [   83.655020] [c00000004d53b940] [c0000000002ec674] lock_acquire+0x2c4/0x5c0
> [   83.655203] [c00000004d53ba30] [c0000000018212dc] _raw_spin_lock_irqsave+0x7c/0xb0
> [   83.655444] [c00000004d53ba70] [c0000000004dc9d0] htab_lru_map_update_elem+0x3e0/0x6c0
> [   83.655673] [c00000004d53baf0] [c0000000004a2b14] bpf_map_update_value.isra.24+0x734/0x820
> [   83.655886] [c00000004d53bb50] [c0000000004a7d58] generic_map_update_batch+0x1b8/0x3b0
> [   83.656088] [c00000004d53bbf0] [c0000000004a05e0] bpf_map_do_batch+0x1b0/0x390
> [   83.656297] [c00000004d53bc50] [c0000000004aca90] __do_sys_bpf+0x13d0/0x35b0
> [   83.656496] [c00000004d53bdb0] [c00000000004b648] system_call_exception+0x178/0x2b0
> [   83.656700] [c00000004d53be10] [c00000000000e060] system_call_common+0xf0/0x27c
> [   83.656903] Showing busy workqueues and worker pools:
> [   83.657044] workqueue events_unbound: flags=0x2
> [   83.657165]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=1/512 refcnt=3
> [   83.657358]     in-flight: 81:bpf_map_free_deferred
> [   83.657519] ___K___ (4) show_pwq 4729
> [   83.657620] task:kworker/u16:1   state:D stack:10928 pid:   81 ppid:     2 flags:0x00000800
> [   83.657820] Workqueue: events_unbound bpf_map_free_deferred
> [   83.657967] Call Trace:
> [   83.658033] [c000000013b574f0] [c000000013aefa98] 0xc000000013aefa98 (unreliable)
> [   83.658255] [c000000013b576e0] [c0000000000271d0] __switch_to+0x3e0/0x700
> [   83.658437] [c000000013b57750] [c000000001817b48] __schedule+0x3c8/0xc80
> [   83.658618] [c000000013b57820] [c000000001818494] schedule+0x94/0x170
> [   83.658815] [c000000013b57850] [c00000000181f9ec] schedule_timeout+0x43c/0x650
> [   83.659019] [c000000013b57960] [c00000000181a194] wait_for_completion+0xb4/0x190
> [   83.659229] [c000000013b579c0] [c000000000325904] __wait_rcu_gp+0x1c4/0x240
> [   83.659406] [c000000013b57a20] [c000000000339164] synchronize_rcu+0xa4/0x180
> [   83.659617] [c000000013b57ac0] [c0000000002e54b0] lockdep_unregister_key+0x1e0/0x470
> [   83.659825] [c000000013b57b60] [c0000000004d942c] htab_map_free+0x20c/0x250
> [   83.660002] [c000000013b57bc0] [c0000000004a1934] bpf_map_free_deferred+0xa4/0x3e0
> [   83.660212] [c000000013b57c30] [c00000000026d508] process_one_work+0x468/0xb00
> [   83.660415] [c000000013b57d10] [c00000000026dc34] worker_thread+0x94/0x760
> [   83.660598] [c000000013b57da0] [c00000000027e380] kthread+0x1f0/0x200
> [   83.660771] [c000000013b57e10] [c00000000000e2f0] ret_from_kernel_thread+0x5c/0x6c
> [   83.661114] pool 16: cpus=0-7 flags=0x4 nice=0 hung=67s workers=3 idle: 7 252
> 
> 
> 
> 

