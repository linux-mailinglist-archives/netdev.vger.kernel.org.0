Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D6A6D4BA3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbjDCPSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjDCPSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:18:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81481B3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:18:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h31so17701213pgl.6
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680535096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMfyOVX8KLzQUrWuvFrHx63/iYdsUy6rjrW+Fwfoiog=;
        b=q40Kgh+Cpydmb3PYzt/xJhefe70NECV8xm6LCpkIgKjydYrgQMEl0ZxXi7gOP8+ZxH
         t30Ykd8PxFgUNL3NW1BiVc0mCqnDZ66WUIbISlCxr4Pki9KB6I1BQc+/pU0Ch1/W/INY
         IubJV/gQsD0raEJLekzXV3NJxG6WIlLvQaf0WywMkad0HflulYQutPQCWcabFv7bPFiR
         jvJUY/cz2D+gRe6wxPiAimsAnL2Iwl4VzrA3XGzBKNtlGRufvlZH59QGc8nqvw4VZPY5
         rt9DYe8afTZeyjYV28CW56Jip+lz9fh4HwYuopEk2XsjavOw/KZVCUlWPIQOLdedXx6/
         pXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680535096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMfyOVX8KLzQUrWuvFrHx63/iYdsUy6rjrW+Fwfoiog=;
        b=FvhCuptQPhpBHTg0jRiXM+RCUG0rAIRAT2tDOuiJy1xNX0a8HWwtNi7F2oiAgN52tn
         kfNq2qVGfqkcwOrbmew7rQYoCSzM3Ltf2kuOeOV4iYx5VLA7j27Oa88725oYSIRaL6MF
         L46q26j9DKHuWisoANb7zUXEl9iSCkwTm3pjIe8su6fz0G27JyWEnuEjiSrMldlNpVUp
         3cObqfwZgS2Hb2Upxq1C1iydAIlJgo2cJ4u3k8myWxT9aHSSAvNcu8I2igKvFprwR/BH
         KEJndL0yLrvipmhZu7WuvM5oCiaDLgbF8NdtK024yzTmfY3+3UuKTtTwOZVXvqjPsDL3
         +ZKw==
X-Gm-Message-State: AAQBX9dpAUUCu1HU7MfyB7zzqK1WSdU87pd+F0hvHA2nbi3yYnSKYvVn
        c111QjIIgumKimJS5+T1IKgPbjldIUnqlR1Vb60=
X-Google-Smtp-Source: AKy350ZBzdu9+rCLCx0o9YyTp+Y21bsDUCRlngxJr4/0+7u8E9Li3JZqX71J4G5NKdhC3v40xfz+rK1KprHtOdMrl20=
X-Received: by 2002:a63:4920:0:b0:50b:cf00:7d2e with SMTP id
 w32-20020a634920000000b0050bcf007d2emr9758326pga.11.1680535095772; Mon, 03
 Apr 2023 08:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230401051221.3160913-1-kuba@kernel.org> <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com> <20230401115854.371a5b4c@kernel.org>
In-Reply-To: <20230401115854.371a5b4c@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 3 Apr 2023 08:18:04 -0700
Message-ID: <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 1, 2023 at 11:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sat, 1 Apr 2023 17:18:12 +0200 Heiner Kallweit wrote:
> > > +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_=
cond) \
> > > +   ({                                                              \
> > > +           int _res;                                               \
> > > +                                                                   \
> > > +           _res =3D -1;                                             =
 \
> >
> > One more question: Don't we need a read memory barrier here to ensure
> > get_desc is up-to-date?
>
> CC: Alex, maybe I should not be posting after 10pm, with the missing v2
> and sparse CC list.. :|
>
> I was thinking about this too yesterday. AFAICT this implementation
> could indeed result in waking even tho the queue is full on non-x86.
> That's why the drivers have an extra check at the start of .xmit? :(

The extra check at the start is more historical than anything else.
Logic like that has been there since the e1000 days. I think it
addressed items like pktgen which I think didn't make use of the
stop/wake flags way back when. I'll add in Herbet who was the original
author for this code so he can add some additional history if needed.

> I *think* that the right ordering would be:
>
> WRITE cons
> mb()  # A
> READ stopped
> rmb() # C
> READ prod, cons

What would the extra rmb() get you? The mb() will have already flushed
out any writes and if stopped is set the tail should have already been
written before setting it.

One other thing to keep in mind is that the wake gives itself a pretty
good runway. We are talking about enough to transmit at least 2
frames. So if another consumer is stopping it we aren't waking it
unless there is enough space for yet another frame after the current
consumer.

> And on the producer side (existing):
>
> WRITE prod
> READ prod, cons
> mb()  # B
> WRITE stopped
> READ prod, cons
>
> But I'm slightly afraid to change it, it's been working for over
> a decade :D

I wouldn't change it. The code has predated BQL in the e1000 driver
and has been that way since the inception of it I believe in 2.6.19.

> One neat thing that I noticed, which we could potentially exploit
> if we were to touch this code is that BQL already has a smp_mb()
> on the consumer side. So on any kernel config and driver which support
> BQL we can use that instead of adding another barrier at #A.
>
> It would actually be a neat optimization because right now, AFAICT,
> completion will fire the # A -like barrier almost every time.

Yeah, the fact is the barrier in the wake path may actually be
redundant if BQL is enabled. My advice is if you are wanting to get a
better idea of how this was setup you could take a look at the e1000
driver in the 2.6.19 kernel as that was where this code originated and
I am pretty certain it predates anything in any of the other Intel
drivers other than maybe e100.
