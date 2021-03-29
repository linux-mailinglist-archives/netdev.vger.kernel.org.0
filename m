Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB17034D0FC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhC2NIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:08:36 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:40568 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhC2NIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 09:08:15 -0400
Received: by mail-vs1-f42.google.com with SMTP id v29so2373826vsi.7;
        Mon, 29 Mar 2021 06:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+63Txv4HMbvp0BnWBDVOQtdOyhYc/l6Vd8gKqugtRUg=;
        b=jTQwNPQwnmSHkZqGRH9yuehUpf7vW9QZDsE4PTWc8kT4ZGuJqKeMRczRV2C5EVUnS6
         A+hVUaPo8pVVlFsP1Ik2z9h8674ynp6XkeIlriqpChQJWV1VSkCXcUK/GKYuYLsySUNO
         L2Wzwh6wvZLnptxswNKw/pk5Ccx5Zxj6MCEtz3Ei/L+MQH1nfqZm8mTjH+Su/Afq2cy6
         HJUrtgdApjbwvLmFGT+6/L3KKctwWe77PpWb+ywzvKVl0tJ08R4N9qdulsheDXagQx0N
         vcv5H/Gt7Ur35PBXkKX3FUSvkxSfOK5P4X+6w8xfaogjGgEzmMbIktvSmFnhTt25Ed1H
         7gIw==
X-Gm-Message-State: AOAM532qEsM/0CQXHi7I10ryEEG8VimC+xSAZKZcE6Iqq98YcCIq974i
        CeHFfdd/Hg/6wWLu0KHO2c3HUwY4MUpRNuvrf6I=
X-Google-Smtp-Source: ABdhPJzSsijhkAmkKkskweEa8lEzgCTgNfIY/32SCSndupArW0/sIyCoCsuKkrnFuR8hNy59Iot842IbVBU1vsBfpcE=
X-Received: by 2002:a67:efd0:: with SMTP id s16mr14526105vsp.3.1617023294693;
 Mon, 29 Mar 2021 06:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-4-aford173@gmail.com>
 <CAMuHMdXjQV7YrW5T_P4tkJk_d44NNTQ8Eu7v2ReESjg6R3tvfw@mail.gmail.com> <CAHCN7xLWDx_AjtN7=moJ6VFsimuf16AJOhrxEryvdw5VnKsJwA@mail.gmail.com>
In-Reply-To: <CAHCN7xLWDx_AjtN7=moJ6VFsimuf16AJOhrxEryvdw5VnKsJwA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 29 Mar 2021 15:08:03 +0200
Message-ID: <CAMuHMdUG4gmaVvbg13TMcA8+FL5-7+Qxmdh3X+CNCJQdq_vPkQ@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] net: ethernet: ravb: Enable optional refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
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

On Mon, Mar 29, 2021 at 2:45 PM Adam Ford <aford173@gmail.com> wrote:
> On Thu, Mar 4, 2021 at 2:08 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> > > For devices that use a programmable clock for the AVB reference clock,
> > > the driver may need to enable them.  Add code to find the optional clock
> > > and enable it when available.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > > @@ -2148,6 +2148,13 @@ static int ravb_probe(struct platform_device *pdev)
> > >                 goto out_release;
> > >         }
> > >
> > > +       priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
> > > +       if (IS_ERR(priv->refclk)) {
> > > +               error = PTR_ERR(priv->refclk);
> > > +               goto out_release;
> > > +       }
> > > +       clk_prepare_enable(priv->refclk);
> > > +
> >
> > Shouldn't the reference clock be disabled in case of any failure below?
> >
> I'll generate a V4.
>
> Should I just regenerate this patch since it seems like the rest are
> OK, or should I regenerate the whole series?

As the DT bindings haven't been applied yet, I think it would be
best if you would send a v4 with just the patches for the netdev
tree (i.e. DT bindings patch 1 and driver patch 4).

I will take the DT patches from this series, once the bindings have been
accepted.

Thank you!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
