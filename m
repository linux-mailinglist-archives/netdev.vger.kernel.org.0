Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7CA63CE31
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiK3EIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiK3EIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:08:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D3A2B1BB
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 20:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669781241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7dVxXAZufrpSRVdfUpGT875/FvocolhoDTU8t05kbp8=;
        b=jIvuO6qdUI6mHKC5ma08YlPWTmUQa1KvVYBn2Xo4NznwF3+p20VJpM24TQytlUjMRUbvNw
        NTNwZ2QwpIbNpmOOKoaFOB4bat2lgxsKb3LyhsrjOmNQF1/WpjtBmNtSBJJbxPVDtr8GGL
        4iHjyULzVZ/OymSBqXuNnwOZ7+i4Ovw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-tCXDdzctOgqdSuZOCqFYUA-1; Tue, 29 Nov 2022 23:07:18 -0500
X-MC-Unique: tCXDdzctOgqdSuZOCqFYUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B67A1C05EAA;
        Wed, 30 Nov 2022 04:07:17 +0000 (UTC)
Received: from [10.22.17.30] (unknown [10.22.17.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F5722024CBE;
        Wed, 30 Nov 2022 04:07:16 +0000 (UTC)
Message-ID: <fb7e9567-6452-7ccc-d2d5-697eb06ac251@redhat.com>
Date:   Tue, 29 Nov 2022 23:07:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
Content-Language: en-US
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Hou Tao <houtao1@huawei.com>
Cc:     Hou Tao <houtao@huaweicloud.com>, Hao Luo <haoluo@google.com>,
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
 <9455ff51-098c-87f0-dc83-2303921032a2@redhat.com>
 <CAMDZJNUdE7BKL6COF3xZD04iPn_4n5ZFmmoNB-y566QSVrct5w@mail.gmail.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <CAMDZJNUdE7BKL6COF3xZD04iPn_4n5ZFmmoNB-y566QSVrct5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 22:32, Tonghao Zhang wrote:
> On Wed, Nov 30, 2022 at 11:07 AM Waiman Long <longman@redhat.com> wrote:
>> On 11/29/22 21:47, Tonghao Zhang wrote:
>>> On Wed, Nov 30, 2022 at 9:50 AM Hou Tao <houtao@huaweicloud.com> wrote:
>>>> Hi Hao,
>>>>
>>>> On 11/30/2022 3:36 AM, Hao Luo wrote:
>>>>> On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
>>>>>> Just to be clear, I meant to refactor htab_lock_bucket() into a try
>>>>>> lock pattern. Also after a second thought, the below suggestion doesn't
>>>>>> work. I think the proper way is to make htab_lock_bucket() as a
>>>>>> raw_spin_trylock_irqsave().
>>>>>>
>>>>>> Regards,
>>>>>> Boqun
>>>>>>
>>>>> The potential deadlock happens when the lock is contended from the
>>>>> same cpu. When the lock is contended from a remote cpu, we would like
>>>>> the remote cpu to spin and wait, instead of giving up immediately. As
>>>>> this gives better throughput. So replacing the current
>>>>> raw_spin_lock_irqsave() with trylock sacrifices this performance gain.
>>>>>
>>>>> I suspect the source of the problem is the 'hash' that we used in
>>>>> htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
>>>>> whether we should use a hash derived from 'bucket' rather than from
>>>>> 'key'. For example, from the memory address of the 'bucket'. Because,
>>>>> different keys may fall into the same bucket, but yield different
>>>>> hashes. If the same bucket can never have two different 'hashes' here,
>>>>> the map_locked check should behave as intended. Also because
>>>>> ->map_locked is per-cpu, execution flows from two different cpus can
>>>>> both pass.
>>>> The warning from lockdep is due to the reason the bucket lock A is used in a
>>>> no-NMI context firstly, then the same bucke lock is used a NMI context, so
>>> Yes, I tested lockdep too, we can't use the lock in NMI(but only
>>> try_lock work fine) context if we use them no-NMI context. otherwise
>>> the lockdep prints the warning.
>>> * for the dead-lock case: we can use the
>>> 1. hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1)
>>> 2. or hash bucket address.
>>>
>>> * for lockdep warning, we should use in_nmi check with map_locked.
>>>
>>> BTW, the patch doesn't work, so we can remove the lock_key
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c50eb518e262fa06bd334e6eec172eaf5d7a5bd9
>>>
>>> static inline int htab_lock_bucket(const struct bpf_htab *htab,
>>>                                      struct bucket *b, u32 hash,
>>>                                      unsigned long *pflags)
>>> {
>>>           unsigned long flags;
>>>
>>>           hash = hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1);
>>>
>>>           preempt_disable();
>>>           if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
>>>                   __this_cpu_dec(*(htab->map_locked[hash]));
>>>                   preempt_enable();
>>>                   return -EBUSY;
>>>           }
>>>
>>>           if (in_nmi()) {
>>>                   if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
>>>                           return -EBUSY;
>> That is not right. You have to do the same step as above by decrementing
>> the percpu count and enable preemption. So you may want to put all these
>> busy_out steps after the return 0 and use "goto busy_out;" to jump there.
> Yes, thanks Waiman, I should add the busy_out label.
>>>           } else {
>>>                   raw_spin_lock_irqsave(&b->raw_lock, flags);
>>>           }
>>>
>>>           *pflags = flags;
>>>           return 0;
>>> }
>> BTW, with that change, I believe you can actually remove all the percpu
>> map_locked count code.
> there are some case, for example, we run the bpf_prog A B in task
> context on the same cpu.
> bpf_prog A
> update map X
>      htab_lock_bucket
>          raw_spin_lock_irqsave()
>      lookup_elem_raw()
>          // bpf prog B is attached on lookup_elem_raw()
>          bpf prog B
>              update map X again and update the element
>                  htab_lock_bucket()
>                      // dead-lock
>                      raw_spinlock_irqsave()

I see, so nested locking is possible in this case. Beside using the 
percpu map_lock, another way is to have cpumask associated with each 
bucket lock and use each bit in the cpumask for to control access using 
test_and_set_bit() for each cpu. That will allow more concurrency and 
you can actually find out how contended is the lock. Anyway, it is just 
a thought.

Cheers,
Longman


