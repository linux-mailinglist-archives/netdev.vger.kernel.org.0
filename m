Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA3540FE04
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhIQQky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:40:54 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:37799 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236487AbhIQQkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:40:51 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HB06749tjz9sTL;
        Fri, 17 Sep 2021 18:39:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zUNT4t2GfQZZ; Fri, 17 Sep 2021 18:39:27 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HB0672sByz9sT0;
        Fri, 17 Sep 2021 18:39:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4DDB18B799;
        Fri, 17 Sep 2021 18:39:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id k6qJeblYekNp; Fri, 17 Sep 2021 18:39:27 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.36])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1D2C58B768;
        Fri, 17 Sep 2021 18:39:26 +0200 (CEST)
Subject: Re: [PATCH v2 7/8] bpf ppc32: Add BPF_PROBE_MEM support for JIT
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
 <20210917153047.177141-8-hbathini@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <24bc04e9-7df3-ca26-def9-f7d5b7b4aff4@csgroup.eu>
Date:   Fri, 17 Sep 2021 18:39:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210917153047.177141-8-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 17/09/2021 à 17:30, Hari Bathini a écrit :
> BPF load instruction with BPF_PROBE_MEM mode can cause a fault
> inside kernel. Append exception table for such instructions
> within BPF program.
> 
> Unlike other archs which uses extable 'fixup' field to pass dest_reg
> and nip, BPF exception table on PowerPC follows the generic PowerPC
> exception table design, where it populates both fixup and extable
> sections within BPF program. fixup section contains 3 instructions,
> first 2 instructions clear dest_reg (lower & higher 32-bit registers)
> and last instruction jumps to next instruction in the BPF code.
> extable 'insn' field contains relative offset of the instruction and
> 'fixup' field contains relative offset of the fixup entry. Example
> layout of BPF program with extable present:
> 
>               +------------------+
>               |                  |
>               |                  |
>     0x4020 -->| lwz   r28,4(r4)  |
>               |                  |
>               |                  |
>     0x40ac -->| lwz  r3,0(r24)   |
>               | lwz  r4,4(r24)   |
>               |                  |
>               |                  |
>               |------------------|
>     0x4278 -->| li  r28,0        |  \
>               | li  r27,0        |  | fixup entry
>               | b   0x4024       |  /
>     0x4284 -->| li  r4,0         |
>               | li  r3,0         |
>               | b   0x40b4       |
>               |------------------|
>     0x4290 -->| insn=0xfffffd90  |  \ extable entry
>               | fixup=0xffffffe4 |  /
>     0x4298 -->| insn=0xfffffe14  |
>               | fixup=0xffffffe8 |
>               +------------------+
> 
>     (Addresses shown here are chosen random, not real)
> 
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> ---
> 
> Changes in v2:
> * New patch to add BPF_PROBE_MEM support for PPC32.
> 
> 
>   arch/powerpc/net/bpf_jit.h        |  7 +++++
>   arch/powerpc/net/bpf_jit_comp.c   | 50 +++++++++++++++++++++++++++++++
>   arch/powerpc/net/bpf_jit_comp32.c | 30 +++++++++++++++++++
>   arch/powerpc/net/bpf_jit_comp64.c | 48 ++---------------------------
>   4 files changed, 89 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
> index 6357c71c26eb..6a591ef88006 100644
> --- a/arch/powerpc/net/bpf_jit.h
> +++ b/arch/powerpc/net/bpf_jit.h
> @@ -144,7 +144,11 @@ struct codegen_context {
>   	unsigned int exentry_idx;
>   };
>   
> +#ifdef CONFIG_PPC32
> +#define BPF_FIXUP_LEN	12 /* Three instructions */

Could use 3 and 2 instead of 12 and 8, see later why.

