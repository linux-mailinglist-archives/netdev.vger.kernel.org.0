Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FFE50F2AA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 09:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344079AbiDZHjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344221AbiDZHjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:39:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C1CB1D1;
        Tue, 26 Apr 2022 00:36:06 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KnYTw3jHmzCsQV;
        Tue, 26 Apr 2022 15:31:32 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 15:36:02 +0800
Message-ID: <79fe5bb5-c55c-7ddc-640f-50bf8bea7f0b@huawei.com>
Date:   Tue, 26 Apr 2022 15:36:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next v3 2/7] ftrace: Fix deadloop caused by direct
 call in ftrace selftest
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-3-xukuohai@huawei.com>
 <20220425110512.538ce0bf@gandalf.local.home>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <20220425110512.538ce0bf@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/2022 11:05 PM, Steven Rostedt wrote:
> On Sun, 24 Apr 2022 11:40:23 -0400
> Xu Kuohai <xukuohai@huawei.com> wrote:
> 
>> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
>> index abcadbe933bb..d2eff2b1d743 100644
>> --- a/kernel/trace/trace_selftest.c
>> +++ b/kernel/trace/trace_selftest.c
>> @@ -785,8 +785,24 @@ static struct fgraph_ops fgraph_ops __initdata  = {
>>  };
>>  
>>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +#ifdef CONFIG_ARM64
> 
> Please find a way to add this in arm specific code. Do not add architecture
> defines in generic code.
> 
> You could add:
> 
> #ifndef ARCH_HAVE_FTRACE_DIRECT_TEST_FUNC
> noinline __noclone static void trace_direct_tramp(void) { }
> #endif
> 
> here, and in arch/arm64/include/ftrace.h
> 
> #define ARCH_HAVE_FTRACE_DIRECT_TEST_FUNC
> 
> and define your test function in the arm64 specific code.
> 
> -- Steve
> 
> 

will move this to arch/arm64/ in v4, thanks.

> 
> 
>> +extern void trace_direct_tramp(void);
>> +
>> +asm (
>> +"	.pushsection	.text, \"ax\", @progbits\n"
>> +"	.type		trace_direct_tramp, %function\n"
>> +"	.global		trace_direct_tramp\n"
>> +"trace_direct_tramp:"
>> +"	mov	x10, x30\n"
>> +"	mov	x30, x9\n"
>> +"	ret	x10\n"
>> +"	.size		trace_direct_tramp, .-trace_direct_tramp\n"
>> +"	.popsection\n"
>> +);
>> +#else
>>  noinline __noclone static void trace_direct_tramp(void) { }
>>  #endif
>> +#endif
>>  
>>  /*
>>   * Pretty much the same than for the function tracer from which the selftest
> 
> .

