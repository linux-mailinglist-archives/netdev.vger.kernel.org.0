Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E70326CF8
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 13:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhB0MP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 07:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhB0MP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 07:15:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B921364EAF
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 12:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614428085;
        bh=3QkaViothu18tlq9U8ksk/VuMzHzzRFuGuIDJLHSbRs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WEM1yXSGoELBIyQK8P0OM+b8R4xQvXnAXTHLKWGzpPDy8oLXJ798AWtFEkGlkl6C6
         NIoiTFn87vj6vBqpMJRW3Q/JI7B7Mc5RNZM13b70EKB261F8yNfM8bcIJb9TRiwK/a
         RkVnWI518jwOzhZ2aoUI+I1aNrIScNyPgMYJVgxNaq2fqPSc09omlB7JZIStx3SHKT
         28EErTUgSqBb+Gmo264i6BVNpbIjHHaFzSSzlwWq2XW+l61W0sW7Zig7E7HYW7x/hK
         J2PENDmnBN4dKG5UdD8Izqj/NBNDKTsEu3hKi/UXqnf9FbrCqFcQb7bZrCj78iIiGx
         1JpGjsApnOfDg==
Received: by mail-ot1-f43.google.com with SMTP id v12so10652380ott.10
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 04:14:45 -0800 (PST)
X-Gm-Message-State: AOAM5322yBaMlV86+ZbxlEeW75s4Wqj4aoBdh3VH/chgpVZ0lKM64wSY
        ztYjQV1AsgWiLPbqm5UyJp68x2OCIpBvMVA+xWY=
X-Google-Smtp-Source: ABdhPJzgV9adQUy+lCNMaGfIsXKexSZ3BvV8C3i4yeK9mmw1zSXifzO1GKu71Ht+IJgbkbqZ1mP0X/8xaqoM2Px0UMM=
X-Received: by 2002:a9d:6b8b:: with SMTP id b11mr6058839otq.210.1614428085085;
 Sat, 27 Feb 2021 04:14:45 -0800 (PST)
MIME-Version: 1.0
References: <20210212025641.323844-1-saeed@kernel.org> <20210212025641.323844-2-saeed@kernel.org>
In-Reply-To: <20210212025641.323844-2-saeed@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 27 Feb 2021 13:14:28 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0b88NUZUebzxLx5J9Lz4r=s2AmxsWPRTvvQm6ieFnuww@mail.gmail.com>
Message-ID: <CAK8P3a0b88NUZUebzxLx5J9Lz4r=s2AmxsWPRTvvQm6ieFnuww@mail.gmail.com>
Subject: Re: [net 01/15] net/mlx5e: E-switch, Fix rate calculation for overflow
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 3:59 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> From: Parav Pandit <parav@nvidia.com>
>
> rate_bytes_ps is a 64-bit field. It passed as 32-bit field to
> apply_police_params(). Due to this when police rate is higher
> than 4Gbps, 32-bit calculation ignores the carry. This results
> in incorrect rate configurationn the device.
>
> Fix it by performing 64-bit calculation.

I just stumbled over this commit while looking at an unrelated
problem.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index dd0bfbacad47..717fbaa6ce73 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -5040,7 +5040,7 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
>          */
>         if (rate) {
>                 rate = (rate * BITS_PER_BYTE) + 500000;
> -               rate_mbps = max_t(u32, do_div(rate, 1000000), 1);
> +               rate_mbps = max_t(u64, do_div(rate, 1000000), 1);

I think there are still multiple issues with this line:

- Before commit 1fe3e3166b35 ("net/mlx5e: E-switch, Fix rate calculation for
  overflow"), it was trying to calculate rate divided by 1000000, but now
  it uses the remainder of the division rather than the quotient. I assume
  this was meant to use div_u64() instead of do_div().

- Both div_u64() and do_div() return a 32-bit number, and '1' is a constant
  that also comfortably fits into a 32-bit number, so changing the max_t
  to return a 64-bit type has no effect on the result

- The maximum of an arbitrary unsigned integer and '1' is either one or zero,
   so there doesn't need to be an expensive division here at all. From the
   comment it sounds like the intention was to use 'min_t()' instead
of 'max_t()'.
   It has however used 'max_t' since the code was first introduced.

        Arnd
