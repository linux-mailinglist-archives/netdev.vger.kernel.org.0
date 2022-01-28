Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EAA49F702
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346328AbiA1KR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:17:29 -0500
Received: from foss.arm.com ([217.140.110.172]:34428 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347210AbiA1KRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 05:17:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9043C113E;
        Fri, 28 Jan 2022 02:17:02 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.13.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5EF23F766;
        Fri, 28 Jan 2022 02:16:59 -0800 (PST)
Date:   Fri, 28 Jan 2022 10:16:49 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
Message-ID: <YfPCkUW4XIHGTZ6z@FVFF77S0Q05N>
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121135632.136976-3-houtao1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 09:56:32PM +0800, Hou Tao wrote:
> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
> it only add support for x86-64, so support these atomic operations
> for arm64 as well.

What ordering semantics are the BPF atomics supposed to have?

e.g. are those meant to be sequentially consistent, entirely relaxed, or
somewhere imbetween?

> Basically the implementation procedure is almost mechanical translation
> of code snippets in atomic_ll_sc.h & atomic_lse.h & cmpxchg.h located
> under arch/arm64/include/asm. An extra temporary register is needed
> for (BPF_ADD | BPF_FETCH) to save the value of src register, instead of
> adding TMP_REG_4 just use BPF_REG_AX instead.
> 
> For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case,
> both ./test_verifier and "./test_progs -t atomic" are exercised and
> passed correspondingly.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  arch/arm64/include/asm/insn.h |  45 +++++--
>  arch/arm64/lib/insn.c         | 155 +++++++++++++++++++++---

Could we please split the arm64 insn bits into a preparatory patch?

That way it's easier for folk familiar with the A64 ISA to review that in
isolation from the BPF bis which they might know nothign about.

>  arch/arm64/net/bpf_jit.h      |  43 ++++++-
>  arch/arm64/net/bpf_jit_comp.c | 216 +++++++++++++++++++++++++++-------
>  4 files changed, 394 insertions(+), 65 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index 6b776c8667b2..1416d636f1af 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -280,6 +280,23 @@ enum aarch64_insn_adr_type {
>  	AARCH64_INSN_ADR_TYPE_ADR,
>  };
>  
> +enum aarch64_insn_mem_atomic_op {
> +	AARCH64_INSN_MEM_ATOMIC_ADD,
> +	AARCH64_INSN_MEM_ATOMIC_BIC,
> +	AARCH64_INSN_MEM_ATOMIC_EOR,
> +	AARCH64_INSN_MEM_ATOMIC_ORR,
> +	AARCH64_INSN_MEM_ATOMIC_SWP,
> +};

Is "BIC" the "CLR" instructions, and "ORR" the "SET" instructions?

I think it'd be best to use the "SET" and "CLR" naming here for consistency
with the actual instruction names.

> +
> +enum aarch64_insn_mem_order_type {
> +	AARCH64_INSN_MEM_ORDER_NONE,
> +	AARCH64_INSN_MEM_ORDER_LOAD_ACQ_STORE_REL,
> +};

I think this is an over-simplification. There are instructions with all
combinations of acquire+release, e.g.

     |       REL        |
     | N      |  Y      |
-----+--------+---------|
A  N | LDCLR  | LCDLRL  |
C  --+--------+---------|
Q  Y | LDCLRA | LDCLRAL |
------------------------'

... so I reckon we need:

enum aarch64_insn_mem_order_type {
	AARCH64_INSN_MEM_ORDER_NONE,
	AARCH64_INSN_MEM_ORDER_ACQ,
	AARCH64_INSN_MEM_ORDER_REL,
	AARCH64_INSN_MEM_ORDER_ACQREL
};

> +
> +enum aarch64_insn_mb_type {
> +	AARCH64_INSN_MB_ISH,
> +};

Similarly, I think we want to be able to encode the other cases here.

Thanks,
Mark.

> +
>  #define	__AARCH64_INSN_FUNCS(abbr, mask, val)				\
>  static __always_inline bool aarch64_insn_is_##abbr(u32 code)		\
>  {									\
> @@ -303,6 +320,11 @@ __AARCH64_INSN_FUNCS(store_post,	0x3FE00C00, 0x38000400)
>  __AARCH64_INSN_FUNCS(load_post,	0x3FE00C00, 0x38400400)
>  __AARCH64_INSN_FUNCS(str_reg,	0x3FE0EC00, 0x38206800)
>  __AARCH64_INSN_FUNCS(ldadd,	0x3F20FC00, 0x38200000)
> +__AARCH64_INSN_FUNCS(ldclr,	0x3F20FC00, 0x38201000)
> +__AARCH64_INSN_FUNCS(ldeor,	0x3F20FC00, 0x38202000)
> +__AARCH64_INSN_FUNCS(ldset,	0x3F20FC00, 0x38203000)
> +__AARCH64_INSN_FUNCS(swp,	0x3F20FC00, 0x38208000)
> +__AARCH64_INSN_FUNCS(cas,	0x3FA07C00, 0x08A07C00)
>  __AARCH64_INSN_FUNCS(ldr_reg,	0x3FE0EC00, 0x38606800)
>  __AARCH64_INSN_FUNCS(ldr_lit,	0xBF000000, 0x18000000)
>  __AARCH64_INSN_FUNCS(ldrsw_lit,	0xFF000000, 0x98000000)
> @@ -474,13 +496,21 @@ u32 aarch64_insn_gen_load_store_ex(enum aarch64_insn_register reg,
>  				   enum aarch64_insn_register state,
>  				   enum aarch64_insn_size_type size,
>  				   enum aarch64_insn_ldst_type type);
> -u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
> -			   enum aarch64_insn_register address,
> -			   enum aarch64_insn_register value,
> -			   enum aarch64_insn_size_type size);
> -u32 aarch64_insn_gen_stadd(enum aarch64_insn_register address,
> -			   enum aarch64_insn_register value,
> -			   enum aarch64_insn_size_type size);
> +u32 aarch64_insn_gen_store_release_ex(enum aarch64_insn_register reg,
> +				      enum aarch64_insn_register base,
> +				      enum aarch64_insn_register state,
> +				      enum aarch64_insn_size_type size);
> +u32 aarch64_insn_gen_atomic_ld_op(enum aarch64_insn_register result,
> +				  enum aarch64_insn_register address,
> +				  enum aarch64_insn_register value,
> +				  enum aarch64_insn_size_type size,
> +				  enum aarch64_insn_mem_atomic_op op,
> +				  enum aarch64_insn_mem_order_type order);
> +u32 aarch64_insn_gen_cas(enum aarch64_insn_register result,
> +			 enum aarch64_insn_register address,
> +			 enum aarch64_insn_register value,
> +			 enum aarch64_insn_size_type size,
> +			 enum aarch64_insn_mem_order_type order);
>  u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
>  				 enum aarch64_insn_register src,
>  				 int imm, enum aarch64_insn_variant variant,
> @@ -541,6 +571,7 @@ u32 aarch64_insn_gen_prefetch(enum aarch64_insn_register base,
>  			      enum aarch64_insn_prfm_type type,
>  			      enum aarch64_insn_prfm_target target,
>  			      enum aarch64_insn_prfm_policy policy);
> +u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type);
>  s32 aarch64_get_branch_offset(u32 insn);
>  u32 aarch64_set_branch_offset(u32 insn, s32 offset);
>  
> diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
> index fccfe363e567..2a7dde58c44b 100644
> --- a/arch/arm64/lib/insn.c
> +++ b/arch/arm64/lib/insn.c
> @@ -328,6 +328,29 @@ static u32 aarch64_insn_encode_ldst_size(enum aarch64_insn_size_type type,
>  	return insn;
>  }
>  
> +static u32 aarch64_insn_encode_ldst_order(enum aarch64_insn_mem_order_type type,
> +					  u32 insn)
> +{
> +	u32 order;
> +
> +	switch (type) {
> +	case AARCH64_INSN_MEM_ORDER_NONE:
> +		order = 0;
> +		break;
> +	case AARCH64_INSN_MEM_ORDER_LOAD_ACQ_STORE_REL:
> +		order = 3;
> +		break;
> +	default:
> +		pr_err("%s: unknown mem order %d\n", __func__, type);
> +		return AARCH64_BREAK_FAULT;
> +	}
> +
> +	insn &= ~GENMASK(23, 22);
> +	insn |= order << 22;
> +
> +	return insn;
> +}
> +
>  static inline long branch_imm_common(unsigned long pc, unsigned long addr,
>  				     long range)
>  {
> @@ -603,12 +626,49 @@ u32 aarch64_insn_gen_load_store_ex(enum aarch64_insn_register reg,
>  					    state);
>  }
>  
> -u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
> -			   enum aarch64_insn_register address,
> -			   enum aarch64_insn_register value,
> -			   enum aarch64_insn_size_type size)
> +u32 aarch64_insn_gen_store_release_ex(enum aarch64_insn_register reg,
> +				      enum aarch64_insn_register base,
> +				      enum aarch64_insn_register state,
> +				      enum aarch64_insn_size_type size)
> +{
> +	u32 insn = aarch64_insn_gen_load_store_ex(reg, base, state, size,
> +						  AARCH64_INSN_LDST_STORE_EX);
> +
> +	if (insn == AARCH64_BREAK_FAULT)
> +		return insn;
> +
> +	return insn | BIT(15);
> +}
> +
> +u32 aarch64_insn_gen_atomic_ld_op(enum aarch64_insn_register result,
> +				  enum aarch64_insn_register address,
> +				  enum aarch64_insn_register value,
> +				  enum aarch64_insn_size_type size,
> +				  enum aarch64_insn_mem_atomic_op op,
> +				  enum aarch64_insn_mem_order_type order)
>  {
> -	u32 insn = aarch64_insn_get_ldadd_value();
> +	u32 insn;
> +
> +	switch (op) {
> +	case AARCH64_INSN_MEM_ATOMIC_ADD:
> +		insn = aarch64_insn_get_ldadd_value();
> +		break;
> +	case AARCH64_INSN_MEM_ATOMIC_BIC:
> +		insn = aarch64_insn_get_ldclr_value();
> +		break;
> +	case AARCH64_INSN_MEM_ATOMIC_EOR:
> +		insn = aarch64_insn_get_ldeor_value();
> +		break;
> +	case AARCH64_INSN_MEM_ATOMIC_ORR:
> +		insn = aarch64_insn_get_ldset_value();
> +		break;
> +	case AARCH64_INSN_MEM_ATOMIC_SWP:
> +		insn = aarch64_insn_get_swp_value();
> +		break;
> +	default:
> +		pr_err("%s: unimplemented mem atomic op %d\n", __func__, op);
> +		return AARCH64_BREAK_FAULT;
> +	}
>  
>  	switch (size) {
>  	case AARCH64_INSN_SIZE_32:
> @@ -621,6 +681,8 @@ u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
>  
>  	insn = aarch64_insn_encode_ldst_size(size, insn);
>  
> +	insn = aarch64_insn_encode_ldst_order(order, insn);
> +
>  	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RT, insn,
>  					    result);
>  
> @@ -631,16 +693,60 @@ u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
>  					    value);
>  }
>  
> -u32 aarch64_insn_gen_stadd(enum aarch64_insn_register address,
> -			   enum aarch64_insn_register value,
> -			   enum aarch64_insn_size_type size)
> +static u32 aarch64_insn_encode_cas_order(enum aarch64_insn_mem_order_type type,
> +					 u32 insn)
>  {
> -	/*
> -	 * STADD is simply encoded as an alias for LDADD with XZR as
> -	 * the destination register.
> -	 */
> -	return aarch64_insn_gen_ldadd(AARCH64_INSN_REG_ZR, address,
> -				      value, size);
> +	u32 order;
> +
> +	switch (type) {
> +	case AARCH64_INSN_MEM_ORDER_NONE:
> +		order = 0;
> +		break;
> +	case AARCH64_INSN_MEM_ORDER_LOAD_ACQ_STORE_REL:
> +		order = BIT(15) | BIT(22);
> +		break;
> +	default:
> +		pr_err("%s: unknown mem order %d\n", __func__, type);
> +		return AARCH64_BREAK_FAULT;
> +	}
> +
> +	insn &= ~(BIT(15) | BIT(22));
> +	insn |= order;
> +
> +	return insn;
> +}
> +
> +u32 aarch64_insn_gen_cas(enum aarch64_insn_register result,
> +			 enum aarch64_insn_register address,
> +			 enum aarch64_insn_register value,
> +			 enum aarch64_insn_size_type size,
> +			 enum aarch64_insn_mem_order_type order)
> +{
> +	u32 insn;
> +
> +	switch (size) {
> +	case AARCH64_INSN_SIZE_32:
> +	case AARCH64_INSN_SIZE_64:
> +		break;
> +	default:
> +		pr_err("%s: unimplemented size encoding %d\n", __func__, size);
> +		return AARCH64_BREAK_FAULT;
> +	}
> +
> +	insn = aarch64_insn_get_cas_value();
> +
> +	insn = aarch64_insn_encode_ldst_size(size, insn);
> +
> +	insn = aarch64_insn_encode_cas_order(order, insn);
> +
> +	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RT, insn,
> +					    result);
> +
> +	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn,
> +					    address);
> +
> +	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RS, insn,
> +					    value);
>  }
>  
>  static u32 aarch64_insn_encode_prfm_imm(enum aarch64_insn_prfm_type type,
> @@ -1456,3 +1562,24 @@ u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
>  	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
>  	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RM, insn, Rm);
>  }
> +
> +u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type)
> +{
> +	u32 opt;
> +	u32 insn;
> +
> +	switch (type) {
> +	case AARCH64_INSN_MB_ISH:
> +		opt = 0xb;
> +		break;
> +	default:
> +		pr_err("%s: unknown dmb type %d\n", __func__, type);
> +		return AARCH64_BREAK_FAULT;
> +	}
> +
> +	insn = aarch64_insn_get_dmb_value();
> +	insn &= ~GENMASK(11, 8);
> +	insn |= (opt << 8);
> +
> +	return insn;
> +}
> diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
> index cc0cf0f5c7c3..308f96587861 100644
> --- a/arch/arm64/net/bpf_jit.h
> +++ b/arch/arm64/net/bpf_jit.h
> @@ -88,10 +88,41 @@
>  /* [Rn] = Rt; (atomic) Rs = [state] */
>  #define A64_STXR(sf, Rt, Rn, Rs) \
>  	A64_LSX(sf, Rt, Rn, Rs, STORE_EX)
> +/* smp_mb(); [Rn] = Rt; (atomic) Rs = [state] */
> +#define A64_STLXR(sf, Rt, Rn, Rs) \
> +	aarch64_insn_gen_store_release_ex(Rt, Rn, Rs, A64_SIZE(sf))
>  
> -/* LSE atomics */
> -#define A64_STADD(sf, Rn, Rs) \
> -	aarch64_insn_gen_stadd(Rn, Rs, A64_SIZE(sf))
> +/*
> + * LSE atomics
> + *
> + * ST{ADD,CLR,SET,EOR} is simply encoded as an alias for
> + * LDD{ADD,CLR,SET,EOR} with XZR as the destination register.
> + */
> +#define A64_ST_OP(sf, Rn, Rs, op) \
> +	aarch64_insn_gen_atomic_ld_op(A64_ZR, Rn, Rs, \
> +		A64_SIZE(sf), AARCH64_INSN_MEM_ATOMIC_##op, \
> +		AARCH64_INSN_MEM_ORDER_NONE)
> +/* [Rn] <op>= Rs */
> +#define A64_STADD(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, ADD)
> +#define A64_STCLR(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, BIC)
> +#define A64_STEOR(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, EOR)
> +#define A64_STSET(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, ORR)
> +
> +#define A64_LD_OP_AL(sf, Rt, Rn, Rs, op) \
> +	aarch64_insn_gen_atomic_ld_op(Rt, Rn, Rs, \
> +		A64_SIZE(sf), AARCH64_INSN_MEM_ATOMIC_##op, \
> +		AARCH64_INSN_MEM_ORDER_LOAD_ACQ_STORE_REL)
> +/* Rt = [Rn]; [Rn] <op>= Rs */
> +#define A64_LDADDAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, ADD)
> +#define A64_LDCLRAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, BIC)
> +#define A64_LDEORAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, EOR)
> +#define A64_LDSETAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, ORR)
> +/* Rt = [Rn]; [Rn] = Rs */
> +#define A64_SWPAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, SWP)
> +/* Rs = CAS(Rn, Rs, Rt) */
> +#define A64_CASAL(sf, Rt, Rn, Rs) \
> +	aarch64_insn_gen_cas(Rt, Rn, Rs, A64_SIZE(sf), \
> +		AARCH64_INSN_MEM_ORDER_LOAD_ACQ_STORE_REL)
>  
>  /* Add/subtract (immediate) */
>  #define A64_ADDSUB_IMM(sf, Rd, Rn, imm12, type) \
> @@ -196,6 +227,9 @@
>  #define A64_ANDS(sf, Rd, Rn, Rm) A64_LOGIC_SREG(sf, Rd, Rn, Rm, AND_SETFLAGS)
>  /* Rn & Rm; set condition flags */
>  #define A64_TST(sf, Rn, Rm) A64_ANDS(sf, A64_ZR, Rn, Rm)
> +/* Rd = ~Rm (alias of ORN with A64_ZR as Rn) */
> +#define A64_MVN(sf, Rd, Rm)  \
> +	A64_LOGIC_SREG(sf, Rd, A64_ZR, Rm, ORN)
>  
>  /* Logical (immediate) */
>  #define A64_LOGIC_IMM(sf, Rd, Rn, imm, type) ({ \
> @@ -219,4 +253,7 @@
>  #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
>  #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
>  
> +/* DMB */
> +#define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
> +
>  #endif /* _BPF_JIT_H */
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 74f9a9b6a053..79e2c2c4c733 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -27,6 +27,17 @@
>  #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
>  #define TMP_REG_3 (MAX_BPF_JIT_REG + 3)
>  
> +#define check_imm(bits, imm) do {				\
> +	if ((((imm) > 0) && ((imm) >> (bits))) ||		\
> +	    (((imm) < 0) && (~(imm) >> (bits)))) {		\
> +		pr_info("[%2d] imm=%d(0x%x) out of range\n",	\
> +			i, imm, imm);				\
> +		return -EINVAL;					\
> +	}							\
> +} while (0)
> +#define check_imm19(imm) check_imm(19, imm)
> +#define check_imm26(imm) check_imm(26, imm)
> +
>  /* Map BPF registers to A64 registers */
>  static const int bpf2a64[] = {
>  	/* return value from in-kernel function, and exit value from eBPF */
> @@ -329,6 +340,163 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
>  #undef jmp_offset
>  }
>  
> +static int emit_lse_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
> +{
> +	const u8 code = insn->code;
> +	const u8 dst = bpf2a64[insn->dst_reg];
> +	const u8 src = bpf2a64[insn->src_reg];
> +	const u8 tmp = bpf2a64[TMP_REG_1];
> +	const u8 tmp2 = bpf2a64[TMP_REG_2];
> +	const bool isdw = BPF_SIZE(code) == BPF_DW;
> +	const s16 off = insn->off;
> +	u8 reg;
> +
> +	if (!off) {
> +		reg = dst;
> +	} else {
> +		emit_a64_mov_i(1, tmp, off, ctx);
> +		emit(A64_ADD(1, tmp, tmp, dst), ctx);
> +		reg = tmp;
> +	}
> +
> +	switch (insn->imm) {
> +	/* lock *(u32/u64 *)(dst_reg + off) <op>= src_reg */
> +	case BPF_ADD:
> +		emit(A64_STADD(isdw, reg, src), ctx);
> +		break;
> +	case BPF_AND:
> +		emit(A64_MVN(isdw, tmp2, src), ctx);
> +		emit(A64_STCLR(isdw, reg, tmp2), ctx);
> +		break;
> +	case BPF_OR:
> +		emit(A64_STSET(isdw, reg, src), ctx);
> +		break;
> +	case BPF_XOR:
> +		emit(A64_STEOR(isdw, reg, src), ctx);
> +		break;
> +	/* src_reg = atomic_fetch_add(dst_reg + off, src_reg) */
> +	case BPF_ADD | BPF_FETCH:
> +		emit(A64_LDADDAL(isdw, src, reg, src), ctx);
> +		break;
> +	case BPF_AND | BPF_FETCH:
> +		emit(A64_MVN(isdw, tmp2, src), ctx);
> +		emit(A64_LDCLRAL(isdw, src, reg, tmp2), ctx);
> +		break;
> +	case BPF_OR | BPF_FETCH:
> +		emit(A64_LDSETAL(isdw, src, reg, src), ctx);
> +		break;
> +	case BPF_XOR | BPF_FETCH:
> +		emit(A64_LDEORAL(isdw, src, reg, src), ctx);
> +		break;
> +	/* src_reg = atomic_xchg(dst_reg + off, src_reg); */
> +	case BPF_XCHG:
> +		emit(A64_SWPAL(isdw, src, reg, src), ctx);
> +		break;
> +	/* r0 = atomic_cmpxchg(dst_reg + off, r0, src_reg); */
> +	case BPF_CMPXCHG:
> +		emit(A64_CASAL(isdw, src, reg, bpf2a64[BPF_REG_0]), ctx);
> +		break;
> +	default:
> +		pr_err_once("unknown atomic op code %02x\n", insn->imm);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int emit_ll_sc_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
> +{
> +	const u8 code = insn->code;
> +	const u8 dst = bpf2a64[insn->dst_reg];
> +	const u8 src = bpf2a64[insn->src_reg];
> +	const u8 tmp = bpf2a64[TMP_REG_1];
> +	const u8 tmp2 = bpf2a64[TMP_REG_2];
> +	const u8 tmp3 = bpf2a64[TMP_REG_3];
> +	const int i = insn - ctx->prog->insnsi;
> +	const s32 imm = insn->imm;
> +	const s16 off = insn->off;
> +	const bool isdw = BPF_SIZE(code) == BPF_DW;
> +	u8 reg;
> +	s32 jmp_offset;
> +
> +	if (!off) {
> +		reg = dst;
> +	} else {
> +		emit_a64_mov_i(1, tmp, off, ctx);
> +		emit(A64_ADD(1, tmp, tmp, dst), ctx);
> +		reg = tmp;
> +	}
> +
> +	if (imm == BPF_ADD || imm == BPF_AND ||
> +	    imm == BPF_OR || imm == BPF_XOR) {
> +		/* lock *(u32/u64 *)(dst_reg + off) <op>= src_reg */
> +		emit(A64_LDXR(isdw, tmp2, reg), ctx);
> +		if (imm == BPF_ADD)
> +			emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
> +		else if (imm == BPF_AND)
> +			emit(A64_AND(isdw, tmp2, tmp2, src), ctx);
> +		else if (imm == BPF_OR)
> +			emit(A64_ORR(isdw, tmp2, tmp2, src), ctx);
> +		else
> +			emit(A64_EOR(isdw, tmp2, tmp2, src), ctx);
> +		emit(A64_STXR(isdw, tmp2, reg, tmp3), ctx);
> +		jmp_offset = -3;
> +		check_imm19(jmp_offset);
> +		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
> +	} else if (imm == (BPF_ADD | BPF_FETCH) ||
> +		   imm == (BPF_AND | BPF_FETCH) ||
> +		   imm == (BPF_OR | BPF_FETCH) ||
> +		   imm == (BPF_XOR | BPF_FETCH)) {
> +		/* src_reg = atomic_fetch_add(dst_reg + off, src_reg) */
> +		const u8 ax = bpf2a64[BPF_REG_AX];
> +
> +		emit(A64_MOV(isdw, ax, src), ctx);
> +		emit(A64_LDXR(isdw, src, reg), ctx);
> +		if (imm == (BPF_ADD | BPF_FETCH))
> +			emit(A64_ADD(isdw, tmp2, src, ax), ctx);
> +		else if (imm == (BPF_AND | BPF_FETCH))
> +			emit(A64_AND(isdw, tmp2, src, ax), ctx);
> +		else if (imm == (BPF_OR | BPF_FETCH))
> +			emit(A64_ORR(isdw, tmp2, src, ax), ctx);
> +		else
> +			emit(A64_EOR(isdw, tmp2, src, ax), ctx);
> +		emit(A64_STLXR(isdw, tmp2, reg, tmp3), ctx);
> +		jmp_offset = -3;
> +		check_imm19(jmp_offset);
> +		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
> +		emit(A64_DMB_ISH, ctx);
> +	} else if (imm == BPF_XCHG) {
> +		/* src_reg = atomic_xchg(dst_reg + off, src_reg); */
> +		emit(A64_MOV(isdw, tmp2, src), ctx);
> +		emit(A64_LDXR(isdw, src, reg), ctx);
> +		emit(A64_STLXR(isdw, tmp2, reg, tmp3), ctx);
> +		jmp_offset = -2;
> +		check_imm19(jmp_offset);
> +		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
> +		emit(A64_DMB_ISH, ctx);
> +	} else if (imm == BPF_CMPXCHG) {
> +		/* r0 = atomic_cmpxchg(dst_reg + off, r0, src_reg); */
> +		const u8 r0 = bpf2a64[BPF_REG_0];
> +
> +		emit(A64_MOV(isdw, tmp2, r0), ctx);
> +		emit(A64_LDXR(isdw, r0, reg), ctx);
> +		emit(A64_EOR(isdw, tmp3, r0, tmp2), ctx);
> +		jmp_offset = 4;
> +		check_imm19(jmp_offset);
> +		emit(A64_CBNZ(isdw, tmp3, jmp_offset), ctx);
> +		emit(A64_STLXR(isdw, src, reg, tmp3), ctx);
> +		jmp_offset = -4;
> +		check_imm19(jmp_offset);
> +		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
> +		emit(A64_DMB_ISH, ctx);
> +	} else {
> +		pr_err_once("unknown atomic op code %02x\n", imm);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static void build_epilogue(struct jit_ctx *ctx)
>  {
>  	const u8 r0 = bpf2a64[BPF_REG_0];
> @@ -434,29 +602,16 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
>  	const u8 src = bpf2a64[insn->src_reg];
>  	const u8 tmp = bpf2a64[TMP_REG_1];
>  	const u8 tmp2 = bpf2a64[TMP_REG_2];
> -	const u8 tmp3 = bpf2a64[TMP_REG_3];
>  	const s16 off = insn->off;
>  	const s32 imm = insn->imm;
>  	const int i = insn - ctx->prog->insnsi;
>  	const bool is64 = BPF_CLASS(code) == BPF_ALU64 ||
>  			  BPF_CLASS(code) == BPF_JMP;
> -	const bool isdw = BPF_SIZE(code) == BPF_DW;
> -	u8 jmp_cond, reg;
> +	u8 jmp_cond;
>  	s32 jmp_offset;
>  	u32 a64_insn;
>  	int ret;
>  
> -#define check_imm(bits, imm) do {				\
> -	if ((((imm) > 0) && ((imm) >> (bits))) ||		\
> -	    (((imm) < 0) && (~(imm) >> (bits)))) {		\
> -		pr_info("[%2d] imm=%d(0x%x) out of range\n",	\
> -			i, imm, imm);				\
> -		return -EINVAL;					\
> -	}							\
> -} while (0)
> -#define check_imm19(imm) check_imm(19, imm)
> -#define check_imm26(imm) check_imm(26, imm)
> -
>  	switch (code) {
>  	/* dst = src */
>  	case BPF_ALU | BPF_MOV | BPF_X:
> @@ -891,33 +1046,12 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
>  
>  	case BPF_STX | BPF_ATOMIC | BPF_W:
>  	case BPF_STX | BPF_ATOMIC | BPF_DW:
> -		if (insn->imm != BPF_ADD) {
> -			pr_err_once("unknown atomic op code %02x\n", insn->imm);
> -			return -EINVAL;
> -		}
> -
> -		/* STX XADD: lock *(u32 *)(dst + off) += src
> -		 * and
> -		 * STX XADD: lock *(u64 *)(dst + off) += src
> -		 */
> -
> -		if (!off) {
> -			reg = dst;
> -		} else {
> -			emit_a64_mov_i(1, tmp, off, ctx);
> -			emit(A64_ADD(1, tmp, tmp, dst), ctx);
> -			reg = tmp;
> -		}
> -		if (cpus_have_cap(ARM64_HAS_LSE_ATOMICS)) {
> -			emit(A64_STADD(isdw, reg, src), ctx);
> -		} else {
> -			emit(A64_LDXR(isdw, tmp2, reg), ctx);
> -			emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
> -			emit(A64_STXR(isdw, tmp2, reg, tmp3), ctx);
> -			jmp_offset = -3;
> -			check_imm19(jmp_offset);
> -			emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
> -		}
> +		if (cpus_have_cap(ARM64_HAS_LSE_ATOMICS))
> +			ret = emit_lse_atomic(insn, ctx);
> +		else
> +			ret = emit_ll_sc_atomic(insn, ctx);
> +		if (ret)
> +			return ret;
>  		break;
>  
>  	default:
> -- 
> 2.27.0
> 
> 
