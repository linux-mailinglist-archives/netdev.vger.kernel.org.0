Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4B33F0057
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhHRJXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:23:23 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41550 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhHRJXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:23:20 -0400
Received: by mail-lf1-f51.google.com with SMTP id y34so3228314lfa.8;
        Wed, 18 Aug 2021 02:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=px7UgFG6E5mTzVJ1HJVqacatEH28xso/Wk3PeVQ1roc=;
        b=bGr7D6z3wiE7kBNRpYIfZnuYKpZfTc/QO7wh262KnR1diuYM+B37u8MjDLGWNbQEh3
         yHxCyFD4cQ3I/H3ueBtSuTEmLD0dVNnwtsV9YNlVdmwenkIyiD81Ks+WN3AoivY6i5Ve
         FPahT43/PopTVpv2gLRALTEayD9nnz9tgCrFHbbGDAJOjwvrhl9guLsSsHMT4fXHXFX7
         bPjBhuN2Q2fDhPB/7/kPZN7XqTnQIILRlrlp4kjs91qe11fHt+Gn7QQyE9+Liz0YyfMq
         6JH7bfvHZm5BlbRHoxMLQfMPbeX9ZbsasocH/G5FF6S8l/6KSu2Z1dj2dTXWdHmASEdu
         iH+w==
X-Gm-Message-State: AOAM530PjeZibKNHKgFAUaspBbun7PfOBInZM9isv8mFjVXK7Siir6OL
        OgoeypKAgrs16a4h3r6MgJ1IU0YgzmWkztMeb4g=
X-Google-Smtp-Source: ABdhPJzQVkytK0wd558pspDu3Fqy+acPbMPxrwPsKAEbRDI6Q7RrbO7spPpJfnd4/Elqx5ASQrQ11WyoqNlDmWiGjxE=
X-Received: by 2002:ac2:4e8c:: with SMTP id o12mr5869825lfr.374.1629278565189;
 Wed, 18 Aug 2021 02:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de> <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
 <20210817200123.4wcdwsdfsdjr3ovk@pengutronix.de>
In-Reply-To: <20210817200123.4wcdwsdfsdjr3ovk@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 18:22:33 +0900
Message-ID: <CAMZ6RqKsjPF2gBbzsKatFG7S4qcOahSX9vSU=dj_e9R-Kqq0CA@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 18 Aug 2021 at 05:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 17.08.2021 00:49:35, Vincent MAILHOL wrote:
> > > We have 4 operations:
> > > - tdc-mode off                  switch off tdc altogether
> > > - tdc-mode manual tdco X tdcv Y configure X and Y for tdco and tdcv
> > > - tdc-mode auto tdco X          configure X tdco and
> > >                                 controller measures tdcv automatically
> > > - /* nothing */                 configure default value for tdco
> > >                                 controller measures tdcv automatically
> >
> > The "nothing" does one more thing: it decides whether TDC should
> > be activated or not.
> >
> > > The /* nothing */ operation is what the old "ip" tool does, so we're
> > > backwards compatible here (using the old "ip" tool on an updated
> > > kernel/driver).
> >
> > That's true but this isn't the real intent. By doing this design,
> > I wanted the user to be able to transparently use TDC while
> > continuing to use the exact same ip commands she or he is used
> > to using.
>
> Backwards compatibility using an old ip tool on a new kernel/driver must
> work.

I am not trying to argue against backward compatibility :)
My comment was just to point out that I had other intents as well.

> In case of the mcp251xfd the tdc mode must be activated and tdcv
> set to the automatic calculated value and tdco automatically measured.

Sorry but I am not sure if I will follow you. Here, do you mean
that "nothing" should do the "fully automated" calculation?

In your previous message, you said:

> Does it make sense to let "mode auto" without a tdco value switch the
> controller into full automatic mode and /* nothing */ not tough the tdc
> config at all?

So, you would like this behavior:

| "nothing" -> TDC is off (not touch the tdc config at all)
| mode auto, no tdco provided -> kernel decides between TDC_AUTO and TDC off.
| mode auto, tdco provided -> TDC_AUTO
| mode manual, tdcv and tdco provided -> TDC_MANUAL
| mode off is not needed anymore (redundant with "nothing")
(TDCF left out of the picture intentionally)

Correct?

If you do so, I see three issues:

1/ Some of the drivers already implement TDC. Those will
automatically do a calculation as long as FD is on. If "nothing"
now brings TDC off, some users will find themselves with some
error on the bus after the iproute2 update if they continue using
the same command.

2/ Users will need to read and understand how to use the TDC
parameters of iproute2. And by experience, too many people just
don't read the doc. If I can make the interface transparent and
do the correct thing by default ("nothing"), I prefer to do so.

3/ Final one is more of a nitpick. The mode auto might result in
TDC being off. If we have a TDC_AUTO flag, I would expect the
auto mode to always set that flag (unless error occurs). I see
this to be slightly counter intuitive (I recognize that my
solution also has some aspects which are not intuitive, I just
want to point here that none are perfect).


To be honest, I really preferred the v1 of this series where
there were no tdc-mode {auto,manual,off} and where the "off"
behavior was controlled by setting TDCO to zero. However, as we
realized, zero is a valid value and thus, I had to add all this
complexity just to allow that damn zero value.


Yours sincerely,
Vincent
