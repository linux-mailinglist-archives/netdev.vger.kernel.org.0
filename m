Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1633940F97C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbhIQNrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:47:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9743 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbhIQNrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:47:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H9wDT4glJzW96L;
        Fri, 17 Sep 2021 21:44:41 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 17 Sep 2021 21:45:45 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 17 Sep 2021 21:45:44 +0800
Subject: Re: [PATCH 1/3] bpf: support writable context for bare tracepoint
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210916135511.3787194-1-houtao1@huawei.com>
 <20210916135511.3787194-2-houtao1@huawei.com>
 <9cbbb8b4-f3e3-cd2d-a1cc-e086e7d28946@fb.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <b76d4051-abff-5e75-c812-41c6f283327f@huawei.com>
Date:   Fri, 17 Sep 2021 21:45:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9cbbb8b4-f3e3-cd2d-a1cc-e086e7d28946@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/17/2021 7:16 AM, Yonghong Song wrote:
>
>
> On 9/16/21 6:55 AM, Hou Tao wrote:
>> Commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
>> supports writable context for tracepoint, but it misses the support
>> for bare tracepoint which has no associated trace event.
>>
>> Bare tracepoint is defined by DECLARE_TRACE(), so adding a corresponding
>> DECLARE_TRACE_WRITABLE() macro to generate a definition in __bpf_raw_tp_map
>> section for bare tracepoint in a similar way to DEFINE_TRACE_WRITABLE().
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>   include/trace/bpf_probe.h | 19 +++++++++++++++----
>>   1 file changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
>> index a23be89119aa..d08ee1060d82 100644
>> --- a/include/trace/bpf_probe.h
>> +++ b/include/trace/bpf_probe.h
>> @@ -93,8 +93,7 @@ __section("__bpf_raw_tp_map") = {                    \
>>     #define FIRST(x, ...) x
>>   -#undef DEFINE_EVENT_WRITABLE
>> -#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size)    \
>> +#define __CHECK_WRITABLE_BUF_SIZE(call, proto, args, size)        \
>>   static inline void bpf_test_buffer_##call(void)                \
>>   {                                    \
>>       /* BUILD_BUG_ON() is ignored if the code is completely eliminated, but \
>> @@ -103,8 +102,12 @@ static inline void
>> bpf_test_buffer_##call(void)                \
>>        */                                \
>>       FIRST(proto);                            \
>>       (void)BUILD_BUG_ON_ZERO(size != sizeof(*FIRST(args)));        \
>> -}                                    \
>> -__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>> +}
>> +
>> +#undef DEFINE_EVENT_WRITABLE
>> +#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size) \
>> +    __CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
>> +    __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>>     #undef DEFINE_EVENT
>>   #define DEFINE_EVENT(template, call, proto, args)            \
>> @@ -119,10 +122,18 @@ __DEFINE_EVENT(template, call, PARAMS(proto),
>> PARAMS(args), size)
>>       __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))        \
>>       __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0)
>>   +#undef DECLARE_TRACE_WRITABLE
>> +#define DECLARE_TRACE_WRITABLE(call, proto, args, size) \
>> +    __CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
>> +    __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args)) \
>> +    __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), size)
>> +
>>   #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>>     #undef DEFINE_EVENT_WRITABLE
>> +#undef DECLARE_TRACE_WRITABLE
>>   #undef __DEFINE_EVENT
>> +#undef __CHECK_WRITABLE_BUF_SIZE
>
> Put "#undef __CHECK_WRITABLE_BUF_SIZE" right after "#undef
> DECLARE_TRACE_WRITABLE" since they are related to each other
> and also they are in correct reverse order w.r.t. __DEFINE_EVENT?
If considering __CHECK_WRITABLE_BUF_SIZE is used in both DECLARE_TRACE_WRITABLE and
DEFINE_EVENT_WRITABLE and the order of definitions, is the following order better ?

#undef DECLARE_TRACE_WRITABLE
#undef DEFINE_EVENT_WRITABLE
#undef __CHECK_WRITABLE_BUF_SIZE

>
>>   #undef FIRST
>>     #endif /* CONFIG_BPF_EVENTS */
>>
> .

