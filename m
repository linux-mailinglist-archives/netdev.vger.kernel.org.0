Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7265D49C859
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbiAZLLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:11:01 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:35874 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240501AbiAZLLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:11:01 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JkLbj3SdVzccr3;
        Wed, 26 Jan 2022 19:10:09 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 19:10:59 +0800
Subject: Re: [PATCH bpf-next] bpf, arm64: enable kfunc call
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220119144942.305568-1-houtao1@huawei.com>
 <b54b3297-086c-1b64-1c25-01f70c6412af@iogearbox.net>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <67471472-d37f-2c56-2e9c-0030a02e1bd9@huawei.com>
Date:   Wed, 26 Jan 2022 19:10:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b54b3297-086c-1b64-1c25-01f70c6412af@iogearbox.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/25/2022 12:21 AM, Daniel Borkmann wrote:
> On 1/19/22 3:49 PM, Hou Tao wrote:
>> Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
>> randomization range to 2 GB"), for arm64 whether KASLR is enabled
>> or not, the module is placed within 2GB of the kernel region, so
>> s32 in bpf_kfunc_desc is sufficient to represente the offset of
>> module function relative to __bpf_call_base. The only thing needed
>> is to override bpf_jit_supports_kfunc_call().
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>
> Lgtm, could we also add a BPF selftest to assert that this assumption
> won't break in future when bpf_jit_supports_kfunc_call() returns true?
>
> E.g. extending lib/test_bpf.ko could be an option, wdyt?
Make sense.  Will figure out how to done that.

Regards,
Tao
>
>> ---
>>   arch/arm64/net/bpf_jit_comp.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>> index e96d4d87291f..74f9a9b6a053 100644
>> --- a/arch/arm64/net/bpf_jit_comp.c
>> +++ b/arch/arm64/net/bpf_jit_comp.c
>> @@ -1143,6 +1143,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog
>> *prog)
>>       return prog;
>>   }
>>   +bool bpf_jit_supports_kfunc_call(void)
>> +{
>> +    return true;
>> +}
>> +
>>   u64 bpf_jit_alloc_exec_limit(void)
>>   {
>>       return VMALLOC_END - VMALLOC_START;
>>
>
> .

