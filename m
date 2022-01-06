Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5A9486D01
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244521AbiAFWAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:00:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:34288 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244436AbiAFWAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:00:45 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5aoG-000EcE-FH; Thu, 06 Jan 2022 23:00:36 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5aoG-000We9-4e; Thu, 06 Jan 2022 23:00:36 +0100
Subject: Re: [PATCH bpf] bpf, arm64: calculate offset as byte-offset for bpf
 line info
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20220104014236.1512639-1-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2091c1ac-2863-cdd6-5de9-d264ab54c9be@iogearbox.net>
Date:   Thu, 6 Jan 2022 23:00:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220104014236.1512639-1-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26414/Thu Jan  6 10:26:00 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/22 2:42 AM, Hou Tao wrote:
> The bpf line info for arm64 is broken due to two reasons:
> (1) insn_to_jit_off passed to bpf_prog_fill_jited_linfo() is
>      calculated in instruction granularity instead of bytes
>      granularity.
> (2) insn_to_jit_off only considers the body itself and ignores
>      prologue before the body.
> 
> So fix it by calculating offset as byte-offset and do build_prologue()
> first in the first JIT pass.
> 
> Fixes: 37ab566c178d ("bpf: arm64: Enable arm64 jit to provide bpf_line_info")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   arch/arm64/net/bpf_jit_comp.c | 27 +++++++++++++++++----------
>   1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 148ca51325bb..d7a6d4b523c9 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -24,6 +24,8 @@
>   
>   #include "bpf_jit.h"
>   
> +#define INSN_SZ (sizeof(u32))
> +
>   #define TMP_REG_1 (MAX_BPF_JIT_REG + 0)
>   #define TMP_REG_2 (MAX_BPF_JIT_REG + 1)
>   #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
> @@ -154,10 +156,11 @@ static inline int bpf2a64_offset(int bpf_insn, int off,
>   	bpf_insn++;
>   	/*
>   	 * Whereas arm64 branch instructions encode the offset
> -	 * from the branch itself, so we must subtract 1 from the
> +	 * from the branch itself, so we must subtract 4 from the
>   	 * instruction offset.
>   	 */
> -	return ctx->offset[bpf_insn + off] - (ctx->offset[bpf_insn] - 1);
> +	return (ctx->offset[bpf_insn + off] -
> +		(ctx->offset[bpf_insn] - INSN_SZ)) / INSN_SZ;
>   }
>   
>   static void jit_fill_hole(void *area, unsigned int size)
> @@ -955,13 +958,14 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
>   		const struct bpf_insn *insn = &prog->insnsi[i];
>   		int ret;
>   
> +		/* BPF line info needs byte-offset instead of insn-offset */
>   		if (ctx->image == NULL)
> -			ctx->offset[i] = ctx->idx;
> +			ctx->offset[i] = ctx->idx * INSN_SZ;
>   		ret = build_insn(insn, ctx, extra_pass);
>   		if (ret > 0) {
>   			i++;
>   			if (ctx->image == NULL)
> -				ctx->offset[i] = ctx->idx;
> +				ctx->offset[i] = ctx->idx * INSN_SZ;
>   			continue;
>   		}
>   		if (ret)
> @@ -973,7 +977,7 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
>   	 * instruction (end of program)
>   	 */
>   	if (ctx->image == NULL)
> -		ctx->offset[i] = ctx->idx;
> +		ctx->offset[i] = ctx->idx * INSN_SZ;
>   
>   	return 0;
>   }
> @@ -1058,15 +1062,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   		goto out_off;
>   	}
>   
> -	/* 1. Initial fake pass to compute ctx->idx. */
> -
> -	/* Fake pass to fill in ctx->offset. */
> -	if (build_body(&ctx, extra_pass)) {
> +	/*
> +	 * 1. Initial fake pass to compute ctx->idx and ctx->offset.
> +	 *
> +	 * BPF line info needs ctx->offset[i] to be the byte offset
> +	 * of instruction[i] in jited image, so build prologue first.
> +	 */
> +	if (build_prologue(&ctx, was_classic)) {
>   		prog = orig_prog;
>   		goto out_off;
>   	}
>   
> -	if (build_prologue(&ctx, was_classic)) {
> +	if (build_body(&ctx, extra_pass)) {
>   		prog = orig_prog;
>   		goto out_off;

Could you split this into two logical patches? Both 1/2 seem independent
of each other and should have been rather 2 patches instead of 1.

Did you check if also other JITs could be affected?

Thanks,
Daniel
