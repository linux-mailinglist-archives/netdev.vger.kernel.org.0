Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A7541BAF8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbhI1XYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhI1XYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 19:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B8A60F9D;
        Tue, 28 Sep 2021 23:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632871373;
        bh=RUvdqkjcjCLXJYTVx4LwzKIXoyGzG4G49JxCo/hG9UE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b0bvSnon4ygCWaCcre1ogN9xOp1YEiNIsifUIP7BAAuuzy5J6HCY4rlzq8282LJfY
         xmNug5p1CA5Q0m6GFMJYQWwIndUChPgCKtAwvowZXxzgJi98Kw4V90NLkubJJY1ivT
         Ds2FbrWuGWtidacUDHrFKa5ecqb5xuMIqdmLxgMd0hnRE7i1X9u0BxHzbnXJdVY1OK
         +jkYVZ6GObvz4o+F6gIloMgs0jU978l7/88dek5DKCx92WjubEoNXOez+dVNRAVMzJ
         yb0XClVr+d2v9NdCfKkvjKyyLDcGwR2lAEHOJeYs7Ijg5TUw1V4b79tUr0Pf7sDUNb
         eKuRJeQP3fa4A==
Date:   Tue, 28 Sep 2021 18:26:55 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/2] bpf: Replace callers of BPF_CAST_CALL
 with proper function typedef
Message-ID: <20210928232655.GA297501@embeddedor>
References: <20210928230946.4062144-1-keescook@chromium.org>
 <20210928230946.4062144-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928230946.4062144-3-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 04:09:46PM -0700, Kees Cook wrote:
> In order to keep ahead of cases in the kernel where Control Flow
> Integrity (CFI) may trip over function call casts, enabling
> -Wcast-function-type is helpful. To that end, BPF_CAST_CALL causes
> various warnings and is one of the last places in the kernel
> triggering this warning.
> 
> For actual function calls, replace BPF_CAST_CALL() with a typedef, which
> captures the same details about the given function pointers.
> 
> This change results in no object code difference.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> Link: https://github.com/KSPP/linux/issues/20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/lkml/CAEf4Bzb46=-J5Fxc3mMZ8JQPtK1uoE0q6+g6WPz53Cvx=CBEhw@mail.gmail.com

Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  include/linux/bpf.h    | 4 +++-
>  include/linux/filter.h | 5 -----
>  kernel/bpf/arraymap.c  | 7 +++----
>  kernel/bpf/hashtab.c   | 7 +++----
>  kernel/bpf/helpers.c   | 5 ++---
>  5 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b6c45a6cbbba..19735d59230a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -48,6 +48,7 @@ extern struct idr btf_idr;
>  extern spinlock_t btf_idr_lock;
>  extern struct kobject *btf_kobj;
>  
> +typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
>  typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
>  					struct bpf_iter_aux_info *aux);
>  typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
> @@ -142,7 +143,8 @@ struct bpf_map_ops {
>  	int (*map_set_for_each_callback_args)(struct bpf_verifier_env *env,
>  					      struct bpf_func_state *caller,
>  					      struct bpf_func_state *callee);
> -	int (*map_for_each_callback)(struct bpf_map *map, void *callback_fn,
> +	int (*map_for_each_callback)(struct bpf_map *map,
> +				     bpf_callback_t callback_fn,
>  				     void *callback_ctx, u64 flags);
>  
>  	/* BTF name and id of struct allocated by map_alloc */
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 6c247663d4ce..47f80adbe744 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -360,11 +360,6 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
>  		.off   = 0,					\
>  		.imm   = TGT })
>  
> -/* Function call */
> -
> -#define BPF_CAST_CALL(x)					\
> -		((u64 (*)(u64, u64, u64, u64, u64))(x))
> -
>  /* Convert function address to BPF immediate */
>  
>  #define BPF_CALL_IMM(x)	((void *)(x) - (void *)__bpf_call_base)
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index cebd4fb06d19..5e1ccfae916b 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -645,7 +645,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
>  	.seq_priv_size		= sizeof(struct bpf_iter_seq_array_map_info),
>  };
>  
> -static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
> +static int bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback_fn,
>  				   void *callback_ctx, u64 flags)
>  {
>  	u32 i, key, num_elems = 0;
> @@ -668,9 +668,8 @@ static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
>  			val = array->value + array->elem_size * i;
>  		num_elems++;
>  		key = i;
> -		ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
> -					(u64)(long)&key, (u64)(long)val,
> -					(u64)(long)callback_ctx, 0);
> +		ret = callback_fn((u64)(long)map, (u64)(long)&key,
> +				  (u64)(long)val, (u64)(long)callback_ctx, 0);
>  		/* return value: 0 - continue, 1 - stop and return */
>  		if (ret)
>  			break;
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 3d8f9d6997d5..d29af9988f37 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -2049,7 +2049,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
>  	.seq_priv_size		= sizeof(struct bpf_iter_seq_hash_map_info),
>  };
>  
> -static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
> +static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_fn,
>  				  void *callback_ctx, u64 flags)
>  {
>  	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> @@ -2089,9 +2089,8 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
>  				val = elem->key + roundup_key_size;
>  			}
>  			num_elems++;
> -			ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
> -					(u64)(long)key, (u64)(long)val,
> -					(u64)(long)callback_ctx, 0);
> +			ret = callback_fn((u64)(long)map, (u64)(long)key,
> +					  (u64)(long)val, (u64)(long)callback_ctx, 0);
>  			/* return value: 0 - continue, 1 - stop and return */
>  			if (ret) {
>  				rcu_read_unlock();
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 2c604ff8c7fb..1ffd469c217f 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1056,7 +1056,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
>  	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
>  	struct bpf_map *map = t->map;
>  	void *value = t->value;
> -	void *callback_fn;
> +	bpf_callback_t callback_fn;
>  	void *key;
>  	u32 idx;
>  
> @@ -1081,8 +1081,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
>  		key = value - round_up(map->key_size, 8);
>  	}
>  
> -	BPF_CAST_CALL(callback_fn)((u64)(long)map, (u64)(long)key,
> -				   (u64)(long)value, 0, 0);
> +	callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value, 0, 0);
>  	/* The verifier checked that return value is zero. */
>  
>  	this_cpu_write(hrtimer_running, NULL);
> -- 
> 2.30.2
> 
