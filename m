Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091BB29FF17
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 08:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgJ3Hvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 03:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3Hvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 03:51:40 -0400
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7040622245;
        Fri, 30 Oct 2020 07:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604044299;
        bh=D/aIIrSzt2ELKTXPH9by2IoB0Bg74n2JeiRz65oPpmc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HFNHX7Ptz1xj5maXrLWDNsKFrMC3B1a4MEBGmeab0Kn0qIcOk7y9ZIyyrDFHW+9jB
         TBVv02b9NS83EknczYO4Nv9Z311VfE5GwmvONSVtWjP5UeQzZ6cyHFREAT3o94Rl7q
         eLcoSDaHIBrVwlhmdaEoVpsJHgV9JZ3vdsZ9+5Bg=
Received: by mail-oo1-f54.google.com with SMTP id v123so1384317ooa.5;
        Fri, 30 Oct 2020 00:51:39 -0700 (PDT)
X-Gm-Message-State: AOAM533qSZqnKHQDo4ZMVLWFHRTEb7rkIEe/QY3p08Sc99feXkjJhDM9
        2KYdo7YumGy9tGO0cSvFAcwP6R53Bq8kWjMDdoc=
X-Google-Smtp-Source: ABdhPJyCH6aeDgANE72vDMvakcnLN2mSF/m847ZvdLdUdjshm/qtRYpKbnaorpXUYQu+qx20bd/1uWLRsLfhe1fwG7o=
X-Received: by 2002:a4a:9806:: with SMTP id y6mr807310ooi.45.1604044298526;
 Fri, 30 Oct 2020 00:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201028171506.15682-1-ardb@kernel.org> <20201028171506.15682-2-ardb@kernel.org>
 <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com>
 <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
 <20201028232001.pp7erdwft7oyt2xm@ast-mbp.dhcp.thefacebook.com>
 <CAKwvOd=Zrza=i54_=H3n2HkmMhg9EJ3Wy0kR5AXTSqBowsQV5g@mail.gmail.com> <20201030032247.twch6rvnk6ql3zjb@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201030032247.twch6rvnk6ql3zjb@ast-mbp.dhcp.thefacebook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Oct 2020 08:51:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGzrTU7-x1vcNotxy-W=buSk=3OUX=WNvwZy59SGTRAxA@mail.gmail.com>
Message-ID: <CAMj1kXGzrTU7-x1vcNotxy-W=buSk=3OUX=WNvwZy59SGTRAxA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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

On Fri, 30 Oct 2020 at 04:22, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 05:28:11PM -0700, Nick Desaulniers wrote:
> >
> > We already know that -fno-asynchronous-unwind-tables get dropped,
> > hence this patch.
>
> On arm64 only. Not on x86
>
> > And we know -fomit-frame-pointer or
> > -fno-omit-frame-pointer I guess gets dropped, hence your ask.
>
> yep. that one is bugged.
>
> > We might not know the full extent which other flags get dropped with the
> > optimize attribute, but I'd argue that my list above can all result in
> > pretty bad bugs when accidentally omitted (ok, maybe not -fshort-wchar
> > or -fmacro-prefix-map, idk what those do) or when mixed with code that
>
> true.
> Few month back I've checked that strict-aliasing and no-common flags
> from your list are not dropped by this attr in gcc [6789].
> I've also checked that no-red-zone and model=kernel preserved as well.
>
> > has different values those flags control.  Searching GCC's bug tracker
> > for `__attribute__((optimize` turns up plenty of reports to make me
> > think this attribute maybe doesn't work the way folks suspect or
> > intend: https://gcc.gnu.org/bugzilla/buglist.cgi?quicksearch=__attribute__%28%28optimize&list_id=283390.
>
> There is a risk.
> Is it a footgun? Sure.
> Yet. gcc testsuite is using __attribute__((optimize)).
> And some of these tests were added _after_ offical gcc doc said that this
> attribute is broken.
> imo it's like 'beware of the dog' sign.
>
> > There's plenty of folks arguing against the use of the optimize
> > attribute in favor of the command line flag.  I urge you to please
> > reconsider the request.
>
> ok. Applied this first patch to bpf tree and will get it to Linus soon.
> Second patch that is splitting interpreter out because of this mess
> is dropped. The effect of gcse on performance is questionable.
> iirc some interpreters used to do -fno-gcse to gain performance.

That is absolutely fine. I only included the second patch to address
Daniel's concern that -fno-gcse could affect unrelated code living in
the same source file as __bpf_prog_run(), but if you don't care about
that, nor will I.
