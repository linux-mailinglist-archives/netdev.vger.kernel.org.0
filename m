Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007D15FFCA
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 05:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfGEDly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 23:41:54 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44931 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbfGEDlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 23:41:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so6012503qtg.11
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 20:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNksPQ+a6LXq8db+Dw4OJOgNhGrCLmReslnkT14eo4U=;
        b=K3X9Th2kR+FpbObMQC5vGJwaKgEaXQ+qlodCTGoLEfnJcVlfZX9P5YWdyUoPmTVJpO
         1U7tNXA5xeh2cp9m5UsJUJC8d254S3AyBzQakVFKSZzedFmUoXM2BTxTV5WyCOTxnC2h
         eXWnYZI4nicmXoj+xr9LNu4GeufKGt9/sFWNRmQa49UaLSX4nlCrKq1E/whqrIOn6Sux
         eTqaefONPhVfntQNVB9QN7EI/6Tiwj0nY4cCm5IhD81g20LEAresP2qPUWbi8l6UTzfp
         utyXD62pwMCoXNo/5X591F1OzghGcg2xulJYLvjXFWaB7xK/Ja0e6xGFzcEX9wBt0ZVc
         aEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNksPQ+a6LXq8db+Dw4OJOgNhGrCLmReslnkT14eo4U=;
        b=TDwBo2L0eR9nFtLjOzpKqQ7kdjypWTjq9ZyvigUB7QifZenWnznbV6Wwx2/lVylfnM
         L7miNDubdrglx3xj44NLVS9erA6yKLu7FCdnXWOdprkxTGd+Jvl+tF6pHHYfZpz3PJFh
         Aye/ECsyUTy0iTvwjC7OrFXs76LUDVBW9qmYYepOkKG6ECD5ghilye9rnOQ1pRtfvUrI
         Ki6vJhYHy3uwqlx+hx/A3/q73eooQ7d83ARI/9GRQ7ea/R4XKSY47mgmyOvc1pBJV2Ef
         4FVTx/zy9Ow0Jo7l9NQ/DI8nMiY7myOEjDZesMK1VR1m9hMBSiiq9Rd2MigQY1ayUuMc
         HN7Q==
X-Gm-Message-State: APjAAAVKhbUrD1cBrP3d3QnvcOBIm+6MMLw3lrmDgDZBNCq0g3R1q9Cc
        1tlvn31mj62WxOI+n/dAa2POYMZMiSbNJeQbjJ0PSQ==
X-Google-Smtp-Source: APXvYqwXWzYcjQij3doAHDi9lJcxfefyacZTXp/ajLN7K/CoFno3PvlDWnYeLlU3mzs7SVpYED9ewekftLQUfUmVKVg=
X-Received: by 2002:aed:3644:: with SMTP id e62mr877924qtb.80.1562298112714;
 Thu, 04 Jul 2019 20:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190704105528.74028-1-chiu@endlessm.com>
In-Reply-To: <20190704105528.74028-1-chiu@endlessm.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Fri, 5 Jul 2019 11:41:41 +0800
Message-ID: <CAD8Lp45rYuE5WHx4vSbUhF10hOHam1aBLd52_aDKP8z2eeL4vA@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 6:55 PM Chris Chiu <chiu@endlessm.com> wrote:
> The WiFi tx power of RTL8723BU is extremely low after booting. So
> the WiFi scan gives very limited AP list and it always fails to
> connect to the selected AP. This module only supports 1x1 antenna
> and the antenna is switched to bluetooth due to some incorrect
> register settings.
>
> Compare with the vendor driver https://github.com/lwfinger/rtl8723bu,
> we realized that the 8723bu's enable_rf() does the same thing as
> rtw_btcoex_HAL_Initialize() in vendor driver. And it by default
> sets the antenna path to BTC_ANT_PATH_BT which we verified it's
> the cause of the wifi weak tx power. The vendor driver will set
> the antenna path to BTC_ANT_PATH_PTA in the consequent btcoexist
> mechanism, by the function halbtc8723b1ant_PsTdma.

Checking these details in the vendor driver:
EXhalbtc8723b1ant_PowerOnSetting sets:
        pBoardInfo->btdmAntPos = BTC_ANTENNA_AT_AUX_PORT;

Following the code flow from rtw_btcoex_HAL_Initialize(), this has a
bWifiOnly parameter which will ultimately influence the final register
value.
Continuing the flow, we reach halbtc8723b1ant_SetAntPath() with
bInitHwCfg=TRUE, bWifiOff=FALSE. antPosType is set to WIFI in the
bWifiOnly case, and BT otherwise.

I'm assuming that bUseExtSwitch = FALSE (existing rtl8xxxu code also
seems to make the same assumption).
For the bWifiOnly=FALSE case, it uses BT,
                    pBtCoexist->fBtcWrite4Byte(pBtCoexist, 0x948, 0x0);
and rtl8xxxu seems to do the same - seemingly routing the antenna path
for BT only.

As for halbtc8723b1ant_PsTdma() then being called in a way that causes
it to switch to the PTA path a little later, it's more difficult to
point out how that happens in an email, but I thin kwe can trust you
on that :) There are certainly many callsites that would pass those
parameters.

> +        * Different settings per different antenna position.
> +        *      Antenna Position:   | Normal   Inverse
> +        * --------------------------------------------------
> +        * Antenna switch to BT:    |  0x280,   0x00
> +        * Antenna switch to WiFi:  |  0x0,     0x280
> +        * Antenna switch to PTA:   |  0x200,   0x80
>          */
> -       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> +       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);

I don't really understand what we mean by an "inverse" antenna and my
reading of the vendor driver leads me to another interpretation.

The logic is based around an antenna position - btdmAntPos. It takes
one of two values:
    BTC_ANTENNA_AT_MAIN_PORT                = 0x1,
    BTC_ANTENNA_AT_AUX_PORT                = 0x2,

So the chip has pins to support two antennas - a "main" antenna and an
"aux" one.

We know we're dealing with a single antenna, so the actual module is
going to only be using one of those antenna interfaces. If the chip
tries to use the other antenna interface, it's effectively not using
the antenna. So it's rather important to tell the chip to use the
right interface.

And that's exactly what happens here. btdmAntPos is hardcoded that the
antenna is on the aux port for these devices, and this code is telling
the chip that this is how things are wired up.

The alternative way of calling this an antenna inverse (which the
vendor driver also does in another section), i.e. "antenna is not
connected to the main port but instead it's connected to the other
one", seems less clear to me.

Even if we don't fully understand what's going on here, I'm convinced
that your code change is fixing an inconsistency with the vendor
driver, and most significantly, making the signal level actually
usable on our devices. But if you agree with my interpretation of
these values then maybe you could update the comment here!

Daniel
