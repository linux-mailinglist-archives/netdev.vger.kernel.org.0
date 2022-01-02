Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C27B482A07
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiABGPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiABGPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:15:17 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2E0C061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:15:17 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x6so15708117lfa.5
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWErgVPSbPgPS0cot2KuzsoxPnk5t2poaH8xxZaNOfk=;
        b=yDNjcq4g15xOFHBXQDmYyXN8EZZbyJUjHUrUfjBIRdjYkk4XhGgviRbuxzqnIhrwHI
         IAixxYAZhkVclfTndwOLRDv2dL2UFC3tvno0yBgTm6Ci0hrA+ZdiWNzdktiKBRhGGkYC
         E6EtUZpkyiqGeQxH0sK8EdwBlKyotxF5zzKj8h8sWvUTE2jqW5dOdb/cU1FUbkzE1IdF
         EXtBDALv7qNHkEoUoNMY5LVZr8458hpNNGb+T3fSDdIxhFfzPOsMhhAX1BiB2CWnlNt5
         SFU0ZapAjcGxfx6GhJHXVkO49P2FBilbj561vi4KXabYoyNo8z0uwThYrMZ7KFXNmePB
         ioBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWErgVPSbPgPS0cot2KuzsoxPnk5t2poaH8xxZaNOfk=;
        b=uUXqngYpVBjdm0E9krQtWb84xj8TOftmr+Ce4cs5jnUIqzFQn26LlTSxS9uzr52F5D
         Nb+qZIHZOG52DeNj3QschMcYCZ7KTCGbWeEBiBkHv7MV3R0iVOnNho9tn5GYo/DSvGyY
         k8NtNp9C8DwKfPk6tmx/vaHDdA3oSAsE4+2CBwaU9TtYJSEV7Eg6YGHGrqJYPovQd2W3
         EQneBh+7IqQUKOAG+tsN7MEVApp/bFWRz36qXOGC90xr+lhHCXLdtkOMhpt69rtBGqtp
         7Ka/uyyPLueB1gcAiYQnpv/YWA5FhixhlhEZwg4wPJsHSWzWFcqqha+U8TspG/yxUBYl
         ZngQ==
X-Gm-Message-State: AOAM533Sl6Y1uHOzwsnmr/QYXg3vXga/rBss0TNMQke5kPKxcJ42tADc
        bZD78u9BIGOBhLYSXMY7oyUBCWUzNgNPFis0p26HhQ==
X-Google-Smtp-Source: ABdhPJxCopLUWq+4ft+NVnaS82/nys0iopBB2B2ZS6BEHXy52c/7c79JVhvvzJycZWI0WqHdXsCC4MjxOpz9+YpqrZs=
X-Received: by 2002:a05:6512:750:: with SMTP id c16mr37650476lfs.622.1641104115576;
 Sat, 01 Jan 2022 22:15:15 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-29-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-29-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:15:03 +0100
Message-ID: <CACRpkdYGQkTEHFNtLB=gMV-jkPWiF8mjUVv_C_rTyd7bxrYcXA@mail.gmail.com>
Subject: Re: [PATCH 28/34] brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev
 with memcpy_toio
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

On Sun, Dec 26, 2021 at 4:40 PM Hector Martin <marcan@marcan.st> wrote:

> The alignment check was wrong (e.g. & 4 instead of & 3), and the logic
> was also inefficient if the length was not a multiple of 4, since it
> would needlessly fall back to copying the entire buffer bytewise.
>
> We already have a perfectly good memcpy_toio function, so just call that
> instead of rolling our own copy logic here. brcmf_pcie_init_ringbuffers
> was already using it anyway.
>
> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
> Signed-off-by: Hector Martin <marcan@marcan.st>

Excellent patch.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
