Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7B41BAF0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbhI1XWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243224AbhI1XWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 19:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B25C613A9;
        Tue, 28 Sep 2021 23:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632871272;
        bh=Qpmjy3v3LXLoqwxdodHgDFx1iO63hAnMdM8VOKZGpXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bjmMrQkaTwojf6QNFkY/FTOzBM3q0ptdF+4qIBCY9GeWM8sCEO5TYXfmBohl5jwuQ
         YDSOPXZynWXBuvCcP8YF9n/qpvdDAsu0A1OrOyFVrTN+V9246BkDCEEPwKReJDb43X
         NJQpiVzuFqnhUjjvWCafzB5DkNk0w/jCnvg9TLvUibjhnZIAWy8JGkVzKD7bEGScbS
         S4n4hrHlwgfbO/4v93FBhh8evB1HDNH3JBo8ywTiS7F2oXRiMduCZCbtyi4HhZlusQ
         JSxZEKaH3MjtyZXG2TAGJM8nTGr3B8CnB5KKIRnInY+L5mbLEno7ZLUBz3nCfnC1K6
         IwmtKvJjE6jBw==
Date:   Tue, 28 Sep 2021 18:25:14 -0500
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
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Replace "want address" users of
 BPF_CAST_CALL with BPF_CALL_IMM
Message-ID: <20210928232514.GA297403@embeddedor>
References: <20210928230946.4062144-1-keescook@chromium.org>
 <20210928230946.4062144-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928230946.4062144-2-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 04:09:45PM -0700, Kees Cook wrote:
> In order to keep ahead of cases in the kernel where Control Flow
> Integrity (CFI) may trip over function call casts, enabling
> -Wcast-function-type is helpful. To that end, BPF_CAST_CALL causes
> various warnings and is one of the last places in the kernel triggering
> this warning.
> 
> Most places using BPF_CAST_CALL actually just want a void * to perform
> math on. It's not actually performing a call, so just use a different
> helper to get the void *, by way of the new BPF_CALL_IMM() helper, which
> can clean up a common copy/paste idiom as well.
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

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  include/linux/filter.h |  6 +++++-
>  kernel/bpf/hashtab.c   |  6 +++---
>  kernel/bpf/verifier.c  | 26 +++++++++-----------------
>  lib/test_bpf.c         |  2 +-
>  4 files changed, 18 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 4a93c12543ee..6c247663d4ce 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -365,13 +365,17 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
>  #define BPF_CAST_CALL(x)					\
>  		((u64 (*)(u64, u64, u64, u64, u64))(x))
>  
> +/* Convert function address to BPF immediate */
> +
> +#define BPF_CALL_IMM(x)	((void *)(x) - (void *)__bpf_call_base)
> +
>  #define BPF_EMIT_CALL(FUNC)					\
>  	((struct bpf_insn) {					\
>  		.code  = BPF_JMP | BPF_CALL,			\
>  		.dst_reg = 0,					\
>  		.src_reg = 0,					\
>  		.off   = 0,					\
> -		.imm   = ((FUNC) - __bpf_call_base) })
> +		.imm   = BPF_CALL_IMM(FUNC) })
>  
>  /* Raw code statement block */
>  
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 32471ba02708..3d8f9d6997d5 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -668,7 +668,7 @@ static int htab_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
>  
>  	BUILD_BUG_ON(!__same_type(&__htab_map_lookup_elem,
>  		     (void *(*)(struct bpf_map *map, void *key))NULL));
> -	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_map_lookup_elem));
> +	*insn++ = BPF_EMIT_CALL(__htab_map_lookup_elem);
>  	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 1);
>  	*insn++ = BPF_ALU64_IMM(BPF_ADD, ret,
>  				offsetof(struct htab_elem, key) +
> @@ -709,7 +709,7 @@ static int htab_lru_map_gen_lookup(struct bpf_map *map,
>  
>  	BUILD_BUG_ON(!__same_type(&__htab_map_lookup_elem,
>  		     (void *(*)(struct bpf_map *map, void *key))NULL));
> -	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_map_lookup_elem));
> +	*insn++ = BPF_EMIT_CALL(__htab_map_lookup_elem);
>  	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 4);
>  	*insn++ = BPF_LDX_MEM(BPF_B, ref_reg, ret,
>  			      offsetof(struct htab_elem, lru_node) +
> @@ -2397,7 +2397,7 @@ static int htab_of_map_gen_lookup(struct bpf_map *map,
>  
>  	BUILD_BUG_ON(!__same_type(&__htab_map_lookup_elem,
>  		     (void *(*)(struct bpf_map *map, void *key))NULL));
> -	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_map_lookup_elem));
> +	*insn++ = BPF_EMIT_CALL(__htab_map_lookup_elem);
>  	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 2);
>  	*insn++ = BPF_ALU64_IMM(BPF_ADD, ret,
>  				offsetof(struct htab_elem, key) +
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7a8351604f67..1433752db740 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1744,7 +1744,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
>  
>  	desc = &tab->descs[tab->nr_descs++];
>  	desc->func_id = func_id;
> -	desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
> +	desc->imm = BPF_CALL_IMM(addr);
>  	err = btf_distill_func_proto(&env->log, btf_vmlinux,
>  				     func_proto, func_name,
>  				     &desc->func_model);
> @@ -12514,8 +12514,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>  			if (!bpf_pseudo_call(insn))
>  				continue;
>  			subprog = insn->off;
> -			insn->imm = BPF_CAST_CALL(func[subprog]->bpf_func) -
> -				    __bpf_call_base;
> +			insn->imm = BPF_CALL_IMM(func[subprog]->bpf_func);
>  		}
>  
>  		/* we use the aux data to keep a list of the start addresses
> @@ -12995,32 +12994,25 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>  patch_map_ops_generic:
>  			switch (insn->imm) {
>  			case BPF_FUNC_map_lookup_elem:
> -				insn->imm = BPF_CAST_CALL(ops->map_lookup_elem) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_lookup_elem);
>  				continue;
>  			case BPF_FUNC_map_update_elem:
> -				insn->imm = BPF_CAST_CALL(ops->map_update_elem) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_update_elem);
>  				continue;
>  			case BPF_FUNC_map_delete_elem:
> -				insn->imm = BPF_CAST_CALL(ops->map_delete_elem) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_delete_elem);
>  				continue;
>  			case BPF_FUNC_map_push_elem:
> -				insn->imm = BPF_CAST_CALL(ops->map_push_elem) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_push_elem);
>  				continue;
>  			case BPF_FUNC_map_pop_elem:
> -				insn->imm = BPF_CAST_CALL(ops->map_pop_elem) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_pop_elem);
>  				continue;
>  			case BPF_FUNC_map_peek_elem:
> -				insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_peek_elem);
>  				continue;
>  			case BPF_FUNC_redirect_map:
> -				insn->imm = BPF_CAST_CALL(ops->map_redirect) -
> -					    __bpf_call_base;
> +				insn->imm = BPF_CALL_IMM(ops->map_redirect);
>  				continue;
>  			}
>  
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 08f438e6fe9e..21ea1ab253a1 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -12439,7 +12439,7 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
>  					err = -EFAULT;
>  					goto out_err;
>  				}
> -				*insn = BPF_EMIT_CALL(BPF_CAST_CALL(addr));
> +				*insn = BPF_EMIT_CALL(addr);
>  				if ((long)__bpf_call_base + insn->imm != addr)
>  					*insn = BPF_JMP_A(0); /* Skip: NOP */
>  				break;
> -- 
> 2.30.2
> 
