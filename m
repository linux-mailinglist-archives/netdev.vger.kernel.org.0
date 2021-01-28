Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160F53068C4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhA1Am4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:42:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:39700 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhA1Ama (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 19:42:30 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4vNP-0007JP-Oa; Thu, 28 Jan 2021 01:41:35 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4vNP-000Pcf-ET; Thu, 28 Jan 2021 01:41:35 +0100
Subject: Re: [PATCH] bpf: Fix integer overflow in argument calculation for
 bpf_map_area_alloc
To:     Bui Quang Minh <minhquangbui99@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210126082606.3183-1-minhquangbui99@gmail.com>
 <CACAyw99bEYWJCSGqfLiJ9Jp5YE1ZsZSiJxb4RFUTwbofipf0dA@mail.gmail.com>
 <20210127042341.GA4948@ubuntu>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f4d20d92-2370-a8d3-d56c-408819a5f7f4@iogearbox.net>
Date:   Thu, 28 Jan 2021 01:41:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210127042341.GA4948@ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26062/Wed Jan 27 13:26:15 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/21 5:23 AM, Bui Quang Minh wrote:
> On Tue, Jan 26, 2021 at 09:36:57AM +0000, Lorenz Bauer wrote:
>> On Tue, 26 Jan 2021 at 08:26, Bui Quang Minh <minhquangbui99@gmail.com> wrote:
>>>
>>> In 32-bit architecture, the result of sizeof() is a 32-bit integer so
>>> the expression becomes the multiplication between 2 32-bit integer which
>>> can potentially leads to integer overflow. As a result,
>>> bpf_map_area_alloc() allocates less memory than needed.
>>>
>>> Fix this by casting 1 operand to u64.
>>
>> Some quick thoughts:
>> * Should this have a Fixes tag?
> 
> Ok, I will add Fixes tag in later version patch.
> 
>> * Seems like there are quite a few similar calls scattered around
>> (cpumap, etc.). Did you audit these as well?
> 
[...]
> In cpumap,
> 
> 	static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
> 	{
> 		cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
> 						   sizeof(struct bpf_cpu_map_entry *),
> 						   cmap->map.numa_node);
> 	}
> 
> I think this is safe because max_entries is not permitted to be larger than NR_CPUS.

Yes.

> In stackmap, there is a place that I'm not very sure about
> 
> 	static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
> 	{
> 		u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
> 		smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
> 						 smap->map.numa_node);
> 	}
> 
> This is called after another bpf_map_area_alloc in stack_map_alloc(). In the first
> bpf_map_area_alloc() the argument is calculated in an u64 variable; so if in the second
> one, there is an integer overflow then the first one must be called with size > 4GB. I
> think the first one will probably fail (I am not sure about the actual limit of vmalloc()),
> so the second one might not be called.

I would sanity check this as well. Looks like k*alloc()/v*alloc() call sites typically
use array_size() which returns SIZE_MAX on overflow, 610b15c50e86 ("overflow.h: Add
allocation size calculation helpers").

Thanks,
Daniel
