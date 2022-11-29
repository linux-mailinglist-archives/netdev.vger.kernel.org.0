Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9488A63C043
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiK2MqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiK2MqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:46:02 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5764B2B602;
        Tue, 29 Nov 2022 04:45:58 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NM2BR5X7gz4f42V7;
        Tue, 29 Nov 2022 20:45:51 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP2 (Coremail) with SMTP id Syh0CgCXrbj8_oVj8E1cBQ--.13678S2;
        Tue, 29 Nov 2022 20:45:52 +0800 (CST)
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Boqun Feng <boqun.feng@gmail.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
References: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
 <20221121100521.56601-2-xiangxia.m.yue@gmail.com>
 <7ed2f531-79a3-61fe-f1c2-b004b752c3f7@huawei.com>
 <CAMDZJNUiPOcnpNg8tM4xCoJABJz_3=AaXLTm5ofQg64mGDkB_A@mail.gmail.com>
 <9278cf3f-dfb6-78eb-8862-553545dac7ed@huawei.com>
 <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
Date:   Tue, 29 Nov 2022 20:45:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: Syh0CgCXrbj8_oVj8E1cBQ--.13678S2
X-Coremail-Antispam: 1UD129KBjvAXoW3Aw1xXFy5KF13Ar45WF1kAFb_yoW8Gr1xAo
        Wxur4fCr48urn5CFWfX345Gr43Jas7AF47Aryjkr4DKr17tFWDAry8G39rJw4UAF1rCF43
        uw17Xw1kua4UAF97n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYI7kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
        rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
        IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI
        62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
        ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
        uYvjxUFDGOUUUUU
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

On 11/29/2022 2:06 PM, Tonghao Zhang wrote:
> On Tue, Nov 29, 2022 at 12:32 PM Hou Tao <houtao1@huawei.com> wrote:
>> Hi,
>>
>> On 11/29/2022 5:55 AM, Hao Luo wrote:
>>> On Sun, Nov 27, 2022 at 7:15 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>> Hi Tonghao,
>>>
>>> With a quick look at the htab_lock_bucket() and your problem
>>> statement, I agree with Hou Tao that using hash &
>>> min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) to index in map_locked seems
>>> to fix the potential deadlock. Can you actually send your changes as
>>> v2 so we can take a look and better help you? Also, can you explain
>>> your solution in your commit message? Right now, your commit message
>>> has only a problem statement and is not very clear. Please include
>>> more details on what you do to fix the issue.
>>>
>>> Hao
>> It would be better if the test case below can be rewritten as a bpf selftests.
>> Please see comments below on how to improve it and reproduce the deadlock.
>>>> Hi
>>>> only a warning from lockdep.
>> Thanks for your details instruction.  I can reproduce the warning by using your
>> setup. I am not a lockdep expert, it seems that fixing such warning needs to set
>> different lockdep class to the different bucket. Because we use map_locked to
>> protect the acquisition of bucket lock, so I think we can define  lock_class_key
>> array in bpf_htab (e.g., lockdep_key[HASHTAB_MAP_LOCK_COUNT]) and initialize the
>> bucket lock accordingly.
The proposed lockdep solution doesn't work. Still got lockdep warning after
that, so cc +locking expert +lkml.org for lockdep help.

Hi lockdep experts,

We are trying to fix the following lockdep warning from bpf subsystem:

