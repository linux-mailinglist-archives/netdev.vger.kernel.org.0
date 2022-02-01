Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2936C4A53BE
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiBAAGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:06:06 -0500
Received: from www62.your-server.de ([213.133.104.62]:55566 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiBAAGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:06:06 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEggN-00065t-Jt; Tue, 01 Feb 2022 01:06:03 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEggN-000N71-9E; Tue, 01 Feb 2022 01:06:03 +0100
Subject: Re: [PATCH v7 bpf-next 7/9] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kernel-team@fb.com,
        peterz@infradead.org, x86@kernel.org, iii@linux.ibm.com,
        npiggin@gmail.com
References: <20220128234517.3503701-1-song@kernel.org>
 <20220128234517.3503701-8-song@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ab7e0a98-fced-23b3-6876-01ce711bd579@iogearbox.net>
Date:   Tue, 1 Feb 2022 01:06:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220128234517.3503701-8-song@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26439/Mon Jan 31 10:24:40 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/22 12:45 AM, Song Liu wrote:
> Most BPF programs are small, but they consume a page each. For systems
> with busy traffic and many BPF programs, this could add significant
> pressure to instruction TLB.
> 
> Introduce bpf_prog_pack allocator to pack multiple BPF programs in a huge
> page. The memory is then allocated in 64 byte chunks.
> 
> Memory allocated by bpf_prog_pack allocator is RO protected after initial
> allocation. To write to it, the user (jit engine) need to use text poke
> API.

Did you benchmark the program load times under this API, e.g. how much
overhead is expected for very large programs?

> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   kernel/bpf/core.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 127 insertions(+)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index dc0142e20c72..25e34caa9a95 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -805,6 +805,133 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>   	return slot;
>   }
>   
> +/*
> + * BPF program pack allocator.
> + *
> + * Most BPF programs are pretty small. Allocating a hole page for each
> + * program is sometime a waste. Many small bpf program also adds pressure
> + * to instruction TLB. To solve this issue, we introduce a BPF program pack
> + * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
> + * to host BPF programs.
> + */
> +#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
> +#define BPF_PROG_CHUNK_SHIFT	6
> +#define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
> +#define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
> +#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
> +
> +struct bpf_prog_pack {
> +	struct list_head list;
> +	void *ptr;
> +	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
> +};
> +
> +#define BPF_PROG_MAX_PACK_PROG_SIZE	HPAGE_PMD_SIZE
> +#define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
> +
> +static DEFINE_MUTEX(pack_mutex);
> +static LIST_HEAD(pack_list);
> +
> +static struct bpf_prog_pack *alloc_new_pack(void)
> +{
> +	struct bpf_prog_pack *pack;
> +
> +	pack = kzalloc(sizeof(*pack), GFP_KERNEL);
> +	if (!pack)
> +		return NULL;
> +	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
> +	if (!pack->ptr) {
> +		kfree(pack);
> +		return NULL;
> +	}
> +	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
> +	list_add_tail(&pack->list, &pack_list);
> +
> +	set_vm_flush_reset_perms(pack->ptr);
> +	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> +	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> +	return pack;
> +}
> +
> +static void *bpf_prog_pack_alloc(u32 size)
> +{
> +	unsigned int nbits = BPF_PROG_SIZE_TO_NBITS(size);
> +	struct bpf_prog_pack *pack;
> +	unsigned long pos;
> +	void *ptr = NULL;
> +
> +	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +		size = round_up(size, PAGE_SIZE);
> +		ptr = module_alloc(size);
> +		if (ptr) {
> +			set_vm_flush_reset_perms(ptr);
> +			set_memory_ro((unsigned long)ptr, size / PAGE_SIZE);
> +			set_memory_x((unsigned long)ptr, size / PAGE_SIZE);
> +		}
> +		return ptr;
> +	}
> +	mutex_lock(&pack_mutex);
> +	list_for_each_entry(pack, &pack_list, list) {
> +		pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> +						 nbits, 0);
> +		if (pos < BPF_PROG_CHUNK_COUNT)
> +			goto found_free_area;
> +	}
> +
> +	pack = alloc_new_pack();
> +	if (!pack)
> +		goto out;

Will this effectively disable the JIT for all bpf_prog_pack_alloc requests <=
BPF_PROG_MAX_PACK_PROG_SIZE when vmap_allow_huge is false (e.g. boot param via
nohugevmalloc) ?

> +	pos = 0;
> +
> +found_free_area:
> +	bitmap_set(pack->bitmap, pos, nbits);
> +	ptr = (void *)(pack->ptr) + (pos << BPF_PROG_CHUNK_SHIFT);
> +
> +out:
> +	mutex_unlock(&pack_mutex);
> +	return ptr;
> +}
> +
> +static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
> +{
> +	struct bpf_prog_pack *pack = NULL, *tmp;
> +	unsigned int nbits;
> +	unsigned long pos;
> +	void *pack_ptr;
> +
> +	if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +		module_memfree(hdr);
> +		return;
> +	}
> +
> +	pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
> +	mutex_lock(&pack_mutex);
> +
> +	list_for_each_entry(tmp, &pack_list, list) {
> +		if (tmp->ptr == pack_ptr) {
> +			pack = tmp;
> +			break;
> +		}
> +	}
> +
> +	if (WARN_ONCE(!pack, "bpf_prog_pack bug\n"))
> +		goto out;
> +
> +	nbits = BPF_PROG_SIZE_TO_NBITS(hdr->size);
> +	pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;
> +
> +	bitmap_clear(pack->bitmap, pos, nbits);
> +	if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> +				       BPF_PROG_CHUNK_COUNT, 0) == 0) {
> +		list_del(&pack->list);
> +		module_memfree(pack->ptr);
> +		kfree(pack);
> +	}
> +out:
> +	mutex_unlock(&pack_mutex);
> +}
> +
>   static atomic_long_t bpf_jit_current;
>   
>   /* Can be overridden by an arch's JIT compiler if it has a custom,
> 

