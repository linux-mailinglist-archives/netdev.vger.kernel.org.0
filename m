Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66AE35FA29
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351494AbhDNSAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:00:20 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:37687 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbhDNSAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 14:00:18 -0400
Received: by mail-vs1-f53.google.com with SMTP id 2so10774755vsh.4;
        Wed, 14 Apr 2021 10:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LrQhYoofWK1qIE+Puebb8490xY7FtwOJErFPSvGIMtY=;
        b=shBio9KXJcxBAmzKpdwcUWISMSsYL8M3tQO4z507KY7PgFMkaEswmzkin+rxfTFEUw
         gE4FBQTec8Moz+tuk7xwCZCQ694Dh34mYn1t3vrNYsTp6XtEo/yIyTOEObyybO6aZjIV
         +skifyO2nWsM3Z3ijX7gtDpYLtrtzg1JcaveBJzpODOGN1jTKKSRu1aEEGN4IlnfJbct
         HDplDg8Oc8YQmB06F4JvM8/oyHSW8KbX3UCwkBx7/t2JOamu5s6mlW8VE7omAkYl9bCY
         w1K2Og6Ug5L+vhdghyXYyoYkr0GknFN1TD18kRjMYxcz+FPdZERqV7nRsbZQvmly1iK3
         7FQg==
X-Gm-Message-State: AOAM531LqaKLI8iIRXD0m1UWr3iM/H2WaoPWUOy+C92HVyEXlTNx93N6
        YjP0GApOe3SOjqCOX6O3o7/nOGUzO3Vp2eRPr8yBXqhjj/o=
X-Google-Smtp-Source: ABdhPJyeOsV8TPzm4qfYRpIEOQxrAj6kXLid0sqN/BtkYP2cUAkLDMXrOtYnopbrTca5CncxrQqmj9wtMiDHf/+FZD8=
X-Received: by 2002:a67:80c4:: with SMTP id b187mr29655934vsd.42.1618423195054;
 Wed, 14 Apr 2021 10:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210412132619.7896-1-aford173@gmail.com> <20210412132619.7896-2-aford173@gmail.com>
 <CAMuHMdU5RfTGs3SCvJX9epKBLOo6o1BQMng49RjrBn+P7QOSeg@mail.gmail.com> <CAHCN7xKp1Lp+KAHwo_GobZoDKQCV9_7Yx2ZNKmTzkkShRBzm_Q@mail.gmail.com>
In-Reply-To: <CAHCN7xKp1Lp+KAHwo_GobZoDKQCV9_7Yx2ZNKmTzkkShRBzm_Q@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 14 Apr 2021 19:59:43 +0200
Message-ID: <CAMuHMdUhwyR8F6PeE1WEtaEtEPrnm0qFtGJ1rGqTJDYSotK8PA@mail.gmail.com>
Subject: Re: [PATCH V4 2/2] net: ethernet: ravb: Enable optional refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Wed, Apr 14, 2021 at 3:08 PM Adam Ford <aford173@gmail.com> wrote:
> On Tue, Apr 13, 2021 at 2:33 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Apr 12, 2021 at 3:27 PM Adam Ford <aford173@gmail.com> wrote:
> > > For devices that use a programmable clock for the AVB reference clock,
> > > the driver may need to enable them.  Add code to find the optional clock
> > > and enable it when available.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > >
> > > ---
> > > V4:  Eliminate the NULL check when disabling refclk, and add a line
> > >      to disable the refclk if there is a failure after it's been
> > >      initialized.
> >
> > Thanks for the update!
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
> >
> > Note that this will call clk_disable_unprepare() in case of failure, which is
> > fine, as that function is a no-op in case of a failed clock.
>
> Geert,
>
> A bot reported that if I jump to out_release may try to free a clock
> if some instances where priv isn't defined.

As priv is allocated using alloc_etherdev_mqs(), priv->refclk is
NULL initially, but priv itself may indeed not be initialized when the first
"goto out_release" is taken.  Sorry for missing that.

> Currently, the priv->clk isn't freed either.  I have heard some
> back-and-forth discussions in other threads on whether or not devm
> functions auto free or not.

The devm_clk_get_optional() will be undone automatically, so there
is no need to handle that explicitly.

> I'm fine with sending a V5 to make the free for the refclock happen
> only when the priv has successfully initialized.  Should I also add

As this patch has been applied to net-next, you''ll have to send
a follow-up fix patch, not a v5.

> one for freeing priv->clk and change all the other goto out_release
> commands to point to this new section?

No, not for priv->clk, due to devm_*().

> I am thinking it would like something like:
>
> free_refclk:
>     clk_disable_unprepare(priv->refclk);

OK.

> free_clk;
>     clk_disable_unprepare(priv->clk);

NAK, as priv->clk is not enabled in ravb_probe().

> out_release:
>     free_netdev(ndev);
>     ....

OK.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
