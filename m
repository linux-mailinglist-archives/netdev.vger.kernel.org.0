Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0322D95D4
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 11:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406688AbgLNKGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 05:06:49 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41911 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgLNKGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 05:06:32 -0500
Received: by mail-oi1-f196.google.com with SMTP id 15so18607674oix.8;
        Mon, 14 Dec 2020 02:06:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wU59+CvZmcAbyjsN37G3+XqMzje/NQXAt7rsV5oGj0k=;
        b=pBG2Aq3lZ7mlTuDZWXC5FtzKOOoJp5zZ0WZhcRqSr71BQG7p+CJuEhzrYIaVhEDjNl
         UtW0pFdF2jvwNMvEGxYAQFWTKt4YgGJlQhs6ITKd28Zenz6+Nwcqxj9FKCd8Vpc7+oEH
         zqm/8IzAYdYwMGmC72SyxS0W+3iqzSXvKMUuWAXDFXucoYvj2VR60eRMuK2A1Fqgrzef
         q3xjMjARB3X4ziPdPpGIAK4AZegPXjGTktFTOEXYZJFx7znnz2B7FCF6v2dQibp9ye+K
         kIlSZ/QJfIid+AFU3+laQ2AFDB9j/dKN1u/nm2D//P2aQL11YB09rkb//CSR0X9upkIh
         QJDg==
X-Gm-Message-State: AOAM531cVSYKQ+QC8/B0y2YCsSoNaTLcYRYOfiYHt0OuPKngKNKQQN5Z
        T/KpZm+CYq8Gjz16n9iUurAphB2MC6inWwtDUQk=
X-Google-Smtp-Source: ABdhPJwQdx6cW6UQ7QqSDaHV7ufUH8rElpntvn+VgJnJPtAuMuVoDgv/Yj3DxHb3j3T7wqzfOFCCZy3FcSOGhfm7I1I=
X-Received: by 2002:aca:4b16:: with SMTP id y22mr17563683oia.148.1607940351152;
 Mon, 14 Dec 2020 02:05:51 -0800 (PST)
MIME-Version: 1.0
References: <20201212165648.166220-1-aford173@gmail.com>
In-Reply-To: <20201212165648.166220-1-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 14 Dec 2020 11:05:40 +0100
Message-ID: <CAMuHMdUr5MWpa5fhpKgAm7zRgzzJga=pjNSVG3aoTvCmuq5poQ@mail.gmail.com>
Subject: Re: [RFC] ravb: Add support for optional txc_refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        charles.stevens@logicpd.com,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Sun, Dec 13, 2020 at 5:18 PM Adam Ford <aford173@gmail.com> wrote:
> The SoC expects the txv_refclk is provided, but if it is provided
> by a programmable clock, there needs to be a way to get and enable
> this clock to operate.  It needs to be optional since it's only
> necessary for those with programmable clocks.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -994,6 +994,7 @@ struct ravb_private {
>         struct platform_device *pdev;
>         void __iomem *addr;
>         struct clk *clk;
> +       struct clk *ref_clk;
>         struct mdiobb_ctrl mdiobb;
>         u32 num_rx_ring[NUM_RX_QUEUE];
>         u32 num_tx_ring[NUM_TX_QUEUE];
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index bd30505fbc57..4c3f95923ef2 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2148,6 +2148,18 @@ static int ravb_probe(struct platform_device *pdev)
>                 goto out_release;
>         }
>
> +       priv->ref_clk = devm_clk_get(&pdev->dev, "txc_refclk");

Please also update the DT bindings[1], to document the optional
presence of the clock.

> +       if (IS_ERR(priv->ref_clk)) {
> +               if (PTR_ERR(priv->ref_clk) == -EPROBE_DEFER) {
> +                       /* for Probe defer return error */
> +                       error = PTR_ERR(priv->ref_clk);
> +                       goto out_release;
> +               }
> +               /* Ignore other errors since it's optional */
> +       } else {
> +               (void)clk_prepare_enable(priv->ref_clk);

This can fail.
Does this clock need to be enabled all the time?
At least it should be disabled in the probe failure path, and in
ravb_remove().

[1] Documentation/devicetree/bindings/net/renesas,etheravb.yaml

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