[   36.092222] ================================
[   36.092230] WARNING: inconsistent lock state
[   36.092234] 6.1.0-rc5+ #81 Tainted: G            E
[   36.092236] --------------------------------
[   36.092237] inconsistent {INITIAL USE} -> {IN-NMI} usage.
[   36.092238] perf/1515 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   36.092242] ffff888341acd1a0 (&htab->lockdep_key){....}-{2:2}, at:
htab_lock_bucket+0x4d/0x58
[   36.092253] {INITIAL USE} state was registered at:
[   36.092255]   mark_usage+0x1d/0x11d
[   36.092262]   __lock_acquire+0x3c9/0x6ed
[   36.092266]   lock_acquire+0x23d/0x29a
[   36.092270]   _raw_spin_lock_irqsave+0x43/0x7f
[   36.092274]   htab_lock_bucket+0x4d/0x58
[   36.092276]   htab_map_delete_elem+0x82/0xfb
[   36.092278]   map_delete_elem+0x156/0x1ac
[   36.092282]   __sys_bpf+0x138/0xb71
[   36.092285]   __do_sys_bpf+0xd/0x15
[   36.092288]   do_syscall_64+0x6d/0x84
[   36.092291]   entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   36.092295] irq event stamp: 120346
[   36.092296] hardirqs last  enabled at (120345): [<ffffffff8180b97f>]
_raw_spin_unlock_irq+0x24/0x39
[   36.092299] hardirqs last disabled at (120346): [<ffffffff81169e85>]
generic_exec_single+0x40/0xb9
[   36.092303] softirqs last  enabled at (120268): [<ffffffff81c00347>]
__do_softirq+0x347/0x387
[   36.092307] softirqs last disabled at (120133): [<ffffffff810ba4f0>]
__irq_exit_rcu+0x67/0xc6
[   36.092311]
[   36.092311] other info that might help us debug this:
[   36.092312]  Possible unsafe locking scenario:
[   36.092312]
[   36.092313]        CPU0
[   36.092313]        ----
[   36.092314]   lock(&htab->lockdep_key);
[   36.092315]   <Interrupt>
[   36.092316]     lock(&htab->lockdep_key);
[   36.092318]
[   36.092318]  *** DEADLOCK ***
[   36.092318]
[   36.092318] 3 locks held by perf/1515:
[   36.092320]  #0: ffff8881b9805cc0 (&cpuctx_mutex){+.+.}-{4:4}, at:
perf_event_ctx_lock_nested+0x8e/0xba
[   36.092327]  #1: ffff8881075ecc20 (&event->child_mutex){+.+.}-{4:4}, at:
perf_event_for_each_child+0x35/0x76
[   36.092332]  #2: ffff8881b9805c20 (&cpuctx_lock){-.-.}-{2:2}, at:
perf_ctx_lock+0x12/0x27
[   36.092339]
[   36.092339] stack backtrace:
[   36.092341] CPU: 0 PID: 1515 Comm: perf Tainted: G            E     
6.1.0-rc5+ #81
[   36.092344] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   36.092349] Call Trace:
[   36.092351]  <NMI>
[   36.092354]  dump_stack_lvl+0x57/0x81
[   36.092359]  lock_acquire+0x1f4/0x29a
[   36.092363]  ? handle_pmi_common+0x13f/0x1f0
[   36.092366]  ? htab_lock_bucket+0x4d/0x58
[   36.092371]  _raw_spin_lock_irqsave+0x43/0x7f
[   36.092374]  ? htab_lock_bucket+0x4d/0x58
[   36.092377]  htab_lock_bucket+0x4d/0x58
[   36.092379]  htab_map_update_elem+0x11e/0x220
[   36.092386]  bpf_prog_f3a535ca81a8128a_bpf_prog2+0x3e/0x42
[   36.092392]  trace_call_bpf+0x177/0x215
[   36.092398]  perf_trace_run_bpf_submit+0x52/0xaa
[   36.092403]  ? x86_pmu_stop+0x97/0x97
[   36.092407]  perf_trace_nmi_handler+0xb7/0xe0
[   36.092415]  nmi_handle+0x116/0x254
[   36.092418]  ? x86_pmu_stop+0x97/0x97
[   36.092423]  default_do_nmi+0x3d/0xf6
[   36.092428]  exc_nmi+0xa1/0x109
[   36.092432]  end_repeat_nmi+0x16/0x67
[   36.092436] RIP: 0010:wrmsrl+0xd/0x1b
[   36.092441] Code: 04 01 00 00 c6 84 07 48 01 00 00 01 5b e9 46 15 80 00 5b c3
cc cc cc cc c3 cc cc cc cc 48 89 f2 89 f9 89 f0 48 c1 ea 20 0f 30 <66> 90 c3 cc
cc cc cc 31 d2 e9 2f 04 49 00 0f 1f 44 00 00 40 0f6
[   36.092443] RSP: 0018:ffffc900043dfc48 EFLAGS: 00000002
[   36.092445] RAX: 000000000000000f RBX: ffff8881b96153e0 RCX: 000000000000038f
[   36.092447] RDX: 0000000000000007 RSI: 000000070000000f RDI: 000000000000038f
[   36.092449] RBP: 000000070000000f R08: ffffffffffffffff R09: ffff8881053bdaa8
[   36.092451] R10: ffff8881b9805d40 R11: 0000000000000005 R12: ffff8881b9805c00
[   36.092452] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881075ec970
[   36.092460]  ? wrmsrl+0xd/0x1b
[   36.092465]  ? wrmsrl+0xd/0x1b
[   36.092469]  </NMI>
[   36.092469]  <TASK>
[   36.092470]  __intel_pmu_enable_all.constprop.0+0x7c/0xaf
[   36.092475]  event_function+0xb6/0xd3
[   36.092478]  ? cpu_to_node+0x1a/0x1a
[   36.092482]  ? cpu_to_node+0x1a/0x1a
[   36.092485]  remote_function+0x1e/0x4c
[   36.092489]  generic_exec_single+0x48/0xb9
[   36.092492]  ? __lock_acquire+0x666/0x6ed
[   36.092497]  smp_call_function_single+0xbf/0x106
[   36.092499]  ? cpu_to_node+0x1a/0x1a
[   36.092504]  ? kvm_sched_clock_read+0x5/0x11
[   36.092508]  ? __perf_event_task_sched_in+0x13d/0x13d
[   36.092513]  cpu_function_call+0x47/0x69
[   36.092516]  ? perf_event_update_time+0x52/0x52
[   36.092519]  event_function_call+0x89/0x117
[   36.092521]  ? __perf_event_task_sched_in+0x13d/0x13d
[   36.092526]  ? _perf_event_disable+0x4a/0x4a
[   36.092528]  perf_event_for_each_child+0x3d/0x76
[   36.092532]  ? _perf_event_disable+0x4a/0x4a
[   36.092533]  _perf_ioctl+0x564/0x590
[   36.092537]  ? __lock_release+0xd5/0x1b0
[   36.092543]  ? perf_event_ctx_lock_nested+0x8e/0xba
[   36.092547]  perf_ioctl+0x42/0x5f
[   36.092551]  vfs_ioctl+0x1e/0x2f
[   36.092554]  __do_sys_ioctl+0x66/0x89
[   36.092559]  do_syscall_64+0x6d/0x84
[   36.092563]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   36.092566] RIP: 0033:0x7fe7110f362b
[   36.092569] Code: 0f 1e fa 48 8b 05 5d b8 2c 00 64 c7 00 26 00 00 00 48 c7 c0
ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 2d b8 2c 00 f7 d8 64 89 018
[   36.092570] RSP: 002b:00007ffebb8e4b08 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[   36.092573] RAX: ffffffffffffffda RBX: 0000000000002400 RCX: 00007fe7110f362b
[   36.092575] RDX: 0000000000000000 RSI: 0000000000002400 RDI: 0000000000000013
[   36.092576] RBP: 00007ffebb8e4b40 R08: 0000000000000001 R09: 000055c1db4a5b40
[   36.092577] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   36.092579] R13: 000055c1db3b2a30 R14: 0000000000000000 R15: 0000000000000000
[   36.092586]  </TASK>

