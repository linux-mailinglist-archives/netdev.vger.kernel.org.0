Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F2034297A
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCTAdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhCTAdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:33:17 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DF9C061760;
        Fri, 19 Mar 2021 17:33:17 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u20so13975630lja.13;
        Fri, 19 Mar 2021 17:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImYRAP6AZ1KS5ltknhW6/B+3aXlkE7eqRYJ8AMMRhtM=;
        b=URG49tKOBQYLqq7XikVjiV1KHUN98FyWam9MFO4CettKoemaO512JEK+HDN7cRMQ05
         8CGUwJom+XOxjBucoP4wTPqUE3NGCxeJi08ZSxNa0ZrUolPrOKbkcUVU59pABBYjoUFB
         +36UKsviaDJjb7N51B8SIdKPpmjHsn79rxeX+XmhbvIoxhCtCv+jWnMX+IAKJANfrE6u
         vSCuDBuTp17yAKNNIILl1/FvAGhsYdAP+soOrAHMivh4q6o8Lc5nAesHcWELYiBii/FR
         iCAOlN0LXmvoTTdcgU88YrJRrICPhDcl03ogLKng3VyFO5DcyTyeRCZQI1Eml7Yyqfrz
         fOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImYRAP6AZ1KS5ltknhW6/B+3aXlkE7eqRYJ8AMMRhtM=;
        b=j/p+EeE7hYqfSIep13RlsHjK97dk/Huto3qO38gDdkrakZBIbM46PMdtYlqxMmCDvy
         YfHJE95tKDfH9auEjBwZPAA0w1NiABqVJGvzU9UpCZQIveyCZ9OEHXT+MKtxYwpRNBmg
         yo1pOnkzbVud9EL+Pc7o4xhEo2Q8Xg9oTJXLQkwRcR0SmFtttgB7C/Z0zdksvHte1jBY
         bsAv4mCS29u8fXBk9ItzMuzGMPnqb6Q1UHN5uq40k9dkbdq7zbUqSRyDvTArLwJqAKGH
         RxqP1DiCCgBDbBP/UjWyPDYPfo9XvCJtQPR02jtSTpqkQJvYjlB/3LDDkvfRc2sERYGF
         6aAg==
X-Gm-Message-State: AOAM532EXS9feqmfYNoirDjmvIhFJjGK7Kr2caeQM37E5FRccdyc3EFS
        +jxiNf1PsxbLSoyFzGp3pn3DLUxTjy21zpVK1fr4TMfz
X-Google-Smtp-Source: ABdhPJxxXlytWMTVRX7LNFLVG7JpC8qm68rxPw0t1QUAX8KM10eX7nu80+xEeFoB1t7nWb0scDbYSnNHaAfRP5UJwjU=
X-Received: by 2002:a2e:900b:: with SMTP id h11mr2417721ljg.258.1616200395390;
 Fri, 19 Mar 2021 17:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210320000001.915366-1-sdf@google.com> <CAADnVQLCdMWgB9tB4UiSFHp36vswfQO_R_1ifdPqyrD6UT6vqA@mail.gmail.com>
 <CAKH8qBvXwzOqJ_4ETF1LrBQKxhKWLWv28beFHHK+=Zd0hULGFQ@mail.gmail.com>
In-Reply-To: <CAKH8qBvXwzOqJ_4ETF1LrBQKxhKWLWv28beFHHK+=Zd0hULGFQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Mar 2021 17:33:04 -0700
Message-ID: <CAADnVQ+fg-HMM=TtsrZx1kJQpy7-fckcgkN00L-Gp5Aa-CzmQQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog, 5)
 for BPF_TRAMP_F_CALL_ORIG
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 5:25 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Mar 19, 2021 at 5:14 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 5:00 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > __bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
> > > emits non-atomic one which breaks fentry/fexit with k8 atomics:
> > >
> > > P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
> > > K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)
> > >
> > > Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
> > > and running fexit_bpf2bpf selftest.
> > >
> > > Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  arch/x86/net/bpf_jit_comp.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > index 72b5a57e9e31..b35fc8023884 100644
> > > --- a/arch/x86/net/bpf_jit_comp.c
> > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > @@ -2012,7 +2012,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >                 /* remember return value in a stack for bpf prog to access */
> > >                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> > >                 im->ip_after_call = prog;
> > > -               emit_nops(&prog, 5);
> > > +               memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> > > +               prog += X86_PATCH_SIZE;
> >
> > I'm well aware, but ideal_nops are pretty much gone already.
> > The changes are already in the -tip tree.
> > So I decided to reduce the conflicts for the merge window.
> >
> > Do you actually see the breakage or it's purely theoretical?
> We do see it, but it's on our tree that pulls from bpf.
> And it obviously doesn't have that "x86: Remove dynamic NOP selection" yet.
> Thanks for the pointer, I guess I can just wait for the real merge then.

If it breaks the real users we have to land the fix, but let me ask how
come that you run with k8 cpu? k8 does other nasty things.
Do you run with all of amd errata?
