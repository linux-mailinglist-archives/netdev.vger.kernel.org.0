Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD254874A5
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 10:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346419AbiAGJZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 04:25:25 -0500
Received: from mail.loongson.cn ([114.242.206.163]:40748 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231910AbiAGJZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 04:25:25 -0500
Received: from loongson-pc (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxOMruBthh5m0AAA--.418S2;
        Fri, 07 Jan 2022 17:25:04 +0800 (CST)
Date:   Fri, 7 Jan 2022 17:25:02 +0800
From:   Huang Pei <huangpei@loongson.cn>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        jiaxun.yang@flygoat.com, yangtiezhu@loongson.cn,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/7] mips: bpf: Add JIT workarounds for CPU errata
Message-ID: <20220107092456.kq6t2fdaf2bq36db@loongson-pc>
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
 <20211005165408.2305108-6-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005165408.2305108-6-johan.almbladh@anyfinetworks.com>
User-Agent: NeoMutt/20180716
X-CM-TRANSID: AQAAf9DxOMruBthh5m0AAA--.418S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr18GFW7tFWDGw1kGryfZwb_yoW7Aw15pF
        yUCwn3Cr9Fqr1DZFyrAF45Xr1Sgr4SqF47Cayak340qr9agFn3KF18KF45XrZ8uryDA34r
        JrZ0vF98u3s3A37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjEoGJ
        UUUUU==
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, for Loongson3 errata, we need another sycn for cmpxchg

 @@ -414,12 +415,13 @@ static void emit_cmpxchg_r64(struct jit_context *ctx, u8 dst, u8 src, s16 off)
  	u8 t1 = MIPS_R_T6;
  	u8 t2 = MIPS_R_T7;
  
 +	LLSC_sync(ctx);
  	emit(ctx, lld, t1, off, dst);
  	emit(ctx, bne, t1, r0, 12);
  	emit(ctx, move, t2, src);      /* Delay slot */
  	emit(ctx, scd, t2, off, dst);
 -	emit(ctx, beqz, t2, -20);
 -	emit(ctx, move, r0, t1);      /* Delay slot */
 +	emit(ctx, LLSC_beqz, t2, -20 - LLSC_offset);
 +	emit(ctx, move, r0, t1);       /* Delay slot */
 +	LLSC_sync(ctx);	
  
On Tue, Oct 05, 2021 at 06:54:06PM +0200, Johan Almbladh wrote:
> This patch adds workarounds for the following CPU errata to the MIPS
> eBPF JIT, if enabled in the kernel configuration.
> 
>   - R10000 ll/sc weak ordering
>   - Loongson-3 ll/sc weak ordering
>   - Loongson-2F jump hang
> 
> The Loongson-2F nop errata is implemented in uasm, which the JIT uses,
> so no additional mitigations are needed for that.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  arch/mips/net/bpf_jit_comp.c   |  6 ++++--
>  arch/mips/net/bpf_jit_comp.h   | 26 +++++++++++++++++++++++++-
>  arch/mips/net/bpf_jit_comp64.c | 10 ++++++----
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/mips/net/bpf_jit_comp.c b/arch/mips/net/bpf_jit_comp.c
> index 7eb95fc57710..b17130d510d4 100644
> --- a/arch/mips/net/bpf_jit_comp.c
> +++ b/arch/mips/net/bpf_jit_comp.c
> @@ -404,6 +404,7 @@ void emit_alu_r(struct jit_context *ctx, u8 dst, u8 src, u8 op)
>  /* Atomic read-modify-write (32-bit) */
>  void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
>  {
> +	LLSC_sync(ctx);
>  	emit(ctx, ll, MIPS_R_T9, off, dst);
>  	switch (code) {
>  	case BPF_ADD:
> @@ -427,7 +428,7 @@ void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
>  		break;
>  	}
>  	emit(ctx, sc, MIPS_R_T8, off, dst);
> -	emit(ctx, beqz, MIPS_R_T8, -16);
> +	emit(ctx, LLSC_beqz, MIPS_R_T8, -16 - LLSC_offset);
>  	emit(ctx, nop); /* Delay slot */
>  
>  	if (code & BPF_FETCH) {
> @@ -439,11 +440,12 @@ void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
>  /* Atomic compare-and-exchange (32-bit) */
>  void emit_cmpxchg_r(struct jit_context *ctx, u8 dst, u8 src, u8 res, s16 off)
>  {
> +	LLSC_sync(ctx);
>  	emit(ctx, ll, MIPS_R_T9, off, dst);
>  	emit(ctx, bne, MIPS_R_T9, res, 12);
>  	emit(ctx, move, MIPS_R_T8, src);     /* Delay slot */
>  	emit(ctx, sc, MIPS_R_T8, off, dst);
> -	emit(ctx, beqz, MIPS_R_T8, -20);
> +	emit(ctx, LLSC_beqz, MIPS_R_T8, -20 - LLSC_offset);
>  	emit(ctx, move, res, MIPS_R_T9);     /* Delay slot */
>  	clobber_reg(ctx, res);
>  }
> diff --git a/arch/mips/net/bpf_jit_comp.h b/arch/mips/net/bpf_jit_comp.h
> index 44787cf377dd..6f3a7b07294b 100644
> --- a/arch/mips/net/bpf_jit_comp.h
> +++ b/arch/mips/net/bpf_jit_comp.h
> @@ -87,7 +87,7 @@ struct jit_context {
>  };
>  
>  /* Emit the instruction if the JIT memory space has been allocated */
> -#define emit(ctx, func, ...)					\
> +#define __emit(ctx, func, ...)					\
>  do {								\
>  	if ((ctx)->target != NULL) {				\
>  		u32 *p = &(ctx)->target[ctx->jit_index];	\
> @@ -95,6 +95,30 @@ do {								\
>  	}							\
>  	(ctx)->jit_index++;					\
>  } while (0)
> +#define emit(...) __emit(__VA_ARGS__)
> +
> +/* Workaround for R10000 ll/sc errata */
> +#ifdef CONFIG_WAR_R10000
> +#define LLSC_beqz	beqzl
> +#else
> +#define LLSC_beqz	beqz
> +#endif
> +
> +/* Workaround for Loongson-3 ll/sc errata */
> +#ifdef CONFIG_CPU_LOONGSON3_WORKAROUNDS
> +#define LLSC_sync(ctx)	emit(ctx, sync, 0)
> +#define LLSC_offset	4
> +#else
> +#define LLSC_sync(ctx)
> +#define LLSC_offset	0
> +#endif
> +
> +/* Workaround for Loongson-2F jump errata */
> +#ifdef CONFIG_CPU_JUMP_WORKAROUNDS
> +#define JALR_MASK	0xffffffffcfffffffULL
> +#else
> +#define JALR_MASK	(~0ULL)
> +#endif
>  
>  /*
>   * Mark a BPF register as accessed, it needs to be
> diff --git a/arch/mips/net/bpf_jit_comp64.c b/arch/mips/net/bpf_jit_comp64.c
> index ca49d3ef7ff4..1f1f7b87f213 100644
> --- a/arch/mips/net/bpf_jit_comp64.c
> +++ b/arch/mips/net/bpf_jit_comp64.c
> @@ -375,6 +375,7 @@ static void emit_atomic_r64(struct jit_context *ctx,
>  	u8 t1 = MIPS_R_T6;
>  	u8 t2 = MIPS_R_T7;
>  
> +	LLSC_sync(ctx);
>  	emit(ctx, lld, t1, off, dst);
>  	switch (code) {
>  	case BPF_ADD:
> @@ -398,7 +399,7 @@ static void emit_atomic_r64(struct jit_context *ctx,
>  		break;
>  	}
>  	emit(ctx, scd, t2, off, dst);
> -	emit(ctx, beqz, t2, -16);
> +	emit(ctx, LLSC_beqz, t2, -16 - LLSC_offset);
>  	emit(ctx, nop); /* Delay slot */
>  
>  	if (code & BPF_FETCH) {
> @@ -414,12 +415,13 @@ static void emit_cmpxchg_r64(struct jit_context *ctx, u8 dst, u8 src, s16 off)
>  	u8 t1 = MIPS_R_T6;
>  	u8 t2 = MIPS_R_T7;
>  
> +	LLSC_sync(ctx);
>  	emit(ctx, lld, t1, off, dst);
>  	emit(ctx, bne, t1, r0, 12);
>  	emit(ctx, move, t2, src);      /* Delay slot */
>  	emit(ctx, scd, t2, off, dst);
> -	emit(ctx, beqz, t2, -20);
> -	emit(ctx, move, r0, t1);      /* Delay slot */
> +	emit(ctx, LLSC_beqz, t2, -20 - LLSC_offset);
> +	emit(ctx, move, r0, t1);       /* Delay slot */
>  
>  	clobber_reg(ctx, r0);
>  }
> @@ -443,7 +445,7 @@ static int emit_call(struct jit_context *ctx, const struct bpf_insn *insn)
>  	push_regs(ctx, ctx->clobbered & JIT_CALLER_REGS, 0, 0);
>  
>  	/* Emit function call */
> -	emit_mov_i64(ctx, tmp, addr);
> +	emit_mov_i64(ctx, tmp, addr & JALR_MASK);
>  	emit(ctx, jalr, MIPS_R_RA, tmp);
>  	emit(ctx, nop); /* Delay slot */
>  
> -- 
> 2.30.2
> 

