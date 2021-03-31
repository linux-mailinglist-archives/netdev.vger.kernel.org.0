Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A3A34FFFC
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbhCaMLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:11:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:59378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235019AbhCaMLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 08:11:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8E6DB1E5;
        Wed, 31 Mar 2021 12:11:03 +0000 (UTC)
Subject: Re: [PATCH V2 1/1] mm:improve the performance during fork
To:     Andrew Morton <akpm@linux-foundation.org>, qianjun.kernel@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210329123635.56915-1-qianjun.kernel@gmail.com>
 <20210330224406.5e195f3b8b971ff2a56c657d@linux-foundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <9f012469-ccda-2c95-aa5a-7ca4f6fb2891@suse.cz>
Date:   Wed, 31 Mar 2021 14:11:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210330224406.5e195f3b8b971ff2a56c657d@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 7:44 AM, Andrew Morton wrote:
> On Mon, 29 Mar 2021 20:36:35 +0800 qianjun.kernel@gmail.com wrote:
> 
>> From: jun qian <qianjun.kernel@gmail.com>
>> 
>> In our project, Many business delays come from fork, so
>> we started looking for the reason why fork is time-consuming.
>> I used the ftrace with function_graph to trace the fork, found
>> that the vm_normal_page will be called tens of thousands and
>> the execution time of this vm_normal_page function is only a
>> few nanoseconds. And the vm_normal_page is not a inline function.
>> So I think if the function is inline style, it maybe reduce the
>> call time overhead.
>> 
>> I did the following experiment:
>> 
>> use the bpftrace tool to trace the fork time :
>> 
>> bpftrace -e 'kprobe:_do_fork/comm=="redis-server"/ {@st=nsecs;} \
>> kretprobe:_do_fork /comm=="redis-server"/{printf("the fork time \
>> is %d us\n", (nsecs-@st)/1000)}'
>> 
>> no inline vm_normal_page:
>> result:
>> the fork time is 40743 us
>> the fork time is 41746 us
>> the fork time is 41336 us
>> the fork time is 42417 us
>> the fork time is 40612 us
>> the fork time is 40930 us
>> the fork time is 41910 us
>> 
>> inline vm_normal_page:
>> result:
>> the fork time is 39276 us
>> the fork time is 38974 us
>> the fork time is 39436 us
>> the fork time is 38815 us
>> the fork time is 39878 us
>> the fork time is 39176 us
>> 
>> In the same test environment, we can get 3% to 4% of
>> performance improvement.
>> 
>> note:the test data is from the 4.18.0-193.6.3.el8_2.v1.1.x86_64,
>> because my product use this version kernel to test the redis
>> server, If you need to compare the latest version of the kernel
>> test data, you can refer to the version 1 Patch.
>> 
>> We need to compare the changes in the size of vmlinux:
>>                   inline           non-inline       diff
>> vmlinux size      9709248 bytes    9709824 bytes    -576 bytes
>> 
> 
> I get very different results with gcc-7.2.0:
> 
> q:/usr/src/25> size mm/memory.o
>    text    data     bss     dec     hex filename
>   74898    3375      64   78337   13201 mm/memory.o-before
>   75119    3363      64   78546   132d2 mm/memory.o-after

I got this:

./scripts/bloat-o-meter memory.o.before mm/memory.o
add/remove: 0/0 grow/shrink: 1/3 up/down: 285/-86 (199)
Function                                     old     new   delta
copy_pte_range                              2095    2380    +285
vm_normal_page                               168     163      -5
do_anonymous_page                           1039    1003     -36
do_swap_page                                1835    1790     -45
Total: Before=42411, After=42610, chg +0.47%


> That's a somewhat significant increase in code size, and larger code
> size has a worsened cache footprint.
> 
> Not that this is necessarily a bad thing for a function which is
> tightly called many times in succession as is vm__normal_page()

Hm but the inline only affects the users within mm/memory.c, unless the kernel
is built with link time optimization (LTO), which is not AFAIK not the standard yet.

>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -592,7 +592,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
>>   * PFNMAP mappings in order to support COWable mappings.
>>   *
>>   */
>> -struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>> +inline struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>>  			    pte_t pte)
>>  {
>>  	unsigned long pfn = pte_pfn(pte);
> 
> I'm a bit surprised this made any difference - rumour has it that
> modern gcc just ignores `inline' and makes up its own mind.  Which is
> why we added __always_inline.

AFAIK it doesn't completely ignore it, just takes it as a hint in addition to
its own heuristics. So adding the keyword might flip the decision to inline in
some cases, but is not guaranteed to.
