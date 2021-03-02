Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE7A32A2C5
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381759AbhCBIcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234867AbhCBAxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 19:53:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F1F60232;
        Tue,  2 Mar 2021 00:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614646357;
        bh=3WraZ07sWC3YpGrcWTkxg1NpTy/JpKJ43ndaffAE2yY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TwFpDBT/9DpFXWII0GkW8dcLjFBBVZiF5TEq5mepbdZF+1p91N/Ij6r8GITU7OGKC
         zEXujZSRPHL5viX4zUVI4/hQIGCCkv2wcgEeqBtH59PQKARtOjjeF8l9pCvIJ2UE2x
         8IFWauTUpfzpIo1Zlh+kOPJN5ycgVp1KKdACIzfOntOjQ8h56ue4iybItLiDJhCTmY
         FgClnoLpdbPSrxtRDbryG3wLaRod4zZFNTKrF9pTgv8sdlBHEXjF5iaADJhpv47iBK
         GHdTw+X7vC0t+UoffAHTATPV4UqgVeO5Pw1/cEnXD68oRiSxk0lwj0ShKQhZjNyYtQ
         YF57VHwIoTG9g==
Message-ID: <47a3455638c908e3dd7301de3ff41c896bdb765e.camel@kernel.org>
Subject: Re: [net 01/15] net/mlx5e: E-switch, Fix rate calculation for
 overflow
From:   Saeed Mahameed <saeed@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>
Date:   Mon, 01 Mar 2021 16:52:35 -0800
In-Reply-To: <CAK8P3a0b88NUZUebzxLx5J9Lz4r=s2AmxsWPRTvvQm6ieFnuww@mail.gmail.com>
References: <20210212025641.323844-1-saeed@kernel.org>
         <20210212025641.323844-2-saeed@kernel.org>
         <CAK8P3a0b88NUZUebzxLx5J9Lz4r=s2AmxsWPRTvvQm6ieFnuww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-02-27 at 13:14 +0100, Arnd Bergmann wrote:
> On Fri, Feb 12, 2021 at 3:59 AM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > 
> > From: Parav Pandit <parav@nvidia.com>
> > 
> > rate_bytes_ps is a 64-bit field. It passed as 32-bit field to
> > apply_police_params(). Due to this when police rate is higher
> > than 4Gbps, 32-bit calculation ignores the carry. This results
> > in incorrect rate configurationn the device.
> > 
> > Fix it by performing 64-bit calculation.
> 
> I just stumbled over this commit while looking at an unrelated
> problem.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index dd0bfbacad47..717fbaa6ce73 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -5040,7 +5040,7 @@ static int apply_police_params(struct
> > mlx5e_priv *priv, u64 rate,
> >          */
> >         if (rate) {
> >                 rate = (rate * BITS_PER_BYTE) + 500000;
> > -               rate_mbps = max_t(u32, do_div(rate, 1000000), 1);
> > +               rate_mbps = max_t(u64, do_div(rate, 1000000), 1);
> 
> I think there are still multiple issues with this line:
> 
> - Before commit 1fe3e3166b35 ("net/mlx5e: E-switch, Fix rate
> calculation for
>   overflow"), it was trying to calculate rate divided by 1000000, but
> now
>   it uses the remainder of the division rather than the quotient. I
> assume
>   this was meant to use div_u64() instead of do_div().
> 

Yes, I already have a patch lined up to fix this issue.

Thanks for spotting this.

> - Both div_u64() and do_div() return a 32-bit number, and '1' is a
> constant
>   that also comfortably fits into a 32-bit number, so changing the
> max_t
>   to return a 64-bit type has no effect on the result
> 

as of the above comment, we shouldn't be using the return value of
do_div().


> - The maximum of an arbitrary unsigned integer and '1' is either one
> or zero,
>    so there doesn't need to be an expensive division here at all.
> From the
>    comment it sounds like the intention was to use 'min_t()' instead
> of 'max_t()'.
>    It has however used 'max_t' since the code was first introduced.
> 

if the input rate is less that 1mbps then the quotient will be 0,
otherwise we want the quotient, and we don't allow 0, so max_t(rate, 1)
should be used, what am I missing ?


