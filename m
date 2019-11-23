Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8761080C3
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfKWVPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:15:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:38390 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfKWVPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:15:18 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYckG-0005s5-3B; Sat, 23 Nov 2019 22:15:08 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYckF-000TS5-Ow; Sat, 23 Nov 2019 22:15:07 +0100
Subject: Re: [PATCH bpf-next] bpf: fail mmap without CONFIG_MMU
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20191123205628.828920-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8bd4fa74-0f71-81b3-1dcd-ab09a695a763@iogearbox.net>
Date:   Sat, 23 Nov 2019 22:15:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191123205628.828920-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25642/Sat Nov 23 10:55:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 9:56 PM, Andrii Nakryiko wrote:
> mmap() support for BPF array depends on vmalloc_user_node_flags, which is
> available only on CONFIG_MMU configurations. Fail mmap-able allocations if no
> CONFIG_MMU is set.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   kernel/bpf/syscall.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index bb002f15b32a..242a06fbdf18 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -156,8 +156,12 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
>   	}
>   	if (mmapable) {
>   		BUG_ON(!PAGE_ALIGNED(size));
> +#ifndef CONFIG_MMU
> +		return NULL;
> +#else
>   		return vmalloc_user_node_flags(size, numa_node, GFP_KERNEL |
>   					       __GFP_RETRY_MAYFAIL | flags);

Hmm, this should rather live in include/linux/vmalloc.h, otherwise every future
user of vmalloc_user_node_flags() would need to add this ifdef? vmalloc.h has
the below, so perhaps this could be added there instead:

[..]
#ifndef CONFIG_MMU
extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
static inline void *__vmalloc_node_flags_caller(unsigned long size, int node,
                                                 gfp_t flags, void *caller)
{
         return __vmalloc_node_flags(size, node, flags);
}
#else
extern void *__vmalloc_node_flags_caller(unsigned long size,
                                          int node, gfp_t flags, void *caller);
#endif
[..]

> +#endif
>   	}
>   	return __vmalloc_node_flags_caller(size, numa_node,
>   					   GFP_KERNEL | __GFP_RETRY_MAYFAIL |
> 

