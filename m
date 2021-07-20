Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947383CF7EF
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhGTJw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:52:28 -0400
Received: from mail-ua1-f41.google.com ([209.85.222.41]:43908 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237861AbhGTJuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:50:50 -0400
Received: by mail-ua1-f41.google.com with SMTP id 109so7895008uar.10;
        Tue, 20 Jul 2021 03:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFJr3mnxmkAIaRVKTYv7QqTxKFA58WNsYKCu7chQapI=;
        b=ZQqhW6TMLHax5JVUXRn319CU2pgZnIZwGBToaDTfcEePCjPiGlfVTv/N79KdIpv4n8
         yZQO0rV1CKpxmAutOW1HIemQz2jlWcFgdcaRcOo2Xv1DSKfmN2Nawn7BfrSxEM18Cj/6
         t0gugw3UUP2qiUcvuqS1wMVuIcOL5pjQnGBgDSUkrVHMOyrPsnru4LMvNZ2aLwThBxSC
         7JWJ4K4SQOb0dwbJgWWrmN4vgwIB01AwKy99gejj4jXl7KwJoK+0KM0zh+kgG+Ftxv9O
         L+p5fl4OKhSGf7+25nLpwUWIQ9rbqmwJYUo9yo3OBNa2uQsN1gLIS2I/0K7Ue9Yox4ad
         g7EQ==
X-Gm-Message-State: AOAM530R9D/fUS9wVLbZgGjAmTtaA+/YHEx/E4Fe0ty1yBvLIJIA6GXa
        5BOlEjI+Xvj/85xjJQ9dvqwOgvCkLNNIiebxBiA=
X-Google-Smtp-Source: ABdhPJx/ZYpxNeEBypBsMcNZBb58Bq9X6WTtWKsSNi6NMeuUBQjblbsD5zBbvCvq65O90njI6YIwBFB4rrfE2qmBb4Q=
X-Received: by 2002:ab0:2554:: with SMTP id l20mr30624074uan.58.1626777067084;
 Tue, 20 Jul 2021 03:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210719143811.2135-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210719143811.2135-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Jul 2021 12:30:55 +0200
Message-ID: <CAMuHMdXkPDaaRZZTCyn-Mwfakuzui69GWuiKUWYEOyhQmuFB=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for RZ/G2L family
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Mon, Jul 19, 2021 at 4:39 PM Lad Prabhakar
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
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -37,9 +37,15 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iopoll.h>
> +#include <linux/reset.h>
>
>  #define RCANFD_DRV_NAME                        "rcar_canfd"
>
> +enum rcanfd_chip_id {
> +       RENESAS_RCAR_GEN3 = 0,
> +       RENESAS_RZG2L,
> +};
> +
>  /* Global register bits */
>
>  /* RSCFDnCFDGRMCFG */
> @@ -513,6 +519,9 @@ struct rcar_canfd_global {
>         enum rcar_canfd_fcanclk fcan;   /* CANFD or Ext clock */
>         unsigned long channels_mask;    /* Enabled channels mask */
>         bool fdmode;                    /* CAN FD or Classical CAN only mode */
> +       struct reset_control *rstc1;     /* Pointer to reset source1 */
> +       struct reset_control *rstc2;     /* Pointer to reset source2 */

Are these comments helpful? IMHO they're stating the obvious.

> +       enum rcanfd_chip_id chip_id;
>  };
>
>  /* CAN FD mode nominal rate constants */
> @@ -1577,6 +1586,45 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         priv->can.clock.freq = fcan_freq;
>         dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
>
> +       if (gpriv->chip_id == RENESAS_RZG2L) {
> +               char *irq_name;
> +               int err_irq;
> +               int tx_irq;
> +
> +               err_irq = platform_get_irq_byname(pdev, ch == 0 ? "can0_error" : "can1_error");
> +               if (err_irq < 0) {
> +                       err = err_irq;
> +                       goto fail;
> +               }
> +
> +               tx_irq = platform_get_irq_byname(pdev, ch == 0 ? "can0_tx" : "can1_tx");
> +               if (tx_irq < 0) {
> +                       err = tx_irq;
> +                       goto fail;
> +               }
> +
> +               irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
> +                                         "canfd.chnerr%d", ch);

if (!irq_name) {
    ret = -ENOMEM;
    goto fail;
}

> +               err = devm_request_irq(&pdev->dev, err_irq,
> +                                      rcar_canfd_channel_interrupt, 0,
> +                                      irq_name, gpriv);
> +               if (err) {
> +                       dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
> +                               err_irq, err);
> +                       goto fail;
> +               }
> +               irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
> +                                         "canfd.chntx%d", ch);

Likewise.

> +               err = devm_request_irq(&pdev->dev, tx_irq,
> +                                      rcar_canfd_channel_interrupt, 0,
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

> @@ -1649,27 +1700,64 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         if (of_child && of_device_is_available(of_child))
>                 channels_mask |= BIT(1);        /* Channel 1 */
>
> -       ch_irq = platform_get_irq(pdev, 0);
> -       if (ch_irq < 0) {
> -               err = ch_irq;
> -               goto fail_dev;
> -       }
> +       if (chip_id == RENESAS_RCAR_GEN3) {
> +               ch_irq = platform_get_irq_byname(pdev, "ch_int");

platform_get_irq_byname_optional()?
Unless you want to urge people to update their DTB.

> +               if (ch_irq < 0) {
> +                       /* For backward compatibility get irq by index */
> +                       ch_irq = platform_get_irq(pdev, 0);
> +                       if (ch_irq < 0)
> +                               return ch_irq;
> +               }
>
> -       g_irq = platform_get_irq(pdev, 1);
> -       if (g_irq < 0) {
> -               err = g_irq;
> -               goto fail_dev;
> +               g_irq = platform_get_irq_byname(pdev, "g_int");

Likewise,

> +               if (g_irq < 0) {
> +                       /* For backward compatibility get irq by index */
> +                       g_irq = platform_get_irq(pdev, 1);
> +                       if (g_irq < 0)
> +                               return g_irq;
> +               }
> +       } else {
> +               g_irq = platform_get_irq_byname(pdev, "g_error");
> +               if (g_irq < 0)
> +                       return g_irq;
> +
> +               g_rx_irq = platform_get_irq_byname(pdev, "g_rx_fifo");
> +               if (g_rx_irq < 0)
> +                       return g_rx_irq;
>         }
>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
