Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3375991A1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbiHSANn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHSANk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:13:40 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E3932055;
        Thu, 18 Aug 2022 17:13:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t5so3797907edc.11;
        Thu, 18 Aug 2022 17:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zuugaCe8bJg0rqCGIdwkGWMnPVnSYXDZaVtIRZe5O70=;
        b=IxuYFPA2kPuu5AKOEsyk3Mba0J8ky8pZxI7SD5DX7y6x62RA4TI/Bl5DaeMBi0++J1
         rkW7Rj+nPbEQRtCYZ6iZehOkd4J+dr/uGAXiE32SXwdfmY+KvSxXPywKegLKGqFrIZ0+
         mOrRJpP9jxtiHgFIItvSSMg+fNTAz1mCfzGipD8BJ3vlpf5z+qELnkC8vTmVfXO/kebC
         hVqpIoO1znh0jHmslB6+heyb8jiwHrLxijjac9nxAd5RINKM2ncF14k/a67C7qm2cfLD
         Y00YqD9r6XwLxieUhlz1GsMkz0W9PuguQ5+2N3DqGQnRYzZl9OiFQu4XEwFrFH41h3vP
         dDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zuugaCe8bJg0rqCGIdwkGWMnPVnSYXDZaVtIRZe5O70=;
        b=li+kCRfkHg52MD8jOeqDAumD19v+XwJuUifvVQE0TiLGyKLi6S9aHWTOdTvcwMgYPC
         XS4kp7iz/ynyR3EJ7Jeu5k0OeqQ/XnbwXze0hNQoCZ2rMm22Qe/cG8X+wMoGK34doY3x
         syzztwrzggS/AWJlAJsvs+igkNGYDaPDc2pGnCLfNEdSG/Evtv8Pz6KQ6c74hUIvzdAJ
         SbyZnc2f6W/dBPJ/YUiIoo+VC30dCKu1et+bE3VMNl15muguDkh+qT7oAgpe/2uyTt+j
         qv5iWUtW7xrqXwg/wZQIU/k6V657GuWjoJ2SuhvfuGnG0c67e7AZGmvGQbunpPSVBoW4
         SgWA==
X-Gm-Message-State: ACgBeo0xlB7z+3SFuxY/AFy7pl4m/09q6/FfpueXWncfIeUJCbxlbBde
        1IIFzV1JNmjfCEFULHKB4PZaWoXTtGbm76x+zAw=
X-Google-Smtp-Source: AA6agR6KwU/18HtaBCplc7jJcPI5CQPQ6IiOEDiRKCacJER1FS4lRHfi9Q90BaVvHOiWKUmnOMt01eOejB20LboFv7E=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr4061786edb.333.1660868016674; Thu, 18
 Aug 2022 17:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+H2n5-Gwgq-OZu-WZKRsg=kq7FtOGXJu6YNHoCEBap6w@mail.gmail.com>
 <20220819000645.55413-1-kuniyu@amazon.com>
In-Reply-To: <20220819000645.55413-1-kuniyu@amazon.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 17:13:25 -0700
Message-ID: <CAADnVQ+wKkiKo0L5HXiCeqxX+oqegiXBqc7fH+Yj2CG6_ymDKg@mail.gmail.com>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > always a chance of data-race.  So, all readers and a writer need some
> > > basic protection to avoid load/store-tearing.
> > >
> > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > >  include/linux/filter.h           | 2 +-
> > >  net/core/sysctl_net_core.c       | 4 ++--
> > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > --- a/arch/arm/net/bpf_jit_32.c
> > > +++ b/arch/arm/net/bpf_jit_32.c
> > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > >         }
> > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > >
> > > -       if (bpf_jit_enable > 1)
> > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> >
> > Nack.
> > Even if the compiler decides to use single byte loads for some
> > odd reason there is no issue here.
>
> I see, and same for 2nd/3rd patches, right?
>
> Then how about this part?
> It's not data-race nor problematic in practice, but should the value be
> consistent in the same function?
> The 2nd/3rd patches also have this kind of part.

The bof_jit_enable > 1 is unsupported and buggy.
It will be removed eventually.

Why are you doing these changes if they're not fixing any bugs ?
Just to shut up some race sanitizer?

> ---8<---
> diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
> index 43e634126514..c71d1e94ee7e 100644
> --- a/arch/powerpc/net/bpf_jit_comp.c
> +++ b/arch/powerpc/net/bpf_jit_comp.c
> @@ -122,6 +122,7 @@ bool bpf_jit_needs_zext(void)
>
>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>  {
> +       int jit_enable = READ_ONCE(bpf_jit_enable);
>         u32 proglen;
>         u32 alloclen;
>         u8 *image = NULL;
> @@ -263,13 +264,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>                 }
>                 bpf_jit_build_epilogue(code_base, &cgctx);
>
> -               if (bpf_jit_enable > 1)
> +               if (jit_enable > 1)
>                         pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
>                                 proglen - (cgctx.idx * 4), cgctx.seen);
>         }
>
>  skip_codegen_passes:
> -       if (bpf_jit_enable > 1)
> +       if (jit_enable > 1)
>                 /*
>                  * Note that we output the base address of the code_base
>                  * rather than image, since opcodes are in code_base.
> ---8<---
