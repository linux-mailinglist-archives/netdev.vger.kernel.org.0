Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B413D85A1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhG1Br7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhG1Br6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:47:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6654C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 18:47:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so7608628pjb.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 18:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b56RRYUTS03XICd8fA2qtUp0AUHb/enzxmkYpgfS6mQ=;
        b=ULjzXag2fzn2MWAevsHkfU4DGFB83/xCN+ou320ileQKhfcFiIwDmgHT0hK27d/5iw
         aNtiwfHcnzUz/xRfQqPTbZdf0v2T5DXdLqH/Iy6jeYelvl6kJqyubEE42ujmpxUqJ1M0
         SVR6MaUBv4nshnxF8am0wiGk1RDsc7Bz3+0xU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b56RRYUTS03XICd8fA2qtUp0AUHb/enzxmkYpgfS6mQ=;
        b=Q4Yry5t746hSe0QRIR4k9HCAJEcHMz8hNdsdRgJTbv0u3Na/I9ohxEYdhJN+hFoYQe
         nrjEHDMsZWLgUcexRjE3glVTVUxrbDR3vYT7KtnNyEESoH97/ezvvfHHL8jRxYMwljtG
         xmZmrCtkzy5Ny3r8/QVLrdZnK2DNSBWygtDnGYseOnelZX2ZC8RQdoKaZNsllxhteztT
         jC1wtRa4Z2QeAylAUlinElj63pC5qZnvI+9/iRmRiglfQa7wDN0zm2EpdUSqn0L40GQn
         IBukPC+AwuBczHBHXPMWCSTjwGV8t/siup7zROHRB2C5h9mfu4TAvyNZPbBJJ+g7orPR
         1lww==
X-Gm-Message-State: AOAM532cI+rdbbOCvgff6e0eCakLFSvb9d4ZnDJ7ekc9hhKOC7Wrz+9R
        FBLgHva/AM3RuPx4oVqB1S+8vQ==
X-Google-Smtp-Source: ABdhPJyGB/6+ELpL7U8c35faYsf4tmgVzMMY5WlBhkjlASqfxpvlVrk6N7mC99D5xk5Tp/+QyE2xNw==
X-Received: by 2002:a17:90a:8c8a:: with SMTP id b10mr15819262pjo.23.1627436874109;
        Tue, 27 Jul 2021 18:47:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 30sm5933732pgq.31.2021.07.27.18.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 18:47:53 -0700 (PDT)
Date:   Tue, 27 Jul 2021 18:47:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 34/64] fortify: Detect struct member overflows in
 memcpy() at compile-time
Message-ID: <202107271830.3DB03F3CF@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-35-keescook@chromium.org>
 <CAKwvOdknit8DtWaFvLupmNEebjbwVa6R3xiGc2D4AqB_6+i52g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdknit8DtWaFvLupmNEebjbwVa6R3xiGc2D4AqB_6+i52g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 03:43:27PM -0700, Nick Desaulniers wrote:
> On Tue, Jul 27, 2021 at 2:17 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > To accelerate the review of potential run-time false positives, it's
> > also worth noting that it is possible to partially automate checking
> > by examining memcpy() buffer argument fields to see if they have
> > a neighboring. It is reasonable to expect that the vast majority of
> 
> a neighboring...field?

Whoops, sorry, this should say "array member". I've fixed this to read:

  To accelerate the review of potential run-time false positives, it's
  also worth noting that it is possible to partially automate checking
  by examining the memcpy() buffer argument to check for the destination
  struct member having a neighboring array member. It is reasonable to
  expect that the vast majority of run-time false positives would look like
  the already evaluated and fixed compile-time false positives, where the
  most common pattern is neighboring arrays. (And, FWIW, several of the
  compile-time fixes were actual bugs.)

> > diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
> > index 7e67d02764db..5e79e626172b 100644
> > --- a/include/linux/fortify-string.h
> > +++ b/include/linux/fortify-string.h
> > @@ -2,13 +2,17 @@
> >  #ifndef _LINUX_FORTIFY_STRING_H_
> >  #define _LINUX_FORTIFY_STRING_H_
> >
> > +#include <linux/bug.h>
> 
> What are you using from linux/bug.h here?

Thanks; yes, that should have been added in patch 64, when the WARN_ONCE()
use is introduced:
https://lore.kernel.org/lkml/20210727205855.411487-65-keescook@chromium.org/

> > [...]
> > +#define __fortify_memcpy_chk(p, q, size, p_size, q_size,               \
> > +                            p_size_field, q_size_field, op) ({         \
> > +       size_t __fortify_size = (size_t)(size);                         \
> > +       fortify_memcpy_chk(__fortify_size, p_size, q_size,              \
> > +                          p_size_field, q_size_field, #op);            \
> > +       __underlying_##op(p, q, __fortify_size);                        \
> > +})
> > +
> > +/*
> > + * __builtin_object_size() must be captured here to avoid evaluating argument
> > + * side-effects further into the macro layers.
> > + */
> > +#define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                 \
> > +               __builtin_object_size(p, 0), __builtin_object_size(q, 0), \
> > +               __builtin_object_size(p, 1), __builtin_object_size(q, 1), \
> > +               memcpy)
> 
> Are there other macro expansion sites for `__fortify_memcpy_chk`,
> perhaps later in this series? I don't understand why `memcpy` is
> passed as `func` to `fortify_panic()` rather than continuing to use
> `__func__`?

Yes, memmove() follows exactly the same pattern. Rather than refactoring
the declaration in that patch, this felt cleaner.
https://lore.kernel.org/lkml/20210727205855.411487-36-keescook@chromium.org/

> > [...]
> >   * @count: The number of bytes to copy
> >   * @pad: Character to use for padding if space is left in destination.
> >   */
> > -static inline void memcpy_and_pad(void *dest, size_t dest_len,
> > -                                 const void *src, size_t count, int pad)
> > +static __always_inline void memcpy_and_pad(void *dest, size_t dest_len,
> > +                                          const void *src, size_t count,
> > +                                          int pad)
> 
> Why __always_inline here?

Without it, we run the risk of it being made out of line, and
potentially losing access to the __builtin_object_size() checking of
arguments. Though given some of the Clang bugs, it's possible this needs
to be strictly converted into a macro.

> > [...]
> >  #ifdef CONFIG_FORTIFY_SOURCE
> > +/* These are placeholders for fortify compile-time warnings. */
> > +void __read_overflow2_field(void) { }
> > +EXPORT_SYMBOL(__read_overflow2_field);
> > +void __write_overflow_field(void) { }
> > +EXPORT_SYMBOL(__write_overflow_field);
> > +
> 
> Don't we rely on these being undefined for Clang to produce a linkage
> failure (until https://reviews.llvm.org/D106030 has landed)?  By
> providing a symbol definition we can link against, I don't think
> __compiletime_{warning|error} will warn at all with Clang?

This was intentional because I explicitly do not want to break the build
for new warnings, and there is no way currently for Clang to _warn_
(rather than fail to link). This could be adjusted to break only Clang's
builds, but at this point, it seemed best.

> > [...]
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#define TEST   \
> > +       memcpy(instance.buf, large, sizeof(instance.buf) + 1)
> > +
> > +#include "test_fortify.h"
> > --
> 
> I haven't read the whole series yet, but I assume test_fortify.h was
> provided earlier in the series?

Yup, it's part of the compile-time tests in patch 32:
https://lore.kernel.org/lkml/20210727205855.411487-33-keescook@chromium.org/

-Kees

-- 
Kees Cook
