Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691E529CBEF
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506352AbgJ0WXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505747AbgJ0WXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 18:23:54 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48278221FB;
        Tue, 27 Oct 2020 22:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603837433;
        bh=Cc+90dgAQa5qCqT7yhr5+fNXcD/lqcWVm7Ov6RIsF+E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vp30La2lUQBdT+96S72S0Dz1GBdL4xWzRgVCDUUYiqM/K1v5/g9Nnn/y8+SrzYwQg
         h75xpYI33IvDxYnn9rJtAMoYxl0HX+x4vO0D92tKl80Ffkjq93h0t7Dd8Cud+CGbTQ
         66CRxjf9li3sgA29EGFpvFJiJpiA8eroc6IiQMh8=
Received: by mail-ot1-f42.google.com with SMTP id n15so2568853otl.8;
        Tue, 27 Oct 2020 15:23:53 -0700 (PDT)
X-Gm-Message-State: AOAM53155J3qiMXis/tlwYxqv5IK0Ms8lOLFqVgF6GiTbVIYG4U6HHAH
        4nT3qBkHtkGOXsKRxbeqFsrImCdUrYlRw0TLWww=
X-Google-Smtp-Source: ABdhPJziJpHQvbpPWWIsVOva0M9OAmaLmP58/5ARQiTSJz3RHLSs0wa1cHQ4AJnrxEt8YQdaEuEp0Vm2ExMSe83AUT8=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr2946472ots.90.1603837432594;
 Tue, 27 Oct 2020 15:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <CAKwvOdmSaVcgq2eKRjRL+_StdFNG2QnNe3nGCs2PWfH=HceadA@mail.gmail.com>
 <CAMj1kXHb8Fe9fqpj4-90ccEMB+NJ6cbuuog-2Vuo7tr7VjZaTA@mail.gmail.com> <CAKwvOdnfkZXJdZkKO6qT53j6nH4HF=CcpUZcr7XOqdnQLSShmw@mail.gmail.com>
In-Reply-To: <CAKwvOdnfkZXJdZkKO6qT53j6nH4HF=CcpUZcr7XOqdnQLSShmw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 27 Oct 2020 23:23:41 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGFWr5FSiO79VYEYhB2eCpDP5vyTJmdskxrKWnUz-GP-w@mail.gmail.com>
Message-ID: <CAMj1kXGFWr5FSiO79VYEYhB2eCpDP5vyTJmdskxrKWnUz-GP-w@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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

On Tue, 27 Oct 2020 at 23:03, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Oct 27, 2020 at 2:50 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Tue, 27 Oct 2020 at 22:20, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > On Tue, Oct 27, 2020 at 1:57 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> > > > index 6e390d58a9f8..ac3fa37a84f9 100644
> > > > --- a/include/linux/compiler_types.h
> > > > +++ b/include/linux/compiler_types.h
> > > > @@ -247,10 +247,6 @@ struct ftrace_likely_data {
> > > >  #define asm_inline asm
> > > >  #endif
> > > >
> > > > -#ifndef __no_fgcse
> > > > -# define __no_fgcse
> > > > -#endif
> > > > -
> > > Finally, this is going to disable GCSE for the whole translation unit,
> > > which may be overkill.   Previously it was isolated to one function
> > > definition.  You could lower the definition of the preprocessor define
> > > into kernel/bpf/core.c to keep its use isolated as far as possible.
> > >
> >
> > Which preprocessor define?
>
> __no_fgcse
>

But we can't use that, that is the whole point of this patch.
