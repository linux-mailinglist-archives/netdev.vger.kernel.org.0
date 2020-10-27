Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A929CD6B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgJ1BiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40572 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832976AbgJ0XLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 19:11:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id w21so1803838pfc.7
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 16:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/YFOuw4+r4f6LoQTQtzwijEnqUvWGCvGd0kdzc/Qt4=;
        b=vVn/EriwOAYPsaHnKCm3LB/5ii579QAKxkx7Q+PeeyytjWowAIjG69e8NhCxPgJAmI
         A/+H74mENfivjnO3LqVP2PC6ujAW7Gfx9T95GBoRdybAmvepQzCGX/2IeBBVbZNozHyY
         zARwRH1httejP1gxVizMDlr5Irvromf61GvalriDkUhJtO1MKGLzBddMGEOD3hkkqj31
         SU74DlHbvOzxIt1y7QY961xq2MB+fvhz+bxbx7XuSbc73Z93AM1qhtHZaprbG+Wrs22B
         B99rJxgsRrOSpe320Vj67g/b7XfZWUtG9Tp5rx1DKeHcyrWpVsTJCoqH3Y1N+Uz9HgiD
         InyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/YFOuw4+r4f6LoQTQtzwijEnqUvWGCvGd0kdzc/Qt4=;
        b=mZhcBG1u6jGpGakqBXMgTy5d/x4/zF991Imv615yKR5LzaXNomnx6LrI4AfoVFxFk/
         7x5fH0mr6fvs9HNMn9fsuj/6VLcqvjN3gGVM9eO0mxaS06JgRGvAdX3+82WWtZtI/OjS
         uUd7Ox9/vxtZyobO/dr2CQLAtTOXfpxoySxxHJQQM+wqxm3Zl83AYjnOF7CwG8PTKbMH
         ZosrqXOgSokyrzLmCB5UhyJGGJbsZ8Or2zWDED9U8ryNoTK1ckLvMWQLU5GK1x6OlS7U
         kZqltvyaapvQtu31Yiru5Ux3CIJKqeyC8+/0mjz/VR/tHnbMZxYWTuAQTnuWGmeTUuPf
         ijUg==
X-Gm-Message-State: AOAM531PhihXRCZY3QtT5f2+La+O2ynqZFCujD7faX5ttTu4Qd69Bfie
        GNy8UAh31kizwR4bIge01WbZuVG3FhEu2xOae9eR1M1JkTQ8sA==
X-Google-Smtp-Source: ABdhPJymw50PBTyHH1b6wCSguQrkRkG/rqXafHH76UIc7lhKGd651I4gjTg4LLDMjhzClnXnyjFghMNZNTptxyFRejQ=
X-Received: by 2002:a62:2905:0:b029:15b:57ef:3356 with SMTP id
 p5-20020a6229050000b029015b57ef3356mr3674232pfp.36.1603840298504; Tue, 27 Oct
 2020 16:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
In-Reply-To: <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 27 Oct 2020 16:11:27 -0700
Message-ID: <CAKwvOdmvyBbqKiR=wFmyiZcXaN1mYHe-VJtqbBS9enhDcUcN=w@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>,
        =?UTF-8?Q?Martin_Li=C5=A1ka?= <mliska@suse.cz>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 4:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/27/20 9:57 PM, Ard Biesheuvel wrote:
> > Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
> > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > GCC specific optimization that was causing trouble on x86 builds, and
> > was not expected to have any positive effect in the first place.
> >
> > However, as the GCC manual documents, __attribute__((optimize))
> > is not for production use, and results in all other optimization
> > options to be forgotten for the function in question. This can
> > cause all kinds of trouble, but in one particular reported case,
>
> Looks like there are couple more as well aside from __no_fgcse, are you
> also planning to fix them?
>
>    arch/powerpc/kernel/setup.h:14:#define __nostackprotector __attribute__((__optimize__("no-stack-protector")))

GCC literally just landed support for
__attribute__((no_stack_protector)) a few days ago.  I was planning on
sending a patch adding it to compiler_attributes.h, but we won't be
able to rely on it for a while.  Now I see I'll have to clean up ppc a
bit. Surely they've had bugs related to optimize attribute
unexpectedly dropping flags.

>    tools/include/linux/compiler-gcc.h:37:#define __no_tail_call __attribute__((optimize("no-optimize-sibling-calls")))

Only used in perf?
tools/perf/tests/dwarf-unwind.c

>
> > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > resulting in .eh_frame info to be emitted for the function
> > inadvertently.
>
> Would have been useful to add a pointer to the original discussion with
> Link tag.
>
> Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
>
> > This reverts commit 3193c0836f203, and instead, it disables the -fgcse
> > optimization for the entire source file, but only when building for
> > X86.
> >
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Arvind Sankar <nivedita@alum.mit.edu>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Fixes: 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> [...]
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index bdc8cd1b6767..02b58f44c479 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -1,6 +1,8 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   obj-y := core.o
> > -CFLAGS_core.o += $(call cc-disable-warning, override-init)
> > +# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
> > +cflags-core-$(CONFIG_X86) := -fno-gcse
> > +CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-core-y)
>
> Also, this needs to be guarded behind !CONFIG_RETPOLINE and !CONFIG_BPF_JIT_ALWAYS_ON
> in particular the latter since only in this case interpreter is compiled in ... most
> distros have the CONFIG_BPF_JIT_ALWAYS_ON set these days for x86.
>
> Do you have an analysis for the commit log on what else this penalizes in core.c if
> it's now for the entire translation unit?
>
> >   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
> >   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 9268d77898b7..55454d2278b1 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
> >    *
> >    * Decode and execute eBPF instructions.
> >    */
> > -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> >   {
> >   #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> >   #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> >
>


-- 
Thanks,
~Nick Desaulniers
