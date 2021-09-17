Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA340FDC6
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239719AbhIQQV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:21:57 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:59865 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhIQQVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:21:55 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4H9zhJ0C1Zz9sTL;
        Fri, 17 Sep 2021 18:20:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3HmtJiRoFnql; Fri, 17 Sep 2021 18:20:31 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4H9zhH4jM1z9sSX;
        Fri, 17 Sep 2021 18:20:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 643098B799;
        Fri, 17 Sep 2021 18:20:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id bomN8LRl1AXu; Fri, 17 Sep 2021 18:20:31 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.36])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5D40F8B768;
        Fri, 17 Sep 2021 18:20:29 +0200 (CEST)
Subject: Re: [PATCH v2 5/8] bpf ppc64: Add BPF_PROBE_MEM support for JIT
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
 <20210917153047.177141-6-hbathini@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <d6be3c64-aab9-b3ca-d632-b02c4943e9bc@csgroup.eu>
Date:   Fri, 17 Sep 2021 18:20:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210917153047.177141-6-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 17/09/2021 à 17:30, Hari Bathini a écrit :
> From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> 
> BPF load instruction with BPF_PROBE_MEM mode can cause a fault
> inside kernel. Append exception table for such instructions
> within BPF program.
> 
> Unlike other archs which uses extable 'fixup' field to pass dest_reg
> and nip, BPF exception table on PowerPC follows the generic PowerPC
> exception table design, where it populates both fixup and extable
> sections within BPF program. fixup section contains two instructions,
> first instruction clears dest_reg and 2nd jumps to next instruction
> in the BPF code. extable 'insn' field contains relative offset of
> the instruction and 'fixup' field contains relative offset of the
> fixup entry. Example layout of BPF program with extable present:
> 
>               +------------------+
>               |                  |
>               |                  |
>     0x4020 -->| ld   r27,4(r3)   |
>               |                  |
>               |                  |
>     0x40ac -->| lwz  r3,0(r4)    |
>               |                  |
>               |                  |
>               |------------------|
>     0x4280 -->| li  r27,0        |  \ fixup entry
>               | b   0x4024       |  /
>     0x4288 -->| li  r3,0         |
>               | b   0x40b0       |
>               |------------------|
>     0x4290 -->| insn=0xfffffd90  |  \ extable entry
>               | fixup=0xffffffec |  /
>     0x4298 -->| insn=0xfffffe14  |
>               | fixup=0xffffffec |
>               +------------------+
> 
>     (Addresses shown here are chosen random, not real)
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> ---
> 
> Changes in v2:
> * Used JITing code after refactoring.
> * Replaced 'xor reg,reg,reg' with 'li reg,0' where appropriate.
> * Avoided unnecessary init during declaration.
> 
> 
>   arch/powerpc/net/bpf_jit.h        |  5 ++-
>   arch/powerpc/net/bpf_jit_comp.c   | 25 ++++++++++----
>   arch/powerpc/net/bpf_jit_comp32.c |  2 +-
>   arch/powerpc/net/bpf_jit_comp64.c | 57 ++++++++++++++++++++++++++++++-
>   4 files changed, 80 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
> index 0c8f885b8f48..6357c71c26eb 100644
> --- a/arch/powerpc/net/bpf_jit.h
> +++ b/arch/powerpc/net/bpf_jit.h
> @@ -141,8 +141,11 @@ struct codegen_context {
>   	unsigned int idx;
>   	unsigned int stack_size;
>   	int b2p[ARRAY_SIZE(b2p)];
> +	unsigned int exentry_idx;
>   };
>   
> +#define BPF_FIXUP_LEN	8 /* Two instructions */
> +
>   static inline void bpf_flush_icache(void *start, void *end)
>   {
>   	smp_wmb();	/* smp write barrier */
> @@ -166,7 +169,7 @@ static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
>   
>   void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
>   int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
> -		       u32 *addrs);
> +		       u32 *addrs, int pass);
>   void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
>   void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
>   void bpf_jit_realloc_regs(struct codegen_context *ctx);
> diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
> index c5c9e8ad1de7..e92bd79d3bac 100644
> --- a/arch/powerpc/net/bpf_jit_comp.c
> +++ b/arch/powerpc/net/bpf_jit_comp.c
> @@ -101,6 +101,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   	struct bpf_prog *tmp_fp;
>   	bool bpf_blinded = false;
>   	bool extra_pass = false;
> +	u32 extable_len;
> +	u32 fixup_len;
>   
>   	if (!fp->jit_requested)
>   		return org_fp;
> @@ -131,7 +133,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   		image = jit_data->image;
>   		bpf_hdr = jit_data->header;
>   		proglen = jit_data->proglen;
> -		alloclen = proglen + FUNCTION_DESCR_SIZE;
>   		extra_pass = true;
>   		goto skip_init_ctx;
>   	}
> @@ -149,7 +150,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
>   
>   	/* Scouting faux-generate pass 0 */
> -	if (bpf_jit_build_body(fp, 0, &cgctx, addrs)) {
> +	if (bpf_jit_build_body(fp, 0, &cgctx, addrs, 0)) {
>   		/* We hit something illegal or unsupported. */
>   		fp = org_fp;
>   		goto out_addrs;
> @@ -162,7 +163,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   	 */
>   	if (cgctx.seen & SEEN_TAILCALL) {
>   		cgctx.idx = 0;
> -		if (bpf_jit_build_body(fp, 0, &cgctx, addrs)) {
> +		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, 0)) {
>   			fp = org_fp;
>   			goto out_addrs;
>   		}
> @@ -177,8 +178,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   	bpf_jit_build_prologue(0, &cgctx);
>   	bpf_jit_build_epilogue(0, &cgctx);
>   
> +	fixup_len = fp->aux->num_exentries * BPF_FIXUP_LEN;
> +	extable_len = fp->aux->num_exentries * sizeof(struct exception_table_entry);
> +
>   	proglen = cgctx.idx * 4;
> -	alloclen = proglen + FUNCTION_DESCR_SIZE;
> +	alloclen = proglen + FUNCTION_DESCR_SIZE + fixup_len + extable_len;
>   
>   	bpf_hdr = bpf_jit_binary_alloc(alloclen, &image, 4, bpf_jit_fill_ill_insns);
>   	if (!bpf_hdr) {
> @@ -186,6 +190,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   		goto out_addrs;
>   	}
>   
> +	if (extable_len) {
> +		fp->aux->extable = (void *)image + FUNCTION_DESCR_SIZE +
> +				   proglen + fixup_len;
> +	}

No { } for single lines statements (See kernel coding style)

> +
>   skip_init_ctx:
>   	code_base = (u32 *)(image + FUNCTION_DESCR_SIZE);
>   
> @@ -210,7 +219,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   		/* Now build the prologue, body code & epilogue for real. */
>   		cgctx.idx = 0;
>   		bpf_jit_build_prologue(code_base, &cgctx);
> -		bpf_jit_build_body(fp, code_base, &cgctx, addrs);
> +		if (bpf_jit_build_body(fp, code_base, &cgctx, addrs, pass)) {
> +			bpf_jit_binary_free(bpf_hdr);
> +			fp = org_fp;
> +			goto out_addrs;
> +		}
>   		bpf_jit_build_epilogue(code_base, &cgctx);
>   
>   		if (bpf_jit_enable > 1)
> @@ -234,7 +247,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   
>   	fp->bpf_func = (void *)image;
>   	fp->jited = 1;
> -	fp->jited_len = alloclen;
> +	fp->jited_len = proglen + FUNCTION_DESCR_SIZE;
>   
>   	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
>   	bpf_jit_binary_lock_ro(bpf_hdr);
> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
> index c8ae14c316e3..94641b7be387 100644
> --- a/arch/powerpc/net/bpf_jit_comp32.c
> +++ b/arch/powerpc/net/bpf_jit_comp32.c
> @@ -266,7 +266,7 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
>   
>   /* Assemble the body code between the prologue & epilogue */
>   int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
> -		       u32 *addrs)
> +		       u32 *addrs, int pass)
>   {
>   	const struct bpf_insn *insn = fp->insnsi;
>   	int flen = fp->len;
> diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
> index 78b28f25555c..2fc10995f243 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -270,9 +270,54 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
>   	/* out: */
>   }
>   
> +/*
> + * The caller should check for (BPF_MODE(code) == BPF_PROBE_MEM) before calling
> + * this function, as this only applies to BPF_PROBE_MEM, for now.
> + */
> +static int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
> +				 struct codegen_context *ctx, int dst_reg)

