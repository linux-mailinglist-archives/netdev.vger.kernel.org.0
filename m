Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0792C40D21C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 05:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhIPDnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 23:43:47 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56456 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233630AbhIPDnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 23:43:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UoXWyLM_1631763742;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoXWyLM_1631763742)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Sep 2021 11:42:23 +0800
Subject: Re: [PATCH] x86: Increase exception stack sizes
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:X86 MM" <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <d16e7188-1afa-7513-990c-804811747bcb@linux.alibaba.com>
 <d85f9710-67c9-2573-07c4-05d9c677d615@intel.com>
 <d8853e49-8b34-4632-3e29-012eb605bea9@linux.alibaba.com>
 <09777a57-a771-5e17-7e17-afc03ea9b83b@linux.alibaba.com>
 <4f63c8bc-1d09-1717-cf81-f9091a9f9fb0@linux.alibaba.com>
 <18252e42-9c30-73d4-e3bb-0e705a78af41@intel.com>
 <4cba7088-f7c8-edcf-02cd-396eb2a56b46@linux.alibaba.com>
 <bbe09ffb-08b7-824c-943f-dffef51e98c2@intel.com>
 <ac31b8c7-122e-3467-566b-54f053ca0ae2@linux.alibaba.com>
 <09d0190b-f2cc-9e64-4d3a-4eb0def22b7b@linux.alibaba.com>
 <YUIO9Ye98S5Eb68w@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <0278349e-3a6d-9ebd-6cc3-490fb99d1990@linux.alibaba.com>
Date:   Thu, 16 Sep 2021 11:42:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUIO9Ye98S5Eb68w@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/15 下午11:19, Peter Zijlstra wrote:
> On Wed, Sep 15, 2021 at 03:34:20PM +0800, 王贇 wrote:
>> Hi, Dave, Peter
>>
>> What if we just increase the stack size when ftrace enabled?
> 
> I think we can do an unconditional increase. But please first test that
> guard page patch :-)

Nice~ let's focus on the guard one firstly.

Regards,
Michael Wang

> 
> ---
> Subject: x86: Increase exception stack sizes
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Sep 15 16:19:46 CEST 2021
> 
> It turns out that a single page of stack is trivial to overflow with
> all the tracing gunk enabled. Raise the exception stacks to 2 pages,
> which is still half the interrupt stacks, which are at 4 pages.
> 
> Reported-by: Michael Wang <yun.wang@linux.alibaba.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/include/asm/page_64_types.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/include/asm/page_64_types.h
> +++ b/arch/x86/include/asm/page_64_types.h
> @@ -15,7 +15,7 @@
>  #define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
>  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
>  
> -#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
> +#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
>  #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
>  
>  #define IRQ_STACK_ORDER (2 + KASAN_STACK_ORDER)
> 
