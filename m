Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553C429CBB5
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832148AbgJ0WDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:03:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39442 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832059AbgJ0WDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:03:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id e15so1717267pfh.6
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 15:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIgA23QX48XZ046Ge9ljl2tKSIQwwh1UxXCcpF43RtQ=;
        b=DQ4QYs8mm70+rmT6lRf4l6/moOr/APcehE0qI2sTetrRpD0rKQcuE06shQpHs4ISpv
         +xskUF2josJN6OZ7d1A7Szw1vnt+kuUpFQR9AMXT1EDP+t9+TC0zAGPXYCQYI2F+v573
         ncdjsWm5Lk/qtYVSspLjcRFflT9AVKO93yQwXSpZpqGOZKI8TOiMPnggSNISM68S9udt
         G/QCm6BtoytS6FFs4Cib7tax4L4ONjrZI1HVW00ZAS1uygE38BcNPpv+dzMtTzFMC0ss
         +BqJM6oJmL3i3yTBUH/czr/Y7LWL8D5KjZVFlF+xNlOG+YauJn6iVtG0d7sgAr1HwTVy
         UYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIgA23QX48XZ046Ge9ljl2tKSIQwwh1UxXCcpF43RtQ=;
        b=Ds0YLmnL9Jzom7WEdAoKJaTQsarPeTzEyX+7aH1MKcBT7t96U+SZiBBXPpdjpFMIYI
         XzGf+ZruUmoB/RayFxrJngo/KOdgZnGaU18HNCpRkPjySzc6zvl48o6/k8Ch6H9Y3989
         l8s5KOxXRPh2uussWxywylMUMY5kaBkjLiC59zyosGe5dZ5NJP71MNPBDpm8AN532b2i
         uY8J6ZffJCHM21jTQfIBGi17717ElCY/H0mWfiMe11a/2MeH7R75VE330H16vyhVs67a
         pMn/EjbuCFbxAu0Yz0AvYOxbhJS1zOySywcycI6PQ7gOlEIrPdjvkL9KLEC9EWTQbxg+
         +n2Q==
X-Gm-Message-State: AOAM531Ij0uLKWgOLMBpD6DmkoM5vVu3boulCFiRYigaYurdOl9V6vIe
        iArsVYG+MwEsPUM/sCJksAtSg1AY5nwg4MwVyod2Ag==
X-Google-Smtp-Source: ABdhPJx8L1OiCbNFAi5Sliu7v9cXX6Ed/uwWX333oVtC4BVqOz5Cs6zhmcXllfQaAoaMy9QHY2yTF0fhz6TiuhuH5rw=
X-Received: by 2002:a62:ce41:0:b029:160:c0c:e03d with SMTP id
 y62-20020a62ce410000b02901600c0ce03dmr4426890pfg.15.1603836222920; Tue, 27
 Oct 2020 15:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <CAKwvOdmSaVcgq2eKRjRL+_StdFNG2QnNe3nGCs2PWfH=HceadA@mail.gmail.com>
 <CAMj1kXHb8Fe9fqpj4-90ccEMB+NJ6cbuuog-2Vuo7tr7VjZaTA@mail.gmail.com>
In-Reply-To: <CAMj1kXHb8Fe9fqpj4-90ccEMB+NJ6cbuuog-2Vuo7tr7VjZaTA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 27 Oct 2020 15:03:31 -0700
Message-ID: <CAKwvOdnfkZXJdZkKO6qT53j6nH4HF=CcpUZcr7XOqdnQLSShmw@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
To:     Ard Biesheuvel <ardb@kernel.org>
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

On Tue, Oct 27, 2020 at 2:50 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 27 Oct 2020 at 22:20, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Tue, Oct 27, 2020 at 1:57 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> > > index 6e390d58a9f8..ac3fa37a84f9 100644
> > > --- a/include/linux/compiler_types.h
> > > +++ b/include/linux/compiler_types.h
> > > @@ -247,10 +247,6 @@ struct ftrace_likely_data {
> > >  #define asm_inline asm
> > >  #endif
> > >
> > > -#ifndef __no_fgcse
> > > -# define __no_fgcse
> > > -#endif
> > > -
> > Finally, this is going to disable GCSE for the whole translation unit,
> > which may be overkill.   Previously it was isolated to one function
> > definition.  You could lower the definition of the preprocessor define
> > into kernel/bpf/core.c to keep its use isolated as far as possible.
> >
>
> Which preprocessor define?

__no_fgcse

>
> > I'm fine with either approach, but we should avoid new warnings for
> > clang.  Thanks for the patch!

-- 
Thanks,
~Nick Desaulniers
