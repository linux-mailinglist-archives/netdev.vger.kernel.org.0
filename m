Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC71EEAE5
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 21:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgFDTJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 15:09:46 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34327 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgFDTJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 15:09:45 -0400
Received: by mail-ot1-f66.google.com with SMTP id b18so5664798oti.1;
        Thu, 04 Jun 2020 12:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X+qiK8YjhEONxTpdjX70xl6++OY/MUPwZ+Do1G1LJJ8=;
        b=GW2eTPu20UwqNX0KYzVZ77nyK4NotTSEGULdpG7s3Iiub4PuOXbACySBtKn3WbvYBh
         s4b4x4/PUmzOXvAzhlgyyHfBAb0fKY0Pn8Vt/G7D2vPmGXlWvQjPYQg02xRxMblvJKLx
         uc91xVfPnlqT9KiicR81FI4/0gUdaplWxi3701kx3noorRHkPm+2RP9VCcC5y+Y7f5ZY
         ikJ9YinXbYMx4cl1TGEqa5GmQBZQlzbHbh6Bfh3zgStaZW+APOiAUiH3iHQ2INqVWP/p
         9lucmaqitdqEP3qkf01mvungAwlz41SHVUIsHr8669r0XAAJr1Hof5D/gPpTyuSLOGdA
         2BJw==
X-Gm-Message-State: AOAM530ihph2ICe7cs5surPRGolnMx5OxNi++eVnn9Lm6h6t6yOl08eq
        gmTcYMbxDOp7gBeLshNltS1LLbmKEpDozFY7alw=
X-Google-Smtp-Source: ABdhPJzhyOhHvYlAI9At8dx2VdKyrIdrlXCUe7od4PVsnRA3/MLtv6c1HELqb/95gRjonFKD9uvMPOkwcy/FsbOWC+M=
X-Received: by 2002:a05:6830:141a:: with SMTP id v26mr4936016otp.250.1591297783928;
 Thu, 04 Jun 2020 12:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-10-keescook@chromium.org> <20200604132306.GO6578@ziepe.ca>
 <202006040757.0DFC3F28E@keescook>
In-Reply-To: <202006040757.0DFC3F28E@keescook>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Jun 2020 21:09:32 +0200
Message-ID: <CAMuHMdVuzvvHt3j+L+_BSPFs5RgaP3rkknEUmRvTAs5nZ9SGPA@mail.gmail.com>
Subject: Re: [PATCH 09/10] treewide: Remove uninitialized_var() usage
To:     Kees Cook <keescook@chromium.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        linux-block@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Thu, Jun 4, 2020 at 5:01 PM Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jun 04, 2020 at 10:23:06AM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 03, 2020 at 04:32:02PM -0700, Kees Cook wrote:
> > > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > > (or can in the future), and suppresses unrelated compiler warnings
> > > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > > either simply initialize the variable or make compiler changes.
> > >
> > > I preparation for removing[2] the[3] macro[4], remove all remaining
> > > needless uses with the following script:
> > >
> > > git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
> > >     xargs perl -pi -e \
> > >             's/\buninitialized_var\(([^\)]+)\)/\1/g;
> > >              s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'
> > >
> > > drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
> > > pathological white-space.
> > >
> > > No outstanding warnings were found building allmodconfig with GCC 9.3.0
> > > for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
> > > alpha, and m68k.
> >
> > At least in the infiniband part I'm confident that old gcc versions
> > will print warnings after this patch.
> >
> > As the warnings are wrong, do we care? Should old gcc maybe just -Wno-
> > the warning?
>
> I *think* a lot of those are from -Wmaybe-uninitialized, but Linus just
> turned that off unconditionally in v5.7:
> 78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized")
>
> I'll try to double-check with some older gcc versions. My compiler
> collection is mostly single-axis: lots of arches, not lots of versions. ;)

Nope, support for the good old gcc 4.1 was removed a while ago.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
