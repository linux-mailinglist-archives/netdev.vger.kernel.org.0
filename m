Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F138509538
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 05:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383863AbiDUDEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 23:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiDUDEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 23:04:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48866E0F4;
        Wed, 20 Apr 2022 20:01:54 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KkMdx2TDrzCrcc;
        Thu, 21 Apr 2022 10:57:25 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 11:01:50 +0800
Message-ID: <0c8976f2-c2d9-8f32-3d2a-725c060fc7e9@huawei.com>
Date:   Thu, 21 Apr 2022 11:01:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next v2 2/6] ftrace: Fix deadloop caused by direct
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
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
References: <20220414162220.1985095-1-xukuohai@huawei.com>
 <20220414162220.1985095-3-xukuohai@huawei.com>
 <20220420192405.4e43a966@gandalf.local.home>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <20220420192405.4e43a966@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/2022 7:24 AM, Steven Rostedt wrote:
> On Thu, 14 Apr 2022 12:22:16 -0400
> Xu Kuohai <xukuohai@huawei.com> wrote:
> 
>> After direct call is enabled for arm64, ftrace selftest enters a
>> dead loop:
>>
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
>> exits, so make trace_direct_tramp() a weak symbol and rewrite it for
>> arm64.
>>
>> To detect this issue directly, call DYN_FTRACE_TEST_NAME() before
>> register_ftrace_graph().
>>
>> Reported-by: Li Huafei <lihuafei1@huawei.com>
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>  arch/arm64/kernel/entry-ftrace.S | 10 ++++++++++
>>  kernel/trace/trace_selftest.c    |  4 +++-
>>  2 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
>> index dfe62c55e3a2..e58eb06ec9b2 100644
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
>> +	mov	x10, x30
>> +	mov	x30, x9
>> +	ret	x10
>> +SYM_FUNC_END(trace_direct_tramp)
>> +#endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
>> +#endif /* CONFIG_FTRACE_SELFTEST */
>> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
>> index abcadbe933bb..38b0d5c9a1e0 100644
>> --- a/kernel/trace/trace_selftest.c
>> +++ b/kernel/trace/trace_selftest.c
>> @@ -785,7 +785,7 @@ static struct fgraph_ops fgraph_ops __initdata  = {
>>  };
>>  
>>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> -noinline __noclone static void trace_direct_tramp(void) { }
>> +void __weak trace_direct_tramp(void) { }
>>  #endif
>>  
>>  /*
> 
> 
>> @@ -868,6 +868,8 @@ trace_selftest_startup_function_graph(struct tracer *trace,
>>  	if (ret)
>>  		goto out;
>>  
>> +	DYN_FTRACE_TEST_NAME();
> 
> This doesn't look like it belongs in this patch.
> 
> -- Steve

This was added to run trace_direct_tramp() separately before registering
function graph, so the dead loop can be caught accurately. However, the
dead loop can also be caught when running function graph test, so this
is somewhat unnecessary and will be removed in v3.

> 
>> +
>>  	ret = register_ftrace_graph(&fgraph_ops);
>>  	if (ret) {
>>  		warn_failed_init_tracer(trace, ret);
> 
> .

