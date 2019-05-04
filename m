Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4623613700
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfEDCLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:11:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34325 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:11:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id e9so10028911wrc.1;
        Fri, 03 May 2019 19:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXnW8QwbRokk+qzSPvi3narjQ4Xryecxmsq/oRg84t0=;
        b=rCsD4WyUm2f1tzHstzZYc9hNLYi5V4Ln+GhDX8ZckucOlbXRd48dZ2qLS8mp6K2hkw
         Dsn0yrdFdl1prwClk6XGfSkFzUuULkS5m1NT905Jo54Sul0XOeQuZ9EY0HWblYYJI0tE
         3e8XkpHPY6dxAGvUFCeRTyHB1aKW6IGQspT5XQEo2ZX86IJKTMtknlYICB9wcWRV0k0T
         8aUh68GqAJHTHWY1USx8apGMq8my60Ye/Ix5iZ4jtc+tKKtxc4IrGcR4doO5pJ8A2vfS
         ygDjfvIrpRVHma17OBJ2r7ylUJ4qsF6MVypFH1W4zvrY+Pbjguo3WnJVZbZ7oxkGOwPN
         6l7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXnW8QwbRokk+qzSPvi3narjQ4Xryecxmsq/oRg84t0=;
        b=I+W48221jn5lC5HARB/EaHjIs6DozcLOq1Gg2GfhmeK4P6DWycxOgEziWTNjZ/ok7e
         o+PMWxpE5hbtDqSCKZOZabzLfydsPUEXNcdtUFkbMpoZHMZXCITSw8oJ3/a5na6LQYsQ
         T7IsHkBfc+yH0ldo6GmAR2qdqMrXRluMa+AGlAycVVejRRaC4uzJc4VYdnGWiK+2imOs
         9zVzjodFs1oqOHYLDgNo4Sy07KZFt7jrttDBJEek+sFGNh29OkZy4jZvm4nz6Tcc+U/X
         VNF7brmpd1xMBcoaOmG26uwmU2dfkhyPI+xqs6YQs9Lt/zwlngaCCBPUg657/cyPcfTm
         Bxag==
X-Gm-Message-State: APjAAAVovBNFMeQe+5kbgwoqLLmK2AqueDpAGKEEjt0trvoFWSDHVWay
        whAB89S34wmmyQZvrw2MSyeqoeOTYPO7TZUpVFs=
X-Google-Smtp-Source: APXvYqyFhxLfsHmATpay3TS+w2UPXNeNQnnLd4sUyMCnq8H/uEaVcJfUGhmQIwy/Y5zu6gDngfLP4cU/zo0PFf4J9ao=
X-Received: by 2002:adf:f84e:: with SMTP id d14mr9028645wrq.21.1556935863182;
 Fri, 03 May 2019 19:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190504011826.30477-1-olteanv@gmail.com> <20190504011826.30477-6-olteanv@gmail.com>
 <3232ef43-d568-0851-4511-6fe7c86d9e8a@gmail.com>
In-Reply-To: <3232ef43-d568-0851-4511-6fe7c86d9e8a@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 4 May 2019 05:10:52 +0300
Message-ID: <CA+h21hppEwWT458brR+h_nVtb6jzpiWgTCU8SE4Hx_cFDksmRA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/9] net: dsa: Add support for deferred xmit
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     vivien.didelot@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 at 05:07, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> > Some hardware needs to take some convincing work in order to receive
> > frames on the CPU port (such as the sja1105 which takes temporary L2
> > forwarding rules over SPI that last for a single frame). Such work needs
> > a sleepable context, and because the regular .ndo_start_xmit is atomic,
> > this cannot be done in the tagger. So introduce a generic DSA mechanism
> > that sets up a transmit skb queue and a workqueue for deferred
> > transmission.
> >
> > The new driver callback (.port_deferred_xmit) is in dsa_switch and not
> > in the tagger because the operations that require sleeping typically
> > also involve interacting with the hardware, and not simply skb
> > manipulations. Therefore having it there simplifies the structure a bit
> > and makes it unnecessary to export functions from the driver to the
> > tagger.
> >
> > The driver is responsible of calling dsa_enqueue_skb which transfers it
> > to the master netdevice. This is so that it has a chance of performing
> > some more work afterwards, such as cleanup or TX timestamping.
> >
> > To tell DSA that skb xmit deferral is required, I have thought about
> > changing the return type of the tagger .xmit from struct sk_buff * into
> > a enum dsa_tx_t that could potentially encode a DSA_XMIT_DEFER value.
> >
> > But the trailer tagger is reallocating every skb on xmit and therefore
> > making a valid use of the pointer return value. So instead of reworking
> > the API in complicated ways, right now a boolean property in the newly
> > introduced DSA_SKB_CB is set.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
>
> [snip]
>
> >  static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
> >  {
> >       struct dsa_slave_priv *p = netdev_priv(dev);
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 8ad9bf957da1..cfb8cba6458c 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -120,6 +120,9 @@ static int dsa_slave_close(struct net_device *dev)
> >       struct net_device *master = dsa_slave_to_master(dev);
> >       struct dsa_port *dp = dsa_slave_to_port(dev);
> >
> > +     cancel_work_sync(&dp->xmit_work);
> > +     skb_queue_purge(&dp->xmit_queue);
> > +
> >       phylink_stop(dp->pl);
>
> Don't you also need to do that for dsa_slave_suspend() in case the
> xmit() raced with netif_device_detach() somehow?
>
>
> --
> Florian

Hi Florian,
Thanks for pointing that out. Not having power management ops I didn't
even think about that.
-Vladimir
