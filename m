Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E962B4A53FA
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiBAAVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:21:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:57544 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiBAAVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:21:08 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEguw-0007qv-C9; Tue, 01 Feb 2022 01:21:06 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEguw-000PnY-1l; Tue, 01 Feb 2022 01:21:06 +0100
Subject: Re: [PATCH v7 bpf-next 8/9] bpf: introduce
 bpf_jit_binary_pack_[alloc|finalize|free]
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kernel-team@fb.com,
        peterz@infradead.org, x86@kernel.org, iii@linux.ibm.com,
        Song Liu <songliubraving@fb.com>
References: <20220128234517.3503701-1-song@kernel.org>
 <20220128234517.3503701-9-song@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c5100e9a-3e8a-a554-1d77-50d7b296340b@iogearbox.net>
Date:   Tue, 1 Feb 2022 01:21:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220128234517.3503701-9-song@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26439/Mon Jan 31 10:24:40 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/22 12:45 AM, Song Liu wrote:
[...]
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 25e34caa9a95..ff0c51ef1cb7 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1031,6 +1031,109 @@ void bpf_jit_binary_free(struct bpf_binary_header *hdr)
>   	bpf_jit_uncharge_modmem(size);
>   }
>   
> +/* Allocate jit binary from bpf_prog_pack allocator.
> + * Since the allocated meory is RO+X, the JIT engine cannot write directly

nit: meory

> + * to the memory. To solve this problem, a RW buffer is also allocated at
> + * as the same time. The JIT engine should calculate offsets based on the
> + * RO memory address, but write JITed program to the RW buffer. Once the
> + * JIT engine finishes, it calls bpf_jit_binary_pack_finalize, which copies
> + * the JITed program to the RO memory.
> + */
> +struct bpf_binary_header *
> +bpf_jit_binary_pack_alloc(unsigned int proglen, u8 **image_ptr,
> +			  unsigned int alignment,
> +			  struct bpf_binary_header **rw_header,
> +			  u8 **rw_image,
> +			  bpf_jit_fill_hole_t bpf_fill_ill_insns)
> +{
> +	struct bpf_binary_header *ro_header;
> +	u32 size, hole, start;
> +
> +	WARN_ON_ONCE(!is_power_of_2(alignment) ||
> +		     alignment > BPF_IMAGE_ALIGNMENT);
> +
> +	/* add 16 bytes for a random section of illegal instructions */
> +	size = round_up(proglen + sizeof(*ro_header) + 16, BPF_PROG_CHUNK_SIZE);
> +
> +	if (bpf_jit_charge_modmem(size))
> +		return NULL;
> +	ro_header = bpf_prog_pack_alloc(size);
> +	if (!ro_header) {
> +		bpf_jit_uncharge_modmem(size);
> +		return NULL;
> +	}
> +
> +	*rw_header = kvmalloc(size, GFP_KERNEL);
> +	if (!*rw_header) {
> +		bpf_prog_pack_free(ro_header);
> +		bpf_jit_uncharge_modmem(size);
> +		return NULL;
> +	}
> +
> +	/* Fill space with illegal/arch-dep instructions. */
> +	bpf_fill_ill_insns(*rw_header, size);
> +	(*rw_header)->size = size;
> +
> +	hole = min_t(unsigned int, size - (proglen + sizeof(*ro_header)),
> +		     BPF_PROG_CHUNK_SIZE - sizeof(*ro_header));
> +	start = (get_random_int() % hole) & ~(alignment - 1);
> +
> +	*image_ptr = &ro_header->image[start];
> +	*rw_image = &(*rw_header)->image[start];
> +
> +	return ro_header;
> +}
> +
> +/* Copy JITed text from rw_header to its final location, the ro_header. */
> +int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
> +				 struct bpf_binary_header *ro_header,
> +				 struct bpf_binary_header *rw_header)
> +{
> +	void *ptr;
> +
> +	ptr = bpf_arch_text_copy(ro_header, rw_header, rw_header->size);

Does this need to be wrapped with a text_mutex lock/unlock pair given
text_poke_copy() internally relies on __text_poke() ?

> +	kvfree(rw_header);
> +
> +	if (IS_ERR(ptr)) {
> +		bpf_prog_pack_free(ro_header);
> +		return PTR_ERR(ptr);
> +	}
> +	prog->aux->use_bpf_prog_pack = true;
> +	return 0;
> +}
> +
[...]
