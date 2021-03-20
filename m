Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF65634296B
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhCTAZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTAZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:25:19 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF51C061761
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:25:18 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id s2so8178993qtx.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1BfxPxTGz5e5gbSJNkzPYOitZlpuJjeOdVJlDrUL2k=;
        b=qMgoPrQbuy1uh6Xu5Qi6L3M6HmvGvEETOfhTJs+533hSIWSw2q/CHu4X3Wj+8rTeDR
         4Z6bzeJmlxPltLAtjSvYkFO51aiHovoI5kql6EUbpNusCf9yEMBTmyakvtjwsRTJe2kL
         FUcmW345iEuwc04xrEirA1eglr6wBA66lPwyW27lWjfYXef44SvFMya2Pf/wK/GswAHH
         AH4CI3g0IwD46fpf1iAXBtPtYGjAR4xXmIn1ZLOK4/zF7ZVBsBtqOg4isQm08I3OoCKd
         AG99qdQVAdO9XEhqI3/a3T7Bl1/SUm80isxVJ1Ouo3b2q1idv6whGRiUo9ek2jmV7K1T
         kFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1BfxPxTGz5e5gbSJNkzPYOitZlpuJjeOdVJlDrUL2k=;
        b=fymLJluowiVLrosRxcC2cbndWHCZU8Ds1v4+HpNXTfjyAlpPcTwp4Vqzie3i1rbFiK
         8o7S3+jcY29XkLffZkMSp0eIIZ0ydAjfS4S+65HrKQw1+nKfvOhO0HtKh79HP9hbejw9
         tnf87BKox70rUo+KFXJCvHh/eAGOtv5NJ4eYur6eVXYrFjqWs01b0lu9qbU935O707tM
         QXyTG6iZ/EaiRE9882By+uNKmlqJX0e3XMh5NFc7CYMfil/RJExmrFKVmdU1RyXMRuFN
         pNxB267obvDR7pSECJ45M1sQR/206Nxy+i+YRzLmq9pGjrqr2gPKPnQt5rQcrjCn0IE3
         PeUg==
X-Gm-Message-State: AOAM532S/9ESPQIL3QBvbBl4U96ELy/6UeMxS4XXt95gVeBuoxSmxdD1
        IjAZh5Ude+4mihNg8VUVPXKts/DL6kPQUwJVUA/mwA==
X-Google-Smtp-Source: ABdhPJzibImwwhu/TEkxZ/+eK+9WajME9aeq4IVLAHw4qB5tvN7cx8TIGab7BSKdAfsin1934hAc7Rpy8FHrXuama6Y=
X-Received: by 2002:aed:3a83:: with SMTP id o3mr1150656qte.349.1616199917757;
 Fri, 19 Mar 2021 17:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210320000001.915366-1-sdf@google.com> <CAADnVQLCdMWgB9tB4UiSFHp36vswfQO_R_1ifdPqyrD6UT6vqA@mail.gmail.com>
In-Reply-To: <CAADnVQLCdMWgB9tB4UiSFHp36vswfQO_R_1ifdPqyrD6UT6vqA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 19 Mar 2021 17:25:07 -0700
Message-ID: <CAKH8qBvXwzOqJ_4ETF1LrBQKxhKWLWv28beFHHK+=Zd0hULGFQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog, 5)
 for BPF_TRAMP_F_CALL_ORIG
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 5:14 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Mar 19, 2021 at 5:00 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > __bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
> > emits non-atomic one which breaks fentry/fexit with k8 atomics:
> >
> > P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
> > K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)
> >
> > Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
> > and running fexit_bpf2bpf selftest.
> >
> > Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 72b5a57e9e31..b35fc8023884 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -2012,7 +2012,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >                 /* remember return value in a stack for bpf prog to access */
> >                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> >                 im->ip_after_call = prog;
> > -               emit_nops(&prog, 5);
> > +               memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> > +               prog += X86_PATCH_SIZE;
>
> I'm well aware, but ideal_nops are pretty much gone already.
> The changes are already in the -tip tree.
> So I decided to reduce the conflicts for the merge window.
>
> Do you actually see the breakage or it's purely theoretical?
We do see it, but it's on our tree that pulls from bpf.
And it obviously doesn't have that "x86: Remove dynamic NOP selection" yet.
Thanks for the pointer, I guess I can just wait for the real merge then.
