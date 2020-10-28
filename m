Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C857F29DE98
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbgJ2AzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731656AbgJ1WRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:40 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55C932419B;
        Wed, 28 Oct 2020 08:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603872855;
        bh=5M2W9qKNdVjM0IDNo6/PWHZzGWNZtDyaNaB7JyIYiao=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JkmzJJ2RcttbAyJezdHP1sxgAtmUAAt//tXCJv4mUdJkozB6YFX6FEnu2Jf+RjVSX
         bkbFHemMzjlV5hsmGlleg8DnrY6WORAZzSY5JPBPN+HN8L1sDU/mJr7RONFAcIdrDY
         zJJfUNRCol+hSq8XEQyOWh2f1Ob6mIOBO/B70sWo=
Received: by mail-ot1-f50.google.com with SMTP id x7so3514167ota.0;
        Wed, 28 Oct 2020 01:14:15 -0700 (PDT)
X-Gm-Message-State: AOAM53135uYnkqkuK93o2B+L0ROGZlrKKMmGyAzmJZjn/QEY1+fAG2uQ
        95t7zeLy4vuKTtnGnI9URXtmiGX+POsKtqOoA4U=
X-Google-Smtp-Source: ABdhPJzc6wSpTGfdbDkZPz8hiEFajZtDYxAk9lesmBpBxTM6E9TK0L3RyPFU12BqXfHNm+ef8gfkwqIo7hihIjlDAKo=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr4145927ots.90.1603872854413;
 Wed, 28 Oct 2020 01:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
 <CAKwvOdmvyBbqKiR=wFmyiZcXaN1mYHe-VJtqbBS9enhDcUcN=w@mail.gmail.com> <20201028081123.GT2628@hirez.programming.kicks-ass.net>
In-Reply-To: <20201028081123.GT2628@hirez.programming.kicks-ass.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 28 Oct 2020 09:14:03 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGpRE5SZYng+eisW+7uTsbyKyy7PwOzCSyNoU0NtA-cGw@mail.gmail.com>
Message-ID: <CAMj1kXGpRE5SZYng+eisW+7uTsbyKyy7PwOzCSyNoU0NtA-cGw@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: Remove broken __no_tail_call attribute
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>,
        =?UTF-8?Q?Martin_Li=C5=A1ka?= <mliska@suse.cz>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 at 09:11, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Oct 27, 2020 at 04:11:27PM -0700, Nick Desaulniers wrote:
