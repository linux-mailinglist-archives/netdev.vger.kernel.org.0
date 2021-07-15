Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375813C95A5
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 03:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhGOBhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 21:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbhGOBhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 21:37:20 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5E3C06175F;
        Wed, 14 Jul 2021 18:34:28 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id u14so6322173ljh.0;
        Wed, 14 Jul 2021 18:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pb22RAfWzq7JxZLbG1m1A+H9CpWAIKjVTut9DdUOIY8=;
        b=hkyuUB2kacfrmpKtNqQF7oQXLP5fmOHWQYCsGfMMV5M9h72XD6xttv1sdrPJ/sePDg
         Aj4wD55gs1xyQjoZvdU9JhKATnbgQXUJWMcEvgBOqexcLDDWV8NQCe/tqbXGSkAzuzti
         DnyHKdpzGr+/W5Bn+sI2lHSpovJ8tPLFAPnLh/2+4xWqZ3AiqBz5GCnLA+j24M5FeEcv
         EIqIIvdY/3JY69sZTKev3j2lKiwo9j+VKXD/ZdLR1hLM2+2eCMIxldBSIJhxUc5nI04N
         NuSsbJ5I7KElJyshruv5yDhyWcz8+gfYpna6ddQKX4dtkz9hGY1BuS96FmU/3lrbuCoc
         tsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pb22RAfWzq7JxZLbG1m1A+H9CpWAIKjVTut9DdUOIY8=;
        b=ZERlOVUZ/p/KK+6I3NJG9jIM6ZUL6OEpk3en0OC3nlVTYS7izvhXzgUuIjdYA4xN2A
         ntthoSA/Ipc73bf8A2BJh8FSrWgXSB1l2v4e38zBRincoEHQL77upS8Pl8S413smucgB
         3snyjh8J9GdYH+I/Y+2suDs+Af0dJlJMCsiXE0015sbMKHXKrZ/NsFPHI7iQfS2sB7mV
         LKqIKjA2QXCsKmzyxatroHj2bflnj3j24jaEg1GWNNNcr2ezyM5UT2SC7hEB/+cP42kb
         qTB4BpPQ2e6LvvJMSzShQC9S0QOMOuk+UcT+WzPQxuA2y1N2XtbC+pfR3WPwmjrSfSjo
         U2nA==
X-Gm-Message-State: AOAM530rmIEJw38VHBsFwnZdmKONfVqlUYiuQN4ehgmd+ZI+xhuy2DVY
        qq7ZLRrvntShkCD1HjBYRiL7lQtYJEAWFLIw7UA=
X-Google-Smtp-Source: ABdhPJySgo+9pbgquBVTVQrADnr50Rguamatr984+8e4JTixCml3fpTvBpZJBoEcwxrJTEExVCpPkgkRqDifaJLCGUo=
X-Received: by 2002:a2e:3214:: with SMTP id y20mr684735ljy.486.1626312866512;
 Wed, 14 Jul 2021 18:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210714101815.164322-1-hefengqing@huawei.com> <CAPhsuW51b0Cd7VV6ub2APze4EMbMJ+Y=scLAEyhJ4SvG=D0kyQ@mail.gmail.com>
In-Reply-To: <CAPhsuW51b0Cd7VV6ub2APze4EMbMJ+Y=scLAEyhJ4SvG=D0kyQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Jul 2021 18:34:15 -0700
Message-ID: <CAADnVQKQP=UsifdhSiFqkydG1BFDY7uCLsOPT-0u9e3P8yVbKw@mail.gmail.com>
Subject: Re: [bpf-next, v2] bpf: verifier: Fix potential memleak and UAF in
 bpf verifier
To:     Song Liu <song@kernel.org>
Cc:     He Fengqing <hefengqing@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 5:54 PM Song Liu <song@kernel.org> wrote:
> > -       return 0;
> > +       return;
> No need to say return here.
>
> >  }
> >
> >  static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len)
> > @@ -11492,6 +11490,14 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
> >                                             const struct bpf_insn *patch, u32 len)
> >  {
> >         struct bpf_prog *new_prog;
> > +       struct bpf_insn_aux_data *new_data = NULL;
> > +
> > +       if (len > 1) {
> > +               new_data = vzalloc(array_size(env->prog->len + len - 1,
> > +                                             sizeof(struct bpf_insn_aux_data)));
> > +               if (!new_data)
> > +                       return NULL;

I removed the redundant 'return' that Song pointed out and the
redundant 'if' above.
And applied to bpf-next.
Though it's a fix, I think it's ok to go via bpf-next, since even
syzbot didn't find it.
