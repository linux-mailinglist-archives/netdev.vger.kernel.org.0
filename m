Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EB9304A44
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbhAZFG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbhAYNJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 08:09:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60E6622DFB;
        Mon, 25 Jan 2021 13:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611580139;
        bh=1wOJZ4FJ0PDEC5fN/ovAq0qlFT12N+k1DDBGhO2O7QA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y4dbJP3GlaUG6C5bud5v0+kwerdEaatEI1wMDWOvu1BmAqZljetRou5TbiJ+LD/Ef
         NEGF0SMhONAhJLCqsg8i7Fnzsy/PPZg67ihvX89l/yoQFTnqWV7OF6d0egFmRblqGW
         U96OJ++SczGR51L4Xsqy24gMrY/MiFCed8uc5AvRzpdVh4bYYE/3o1GB7abw2I28/i
         OkuXTnoUhnaO3ht012O9+RCxmWfRA3QQXHX6GghvsgaexoxXzZDmG5/MA86cVa9Aws
         rD85ABL9KzahoX5/tUODJei6TktVS8tfFQC2J1AVJorn+0OpN4cDSdvFVg0si3NLqy
         aYhCTYXi/Sn0w==
Received: by mail-ot1-f42.google.com with SMTP id a109so12670218otc.1;
        Mon, 25 Jan 2021 05:08:59 -0800 (PST)
X-Gm-Message-State: AOAM5301Ykg7lOrr9n62AOVO/6RbpKVTkxzqHGoR1CC+P8sGGOvpSsSj
        xKOlAgNgslUTZUSgsxeoQk6/XNsEono9nBZvKqo=
X-Google-Smtp-Source: ABdhPJw43suOaoKizgEZR7ekOyty04AJ2IEReeT8qTkzlvQIMmG6vmgb4cCLrl26kiR4DHwpeYcwROPy2zVGS4C1Dkw=
X-Received: by 2002:a9d:741a:: with SMTP id n26mr386721otk.210.1611580138587;
 Mon, 25 Jan 2021 05:08:58 -0800 (PST)
MIME-Version: 1.0
References: <20210125113654.2408057-1-arnd@kernel.org> <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
In-Reply-To: <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 25 Jan 2021 14:08:42 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
Message-ID: <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
To:     Krzysztof Kozlowski <krzk@kernel.org>
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

On Mon, Jan 25, 2021 at 12:40 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Mon, 25 Jan 2021 at 12:36, Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When CONFIG_ATH9K is built-in but LED support is in a loadable
> > module, both ath9k drivers fails to link:
> >
> > x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
> > gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
> > x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
> > gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
> >
> > The problem is that the 'imply' keyword does not enforce any dependency
> > but is only a weak hint to Kconfig to enable another symbol from a
> > defconfig file.
> >
> > Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
> > configuration but still allows building the driver without LED support.
> >
> > The 'select MAC80211_LEDS' is now ensures that the LED support is
> > actually used if it is present, and the added Kconfig dependency
> > on MAC80211_LEDS ensures that it cannot be enabled manually when it
> > has no effect.
>
> But we do not want to have this dependency (selecting MAC80211_LEDS).
> I fixed this problem here:
> https://lore.kernel.org/lkml/20201227143034.1134829-1-krzk@kernel.org/
> Maybe let's take this approach?

Generally speaking, I don't like to have a device driver specific Kconfig
setting 'select' a subsystem', for two reasons:

- you suddenly get asked for tons of new LED specific options when
  enabling seemingly benign options

- Mixing 'depends on' and 'select' leads to bugs with circular
  dependencies that usually require turning some other 'select'
  into 'depends on'.

The problem with LEDS_CLASS in particular is that there is a mix of drivers
using one vs the other roughly 50:50.

      Arnd