The lockdep warning is a false alarm, because per-cpu map_locked must be zero
before acquire b->raw_lock. If b->raw_lock has already been acquired by a normal
process through htab_map_update_elem(), then a NMI interrupts the process and
tries to acquire the same b->raw_lock, the acquisition will fail because per-cpu
map_locked has already been increased by the process.

So beside using lockdep_off() and lockdep_on() to disable/enable lockdep
temporarily in htab_lock_bucket() and htab_unlock_bucket(), are there other ways
to fix the lockdep warning ?

Thanks,
Tao




> Hi
> Thanks for your reply. define the lock_class_key array looks good.
> Last question: how about using  raw_spin_trylock_irqsave, if the
> bucket is locked on the same or other cpu.
> raw_spin_trylock_irqsave will return the false, we should return the
> -EBUSY in htab_lock_bucket.
>
> static inline int htab_lock_bucket(struct bucket *b,
>                                    unsigned long *pflags)
> {
>         unsigned long flags;
>
>         if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
>                 return -EBUSY;
>
>         *pflags = flags;
>         return 0;
> }
>
>>>> 1. the kernel .config
>>>> #
>>>> # Debug Oops, Lockups and Hangs
>>>> #
>>>> CONFIG_PANIC_ON_OOPS=y
>>>> CONFIG_PANIC_ON_OOPS_VALUE=1
>>>> CONFIG_PANIC_TIMEOUT=0
>>>> CONFIG_LOCKUP_DETECTOR=y
>>>> CONFIG_SOFTLOCKUP_DETECTOR=y
>>>> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
>>>> CONFIG_HARDLOCKUP_DETECTOR_PERF=y
>>>> CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
>>>> CONFIG_HARDLOCKUP_DETECTOR=y
>>>> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
>>>> CONFIG_DETECT_HUNG_TASK=y
>>>> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
>>>> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
>>>> # CONFIG_WQ_WATCHDOG is not set
>>>> # CONFIG_TEST_LOCKUP is not set
>>>> # end of Debug Oops, Lockups and Hangs
>>>>
>>>> 2. bpf.c, the map size is 2.
>>>> struct {
>>>> __uint(type, BPF_MAP_TYPE_HASH);
>> Adding __uint(map_flags, BPF_F_ZERO_SEED); to ensure there will be no seed for
>> hash calculation, so we can use key=4 and key=20 to construct the case that
>> these two keys have the same bucket index but have different map_locked index.
>>>> __uint(max_entries, 2);
>>>> __uint(key_size, sizeof(unsigned int));
>>>> __uint(value_size, sizeof(unsigned int));
>>>> } map1 SEC(".maps");
>>>>
>>>> static int bpf_update_data()
>>>> {
>>>> unsigned int val = 1, key = 0;
>> key = 20
>>>> return bpf_map_update_elem(&map1, &key, &val, BPF_ANY);
>>>> }
>>>>
>>>> SEC("kprobe/ip_rcv")
>>>> int bpf_prog1(struct pt_regs *regs)
>>>> {
>>>> bpf_update_data();
>>>> return 0;
>>>> }
>> kprobe on ip_rcv is unnecessary, you can just remove it.
>>>> SEC("tracepoint/nmi/nmi_handler")
>>>> int bpf_prog2(struct pt_regs *regs)
>>>> {
>>>> bpf_update_data();
>>>> return 0;
>>>> }
>> Please use SEC("fentry/nmi_handle") instead of SEC("tracepoint") and unfold
>> bpf_update_data(), because the running of bpf program on tracepoint will be
>> blocked by bpf_prog_active which will be increased bpf_map_update_elem through
>> bpf_disable_instrumentation().
>>>> char _license[] SEC("license") = "GPL";
>>>> unsigned int _version SEC("version") = LINUX_VERSION_CODE;
>>>>
>>>> 3. bpf loader.
>>>> #include "kprobe-example.skel.h"
>>>>
>>>> #include <unistd.h>
>>>> #include <errno.h>
>>>>
>>>> #include <bpf/bpf.h>
>>>>
>>>> int main()
>>>> {
>>>> struct kprobe_example *skel;
>>>> int map_fd, prog_fd;
>>>> int i;
>>>> int err = 0;
>>>>
>>>> skel = kprobe_example__open_and_load();
>>>> if (!skel)
>>>> return -1;
>>>>
>>>> err = kprobe_example__attach(skel);
>>>> if (err)
>>>> goto cleanup;
>>>>
>>>> /* all libbpf APIs are usable */
>>>> prog_fd = bpf_program__fd(skel->progs.bpf_prog1);
>>>> map_fd = bpf_map__fd(skel->maps.map1);
>>>>
>>>> printf("map_fd: %d\n", map_fd);
>>>>
>>>> unsigned int val = 0, key = 0;
>>>>
>>>> while (1) {
>>>> bpf_map_delete_elem(map_fd, &key);
>> No needed neither. Only do bpf_map_update_elem() is OK. Also change key=0 from
>> key=4, so it will have the same bucket index as key=20 but have different
>> map_locked index.
>>>> bpf_map_update_elem(map_fd, &key, &val, BPF_ANY);
>>>> }
>> Also need to pin the process on a specific CPU (e.g., CPU 0)
>>>> cleanup:
>>>> kprobe_example__destroy(skel);
>>>> return err;
>>>> }
>>>>
>>>> 4. run the bpf loader and perf record for nmi interrupts.  the warming occurs
>> For perf event, you can reference prog_tests/find_vma.c on how to using
>> perf_event_open to trigger a perf nmi interrupt. The perf event also needs to
>> pin on a specific CPU as the caller of bpf_map_update_elem() does.
>>
>>>> --
>>>> Best regards, Tonghao
>>> .
>