> > On Tue, Oct 27, 2020 at 4:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 10/27/20 9:57 PM, Ard Biesheuvel wrote:
> > > > Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
> > > > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > > > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > > > GCC specific optimization that was causing trouble on x86 builds, and
> > > > was not expected to have any positive effect in the first place.
> > > >
> > > > However, as the GCC manual documents, __attribute__((optimize))
> > > > is not for production use, and results in all other optimization
> > > > options to be forgotten for the function in question. This can
> > > > cause all kinds of trouble, but in one particular reported case,
> > >
> > > Looks like there are couple more as well aside from __no_fgcse, are you
> > > also planning to fix them?
> > >
> > >    arch/powerpc/kernel/setup.h:14:#define __nostackprotector __attribute__((__optimize__("no-stack-protector")))
> >
> > GCC literally just landed support for
> > __attribute__((no_stack_protector)) a few days ago.  I was planning on
> > sending a patch adding it to compiler_attributes.h, but we won't be
> > able to rely on it for a while.  Now I see I'll have to clean up ppc a
> > bit. Surely they've had bugs related to optimize attribute
> > unexpectedly dropping flags.
> >
> > >    tools/include/linux/compiler-gcc.h:37:#define __no_tail_call __attribute__((optimize("no-optimize-sibling-calls")))
> >
> > Only used in perf?
> > tools/perf/tests/dwarf-unwind.c
>
> Right, that should probably be fixed. It also probably doesn't matter
> too much since its an unwinder tests, but still, having that attribute
> is dangerous.
>
> The only cross-compiler way of doing this is like in commit
> a9a3ed1eff360.
>
> ---
> Subject: tools/perf: Remove broken __no_tail_call attribute
>
> The GCC specific __attribute__((optimize)) attribute does not what is
> commonly expected and is explicitly recommended against using in
> production code by the GCC people.
>
> Unlike what is often expected, it doesn't add to the optimization flags,
> but it fully replaces them, loosing any and all optimization flags
> provided by the compiler commandline.
>
> The only guaranteed upon means of inhibiting tail-calls is by placing a
> volatile asm with side-effects after the call such that the tail-call
> simply cannot be done.
>
> Given the original commit wasn't specific on which calls were the
> problem, this removal might re-introduce the problem, which can then be
> re-analyzed and cured properly.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  tools/include/linux/compiler-gcc.h | 12 ------------
>  tools/include/linux/compiler.h     |  3 ---
>  tools/perf/tests/dwarf-unwind.c    | 10 +++++-----
>  3 files changed, 5 insertions(+), 20 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/tools/include/linux/compiler-gcc.h b/tools/include/linux/compiler-gcc.h
> index b9d4322e1e65..95c072b70d0e 100644
> --- a/tools/include/linux/compiler-gcc.h
> +++ b/tools/include/linux/compiler-gcc.h
> @@ -27,18 +27,6 @@
>  #define  __pure                __attribute__((pure))
>  #endif
>  #define  noinline      __attribute__((noinline))
> -#ifdef __has_attribute
> -#if __has_attribute(disable_tail_calls)
> -#define __no_tail_call __attribute__((disable_tail_calls))
> -#endif
> -#endif
> -#ifndef __no_tail_call
> -#if GCC_VERSION > 40201
> -#define __no_tail_call __attribute__((optimize("no-optimize-sibling-calls")))
> -#else
> -#define __no_tail_call
> -#endif
> -#endif
>  #ifndef __packed
>  #define __packed       __attribute__((packed))
>  #endif
> diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
> index 2b3f7353e891..d22a974372c0 100644
> --- a/tools/include/linux/compiler.h
> +++ b/tools/include/linux/compiler.h
> @@ -47,9 +47,6 @@
>  #ifndef noinline
>  #define noinline
>  #endif
> -#ifndef __no_tail_call
> -#define __no_tail_call
> -#endif
>
>  /* Are two types/vars the same type (ignoring qualifiers)? */
>  #ifndef __same_type
> diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
> index 2491d167bf76..83638097c3bc 100644
> --- a/tools/perf/tests/dwarf-unwind.c
> +++ b/tools/perf/tests/dwarf-unwind.c
> @@ -95,7 +95,7 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
>         return strcmp((const char *) symbol, funcs[idx]);
>  }
>
> -__no_tail_call noinline int test_dwarf_unwind__thread(struct thread *thread)
> +noinline int test_dwarf_unwind__thread(struct thread *thread)
>  {
>         struct perf_sample sample;
>         unsigned long cnt = 0;
> @@ -126,7 +126,7 @@ __no_tail_call noinline int test_dwarf_unwind__thread(struct thread *thread)
>
>  static int global_unwind_retval = -INT_MAX;
>
> -__no_tail_call noinline int test_dwarf_unwind__compare(void *p1, void *p2)
> +noinline int test_dwarf_unwind__compare(void *p1, void *p2)
>  {
>         /* Any possible value should be 'thread' */
>         struct thread *thread = *(struct thread **)p1;
> @@ -145,7 +145,7 @@ __no_tail_call noinline int test_dwarf_unwind__compare(void *p1, void *p2)
>         return p1 - p2;
>  }
>
> -__no_tail_call noinline int test_dwarf_unwind__krava_3(struct thread *thread)
> +noinline int test_dwarf_unwind__krava_3(struct thread *thread)
>  {
>         struct thread *array[2] = {thread, thread};
>         void *fp = &bsearch;
> @@ -164,12 +164,12 @@ __no_tail_call noinline int test_dwarf_unwind__krava_3(struct thread *thread)
>         return global_unwind_retval;
>  }
>
> -__no_tail_call noinline int test_dwarf_unwind__krava_2(struct thread *thread)
> +noinline int test_dwarf_unwind__krava_2(struct thread *thread)
>  {
>         return test_dwarf_unwind__krava_3(thread);
>  }
>
> -__no_tail_call noinline int test_dwarf_unwind__krava_1(struct thread *thread)
> +noinline int test_dwarf_unwind__krava_1(struct thread *thread)
>  {
>         return test_dwarf_unwind__krava_2(thread);
>  }
