Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB3C40A317
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 04:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbhINCKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 22:10:10 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37336 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233111AbhINCKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 22:10:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UoK3s4Y_1631585325;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoK3s4Y_1631585325)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Sep 2021 10:08:46 +0800
Subject: Re: [PATCH] perf: fix panic by disable ftrace on fault.c
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <d16e7188-1afa-7513-990c-804811747bcb@linux.alibaba.com>
 <d85f9710-67c9-2573-07c4-05d9c677d615@intel.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <1e7a75ab-aa9e-1532-2746-28bfcbc98908@linux.alibaba.com>
Date:   Tue, 14 Sep 2021 10:08:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d85f9710-67c9-2573-07c4-05d9c677d615@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/13 下午10:49, Dave Hansen wrote:
> On 9/12/21 8:30 PM, 王贇 wrote:
>> According to the trace we know the story is like this, the NMI
>> triggered perf IRQ throttling and call perf_log_throttle(),
>> which triggered the swevent overflow, and the overflow process
>> do perf_callchain_user() which triggered a user PF, and the PF
>> process triggered perf ftrace which finally lead into a suspected
>> stack overflow.
>>
>> This patch disable ftrace on fault.c, which help to avoid the panic.
> ...
>> +# Disable ftrace to avoid stack overflow.
>> +CFLAGS_REMOVE_fault.o = $(CC_FLAGS_FTRACE)
> 
> Was this observed on a mainline kernel?

Yes, it is trigger on linux-next.

> 
> How reproducible is this?
> 
> I suspect we're going into do_user_addr_fault(), then falling in here:
> 
>>         if (unlikely(faulthandler_disabled() || !mm)) {
>>                 bad_area_nosemaphore(regs, error_code, address);
>>                 return;
>>         }
> 

Correct, perf_callchain_user() disabled PF which lead into here.

> Then something double faults in perf_swevent_get_recursion_context().
> But, you snipped all of the register dump out so I can't quite see
> what's going on and what might have caused *that* fault.  But, in my
> kernel perf_swevent_get_recursion_context+0x0/0x70 is:
> 
> 	   mov    $0x27d00,%rdx
> 
> which is rather unlikely to fault.

Would you like to check the full trace I just sent see if we can get any
clue?

> 
> Either way, we don't want to keep ftrace out of fault.c.  This patch is
> just a hack, and doesn't really try to fix the underlying problem.  This
> situation *should* be handled today.  There's code there to handle it.
> 
> Something else really funky is going on.

Do you think stack overflow is possible in this case? To be mentioned the NMI
arrive in very high frequency, and reduce perf_event_max_sample_rate to a low
value can also avoid the panic.

Regards,
Michael Wang

> 
