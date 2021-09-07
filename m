Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061B64027A1
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 13:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245729AbhIGLO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 07:14:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19014 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245739AbhIGLOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 07:14:54 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H3jGK1cJ0zbmB0;
        Tue,  7 Sep 2021 19:09:45 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 7 Sep 2021 19:13:45 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 7 Sep 2021 19:13:44 +0800
Subject: Re: [PATCH bpf] bpf: handle return value of BPF_PROG_TYPE_STRUCT_OPS
 prog
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>
References: <20210901085344.3052333-1-houtao1@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <ff54247f-e1bd-0d8b-51d2-ce0fcfc0731b@huawei.com>
Date:   Tue, 7 Sep 2021 19:13:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210901085344.3052333-1-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping ?

+cc netdev

On 9/1/2021 4:53 PM, Hou Tao wrote:
> Currently if a function ptr in struct_ops has a return value, its
> caller will get a random return value from it, because the return
> value of related BPF_PROG_TYPE_STRUCT_OPS prog is just dropped.
>
> So adding a new flag BPF_TRAMP_F_RET_FENTRY_RET to tell bpf trampoline
> to save and return the return value of struct_ops prog if ret_size of
> the function ptr is greater than 0. Also restricting the flag to be
> used alone.
>
> Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 53 ++++++++++++++++++++++++++++---------
>  include/linux/bpf.h         |  2 ++
>  kernel/bpf/bpf_struct_ops.c |  7 +++--
>  3 files changed, 47 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 16d76f814e9b..47780844598a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1744,7 +1744,7 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
>  }
>  
>  static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
> -			   struct bpf_prog *p, int stack_size, bool mod_ret)
> +			   struct bpf_prog *p, int stack_size, bool save_ret)
>  {
>  	u8 *prog = *pprog;
>  	u8 *jmp_insn;
> @@ -1777,11 +1777,15 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>  	if (emit_call(&prog, p->bpf_func, prog))
>  		return -EINVAL;
>  
> -	/* BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
> +	/*
> +	 * BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
>  	 * of the previous call which is then passed on the stack to
>  	 * the next BPF program.
> +	 *
> +	 * BPF_TRAMP_FENTRY trampoline may need to return the return
> +	 * value of BPF_PROG_TYPE_STRUCT_OPS prog.
>  	 */
> -	if (mod_ret)
> +	if (save_ret)
>  		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
>  
>  	/* replace 2 nops with JE insn, since jmp target is known */
> @@ -1828,13 +1832,15 @@ static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
>  }
>  
>  static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
> -		      struct bpf_tramp_progs *tp, int stack_size)
> +		      struct bpf_tramp_progs *tp, int stack_size,
> +		      bool save_ret)
>  {
>  	int i;
>  	u8 *prog = *pprog;
>  
>  	for (i = 0; i < tp->nr_progs; i++) {
> -		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, false))
> +		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size,
> +				    save_ret))
>  			return -EINVAL;
>  	}
>  	*pprog = prog;
> @@ -1877,6 +1883,23 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
>  	return 0;
>  }
>  
> +static bool is_valid_bpf_tramp_flags(unsigned int flags)
> +{
> +	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
> +	    (flags & BPF_TRAMP_F_SKIP_FRAME))
> +		return false;
> +
> +	/*
> +	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
> +	 * and it must be used alone.
> +	 */
> +	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
> +	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
> +		return false;
> +
> +	return true;
> +}
> +
>  /* Example:
>   * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
>   * its 'struct btf_func_model' will be nr_args=2
> @@ -1949,17 +1972,19 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
>  	u8 **branches = NULL;
>  	u8 *prog;
> +	bool save_ret;
>  
>  	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
>  	if (nr_args > 6)
>  		return -ENOTSUPP;
>  
> -	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
> -	    (flags & BPF_TRAMP_F_SKIP_FRAME))
> +	if (!is_valid_bpf_tramp_flags(flags))
>  		return -EINVAL;
>  
> -	if (flags & BPF_TRAMP_F_CALL_ORIG)
> -		stack_size += 8; /* room for return value of orig_call */
> +	/* room for return value of orig_call or fentry prog */
> +	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
> +	if (save_ret)
> +		stack_size += 8;
>  
>  	if (flags & BPF_TRAMP_F_SKIP_FRAME)
>  		/* skip patched call instruction and point orig_call to actual
> @@ -1986,7 +2011,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	}
>  
>  	if (fentry->nr_progs)
> -		if (invoke_bpf(m, &prog, fentry, stack_size))
> +		if (invoke_bpf(m, &prog, fentry, stack_size,
> +			       flags & BPF_TRAMP_F_RET_FENTRY_RET))
>  			return -EINVAL;
>  
>  	if (fmod_ret->nr_progs) {
> @@ -2033,7 +2059,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	}
>  
>  	if (fexit->nr_progs)
> -		if (invoke_bpf(m, &prog, fexit, stack_size)) {
> +		if (invoke_bpf(m, &prog, fexit, stack_size, false)) {
>  			ret = -EINVAL;
>  			goto cleanup;
>  		}
> @@ -2053,9 +2079,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  			ret = -EINVAL;
>  			goto cleanup;
>  		}
> -		/* restore original return value back into RAX */
> -		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
>  	}
> +	/* restore return value of orig_call or fentry prog back into RAX */
> +	if (save_ret)
> +		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
>  
>  	EMIT1(0x5B); /* pop rbx */
>  	EMIT1(0xC9); /* leave */
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index e8e2b0393ca9..85413eb368de 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -553,6 +553,8 @@ struct btf_func_model {
>   * programs only. Should not be used with normal calls and indirect calls.
>   */
>  #define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
> +/* Return the return value of fentry prog. Only used by bpf_struct_ops. */
> +#define BPF_TRAMP_F_RET_FENTRY_RET	BIT(3)
>  
>  /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
>   * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 70f6fd4fa305..2ce17447fb76 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -367,6 +367,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>  		const struct btf_type *mtype, *ptype;
>  		struct bpf_prog *prog;
>  		u32 moff;
> +		u32 flags;
>  
>  		moff = btf_member_bit_offset(t, member) / 8;
>  		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
> @@ -430,10 +431,12 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>  
>  		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
>  		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
> +		flags = st_ops->func_models[i].ret_size > 0 ?
> +			BPF_TRAMP_F_RET_FENTRY_RET : 0;
>  		err = arch_prepare_bpf_trampoline(NULL, image,
>  						  st_map->image + PAGE_SIZE,
> -						  &st_ops->func_models[i], 0,
> -						  tprogs, NULL);
> +						  &st_ops->func_models[i],
> +						  flags, tprogs, NULL);
>  		if (err < 0)
>  			goto reset_unlock;
>  
