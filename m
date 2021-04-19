Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB636462D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbhDSOde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhDSOdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:33:33 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A808C06174A;
        Mon, 19 Apr 2021 07:33:03 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a1so39636232ljp.2;
        Mon, 19 Apr 2021 07:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7tmme4pRYd93LTaqtaN5mHl4x1cZSgoWzQ2PDBJdLng=;
        b=JR3Wf17T/Ilg5kJ8ARhsGu1audbYrS6bCxmzxtDcShkkYahcf9HJWm7lH++28bzIXj
         StObiFHebdhHmXQ0KIwLa3mJ9Pvw4xuWh+r231y5bG2VXGwLh6euxZjYPHdKFiTq4/zd
         LzpiHUqvf83Zbpqz+OtH/2OB062g+FVgfh/k2KYVnIFAnfF90+HoEXZNGgUYTTLauFDS
         LnJjD0gCSkelxAOd5EmeFiz1+12xZr+Mdi7dCGTQlQiXIDEZA0uhRt+pBs0GjxUSlZHM
         lLdAVWPUGpxN4rPrpttB6pKwtT2KXGHtYR8rcJZKrWqN2FQANdr+G0hLDNVr+7VnbqHW
         A47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7tmme4pRYd93LTaqtaN5mHl4x1cZSgoWzQ2PDBJdLng=;
        b=c2fUNabEqLMuOgr06pWa6q3rF6/OTTxX6FmTZNTbKEwZj01V5YBjNBHcsd440uNou1
         l7/+XvaT7VCv6M0znupoeoZGmYJcWPrOSpg/toHgcpHzu1Hz2cRkOqRbPDgWaXGCTT9g
         ITEA4QbWDpapXdcfC0okdF4DI2Hok0Qk2rxA3rKxVKepsUK+/oZjFrgWynzS07wsV/t1
         SnMPWWotb5xHAzECK0ZrSIPoEX5Gbh3xoynSlLcOpFbz4SCE6nkSVOcukWt6soH0P00C
         E22QNJxFt0KOLGyyO/1ETq8h6JEMk8R7l4+xpY8d8BK93uUX21yPtk0LtOiQ+hc+0Hr+
         pATA==
X-Gm-Message-State: AOAM532hQ/p9DNl4wsmtpf48iVWSHbOWmTtzelkPRPuCEmB4g2mOn0rn
        FZVOxYHvPLkkh5lgLegnG6l0QIzS+rxCCZBg/+o=
X-Google-Smtp-Source: ABdhPJztWDw4LdolZiG/tiEjxcLEoFBoUW7An7FriKYh+HvW59mBOYueLsP4J32lQjC8xxT5uBdFtuzFxB2SxKg9wkw=
X-Received: by 2002:a2e:8356:: with SMTP id l22mr1609707ljh.204.1618842782059;
 Mon, 19 Apr 2021 07:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210418200249.174835-1-pctammela@mojatatu.com>
 <CAADnVQLJDsnQ1YO9a_pQ-1aTJ1hNKYJXcSHypfzCare-c4HO1A@mail.gmail.com> <CAKY_9u0Ye9pt7igtxT8UR=Ro7=yNwUz2zQZDKH20NK92_LvgxA@mail.gmail.com>
In-Reply-To: <CAKY_9u0Ye9pt7igtxT8UR=Ro7=yNwUz2zQZDKH20NK92_LvgxA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 19 Apr 2021 07:32:50 -0700
Message-ID: <CAADnVQ+KhDOZGn9jAhfWbOOTTFZB0JL1i046y5XEuMzcuQQ8oA@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix errno code for unsupported batch ops
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 6:52 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> Em dom., 18 de abr. de 2021 =C3=A0s 19:56, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> escreveu:
> >
> > On Sun, Apr 18, 2021 at 1:03 PM Pedro Tammela <pctammela@gmail.com> wro=
te:
> > >
> > > ENOTSUPP is not a valid userland errno[1], which is annoying for
> > > userland applications that implement a fallback to iterative, report
> > > errors via 'strerror()' or both.
> > >
> > > The batched ops return this errno whenever an operation
> > > is not implemented for kernels that implement batched ops.
> > >
> > > In older kernels, pre batched ops, it returns EINVAL as the arguments
> > > are not supported in the syscall.
> > >
> > > [1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kern=
el.org/
> > >
> > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > ---
> > >  kernel/bpf/syscall.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index fd495190115e..88fe19c0aeb1 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -3961,7 +3961,7 @@ static int bpf_task_fd_query(const union bpf_at=
tr *attr,
> > >  #define BPF_DO_BATCH(fn)                       \
> > >         do {                                    \
> > >                 if (!fn) {                      \
> > > -                       err =3D -ENOTSUPP;        \
> > > +                       err =3D -EOPNOTSUPP;      \
> >
> > $ git grep EOPNOTSUPP kernel/bpf/|wc -l
> > 11
> > $ git grep ENOTSUPP kernel/bpf/|wc -l
> > 51
> >
> > For new code EOPNOTSUPP is better, but I don't think changing all 51 ca=
se
> > is a good idea. Something might depend on it already.
>
> OK, makes sense.
>
> Perhaps, handle this errno in 'libbpf_strerror()'?

That's a good idea.

> So language
> bindings don't get lost when dealing with this errno.

I'm not sure what you mean by "language bindings".
In general, strerror is not that useful. The kernel aliases
multiple conditions into the same error code. The error string
is too generic in practice to be useful.
