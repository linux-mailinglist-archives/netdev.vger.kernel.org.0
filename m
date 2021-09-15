Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC34640BD76
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 03:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhIOB55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 21:57:57 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:59184 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhIOB54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 21:57:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UoQf.V6_1631670993;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoQf.V6_1631670993)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Sep 2021 09:56:34 +0800
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
 <d8853e49-8b34-4632-3e29-012eb605bea9@linux.alibaba.com>
 <09777a57-a771-5e17-7e17-afc03ea9b83b@linux.alibaba.com>
 <4f63c8bc-1d09-1717-cf81-f9091a9f9fb0@linux.alibaba.com>
 <18252e42-9c30-73d4-e3bb-0e705a78af41@intel.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <4cba7088-f7c8-edcf-02cd-396eb2a56b46@linux.alibaba.com>
Date:   Wed, 15 Sep 2021 09:56:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <18252e42-9c30-73d4-e3bb-0e705a78af41@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/15 上午12:16, Dave Hansen wrote:
> On 9/14/21 12:23 AM, 王贇 wrote:
>>
>> On 2021/9/14 上午11:02, 王贇 wrote:
>> [snip]
>>> [   44.133509][    C0] traps: PANIC: double fault, error_code: 0x0
>>> [   44.133519][    C0] double fault: 0000 [#1] SMP PTI
>>> [   44.133526][    C0] CPU: 0 PID: 743 Comm: a.out Not tainted 5.14.0-next-20210913 #469
>>> [   44.133532][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>> [   44.133536][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
>>> [   44.133549][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 09 20 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 3b d2 7e
>>> [   44.133556][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
>> Another information is that I have printed '__this_cpu_ist_bottom_va(NMI)'
>> on cpu0, which is just the RSP fffffe000000b000, does this imply
>> we got an overflowed NMI stack?
> 
> Yep.  I have the feeling some of your sanitizer and other debugging is
> eating the stack:

Could be, in another thread we have confirmed the exception stack was
overflowed.

> 
>> [   44.134987][    C0]  ? __sanitizer_cov_trace_pc+0x7/0x60
>> [   44.135005][    C0]  ? kcov_common_handle+0x30/0x30
> 
> Just turning off tracing for the page fault handler is papering over the
> problem.  It'll just come back later with a slightly different form.
> 

Cool~ please let me know when you have the proper approach.

Regards,
Michael Wang

