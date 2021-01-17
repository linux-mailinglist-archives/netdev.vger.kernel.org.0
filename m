Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEF22F91B8
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 11:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbhAQKWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 05:22:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbhAQKWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 05:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A0D820C56
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 10:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610878924;
        bh=d1xWKCG+gIUwVlwPRL7k/nVxtsMRdtAP6nnRmMxIfhE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b9atr8PVO4HbepX176u2GuWleXcnxW+uGbX60dfpzKPSOV7msoP8NsGY3Szl735AE
         q5p79q4CiV+q+lL3Bx5TAugxOrmmmyhX+DLzW/e6wZWqBRCGqy43hPrA8ezFv+BWlS
         jah7QLNSINZqYhr97lnwwAPkQ7MPqKGiz9IVJvZCQdo3VSk7oYxk8eFqcdKBgFk9/3
         RPOt1sguSB7dtTpif8VCwcB7NazHIrUjxwbiZGBDjYGQ8jMr30cSjUWfesPUXo7e8F
         uGqgnSqnG4KLIsae2hSz7TkNQSlkmGgbkt1BJTn5+ssvctxq0ZI6raLZF1q5ytbyAs
         kQwSvmGbHqMWA==
Received: by mail-ot1-f47.google.com with SMTP id n42so13335270ota.12
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 02:22:04 -0800 (PST)
X-Gm-Message-State: AOAM532/brKkQxt1JoxL2fq7XgDQ2cAzB9Q2pxOKipdFeygA1OugMX0i
        rPKLGhCU4vlP1TIKKEvZT7ThHHW0OhhedVwBbtQ=
X-Google-Smtp-Source: ABdhPJyUkjW91BCUQ5+vPPy9Po8vwT5xQmikmD3WAWBFDa86YmDFBT7tLyCTqU7dAAuXZ/58fuDBXPh28KWiHwO38Kc=
X-Received: by 2002:a9d:741a:: with SMTP id n26mr7029939otk.210.1610878923870;
 Sun, 17 Jan 2021 02:22:03 -0800 (PST)
MIME-Version: 1.0
References: <20210116164828.40545-1-marex@denx.de> <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
 <a660f328-19d9-1e97-3f83-533c1245622e@denx.de> <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
 <20210116203945.GA32445@wunner.de> <a6d74297-b29e-956e-5861-40cee359e892@denx.de>
 <de224620-474d-0853-4ddc-a2f88f79fbcc@gmail.com>
In-Reply-To: <de224620-474d-0853-4ddc-a2f88f79fbcc@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 17 Jan 2021 11:21:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3bDRvsTqtqxNp782OUy3e6Lib3eN3OSjjRh25x5Lkbuw@mail.gmail.com>
Message-ID: <CAK8P3a3bDRvsTqtqxNp782OUy3e6Lib3eN3OSjjRh25x5Lkbuw@mail.gmail.com>
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marek Vasut <marex@denx.de>, Lukas Wunner <lukas@wunner.de>,
        Networking <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 10:41 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> It seems unlikely that a system uses both, the parallel *and* the SPI
> >> variant of the ks8851.  So the additional memory necessary because of
> >> code duplication wouldn't matter in practice.
> >
> > I have a board with both options populated on my desk, sorry.
>
> Making the common part a separate module shouldn't be that hard.
> AFAICS it would just take:
> - export 4 functions from common
> - extend Kconfig
> - extend Makefile
> One similar configuration that comes to my mind and could be used as
> template is SPI_FSL_LIB.

There is no need to even change Kconfig, just simplify the Makefile to

obj-$(CONFIG_KS8851) += ks8851_common.o ks8851_spi.o
obj-$(CONFIG_KS8851_MLL) += ks8851_common.o ks8851_par.o

This will do the right thing and build ks8851_common.ko into
vmlinux if at least one of the two front-ends is built-in, and
otherwise build it at a loadable module if there is another
module using it.

         Arnd
