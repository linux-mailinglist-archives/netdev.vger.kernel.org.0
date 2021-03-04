Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A4E32CE23
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhCDIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:09:01 -0500
Received: from mail-vs1-f44.google.com ([209.85.217.44]:36301 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhCDIIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:08:53 -0500
Received: by mail-vs1-f44.google.com with SMTP id a12so7462852vsd.3;
        Thu, 04 Mar 2021 00:08:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VIhNJJMVnzvhOohhU5+sHSGrbiWXYRzHlRt+5Fa9ZAM=;
        b=dp9/2N97ID2W08m9XDtpLgdIenSHuAQYwynqWJ2JxBktdemD7D9+sJwGs/E9sPaPk4
         64pW+KfwnlzrkHc32tsAIHWYUD3v/9n/3xwevaDjy0avQB4/vxOFbWIn1yuHyqMdc5nS
         T3LiW9m4HIeiQa3JzWHq67JPdlaadDcR3lWzkjmBxAuoyVSnbaciSCGaY/KtEfoYp6a9
         tTpklKqUeII925Hk/RNoM880kmWA3ZvJxU4EHnIIO+byI9DCNNLhvXQd9y+wWGNHlu3Z
         3qXBfdCvUY29DktW9s+aKkQ/GSfcsn3yvCFZOTbXRF4CjcYFOSo/e3LoZSvHMOoXOd/m
         RWxQ==
X-Gm-Message-State: AOAM533cAzQNYHTwNwdP0YYYHUgzB3Gc+WTUYaDmo1CNYs7JQyE3cTkk
        DYfLDzkXFrCt3SPCcbvX27kUmtVpcSCtfrd3yEU=
X-Google-Smtp-Source: ABdhPJw0x8zdV/rT4XakBLSt5aNaEU9m6ptAA1rjZNeubRN69J3WPDnkAIu8HfFWZbRetFta0ELKelcJ5surbKmASqg=
X-Received: by 2002:a67:fb86:: with SMTP id n6mr1779925vsr.3.1614845292063;
 Thu, 04 Mar 2021 00:08:12 -0800 (PST)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-4-aford173@gmail.com>
In-Reply-To: <20210224115146.9131-4-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Mar 2021 09:08:00 +0100
Message-ID: <CAMuHMdXjQV7YrW5T_P4tkJk_d44NNTQ8Eu7v2ReESjg6R3tvfw@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] net: ethernet: ravb: Enable optional refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> For devices that use a programmable clock for the AVB reference clock,
> the driver may need to enable them.  Add code to find the optional clock
> and enable it when available.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2148,6 +2148,13 @@ static int ravb_probe(struct platform_device *pdev)
>                 goto out_release;
>         }
>
> +       priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
> +       if (IS_ERR(priv->refclk)) {
> +               error = PTR_ERR(priv->refclk);
> +               goto out_release;
> +       }
> +       clk_prepare_enable(priv->refclk);
> +

Shouldn't the reference clock be disabled in case of any failure below?

>         ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
>         ndev->min_mtu = ETH_MIN_MTU;
>
> @@ -2260,6 +2267,9 @@ static int ravb_remove(struct platform_device *pdev)
>         if (priv->chip_id != RCAR_GEN2)
>                 ravb_ptp_stop(ndev);
>
> +       if (priv->refclk)
> +               clk_disable_unprepare(priv->refclk);
> +
>         dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
>                           priv->desc_bat_dma);
>         /* Set reset mode */

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
