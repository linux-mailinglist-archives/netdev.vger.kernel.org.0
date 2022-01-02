Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F51F4829EA
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiABGD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiABGD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:03:28 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0DBC06173E
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:03:28 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id o12so68589219lfk.1
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eOSEt2UYspkO7KlpH0taqWCjFFVAh5LxlRawNiLoSCA=;
        b=tGCb3hDZ09NPFPr6FT12MbJtVURDBtkxRXV2FAUpIK+IdsXRbxxLlxD5RF8xeHOlEc
         rdmSfOvohYAfAqnQntjwxXcMrg8fpekXTKeiEFtU+MjoWUpWzrz6GxsLS2PcAK2OmQEy
         YumzH+DZG7mHqw7l6y3F2G18Ru+zT6NqLuwsAIkADGyZ4dRhzF7YoWyMV5/9RlP8Nu+b
         z51JezLya73SyPTWGXQTVea/ARxo88mAjh5xPmHLM3Y+UnVUeA3Ir/OY3xosGv89OQP1
         vyZohRjymVa7nmmoZKQUluLyyA9P0Wnp6d0ZturGsebk89CRpkHYtSDzYi333r+AjIv+
         uUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eOSEt2UYspkO7KlpH0taqWCjFFVAh5LxlRawNiLoSCA=;
        b=Yl5NluzfXWYfQpxVB/AXNxQLr6c9cCqAPkZImi7OWgN0JFj4ccqkyjzjaIebsl088Z
         VrushuYRnvcDCyJnc5+DkDjxH8+OVej0zVLrVp2FMt/GDsTaN4ubtfQahMv8l4ezKU7F
         Kf2Gq+D8xDbibpju5xo0Bsx5UGvvxft+qY3ynsfQbvr7BJBiknEcrUml5gInAAS41JbO
         KW2ZbGk9kZa7nHUjT9ePovAwaK8jLG3nWtGI24BVR4tJYj1Msm0W/thQIHHnE1bK28q1
         YRbxRM1RQWP6ComrlM+rOvrAmV71NSeAXw0C9DbZwMPxojDs5v8qH3693TbBMYMCDIE8
         Jh8g==
X-Gm-Message-State: AOAM530X5jJtgcrObafrT8dyS7i5CYOyZfdO13ELjMHE3lAQKzcUbYUJ
        qET4Lb5tdPSB+tga8qNoYTnVp5GDGqvC1G46WvXXtg==
X-Google-Smtp-Source: ABdhPJyUsJK/0aqdGyEKpwuU7vg2NlhR00lEWpxX20MF2aZZkZEtuybziC46nnAcrr7lYQhYJfFsFAUfCpx4oTaGd/A=
X-Received: by 2002:a05:6512:2303:: with SMTP id o3mr36790809lfu.362.1641103406623;
 Sat, 01 Jan 2022 22:03:26 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-22-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-22-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:03:14 +0100
Message-ID: <CACRpkdaPwG7gQd6Zk81NH_u2ZzPA8=33kCThm+SPn_fywBm6AQ@mail.gmail.com>
Subject: Re: [PATCH 21/34] brcmfmac: chip: Only disable D11 cores; handle an
 arbitrary number
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
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 4:39 PM Hector Martin <marcan@marcan.st> wrote:

> At least on BCM4387, the D11 cores are held in reset on cold startup and
> firmware expects to release reset itself. Just assert reset here and let
> firmware deassert it. Premature deassertion results in the firmware
> failing to initialize properly some of the time, with strange AXI bus
> errors.
>
> Also, BCM4387 has 3 cores, up from 2. The logic for handling that is in
> brcmf_chip_ai_resetcore(), but since we aren't using that any more, just
> handle it here.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
