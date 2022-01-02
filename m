Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324E34829B8
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 06:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiABFwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 00:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiABFwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 00:52:03 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079EBC061746
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 21:52:03 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id v15so51222714ljc.0
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 21:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n1IdkO2v3WWPYSUTncvDnfGDMDrfABtHyJ12lBtRt4A=;
        b=wDPn0Jr+i3Ne3uIfUMRrc8qtDSm3mBZfR4pC/cTBiQ5xoFgztpIkqZE0aoMSWL9CYM
         p4empsBUWq+plhKvwpWgg1psHX4gHau9FVaXoOrzVCDiQqIL0ecOMx5kNHBMWD/tzoKp
         s+CYL0Qz7pVSkPyVn7ui/EuafYsSDUAodi63H145X98ARPys1LR/H2YAQ9ZA8zRy5ZZV
         B8SMHR+rk9xm9TzIGdveVWHO1vtVb4wsf6WXaWtOyhev38qygrVRNprhkiSpjkSA8PlV
         26trSfYiYZGfE0+NYotRn+hrXSiykF763+t+fzNBLCdtjcdkFWwLFFrCcYYHLelEZuCg
         dhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n1IdkO2v3WWPYSUTncvDnfGDMDrfABtHyJ12lBtRt4A=;
        b=Whs2L+t/265zrXPD+OcYaOpoBFGEFg/ivMwYJEMvECRr4SNu+aCxoWeKOlTZSpJrvW
         rSQUbcY5/XTZAmXToBVxnkO5vPQScpF15p52vk1cePA95k2RViTxQidFk2qp6Kq+Escn
         m5SJrNGcWdzmqOw1hDgAjvtcRs/B3iJ7iZLhbxJtmnn0aS0feao8BtbU+rMEVjtass40
         CTx/BbUve4cuIiPgZTC+459/OEHkquETWEYi52xzTFvI/ZQsJ/dzLZQpXAO/30fN6pSE
         pBKoNeYF1tfsBWOF1GRe0ljrZLveqvWd9PzHp02f0ygjwtH8/slDc3kycbUR0lAxOFDe
         d6pw==
X-Gm-Message-State: AOAM530yHSkloVEgUX0N5C5dPr1QxOxmL1ccu0GVxxIZujG/tyALs84G
        A8p84+XGBJxgG+CYZIeUcvJcPJ6UVuvx0LIzT3mGLg==
X-Google-Smtp-Source: ABdhPJz3850HYLW8wxEtlvPJb84T9SqXhem/mi/73BSeo5E7P0JHUZBkParKaPmI6AIp8XQ33Vb7i+PVLJ6RLVAtbBE=
X-Received: by 2002:a2e:b808:: with SMTP id u8mr24141804ljo.282.1641102721114;
 Sat, 01 Jan 2022 21:52:01 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-13-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-13-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 06:51:49 +0100
Message-ID: <CACRpkdYZUBjOG-kW4Gj4HfzvQySsjpU_h8+mzywwFHxMCuHUYQ@mail.gmail.com>
Subject: Re: [PATCH 12/34] brcmfmac: pcie: Fix crashes due to early IRQs
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

On Sun, Dec 26, 2021 at 4:38 PM Hector Martin <marcan@marcan.st> wrote:

> The driver was enabling IRQs before the message processing was
> initialized. This could cause IRQs to come in too early and crash the
> driver. Instead, move the IRQ enable and hostready to a bus preinit
> function, at which point everything is properly initialized.
>
> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
