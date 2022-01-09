Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4EF4888D7
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 12:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiAILXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 06:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiAILXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 06:23:12 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC97DC061751
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 03:23:07 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id x6so34010487lfa.5
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 03:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VuyKoLpWpEEZox/0t1toTPqDMCC65viZRvg9Agp6Rc=;
        b=dJPaZcxnQDoggqCqDo8SgAfO7tb06gDGic1MlpIuAl1WKAb1IrZyFWhx4ySSrIWNyJ
         qWJ6FrK8U+m+QW4qoDRndMDgG8p564Lt49T0onB8wBboILu+sjsS7VqS1UIErAg4zhn/
         aUCXP6JgTQq/tdxHxNMCmbydvDrjg1E6eYGAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VuyKoLpWpEEZox/0t1toTPqDMCC65viZRvg9Agp6Rc=;
        b=DjpMt9ABO+2Xj75F69IGjwo2TcoQgSUdCZRwOqrz8GdXI20V/lZWsfHYWM1PeWA2q9
         dZHpL3eFEx2LgX1iiQd7fO4VYh1noi8wHpeabdHIKN4vvNk/RLvTeyNJSR1CfIz/v6jf
         v9swLvDHRp+flESSA3WOHkb69cbyjvjh5tPhOQRnuggVJnAJPG5YB/SKB3tUnvAzkmQW
         M+/+L4I9QcqFJ1fJcdPAQ9Aavbwt94GbVphxZ/KL7WskRglbZDbOSstKazBDFVvNs0vG
         p7MlRN7xV6SVQOAHxa3iLtQdoWiAQhaJioCelhRPVxCjWG1HzOnFhXhFX2Qs2j28Wjlh
         b79g==
X-Gm-Message-State: AOAM531Y3TxXoLx14aNDjOMQPZKHoFUZVVU/fxn6rZoYfSAZ852lu3T2
        iuEBDddaDBc1QHm1ND7qWXwoDZVEuqvoubWh22oIwg==
X-Google-Smtp-Source: ABdhPJz+5GwtyaN/5n8Jbaloti4ZQbWg5UCqS9v3FH2+ZEJYOcidZDDjriHT2NrEphgQkiv8v8+L/snICziKs2BJanM=
X-Received: by 2002:a05:651c:145:: with SMTP id c5mr57989978ljd.237.1641727385719;
 Sun, 09 Jan 2022 03:23:05 -0800 (PST)
MIME-Version: 1.0
References: <20220108181633.420433-1-dario.binacchi@amarulasolutions.com> <20220108201650.7gp3zlduzphgcgkq@pengutronix.de>
In-Reply-To: <20220108201650.7gp3zlduzphgcgkq@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Sun, 9 Jan 2022 12:22:54 +0100
Message-ID: <CABGWkvoGs_VBGD-7dt18LY9NV=63w50OceKjmaKYeqDe_WJk9g@mail.gmail.com>
Subject: Re: [RFC PATCH] can: flexcan: add ethtool support to get rx/tx ring parameters
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 8, 2022 at 9:16 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 08.01.2022 19:16:33, Dario Binacchi wrote:
> > Adds ethtool support to get the number of message buffers configured for
> > reception/transmission, which may also depends on runtime configurations
> > such as the 'rx-rtr' flag state.
> >
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > ---
> >
> >  drivers/net/can/flexcan/flexcan-ethtool.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/drivers/net/can/flexcan/flexcan-ethtool.c b/drivers/net/can/flexcan/flexcan-ethtool.c
> > index 5bb45653e1ac..d119bca584f6 100644
> > --- a/drivers/net/can/flexcan/flexcan-ethtool.c
> > +++ b/drivers/net/can/flexcan/flexcan-ethtool.c
> > @@ -80,7 +80,24 @@ static int flexcan_set_priv_flags(struct net_device *ndev, u32 priv_flags)
> >       return 0;
> >  }
> >
> > +static void flexcan_get_ringparam(struct net_device *ndev,
> > +                               struct ethtool_ringparam *ring)
>
> This doesn't compile on net-next/master, as the prototype of the
> get_ringparam callback changed, fixed this while applying.
>
> > +{
> > +     struct flexcan_priv *priv = netdev_priv(ndev);
> > +
> > +     ring->rx_max_pending = priv->mb_count;
> > +     ring->tx_max_pending = priv->mb_count;
> > +
> > +     if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
> > +             ring->rx_pending = __sw_hweight64(priv->rx_mask);
>
> I've replaced the hamming weight calculation by the simpler:
>
> |               ring->rx_pending = priv->offload.mb_last -
> |                       priv->offload.mb_first + 1;
>
> > +     else
> > +             ring->rx_pending = 6;
> > +
> > +     ring->tx_pending = __sw_hweight64(priv->tx_mask);
>
> ...and here I added a hardcoded "1", as the driver currently only
> support on TX buffer.
>
> > +}
> > +
> >  static const struct ethtool_ops flexcan_ethtool_ops = {
> > +     .get_ringparam = flexcan_get_ringparam,
> >       .get_sset_count = flexcan_get_sset_count,
> >       .get_strings = flexcan_get_strings,
> >       .get_priv_flags = flexcan_get_priv_flags,
>
> BTW: If you're looking for more TX performance, this can be done by
> using more than one TX buffer.

I didn't expect only one message buffer to be used for transmission

thanks and regards,
Dario

> It's also possible to configure the
> number of RX and TX buffers via ethtool during runtime. I'm currently
> preparing a patch set for the mcp251xfd to implement this.
>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
