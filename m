Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D238C63C4AD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiK2QIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiK2QIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:08:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614ECB07
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669738019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGSsOKZIaXvD2Db2EaTYBBqV/YNM2fgfWamu5PuCnRI=;
        b=Q74lkIOsQsjhFcko3Su48XaFjuXJCkQMCx7+hyBPoaFVgzRVPFXBkD0xqUG7msnYzKK0r+
        re+wBO6sbRR6ndPGir+x9t5MNlRYwW7cZXDGwhFLOxxm4WL6QGzBuDcbivpl+OAq2Ko24A
        TFBVcNS9Iv87UlMO4H3Z67Rw4pBuFQE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-9TuuBb6BMwSaRGLNqSGnxg-1; Tue, 29 Nov 2022 11:06:55 -0500
X-MC-Unique: 9TuuBb6BMwSaRGLNqSGnxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C42982DFCF;
        Tue, 29 Nov 2022 16:06:54 +0000 (UTC)
Received: from [10.22.17.30] (unknown [10.22.17.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57BB11121314;
        Tue, 29 Nov 2022 16:06:53 +0000 (UTC)
Message-ID: <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
Date:   Tue, 29 Nov 2022 11:06:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
Content-Language: en-US
To:     Hou Tao <houtao@huaweicloud.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
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
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 07:45, Hou Tao wrote:
> Hi,
>
> On 11/29/2022 2:06 PM, Tonghao Zhang wrote:
>> On Tue, Nov 29, 2022 at 12:32 PM Hou Tao <houtao1@huawei.com> wrote:
>>> Hi,
>>>
>>> On 11/29/2022 5:55 AM, Hao Luo wrote:
>>>> On Sun, Nov 27, 2022 at 7:15 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>>> Hi Tonghao,
>>>>
>>>> With a quick look at the htab_lock_bucket() and your problem
>>>> statement, I agree with Hou Tao that using hash &
>>>> min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) to index in map_locked seems
>>>> to fix the potential deadlock. Can you actually send your changes as
>>>> v2 so we can take a look and better help you? Also, can you explain
>>>> your solution in your commit message? Right now, your commit message
>>>> has only a problem statement and is not very clear. Please include
>>>> more details on what you do to fix the issue.
>>>>
>>>> Hao
>>> It would be better if the test case below can be rewritten as a bpf selftests.
>>> Please see comments below on how to improve it and reproduce the deadlock.
>>>>> Hi
>>>>> only a warning from lockdep.
>>> Thanks for your details instruction.  I can reproduce the warning by using your
>>> setup. I am not a lockdep expert, it seems that fixing such warning needs to set
>>> different lockdep class to the different bucket. Because we use map_locked to
>>> protect the acquisition of bucket lock, so I think we can define  lock_class_key
>>> array in bpf_htab (e.g., lockdep_key[HASHTAB_MAP_LOCK_COUNT]) and initialize the
>>> bucket lock accordingly.
> The proposed lockdep solution doesn't work. Still got lockdep warning after
> that, so cc +locking expert +lkml.org for lockdep help.
>
> Hi lockdep experts,
>
> We are trying to fix the following lockdep warning from bpf subsystem:
>
> [   36.092222] ================================
> [   36.092230] WARNING: inconsistent lock state
> [   36.092234] 6.1.0-rc5+ #81 Tainted: G            E
> [   36.092236] --------------------------------
> [   36.092237] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> [   36.092238] perf/1515 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   36.092242] ffff888341acd1a0 (&htab->lockdep_key){....}-{2:2}, at:
> htab_lock_bucket+0x4d/0x58
> [   36.092253] {INITIAL USE} state was registered at:
> [   36.092255]   mark_usage+0x1d/0x11d
> [   36.092262]   __lock_acquire+0x3c9/0x6ed
> [   36.092266]   lock_acquire+0x23d/0x29a
> [   36.092270]   _raw_spin_lock_irqsave+0x43/0x7f
> [   36.092274]   htab_lock_bucket+0x4d/0x58
> [   36.092276]   htab_map_delete_elem+0x82/0xfb
> [   36.092278]   map_delete_elem+0x156/0x1ac
> [   36.092282]   __sys_bpf+0x138/0xb71
> [   36.092285]   __do_sys_bpf+0xd/0x15
> [   36.092288]   do_syscall_64+0x6d/0x84
> [   36.092291]   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   36.092295] irq event stamp: 120346
> [   36.092296] hardirqs last  enabled at (120345): [<ffffffff8180b97f>]
> _raw_spin_unlock_irq+0x24/0x39
> [   36.092299] hardirqs last disabled at (120346): [<ffffffff81169e85>]
> generic_exec_single+0x40/0xb9
> [   36.092303] softirqs last  enabled at (120268): [<ffffffff81c00347>]
> __do_softirq+0x347/0x387
> [   36.092307] softirqs last disabled at (120133): [<ffffffff810ba4f0>]
> __irq_exit_rcu+0x67/0xc6
> [   36.092311]
> [   36.092311] other info that might help us debug this:
> [   36.092312]  Possible unsafe locking scenario:
> [   36.092312]
> [   36.092313]        CPU0
> [   36.092313]        ----
> [   36.092314]   lock(&htab->lockdep_key);
> [   36.092315]   <Interrupt>
> [   36.092316]     lock(&htab->lockdep_key);
> [   36.092318]
> [   36.092318]  *** DEADLOCK ***
> [   36.092318]
> [   36.092318] 3 locks held by perf/1515:
> [   36.092320]  #0: ffff8881b9805cc0 (&cpuctx_mutex){+.+.}-{4:4}, at:
> perf_event_ctx_lock_nested+0x8e/0xba
> [   36.092327]  #1: ffff8881075ecc20 (&event->child_mutex){+.+.}-{4:4}, at:
> perf_event_for_each_child+0x35/0x76
> [   36.092332]  #2: ffff8881b9805c20 (&cpuctx_lock){-.-.}-{2:2}, at:
> perf_ctx_lock+0x12/0x27
> [   36.092339]
> [   36.092339] stack backtrace:
> [   36.092341] CPU: 0 PID: 1515 Comm: perf Tainted: G            E
> 6.1.0-rc5+ #81
> [   36.092344] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [   36.092349] Call Trace:
> [   36.092351]  <NMI>
> [   36.092354]  dump_stack_lvl+0x57/0x81
> [   36.092359]  lock_acquire+0x1f4/0x29a
> [   36.092363]  ? handle_pmi_common+0x13f/0x1f0
> [   36.092366]  ? htab_lock_bucket+0x4d/0x58
> [   36.092371]  _raw_spin_lock_irqsave+0x43/0x7f
> [   36.092374]  ? htab_lock_bucket+0x4d/0x58
> [   36.092377]  htab_lock_bucket+0x4d/0x58
> [   36.092379]  htab_map_update_elem+0x11e/0x220
> [   36.092386]  bpf_prog_f3a535ca81a8128a_bpf_prog2+0x3e/0x42
> [   36.092392]  trace_call_bpf+0x177/0x215
> [   36.092398]  perf_trace_run_bpf_submit+0x52/0xaa
> [   36.092403]  ? x86_pmu_stop+0x97/0x97
> [   36.092407]  perf_trace_nmi_handler+0xb7/0xe0
> [   36.092415]  nmi_handle+0x116/0x254
> [   36.092418]  ? x86_pmu_stop+0x97/0x97
> [   36.092423]  default_do_nmi+0x3d/0xf6
> [   36.092428]  exc_nmi+0xa1/0x109
> [   36.092432]  end_repeat_nmi+0x16/0x67
> [   36.092436] RIP: 0010:wrmsrl+0xd/0x1b

So the lock is really taken in a NMI context. In general, we advise 
again using lock in a NMI context unless it is a lock that is used only 
in that context. Otherwise, deadlock is certainly a possibility as there 
is no way to mask off again NMI.

Cheers,
Longman

