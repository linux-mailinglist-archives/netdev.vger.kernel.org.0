Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48FB29F78F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgJ2WNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgJ2WNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:13:17 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CFC521534;
        Thu, 29 Oct 2020 22:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604009596;
        bh=6G0KYvEIe0We8NX5HSEENfq+P+g0aXPqwOaw5vT8pHU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t9s2F4T1BSutTSAYQzkKV9Vwzcfoj1IZCcvn6qLY+IE0toQSmiRzknnoOoZJq6OAX
         O6GW5hYvnaJUWLZeshE3vvF5kX80yJDcPHTp3QBZ2QK6IPjBDWoTR8Hw+gn1mhS4K0
         0aLWnqu+HPTdsm3sh/b27IUFocXEI8+jrdfoKUMU=
Received: by mail-oi1-f173.google.com with SMTP id f7so4684919oib.4;
        Thu, 29 Oct 2020 15:13:16 -0700 (PDT)
X-Gm-Message-State: AOAM531h1wDfksxWMhD1RgyEOOc3toMDldpAAGH2j60G8DBC1nfnFHMM
        3KG+GWrDrhQNgRIePGJB72jzGa8xpEucHMybW6c=
X-Google-Smtp-Source: ABdhPJyCaru79zu3HxLlCyL7++Unf5ik6G+WcAV4bSZkMJOFXhdSAOc40vpKleOl7hnH1hBldv/dlbFhkw/866xLEgY=
X-Received: by 2002:aca:2310:: with SMTP id e16mr940329oie.47.1604009595232;
 Thu, 29 Oct 2020 15:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201028171506.15682-1-ardb@kernel.org> <20201028171506.15682-2-ardb@kernel.org>
 <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com>
 <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
 <20201028232001.pp7erdwft7oyt2xm@ast-mbp.dhcp.thefacebook.com>
 <20201029025745.GA2386070@rani.riverdale.lan> <20201029203113.GJ2672@gate.crashing.org>
In-Reply-To: <20201029203113.GJ2672@gate.crashing.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 29 Oct 2020 23:13:04 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHxX+u5-cN0v3SLdqZTSiKsWsFOvc2SC5=-ScaUZOu8Ng@mail.gmail.com>
Message-ID: <CAMj1kXHxX+u5-cN0v3SLdqZTSiKsWsFOvc2SC5=-ScaUZOu8Ng@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>,
        linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 at 21:35, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> On Wed, Oct 28, 2020 at 10:57:45PM -0400, Arvind Sankar wrote:
> > On Wed, Oct 28, 2020 at 04:20:01PM -0700, Alexei Starovoitov wrote:
> > > All compilers have bugs. Kernel has bugs. What can go wrong?
>
> Heh.
>
> > +linux-toolchains. GCC updated the documentation in 7.x to discourage
> > people from using the optimize attribute.
> >
> > https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=893100c3fa9b3049ce84dcc0c1a839ddc7a21387
>
> https://patchwork.ozlabs.org/project/gcc/patch/20151213081911.GA320@x4/
> has all the discussion around that GCC patch.
>

For everyone's convenience, let me reproduce here how the GCC
developers describe this attribute on their wiki [0]:

"""
Currently (2015), this attribute is known to have several critical
bugs (PR37565, PR63401, PR60580, PR50782). Using it may produce not
effect at all or lead to wrong-code.

Quoting one GCC maintainer: "I consider the optimize attribute code
seriously broken and unmaintained (but sometimes useful for debugging
- and only that)." source

Unfortunately, the people who added it are either not working on GCC
anymore or not interested in fixing it. Do not try to guess how it is
supposed to work by trial-and-error. There is not a list of options
that are safe to use or known to be broken. Bug reports about the
optimize attribute being broken will probably be closed as WONTFIX
(PR59262), thus it is not worth to open new ones. If it works for you
for a given version of GCC, it doesn't mean it will work on a
different machine or a different version.

The only realistic choices are to not use it, to use it and accept its
brokenness (current or future one, since it is unmaintained), or join
GCC and fix it (perhaps motivating other people along the way to join
your effort).
"""

[0] https://gcc.gnu.org/wiki/FAQ#optimize_attribute_broken
