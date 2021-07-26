Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D6C3D56E0
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhGZJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 05:12:51 -0400
Received: from mail-vs1-f54.google.com ([209.85.217.54]:35660 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhGZJMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 05:12:49 -0400
Received: by mail-vs1-f54.google.com with SMTP id p13so4896517vsg.2;
        Mon, 26 Jul 2021 02:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mo44UZHj7UyEbhGMPjthYrR+6cIV8nYK59wZuJbcwls=;
        b=HgT7Zh+m8LxQ6fsspwMqyvmFuRyAEl+TNC3Lg+FIvfu/Bcm1mCZur3f9yNmpFAHaai
         JucuO1ei6gPV8eCSRXAU+JiuwItK7V7yM2xVK5TkqF7DZczRMkSCjW1yjvhb/GBq9fIc
         qF/QkVmliwHslLamKkA10AhHonKxbOED8LuFnGt1bYzpaR6sZIsOKeviPh+ekDgQEI7V
         ji1nBtmjTuBr0GKyfBzvG3GTxEV3kbf0oWJcq9R9INY4BAONhfguIr15ehnzQW6OnjSF
         padF1BCs0X0yptruDVDXiJriaul+5iBE3AmpM9ECOmVLU34THI5GGtevWJoNcvV1zSmi
         vxlA==
X-Gm-Message-State: AOAM532OmBMfE3vMjHkIRJICAIAMtSeplElCpP207jNA0dNdgDKmMYSt
        VIrGp4YtPx5qFAQVT8aecKNXgJsW7NJ9ceCikdY=
X-Google-Smtp-Source: ABdhPJyi2KG9djcxQLYJlEr3Qxzre7k9jFg6SE0AUxjF4rVlN643niJ5kjEhHf7i9K4wmXFRhnqB3+QlJisYrQ73KcU=
X-Received: by 2002:a05:6102:2828:: with SMTP id ba8mr11359232vsb.18.1627293196190;
 Mon, 26 Jul 2021 02:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210721194951.30983-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 26 Jul 2021 11:53:04 +0200
Message-ID: <CAMuHMdU0YkKb-_k00Zbr3aQGSHRD8639Ut207VwQ_ji0E+YL2g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Wed, Jul 21, 2021 at 9:50 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> CANFD block on RZ/G2L SoC is almost identical to one found on
> R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
> are split into different sources and the IP doesn't divide (1/2)
> CANFD clock within the IP.
>
> This patch adds compatible string for RZ/G2L family and registers
> the irq handlers required for CANFD operation. IRQ numbers are now
> fetched based on names instead of indices. For backward compatibility
> on non RZ/G2L SoC's we fallback reading based on indices.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for the update!

I think you misunderstood my comment on v1 about the interrupt
handlers, cfr. below.

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c

> @@ -1577,6 +1586,53 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         priv->can.clock.freq = fcan_freq;
>         dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
>
> +       if (gpriv->chip_id == RENESAS_RZG2L) {
> +               char *irq_name;
> +               int err_irq;
> +               int tx_irq;
> +
> +               err_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_err" : "ch1_err");
> +               if (err_irq < 0) {
> +                       err = err_irq;
> +                       goto fail;
> +               }
> +
> +               tx_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_trx" : "ch1_trx");
> +               if (tx_irq < 0) {
> +                       err = tx_irq;
> +                       goto fail;
> +               }
> +
> +               irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
> +                                         "canfd.ch%d_err", ch);
> +               if (!irq_name) {
> +                       err = -ENOMEM;
> +                       goto fail;
> +               }
> +               err = devm_request_irq(&pdev->dev, err_irq,
> +                                      rcar_canfd_channel_interrupt, 0,

This is the same interrupt handler...

> +                                      irq_name, gpriv);
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
> +                               err_irq, err);
> +                       goto fail;
> +               }
> +               irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
> +                                         "canfd.ch%d_trx", ch);
> +               if (!irq_name) {
> +                       err = -ENOMEM;
> +                       goto fail;
> +               }
> +               err = devm_request_irq(&pdev->dev, tx_irq,
> +                                      rcar_canfd_channel_interrupt, 0,

... as this one.

> +                                      irq_name, gpriv);
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
> +                               tx_irq, err);
> +                       goto fail;
> +               }
> +       }
> +
>         if (gpriv->fdmode) {
>                 priv->can.bittiming_const = &rcar_canfd_nom_bittiming_const;
>                 priv->can.data_bittiming_const =

> @@ -1711,20 +1798,51 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         gpriv->base = addr;
>
>         /* Request IRQ that's common for both channels */
> -       err = devm_request_irq(&pdev->dev, ch_irq,
> -                              rcar_canfd_channel_interrupt, 0,
> -                              "canfd.chn", gpriv);
> -       if (err) {
> -               dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> -                       ch_irq, err);
> -               goto fail_dev;
> +       if (gpriv->chip_id == RENESAS_RCAR_GEN3) {
> +               err = devm_request_irq(&pdev->dev, ch_irq,
> +                                      rcar_canfd_channel_interrupt, 0,
> +                                      "canfd.ch_int", gpriv);
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +                               ch_irq, err);
> +                       goto fail_dev;
> +               }
> +
> +               err = devm_request_irq(&pdev->dev, g_irq,
> +                                      rcar_canfd_global_interrupt, 0,
> +                                      "canfd.g_int", gpriv);
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +                               g_irq, err);
> +                       goto fail_dev;
> +               }
> +       } else {
> +               err = devm_request_irq(&pdev->dev, g_recc_irq,
> +                                      rcar_canfd_global_interrupt, 0,

This is the same interrupt handler...

> +                                      "canfd.g_recc", gpriv);
> +
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +                               g_recc_irq, err);
> +                       goto fail_dev;
> +               }
> +
> +               err = devm_request_irq(&pdev->dev, g_err_irq,
> +                                      rcar_canfd_global_interrupt, 0,

... as this one.

> +                                      "canfd.g_err", gpriv);
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> +                               g_err_irq, err);
> +                       goto fail_dev;
> +               }
>         }
> -       err = devm_request_irq(&pdev->dev, g_irq,
> -                              rcar_canfd_global_interrupt, 0,
> -                              "canfd.gbl", gpriv);
> +
> +       err = reset_control_reset(gpriv->rstc1);
> +       if (err)
> +               goto fail_dev;
> +       err = reset_control_reset(gpriv->rstc2);
>         if (err) {
> -               dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> -                       g_irq, err);
> +               reset_control_assert(gpriv->rstc1);
>                 goto fail_dev;
>         }

I did not object to having fine-grained interrupt handlers on RZ/G2L.
I did object to duplicating code in global and fine-grained interrupt
handlers.

The trick to have both is to let the global interrupt handlers call
(conditionally) into the fine-grained handlers. In pseudo-code:

    global_interrupt_handler()
    {
            if (...)
                    fine_grained_handler1();

            if (...)
                    fine_grained_handler2();
            ...
    }

On R-Car Gen3, you register the global interrupt handlers, as before.
On RZ/G2L, you register the fine-grained interrupt handlers instead.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
