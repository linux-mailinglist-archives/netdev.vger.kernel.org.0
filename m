Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445632562B2
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 23:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgH1V4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 17:56:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:52428 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1V4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 17:56:41 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBmMQ-0004sy-QM; Fri, 28 Aug 2020 23:56:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBmMQ-000QHj-Ig; Fri, 28 Aug 2020 23:56:38 +0200
Subject: Re: [PATCHv9 bpf-next 1/5] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko B <andrii.nakryiko@gmail.com>
References: <20200715130816.2124232-1-liuhangbin@gmail.com>
 <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200826132002.2808380-2-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a6ef587d-8128-a926-16b3-01e7ef7b4c8b@iogearbox.net>
Date:   Fri, 28 Aug 2020 23:56:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200826132002.2808380-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25913/Fri Aug 28 15:19:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 3:19 PM, Hangbin Liu wrote:
> Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> used when we want to allow NULL pointer for map parameter. The bpf helper
> need to take care and check if the map is NULL when use this type.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> 
> v9: merge the patch from [1] in to this series.
> v1-v8: no this patch
> 
> [1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/
> ---
>   include/linux/bpf.h   |  2 ++
>   kernel/bpf/verifier.c | 23 ++++++++++++++++-------
>   2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a6131d95e31e..cb40a1281ea2 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -276,6 +276,7 @@ enum bpf_arg_type {
>   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
>   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
>   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
>   };
>   
>   /* type of values returned from helper functions */
> @@ -369,6 +370,7 @@ enum bpf_reg_type {
>   	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
>   	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
>   	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
> +	CONST_PTR_TO_MAP_OR_NULL, /* reg points to struct bpf_map or NULL */

Why is this needed & where do you assign it? Also, if we were to use CONST_PTR_TO_MAP_OR_NULL
then it's missing few things like rejection of arithmetic in adjust_ptr_min_max_vals(), handling
in pruning logic etc.

Either way, given no helper currently returns CONST_PTR_TO_MAP_OR_NULL, the ARG_CONST_MAP_PTR_OR_NULL
one should be sufficient, so I'd suggest to remove the CONST_PTR_TO_MAP_OR_NULL bits.

>   };
>   
>   /* The information passed from prog-specific *_is_valid_access
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7e5908b83ec7..53a84335a8fd 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -411,7 +411,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
>   	       type == PTR_TO_BTF_ID_OR_NULL ||
>   	       type == PTR_TO_MEM_OR_NULL ||
>   	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
> -	       type == PTR_TO_RDWR_BUF_OR_NULL;
> +	       type == PTR_TO_RDWR_BUF_OR_NULL ||
> +	       type == CONST_PTR_TO_MAP_OR_NULL;
>   }
>   
>   static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
> @@ -427,7 +428,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
>   		type == PTR_TO_TCP_SOCK ||
>   		type == PTR_TO_TCP_SOCK_OR_NULL ||
>   		type == PTR_TO_MEM ||
> -		type == PTR_TO_MEM_OR_NULL;
> +		type == PTR_TO_MEM_OR_NULL ||
> +		type == CONST_PTR_TO_MAP_OR_NULL;
>   }
>   
>   static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
> @@ -509,6 +511,7 @@ static const char * const reg_type_str[] = {
>   	[PTR_TO_RDONLY_BUF_OR_NULL] = "rdonly_buf_or_null",
>   	[PTR_TO_RDWR_BUF]	= "rdwr_buf",
>   	[PTR_TO_RDWR_BUF_OR_NULL] = "rdwr_buf_or_null",
> +	[CONST_PTR_TO_MAP_OR_NULL] = "map_ptr_or_null",
>   };
>   
>   static char slot_type_char[] = {
> @@ -3957,9 +3960,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		expected_type = SCALAR_VALUE;
>   		if (type != expected_type)
>   			goto err_type;
> -	} else if (arg_type == ARG_CONST_MAP_PTR) {
> +	} else if (arg_type == ARG_CONST_MAP_PTR ||
> +		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
>   		expected_type = CONST_PTR_TO_MAP;
> -		if (type != expected_type)
> +		if (register_is_null(reg) &&
> +		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
> +			/* final test in check_stack_boundary() */;

Where is that test in the code? Copy-paste leftover comment?

> +		else if (type != expected_type)
>   			goto err_type;
>   	} else if (arg_type == ARG_PTR_TO_CTX ||
>   		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
> @@ -4076,9 +4083,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		return -EFAULT;
>   	}
>   
> -	if (arg_type == ARG_CONST_MAP_PTR) {
> -		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
> -		meta->map_ptr = reg->map_ptr;
> +	if (arg_type == ARG_CONST_MAP_PTR ||
> +	    arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
> +		meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;
>   	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
>   		/* bpf_map_xxx(..., map_ptr, ..., key) call:
>   		 * check that [key, key + map->key_size) are within
> @@ -6977,6 +6984,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
>   			reg->type = PTR_TO_RDONLY_BUF;
>   		} else if (reg->type == PTR_TO_RDWR_BUF_OR_NULL) {
>   			reg->type = PTR_TO_RDWR_BUF;
> +		} else if (reg->type == CONST_PTR_TO_MAP_OR_NULL) {
> +			reg->type = CONST_PTR_TO_MAP;
>   		}
>   		if (is_null) {
>   			/* We don't need id and ref_obj_id from this point
> 

