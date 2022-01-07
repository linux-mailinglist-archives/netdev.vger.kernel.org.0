Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91239487554
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 11:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346655AbiAGKSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 05:18:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:41464 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbiAGKSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 05:18:11 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5mJs-000CBa-0V; Fri, 07 Jan 2022 11:18:00 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5mJr-0003PV-If; Fri, 07 Jan 2022 11:17:59 +0100
Subject: Re: [PATCH 5/7] mips: bpf: Add JIT workarounds for CPU errata
To:     Huang Pei <huangpei@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, andrii@kernel.org, paulburton@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        jiaxun.yang@flygoat.com, yangtiezhu@loongson.cn,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
 <20211005165408.2305108-6-johan.almbladh@anyfinetworks.com>
 <20220107092456.kq6t2fdaf2bq36db@loongson-pc>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f7e6800b-c9e5-4e4b-291c-f19338471fd0@iogearbox.net>
Date:   Fri, 7 Jan 2022 11:17:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220107092456.kq6t2fdaf2bq36db@loongson-pc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26415/Fri Jan  7 10:26:59 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Huang,

On 1/7/22 10:25 AM, Huang Pei wrote:
> Hi, for Loongson3 errata, we need another sycn for cmpxchg
> 
>   @@ -414,12 +415,13 @@ static void emit_cmpxchg_r64(struct jit_context *ctx, u8 dst, u8 src, s16 off)
>    	u8 t1 = MIPS_R_T6;
>    	u8 t2 = MIPS_R_T7;
>    
>   +	LLSC_sync(ctx);
>    	emit(ctx, lld, t1, off, dst);
>    	emit(ctx, bne, t1, r0, 12);
>    	emit(ctx, move, t2, src);      /* Delay slot */
>    	emit(ctx, scd, t2, off, dst);
>   -	emit(ctx, beqz, t2, -20);
>   -	emit(ctx, move, r0, t1);      /* Delay slot */
>   +	emit(ctx, LLSC_beqz, t2, -20 - LLSC_offset);
>   +	emit(ctx, move, r0, t1);       /* Delay slot */
>   +	LLSC_sync(ctx);	

Please craft an official fix for bpf tree and have Johan Almbladh in Cc
for review / ack.

(Please also make sure that this passes the lib/test_bpf.ko suite.)

Thanks a lot,
Daniel