Patch 7 will reuse this function so put it in 
arch/powerpc/net/bpf_jit_comp.c now instead of moving it later.


> +{
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
> +	pc = (unsigned long)&image[ctx->idx - 1];
> +
> +	fixup = (void *)fp->aux->extable -
> +		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
> +		(ctx->exentry_idx * BPF_FIXUP_LEN);
> +
> +	fixup[0] = PPC_RAW_LI(dst_reg, 0);
> +	fixup[1] = PPC_RAW_BRANCH((long)(pc + 4) - (long)&fixup[1]);
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
> +
>   /* Assemble the body code between the prologue & epilogue */
>   int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
> -		       u32 *addrs)
> +		       u32 *addrs, int pass)
>   {
>   	const struct bpf_insn *insn = fp->insnsi;
>   	int flen = fp->len;
> @@ -714,12 +759,16 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
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
> @@ -737,6 +786,12 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   
>   			if ((size != BPF_DW) && insn_is_zext(&insn[i + 1]))
>   				addrs[++i] = ctx->idx * 4;
> +
> +			if (BPF_MODE(code) == BPF_PROBE_MEM) {
> +				ret = bpf_add_extable_entry(fp, image, pass, ctx, dst_reg);
> +				if (ret)
> +					return ret;
> +			}
>   			break;
>   
>   		/*
> 
