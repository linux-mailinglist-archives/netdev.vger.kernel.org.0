Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949E85307A1
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 04:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352641AbiEWCYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 22:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352264AbiEWCYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 22:24:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879AE3668E
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 19:24:40 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c14so12460352pfn.2
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 19:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=aOMiWykzTAkss9hiOWvH4knj9DdODFE029xQgfTUVrU=;
        b=vMYjUcNMrOX2c7g4XD3BjJ9X9Z8/cvadMUidMtCGEEz4yigIjRhf8BViP+CBRrFuDx
         fv3Y28zgTKOmWSxd30HhDWGkN8hnG69SmYfTPKO1Kkb38gABLq7MqP7LuHjrE/cZCIFu
         iEdwypssPKclptjD8hDfnYuPc+HklmtKXkIjRjbr2kgkLxO2msSDH4ElLTJQ9MSDrE3q
         UfAQAR5qE+XcwfPRm0dzisp8kHEwDM0mRg0Fo0eJmDYxgvJT2zRnB3XqA1l+a/0YguC4
         vW5woMO9vkCMGbHf6Ju29W4zD/gsUFMqihwrENXIEIGODWt5Bh/ENU56clFIfMEt4PpY
         4OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aOMiWykzTAkss9hiOWvH4knj9DdODFE029xQgfTUVrU=;
        b=OXpwX1MW2/tJZhrFhxz7Ok+tnZx4omQOnC0AnQSg9r/02DgIElvG/nXhlw1eeVUgVe
         jbkWtZlqevLTyJYvFsP5xN/4Qet2qCh/ALLgtUkaRng2gkX6ZHlqXIwN+d5I6laXD3Ki
         0X0IFLIuiLCJx1RtxItFhGHgF5sGbniUDk3izJ/DO87x4GdFASSPnT12cQeZ9xoEyaKt
         zLMD73WVInydToO3ba6TmbQu2bErRzX3Pj4OYEQ+w8consAEExwuFlERk2QtYllAzugW
         hs+P1mP3QQY1AcfrKeLVzDTomcncB3n4z1hUEnZImaqP/HPtJMtb0tIgor72G3AsSL9e
         5Rag==
X-Gm-Message-State: AOAM533H2sY/adPPrOXiE3qBRXWoP3OXyNm6dbW8EKRyK3539cMJReFe
        Npnq7xi9dULrniIjZRCVXJDhgA==
X-Google-Smtp-Source: ABdhPJzNZKi4tFMTcZBcZTd5ceElD4O7tWT7ehNN2D75Mue6UDOpiO/0ro3lkff3rjoKDXamJp9/ig==
X-Received: by 2002:a63:b705:0:b0:3fa:5e1c:ca11 with SMTP id t5-20020a63b705000000b003fa5e1cca11mr2127687pgf.31.1653272680033;
        Sun, 22 May 2022 19:24:40 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id t3-20020a62d143000000b0051868677e6dsm5802559pfl.51.2022.05.22.19.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 19:24:39 -0700 (PDT)
Message-ID: <877ac441-045b-1844-6938-fcaee5eee7f2@bytedance.com>
Date:   Mon, 23 May 2022 10:24:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
 <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
 <6ae715b3-96b1-2b42-4d1a-5267444d586b@bytedance.com>
 <9c0c3e0b-33bc-51a7-7916-7278f14f308e@fb.com>
 <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
 <0f904395-350d-5ee7-152e-93d104742e98@fb.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <0f904395-350d-5ee7-152e-93d104742e98@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/20 上午12:45, Yonghong Song 写道:
