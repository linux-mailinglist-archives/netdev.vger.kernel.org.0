Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD14615CDE
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 08:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiKBHUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 03:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiKBHT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 03:19:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E296F23164;
        Wed,  2 Nov 2022 00:19:55 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2J740d2TzRnx1;
        Wed,  2 Nov 2022 15:14:56 +0800 (CST)
Received: from [10.174.178.197] (10.174.178.197) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 15:19:52 +0800
Message-ID: <666b976a-8873-25e2-66dd-1398682c6cb7@huawei.com>
Date:   Wed, 2 Nov 2022 15:19:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH -next] bpf, test_run: fix alignment problem in
 bpf_prog_test_run_skb()
To:     Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <song@kernel.org>, <yhs@fb.com>, <haoluo@google.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux MM <linux-mm@kvack.org>, <kasan-dev@googlegroups.com>
References: <20221101040440.3637007-1-zhongbaisong@huawei.com>
 <eca17bfb-c75f-5db1-f194-5b00c2a0c6f2@iogearbox.net>
 <ca6253bd-dcf4-2625-bc41-4b9a7774d895@huawei.com>
 <20221101210542.724e3442@kernel.org> <202211012121.47D68D0@keescook>
 <CANn89i+FVN95uvftTJteZgGQ_sSb6452XXZn0veNjHHKZ2yEFQ@mail.gmail.com>
From:   zhongbaisong <zhongbaisong@huawei.com>
Organization: huawei
In-Reply-To: <CANn89i+FVN95uvftTJteZgGQ_sSb6452XXZn0veNjHHKZ2yEFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.197]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/2 12:37, Eric Dumazet wrote:
> On Tue, Nov 1, 2022 at 9:27 PM Kees Cook <keescook@chromium.org> wrote:
>>
>> On Tue, Nov 01, 2022 at 09:05:42PM -0700, Jakub Kicinski wrote:
>>> On Wed, 2 Nov 2022 10:59:44 +0800 zhongbaisong wrote:
>>>> On 2022/11/2 0:45, Daniel Borkmann wrote:
>>>>> [ +kfence folks ]
>>>>
>>>> + cc: Alexander Potapenko, Marco Elver, Dmitry Vyukov
>>>>
>>>> Do you have any suggestions about this problem?
>>>
>>> + Kees who has been sending similar patches for drivers
>>>
>>>>> On 11/1/22 5:04 AM, Baisong Zhong wrote:
>>>>>> Recently, we got a syzkaller problem because of aarch64
>>>>>> alignment fault if KFENCE enabled.
>>>>>>
>>>>>> When the size from user bpf program is an odd number, like
>>>>>> 399, 407, etc, it will cause skb shard info's alignment access,
>>>>>> as seen below:
>>>>>>
>>>>>> BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0
>>>>>> net/core/skbuff.c:1032
>>>>>>
>>>>>> Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
>>>>>>    __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
>>>>>>    arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
>>>>>>    arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
>>>>>>    atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
>>>>>>    __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
>>>>>>    skb_clone+0xf4/0x214 net/core/skbuff.c:1481
>>>>>>    ____bpf_clone_redirect net/core/filter.c:2433 [inline]
>>>>>>    bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
>>>>>>    bpf_prog_d3839dd9068ceb51+0x80/0x330
>>>>>>    bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
>>>>>>    bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
>>>>>>    bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
>>>>>>    bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
>>>>>>    __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
>>>>>>    __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
>>>>>>
>>>>>> kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=407,
>>>>>> cache=kmalloc-512
>>>>>>
>>>>>> allocated by task 15074 on cpu 0 at 1342.585390s:
>>>>>>    kmalloc include/linux/slab.h:568 [inline]
>>>>>>    kzalloc include/linux/slab.h:675 [inline]
>>>>>>    bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
>>>>>>    bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
>>>>>>    bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
>>>>>>    __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
>>>>>>    __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
>>>>>>    __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381
>>>>>>
>>>>>> To fix the problem, we round up allocations with kmalloc_size_roundup()
>>>>>> so that build_skb()'s use of kize() is always alignment and no special
>>>>>> handling of the memory is needed by KFENCE.
>>>>>>
>>>>>> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
>>>>>> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
>>>>>> ---
>>>>>>    net/bpf/test_run.c | 1 +
>>>>>>    1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>>>>> index 13d578ce2a09..058b67108873 100644
>>>>>> --- a/net/bpf/test_run.c
>>>>>> +++ b/net/bpf/test_run.c
>>>>>> @@ -774,6 +774,7 @@ static void *bpf_test_init(const union bpf_attr
>>>>>> *kattr, u32 user_size,
>>>>>>        if (user_size > size)
>>>>>>            return ERR_PTR(-EMSGSIZE);
>>>>>> +    size = kmalloc_size_roundup(size);
>>>>>>        data = kzalloc(size + headroom + tailroom, GFP_USER);
>>>>>
>>>>> The fact that you need to do this roundup on call sites feels broken, no?
>>>>> Was there some discussion / consensus that now all k*alloc() call sites
>>>>> would need to be fixed up? Couldn't this be done transparently in k*alloc()
>>>>> when KFENCE is enabled? I presume there may be lots of other such occasions
>>>>> in the kernel where similar issue triggers, fixing up all call-sites feels
>>>>> like ton of churn compared to api-internal, generic fix.
>>
>> I hope I answer this in more detail here:
>> https://lore.kernel.org/lkml/202211010937.4631CB1B0E@keescook/
>>
>> The problem is that ksize() should never have existed in the first
>> place. :P Every runtime bounds checker has tripped over it, and with
>> the addition of the __alloc_size attribute, I had to start ripping
>> ksize() out: it can't be used to pretend an allocation grew in size.
>> Things need to either preallocate more or go through *realloc() like
>> everything else. Luckily, ksize() is rare.
>>
>> FWIW, the above fix doesn't look correct to me -- I would expect this to
>> be:
>>
>>          size_t alloc_size;
>>          ...
>>          alloc_size = kmalloc_size_roundup(size + headroom + tailroom);
>>          data = kzalloc(alloc_size, GFP_USER);
> 
> Making sure the struct skb_shared_info is aligned to a cache line does
> not need kmalloc_size_roundup().
> 
> What is needed is to adjust @size so that (@size + @headroom) is a
> multiple of SMP_CACHE_BYTES

ok, I'll fix it and send v2.

Thanks

.
