Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C070CE3
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbfGVW7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 18:59:05 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42362 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbfGVW7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 18:59:05 -0400
Received: by mail-vs1-f66.google.com with SMTP id 190so27538108vsf.9
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 15:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a6gUbUP/R00uoc9Oz2jeql1BpGA/m6qMkrIPJ3QlddQ=;
        b=eDjyv2RY6Bx4fYO+npn5oQzh2ioB1kdfEs/Vgg+MCADFjd7DVetXClfe1YfjcOwMog
         E+L3nvfN9zYRTtr1CiJKRxNrxV8ziXeUzOXNCId2D6ggLKsAyivk7Ojru+RDhqPGbjvh
         tT5F3RjcXTnIxoaor4LJNJ4j4Kzp3ZxBP3vrA+5g6kI8GDfg5ey9XALTNZM40w4U17Sz
         kNKuvAYA1ZznLYUO2LQODUZOTgttZr7BL801Nlel9KEpUqRLemKEVv5e31nJcynHl/ys
         fKUr3KHOx9nRztN90OSTcELT4hLQQeWQxt7/KOw7ujuPb07mFENrFJZ4JChjO0wtcgVe
         1b9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a6gUbUP/R00uoc9Oz2jeql1BpGA/m6qMkrIPJ3QlddQ=;
        b=GHKvqlHdYRpRNwrs/3oiyVE3Ng4wx119zA9Cba4lm0NNozxf5QyxrAT3tqYC44JF01
         JGhkR/9PbZstakWOUALu0N2qkES2WdDjn8tfVf7Lsw/hduFbdnIPqaiQQ3w1nxxWo90Q
         FDWeaxpi+bFj39OWJbCH1UENoY/I6SrMlKdsEzLSss45y53HNh9M1hUNgN+Uh9Rmbtil
         gzd/ywmWGXAywm8SxqhU9fkuNQeZCvN4oy4p4sOOmfh7konldcj56QWlijSewH1vSiz5
         AbZ4QXm75GI8xDm+g3muxq7IlzzHFDqm0aJAYsuP5vaeLu8JTiMfLBxrIP1OMwA20/+Y
         qIfg==
X-Gm-Message-State: APjAAAWeNbA3mKw6F3nzl5vRkF4EBP7Y/zXiwpnOzIS1rChdDnTcp+Ym
        DpmmVaxpcYH5vuahWe9YSMsHLPyYsLd1sR7OSs6lcQ==
X-Google-Smtp-Source: APXvYqwpzobo+k9xTUdhuWur2J3vnVuV41nS4xgFn1mj3wzSYgKZ7x9fW/TARiZSFh2NVZ7R0iZprQhyNfOjwxh8UCU=
X-Received: by 2002:a67:a209:: with SMTP id l9mr49107102vse.125.1563836344002;
 Mon, 22 Jul 2019 15:59:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
 <CAGG=3QUvdwJs1wW1w+5Mord-qFLa=_WkjTsiZuwGfcjkoEJGNQ@mail.gmail.com>
 <75B428FC-734C-4B15-B1A7-A3FC5F9F2FE5@lca.pw> <20190718.162928.124906203979938369.davem@davemloft.net>
 <1563572871.11067.2.camel@lca.pw> <1563829996.11067.4.camel@lca.pw>
In-Reply-To: <1563829996.11067.4.camel@lca.pw>
From:   James Y Knight <jyknight@google.com>
Date:   Mon, 22 Jul 2019 18:58:34 -0400
Message-ID: <CAA2zVHqXDuMzBC6dD5AbepZc63nPdJ3WLYmjinjq01erqH+HXA@mail.gmail.com>
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
To:     Qian Cai <cai@lca.pw>
Cc:     David Miller <davem@davemloft.net>,
        Bill Wendling <morbo@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        natechancellor@gmail.com, Jakub Jelinek <jakub@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 5:13 PM Qian Cai <cai@lca.pw> wrote:
>
> On Fri, 2019-07-19 at 17:47 -0400, Qian Cai wrote:
> > On Thu, 2019-07-18 at 16:29 -0700, David Miller wrote:
> > > From: Qian Cai <cai@lca.pw>
> > > Date: Thu, 18 Jul 2019 19:26:47 -0400
> > >
> > > >
> > > >
> > > > > On Jul 18, 2019, at 5:21 PM, Bill Wendling <morbo@google.com> wrote:
> > > > >
> > > > > [My previous response was marked as spam...]
> > > > >
> > > > > Top-of-tree clang says that it's const:
> > > > >
> > > > > $ gcc a.c -O2 && ./a.out
> > > > > a is a const.
> > > > >
> > > > > $ clang a.c -O2 && ./a.out
> > > > > a is a const.
> > > >
> > > >
> > > >
> > > > I used clang-7.0.1. So, this is getting worse where both GCC and clang
> > > > will
> > >
> > > start to suffer the
> > > > same problem.
> > >
> > > Then rewrite the module parameter macros such that the non-constness
> > > is evident to all compilers regardless of version.
> > >
> > > That is the place to fix this, otherwise we will just be adding hacks
> > > all over the place rather than in just one spot.
> >
> > The problem is that when the compiler is compiling be_main.o, it has no
> > knowledge about what is going to happen in load_module().  The compiler can
> > only
> > see that a "const struct kernel_param_ops" "__param_ops_rx_frag_size" at the
> > time with
> >
> > __param_ops_rx_frag_size.arg = &rx_frag_size
> >
> > but only in load_module()->parse_args()->parse_one()->param_set_ushort(), it
> > changes "__param_ops_rx_frag_size.arg" which in-turn changes the value
> > of "rx_frag_size".
>
> Even for an obvious case, the compilers still go ahead optimizing a variable as
> a constant. Maybe it is best to revert the commit d66acc39c7ce ("bitops:
> Optimise get_order()") unless some compiler experts could improve the situation.
>
> #include <stdio.h>
>
> int a = 1;
>
> int main(void)
> {
>         int *p;
>
>         p = &a;
>         *p = 2;
>
>         if (__builtin_constant_p(a))
>                 printf("a is a const.\n");
>
>         printf("a = %d\n", a);
>
>         return 0;
> }
>
> # gcc -O2 const.c -o const
>
> # ./const
> a is a const.
> a = 2

This example (like the former) is showing correct behavior. At the
point of invocation of __builtin_constant_p here, the compiler knows
that 'a' is 2, because you've just assigned it (through 'p', but that
indirection trivially disappears in optimization).
