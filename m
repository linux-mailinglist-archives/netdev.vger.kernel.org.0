Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBF063CCE3
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiK3BhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 20:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiK3BhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:37:13 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7D96D4A5;
        Tue, 29 Nov 2022 17:37:11 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NMMJK3rSGz4f3p1G;
        Wed, 30 Nov 2022 09:37:05 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP1 (Coremail) with SMTP id cCh0CgBHOai+s4ZjTag9BQ--.41614S2;
        Wed, 30 Nov 2022 09:37:05 +0800 (CST)
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <9278cf3f-dfb6-78eb-8862-553545dac7ed@huawei.com>
 <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
 <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <db6293a9-8739-7970-d1e0-a027afa935de@huaweicloud.com>
Date:   Wed, 30 Nov 2022 09:37:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: cCh0CgBHOai+s4ZjTag9BQ--.41614S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtF48Aw1UAF1xGFyxGw17Jrb_yoW3GF47pr
        93GFZ7Ar15Ja1xuFyjgryUGF1jv3W7G3Zrur1kGw1kJFsrZr17Ww40gw1qgFy2vrWxCFn3
        tF4Yq34Sv34UZFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
        e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
        6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07UZ18PUUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/30/2022 1:23 AM, Boqun Feng wrote:
> On Tue, Nov 29, 2022 at 11:06:51AM -0500, Waiman Long wrote:
>> On 11/29/22 07:45, Hou Tao wrote:
>>> Hi,
>>>
>>> On 11/29/2022 2:06 PM, Tonghao Zhang wrote:
>>>> On Tue, Nov 29, 2022 at 12:32 PM Hou Tao <houtao1@huawei.com> wrote:
>>>>> Hi,
>>>>>
>>>>> On 11/29/2022 5:55 AM, Hao Luo wrote:
>>>>>> On Sun, Nov 27, 2022 at 7:15 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>>>>> Hi Tonghao,
>>>>>>
>>>>>> With a quick look at the htab_lock_bucket() and your problem
>>>>>> statement, I agree with Hou Tao that using hash &
>>>>>> min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) to index in map_locked seems
>>>>>> to fix the potential deadlock. Can you actually send your changes as
>>>>>> v2 so we can take a look and better help you? Also, can you explain
>>>>>> your solution in your commit message? Right now, your commit message
>>>>>> has only a problem statement and is not very clear. Please include
>>>>>> more details on what you do to fix the issue.
>>>>>>
>>>>>> Hao
>>>>> It would be better if the test case below can be rewritten as a bpf selftests.
>>>>> Please see comments below on how to improve it and reproduce the deadlock.
>>>>>>> Hi
>>>>>>> only a warning from lockdep.
>>>>> Thanks for your details instruction.  I can reproduce the warning by using your
>>>>> setup. I am not a lockdep expert, it seems that fixing such warning needs to set
>>>>> different lockdep class to the different bucket. Because we use map_locked to
>>>>> protect the acquisition of bucket lock, so I think we can define  lock_class_key
>>>>> array in bpf_htab (e.g., lockdep_key[HASHTAB_MAP_LOCK_COUNT]) and initialize the
>>>>> bucket lock accordingly.
>>> The proposed lockdep solution doesn't work. Still got lockdep warning after
>>> that, so cc +locking expert +lkml.org for lockdep help.
>>>
>>> Hi lockdep experts,
>>>
>>> We are trying to fix the following lockdep warning from bpf subsystem:
>>>
>>> [   36.092222] ================================
>>> [   36.092230] WARNING: inconsistent lock state
>>> [   36.092234] 6.1.0-rc5+ #81 Tainted: G            E
>>> [   36.092236] --------------------------------
>>> [   36.092237] inconsistent {INITIAL USE} -> {IN-NMI} usage.
>>> [   36.092238] perf/1515 [HC1[1]:SC0[0]:HE0:SE1] takes:
>>> [   36.092242] ffff888341acd1a0 (&htab->lockdep_key){....}-{2:2}, at:
>>> htab_lock_bucket+0x4d/0x58
>>> [   36.092253] {INITIAL USE} state was registered at:
>>> [   36.092255]   mark_usage+0x1d/0x11d
>>> [   36.092262]   __lock_acquire+0x3c9/0x6ed
>>> [   36.092266]   lock_acquire+0x23d/0x29a
>>> [   36.092270]   _raw_spin_lock_irqsave+0x43/0x7f
>>> [   36.092274]   htab_lock_bucket+0x4d/0x58
>>> [   36.092276]   htab_map_delete_elem+0x82/0xfb
>>> [   36.092278]   map_delete_elem+0x156/0x1ac
>>> [   36.092282]   __sys_bpf+0x138/0xb71
>>> [   36.092285]   __do_sys_bpf+0xd/0x15
>>> [   36.092288]   do_syscall_64+0x6d/0x84
>>> [   36.092291]   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>> [   36.092295] irq event stamp: 120346
>>> [   36.092296] hardirqs last  enabled at (120345): [<ffffffff8180b97f>]
>>> _raw_spin_unlock_irq+0x24/0x39
>>> [   36.092299] hardirqs last disabled at (120346): [<ffffffff81169e85>]
>>> generic_exec_single+0x40/0xb9
>>> [   36.092303] softirqs last  enabled at (120268): [<ffffffff81c00347>]
>>> __do_softirq+0x347/0x387
>>> [   36.092307] softirqs last disabled at (120133): [<ffffffff810ba4f0>]
>>> __irq_exit_rcu+0x67/0xc6
>>> [   36.092311]
>>> [   36.092311] other info that might help us debug this:
>>> [   36.092312]  Possible unsafe locking scenario:
>>> [   36.092312]
>>> [   36.092313]        CPU0
>>> [   36.092313]        ----
>>> [   36.092314]   lock(&htab->lockdep_key);
>>> [   36.092315]   <Interrupt>
>>> [   36.092316]     lock(&htab->lockdep_key);
>>> [   36.092318]
>>> [   36.092318]  *** DEADLOCK ***
>>> [   36.092318]
>>> [   36.092318] 3 locks held by perf/1515:
>>> [   36.092320]  #0: ffff8881b9805cc0 (&cpuctx_mutex){+.+.}-{4:4}, at:
>>> perf_event_ctx_lock_nested+0x8e/0xba
>>> [   36.092327]  #1: ffff8881075ecc20 (&event->child_mutex){+.+.}-{4:4}, at:
>>> perf_event_for_each_child+0x35/0x76
>>> [   36.092332]  #2: ffff8881b9805c20 (&cpuctx_lock){-.-.}-{2:2}, at:
>>> perf_ctx_lock+0x12/0x27
>>> [   36.092339]
>>> [   36.092339] stack backtrace:
>>> [   36.092341] CPU: 0 PID: 1515 Comm: perf Tainted: G            E
>>> 6.1.0-rc5+ #81
>>> [   36.092344] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>>> rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
>>> [   36.092349] Call Trace:
>>> [   36.092351]  <NMI>
>>> [   36.092354]  dump_stack_lvl+0x57/0x81
>>> [   36.092359]  lock_acquire+0x1f4/0x29a
>>> [   36.092363]  ? handle_pmi_common+0x13f/0x1f0
>>> [   36.092366]  ? htab_lock_bucket+0x4d/0x58
>>> [   36.092371]  _raw_spin_lock_irqsave+0x43/0x7f
>>> [   36.092374]  ? htab_lock_bucket+0x4d/0x58
>>> [   36.092377]  htab_lock_bucket+0x4d/0x58
>>> [   36.092379]  htab_map_update_elem+0x11e/0x220
>>> [   36.092386]  bpf_prog_f3a535ca81a8128a_bpf_prog2+0x3e/0x42
>>> [   36.092392]  trace_call_bpf+0x177/0x215
>>> [   36.092398]  perf_trace_run_bpf_submit+0x52/0xaa
>>> [   36.092403]  ? x86_pmu_stop+0x97/0x97
>>> [   36.092407]  perf_trace_nmi_handler+0xb7/0xe0
>>> [   36.092415]  nmi_handle+0x116/0x254
>>> [   36.092418]  ? x86_pmu_stop+0x97/0x97
>>> [   36.092423]  default_do_nmi+0x3d/0xf6
>>> [   36.092428]  exc_nmi+0xa1/0x109
>>> [   36.092432]  end_repeat_nmi+0x16/0x67
>>> [   36.092436] RIP: 0010:wrmsrl+0xd/0x1b
>> So the lock is really taken in a NMI context. In general, we advise again
>> using lock in a NMI context unless it is a lock that is used only in that
>> context. Otherwise, deadlock is certainly a possibility as there is no way
>> to mask off again NMI.
>>
> I think here they use a percpu counter as an "outer lock" to make the
> accesses to the real lock exclusive:
>
> 	preempt_disable();
> 	a = __this_cpu_inc(->map_locked);
> 	if (a != 1) {
> 		__this_cpu_dec(->map_locked);
> 		preempt_enable();
> 		return -EBUSY;
> 	}
> 	preempt_enable();
> 		return -EBUSY;
> 	
> 	raw_spin_lock_irqsave(->raw_lock);
>
> and lockdep is not aware that ->map_locked acts as a lock.
>
> However, I feel this may be just a reinvented try_lock pattern, Hou Tao,
> could you see if this can be refactored with a try_lock? Otherwise, you
> may need to introduce a virtual lockclass for ->map_locked.
As said by Hao Luo, the problem of using trylock in nmi context is that it can
not distinguish between dead-lock and lock with high-contention. And map_locked
is still needed even trylock is used in NMI because htab_map_update_elem() may
be reentered in a normal context through attaching a bpf program to one function
called after taken the lock. So introducing a virtual lockclass for ->map_locked
is a better idea.

Thanks,
Tao
> Regards,
> Boqun
>
>> Cheers,
>> Longman
>>
> .

