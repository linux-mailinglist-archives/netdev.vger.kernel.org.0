Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78843FE894
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKOXXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:23:11 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35363 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfKOXXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:23:11 -0500
Received: by mail-qk1-f196.google.com with SMTP id i19so9510993qki.2;
        Fri, 15 Nov 2019 15:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wGFPIMQEUkO/+C9EmOWTVcA4qD5FSm48Riv2fdhacjQ=;
        b=WhouXq5oaqtYCPDm4fxN2R8AwpFGNxaV636Piy0rAT7+M6De6B+eZ8KugdYYDygdWs
         +BI36/nMUCZuBFDw8fm7gUfYXNZOT2dbSxH4Xip0uO1NDx3Osg2ST/rbTCo0xZgJxNCJ
         +K9Kfn3Vshu1i82w991zlCp78mLqS99ZD3ZwLnhR8ljcoRDqm9MFz3hPlHjrbogsbTwp
         HPPbg8kgSiHxoiZIwynwektrFc3YFi5KY4f25iys2llY4C64vPhbzZjMPDSeMhRo6AyV
         W9J8aW19Vsdk49KOWWqELLohsyDVfKZVexQBFD0FkcGcCV6394zN3cU3DswU3JZwJuto
         tJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGFPIMQEUkO/+C9EmOWTVcA4qD5FSm48Riv2fdhacjQ=;
        b=Zi16oM1HQp82DB+krJ/6PIYAP0Gsgaw0xr9Ri54MuRd8wpsX66ZFgRy+RjKjGvjhAF
         lGpXEgL8swCBDA/qlt0aFnFDcXmVzQcItRPfXnuPAgUDcom7gbJ2NLIcZ3g6n4mC8cAf
         BPFJsdwpJ0ntHGB4+XwZohLVauwHLI4iJCwGFP1bnzoSVtfAjeecyq4QiNE+UPuFgNuI
         GxWGKDd21U3SGGVMeW3pJA744sPHlofDqc++sjZYP+w91Niqj0plo9kNSXWRv8iioGrB
         8yV6458d8ZaWZUUaX1IURFIkTvau4n9pCFYr8ApkRSn9StLZyCRU9TCycx9rx/GNL81F
         B/0Q==
X-Gm-Message-State: APjAAAWbIkaSc/6TdtHkWOC3PBUe4D2MmJKaESh2jIjI4tba4VkMCObl
        WITX8UTU1fDsAr2Xmax07h5rNbWb3WyUdajiVhnLrQ==
X-Google-Smtp-Source: APXvYqz1Jb23dkNgG3Ivn+RVufWRWR0fnQTi/K4weS+0IFsTryLBBQBWBpw4K+xreO7ppsCM9keQEhfhtbw3Cqaanes=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr15084382qkj.39.1573860190106;
 Fri, 15 Nov 2019 15:23:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <d2364bbaca1569b04e2434d8b58a458f21c685ef.1573779287.git.daniel@iogearbox.net>
In-Reply-To: <d2364bbaca1569b04e2434d8b58a458f21c685ef.1573779287.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Nov 2019 15:22:59 -0800
Message-ID: <CAEf4BzZau9d-feGEsOu617b7cd2aSfmmSi2TgwZbf4XZGBHASg@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 1/8] bpf, x86: generalize and extend
 bpf_arch_text_poke for direct jumps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add BPF_MOD_{NOP_TO_JUMP,JUMP_TO_JUMP,JUMP_TO_NOP} patching for x86
> JIT in order to be able to patch direct jumps or nop them out. We need
> this facility in order to patch tail call jumps and in later work also
> BPF static keys.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

just naming nits, looks good otherwise


>  arch/x86/net/bpf_jit_comp.c | 64 ++++++++++++++++++++++++++-----------
>  include/linux/bpf.h         |  6 ++++
>  2 files changed, 52 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 2e586f579945..66921f2aeece 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -203,8 +203,9 @@ struct jit_context {
>  /* Maximum number of bytes emitted while JITing one eBPF insn */
>  #define BPF_MAX_INSN_SIZE      128
>  #define BPF_INSN_SAFETY                64
> -/* number of bytes emit_call() needs to generate call instruction */
> -#define X86_CALL_SIZE          5
> +
> +/* Number of bytes emit_patchable() needs to generate instructions */
> +#define X86_PATCHABLE_SIZE     5
>
>  #define PROLOGUE_SIZE          25
>
> @@ -215,7 +216,7 @@ struct jit_context {
>  static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
>  {
>         u8 *prog = *pprog;
> -       int cnt = X86_CALL_SIZE;
> +       int cnt = X86_PATCHABLE_SIZE;
>
>         /* BPF trampoline can be made to work without these nops,
>          * but let's waste 5 bytes for now and optimize later
> @@ -480,64 +481,91 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
>         *pprog = prog;
>  }
>
> -static int emit_call(u8 **pprog, void *func, void *ip)
> +static int emit_patchable(u8 **pprog, void *func, void *ip, u8 b1)

I'd strongly prefer opcode instead of b1 :) also would emit_patch() be
a terrible name?

>  {
>         u8 *prog = *pprog;
>         int cnt = 0;
>         s64 offset;
>

[...]

>         case BPF_MOD_CALL_TO_NOP:
> -               if (memcmp(ip, old_insn, X86_CALL_SIZE))
> +       case BPF_MOD_JUMP_TO_NOP:
> +               if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
>                         goto out;
> -               text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE, NULL);
> +               text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE,


maybe keep it shorter with X86_PATCH_SIZE?

> +                            NULL);
>                 break;
>         }
>         ret = 0;

[...]
