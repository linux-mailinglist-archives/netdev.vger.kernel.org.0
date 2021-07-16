Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229803CB383
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 09:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhGPHu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 03:50:27 -0400
Received: from mail-vs1-f51.google.com ([209.85.217.51]:38627 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbhGPHuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 03:50:24 -0400
Received: by mail-vs1-f51.google.com with SMTP id x22so2661240vsq.5;
        Fri, 16 Jul 2021 00:47:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NutJ9mQKrIqtuo3VaZ+xcHZMGsxW+Kv/SDu5LrVjo9Q=;
        b=srno97Z879KGTtohm415goZecyDihWM5fEE1Ag1GFzwSCqoyAHzIghekLYB/mcaKd+
         vbU/MIQ3BrgcVV6CnseDZTFqjc56mVsgsfmxyktR9++BZaSYMUeKWvJcZDtluaCnVzaN
         1PqIihB5d/AGEKpySM7fqigwvgp3MyVz29fh0qiINU4u0iG1ZgoB0Q76tEh26aB0iSWZ
         O1yg6mNmri3xfW6k67Ii1QLffn2pnm9Dta8/QJc1t4PSNMJCptTS5TQLh0AqUpzLMaw2
         uuHlN5bQ8svzo6JYBo9jk01tXgjIOMlNrcPHOWZ7RYbxvpHmgEJVHMW4u2wR2n0rytD7
         BaMw==
X-Gm-Message-State: AOAM530N7Fzwl3+KBi14sMc89XU148Ghs0X2yH53AKhRDxmQwkTvV3au
        wDU03g8c850rVStOG6LwrqtX2UQKeaIBIfvr7tk=
X-Google-Smtp-Source: ABdhPJxLo36ZYfsdUvfI1JBDYT7drXA56AQ+hjhm7XXKhCEjbX1Gl5TmWQs/cv5GDKqy6y9Q8eGS6yalYJYWjZJ0up8=
X-Received: by 2002:a05:6102:2828:: with SMTP id ba8mr11052431vsb.18.1626421648298;
 Fri, 16 Jul 2021 00:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210715182123.23372-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210715182123.23372-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Jul 2021 09:47:17 +0200
Message-ID: <CAMuHMdXB-kEU7QVuMH1SNrwg+VPbHeOVQS3rjhcgQRFwoMsgdA@mail.gmail.com>
Subject: Re: [PATCH 2/6] can: rcar_canfd: Add support for RZ/G2L family
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
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

On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> CANFD block on RZ/G2L SoC is almost identical to one found on
> R-Car Gen3 SoC's.
>
> On RZ/G2L SoC interrupt sources for each channel are split into
> different sources, irq handlers for the same are added.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1070,6 +1077,56 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
>         can_led_event(ndev, CAN_LED_EVENT_TX);
>  }
>
> +static irqreturn_t rcar_canfd_global_err_interrupt(int irq, void *dev_id)
> +{

> +static irqreturn_t rcar_canfd_global_recieve_fifo_interrupt(int irq, void *dev_id)
> +{

>  static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
>  {
>         struct rcar_canfd_global *gpriv = dev_id;
> @@ -1139,6 +1196,56 @@ static void rcar_canfd_state_change(struct net_device *ndev,
>         }
>  }
>
> +static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
> +{

> +static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
> +{

It looks like the new split interrupt handlers duplicate code from
the existing unified interrupt handlers.  Perhaps the latter can be
made to call the former instead?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
