Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B89D42F6D6
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbhJOPTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230246AbhJOPTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 11:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 583E3604E9;
        Fri, 15 Oct 2021 15:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634311020;
        bh=0P/nqlzCxPBNYjpNGvCgDjhUfvGhQ4sWoGMp6EBS3EQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QfIIeWcPiv3PwB/krvJVEO32ocEy2fGPpblJMrJsmTChX2GH6N6v0Fg4rjAzjLnbp
         aEtfIMNHHSfLdPkjGBg2idWqyxm5iUSclTAmnJPaBo60gucmoqlckcJqJGNIUr2Apa
         inWnaRnL0v9yW3+UQxiwtuCjzc1n3Zw6gE08/lsrAbV1WjRq/oyJCJMtP8vo1Bd+IS
         EM2qVtap060vWwLHLSb4tUFuqiNz8rrveP5HtWMF4/a0s5u3Jp5TZIoHZnyvQ7mVJ9
         R7H3o+zPzqBkYUdV85KJuW16JR9Ihrx9ZdQT9Sj49JSC2n+85aRua9Wk5U+wwcQyoX
         6LIqUnvh0BouQ==
Received: by mail-wr1-f43.google.com with SMTP id e12so27133431wra.4;
        Fri, 15 Oct 2021 08:17:00 -0700 (PDT)
X-Gm-Message-State: AOAM5333+Me3sXrhzhO8ev3dhrki51aqjCc3aYy3g01FUmVBe8kbl+6b
        x6h6b5SrM0leEkVGoDAlJu+iAVClds1lG+9HdP0=
X-Google-Smtp-Source: ABdhPJxEPK+TqBi5jntB9NZ2aiQ169wvUQqCk0nO/GYgvmQPSRyiZRUTCn36xHT9UsW2ewN4zNDGavkD+wcIhmpOVJQ=
X-Received: by 2002:adf:b1c4:: with SMTP id r4mr15042210wra.428.1634311018725;
 Fri, 15 Oct 2021 08:16:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211013150232.2942146-1-arnd@kernel.org> <328f581e-7f1d-efc3-036c-66e729297e9c@gmail.com>
 <132eb082-c646-765b-7b32-8a9943d10d0e@nvidia.com>
In-Reply-To: <132eb082-c646-765b-7b32-8a9943d10d0e@nvidia.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 15 Oct 2021 17:16:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0QR8a6vxp6r_RtN5QvwxR-umKy6Ye7VNyyt_1BS4yQ7Q@mail.gmail.com>
Message-ID: <CAK8P3a0QR8a6vxp6r_RtN5QvwxR-umKy6Ye7VNyyt_1BS4yQ7Q@mail.gmail.com>
Subject: Re: [PATCH] mlx5: allow larger xsk chunk_size
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 3:27 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> > On 10/13/2021 6:02 PM, Arnd Bergmann wrote:
> >> From: Arnd Bergmann <arnd@arndb.de>
> >>
> >> When building with 64KB pages, clang points out that xsk->chunk_size
> >> can never be PAGE_SIZE:
> >>
> >> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:19:22: error:
> >> result of comparison of constant 65536 with expression of type 'u16'
> >> (aka 'unsigned short') is always false
> >> [-Werror,-Wtautological-constant-out-of-range-compare]
> >>          if (xsk->chunk_size > PAGE_SIZE ||
> >>              ~~~~~~~~~~~~~~~ ^ ~~~~~~~~~
> >>
> >> I'm not familiar with the details of this code, but from a quick look
> >> I found that it gets assigned from a 32-bit variable that can be
> >> PAGE_SIZE, and that the layout of 'xsk' is not part of an ABI or
> >> a hardware structure, so extending the members to 32 bits as well
> >> should address both the behavior on 64KB page kernels, and the
> >> warning I saw.
>
> This change is not enough to fix the behavior. mlx5e_xsk_is_pool_sane
> checks that chunk_size <= 65535. Your patch just silences the warning,
> but doesn't improve 64 KB page support.
>
> While mlx5e_xsk_is_pool_sane is simply a sanity check, it's not enough
> to remove it to support 64 KB pages. It will need careful review of
> assumptions in data path, because many places use 16-bit values for
> packet size and headroom, and it comes down to the hardware interface
> (see mpwrq_get_cqe_byte_cnt - the hardware passes the incoming packet
> size as a 16-bit value) and hardware limitations.
>
> For example, MLX5_MPWQE_LOG_STRIDE_SZ_MAX is defined to 13 (Tariq, is it
> a hardware limitation or just an arbitrary value?), which means the max
> stride size in striding RQ is 2^13 = 8192, which will make the driver
> fall back to legacy RQ (slower). We also need to check if legacy RQ
> works fine with such large buffers, but so far I didn't find any reason
> why not.
>
> I genuinely think allocating 64 KB per packet is waste of memory, and
> supporting it isn't very useful, as long as it's possible to use smaller
> frame sizes, and given that it would be slower because of lack of
> striding RQ support.

Fair enough. I wouldn't be concerned about wasting memory here,
as 64KB pages are much more wasteful in other areas already, but
if there are no possible upsides and making it work is hard, then
we don't need to bother.

> It could be implemented as a feature for net-next, though, but only
> after careful testing and expanding all relevant variables (the hardware
> also uses a few bits as flags, so the max frame size will be smaller
> than 2^32 anyway, but hopefully bigger than 2^16 if there are no other
> limitations).
>
> For net, I suggest to silence the warning in some other way (cast type
> before comparing?)

Ok, sending the trivial workaround as v2 now.

        Arnd
