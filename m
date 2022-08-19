Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12F59923D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiHSBF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHSBF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:05:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69963B728A;
        Thu, 18 Aug 2022 18:05:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i14so6207617ejg.6;
        Thu, 18 Aug 2022 18:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=l/uFusNeYcgVKyB9Cvjyb0TgfN/A2hgl4OfScqL5RVU=;
        b=D9jOD52xUJ6UBB3joMLIoghoN7OlgEBxxRq1nn1FOzQ02Yk3vWEs9+4f7759/i4G3i
         iCqbGldtKQLmA3mOzDw9GmWnB3SKohkrJvn96v3yTZDkdv6aZXWYKS/XQROPkWQ2LoLg
         SVPC6vAsuBot8QlXnRiBr6RIh3vqSwC157M3svzma1p+hFAwKq7jrbFPi9izfABveez/
         qWEMjBmhm7kDk1PVnZEpg19sp/8Y2gDH7PdXbHRa/Ha8Sj0O51UFyzuCvLaqIXHKvLeb
         aXv2f/3yRH3oUjwPqarMHjoLh4hSRcm5xGRylEopKWEMlH9RUPI7eG17K5q+uLlrWOUH
         UtDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=l/uFusNeYcgVKyB9Cvjyb0TgfN/A2hgl4OfScqL5RVU=;
        b=GYBUnZdB7pMVLG0gPLWaCkNglToZhu/qnHyiFJ22mhnG5Relsm/xLq/janA57JWJFd
         eBznyD5Vcyh4q+H69Xe+7tcPM5NwxDe/5woyPPOqNvT06ZiHSqAe7y3Qnuw8jY9MAUAT
         BwxqlJ2twicIfw2gXY75FIMHB+HfBw5tO6H5NmOCYb4K6v5dLNew0ZUs2k9pPQT4tPnR
         l6wvK8fv2Bp4MonZUlalhA8WM+riDb9djPycAXNxHZgyiRHioD557VcpVQ22VSHvL46D
         OJ9ua0Q+mc6ZRVv9a3MKDIZoRy7bt2oy3gDpu5p8O2Hp9oFkveeSuA+YCpVGyffoqjVU
         nfng==
X-Gm-Message-State: ACgBeo1XaaB7qw/3jrYgSNUQ15kVVfUtFQpGQUT7+hzG10s+NjLnwtJX
        QRALg/O49yJ2pkO0vJJpl411m6HbxmYQnsMPV7k=
X-Google-Smtp-Source: AA6agR7akhee9frypDfPrbcwxwUaZd9H6Dj1EtY/YzbVkU6SS9bF1jNpn/98QQBmSjaYlpQgvxtFp+Kecj3mChYNzDU=
X-Received: by 2002:a17:907:272a:b0:731:4699:b375 with SMTP id
 d10-20020a170907272a00b007314699b375mr3328145ejl.633.1660871155964; Thu, 18
 Aug 2022 18:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+wKkiKo0L5HXiCeqxX+oqegiXBqc7fH+Yj2CG6_ymDKg@mail.gmail.com>
 <20220819005520.57894-1-kuniyu@amazon.com>
In-Reply-To: <20220819005520.57894-1-kuniyu@amazon.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 18:05:44 -0700
Message-ID: <CAADnVQ+=F4tHsYi14+z+8WP+T3w9vBUpdUhgq4y9=c4X5NhN_g@mail.gmail.com>
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

On Thu, Aug 18, 2022 at 5:56 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date:   Thu, 18 Aug 2022 17:13:25 -0700
> > On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > > > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > > > always a chance of data-race.  So, all readers and a writer need some
> > > > > basic protection to avoid load/store-tearing.
> > > > >
> > > > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > ---
> > > > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > > > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > > > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > > > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > > > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > > > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > > > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > > > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > > > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > > > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > > > >  include/linux/filter.h           | 2 +-
> > > > >  net/core/sysctl_net_core.c       | 4 ++--
> > > > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > > > --- a/arch/arm/net/bpf_jit_32.c
> > > > > +++ b/arch/arm/net/bpf_jit_32.c
> > > > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > > > >         }
> > > > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > > > >
> > > > > -       if (bpf_jit_enable > 1)
> > > > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> > > >
> > > > Nack.
> > > > Even if the compiler decides to use single byte loads for some
> > > > odd reason there is no issue here.
> > >
> > > I see, and same for 2nd/3rd patches, right?
> > >
> > > Then how about this part?
> > > It's not data-race nor problematic in practice, but should the value be
> > > consistent in the same function?
> > > The 2nd/3rd patches also have this kind of part.
> >
> > The bof_jit_enable > 1 is unsupported and buggy.
> > It will be removed eventually.
>
> Ok, then I'm fine with no change.
>
> >
> > Why are you doing these changes if they're not fixing any bugs ?
> > Just to shut up some race sanitizer?
>
> For data-race, it's one of reason.  I should have made sure the change fixes
> an actual bug, my apologies.
>
> For two reads, I feel buggy that there's an inconsitent snapshot.
> e.g.) in the 2nd patch, bpf_jit_harden == 0 in bpf_jit_blinding_enabled()
> could return true.  Thinking the previous value was 1, it seems to be timing
> issue, but not intuitive.

it's also used in bpf_jit_kallsyms_enabled.
So the patch 2 doesn't make anything 'intuitive'.
