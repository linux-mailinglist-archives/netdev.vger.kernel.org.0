Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1D59A8F7
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiHSW4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiHSW4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:56:48 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF8810E789;
        Fri, 19 Aug 2022 15:56:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qn6so11317906ejc.11;
        Fri, 19 Aug 2022 15:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=y1Ot7JwaLFB8mJjqEqwwfJmEFFcwQibYT37fHJJrIBU=;
        b=fbq5yFNeLeJLs1YOLPSMK67DddVFloUIVSYKmxRG3dXhzFEMuopLmHg898JNwR0hzo
         GdTK6T21zdS1nqxsg1JKWSSPNWp/hLkYx6MIK1sH+B1uXWkomOPL048Gpm9uISkGe49F
         QZ5eMrPMl+rmegLOxiVhoA1p68QG1yGv3b9GPUkT/Gs8pNdTacd7J8bxlkovMigQFOyQ
         evc5M08/sO4NMs72mb7bJuXLskKGpV6xa79QxpNn/4fLfP+nKcS4qBJ97FcOM5ksPIpc
         rE19CL0ZwbBAfV3rZfkSnPIyQNrzsN5i+bJ/F+mf+eiSHULewlENKXp9YvE2cBm6wolv
         3HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=y1Ot7JwaLFB8mJjqEqwwfJmEFFcwQibYT37fHJJrIBU=;
        b=T8VOoY26Z5Lq6k/UUvKRMzgP8Y2O1eYhx/tBx0sx93MtJiXu+28dRN13F6vHHpaQNw
         cnnOJg9WElIzA7T69UgbPwMpKWp3xqmq5MVRqTDDjeak7ZmDb2Cqch/+geY6O2+9AE5q
         nq8ESV9CJTwglUjwsI4Kdc1OWSdl1Iu1W4mCSGm/0A4DYatTTzA3o0+TbkTtxdIB3Du9
         dbM0K01slj3gnz7X88+En6cjTc10biEEoe8xBqpxVnUgEao8ojSbP46aGPxZTMR844/v
         ugK1QCXDTkhhZ6WvXvNXuDYiqUNWrt7n4oQroOikQyUCNuTF4bN/iFyLHCE7D3mQhnjr
         6CAA==
X-Gm-Message-State: ACgBeo3hUe1e4iulZliVsklahjzcs0/Xp3Yu6R8gBO/Aj3ikGFc0570j
        xVDJFAXrKswOLO0j26pxaMVccjOOhV0tgiwNC4U=
X-Google-Smtp-Source: AA6agR6HHiYxIPLPzpcske/8DgoDwHZfyDzJREkUkXfgCQXVEQR93qdyFvX1BEYAKci2B5qlG/G4VyvI9CIiUuedghc=
X-Received: by 2002:a17:907:e8d:b0:730:a4e8:27ed with SMTP id
 ho13-20020a1709070e8d00b00730a4e827edmr5977071ejc.58.1660949805843; Fri, 19
 Aug 2022 15:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJHdxu43rPgpfQ-ezR-Vt3xW2YP7SXUayfoEg+3BCps5w@mail.gmail.com>
 <20220819034635.67875-1-kuniyu@amazon.com>
In-Reply-To: <20220819034635.67875-1-kuniyu@amazon.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Aug 2022 15:56:34 -0700
Message-ID: <CAADnVQLjUn75aj1ZJbjX9ZPCQDJZ1J4Xan5w7u3qRiDybnW9WA@mail.gmail.com>
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

On Thu, Aug 18, 2022 at 8:46 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date:   Thu, 18 Aug 2022 20:27:49 -0700
> > On Thu, Aug 18, 2022 at 6:15 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > Date:   Thu, 18 Aug 2022 18:05:44 -0700
> > > > On Thu, Aug 18, 2022 at 5:56 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > Date:   Thu, 18 Aug 2022 17:13:25 -0700
> > > > > > On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > >
> > > > > > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > > > Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > > > > > > > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > > > >
> > > > > > > > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > > > > > > > always a chance of data-race.  So, all readers and a writer need some
> > > > > > > > > basic protection to avoid load/store-tearing.
> > > > > > > > >
> > > > > > > > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > > > ---
> > > > > > > > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > > > > > > > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > > > > > > > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > > > > > > > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > > > > > > > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > > > > > > > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > > > > > > > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > > > > > > > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > > > > > > > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > > > > > > > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > > > > > > > >  include/linux/filter.h           | 2 +-
> > > > > > > > >  net/core/sysctl_net_core.c       | 4 ++--
> > > > > > > > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > > > > > > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > > > > > > > --- a/arch/arm/net/bpf_jit_32.c
> > > > > > > > > +++ b/arch/arm/net/bpf_jit_32.c
> > > > > > > > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > > > > > > > >         }
> > > > > > > > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > > > > > > > >
> > > > > > > > > -       if (bpf_jit_enable > 1)
> > > > > > > > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> > > > > > > >
> > > > > > > > Nack.
> > > > > > > > Even if the compiler decides to use single byte loads for some
> > > > > > > > odd reason there is no issue here.
> > > > > > >
> > > > > > > I see, and same for 2nd/3rd patches, right?
> > > > > > >
> > > > > > > Then how about this part?
> > > > > > > It's not data-race nor problematic in practice, but should the value be
> > > > > > > consistent in the same function?
> > > > > > > The 2nd/3rd patches also have this kind of part.
> > > > > >
> > > > > > The bof_jit_enable > 1 is unsupported and buggy.
> > > > > > It will be removed eventually.
> > > > >
> > > > > Ok, then I'm fine with no change.
> > > > >
> > > > > >
> > > > > > Why are you doing these changes if they're not fixing any bugs ?
> > > > > > Just to shut up some race sanitizer?
> > > > >
> > > > > For data-race, it's one of reason.  I should have made sure the change fixes
> > > > > an actual bug, my apologies.
> > > > >
> > > > > For two reads, I feel buggy that there's an inconsitent snapshot.
> > > > > e.g.) in the 2nd patch, bpf_jit_harden == 0 in bpf_jit_blinding_enabled()
> > > > > could return true.  Thinking the previous value was 1, it seems to be timing
> > > > > issue, but not intuitive.
> > > >
> > > > it's also used in bpf_jit_kallsyms_enabled.
> > > > So the patch 2 doesn't make anything 'intuitive'.
> > >
> > > Exactly...
> > >
> > > So finally, should I repost 4th patch or drop it?
> >
> > This?
> > -       if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
> > +       if (atomic_long_add_return(size, &bpf_jit_current) >
> > READ_ONCE(bpf_jit_limit)) {
> >
> > same question. What does it fix?
>
> Its size is long, and load tearing [0] could occur by compiler
> optimisation.  So, concurrent writes & a teared-read could get
> a bigger limit than intended.

'long' indeed. Still improbable, but sure. let's read_once it.
