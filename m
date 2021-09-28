Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D797441AF08
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbhI1Mb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:45144 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240571AbhI1Mb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:31:28 -0400
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVCEx-000Gn4-TZ; Tue, 28 Sep 2021 14:29:43 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVCEx-000W89-La; Tue, 28 Sep 2021 14:29:43 +0200
Subject: Re: [PATCH] bpf: Fix integer overflow in
 prealloc_elems_and_freelist()
To:     Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210925053106.1031798-1-th.yasumatsu@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9be5acb8-5eaa-6101-1be8-a74d7df7e20e@iogearbox.net>
Date:   Tue, 28 Sep 2021 14:29:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210925053106.1031798-1-th.yasumatsu@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26306/Tue Sep 28 11:05:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/21 7:31 AM, Tatsuhiko Yasumatsu wrote:
> In prealloc_elems_and_freelist(), the multiplication to calculate the
> size passed to bpf_map_area_alloc() could lead to an integer overflow.
> As a result, out-of-bounds write could occur in pcpu_freelist_populate()
> as reported by KASAN:
> 
> [...]
> [   16.968613] BUG: KASAN: slab-out-of-bounds in pcpu_freelist_populate+0xd9/0x100
> [   16.969408] Write of size 8 at addr ffff888104fc6ea0 by task crash/78
> [   16.970038]
> [   16.970195] CPU: 0 PID: 78 Comm: crash Not tainted 5.15.0-rc2+ #1
> [   16.970878] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [   16.972026] Call Trace:
> [   16.972306]  dump_stack_lvl+0x34/0x44
> [   16.972687]  print_address_description.constprop.0+0x21/0x140
> [   16.973297]  ? pcpu_freelist_populate+0xd9/0x100
> [   16.973777]  ? pcpu_freelist_populate+0xd9/0x100
> [   16.974257]  kasan_report.cold+0x7f/0x11b
> [   16.974681]  ? pcpu_freelist_populate+0xd9/0x100
> [   16.975190]  pcpu_freelist_populate+0xd9/0x100
> [   16.975669]  stack_map_alloc+0x209/0x2a0
> [   16.976106]  __sys_bpf+0xd83/0x2ce0
> [...]
> 
> The possibility of this overflow was originally discussed in [0], but
> was overlooked.
> 
> Fix the integer overflow by casting one operand to u64.
> 
> [0] https://lore.kernel.org/bpf/728b238e-a481-eb50-98e9-b0f430ab01e7@gmail.com/
> 
> Fixes: 557c0c6e7df8 ("bpf: convert stackmap to pre-allocation")
> Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
> ---
>   kernel/bpf/stackmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 09a3fd97d329..8941dc83a769 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -66,7 +66,7 @@ static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
>   	u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;

Thanks a lot for the fix, Tatsuhiko! Could we just change the above elem_size to u64 instead?

>   	int err;
>   
> -	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
> +	smap->elems = bpf_map_area_alloc((u64)elem_size * smap->map.max_entries,
>   					 smap->map.numa_node);
>   	if (!smap->elems)
>   		return -ENOMEM;
> 

Best,
Daniel
