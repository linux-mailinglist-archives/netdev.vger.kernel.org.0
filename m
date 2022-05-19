Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E207552CA20
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiESDNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiESDM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:12:58 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E10052B14
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:12:56 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k16so3949674pff.5
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=6IaBYwoRHRaxkHU7M30ifQh1nkElBKl7D4YjtOVQqYY=;
        b=CmMzXeOJAh6BIxM8VcearYEZsPNG9i4weY+q0nBdW/+BaDt1HixZChQkPCHJpLaFM7
         gh2obS+UcjYG0UD1Zzi6jChw2pK2dmnPTxkqiz/a2tQk+ySShqt6zI0ze1PSFW2Zh5vy
         Cy3yhDsfZDC2IsslcYrGQrJ+QxodnGjkB25mv4dWDvi3VM80N+m4jMsYApmhQYoQEp5W
         S4wsZ8kHOG3Ain84sAEhYas2SFMEovVrJNKOGoHUfI/eRmz2HTt4J3vVJyb1PrUcgF41
         hSWestDp09u0gU2aNUQwKLW2BG0Cj07bm8J17UId2NUxFocnIUmAFADJQUXc320KMH59
         TP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6IaBYwoRHRaxkHU7M30ifQh1nkElBKl7D4YjtOVQqYY=;
        b=05+JjDDbHhASfYaiE3pPsFsyIpdPxWh6gEIfo3Hx2KR5KtOuDNXvF0iAZh4ylKvMVX
         Fqmfzfg1niOVO/hlxfs4FW2eI6OJPA57bjPfL/pI7HqIjok9yys4JgqJvr4LADLfPj4/
         yNPW0hi0/yXVnQ/H7vX6xrWvTJRmBrxiRPk4k48ZBIBlsa3SszkS4W9VUXyNxWVyY3fB
         lJTMiJZBhbilF6VRtR8BnkdJtNuqVcxrDf1TwV8tVOA2hKDbjIfj7eDaaRnFVESwjKKE
         LVH7JayeTy7WWXxBeHhu/cexB6JanzmyIynRrSDhgUsy0Ldq8rns6rvn7ICnHFajZ8tF
         po8w==
X-Gm-Message-State: AOAM531b1JP7dcJw47ALU6UfIBz1HK6Yb6pLRA28Cc5uY1qvO+i83PVy
        QqBC9wqXtrEhg3NRxFiL1UobrA==
X-Google-Smtp-Source: ABdhPJzAwdneH86y+C+f93UpPYQmWHPQcqB6CktJpVLQcQRz7TZouVpUAZ61nvn7xEbk4XNMgbmkkA==
X-Received: by 2002:a62:2701:0:b0:518:2570:b8f6 with SMTP id n1-20020a622701000000b005182570b8f6mr2489091pfn.19.1652929976048;
        Wed, 18 May 2022 20:12:56 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id bv11-20020a17090af18b00b001d6a79768b6sm2264863pjb.49.2022.05.18.20.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 20:12:55 -0700 (PDT)
Message-ID: <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
Date:   Thu, 19 May 2022 11:12:48 +0800
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
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <9c0c3e0b-33bc-51a7-7916-7278f14f308e@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/19 上午4:39, Yonghong Song 写道:
>
>
> On 5/17/22 11:57 PM, Feng Zhou wrote:
>> 在 2022/5/18 下午2:32, Alexei Starovoitov 写道:
>>> On Tue, May 17, 2022 at 11:27 PM Feng zhou 
>>> <zhoufeng.zf@bytedance.com> wrote:
>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>
>>>> We encountered bad case on big system with 96 CPUs that
>>>> alloc_htab_elem() would last for 1ms. The reason is that after the
>>>> prealloc hashtab has no free elems, when trying to update, it will 
>>>> still
>>>> grab spin_locks of all cpus. If there are multiple update users, the
>>>> competition is very serious.
>>>>
>>>> So this patch add is_empty in pcpu_freelist_head to check freelist
>>>> having free or not. If having, grab spin_lock, or check next cpu's
>>>> freelist.
>>>>
>>>> Before patch: hash_map performance
>>>> ./map_perf_test 1
>
> could you explain what parameter '1' means here?

This code is here:
samples/bpf/map_perf_test_user.c
samples/bpf/map_perf_test_kern.c
parameter '1' means testcase flag, test hash_map's performance
parameter '2048' means test hash_map's performance when free=0.
testcase flag '2048' is added by myself to reproduce the problem phenomenon.

