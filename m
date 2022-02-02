Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573E94A70BD
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbiBBM0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:26:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:58456 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344136AbiBBM0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:26:49 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFEig-000Gr5-Hl; Wed, 02 Feb 2022 13:26:42 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFEig-000O4J-6a; Wed, 02 Feb 2022 13:26:42 +0100
Subject: Re: [PATCH bpf-next v2] bpf: use VM_MAP instead of VM_ALLOC for
 ringbuf
To:     Hou Tao <hotforest@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com,
        Andrey Konovalov <andreyknvl@google.com>
References: <20220202060158.6260-1-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c6c74927-0199-617a-c4b2-bb4d0a733906@iogearbox.net>
Date:   Wed, 2 Feb 2022 13:26:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220202060158.6260-1-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26441/Wed Feb  2 10:43:13 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +Andrey ]

On 2/2/22 7:01 AM, Hou Tao wrote:
> After commit 2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages
> after mapping"), non-VM_ALLOC mappings will be marked as accessible
> in __get_vm_area_node() when KASAN is enabled. But now the flag for
> ringbuf area is VM_ALLOC, so KASAN will complain out-of-bound access
> after vmap() returns. Because the ringbuf area is created by mapping
> allocated pages, so use VM_MAP instead.
> 
> After the change, info in /proc/vmallocinfo also changes from
>    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
> to
>    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user
> 
> Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> v2:
>    * explain why VM_ALLOC will lead to vmalloc-oob access

Do you know which tree commit 2fd3fb0be1d1 is, looks like it's neither
in bpf nor in bpf-next tree at the moment.

Either way, I presume this fix should be routed via bpf tree rather
than bpf-next? (I can add Fixes tag while applying.)

>    * add Reported-by tag
> v1: https://lore.kernel.org/bpf/CANUnq3a+sT_qtO1wNQ3GnLGN7FLvSSgvit2UVgqQKRpUvs85VQ@mail.gmail.com/T/#t
> ---
>   kernel/bpf/ringbuf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index 638d7fd7b375..710ba9de12ce 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
>   	}
>   
>   	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> -		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> +		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
>   	if (rb) {
>   		kmemleak_not_leak(pages);
>   		rb->pages = pages;
> 

