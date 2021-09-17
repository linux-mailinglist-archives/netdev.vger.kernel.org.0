Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4F740FD9A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243443AbhIQQMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:12:23 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:35207 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242637AbhIQQMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:12:21 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4H9zTG4GLWz9sTL;
        Fri, 17 Sep 2021 18:10:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uHgBiDyHP1Bt; Fri, 17 Sep 2021 18:10:58 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4H9zTG369Kz9sSX;
        Fri, 17 Sep 2021 18:10:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5667D8B799;
        Fri, 17 Sep 2021 18:10:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id NlpBolU4rfbX; Fri, 17 Sep 2021 18:10:58 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.36])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1DBE48B768;
        Fri, 17 Sep 2021 18:10:57 +0200 (CEST)
Subject: Re: [PATCH v2 3/8] bpf powerpc: refactor JIT compiler code
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
 <20210917153047.177141-4-hbathini@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <b73d67d5-3ec3-c618-7f4c-ffdd71650e7e@csgroup.eu>
Date:   Fri, 17 Sep 2021 18:10:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210917153047.177141-4-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 17/09/2021 à 17:30, Hari Bathini a écrit :
> Refactor powerpc JITing. This simplifies adding BPF_PROBE_MEM support.

Could you describe a bit more what you are refactoring exactly ?


