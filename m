Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEDF3033F2
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAZFKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbhAYN2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 08:28:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CC39230FF;
        Mon, 25 Jan 2021 13:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611581284;
        bh=Wcrnt9a6tlwxFh75n05d6QTgYKpioPtAnTptCbWjZQE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o5SF/z9ajMcRl62SRaNmYtqXooicbAi3WW1iN7z1ytWd8ah8MwFUz1d/eL7XcjQjm
         agFH14nXax/5dw/LCR/DdIvIrE4anBG67k52El622HblrkujOZ1/yx+nftxJBv2p/C
         WPKaneuEimgr2mhNLvWVzE/eEyy55/g+DWg3Z9nieG0aHTiFJ1Z/UZc9pOcLj1Aikt
         m/Pxm3Mouz+wt84THQprjnGcJasL6rcAbaF2DAwMcIbIYTA1wG419NkxKuEwLSBWbm
         C48mh9yf6IX+VePx1JNCrOrAowxzlI1iDY874ZHMi0kPpRs3cy6D8HLUV+yXxUfb+v
         KRIeVkH4M5baw==
Received: by mail-ej1-f42.google.com with SMTP id ox12so18055160ejb.2;
        Mon, 25 Jan 2021 05:28:04 -0800 (PST)
X-Gm-Message-State: AOAM532lG9SFXC8IvFt1qhoIv6aZS2hG3ovn/xcreiuno7aJtt2H2C3J
        Yzu27eVNIz4YMifjL5wvxx9NAqIGOmAHcsk1qZg=
X-Google-Smtp-Source: ABdhPJwAZH0y+1uWVKT0bIlmN1qPDw4htbVM71bDR5Huc/2JDMSjtc6HKqDT/J2Dz91sFUk5PmuimiPuO2LL2lmqUiM=
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr349032ejd.215.1611581282765;
 Mon, 25 Jan 2021 05:28:02 -0800 (PST)
MIME-Version: 1.0
References: <20210125113654.2408057-1-arnd@kernel.org> <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
 <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
In-Reply-To: <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 25 Jan 2021 14:27:51 +0100
X-Gmail-Original-Message-ID: <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
Message-ID: <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 at 14:09, Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Mon, Jan 25, 2021 at 12:40 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > On Mon, 25 Jan 2021 at 12:36, Arnd Bergmann <arnd@kernel.org> wrote:
> > >
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > When CONFIG_ATH9K is built-in but LED support is in a loadable
> > > module, both ath9k drivers fails to link:
> > >
> > > x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
> > > gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
> > > x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
> > > gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
> > >
> > > The problem is that the 'imply' keyword does not enforce any dependency
> > > but is only a weak hint to Kconfig to enable another symbol from a
> > > defconfig file.
> > >
> > > Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
> > > configuration but still allows building the driver without LED support.
> > >
> > > The 'select MAC80211_LEDS' is now ensures that the LED support is
> > > actually used if it is present, and the added Kconfig dependency
> > > on MAC80211_LEDS ensures that it cannot be enabled manually when it
> > > has no effect.
> >
> > But we do not want to have this dependency (selecting MAC80211_LEDS).
> > I fixed this problem here:
> > https://lore.kernel.org/lkml/20201227143034.1134829-1-krzk@kernel.org/
> > Maybe let's take this approach?
>
> Generally speaking, I don't like to have a device driver specific Kconfig
> setting 'select' a subsystem', for two reasons:
>
> - you suddenly get asked for tons of new LED specific options when
>   enabling seemingly benign options
>
> - Mixing 'depends on' and 'select' leads to bugs with circular
>   dependencies that usually require turning some other 'select'
>   into 'depends on'.
>
> The problem with LEDS_CLASS in particular is that there is a mix of drivers
> using one vs the other roughly 50:50.

Yes, you are right, I also don't like it. However it was like this
before my commit so I am not introducing a new issue. The point is
that in your choice the MAC80211_LEDS will be selected if LEDS_CLASS
is present, which is exactly what I was trying to fix/remove. My WiFi
dongle does not have a LED and it causes a periodic (every second)
event. However I still have LEDS_CLASS for other LEDS in the system.

Best regards,
Krzysztof

On Mon, 25 Jan 2021 at 14:09, Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Mon, Jan 25, 2021 at 12:40 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > On Mon, 25 Jan 2021 at 12:36, Arnd Bergmann <arnd@kernel.org> wrote:
> > >
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > When CONFIG_ATH9K is built-in but LED support is in a loadable
> > > module, both ath9k drivers fails to link:
> > >
> > > x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
> > > gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
> > > x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
> > > gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
> > >
> > > The problem is that the 'imply' keyword does not enforce any dependency
> > > but is only a weak hint to Kconfig to enable another symbol from a
> > > defconfig file.
> > >
> > > Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
> > > configuration but still allows building the driver without LED support.
> > >
> > > The 'select MAC80211_LEDS' is now ensures that the LED support is
> > > actually used if it is present, and the added Kconfig dependency
> > > on MAC80211_LEDS ensures that it cannot be enabled manually when it
> > > has no effect.
> >
> > But we do not want to have this dependency (selecting MAC80211_LEDS).
> > I fixed this problem here:
> > https://lore.kernel.org/lkml/20201227143034.1134829-1-krzk@kernel.org/
> > Maybe let's take this approach?
>
> Generally speaking, I don't like to have a device driver specific Kconfig
> setting 'select' a subsystem', for two reasons:
>
> - you suddenly get asked for tons of new LED specific options when
>   enabling seemingly benign options
>
> - Mixing 'depends on' and 'select' leads to bugs with circular
>   dependencies that usually require turning some other 'select'
>   into 'depends on'.
>
> The problem with LEDS_CLASS in particular is that there is a mix of drivers
> using one vs the other roughly 50:50.
>
>       Arnd
