Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D1348E698
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 09:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiANIdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 03:33:49 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:40820 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiANIdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 03:33:49 -0500
Received: by mail-ua1-f52.google.com with SMTP id w21so6260022uan.7;
        Fri, 14 Jan 2022 00:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sy7lT+eK8ipvfv0Ofk1ldO/tYfoiahfm+fHSJgI7+Xs=;
        b=CxrkKtDb0bQBRSg8bGzObzfkMdWdLj+QaLq822JccgbrkrtZJ9qsALhOtRkSxpnAlJ
         +LztWhgqlj+q0gde1w9ZTIWrepAi+U+Zv54+5uM047NoVi43FkAVp28d2X20DwgfN+sO
         OdVftcRsaD4JmuvNDHnlIsTIfczli/RvobUGFa+UzTxo4qIr0sEicHl1W9e41ZTaJWlg
         baWu3JFEUz6l06Hh5IvRvCKwltDZo0ZP1vOKz3+V6GUzsrk+606t9HFPwbnAJAQeqHKc
         U4FqQMa7ZQY9LVVMaqVodT7e8Gm1Pgfhlye+WYllSPsaDKLGQ+5oHP9q3dF5KK1lzSBJ
         n31A==
X-Gm-Message-State: AOAM5314EITKksdxyh/QwVSin2Bx9CxICv01OJ2vqGKTgu2fdt8fkAPo
        BDGNPd/TrI4OPZRK/Mr6WchoYdt35/C8pA==
X-Google-Smtp-Source: ABdhPJznBeXDe9YRtuIahv0G00H8XbqbgcbaGO0fg9iFPtOdW6MJAg7mNOptcVSx7GL9N5nXHk4bQA==
X-Received: by 2002:a05:6102:807:: with SMTP id g7mr3435871vsb.65.1642149228403;
        Fri, 14 Jan 2022 00:33:48 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id c25sm2446948vsk.32.2022.01.14.00.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 00:33:47 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id o1so15732561uap.4;
        Fri, 14 Jan 2022 00:33:47 -0800 (PST)
X-Received: by 2002:a67:e905:: with SMTP id c5mr3691251vso.68.1642149227718;
 Fri, 14 Jan 2022 00:33:47 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com> <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
In-Reply-To: <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Jan 2022 09:33:36 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV_4HjvbpDsbhomxO3JSv-MOWDzb-8vc2=prc_KgTPA1g@mail.gmail.com>
Message-ID: <CAMuHMdV_4HjvbpDsbhomxO3JSv-MOWDzb-8vc2=prc_KgTPA1g@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Thu, Jan 13, 2022 at 11:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Thu, Jan 13, 2022 at 4:27 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > On 1/13/22, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > Nack.
> > > It's part of api. We cannot change it.
> >
> > This is an RFC patchset, so there's no chance that it'll actually be
> > applied as-is, and hence there's no need for the strong hammer nack.
> > The point of "request for comments" is comments. Specifically here,
> > I'm searching for information on the ins and outs of *why* it might be
> > hard to change. How does userspace use this? Why must this 64-bit
> > number be unchanged? Why did you do things this way originally? Etc.
> > If you could provide a bit of background, we might be able to shake
> > out a solution somewhere in there.
>
> There is no problem with the code and nothing to be fixed.

"Your Jedi mind tricks don't work on me."

The "problem" is that this is one of the few last users of SHA-1 in
the kernel.

Can you please answer the questions above, so we can get a better
understanding?
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
