Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725F45698D8
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiGGDf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiGGDf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:35:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5DD1C91F;
        Wed,  6 Jul 2022 20:35:27 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ldhnt2x4VzcmyX;
        Thu,  7 Jul 2022 11:33:22 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 11:35:24 +0800
Message-ID: <82d7c23c-3aa4-b637-1050-9407c1f74045@huawei.com>
Date:   Thu, 7 Jul 2022 11:35:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
Content-Language: en-US
To:     KP Singh <kpsingh@kernel.org>, Will Deacon <will@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        <jean-philippe.brucker@arm.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
 <20220705160045.GA1240@willie-the-truck>
 <CACYkzJ4e6qrB+HV7Nj=S-zCsPZjcxwMFCBMSnrYbdkLaD04Hqg@mail.gmail.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <CACYkzJ4e6qrB+HV7Nj=S-zCsPZjcxwMFCBMSnrYbdkLaD04Hqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/2022 2:34 AM, KP Singh wrote:
> On Tue, Jul 5, 2022 at 6:00 PM Will Deacon <will@kernel.org> wrote:
>>
>> Hi Daniel,
>>
>> On Thu, Jun 30, 2022 at 11:12:54PM +0200, Daniel Borkmann wrote:
>>> On 6/25/22 6:12 PM, Xu Kuohai wrote:
>>>> This patchset introduces bpf trampoline on arm64. A bpf trampoline converts
>>>> native calling convention to bpf calling convention and is used to implement
>>>> various bpf features, such as fentry, fexit, fmod_ret and struct_ops.
>>>>
>>>> The trampoline introduced does essentially the same thing as the bpf
>>>> trampoline does on x86.
>>>>
>>>> Tested on raspberry pi 4b and qemu:
>>>>
>>>>   #18 /1     bpf_tcp_ca/dctcp:OK
>>>>   #18 /2     bpf_tcp_ca/cubic:OK
>>>>   #18 /3     bpf_tcp_ca/invalid_license:OK
>>>>   #18 /4     bpf_tcp_ca/dctcp_fallback:OK
>>>>   #18 /5     bpf_tcp_ca/rel_setsockopt:OK
>>>>   #18        bpf_tcp_ca:OK
>>>>   #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
>>>>   #51 /2     dummy_st_ops/dummy_init_ret_value:OK
>>>>   #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
>>>>   #51 /4     dummy_st_ops/dummy_multiple_args:OK
>>>>   #51        dummy_st_ops:OK
>>>>   #57 /1     fexit_bpf2bpf/target_no_callees:OK
>>>>   #57 /2     fexit_bpf2bpf/target_yes_callees:OK
>>>>   #57 /3     fexit_bpf2bpf/func_replace:OK
>>>>   #57 /4     fexit_bpf2bpf/func_replace_verify:OK
>>>>   #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
>>>>   #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
>>>>   #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
>>>>   #57 /8     fexit_bpf2bpf/func_replace_multi:OK
>>>>   #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
>>>>   #57        fexit_bpf2bpf:OK
>>>>   #237       xdp_bpf2bpf:OK
>>>>
>>>> v6:
>>>> - Since Mark is refactoring arm64 ftrace to support long jump and reduce the
>>>>    ftrace trampoline overhead, it's not clear how we'll attach bpf trampoline
>>>>    to regular kernel functions, so remove ftrace related patches for now.
>>>> - Add long jump support for attaching bpf trampoline to bpf prog, since bpf
>>>>    trampoline and bpf prog are allocated via vmalloc, there is chance the
>>>>    distance exceeds the max branch range.
>>>> - Collect ACK/Review-by, not sure if the ACK and Review-bys for bpf_arch_text_poke()
>>>>    should be kept, since the changes to it is not trivial
> 
> +1 I need to give it another pass.>

Thank you verfy much! But I have to admit a problem. This patchset does
not suport attaching bpf trampoline to regular kernel functions with
ftrace. So lsm still does not work since the LSM HOOKS themselves are
regular kernel functions. Sorry about that and hopefully we'll find an
acceptable solution soon.

>>>> - Update some commit messages and comments
>>>
>>> Given you've been taking a look and had objections in v5, would be great if you
>>> can find some cycles for this v6.
>>
>> Mark's out at the moment, so I wouldn't hold this series up pending his ack.
>> However, I agree that it would be good if _somebody_ from the Arm side can
>> give it the once over, so I've added Jean-Philippe to cc in case he has time
> 
> Makes sense,  Jean-Philippe had worked on BPF trampolines for ARM.
> 
>> for a quick review. KP said he would also have a look, as he is interested
> 
> Thank you so much Will, I will give this another pass before the end
> of the week.
> 
>> in this series landing.
>>
>> Failing that, I'll try to look this week, but I'm off next week and I don't
>> want this to miss the merge window on my account.
> 
> Thanks for being considerate. Much appreciated.
> 
> - KP
> 
>>
>> Cheers,
>>
>> Will
> .

