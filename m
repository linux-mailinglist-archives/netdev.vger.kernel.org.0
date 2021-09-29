Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB4941C394
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbhI2Lom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:44:42 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:38215 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhI2Lom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 07:44:42 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HKDyW5N65z9sYm;
        Wed, 29 Sep 2021 13:42:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6eT6i8EZsuyZ; Wed, 29 Sep 2021 13:42:59 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HKDyW46Zzz9sYh;
        Wed, 29 Sep 2021 13:42:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 71C8F8B770;
        Wed, 29 Sep 2021 13:42:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id X3ysY2qXm5OT; Wed, 29 Sep 2021 13:42:59 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 40B8C8B763;
        Wed, 29 Sep 2021 13:42:59 +0200 (CEST)
Subject: Re: [PATCH v4 3/8] bpf powerpc: refactor JIT compiler code
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
 <20210929111855.50254-4-hbathini@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <0a0e6639-748c-5660-25af-98d82fd78c23@csgroup.eu>
Date:   Wed, 29 Sep 2021 13:42:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210929111855.50254-4-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 29/09/2021 à 13:18, Hari Bathini a écrit :
> Refactor powerpc LDX JITing code to simplify adding BPF_PROBE_MEM
> support.
> 
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
> 
> Changes in v4:
> * Dropped the default case in the switch statement for bpf size.
> * Dropped explicit fallthrough statement for empty switch cases.
> 
> 
>   arch/powerpc/net/bpf_jit_comp32.c | 33 ++++++++++++++++++-------------
>   arch/powerpc/net/bpf_jit_comp64.c | 31 +++++++++++++++++------------
>   2 files changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
> index b60b59426a24..65a4d1ed97bf 100644
> --- a/arch/powerpc/net/bpf_jit_comp32.c
> +++ b/arch/powerpc/net/bpf_jit_comp32.c
> @@ -282,6 +282,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		u32 src_reg = bpf_to_ppc(ctx, insn[i].src_reg);
>   		u32 src_reg_h = src_reg - 1;
>   		u32 tmp_reg = bpf_to_ppc(ctx, TMP_REG);
> +		u32 size = BPF_SIZE(code);
>   		s16 off = insn[i].off;
>   		s32 imm = insn[i].imm;
>   		bool func_addr_fixed;
> @@ -810,23 +811,27 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		 * BPF_LDX
>   		 */
>   		case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> -			if (!fp->aux->verifier_zext)
> -				EMIT(PPC_RAW_LI(dst_reg_h, 0));
> -			break;
>   		case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
> -			if (!fp->aux->verifier_zext)
> -				EMIT(PPC_RAW_LI(dst_reg_h, 0));
> -			break;
>   		case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
> -			if (!fp->aux->verifier_zext)
> -				EMIT(PPC_RAW_LI(dst_reg_h, 0));
> -			break;
>   		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
> -			EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
> -			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
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
> +
> +			if (size != BPF_DW && !fp->aux->verifier_zext)
> +				EMIT(PPC_RAW_LI(dst_reg_h, 0));
>   			break;
>   
>   		/*
> diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
> index 2a87da50d9a4..49e6e0b6e4d2 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -285,6 +285,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		u32 code = insn[i].code;
>   		u32 dst_reg = b2p[insn[i].dst_reg];
>   		u32 src_reg = b2p[insn[i].src_reg];
> +		u32 size = BPF_SIZE(code);
>   		s16 off = insn[i].off;
>   		s32 imm = insn[i].imm;
>   		bool func_addr_fixed;
> @@ -716,25 +717,29 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
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
> +			if (size != BPF_DW && insn_is_zext(&insn[i + 1]))
> +				addrs[++i] = ctx->idx * 4;
>   			break;
>   
>   		/*
> 