> 
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> ---
> 
> Changes in v2:
> * New patch to refactor a bit of JITing code.
> 
> 
>   arch/powerpc/net/bpf_jit_comp32.c | 50 +++++++++++---------
>   arch/powerpc/net/bpf_jit_comp64.c | 76 ++++++++++++++++---------------
>   2 files changed, 68 insertions(+), 58 deletions(-)
> 
> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
> index b60b59426a24..c8ae14c316e3 100644
> --- a/arch/powerpc/net/bpf_jit_comp32.c
> +++ b/arch/powerpc/net/bpf_jit_comp32.c
> @@ -276,17 +276,17 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   	u32 exit_addr = addrs[flen];
>   
>   	for (i = 0; i < flen; i++) {
> -		u32 code = insn[i].code;
>   		u32 dst_reg = bpf_to_ppc(ctx, insn[i].dst_reg);
> -		u32 dst_reg_h = dst_reg - 1;
>   		u32 src_reg = bpf_to_ppc(ctx, insn[i].src_reg);
> -		u32 src_reg_h = src_reg - 1;
>   		u32 tmp_reg = bpf_to_ppc(ctx, TMP_REG);
> +		u32 true_cond, code = insn[i].code;
> +		u32 dst_reg_h = dst_reg - 1;
> +		u32 src_reg_h = src_reg - 1;

All changes above seems unneeded and not linked to the current patch. 
Please leave cosmetic changes outside and focus on necessary changes.

> +		u32 size = BPF_SIZE(code);
>   		s16 off = insn[i].off;
>   		s32 imm = insn[i].imm;
>   		bool func_addr_fixed;
>   		u64 func_addr;
> -		u32 true_cond;
>   
>   		/*
>   		 * addrs[] maps a BPF bytecode address into a real offset from
> @@ -809,25 +809,33 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		/*
>   		 * BPF_LDX
>   		 */
> -		case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> -			if (!fp->aux->verifier_zext)
> -				EMIT(PPC_RAW_LI(dst_reg_h, 0));
> -			break;
> -		case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
> -			if (!fp->aux->verifier_zext)
> -				EMIT(PPC_RAW_LI(dst_reg_h, 0));
> -			break;
> -		case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
> -			if (!fp->aux->verifier_zext)
> +		/* dst = *(u8 *)(ul) (src + off) */
> +		case BPF_LDX | BPF_MEM | BPF_B:
> +		/* dst = *(u16 *)(ul) (src + off) */
> +		case BPF_LDX | BPF_MEM | BPF_H:
> +		/* dst = *(u32 *)(ul) (src + off) */
> +		case BPF_LDX | BPF_MEM | BPF_W:
> +		/* dst = *(u64 *)(ul) (src + off) */
> +		case BPF_LDX | BPF_MEM | BPF_DW:
Why changing the location of the comments ? I found it more readable before.

> +			switch (size) {
> +			case BPF_B:
> +				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> +				break;
> +			case BPF_H:
> +				EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
> +				break;
> +			case BPF_W:
> +				EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
> +				break;
> +			case BPF_DW:
> +				EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
> +				EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
> +				break;
> +			}

BPF_B, BPF_H, ... are not part of an enum. Are you sure GCC is happy to 
have no default ?

> +
> +			if ((size != BPF_DW) && !fp->aux->verifier_zext)

You don't need () around size != BPF_DW

>   				EMIT(PPC_RAW_LI(dst_reg_h, 0));
>   			break;
> -		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
> -			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
> -			break;
>   
>   		/*
>   		 * Doubleword load
> diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
> index 2a87da50d9a4..78b28f25555c 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -282,16 +282,15 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   	u32 exit_addr = addrs[flen];
>   
>   	for (i = 0; i < flen; i++) {
> -		u32 code = insn[i].code;
>   		u32 dst_reg = b2p[insn[i].dst_reg];
>   		u32 src_reg = b2p[insn[i].src_reg];
> +		u32 tmp_idx, code = insn[i].code;
> +		u32 size = BPF_SIZE(code);
>   		s16 off = insn[i].off;
>   		s32 imm = insn[i].imm;
>   		bool func_addr_fixed;
> -		u64 func_addr;
> -		u64 imm64;
> +		u64 func_addr, imm64;
>   		u32 true_cond;
> -		u32 tmp_idx;

All changes other than the addition of 'size' seems unneeded and not 
linked to the current patch.

>   
>   		/*
>   		 * addrs[] maps a BPF bytecode address into a real offset from
> @@ -638,35 +637,34 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		 */
>   		case BPF_STX | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = src */
>   		case BPF_ST | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = imm */
> -			if (BPF_CLASS(code) == BPF_ST) {
> -				EMIT(PPC_RAW_LI(b2p[TMP_REG_1], imm));
> -				src_reg = b2p[TMP_REG_1];
> -			}
> -			EMIT(PPC_RAW_STB(src_reg, dst_reg, off));
> -			break;
>   		case BPF_STX | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = src */
>   		case BPF_ST | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = imm */
> -			if (BPF_CLASS(code) == BPF_ST) {
> -				EMIT(PPC_RAW_LI(b2p[TMP_REG_1], imm));
> -				src_reg = b2p[TMP_REG_1];
> -			}
> -			EMIT(PPC_RAW_STH(src_reg, dst_reg, off));
> -			break;
>   		case BPF_STX | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = src */
>   		case BPF_ST | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = imm */
> -			if (BPF_CLASS(code) == BPF_ST) {
> -				PPC_LI32(b2p[TMP_REG_1], imm);
> -				src_reg = b2p[TMP_REG_1];
> -			}
> -			EMIT(PPC_RAW_STW(src_reg, dst_reg, off));
> -			break;
>   		case BPF_STX | BPF_MEM | BPF_DW: /* (u64 *)(dst + off) = src */
>   		case BPF_ST | BPF_MEM | BPF_DW: /* *(u64 *)(dst + off) = imm */
>   			if (BPF_CLASS(code) == BPF_ST) {
> -				PPC_LI32(b2p[TMP_REG_1], imm);
> +				if ((size == BPF_B) || (size == BPF_H))
> +					EMIT(PPC_RAW_LI(b2p[TMP_REG_1], imm));
> +				else /* size == BPF_W || size == BPF_DW */
> +					PPC_LI32(b2p[TMP_REG_1], imm);

I think you can use PPC_LI32() for all cases, it should generate the 
same code.

>   				src_reg = b2p[TMP_REG_1];
>   			}
> -			PPC_BPF_STL(src_reg, dst_reg, off);
> +
> +			switch (size) {
> +			case BPF_B:
> +				EMIT(PPC_RAW_STB(src_reg, dst_reg, off));
> +				break;
> +			case BPF_H:
> +				EMIT(PPC_RAW_STH(src_reg, dst_reg, off));
> +				break;
> +			case BPF_W:
> +				EMIT(PPC_RAW_STW(src_reg, dst_reg, off));
> +				break;
> +			case BPF_DW:
> +				PPC_BPF_STL(src_reg, dst_reg, off);
> +				break;
> +			}
>   			break;
>   
>   		/*
> @@ -716,25 +714,29 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		 */
>   		/* dst = *(u8 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_B:
> -			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> -			if (insn_is_zext(&insn[i + 1]))
> -				addrs[++i] = ctx->idx * 4;
> -			break;
>   		/* dst = *(u16 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_H:
> -			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
> -			if (insn_is_zext(&insn[i + 1]))
> -				addrs[++i] = ctx->idx * 4;
> -			break;
>   		/* dst = *(u32 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_W:
> -			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
> -			if (insn_is_zext(&insn[i + 1]))
> -				addrs[++i] = ctx->idx * 4;
> -			break;
>   		/* dst = *(u64 *)(ul) (src + off) */
>   		case BPF_LDX | BPF_MEM | BPF_DW:
> -			PPC_BPF_LL(dst_reg, src_reg, off);
> +			switch (size) {
> +			case BPF_B:
> +				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> +				break;
> +			case BPF_H:
> +				EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
> +				break;
> +			case BPF_W:
> +				EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
> +				break;
> +			case BPF_DW:
> +				PPC_BPF_LL(dst_reg, src_reg, off);
> +				break;
> +			}
> +
> +			if ((size != BPF_DW) && insn_is_zext(&insn[i + 1]))
> +				addrs[++i] = ctx->idx * 4;
>   			break;
>   
>   		/*
> 
