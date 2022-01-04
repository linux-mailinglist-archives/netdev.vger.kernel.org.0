Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5514B484323
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiADOOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiADOOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:14:40 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2430C061761;
        Tue,  4 Jan 2022 06:14:39 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id n30so36904178eda.13;
        Tue, 04 Jan 2022 06:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JWj20KokVmbJ1KQKxKTcG8eJrd73Z/FrzXrGHNXIYQ=;
        b=imO7AvZwhSqnGrvwQeVkNBV4cnKH740zTDdLNAdNiGGp8f1uzMHM0ttEykYxr4BWkl
         EkpRaK27dAFloGoRxR/z3ktW/nI2W1fjbRqdG/vW2Rzbz8W5GsA8BmfeRrBxDuIF6YAc
         gsobO4KfR1xNVt8kv6nGcpxJJ9MlEx03qb2MIeox+TvS6rChq2QG/jh5F3+3fjer/OWF
         EXugqwqpk99xC2zv8OvQkthpwRisIS48WSh2YJBvH28BpBkjlc+TAK11GHvyd2Zgw62T
         cNZrAoybRhVa0DH0GWIto1H1D3kAStNkvi9lWPyoQ8gZFkO8lzTMRwINGVlA8fhIRLo5
         s7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JWj20KokVmbJ1KQKxKTcG8eJrd73Z/FrzXrGHNXIYQ=;
        b=DsR2lMJofNzmgKf1icbosWwLFoDU5EA1iP/BLYwce7Gs8F8k+ODTbPYDJ4D5dUMNBv
         snPZ2mW0lnfJ9s6lMN0Pf++HGEl1AVUl2P4MZtMUDLqLB6GdCGTZeuG9V/vr/Ar5MgH0
         4IaOQWJ7E1TLR5zmnTkIHXgo856wdbGfQ5xlDooU9YN7W7PLtoUngsuAmFiJcrvSjpD1
         Oh/8HBSekFOlzBQdyYNJ28o0p4qA9mJr/ACl7tYfsx16R0uVe6tYMEF7P/owj+JrOF5L
         6irrro/Ik99nlufHghTL2OV11SRQgGfd+QJYU+rA4pg0OUBo7f7VGhlG46sziA+YjgiR
         RPUw==
X-Gm-Message-State: AOAM530IuWULbuDyBpNdWwR66K/MoKJyT0pMZFzegVfg/nX0wL6Ezk+C
        PKc54qvtZ9udkQRsI+bpTR9nwHlVBPHEkcopBN0=
X-Google-Smtp-Source: ABdhPJxFlwpFpUZdQ6bUszycW6INa0R+GLudK5872rFm8RVazA48OfXiqtyIAKFwq0RNQGHYzU8rSvivGo46xnrW/5g=
X-Received: by 2002:a17:906:3ed0:: with SMTP id d16mr38660386ejj.636.1641305678365;
 Tue, 04 Jan 2022 06:14:38 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-13-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-13-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 16:12:47 +0200
Message-ID: <CAHp75VdeNhmRUW1mFY-H5vyzTRHZ9Y2dv03eo+rfcTQKjn9tuQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/35] brcmfmac: pcie: Fix crashes due to early IRQs
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:
>
> The driver was enabling IRQs before the message processing was
> initialized. This could cause IRQs to come in too early and crash the
> driver. Instead, move the IRQ enable and hostready to a bus preinit
> function, at which point everything is properly initialized.
>
> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")

You should gather fixes at the beginning of the series, and even
possible to send them as a separate series. In the current state it's
unclear if there are dependencies on your new feature (must not be for
fixes that meant to be backported).

-- 
With Best Regards,
Andy Shevchenko
