Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700DE2E66F0
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633185AbgL1QSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:18:45 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:47029 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633046AbgL1QSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:18:43 -0500
Received: by mail-ot1-f52.google.com with SMTP id w3so9501374otp.13;
        Mon, 28 Dec 2020 08:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3bMFyLrNXYKkHBMjSrQQwVWB5IIqbb7QcW+GHhEb7po=;
        b=h1qGb8OYn/v9Rhk4BP9XwN8FskTRYNpoDcrb7bXPGf2Lgw0QbA87PRG0pur+wES8Vj
         Xqr1YRJxlw6OAhLOtgX8ESRKbtYtGMUyGiT1F3SpoMM9yIMaQGRBq3kpH+nZcxWJDbWa
         gIGOHKXHJDL85I93ZTKjrirQ+aEguHMOG+kKJaTfWqwiPDu5WXTGSBP81rMrWdd3/EMo
         dimsx4Wu4JyceGJEUMYUNnBIlmK/GxkWRAZK4HlGxnEC2o01C+RLP09XvsA9X4SVgt81
         4JX84R4NKDNxI4F7TYK4W5wuh8+PTXMrxuzeFStFCDgv3IYgImSBJbw6phyvktQDzy5Q
         vqzA==
X-Gm-Message-State: AOAM531aaUL0neV2NhldI1eEliqpyiUqY8he457fRAacsOZuVTjfDWDk
        TTVjuZH4qYnkhxh6kQ4gAbRDPV9NJBoDlIr3eyO5Xgi5hlg=
X-Google-Smtp-Source: ABdhPJzoKsz+m5Nt7TMgWgCUitHebt9ovB68151JyGE+slM8gyWz9+7nOPZIbgO7FfX/0pQBXVveUrnuoCpYf8WHOsg=
X-Received: by 2002:a9d:c01:: with SMTP id 1mr18630563otr.107.1609172282400;
 Mon, 28 Dec 2020 08:18:02 -0800 (PST)
MIME-Version: 1.0
References: <20201212165648.166220-1-aford173@gmail.com> <CAMuHMdUr5MWpa5fhpKgAm7zRgzzJga=pjNSVG3aoTvCmuq5poQ@mail.gmail.com>
 <CAHCN7x+jm8agBzqDqnkmW1Obtd0zL6EA_xbicvkroZ+kmgEqiA@mail.gmail.com>
In-Reply-To: <CAHCN7x+jm8agBzqDqnkmW1Obtd0zL6EA_xbicvkroZ+kmgEqiA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 28 Dec 2020 17:17:51 +0100
Message-ID: <CAMuHMdU-FY9cHXP2+tbHRShZw52UudQTRNx58Cw9F_JV73pB-A@mail.gmail.com>
Subject: Re: [RFC] ravb: Add support for optional txc_refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Charles Stevens <charles.stevens@logicpd.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

CC devicetree

On Mon, Dec 28, 2020 at 2:49 PM Adam Ford <aford173@gmail.com> wrote:
> On Mon, Dec 14, 2020 at 4:05 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, Dec 13, 2020 at 5:18 PM Adam Ford <aford173@gmail.com> wrote:
> > > The SoC expects the txv_refclk is provided, but if it is provided
> > > by a programmable clock, there needs to be a way to get and enable
> > > this clock to operate.  It needs to be optional since it's only
> > > necessary for those with programmable clocks.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/net/ethernet/renesas/ravb.h
> > > +++ b/drivers/net/ethernet/renesas/ravb.h
> > > @@ -994,6 +994,7 @@ struct ravb_private {
> > >         struct platform_device *pdev;
> > >         void __iomem *addr;
> > >         struct clk *clk;
> > > +       struct clk *ref_clk;
> > >         struct mdiobb_ctrl mdiobb;
> > >         u32 num_rx_ring[NUM_RX_QUEUE];
> > >         u32 num_tx_ring[NUM_TX_QUEUE];
> > > diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> > > index bd30505fbc57..4c3f95923ef2 100644
> > > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > > @@ -2148,6 +2148,18 @@ static int ravb_probe(struct platform_device *pdev)
> > >                 goto out_release;
> > >         }
> > >
> > > +       priv->ref_clk = devm_clk_get(&pdev->dev, "txc_refclk");
> >
> > Please also update the DT bindings[1], to document the optional
> > presence of the clock.
>
> I am not all that familiar with the YAML syntax, but right now, the
> clock-names property isn't in the binding, and the driver doesn't use
> a name when requesting the single clock it's expecting.
> Since the txc_refclk is optional, can the clock-names property allow
> for 0-2 names while the number of clocks be 1-2?
>
> clocks:
>     minItems: 1
>     maxItems: 2
>
>   clock-names:
>     minItems: 0
>     maxItems: 2
>     items:
>       enum:
>         - fck # AVB functional clock (optional if it is the only clock)
>         - txc_refclk # TXC reference clock

With "enum", it accepts any order. But for compatibility, we want to force
"fck" first.

Something like:

  clocks:
    minItems: 1
    items:
      - description: AVB functional clock
      - description: Optional TXC reference clock

  clock-names:
    items:
      - const: fck
      - const: txc_refclk

> With the above proposal, the clock-names would only be necessary when
> using the txc_refclk.

I think that's difficult to express: either make clock-names optional (i.e.
don't list it under "required"), or make it required in all cases (which need
fixups for the existing users, and "minItems: 1" for "clock-names", too).

> > > +       if (IS_ERR(priv->ref_clk)) {
> > > +               if (PTR_ERR(priv->ref_clk) == -EPROBE_DEFER) {
> > > +                       /* for Probe defer return error */
> > > +                       error = PTR_ERR(priv->ref_clk);
> > > +                       goto out_release;
> > > +               }
> > > +               /* Ignore other errors since it's optional */
> > > +       } else {
> > > +               (void)clk_prepare_enable(priv->ref_clk);
> >
> > This can fail.
> > Does this clock need to be enabled all the time?
> > At least it should be disabled in the probe failure path, and in
> > ravb_remove().
>
> I'll do that for the next rev.
>
> thanks,
>
> adam
> >
> > [1] Documentation/devicetree/bindings/net/renesas,etheravb.yaml

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
