Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4244329DA87
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbgJ1XYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgJ1XLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:11:05 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F1F020790;
        Wed, 28 Oct 2020 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603926664;
        bh=HIIG0lPxqF7DonwHh336RcBqXuSM/AWZr5Tt//apNiA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qVoofgNk5Belh9Elgc53iNh5kG9OQnRkUUTqEXkIRoln57oky/CShOJSJuVUrNlJb
         fINLgGwM/qg6qUnkK9cxX3JT+Fhfx3XKal1vglkIrVakyPy83bscpoJLhUHjf3bFNF
         Rf5866qjwSSIjgWCK5P4oN2Z94HlYa+FI0K3tavI=
Received: by mail-oi1-f182.google.com with SMTP id y186so1356291oia.3;
        Wed, 28 Oct 2020 16:11:04 -0700 (PDT)
X-Gm-Message-State: AOAM533VId1svEBqbDmyJ/F2aztwpwgqHHYxCf0GaWxz+SLSPF/4/t/n
        qipkxpA9Zn+j/ynMFAgO/DjMeasYV2cvo6vf7OU=
X-Google-Smtp-Source: ABdhPJy9zA4pQrccnT0p7DWN1xD057PNvpnSnzUrxVpAqmiDcix7Nd0dyZM3HCv4XsbNNmdlJCUkg1JV8NY2sJSrnq4=
X-Received: by 2002:aca:d64f:: with SMTP id n76mr1006347oig.174.1603926663755;
 Wed, 28 Oct 2020 16:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201028171506.15682-1-ardb@kernel.org> <20201028171506.15682-2-ardb@kernel.org>
 <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com> <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 29 Oct 2020 00:10:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
Message-ID: <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 at 23:59, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 28, 2020 at 11:15:04PM +0100, Ard Biesheuvel wrote:
> > On Wed, 28 Oct 2020 at 22:39, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Oct 28, 2020 at 06:15:05PM +0100, Ard Biesheuvel wrote:
> > > > Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
> > > > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > > > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > > > GCC specific optimization that was causing trouble on x86 builds, and
> > > > was not expected to have any positive effect in the first place.
> > > >
> > > > However, as the GCC manual documents, __attribute__((optimize))
> > > > is not for production use, and results in all other optimization
> > > > options to be forgotten for the function in question. This can
> > > > cause all kinds of trouble, but in one particular reported case,
> > > > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > > > resulting in .eh_frame info to be emitted for the function.
> > > >
> > > > This reverts commit 3193c0836, and instead, it disables the -fgcse
> > > > optimization for the entire source file, but only when building for
> > > > X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
> > > > original commit states that CONFIG_RETPOLINE=n triggers the issue,
> > > > whereas CONFIG_RETPOLINE=y performs better without the optimization,
> > > > so it is kept disabled in both cases.
> > > >
> > > > Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > > Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > ---
> > > >  include/linux/compiler-gcc.h   | 2 --
> > > >  include/linux/compiler_types.h | 4 ----
> > > >  kernel/bpf/Makefile            | 6 +++++-
> > > >  kernel/bpf/core.c              | 2 +-
> > > >  4 files changed, 6 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > > > index d1e3c6896b71..5deb37024574 100644
> > > > --- a/include/linux/compiler-gcc.h
> > > > +++ b/include/linux/compiler-gcc.h
> > > > @@ -175,5 +175,3 @@
> > > >  #else
> > > >  #define __diag_GCC_8(s)
> > > >  #endif
> > > > -
> > > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > >
> > > See my reply in the other thread.
> > > I prefer
> > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > >
> > > Potentially with -fno-asynchronous-unwind-tables.
> > >
> >
> > So how would that work? arm64 has the following:
> >
> > KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
> >
> > ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
> > KBUILD_CFLAGS += -ffixed-x18
> > endif
> >
> > and it adds -fpatchable-function-entry=2 for compilers that support
> > it, but only when CONFIG_FTRACE is enabled.
>
> I think you're assuming that GCC drops all flags when it sees __attribute__((optimize)).
> That's not the case.
>

So which flags does it drop, and which doesn't it drop? Is that
documented somewhere? Is that the same for all versions of GCC?

> > Also, as Nick pointed out, -fno-gcse does not work on Clang.
>
> yes and what's the point?
> #define __no_fgcse is GCC only. clang doesn't need this workaround.
>

Ah ok, that's at least something.

> > Every architecture will have a different set of requirements here. And
> > there is no way of knowing which -f options are disregarded when you
> > use the function attribute.
> >
> > So how on earth are you going to #define __no-fgcse correctly for
> > every configuration imaginable?
> >
> > > __attribute__((optimize("")) is not as broken as you're claiming to be.
> > > It has quirky gcc internal logic, but it's still widely used
> > > in many software projects.
> >
> > So it's fine because it is only a little bit broken? I'm sorry, but
> > that makes no sense whatsoever.
> >
> > If you insist on sticking with this broken construct, can you please
> > make it GCC/x86-only at least?
>
> I'm totally fine with making
> #define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> to be gcc+x86 only.
> I'd like to get rid of it, but objtool is not smart enough to understand
> generated asm without it.

I'll defer to the x86 folks to make the final call here, but I would
be perfectly happy doing

index d1e3c6896b71..68ddb91fbcc6 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -176,4 +176,6 @@
 #define __diag_GCC_8(s)
 #endif

+#ifdef CONFIG_X86
 #define __no_fgcse __attribute__((optimize("-fno-gcse")))
+#endif

and end the conversation here, because I honestly cannot wrap my head
around the fact that you are willing to work around an x86 specific
objtool shortcoming by arbitrarily disabling some GCC optimization for
all architectures, using a construct that may or may not affect other
compiler settings in unpredictable ways, where the compiler is being
used to compile a BPF language runtime for executing BPF programs
inside the kernel.

What on earth could go wrong?
