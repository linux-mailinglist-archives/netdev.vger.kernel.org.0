Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE749385E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353704AbiASKZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbiASKYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:24:30 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2838BC061574;
        Wed, 19 Jan 2022 02:24:30 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id h206-20020a1c21d7000000b0034d95625e1fso5297258wmh.4;
        Wed, 19 Jan 2022 02:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=23T4xOW2I0F1J8h1VBHMXa/Hl9U+ZT3rpxlsT4/aGfc=;
        b=YsEHE2FoxTIEDYdQkjHZoP/fMCSt7QDmBQ4JdVPHxM4mlnOCzYop6XchK4rNHKQtf+
         EB550obMnV3f5ZhHcIk/AxpQ8rIFuitjP2WoGDxLwZPMERXqneeB/TZ8sQCaB/Na7dAD
         gBFFTaU95S2gXYoC1ejMoGbHiqPSliY7DgwtbQkFJB0qfSMMdRfOMiiSSiPIlGi9YkfW
         SF6KUmqLmY0Vm9eUK4+qdupPRPxxj4ZT74ftdKfK9m/t115DOzfVBBOGbky0j7JF+4xS
         /laydDlP6PnfNM7FjGBWQC6AyMUnubEMwTk5FqFL60694tozYxQKd8zFSgAVHk04Owxb
         LpWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=23T4xOW2I0F1J8h1VBHMXa/Hl9U+ZT3rpxlsT4/aGfc=;
        b=wp71PNOw7uY9/OJcFWEXNEREiiehw2o2wtyR0AoKRfpKxjOVNAeuHDsU1xQhR+e/pf
         4vTLMgzUjcBEyzK6XVxR5IaAis1Q4HLs/k5aKuk3I941zWh4DmpY7sGlfLzZlB4wswj/
         ibNtmpIIO90BCA+e7IE54qfvDQPO27MCokYnZGddxbpFxldZCdzepuIoaGugLW54xs56
         oD8iMR7P+yrCYxQNXecxtfpAL46IQFs+voh3rL2sVh1SNaKN7Sj4zujtnNvX3UxnCpdg
         tfElr111tKLjJGKQb3yiZOPvW1hxw65giPYVy9B5zNqOVgtRXkIaJAzqxBrx9cCFhyIg
         1ghA==
X-Gm-Message-State: AOAM530N5Q7n+yD6DH151KyOplkCydNiKxJMv71N/7JN4E21sKh96hvL
        k0N3MKJuyq9P6kVac7v15wO+2kXi812TE7t8E44=
X-Google-Smtp-Source: ABdhPJyQ5Tdq7m8t7iLiOJAS4JTEijMM4at1JFtGA1ZF2R8mUGyIx8zXbXyxAiL39Qfm4S+aXM2whQ60Ky+y/NvZSKQ=
X-Received: by 2002:adf:d08b:: with SMTP id y11mr27706022wrh.384.1642587868723;
 Wed, 19 Jan 2022 02:24:28 -0800 (PST)
MIME-Version: 1.0
References: <20220110165208.1826-1-jszhang@kernel.org> <Ydxljv2Q4YNDYRTx@xhacker>
In-Reply-To: <Ydxljv2Q4YNDYRTx@xhacker>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 19 Jan 2022 11:24:16 +0100
Message-ID: <CAJ+HfNiS7Ss0FJowPUrrKvuC+1Kn9gXb=VqNoqh3eWJDu=m4Mg@mail.gmail.com>
Subject: Re: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
To:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, palmer@rivosinc.com,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jisheng/Palmer,

On Mon, 10 Jan 2022 at 18:05, Jisheng Zhang <jszhang@kernel.org> wrote:
>
> On Tue, Jan 11, 2022 at 12:52:08AM +0800, Jisheng Zhang wrote:
> > eBPF's exception tables needs to be modified to relative synchronously.
> >
> > Suggested-by: Tong Tiangen <tongtiangen@huawei.com>
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Nice catch, and apologies for the slow response.

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> > ---
> >  arch/riscv/net/bpf_jit_comp64.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_c=
omp64.c
> > index 69bab7e28f91..44c97535bc15 100644
> > --- a/arch/riscv/net/bpf_jit_comp64.c
> > +++ b/arch/riscv/net/bpf_jit_comp64.c
> > @@ -498,7 +498,7 @@ static int add_exception_handler(const struct bpf_i=
nsn *insn,
> >       offset =3D pc - (long)&ex->insn;
> >       if (WARN_ON_ONCE(offset >=3D 0 || offset < INT_MIN))
> >               return -ERANGE;
> > -     ex->insn =3D pc;
> > +     ex->insn =3D offset;
>
> Hi Palmer,
>
> Tong pointed out this issue but there was something wrong with my email
> forwarding address, so I didn't get his reply. Today, I searched on
> lore.kernel.org just found his reply, sorry for inconvenience.
>

AFAIK, Jisheng's extable work is still in Palmer's for-next tree.

Daniel/Alexei: This eBPF must follow commit 1f77ed9422cb ("riscv:
switch to relative extable and other improvements"), which is in
Palmer's tree. It cannot go via bpf-next.

Palmer, please pull this to your for-next tree.


Thanks,
Bj=C3=B6rn
