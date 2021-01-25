Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC2303386
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 05:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbhAZE6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbhAYMOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:14:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A9822B3B;
        Mon, 25 Jan 2021 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611574857;
        bh=6D5DQ40HGM9bv3hJpq+RCwIVOaKeM70frKbqsE8znNs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G9GnVDUAGX+OfnPvn3gL+SN38nLclH5OZ0K4v111vpvFJ/KkSpmpONmzwQd+loQQ4
         PYGpP348v4ZGBWsLoD9rA+nEu6O3i3Ed+NmKg2TQcnS49V5voqNT4NDpwEJ+tL2j9F
         B5Aq/+8H9NbWY3PJeFSzYt0QNRea8KGKho6M27rXLtfWdwH2m3qNmYkAXx0BcR+y1c
         a+HuJlJo0wdTVSqgtmmesvY8o6Xj8HzAmuZUJB2B5Qzo4rZIfB01HPsDiaYcJOiKoQ
         i5Y3tlrf2YgIuDHmx9h2LTAcb5V1j0TQCE58aK2QaCZ601ns23YHRsU4677jkIQfKe
         gK5/cwVqNT0XQ==
Received: by mail-ed1-f52.google.com with SMTP id j13so14895866edp.2;
        Mon, 25 Jan 2021 03:40:56 -0800 (PST)
X-Gm-Message-State: AOAM531QCaEeqYlv1cK3uwrg4us7LCWhWk95PnBJLBmhimO53YGZR3rT
        RYw/M271kAAhO/PolC0zztVwWo9auHTolW16ZZ0=
X-Google-Smtp-Source: ABdhPJynjF22NzGKJULN+rk02lXwoPJNjqn1Evfhz0gaK9ahQzC3HawPa96aanqNiT5p5HKgN533f+6lp7738Dc7uq0=
X-Received: by 2002:aa7:c308:: with SMTP id l8mr101170edq.246.1611574855267;
 Mon, 25 Jan 2021 03:40:55 -0800 (PST)
MIME-Version: 1.0
References: <20210125113654.2408057-1-arnd@kernel.org>
In-Reply-To: <20210125113654.2408057-1-arnd@kernel.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 25 Jan 2021 12:40:43 +0100
X-Gmail-Original-Message-ID: <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
Message-ID: <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 at 12:36, Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When CONFIG_ATH9K is built-in but LED support is in a loadable
> module, both ath9k drivers fails to link:
>
> x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
> gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
> x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
> gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
>
> The problem is that the 'imply' keyword does not enforce any dependency
> but is only a weak hint to Kconfig to enable another symbol from a
> defconfig file.
>
> Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
> configuration but still allows building the driver without LED support.
>
> The 'select MAC80211_LEDS' is now ensures that the LED support is
> actually used if it is present, and the added Kconfig dependency
> on MAC80211_LEDS ensures that it cannot be enabled manually when it
> has no effect.

But we do not want to have this dependency (selecting MAC80211_LEDS).
I fixed this problem here:
https://lore.kernel.org/lkml/20201227143034.1134829-1-krzk@kernel.org/
Maybe let's take this approach?

Best regards,
Krzysztof

>
> Fixes: 197f466e93f5 ("ath9k_htc: Do not select MAC80211_LEDS by default")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig | 8 ++------
>  net/mac80211/Kconfig                   | 2 +-
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index a84bb9b6573f..e150d82eddb6 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -21,11 +21,9 @@ config ATH9K_BTCOEX_SUPPORT
>  config ATH9K
>         tristate "Atheros 802.11n wireless cards support"
>         depends on MAC80211 && HAS_DMA
> +       select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
>         select ATH9K_HW
>         select ATH9K_COMMON
> -       imply NEW_LEDS
> -       imply LEDS_CLASS
> -       imply MAC80211_LEDS
>         help
>           This module adds support for wireless adapters based on
>           Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
> @@ -176,11 +174,9 @@ config ATH9K_PCI_NO_EEPROM
>  config ATH9K_HTC
>         tristate "Atheros HTC based wireless cards support"
>         depends on USB && MAC80211
> +       select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
>         select ATH9K_HW
>         select ATH9K_COMMON
> -       imply NEW_LEDS
> -       imply LEDS_CLASS
> -       imply MAC80211_LEDS
>         help
>           Support for Atheros HTC based cards.
>           Chipsets supported: AR9271
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index cd9a9bd242ba..51ec8256b7fa 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -69,7 +69,7 @@ config MAC80211_MESH
>  config MAC80211_LEDS
>         bool "Enable LED triggers"
>         depends on MAC80211
> -       depends on LEDS_CLASS
> +       depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
>         select LEDS_TRIGGERS
>         help
>           This option enables a few LED triggers for different
> --
> 2.29.2
>
