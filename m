Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB03A34F852
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 07:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhCaFoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 01:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233595AbhCaFoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 01:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545C06024A;
        Wed, 31 Mar 2021 05:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617169447;
        bh=Xhc7zQfL4bF/OHNK1HpEfoIAv4vWvUPs8jQIpfTLYIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OXDwaqr5QvEDOc9RMY6XwR+lv1+jUCOhFLEavt/HREAXlF7KvJraHMSNFiwkcYa0G
         Pge5v+dcMHAuJHF1HZSnLDmsmb/L8xYOpn3mPxog3+kaNVjpqQPLelzIE9/jv/YzSU
         iGI3uaLXguWFaPHmJnTG/QJqrNUN/3owSCpkkNZ4=
Date:   Tue, 30 Mar 2021 22:44:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     qianjun.kernel@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH V2 1/1] mm:improve the performance during fork
Message-Id: <20210330224406.5e195f3b8b971ff2a56c657d@linux-foundation.org>
In-Reply-To: <20210329123635.56915-1-qianjun.kernel@gmail.com>
References: <20210329123635.56915-1-qianjun.kernel@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Mar 2021 20:36:35 +0800 qianjun.kernel@gmail.com wrote:

> From: jun qian <qianjun.kernel@gmail.com>
> 
> In our project, Many business delays come from fork, so
> we started looking for the reason why fork is time-consuming.
> I used the ftrace with function_graph to trace the fork, found
> that the vm_normal_page will be called tens of thousands and
> the execution time of this vm_normal_page function is only a
> few nanoseconds. And the vm_normal_page is not a inline function.
> So I think if the function is inline style, it maybe reduce the
> call time overhead.
> 
> I did the following experiment:
> 
> use the bpftrace tool to trace the fork time :
> 
> bpftrace -e 'kprobe:_do_fork/comm=="redis-server"/ {@st=nsecs;} \
> kretprobe:_do_fork /comm=="redis-server"/{printf("the fork time \
> is %d us\n", (nsecs-@st)/1000)}'
> 
> no inline vm_normal_page:
> result:
> the fork time is 40743 us
> the fork time is 41746 us
> the fork time is 41336 us
> the fork time is 42417 us
> the fork time is 40612 us
> the fork time is 40930 us
> the fork time is 41910 us
> 
> inline vm_normal_page:
> result:
> the fork time is 39276 us
> the fork time is 38974 us
> the fork time is 39436 us
> the fork time is 38815 us
> the fork time is 39878 us
> the fork time is 39176 us
> 
> In the same test environment, we can get 3% to 4% of
> performance improvement.
> 
> note:the test data is from the 4.18.0-193.6.3.el8_2.v1.1.x86_64,
> because my product use this version kernel to test the redis
> server, If you need to compare the latest version of the kernel
> test data, you can refer to the version 1 Patch.
> 
> We need to compare the changes in the size of vmlinux:
>                   inline           non-inline       diff
> vmlinux size      9709248 bytes    9709824 bytes    -576 bytes
> 

I get very different results with gcc-7.2.0:

q:/usr/src/25> size mm/memory.o
   text    data     bss     dec     hex filename
  74898    3375      64   78337   13201 mm/memory.o-before
  75119    3363      64   78546   132d2 mm/memory.o-after

That's a somewhat significant increase in code size, and larger code
size has a worsened cache footprint.

Not that this is necessarily a bad thing for a function which is
tightly called many times in succession as is vm__normal_page()

> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -592,7 +592,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
>   * PFNMAP mappings in order to support COWable mappings.
>   *
>   */
> -struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
> +inline struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  			    pte_t pte)
>  {
>  	unsigned long pfn = pte_pfn(pte);

I'm a bit surprised this made any difference - rumour has it that
modern gcc just ignores `inline' and makes up its own mind.  Which is
why we added __always_inline.

