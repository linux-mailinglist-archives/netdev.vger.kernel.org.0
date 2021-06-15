Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760A53A8B3B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFOVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFOVkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 17:40:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979D761159;
        Tue, 15 Jun 2021 21:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623793097;
        bh=WsnjQxBiIqhUROeHutNepvY82vWn5+Gb/nJxmlw1okQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G54nkd1ForQLhHRyA3xmzkzQ/I3ZTEMbs3gzY14C/QuPikahuDvGy05v8VOm+cB1I
         He+r68OrgXgLYhrWZW2vUwDM+Y/ekqLde5qIQapr/6aaO0clZO2XH1oG8oXy6FMYjG
         lT5HLVEuN80FuhPXro1El3ACmr1wW8RDfIfdoRmaHh5SPkrUfihxd19JzI4zblWXSE
         iESMg0YLder2JKhvedkWNuJjwJKP2Nnn2C1lVI0NNhqcCfker106IdMF5UkzrvD/OV
         hQaXqLv55Cp4pstc0+buH8K/s0gez6civkJZ3nvEVJPgsKAMXIp1fjKYtDCejGdI0p
         Z0OgN5xmj/tkw==
Date:   Tue, 15 Jun 2021 14:38:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        keescook@chromium.org, yhs@fb.com, dvyukov@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        nathan@kernel.org, ndesaulniers@google.com,
        clang-built-linux@googlegroups.com,
        kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <YMkdx1VB0i+fhjAY@gmail.com>
References: <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
 <YMkAbNQiIBbhD7+P@gmail.com>
 <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
 <YMkcYn4dyZBY/ze+@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMkcYn4dyZBY/ze+@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 02:32:18PM -0700, Eric Biggers wrote:
> On Tue, Jun 15, 2021 at 11:08:18PM +0200, Daniel Borkmann wrote:
> > On 6/15/21 9:33 PM, Eric Biggers wrote:
> > > On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
> > > > 
> > > > As I understand it, the UBSAN report is coming from the eBPF interpreter,
> > > >   which is the *slow path* and indeed on many production systems is
> > > >   compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
> > > > Perhaps a better approach to the fix would be to change the interpreter
> > > >   to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
> > > >   bitnesses), thus matching the behaviour of most chips' shift opcodes.
> > > > This would shut up UBSAN, without affecting JIT code generation.
> > > 
> > > Yes, I suggested that last week
> > > (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
> > > get optimized out when compiling for most CPUs.
> > 
> > Did you check if the generated interpreter code for e.g. x86 is the same
> > before/after with that?
> 
> Yes, on x86_64 with gcc 10.2.1, the disassembly of ___bpf_prog_run() is the same
> both before and after (with UBSAN disabled).  Here is the patch I used:
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 5e31ee9f7512..996db8a1bbfb 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1407,12 +1407,30 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>  		DST = (u32) DST OP (u32) IMM;	\
>  		CONT;
>  
> +	/*
> +	 * Explicitly mask the shift amounts with 63 or 31 to avoid undefined
> +	 * behavior.  Normally this won't affect the generated code.
> +	 */
> +#define ALU_SHIFT(OPCODE, OP)		\
> +	ALU64_##OPCODE##_X:		\
> +		DST = DST OP (SRC & 63);\
> +		CONT;			\
> +	ALU_##OPCODE##_X:		\
> +		DST = (u32) DST OP ((u32)SRC & 31);	\
> +		CONT;			\
> +	ALU64_##OPCODE##_K:		\
> +		DST = DST OP (IMM & 63);	\
> +		CONT;			\
> +	ALU_##OPCODE##_K:		\
> +		DST = (u32) DST OP ((u32)IMM & 31);	\
> +		CONT;
> +
>  	ALU(ADD,  +)
>  	ALU(SUB,  -)
>  	ALU(AND,  &)
>  	ALU(OR,   |)
> -	ALU(LSH, <<)
> -	ALU(RSH, >>)
> +	ALU_SHIFT(LSH, <<)
> +	ALU_SHIFT(RSH, >>)
>  	ALU(XOR,  ^)
>  	ALU(MUL,  *)
>  #undef ALU
> 

Note, I missed the arithmetic right shifts later on in the function.  Same
result there, though.

- Eric
