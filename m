Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035204B0817
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbiBJIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:25:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiBJIZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:25:55 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D87D109E;
        Thu, 10 Feb 2022 00:25:56 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nI4lz-000D7n-KY; Thu, 10 Feb 2022 09:25:51 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nI4lz-00050p-Be; Thu, 10 Feb 2022 09:25:51 +0100
Subject: Re: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
To:     Song Liu <song@kernel.org>, linux-mm@kvack.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kernel-team@fb.com,
        akpm@linux-foundation.org, eric.dumazet@gmail.com, mhocko@suse.com
References: <20220210064108.1095847-1-song@kernel.org>
 <20220210064108.1095847-3-song@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <34d0ed40-30cf-a1a2-f4eb-fa3d0a55bce8@iogearbox.net>
Date:   Thu, 10 Feb 2022 09:25:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220210064108.1095847-3-song@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26448/Wed Feb  9 10:31:19 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 7:41 AM, Song Liu wrote:
> bpf_prog_pack uses huge pages to reduce pressue on instruction TLB.
> To guarantee allocating huge pages for bpf_prog_pack, it is necessary to
> allocate memory of size PMD_SIZE * num_online_nodes().
> 
> On the other hand, if the system doesn't support huge pages, it is more
> efficient to allocate PAGE_SIZE bpf_prog_pack.
> 
> Address different scenarios with more flexible bpf_prog_pack_size().
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   kernel/bpf/core.c | 47 +++++++++++++++++++++++++++--------------------
>   1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 42d96549a804..d961a1f07a13 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -814,46 +814,53 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>    * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>    * to host BPF programs.
>    */
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
> -#else
> -#define BPF_PROG_PACK_SIZE	PAGE_SIZE
> -#endif
>   #define BPF_PROG_CHUNK_SHIFT	6
>   #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>   #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
> -#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
>   
>   struct bpf_prog_pack {
>   	struct list_head list;
>   	void *ptr;
> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
> +	unsigned long bitmap[];
>   };
>   
> -#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
>   #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
>   
>   static DEFINE_MUTEX(pack_mutex);
>   static LIST_HEAD(pack_list);
>   
> +static inline int bpf_prog_pack_size(void)
> +{
> +	/* If vmap_allow_huge == true, use pack size of the smallest
> +	 * possible vmalloc huge page: PMD_SIZE * num_online_nodes().
> +	 * Otherwise, use pack size of PAGE_SIZE.
> +	 */
> +	return get_vmap_allow_huge() ? PMD_SIZE * num_online_nodes() : PAGE_SIZE;
> +}

Imho, this is making too many assumptions about implementation details. Can't we
just add a new module_alloc*() API instead which internally guarantees allocating
huge pages when enabled/supported (e.g. with a __weak function as fallback)?

> +static inline int bpf_prog_chunk_count(void)
> +{
> +	return bpf_prog_pack_size() / BPF_PROG_CHUNK_SIZE;
> +}
> +
>   static struct bpf_prog_pack *alloc_new_pack(void)
>   {
>   	struct bpf_prog_pack *pack;
>   
> -	pack = kzalloc(sizeof(*pack), GFP_KERNEL);
> +	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(bpf_prog_chunk_count()), GFP_KERNEL);
>   	if (!pack)
>   		return NULL;
> -	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
> +	pack->ptr = module_alloc(bpf_prog_pack_size());
>   	if (!pack->ptr) {
>   		kfree(pack);
>   		return NULL;
>   	}
> -	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
> +	bitmap_zero(pack->bitmap, bpf_prog_pack_size() / BPF_PROG_CHUNK_SIZE);
>   	list_add_tail(&pack->list, &pack_list);
>   
>   	set_vm_flush_reset_perms(pack->ptr);
> -	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> -	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> +	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size() / PAGE_SIZE);
> +	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size() / PAGE_SIZE);
>   	return pack;
>   }
>   
> @@ -864,7 +871,7 @@ static void *bpf_prog_pack_alloc(u32 size)
>   	unsigned long pos;
>   	void *ptr = NULL;
>   
> -	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +	if (size > bpf_prog_pack_size()) {
>   		size = round_up(size, PAGE_SIZE);
>   		ptr = module_alloc(size);
>   		if (ptr) {
> @@ -876,9 +883,9 @@ static void *bpf_prog_pack_alloc(u32 size)
>   	}
>   	mutex_lock(&pack_mutex);
>   	list_for_each_entry(pack, &pack_list, list) {
> -		pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> +		pos = bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
>   						 nbits, 0);
> -		if (pos < BPF_PROG_CHUNK_COUNT)
> +		if (pos < bpf_prog_chunk_count())
>   			goto found_free_area;
>   	}
>   
> @@ -904,12 +911,12 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
>   	unsigned long pos;
>   	void *pack_ptr;
>   
> -	if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +	if (hdr->size > bpf_prog_pack_size()) {
>   		module_memfree(hdr);
>   		return;
>   	}
>   
> -	pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
> +	pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size() - 1));
>   	mutex_lock(&pack_mutex);
>   
>   	list_for_each_entry(tmp, &pack_list, list) {
> @@ -926,8 +933,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
>   	pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;
>   
>   	bitmap_clear(pack->bitmap, pos, nbits);
> -	if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> -				       BPF_PROG_CHUNK_COUNT, 0) == 0) {
> +	if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
> +				       bpf_prog_chunk_count(), 0) == 0) {
>   		list_del(&pack->list);
>   		module_memfree(pack->ptr);
>   		kfree(pack);
> 