> +#else
>   #define BPF_FIXUP_LEN	8 /* Two instructions */
> +#endif
>   
>   static inline void bpf_flush_icache(void *start, void *end)
>   {
> @@ -174,6 +178,9 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
>   void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
>   void bpf_jit_realloc_regs(struct codegen_context *ctx);
>   
> +int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass, struct codegen_context *ctx,
> +			  int insn_idx, int jmp_off, int dst_reg);
> +
>   #endif
>   
>   #endif
> diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
> index e92bd79d3bac..a1753b8c78c8 100644
> --- a/arch/powerpc/net/bpf_jit_comp.c
> +++ b/arch/powerpc/net/bpf_jit_comp.c
> @@ -271,3 +271,53 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   
>   	return fp;
>   }
> +
> +/*
> + * The caller should check for (BPF_MODE(code) == BPF_PROBE_MEM) before calling
> + * this function, as this only applies to BPF_PROBE_MEM, for now.
> + */
> +int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass, struct codegen_context *ctx,
> +			  int insn_idx, int jmp_off, int dst_reg)
> +{

Modify patch 5 to get that function already in 
arch/powerpc/net/bpf_jit_comp.c, so that only changes/additions to the 
function appear here.


And you can have the prototype ready for the final version in patch 5 
instead of adding new arguments here and having to change ppc64 call site.

And in fact you can use them already in patch 5, like jmp_off.

> +	off_t offset;
> +	unsigned long pc;
> +	struct exception_table_entry *ex;
> +	u32 *fixup;
> +
> +	/* Populate extable entries only in the last pass */
> +	if (pass != 2)
> +		return 0;
> +
> +	if (!fp->aux->extable ||
> +	    WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
> +		return -EINVAL;
> +
> +	pc = (unsigned long)&image[insn_idx];
> +
> +	fixup = (void *)fp->aux->extable -
> +		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
> +		(ctx->exentry_idx * BPF_FIXUP_LEN);

Use 2 or 3 for BPF_FIXUP_LEN and multiply by 4 here.

> +
> +	fixup[0] = PPC_RAW_LI(dst_reg, 0);
> +#ifdef CONFIG_PPC32

You should use 'if (IS_ENABLED(CONFIG_PPC32)' instead of a #ifdef here.

> +	fixup[1] = PPC_RAW_LI(dst_reg - 1, 0); /* clear higher 32-bit register too */
> +	fixup[2] = PPC_RAW_BRANCH((long)(pc + jmp_off) - (long)&fixup[2]);
> +#else
> +	fixup[1] = PPC_RAW_BRANCH((long)(pc + jmp_off) - (long)&fixup[1]);
> +#endif

Use 2 or 3 for BPF_FIXUP_LEN and you can do

	if (IS_ENABLED(CONFIG_PPC32)
		fixup[1] = PPC_RAW_LI(dst_reg - 1, 0); /* clear higher 32-bit register 
too */

	fixup[BPF_FIXUP_LEN - 1] = PPC_RAW_BRANCH((long)(pc + jmp_off) - 
(long)&fixup[BPF_FIXUP_LEN - 1]);


> +
> +	ex = &fp->aux->extable[ctx->exentry_idx];
> +
> +	offset = pc - (long)&ex->insn;
> +	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
> +		return -ERANGE;
> +	ex->insn = offset;
> +
> +	offset = (long)fixup - (long)&ex->fixup;
> +	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
> +		return -ERANGE;
> +	ex->fixup = offset;
> +
> +	ctx->exentry_idx++;
> +	return 0;
> +}
> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
> index 94641b7be387..c6262289dcc4 100644
> --- a/arch/powerpc/net/bpf_jit_comp32.c
> +++ b/arch/powerpc/net/bpf_jit_comp32.c
> @@ -811,12 +811,16 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		 */
>   		/* dst = *(u8 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_B:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
>   		/* dst = *(u16 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_H:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
>   		/* dst = *(u32 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_W:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
>   		/* dst = *(u64 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_DW:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
>   			switch (size) {
>   			case BPF_B:
>   				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> @@ -835,6 +839,32 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   
>   			if ((size != BPF_DW) && !fp->aux->verifier_zext)
>   				EMIT(PPC_RAW_LI(dst_reg_h, 0));
> +
> +			if (BPF_MODE(code) == BPF_PROBE_MEM) {
> +				int insn_idx = ctx->idx - 1;
> +				int jmp_off = 4;
> +
> +				/*
> +				 * In case of BPF_DW, two lwz instructions are emitted, one
> +				 * for higher 32-bit and another for lower 32-bit. So, set
> +				 * ex->insn to the first of the two and jump over both
> +				 * instructions in fixup.
> +				 *
> +				 * Similarly, with !verifier_zext, two instructions are
> +				 * emitted for BPF_B/H/W case. So, set ex-insn to the
> +				 * instruction that could fault and skip over both
> +				 * instructions.
> +				 */
> +				if ((size == BPF_DW) || !fp->aux->verifier_zext) {

No need of ( ) around 'size == BPF_DW'

> +					insn_idx -= 1;
> +					jmp_off += 4;
> +				}
> +
> +				ret = bpf_add_extable_entry(fp, image, pass, ctx, insn_idx,
> +							    jmp_off, dst_reg);
> +				if (ret)
> +					return ret;
> +			}
>   			break;
>   
>   		/*
> diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
> index eb28dbc67151..10cc9f04843c 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -270,51 +270,6 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
>   	/* out: */
>   }
>   
> -/*
> - * The caller should check for (BPF_MODE(code) == BPF_PROBE_MEM) before calling
> - * this function, as this only applies to BPF_PROBE_MEM, for now.
> - */
> -static int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
> -				 struct codegen_context *ctx, int dst_reg)
> -{
> -	off_t offset;
> -	unsigned long pc;
> -	struct exception_table_entry *ex;
> -	u32 *fixup;
> -
> -	/* Populate extable entries only in the last pass */
> -	if (pass != 2)
> -		return 0;
> -
> -	if (!fp->aux->extable ||
> -	    WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
> -		return -EINVAL;
> -
> -	pc = (unsigned long)&image[ctx->idx - 1];
> -
> -	fixup = (void *)fp->aux->extable -
> -		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
> -		(ctx->exentry_idx * BPF_FIXUP_LEN);
> -
> -	fixup[0] = PPC_RAW_LI(dst_reg, 0);
> -	fixup[1] = PPC_RAW_BRANCH((long)(pc + 4) - (long)&fixup[1]);
> -
> -	ex = &fp->aux->extable[ctx->exentry_idx];
> -
> -	offset = pc - (long)&ex->insn;
> -	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
> -		return -ERANGE;
> -	ex->insn = offset;
> -
> -	offset = (long)fixup - (long)&ex->fixup;
> -	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
> -		return -ERANGE;
> -	ex->fixup = offset;
> -
> -	ctx->exentry_idx++;
> -	return 0;
> -}
> -
>   /* Assemble the body code between the prologue & epilogue */
>   int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
>   		       u32 *addrs, int pass)
> @@ -811,7 +766,8 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   				addrs[++i] = ctx->idx * 4;
>   
>   			if (BPF_MODE(code) == BPF_PROBE_MEM) {
> -				ret = bpf_add_extable_entry(fp, image, pass, ctx, dst_reg);
> +				ret = bpf_add_extable_entry(fp, image, pass, ctx, ctx->idx - 1,
> +							    4, dst_reg);

Make that ready in patch 5 so that you don't need to change here in patch 7.

>   				if (ret)
>   					return ret;
>   			}
> 
