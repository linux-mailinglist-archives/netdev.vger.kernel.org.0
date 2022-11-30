Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1150B63CE42
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiK3ENg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiK3ENO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:13:14 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F087925C65;
        Tue, 29 Nov 2022 20:13:10 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NMQmK21chz4f3l2X;
        Wed, 30 Nov 2022 12:13:05 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP1 (Coremail) with SMTP id cCh0CgC3rKtO2IZjCJ9DBQ--.5500S2;
        Wed, 30 Nov 2022 12:13:06 +0800 (CST)
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Hao Luo <haoluo@google.com>, Waiman Long <longman@redhat.com>,
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
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
 <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
 <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
 <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
 <23b5de45-1a11-b5c9-d0d3-4dbca0b7661e@huaweicloud.com>
 <CAMDZJNWtyanKtXtAxYGwvJ0LTgYLf=5iYFm63pbvvJLPE8oHSQ@mail.gmail.com>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <8d424223-1da6-60bf-dd2c-cd2fe6d263fe@huaweicloud.com>
Date:   Wed, 30 Nov 2022 12:13:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAMDZJNWtyanKtXtAxYGwvJ0LTgYLf=5iYFm63pbvvJLPE8oHSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: cCh0CgC3rKtO2IZjCJ9DBQ--.5500S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCF48Aw18KrW7Jr4fKFW3Wrg_yoW5KrW3pF
        W7WF9xKF4kZF1Uuan2va18tr4aywnF9r4jkrZ8Jw10vF98Xry3ZFWIgw4I9Fy0qrn3ArsI
        vr47Zay8CFn0vFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 11/30/2022 10:47 AM, Tonghao Zhang wrote:
> On Wed, Nov 30, 2022 at 9:50 AM Hou Tao <houtao@huaweicloud.com> wrote:
>> Hi Hao,
>>
>> On 11/30/2022 3:36 AM, Hao Luo wrote:
>>> On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
>>>> Just to be clear, I meant to refactor htab_lock_bucket() into a try
>>>> lock pattern. Also after a second thought, the below suggestion doesn't
>>>> work. I think the proper way is to make htab_lock_bucket() as a
>>>> raw_spin_trylock_irqsave().
>>>>
>>>> Regards,
>>>> Boqun
>>>>
>>> The potential deadlock happens when the lock is contended from the
>>> same cpu. When the lock is contended from a remote cpu, we would like
>>> the remote cpu to spin and wait, instead of giving up immediately. As
>>> this gives better throughput. So replacing the current
>>> raw_spin_lock_irqsave() with trylock sacrifices this performance gain.
>>>
>>> I suspect the source of the problem is the 'hash' that we used in
>>> htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
>>> whether we should use a hash derived from 'bucket' rather than from
>>> 'key'. For example, from the memory address of the 'bucket'. Because,
>>> different keys may fall into the same bucket, but yield different
>>> hashes. If the same bucket can never have two different 'hashes' here,
>>> the map_locked check should behave as intended. Also because
>>> ->map_locked is per-cpu, execution flows from two different cpus can
>>> both pass.
>> The warning from lockdep is due to the reason the bucket lock A is used in a
>> no-NMI context firstly, then the same bucke lock is used a NMI context, so
> Yes, I tested lockdep too, we can't use the lock in NMI(but only
> try_lock work fine) context if we use them no-NMI context. otherwise
> the lockdep prints the warning.
> * for the dead-lock case: we can use the
> 1. hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1)
> 2. or hash bucket address.
Use the computed hash will be better than hash bucket address, because the hash
buckets are allocated sequentially.
>
> * for lockdep warning, we should use in_nmi check with map_locked.
>
> BTW, the patch doesn't work, so we can remove the lock_key
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c50eb518e262fa06bd334e6eec172eaf5d7a5bd9
>
> static inline int htab_lock_bucket(const struct bpf_htab *htab,
>                                    struct bucket *b, u32 hash,
>                                    unsigned long *pflags)
> {
>         unsigned long flags;
>
>         hash = hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1);
>
>         preempt_disable();
>         if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
>                 __this_cpu_dec(*(htab->map_locked[hash]));
>                 preempt_enable();
>                 return -EBUSY;
>         }
>
>         if (in_nmi()) {
>                 if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
>                         return -EBUSY;
The only purpose of trylock here is to make lockdep happy and it may lead to
unnecessary -EBUSY error for htab operations in NMI context. I still prefer add
a virtual lock-class for map_locked to fix the lockdep warning. So could you use
separated patches to fix the potential dead-lock and the lockdep warning ? It
will be better you can also add a bpf selftests for deadlock problem as said before.

Thanks,
Tao
>         } else {
>                 raw_spin_lock_irqsave(&b->raw_lock, flags);
>         }
>
>         *pflags = flags;
>         return 0;
> }
>
>
>> lockdep deduces that may be a dead-lock. I have already tried to use the same
>> map_locked for keys with the same bucket, the dead-lock is gone, but still got
>> lockdep warning.
>>> Hao
>>> .
>

