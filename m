Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6832A39B
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378971AbhCBJXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378837AbhCBJCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 04:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30C1264F14
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 09:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675718;
        bh=o3mCxuDJzYLePQJzSSI0Ar+My+bEW81VEOi2bsaAVK0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Rd7cdxyECEZhpIBxJb1hOSdY3K1SCI8G2PpC/LiUI2KKfRX5LpOJT8dUk/QwWGS3e
         WD4pOOy+AT0rtQm37k7pq7CnwlMO978yh2xLXGZlDwEFkGVxdWPoUYrqQcZUCAyz1P
         95F8erXRaPK8ma2UxhFd9tTr704u51q5il0h461Aa1VqTgD3o9sZrLYOeIW71dj8QT
         HXhI+yV/acgCvQowJav+YhkT8Stydhts5KLFZOL7c2Ovv8IflhRMWoAv5zguAdJQTy
         TzKt00bmyZT/aF/jtkgDb0CtE9mw+VbSASI78Ja2s2wzQ4jw/J+FZrUr3ziJ6vyM0E
         HjXWMMHIQ+Z8A==
Received: by mail-ot1-f48.google.com with SMTP id x9so14964048otp.8
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 01:01:58 -0800 (PST)
X-Gm-Message-State: AOAM530W8w4bkjKi19/o7ybgpn0lyb26HWMkjGt/vVBTES9JvORbr4Ra
        2P0WuntGBMgxA9jY3sXa20gn43gcorSuiVU4aPw=
X-Google-Smtp-Source: ABdhPJwSJtXcu7/XJp1q0qytYriJjt/SZXaBJMnPi4Ir2Dr8knR4IbC07MLIbW6+AwM7pghjWzCWrj9Y5LgGDcBAaSc=
X-Received: by 2002:a05:6830:1b65:: with SMTP id d5mr891656ote.305.1614675717341;
 Tue, 02 Mar 2021 01:01:57 -0800 (PST)
MIME-Version: 1.0
References: <20210212025641.323844-1-saeed@kernel.org> <20210212025641.323844-2-saeed@kernel.org>
 <CAK8P3a0b88NUZUebzxLx5J9Lz4r=s2AmxsWPRTvvQm6ieFnuww@mail.gmail.com> <47a3455638c908e3dd7301de3ff41c896bdb765e.camel@kernel.org>
In-Reply-To: <47a3455638c908e3dd7301de3ff41c896bdb765e.camel@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 2 Mar 2021 10:01:40 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0RvXYoWfBOP0m6E_T2=ySQzxtsohT1Lc4qX8NQAqBVTw@mail.gmail.com>
Message-ID: <CAK8P3a0RvXYoWfBOP0m6E_T2=ySQzxtsohT1Lc4qX8NQAqBVTw@mail.gmail.com>
Subject: Re: [net 01/15] net/mlx5e: E-switch, Fix rate calculation for overflow
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 1:52 AM Saeed Mahameed <saeed@kernel.org> wrote:
> On Sat, 2021-02-27 at 13:14 +0100, Arnd Bergmann wrote:
> > On Fri, Feb 12, 2021 at 3:59 AM Saeed Mahameed <saeed@kernel.org>
> > wrote:
> > >
> > > From: Parav Pandit <parav@nvidia.com>
> > >
> > > rate_bytes_ps is a 64-bit field. It passed as 32-bit field to
> > > apply_police_params(). Due to this when police rate is higher
> > > than 4Gbps, 32-bit calculation ignores the carry. This results
> > > in incorrect rate configurationn the device.
> > >
> > > Fix it by performing 64-bit calculation.
> >
> > I just stumbled over this commit while looking at an unrelated
> > problem.
> >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > index dd0bfbacad47..717fbaa6ce73 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > > @@ -5040,7 +5040,7 @@ static int apply_police_params(struct
> > > mlx5e_priv *priv, u64 rate,
> > >          */
> > >         if (rate) {
> > >                 rate = (rate * BITS_PER_BYTE) + 500000;
> > > -               rate_mbps = max_t(u32, do_div(rate, 1000000), 1);
> > > +               rate_mbps = max_t(u64, do_div(rate, 1000000), 1);
> >
> > I think there are still multiple issues with this line:
> >
> > - Before commit 1fe3e3166b35 ("net/mlx5e: E-switch, Fix rate
> > calculation for
> >   overflow"), it was trying to calculate rate divided by 1000000, but
> > now
> >   it uses the remainder of the division rather than the quotient. I
> > assume
> >   this was meant to use div_u64() instead of do_div().
> >
>
> Yes, I already have a patch lined up to fix this issue.

ok

> > - Both div_u64() and do_div() return a 32-bit number, and '1' is a
> > constant
> >   that also comfortably fits into a 32-bit number, so changing the
> > max_t
> >   to return a 64-bit type has no effect on the result
> >
>
> as of the above comment, we shouldn't be using the return value of
> do_div().

Ok, I was confused here because do_div() returns a 32-bit type,
and is called by div_u64(). Of course that was nonsense because
do_div() returns the 32-bit remainder, while the division result
remains 64-bit.

> > - The maximum of an arbitrary unsigned integer and '1' is either one
> > or zero,
> >    so there doesn't need to be an expensive division here at all.
> > From the
> >    comment it sounds like the intention was to use 'min_t()' instead
> > of 'max_t()'.
> >    It has however used 'max_t' since the code was first introduced.
> >
>
> if the input rate is less that 1mbps then the quotient will be 0,
> otherwise we want the quotient, and we don't allow 0, so max_t(rate, 1)
> should be used, what am I missing ?

And I have no idea what I was thinking here, of course you are right
and there is no other bug.

       Arnd
