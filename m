Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651412F87BD
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 22:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbhAOVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 16:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbhAOVhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 16:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ECEA239EF
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610746589;
        bh=kl7XMO2pxB6Siim1iAIbS2+y/FB7jwjFF8HY7HsXO/k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ox+mLyrhkPgtDmoe6OELHRsVwqtTSZGYuqyQmVmZ7wny+p0uVII9V4ossdrFFhkTj
         vRpNKfCFERR1z1Ebwjh8ga75bRUY8bL073GkX8wxzhXc3ROPXpyimiqmPgMEMQosYd
         sYNWmBfs/jkdL9fSy+GjcGh02Srj7lRP4nSiMbZCJ7R8pRxQd636eSQ1S97VeQkQaJ
         0t56MlomSs5ev+J+JIITV7mytd4U2WnY2ZhzjUxhtBfegbKFzTT/eiPh4kZDwuchEL
         ArKHMcmzsbPTej9c4qiBW0lD1m4bYEF/hgXhli+foSQSDPNOU1KaQL/+H0OUPJlt57
         HrXAgZGYcZBCg==
Received: by mail-oo1-f43.google.com with SMTP id x203so2567794ooa.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 13:36:29 -0800 (PST)
X-Gm-Message-State: AOAM533hxpX84W56AM17FdaCjAIGVtkrSTj4yHBWgyweYiK17h9K2032
        QhCOO+jR5b9R8ZjedSiOW0cg2Ew3zYddWROJcSQ=
X-Google-Smtp-Source: ABdhPJyHlFy04+Ag5yX+YiM6cw6pWK7Tdc7mwWxooplU732FxM/VM1pDZPlmpMB1g6Gw5GYrJCE6BUTASf6mrzUQOfU=
X-Received: by 2002:a4a:4592:: with SMTP id y140mr9975289ooa.26.1610746588340;
 Fri, 15 Jan 2021 13:36:28 -0800 (PST)
MIME-Version: 1.0
References: <20210115134239.126152-1-marex@denx.de> <YAGuA8O0lr19l5lH@lunn.ch>
 <e000a5f4-53bb-a4e4-f032-3dbe394d5ea3@denx.de> <YAG79tfQXTVWtPJX@lunn.ch> <48be7af4-3233-c3dc-70a1-1197b7ad83d7@gmail.com>
In-Reply-To: <48be7af4-3233-c3dc-70a1-1197b7ad83d7@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 15 Jan 2021 22:36:12 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1A=Fa6dHvLKkqcmDwPGh2MsJfpTDwmRAjkn1++jAJUWA@mail.gmail.com>
Message-ID: <CAK8P3a1A=Fa6dHvLKkqcmDwPGh2MsJfpTDwmRAjkn1++jAJUWA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Vasut <marex@denx.de>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 6:24 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> On 15.01.2021 16:59, Andrew Lunn wrote:
> > On Fri, Jan 15, 2021 at 04:05:57PM +0100, Marek Vasut wrote:
> >> On 1/15/21 4:00 PM, Andrew Lunn wrote:
> >>> On Fri, Jan 15, 2021 at 02:42:39PM +0100, Marek Vasut wrote:
> >>>> When either the SPI or PAR variant is compiled as module AND the other
> >>>> variant is compiled as built-in, the following build error occurs:
> >>>>
> >>>> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> >>>> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
> >>>>
> >>>> Fix this by including the ks8851_common.c in both ks8851_spi.c and
> >>>> ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
> >>>> does not have to be defined again.
> >>>
> >>> DEBUG should not be defined for production code. So i would remove it
> >>> altogether.
> >>>
> >>> There is kconfig'ury you can use to make them both the same. But i'm
> >>> not particularly good with it.
> >>
> >> We had discussion about this module/builtin topic in ks8851 before, so I was
> >> hoping someone might provide a better suggestion.
> >
> > Try Arnd Bergmann. He is good with this sort of thing.
> >
> I'd say make ks8851_common.c a separate module. Then, if one of SPI / PAR
> is built in, ks8851_common needs to be built in too. To do so you'd have
> export all symbols from ks8851_common that you want to use in SPI /PAR.

Yes, that should work, as long the common module does not reference
any symbols from the other two modules (it normally wouldn't), and all
globals in the common one are exported.

You can also link everything into a single module, but then you have
to deal with registering two device_driver structures from a single
init function, which would undo some of cleanup.

       Arnd