> On Tue, Oct 05, 2021 at 06:54:06PM +0200, Johan Almbladh wrote:
>> This patch adds workarounds for the following CPU errata to the MIPS
>> eBPF JIT, if enabled in the kernel configuration.
>>
>>    - R10000 ll/sc weak ordering
>>    - Loongson-3 ll/sc weak ordering
>>    - Loongson-2F jump hang
>>
>> The Loongson-2F nop errata is implemented in uasm, which the JIT uses,
>> so no additional mitigations are needed for that.
>>
>> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
>> ---
>>   arch/mips/net/bpf_jit_comp.c   |  6 ++++--
>>   arch/mips/net/bpf_jit_comp.h   | 26 +++++++++++++++++++++++++-
>>   arch/mips/net/bpf_jit_comp64.c | 10 ++++++----
>>   3 files changed, 35 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/mips/net/bpf_jit_comp.c b/arch/mips/net/bpf_jit_comp.c
>> index 7eb95fc57710..b17130d510d4 100644
>> --- a/arch/mips/net/bpf_jit_comp.c
>> +++ b/arch/mips/net/bpf_jit_comp.c
>> @@ -404,6 +404,7 @@ void emit_alu_r(struct jit_context *ctx, u8 dst, u8 src, u8 op)
>>   /* Atomic read-modify-write (32-bit) */
>>   void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
>>   {
>> +	LLSC_sync(ctx);
>>   	emit(ctx, ll, MIPS_R_T9, off, dst);
>>   	switch (code) {
>>   	case BPF_ADD:
>> @@ -427,7 +428,7 @@ void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
>>   		break;
>>   	}
>>   	emit(ctx, sc, MIPS_R_T8, off, dst);
>> -	emit(ctx, beqz, MIPS_R_T8, -16);
>> +	emit(ctx, LLSC_beqz, MIPS_R_T8, -16 - LLSC_offset);
>>   	emit(ctx, nop); /* Delay slot */
>>   
>>   	if (code & BPF_FETCH) {
>> @@ -439,11 +440,12 @@ void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
>>   /* Atomic compare-and-exchange (32-bit) */
>>   void emit_cmpxchg_r(struct jit_context *ctx, u8 dst, u8 src, u8 res, s16 off)
>>   {
>> +	LLSC_sync(ctx);
>>   	emit(ctx, ll, MIPS_R_T9, off, dst);
>>   	emit(ctx, bne, MIPS_R_T9, res, 12);
>>   	emit(ctx, move, MIPS_R_T8, src);     /* Delay slot */
>>   	emit(ctx, sc, MIPS_R_T8, off, dst);
>> -	emit(ctx, beqz, MIPS_R_T8, -20);
>> +	emit(ctx, LLSC_beqz, MIPS_R_T8, -20 - LLSC_offset);
>>   	emit(ctx, move, res, MIPS_R_T9);     /* Delay slot */
>>   	clobber_reg(ctx, res);
>>   }
>> diff --git a/arch/mips/net/bpf_jit_comp.h b/arch/mips/net/bpf_jit_comp.h
>> index 44787cf377dd..6f3a7b07294b 100644
>> --- a/arch/mips/net/bpf_jit_comp.h
>> +++ b/arch/mips/net/bpf_jit_comp.h
>> @@ -87,7 +87,7 @@ struct jit_context {
>>   };
>>   
>>   /* Emit the instruction if the JIT memory space has been allocated */
>> -#define emit(ctx, func, ...)					\
>> +#define __emit(ctx, func, ...)					\
>>   do {								\
>>   	if ((ctx)->target != NULL) {				\
>>   		u32 *p = &(ctx)->target[ctx->jit_index];	\
>> @@ -95,6 +95,30 @@ do {								\
>>   	}							\
>>   	(ctx)->jit_index++;					\
>>   } while (0)
>> +#define emit(...) __emit(__VA_ARGS__)
>> +
>> +/* Workaround for R10000 ll/sc errata */
>> +#ifdef CONFIG_WAR_R10000
>> +#define LLSC_beqz	beqzl
>> +#else
>> +#define LLSC_beqz	beqz
>> +#endif
>> +
>> +/* Workaround for Loongson-3 ll/sc errata */
>> +#ifdef CONFIG_CPU_LOONGSON3_WORKAROUNDS
>> +#define LLSC_sync(ctx)	emit(ctx, sync, 0)
>> +#define LLSC_offset	4
>> +#else
>> +#define LLSC_sync(ctx)
>> +#define LLSC_offset	0
>> +#endif
>> +
>> +/* Workaround for Loongson-2F jump errata */
>> +#ifdef CONFIG_CPU_JUMP_WORKAROUNDS
>> +#define JALR_MASK	0xffffffffcfffffffULL
>> +#else
>> +#define JALR_MASK	(~0ULL)
>> +#endif
>>   
>>   /*
>>    * Mark a BPF register as accessed, it needs to be
>> diff --git a/arch/mips/net/bpf_jit_comp64.c b/arch/mips/net/bpf_jit_comp64.c
>> index ca49d3ef7ff4..1f1f7b87f213 100644
>> --- a/arch/mips/net/bpf_jit_comp64.c
>> +++ b/arch/mips/net/bpf_jit_comp64.c
>> @@ -375,6 +375,7 @@ static void emit_atomic_r64(struct jit_context *ctx,
>>   	u8 t1 = MIPS_R_T6;
>>   	u8 t2 = MIPS_R_T7;
>>   
>> +	LLSC_sync(ctx);
>>   	emit(ctx, lld, t1, off, dst);
>>   	switch (code) {
>>   	case BPF_ADD:
>> @@ -398,7 +399,7 @@ static void emit_atomic_r64(struct jit_context *ctx,
>>   		break;
>>   	}
>>   	emit(ctx, scd, t2, off, dst);
>> -	emit(ctx, beqz, t2, -16);
>> +	emit(ctx, LLSC_beqz, t2, -16 - LLSC_offset);
>>   	emit(ctx, nop); /* Delay slot */
>>   
>>   	if (code & BPF_FETCH) {
>> @@ -414,12 +415,13 @@ static void emit_cmpxchg_r64(struct jit_context *ctx, u8 dst, u8 src, s16 off)
>>   	u8 t1 = MIPS_R_T6;
>>   	u8 t2 = MIPS_R_T7;
>>   
>> +	LLSC_sync(ctx);
>>   	emit(ctx, lld, t1, off, dst);
>>   	emit(ctx, bne, t1, r0, 12);
>>   	emit(ctx, move, t2, src);      /* Delay slot */
>>   	emit(ctx, scd, t2, off, dst);
>> -	emit(ctx, beqz, t2, -20);
>> -	emit(ctx, move, r0, t1);      /* Delay slot */
>> +	emit(ctx, LLSC_beqz, t2, -20 - LLSC_offset);
>> +	emit(ctx, move, r0, t1);       /* Delay slot */
>>   
>>   	clobber_reg(ctx, r0);
>>   }
>> @@ -443,7 +445,7 @@ static int emit_call(struct jit_context *ctx, const struct bpf_insn *insn)
>>   	push_regs(ctx, ctx->clobbered & JIT_CALLER_REGS, 0, 0);
>>   
>>   	/* Emit function call */
>> -	emit_mov_i64(ctx, tmp, addr);
>> +	emit_mov_i64(ctx, tmp, addr & JALR_MASK);
>>   	emit(ctx, jalr, MIPS_R_RA, tmp);
>>   	emit(ctx, nop); /* Delay slot */
>>   
>> -- 
>> 2.30.2
>>
> 

