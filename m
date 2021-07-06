Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034863BC8B3
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 11:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGFJ40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 05:56:26 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:20903 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhGFJ4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 05:56:25 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GJyYj4Cr1zBBJS;
        Tue,  6 Jul 2021 11:53:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oQkE2M0fqy9u; Tue,  6 Jul 2021 11:53:45 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GJyYj3BH9zBBJJ;
        Tue,  6 Jul 2021 11:53:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 579238B79E;
        Tue,  6 Jul 2021 11:53:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 8NcbPEjczuQZ; Tue,  6 Jul 2021 11:53:45 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5597F8B794;
        Tue,  6 Jul 2021 11:53:44 +0200 (CEST)
Subject: Re: [PATCH 3/4] bpf powerpc: Add BPF_PROBE_MEM support for 64bit JIT
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     songliubraving@fb.com, netdev@vger.kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kpsingh@kernel.org,
        paulus@samba.org, sandipan@linux.ibm.com, yhs@fb.com,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kafai@fb.com,
        linux-kernel@vger.kernel.org
References: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
 <20210706073211.349889-4-ravi.bangoria@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <2bfcb782-3133-2db2-31a7-6886156d2048@csgroup.eu>
Date:   Tue, 6 Jul 2021 11:53:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706073211.349889-4-ravi.bangoria@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 06/07/2021 à 09:32, Ravi Bangoria a écrit :
> BPF load instruction with BPF_PROBE_MEM mode can cause a fault
> inside kernel. Append exception table for such instructions
> within BPF program.

Can you do the same for 32bit ?

> 
> Unlike other archs which uses extable 'fixup' field to pass dest_reg
> and nip, BPF exception table on PowerPC follows the generic PowerPC
> exception table design, where it populates both fixup and extable
> sections witin BPF program. fixup section contains two instructions,
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
>     0x4280 -->| xor r27,r27,r27  |  \ fixup entry
>               | b   0x4024       |  /
>     0x4288 -->| xor r3,r3,r3     |
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
> ---
>   arch/powerpc/net/bpf_jit.h        |  5 ++-
>   arch/powerpc/net/bpf_jit_comp.c   | 25 +++++++++----
>   arch/powerpc/net/bpf_jit_comp32.c |  2 +-
>   arch/powerpc/net/bpf_jit_comp64.c | 60 ++++++++++++++++++++++++++++++-
>   4 files changed, 83 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
> index 411c63d945c7..e9408ad190d3 100644
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
> index a9585e52a88d..3ebd8897cf09 100644
> --- a/arch/powerpc/net/bpf_jit_comp.c
> +++ b/arch/powerpc/net/bpf_jit_comp.c
> @@ -89,6 +89,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>   {
>   	u32 proglen;
>   	u32 alloclen;
> +	u32 extable_len = 0;
> +	u32 fixup_len = 0;

Setting those to 0 doesn't seem to be needed, as it doesn't seem to exist any path to skip the 
setting below. You should not perform unnecessary init at declaration as it is error prone.

>   	u8 *image = NULL;
>   	u32 *code_base;
>   	u32 *addrs;
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
>   	if (!fp->is_func || extra_pass) {

This hunk does not apply on latest powerpc tree. You are missing commit 62e3d4210ac9c


> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
> index 1f81bea35aab..23ab5620a45a 100644
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
> index 984177d9d394..1884c6dca89a 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -270,9 +270,51 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
>   	/* out: */
>   }
>   
> +static int add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
> +			     u32 code, struct codegen_context *ctx, int dst_reg)
> +{
> +	off_t offset;
> +	unsigned long pc;
> +	struct exception_table_entry *ex;
> +	u32 *fixup;
> +
> +	/* Populate extable entries only in the last pass */
> +	if (pass != 2 || BPF_MODE(code) != BPF_PROBE_MEM)

'code' is only used for that test, can you do the test before calling add_extable_entry() ?

> +		return 0;
> +
> +	if (!fp->aux->extable ||
> +	    WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
> +		return -EINVAL;
> +
> +	pc = (unsigned long)&image[ctx->idx - 1];

You should call this function before incrementing ctx->idx

> +
> +	fixup = (void *)fp->aux->extable -
> +		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
> +		(ctx->exentry_idx * BPF_FIXUP_LEN);
> +
> +	fixup[0] = PPC_RAW_XOR(dst_reg, dst_reg, dst_reg);

Prefered way to clear a reg in according to ISA is to do 'li reg, 0'

> +	fixup[1] = (PPC_INST_BRANCH |
> +		   (((long)(pc + 4) - (long)&fixup[1]) & 0x03fffffc));

Would be nice if we could have a PPC_RAW_BRANCH() stuff, we could do something like 
PPC_RAW_BRANCH((long)(pc + 4) - (long)&fixup[1])


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
> @@ -710,25 +752,41 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		 */
>   		/* dst = *(u8 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_B:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_B:

Could do:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
+			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
+			if (ret)
+				return ret;
   		case BPF_LDX | BPF_MEM | BPF_B:

>   			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
>   			if (insn_is_zext(&insn[i + 1]))
>   				addrs[++i] = ctx->idx * 4;
> +			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
> +			if (ret)
> +				return ret;
>   			break;
>   		/* dst = *(u16 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_H:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
>   			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
>   			if (insn_is_zext(&insn[i + 1]))
>   				addrs[++i] = ctx->idx * 4;
> +			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
> +			if (ret)
> +				return ret;
>   			break;
>   		/* dst = *(u32 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_W:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
>   			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
>   			if (insn_is_zext(&insn[i + 1]))
>   				addrs[++i] = ctx->idx * 4;
> +			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
> +			if (ret)
> +				return ret;
>   			break;
>   		/* dst = *(u64 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_DW:
> +		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
>   			PPC_BPF_LL(dst_reg, src_reg, off);
> +			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
> +			if (ret)
> +				return ret;
>   			break;
>   
>   		/*
> 
