Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE752CFFB4
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgLEXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:19:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgLEXTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:19:42 -0500
X-Gm-Message-State: AOAM532M7q8c08tqzjRCIMZtKe4/Blh38aKc6uY3j4HHbzAKLI9vCoIU
        0FZaH9BLYQ1RSui5aRnykAQJV28y7zsxxB03pbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607210342;
        bh=kk9JkuUd1l6t5I15Gl47hIZhXnkxQUPV0hK//SCxbYs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sbFs3/9LeGwXKZlrzxI3a6fEXB6TvwxZSGLkW7+uUuOJ9ifiMwP/NhD+RulAehH/o
         Q/JJ2AaLU2J3UuQDcDyMndAjrW+WmHMtDOn8GnVRM5CQPfRTOf0sovorZVKOzpZWwl
         UjAKULjp2RNMLXTQe7jdgkfPgbX8MNjeImQvG/gisjdNGI8zod+uWkqqQp2f5N3yi3
         JAGvP50jwKt5vy/4NXMgcRgj47iuoYqczX7g4CzZ54tAG5iV2nG0W1sKbv44KkjnT1
         nQ78YPIvCJF9d/IvSodzngRT4qLiQOZ4AFMFTP281sRHc9tYV1q+RRoeYIzMX9OlZR
         PKCmOFxhJ/CGg==
X-Google-Smtp-Source: ABdhPJw4C2b0Bs2vlfH95fq1FqF2vx8kqDiaMQgJG5XmB9BtXVyiwBcA2oJoiLGvtfvnV5cqe0iQlN0YneU93fsax0c=
X-Received: by 2002:a9d:be1:: with SMTP id 88mr8458633oth.210.1607210341377;
 Sat, 05 Dec 2020 15:19:01 -0800 (PST)
MIME-Version: 1.0
References: <20201203222641.964234-1-arnd@kernel.org> <20201204175745.1cd433f7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204175745.1cd433f7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 6 Dec 2020 00:18:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3TuKAC60HAjiyHwy7ciQp=mCNKjmG5jcaCFWe8ysVCuA@mail.gmail.com>
Message-ID: <CAK8P3a3TuKAC60HAjiyHwy7ciQp=mCNKjmG5jcaCFWe8ysVCuA@mail.gmail.com>
Subject: Re: [PATCH] ch_ktls: fix build warning for ipv4-only config
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 2:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  3 Dec 2020 23:26:16 +0100 Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When CONFIG_IPV6 is disabled, clang complains that a variable
> > is uninitialized for non-IPv4 data:
> >
> > drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1046:6: error: variable 'cntrl1' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >         if (tx_info->ip_family == AF_INET) {
> >             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1059:2: note: uninitialized use occurs here
> >         cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
> >         ^~~~~~
> >
> > Replace the preprocessor conditional with the corresponding C version,
> > and make the ipv4 case unconditional in this configuration to improve
> > readability and avoid the warning.
> >
> > Fixes: 86716b51d14f ("ch_ktls: Update cheksum information")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> This is for evrey clang build or just W=1+? Would be annoying if clang
> produced this on every build with 5.10 (we need to decide fix vs -next).

The -Wsometimes-uninitialized is enabled unconditionally for clang,
but this only happens for IPv4-only configurations with IPv6 disabled,
so most real configurations should not observe it, but the fix should still
go into v5.10.

      Arnd
