Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46390534CAF
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346906AbiEZJpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiEZJpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:45:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FEAC1EF9;
        Thu, 26 May 2022 02:45:14 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L830X0wP5zgYPK;
        Thu, 26 May 2022 17:43:40 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 26 May 2022 17:45:10 +0800
Message-ID: <ee9aba0e-b6ef-2cbb-acbd-76f807b11e62@huawei.com>
Date:   Thu, 26 May 2022 17:45:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v5 2/6] ftrace: Fix deadloop caused by direct
 call in ftrace selftest
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
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
References: <20220518131638.3401509-1-xukuohai@huawei.com>
 <20220518131638.3401509-3-xukuohai@huawei.com>
 <Yo4ymwu92gM75/Z5@FVFF77S0Q05N>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <Yo4ymwu92gM75/Z5@FVFF77S0Q05N>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/2022 9:43 PM, Mark Rutland wrote:
> On Wed, May 18, 2022 at 09:16:34AM -0400, Xu Kuohai wrote:
>> After direct call is enabled for arm64, ftrace selftest enters a
>> dead loop:
> 
> IIUC this means that patch 1 alone is broken, and presumably this patch should
> have been part of it?

No, patch 1 is not broken. This patch fixes bug in the selftest
trampoline, not bug in patch 1.

> 
>> <trace_selftest_dynamic_test_func>:
>> 00  bti     c
>> 01  mov     x9, x30                            <trace_direct_tramp>:
>> 02  bl      <trace_direct_tramp>    ---------->     ret
>>                                                      |
>>                                          lr/x30 is 03, return to 03
>>                                                      |
>> 03  mov     w0, #0x0   <-----------------------------|
>>      |                                               |
>>      |                   dead loop!                  |
>>      |                                               |
>> 04  ret   ---- lr/x30 is still 03, go back to 03 ----|
>>
>> The reason is that when the direct caller trace_direct_tramp() returns
>> to the patched function trace_selftest_dynamic_test_func(), lr is still
>> the address after the instrumented instruction in the patched function,
>> so when the patched function exits, it returns to itself!
>>
>> To fix this issue, we need to restore lr before trace_direct_tramp()
>> exits, so rewrite a dedicated trace_direct_tramp() for arm64.
> 
> As mentioned on patch 1 I'd prefer we solved this through indirection, which
> would avoid the need for this and would make things more robust generally by
> keeping the unusual calling convention private to the patch-site and regular
> trampoline.
>

IIUC, we still need to restore x30 before returning from the trampoline
even through indirection, so this bug is still there.

> Thanks,
> Mark.
> 
>> Reported-by: Li Huafei <lihuafei1@huawei.com>
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>  arch/arm64/include/asm/ftrace.h  | 10 ++++++++++
>>  arch/arm64/kernel/entry-ftrace.S | 10 ++++++++++
>>  kernel/trace/trace_selftest.c    |  2 ++
>>  3 files changed, 22 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
>> index 14a35a5df0a1..6f6b184e72fb 100644
>> --- a/arch/arm64/include/asm/ftrace.h
>> +++ b/arch/arm64/include/asm/ftrace.h
>> @@ -126,6 +126,16 @@ static inline bool arch_syscall_match_sym_name(const char *sym,
>>  	 */
>>  	return !strcmp(sym + 8, name);
>>  }
>> +
>> +#ifdef CONFIG_FTRACE_SELFTEST
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +
>> +#define trace_direct_tramp trace_direct_tramp
>> +extern void trace_direct_tramp(void);
>> +
>> +#endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
>> +#endif /* CONFIG_FTRACE_SELFTEST */
>> +
>>  #endif /* ifndef __ASSEMBLY__ */
>>  
>>  #endif /* __ASM_FTRACE_H */
>> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
>> index dfe62c55e3a2..a47e87d4d3dd 100644
>> --- a/arch/arm64/kernel/entry-ftrace.S
>> +++ b/arch/arm64/kernel/entry-ftrace.S
>> @@ -357,3 +357,13 @@ SYM_CODE_START(return_to_handler)
>>  	ret
>>  SYM_CODE_END(return_to_handler)
>>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>> +
>> +#ifdef CONFIG_FTRACE_SELFTEST
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +SYM_FUNC_START(trace_direct_tramp)
>> +	mov x10, x30
>> +	mov x30, x9
>> +	ret x10
>> +SYM_FUNC_END(trace_direct_tramp)
>> +#endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
>> +#endif /* CONFIG_FTRACE_SELFTEST */
>> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
>> index abcadbe933bb..e7ccd0d10c39 100644
>> --- a/kernel/trace/trace_selftest.c
>> +++ b/kernel/trace/trace_selftest.c
>> @@ -785,8 +785,10 @@ static struct fgraph_ops fgraph_ops __initdata  = {
>>  };
>>  
>>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +#ifndef trace_direct_tramp
>>  noinline __noclone static void trace_direct_tramp(void) { }
>>  #endif
>> +#endif
>>  
>>  /*
>>   * Pretty much the same than for the function tracer from which the selftest
>> -- 
>> 2.30.2
>>
> .

