Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA14D1E08
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbiCHQ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbiCHQ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:59:16 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C038834BA2;
        Tue,  8 Mar 2022 08:58:18 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRdA8-00060e-O6; Tue, 08 Mar 2022 17:58:16 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRdA8-0000D9-Gl; Tue, 08 Mar 2022 17:58:16 +0100
Subject: Re: [PATCH bpf-next] bpf: select proper size for bpf_prog_pack
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kernel-team@fb.com,
        edumazet@google.com
References: <20220304184320.3424748-1-song@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c0be971d-c03e-abcb-83fd-d0b087e38780@iogearbox.net>
Date:   Tue, 8 Mar 2022 17:58:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220304184320.3424748-1-song@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26475/Tue Mar  8 10:31:43 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/22 7:43 PM, Song Liu wrote:
> Using HPAGE_PMD_SIZE as the size for bpf_prog_pack is not ideal in some
> cases. Specifically, for NUMA systems, __vmalloc_node_range requires
> PMD_SIZE * num_online_nodes() to allocate huge pages. Also, if the system
> does not support huge pages (i.e., with cmdline option nohugevmalloc), it
> is better to use PAGE_SIZE packs.
> 
> Add logic to select proper size for bpf_prog_pack. This solution is not
> ideal, as it makes assumption about the behavior of module_alloc and
> __vmalloc_node_range. However, it appears to be the easiest solution as
> it doesn't require changes in module_alloc and vmalloc code.
> 

nit: Fixes tag?

> Signed-off-by: Song Liu <song@kernel.org>
[...]
>   
> +static size_t bpf_prog_pack_size = -1;
> +
> +static inline int bpf_prog_chunk_count(void)
> +{
> +	WARN_ON_ONCE(bpf_prog_pack_size == -1);
> +	return bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE;
> +}
> +
>   static DEFINE_MUTEX(pack_mutex);
>   static LIST_HEAD(pack_list);
>   
>   static struct bpf_prog_pack *alloc_new_pack(void)
>   {
>   	struct bpf_prog_pack *pack;
> +	size_t size;
> +	void *ptr;
>   
> -	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
> -	if (!pack)
> +	if (bpf_prog_pack_size == -1) {
> +		/* Test whether we can get huge pages. If not just use
> +		 * PAGE_SIZE packs.
> +		 */
> +		size = PMD_SIZE * num_online_nodes();
> +		ptr = module_alloc(size);
> +		if (ptr && is_vm_area_hugepages(ptr)) {
> +			bpf_prog_pack_size = size;
> +			goto got_ptr;
> +		} else {
> +			bpf_prog_pack_size = PAGE_SIZE;
> +			vfree(ptr);
> +		}
> +	}
> +
> +	ptr = module_alloc(bpf_prog_pack_size);
> +	if (!ptr)
>   		return NULL;
> -	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
> -	if (!pack->ptr) {
> -		kfree(pack);
> +got_ptr:
> +	pack = kzalloc(struct_size(pack, bitmap, BITS_TO_LONGS(bpf_prog_chunk_count())),
> +		       GFP_KERNEL);
> +	if (!pack) {
> +		vfree(ptr);
>   		return NULL;
>   	}
> -	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
> +	pack->ptr = ptr;
> +	bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
>   	list_add_tail(&pack->list, &pack_list);
>   
>   	set_vm_flush_reset_perms(pack->ptr);
> -	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> -	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> +	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
> +	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
>   	return pack;
>   }
>   
> @@ -864,7 +886,7 @@ static void *bpf_prog_pack_alloc(u32 size)
>   	unsigned long pos;
>   	void *ptr = NULL;
>   
> -	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +	if (size > bpf_prog_pack_size) {
>   		size = round_up(size, PAGE_SIZE);
>   		ptr = module_alloc(size);
>   		if (ptr) {

What happens if the /very first/ program requests an allocation size of >PAGE_SIZE? Wouldn't
this result in OOB write?

The 'size > bpf_prog_pack_size' is initially skipped due to -1 but then the module_alloc()
won't return a huge page, so we redo the allocation with bpf_prog_pack_size as PAGE_SIZE and
return a pointer into this pack?

Thanks,
Daniel