>
>>>> 0:hash_map_perf pre-alloc 975345 events per sec
>>>> 4:hash_map_perf pre-alloc 855367 events per sec
>>>> 12:hash_map_perf pre-alloc 860862 events per sec
>>>> 8:hash_map_perf pre-alloc 849561 events per sec
>>>> 3:hash_map_perf pre-alloc 849074 events per sec
>>>> 6:hash_map_perf pre-alloc 847120 events per sec
>>>> 10:hash_map_perf pre-alloc 845047 events per sec
>>>> 5:hash_map_perf pre-alloc 841266 events per sec
>>>> 14:hash_map_perf pre-alloc 849740 events per sec
>>>> 2:hash_map_perf pre-alloc 839598 events per sec
>>>> 9:hash_map_perf pre-alloc 838695 events per sec
>>>> 11:hash_map_perf pre-alloc 845390 events per sec
>>>> 7:hash_map_perf pre-alloc 834865 events per sec
>>>> 13:hash_map_perf pre-alloc 842619 events per sec
>>>> 1:hash_map_perf pre-alloc 804231 events per sec
>>>> 15:hash_map_perf pre-alloc 795314 events per sec
>>>>
>>>> hash_map the worst: no free
>>>> ./map_perf_test 2048
>>>> 6:worse hash_map_perf pre-alloc 28628 events per sec
>>>> 5:worse hash_map_perf pre-alloc 28553 events per sec
>>>> 11:worse hash_map_perf pre-alloc 28543 events per sec
>>>> 3:worse hash_map_perf pre-alloc 28444 events per sec
>>>> 1:worse hash_map_perf pre-alloc 28418 events per sec
>>>> 7:worse hash_map_perf pre-alloc 28427 events per sec
>>>> 13:worse hash_map_perf pre-alloc 28330 events per sec
>>>> 14:worse hash_map_perf pre-alloc 28263 events per sec
>>>> 9:worse hash_map_perf pre-alloc 28211 events per sec
>>>> 15:worse hash_map_perf pre-alloc 28193 events per sec
>>>> 12:worse hash_map_perf pre-alloc 28190 events per sec
>>>> 10:worse hash_map_perf pre-alloc 28129 events per sec
>>>> 8:worse hash_map_perf pre-alloc 28116 events per sec
>>>> 4:worse hash_map_perf pre-alloc 27906 events per sec
>>>> 2:worse hash_map_perf pre-alloc 27801 events per sec
>>>> 0:worse hash_map_perf pre-alloc 27416 events per sec
>>>> 3:worse hash_map_perf pre-alloc 28188 events per sec
>>>>
>>>> ftrace trace
>>>>
>>>> 0)               |  htab_map_update_elem() {
>>>> 0)   0.198 us    |    migrate_disable();
>>>> 0)               |    _raw_spin_lock_irqsave() {
>>>> 0)   0.157 us    |      preempt_count_add();
>>>> 0)   0.538 us    |    }
>>>> 0)   0.260 us    |    lookup_elem_raw();
>>>> 0)               |    alloc_htab_elem() {
>>>> 0)               |      __pcpu_freelist_pop() {
>>>> 0)               |        _raw_spin_lock() {
>>>> 0)   0.152 us    |          preempt_count_add();
>>>> 0)   0.352 us    | native_queued_spin_lock_slowpath();
>>>> 0)   1.065 us    |        }
>>>>                   |        ...
>>>> 0)               |        _raw_spin_unlock() {
>>>> 0)   0.254 us    |          preempt_count_sub();
>>>> 0)   0.555 us    |        }
>>>> 0) + 25.188 us   |      }
>>>> 0) + 25.486 us   |    }
>>>> 0)               |    _raw_spin_unlock_irqrestore() {
>>>> 0)   0.155 us    |      preempt_count_sub();
>>>> 0)   0.454 us    |    }
>>>> 0)   0.148 us    |    migrate_enable();
>>>> 0) + 28.439 us   |  }
>>>>
>>>> The test machine is 16C, trying to get spin_lock 17 times, in addition
>>>> to 16c, there is an extralist.
>>> Is this with small max_entries and a large number of cpus?
>>>
>>> If so, probably better to fix would be to artificially
>>> bump max_entries to be 4x of num_cpus.
>>> Racy is_empty check still wastes the loop.
>>
>> This hash_map worst testcase with 16 CPUs, map's max_entries is 1000.
>>
>> This is the test case I constructed, it is to fill the map on 
>> purpose, and then
>>
>> continue to update, just to reproduce the problem phenomenon.
>>
>> The bad case we encountered with 96 CPUs, map's max_entries is 10240.
>
> For such cases, most likely the map is *almost* full. What is the 
> performance if we increase map size, e.g., from 10240 to 16K(16192)?

Yes, increasing max_entries can temporarily solve this problem, but when 
16k is used up,
it will still encounter this problem. This patch is to try to fix this 
corner case.