>
>
> On 5/18/22 8:12 PM, Feng Zhou wrote:
>> 在 2022/5/19 上午4:39, Yonghong Song 写道:
>>>
>>>
>>> On 5/17/22 11:57 PM, Feng Zhou wrote:
>>>> 在 2022/5/18 下午2:32, Alexei Starovoitov 写道:
>>>>> On Tue, May 17, 2022 at 11:27 PM Feng zhou 
>>>>> <zhoufeng.zf@bytedance.com> wrote:
>>>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>>>
>>>>>> We encountered bad case on big system with 96 CPUs that
>>>>>> alloc_htab_elem() would last for 1ms. The reason is that after the
>>>>>> prealloc hashtab has no free elems, when trying to update, it 
>>>>>> will still
>>>>>> grab spin_locks of all cpus. If there are multiple update users, the
>>>>>> competition is very serious.
>>>>>>
>>>>>> So this patch add is_empty in pcpu_freelist_head to check freelist
>>>>>> having free or not. If having, grab spin_lock, or check next cpu's
>>>>>> freelist.
>>>>>>
>>>>>> Before patch: hash_map performance
>>>>>> ./map_perf_test 1
>>>
>>> could you explain what parameter '1' means here?
>>
>> This code is here:
>> samples/bpf/map_perf_test_user.c
>> samples/bpf/map_perf_test_kern.c
>> parameter '1' means testcase flag, test hash_map's performance
>> parameter '2048' means test hash_map's performance when free=0.
>> testcase flag '2048' is added by myself to reproduce the problem 
>> phenomenon.
>>
>>>
>>>>>> 0:hash_map_perf pre-alloc 975345 events per sec
>>>>>> 4:hash_map_perf pre-alloc 855367 events per sec
>>>>>> 12:hash_map_perf pre-alloc 860862 events per sec
>>>>>> 8:hash_map_perf pre-alloc 849561 events per sec
>>>>>> 3:hash_map_perf pre-alloc 849074 events per sec
>>>>>> 6:hash_map_perf pre-alloc 847120 events per sec
>>>>>> 10:hash_map_perf pre-alloc 845047 events per sec
>>>>>> 5:hash_map_perf pre-alloc 841266 events per sec
>>>>>> 14:hash_map_perf pre-alloc 849740 events per sec
>>>>>> 2:hash_map_perf pre-alloc 839598 events per sec
>>>>>> 9:hash_map_perf pre-alloc 838695 events per sec
>>>>>> 11:hash_map_perf pre-alloc 845390 events per sec
>>>>>> 7:hash_map_perf pre-alloc 834865 events per sec
>>>>>> 13:hash_map_perf pre-alloc 842619 events per sec
>>>>>> 1:hash_map_perf pre-alloc 804231 events per sec
>>>>>> 15:hash_map_perf pre-alloc 795314 events per sec
>>>>>>
>>>>>> hash_map the worst: no free
>>>>>> ./map_perf_test 2048
>>>>>> 6:worse hash_map_perf pre-alloc 28628 events per sec
>>>>>> 5:worse hash_map_perf pre-alloc 28553 events per sec
>>>>>> 11:worse hash_map_perf pre-alloc 28543 events per sec
>>>>>> 3:worse hash_map_perf pre-alloc 28444 events per sec
>>>>>> 1:worse hash_map_perf pre-alloc 28418 events per sec
>>>>>> 7:worse hash_map_perf pre-alloc 28427 events per sec
>>>>>> 13:worse hash_map_perf pre-alloc 28330 events per sec
>>>>>> 14:worse hash_map_perf pre-alloc 28263 events per sec
>>>>>> 9:worse hash_map_perf pre-alloc 28211 events per sec
>>>>>> 15:worse hash_map_perf pre-alloc 28193 events per sec
>>>>>> 12:worse hash_map_perf pre-alloc 28190 events per sec
>>>>>> 10:worse hash_map_perf pre-alloc 28129 events per sec
>>>>>> 8:worse hash_map_perf pre-alloc 28116 events per sec
>>>>>> 4:worse hash_map_perf pre-alloc 27906 events per sec
>>>>>> 2:worse hash_map_perf pre-alloc 27801 events per sec
>>>>>> 0:worse hash_map_perf pre-alloc 27416 events per sec
>>>>>> 3:worse hash_map_perf pre-alloc 28188 events per sec
>>>>>>
>>>>>> ftrace trace
>>>>>>
>>>>>> 0)               |  htab_map_update_elem() {
>>>>>> 0)   0.198 us    |    migrate_disable();
>>>>>> 0)               |    _raw_spin_lock_irqsave() {
>>>>>> 0)   0.157 us    |      preempt_count_add();
>>>>>> 0)   0.538 us    |    }
>>>>>> 0)   0.260 us    |    lookup_elem_raw();
>>>>>> 0)               |    alloc_htab_elem() {
>>>>>> 0)               |      __pcpu_freelist_pop() {
>>>>>> 0)               |        _raw_spin_lock() {
>>>>>> 0)   0.152 us    |          preempt_count_add();
>>>>>> 0)   0.352 us    | native_queued_spin_lock_slowpath();
>>>>>> 0)   1.065 us    |        }
>>>>>>                   |        ...
>>>>>> 0)               |        _raw_spin_unlock() {
>>>>>> 0)   0.254 us    |          preempt_count_sub();
>>>>>> 0)   0.555 us    |        }
>>>>>> 0) + 25.188 us   |      }
>>>>>> 0) + 25.486 us   |    }
>>>>>> 0)               |    _raw_spin_unlock_irqrestore() {
>>>>>> 0)   0.155 us    |      preempt_count_sub();
>>>>>> 0)   0.454 us    |    }
>>>>>> 0)   0.148 us    |    migrate_enable();
>>>>>> 0) + 28.439 us   |  }
>>>>>>
>>>>>> The test machine is 16C, trying to get spin_lock 17 times, in 
>>>>>> addition
>>>>>> to 16c, there is an extralist.
>>>>> Is this with small max_entries and a large number of cpus?
>>>>>
>>>>> If so, probably better to fix would be to artificially
>>>>> bump max_entries to be 4x of num_cpus.
>>>>> Racy is_empty check still wastes the loop.
>>>>
>>>> This hash_map worst testcase with 16 CPUs, map's max_entries is 1000.
>>>>
>>>> This is the test case I constructed, it is to fill the map on 
>>>> purpose, and then
>>>>
>>>> continue to update, just to reproduce the problem phenomenon.
>>>>
>>>> The bad case we encountered with 96 CPUs, map's max_entries is 10240.
>>>
>>> For such cases, most likely the map is *almost* full. What is the 
>>> performance if we increase map size, e.g., from 10240 to 16K(16192)?
>>
>> Yes, increasing max_entries can temporarily solve this problem, but 
>> when 16k is used up,
>> it will still encounter this problem. This patch is to try to fix 
>> this corner case.
>
> Okay, if I understand correctly, in your use case, you have lots of 
> different keys and your intention is NOT to capture all the keys in
> the hash table. So given a hash table, it is possible that the hash
> will become full even if you increase the hashtable size.
>
> Maybe you will occasionally delete some keys which will free some
> space but the space will be quickly occupied by the new updates.
>
> For such cases, yes, check whether the free list is empty or not
> before taking the lock should be helpful. But I am wondering
> what is the rationale behind your use case.

My use case is to monitor the network traffic of the server, and use 
five-tuple as the key.
When there is a surge in network traffic, it is possible to cause the 
hash_map to be full.




