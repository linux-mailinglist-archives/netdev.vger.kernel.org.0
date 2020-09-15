Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB026A5FB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 15:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgIONLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 09:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgIONLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 09:11:14 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC0A520872;
        Tue, 15 Sep 2020 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600175470;
        bh=u/HTMK9SYBgCqASpK328ZsVw4zxDrK6hSpUMfxoRGKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zV2bRb447YudntQTxCq5cx2hsf+YfN2kbD2p5EqaMRL+St1Y33ZWmsv2Ze0mdR7Sf
         Se+09pdD9vpCL9V9m6Xn0izS8bxbmU8jedSPALDVzeQZQqREX3WSQ/AbA/pxSHDgRG
         QQbW/1YpEn7age6n20mMP155ep19TpDqgMmAPNtM=
Date:   Tue, 15 Sep 2020 14:11:03 +0100
From:   Will Deacon <will@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200915131102.GA26439@willie-the-truck>
References: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias,

On Mon, Sep 14, 2020 at 07:03:55PM +0300, Ilias Apalodimas wrote:
> Running the eBPF test_verifier leads to random errors looking like this:
> 
> [ 6525.735488] Unexpected kernel BRK exception at EL1
> [ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP

Does this happen because we poison the BPF memory with BRK instructions?
Maybe we should look at using a special immediate so we can detect this,
rather than end up in the ptrace handler.

> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index f8912e45be7a..0974effff58c 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -143,9 +143,13 @@ static inline void emit_addr_mov_i64(const int reg, const u64 val,
>  	}
>  }
>  
> -static inline int bpf2a64_offset(int bpf_to, int bpf_from,
> +static inline int bpf2a64_offset(int bpf_insn, int off,
>  				 const struct jit_ctx *ctx)
>  {
> +	/* arm64 offset is relative to the branch instruction */
> +	int bpf_from = bpf_insn + 1;
> +	/* BPF JMP offset is relative to the next instruction */
> +	int bpf_to = bpf_insn + off + 1;
>  	int to = ctx->offset[bpf_to];
>  	/* -1 to account for the Branch instruction */
>  	int from = ctx->offset[bpf_from] - 1;

I think this is a bit confusing with all the variables. How about just
doing:

	/* BPF JMP offset is relative to the next BPF instruction */
	bpf_insn++;

	/*
	 * Whereas arm64 branch instructions encode the offset from the
	 * branch itself, so we must subtract 1 from the instruction offset.
	 */
	return ctx->offset[bpf_insn + off] - ctx->offset[bpf_insn] - 1;

> @@ -642,7 +646,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
>  
>  	/* JUMP off */
>  	case BPF_JMP | BPF_JA:
> -		jmp_offset = bpf2a64_offset(i + off, i, ctx);
> +		jmp_offset = bpf2a64_offset(i, off, ctx);
>  		check_imm26(jmp_offset);
>  		emit(A64_B(jmp_offset), ctx);
>  		break;
> @@ -669,7 +673,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
>  	case BPF_JMP32 | BPF_JSLE | BPF_X:
>  		emit(A64_CMP(is64, dst, src), ctx);
>  emit_cond_jmp:
> -		jmp_offset = bpf2a64_offset(i + off, i, ctx);
> +		jmp_offset = bpf2a64_offset(i, off, ctx);
>  		check_imm19(jmp_offset);
>  		switch (BPF_OP(code)) {
>  		case BPF_JEQ:
> @@ -912,18 +916,26 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
>  		const struct bpf_insn *insn = &prog->insnsi[i];
>  		int ret;
>  
> +		/*
> +		 * offset[0] offset of the end of prologue, start of the
> +		 * first insn.
> +		 * offset[x] - offset of the end of x insn.

So does offset[1] point at the last arm64 instruction for the first BPF
instruction, or does it point to the first arm64 instruction for the second
BPF instruction?

> +		 */
> +		if (ctx->image == NULL)
> +			ctx->offset[i] = ctx->idx;
> +
>  		ret = build_insn(insn, ctx, extra_pass);
>  		if (ret > 0) {
>  			i++;
>  			if (ctx->image == NULL)
> -				ctx->offset[i] = ctx->idx;
> +				ctx->offset[i] = ctx->offset[i - 1];

Does it matter that we set the offset for both halves of a 16-byte BPF
instruction? I think that's a change in behaviour here.

>  			continue;
>  		}
> -		if (ctx->image == NULL)
> -			ctx->offset[i] = ctx->idx;
>  		if (ret)
>  			return ret;
>  	}
> +	if (ctx->image == NULL)
> +		ctx->offset[i] = ctx->idx;

I think it would be cleared to set ctx->offset[0] before the for loop (with
a comment about what it is) and then change the for loop to iterate from 1
all the way to prog->len.

Will
