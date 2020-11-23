Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09BB2C1433
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgKWTHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgKWTHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:07:35 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D17C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 11:07:35 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id e81so15351117ybc.1
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 11:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADoGlm1BrknNB0Bnqx7/vfiwgrgmIJO/536XKKlvfdI=;
        b=HvO/Mc//utp1B+ec6macvlK2FTHTHmV9wAWndSMRvGT1MZZPFXhKWwQVJC7scRw0Vl
         2K1zq4U4r3uJ7uuweqV3gPdT2V68jxNmCDCv0zovp0ZelCE3udanZaYEvBJj1tjvRsrR
         VhH9bxhA413+GsjTv21dsCEhmQmbXC5AhMvt3TGphlUDCUKeHlzzPkG2WTPBaiB7e+BE
         53H8q7Fi/5USdYAsM/E810stCUwLjZvTGtb6G4wh0f+Wfomn7SQeg7ss+/E/DNuzYvVU
         5QP0rgliU34dZ4vhXtnbVHEhkBu6eqTu8eqAj5+jPW4txL9vucWKCW6fskUfzP5V6BCJ
         QrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADoGlm1BrknNB0Bnqx7/vfiwgrgmIJO/536XKKlvfdI=;
        b=uaSHvcski14S2mpE1249Gk1WLeT7M8li2XGuHtcZSHfdQtzBcnLFFN2nuCIQFzTyj4
         TW1oNB9uZO8yY9ei8XUc6ZiI2vnKSa5ba1n2v+l2m3yR5k/b7Mu/A9BHxxvYtor3Plba
         LiobJHUs+JaeKpK+uHG9wzGaA8yRb3gsz4TCc+GgufK5gvO99b3Aqbcj1D/H5zNx5eMf
         1j1tV1+Xa8+7ajfds6UWWBA8ppjfiFdhK73ZmAlerinQZuVbqFLc40N3gLoQ1sHDUddZ
         7Lioa68Cx/scwTYJrzEhCvLNS0148Ld43VEAAvkyNcYZErSueUAmE4YqL6YnL92kuSyV
         1QxA==
X-Gm-Message-State: AOAM533fkx4/b/otLo1FLwYlvqC9XvHQtt+WbkYmV8xyGM5lN04wwRlp
        6NFQ+GW4pl9AOyluVsa3MvG5AlBrdVwJYySBMEidbQ==
X-Google-Smtp-Source: ABdhPJxNROv0CH1DzFJpgeoNKCe1WbFjfTRkYwsbO93Ve7qNlmuhWiclYSg7dmXOgCZb4pmrUTlTOgP8I9B7Es4mtFY=
X-Received: by 2002:a25:ac19:: with SMTP id w25mr1688521ybi.278.1606158454404;
 Mon, 23 Nov 2020 11:07:34 -0800 (PST)
MIME-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com> <20201118191009.3406652-2-weiwan@google.com>
 <20201121163136.024d636c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAEA6p_ATLr-=xQ8cZLJE3cbWn=cFx11kpWm0cV2J2hiaOVFPzg@mail.gmail.com> <20201123105647.3ae683ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123105647.3ae683ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 23 Nov 2020 11:07:23 -0800
Message-ID: <CAEA6p_C_VeM-PvasfN91p-903db=zVXCT6bWuRDuMiW7j2WDjw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/5] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 10:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 21 Nov 2020 18:23:33 -0800 Wei Wang wrote:
> > On Sat, Nov 21, 2020 at 4:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 18 Nov 2020 11:10:05 -0800 Wei Wang wrote:
> > > > +int napi_set_threaded(struct napi_struct *n, bool threaded)
> > > > +{
> > > > +     ASSERT_RTNL();
> > > > +
> > > > +     if (n->dev->flags & IFF_UP)
> > > > +             return -EBUSY;
> > > > +
> > > > +     if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> > > > +             return 0;
> > > > +     if (threaded)
> > > > +             set_bit(NAPI_STATE_THREADED, &n->state);
> > > > +     else
> > > > +             clear_bit(NAPI_STATE_THREADED, &n->state);
> > >
> > > Do we really need the per-NAPI control here? Does anyone have use cases
> > > where that makes sense? The user would be guessing which NAPI means
> > > which queue and which bit, currently.
> >
> > Thanks for reviewing this.
> > I think one use case might be that if the driver uses separate napi
> > for tx and rx, one might want to only enable threaded mode for rx, and
> > leave tx completion in interrupt mode.
>
> Okay, but with separate IRQs/NAPIs that's really a guessing game in
> terms of NAPI -> bit position. I'd rather we held off on the per-NAPI
> control.
>

Yes. That is true. The bit position is dependent on the driver implementation.

> If anyone has a strong use for it now, please let us know.

OK. Will change it to per dev control if no one objects.
