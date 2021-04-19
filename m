Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918CC36454A
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhDSNwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhDSNwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:52:49 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3DFC06174A;
        Mon, 19 Apr 2021 06:52:19 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id p8so13542536iol.11;
        Mon, 19 Apr 2021 06:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gt16QylDheR8xWPIXKNaPKZyKT22Q7EnSGM+4gpD6LU=;
        b=Qcu4HYLP7VaVWZd53EmrWCBNaY1QjDxJR0cq6lPZzYYjdhZn4nzGtb/Rtnt6Q19rVl
         HYaWJqJxWG2zfycNh2IOHx3qJGB5H7we92AEVfZ1I2Vf98VoLjELgYipsR+7JXH1nzJc
         m/wPw5m9s+7WpykoGSZDxvS3yxHb1Kkr+wlDkHU6ysWxzLw2ipuw1Uq0FJtJQ5e8j3Ms
         J/hoqXtCPl8yBFvwpv2r4zzwLyKHIX2HRs+TjpQtFEsXSRII2RTe+Chd7ZWeQnIZA2cY
         viVsjITptAzeR0+FPYmek8MZpKs1J7Je8ksDtT0cpq7pqErjoLdPMkx5l/MaicaU/csz
         pw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gt16QylDheR8xWPIXKNaPKZyKT22Q7EnSGM+4gpD6LU=;
        b=CEAFuGUDSrqFa7SpPsC2/1XskkFYodvs+IPJTVAAymKk6Y8eGpwfT3mC9dgY8c1vcJ
         KpuJav8cuk9g63KqbBBtabuBR8nX3VjY1AjCeZwh04t5jffiyjqsiawQ5S9ixRfGpOwS
         0olTeQE02Ljk90tG6SAq8V8fmxpVDrEeb+0QT7Ze0XgUwwmuB5eHUtXK5kN0gqRwgpt0
         Nbq2u7166OMx6In4phBOTlniDfJsrnReciqKbKOvxRcHxW8NlMfn03qGjFqSvx/Tk6Qb
         QHQnscK/qErIRy78vUY4i+Jfv6G23zX6Zz8Nf7PIhR6Tc1EoQ2/xbOHZ+G1ht1j5k0u/
         xrWw==
X-Gm-Message-State: AOAM5301SlzqUMoeWT3MWHRY+E+XSuJcmw8LJg7mEVQZ9cRhHo5sLphO
        c5AISc5JOLOH9WU9Qs65PT4G2G37JWHzmbEhnNA=
X-Google-Smtp-Source: ABdhPJzvI4WWzIaZrrMjXaqt0Ng/O9c2rA0Mbhx/YIaKUDttEbB23keXhYKY0wvkB6OeUb3UfIjN1gmho3Y0sYxlGgw=
X-Received: by 2002:a5e:9817:: with SMTP id s23mr5418212ioj.149.1618840338411;
 Mon, 19 Apr 2021 06:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210418200249.174835-1-pctammela@mojatatu.com> <CAADnVQLJDsnQ1YO9a_pQ-1aTJ1hNKYJXcSHypfzCare-c4HO1A@mail.gmail.com>
In-Reply-To: <CAADnVQLJDsnQ1YO9a_pQ-1aTJ1hNKYJXcSHypfzCare-c4HO1A@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Mon, 19 Apr 2021 10:52:07 -0300
Message-ID: <CAKY_9u0Ye9pt7igtxT8UR=Ro7=yNwUz2zQZDKH20NK92_LvgxA@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix errno code for unsupported batch ops
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

Em dom., 18 de abr. de 2021 =C3=A0s 19:56, Alexei Starovoitov
<alexei.starovoitov@gmail.com> escreveu:
>
> On Sun, Apr 18, 2021 at 1:03 PM Pedro Tammela <pctammela@gmail.com> wrote=
:
> >
> > ENOTSUPP is not a valid userland errno[1], which is annoying for
> > userland applications that implement a fallback to iterative, report
> > errors via 'strerror()' or both.
> >
> > The batched ops return this errno whenever an operation
> > is not implemented for kernels that implement batched ops.
> >
> > In older kernels, pre batched ops, it returns EINVAL as the arguments
> > are not supported in the syscall.
> >
> > [1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel=
.org/
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> >  kernel/bpf/syscall.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index fd495190115e..88fe19c0aeb1 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3961,7 +3961,7 @@ static int bpf_task_fd_query(const union bpf_attr=
 *attr,
> >  #define BPF_DO_BATCH(fn)                       \
> >         do {                                    \
> >                 if (!fn) {                      \
> > -                       err =3D -ENOTSUPP;        \
> > +                       err =3D -EOPNOTSUPP;      \
>
> $ git grep EOPNOTSUPP kernel/bpf/|wc -l
> 11
> $ git grep ENOTSUPP kernel/bpf/|wc -l
> 51
>
> For new code EOPNOTSUPP is better, but I don't think changing all 51 case
> is a good idea. Something might depend on it already.

OK, makes sense.

Perhaps, handle this errno in 'libbpf_strerror()'? So language
bindings don't get lost when dealing with this errno.
