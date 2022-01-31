Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02204A4C15
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380423AbiAaQ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:29:13 -0500
Received: from www62.your-server.de ([213.133.104.62]:53016 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380402AbiAaQ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:29:09 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEZXu-000EEk-9M; Mon, 31 Jan 2022 17:28:50 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEZXu-000IGM-0X; Mon, 31 Jan 2022 17:28:50 +0100
Subject: Re: [PATCH bpf-next] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
To:     Hou Tao <hotforest@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com
References: <20220131114600.21849-1-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <36954dbd-beab-9599-3579-105037822045@iogearbox.net>
Date:   Mon, 31 Jan 2022 17:28:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220131114600.21849-1-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26439/Mon Jan 31 10:24:40 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/22 12:46 PM, Hou Tao wrote:
> Now the ringbuf area in /proc/vmallocinfo is showed as vmalloc,
> but VM_ALLOC is only used for vmalloc(), and for the ringbuf area
> it is created by mapping allocated pages, so use VM_MAP instead.
> 
> After the change, ringbuf info in /proc/vmallocinfo will changed from:
>    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
> to
>    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user

Could you elaborate in the commit msg if this also has some other internal
effect aside from the /proc/vmallocinfo listing? Thanks!

> Signed-off-by: Hou Tao <houtao1@huawei.com>
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

