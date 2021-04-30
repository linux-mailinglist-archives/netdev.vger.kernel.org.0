Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFB436F6BA
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 09:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhD3Hub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 03:50:31 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:37541 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhD3Hua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 03:50:30 -0400
Received: by mail-vs1-f53.google.com with SMTP id 2so35114100vsh.4;
        Fri, 30 Apr 2021 00:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3MtcEBgU5dyOOgckSftFjH0gpeoB/1IYhWDTLXUVAzg=;
        b=RsWObpHcRWajLZaLJTdObKuh0hxQk+q5YKcCQq8hrv6Jvlf8QLQsdFBwVvE//h1oMU
         vZ/Il77MqRY3KMQUXFBliAprdMr9PXnxKbDl/JC+XJa5HPL1dN5l40GaqgBMGzO5QjNz
         I5b9wpmkIJYhf+8SkGl2ZGga0jZosxiH4ivJdFU9Gd17GJ4Xgr+B51dFYF8fS/ZfYgzp
         jhHyZrI+jU76JtQmuQDXX4IStttB6FPBDtTAzIo3lz9ftZgSuxLahX75R0qoAKjIOp6a
         CzNePLfOe0TG6wTy7ZixKQH1PZU5qLeHqzphbmtRzbhDYheLWf1PSeEUZAGFPtTEvQB5
         Lhog==
X-Gm-Message-State: AOAM531zJl3S0T7vbZ0rREgJFoFSElmCvCa9tT49hSZH8ihHgoMKIacV
        uplEYlR0VO6Vb4ID0YaD4vBuKRSK8ZjF6Wl16IQ=
X-Google-Smtp-Source: ABdhPJzB0OFCU7TrJ91DtINuAVZDq5FyGyzedvAgeMbCLbnzKyrGO68lofjcEU3xn1vVl34srnKyAGN1/r3BnLtsCzE=
X-Received: by 2002:a67:f503:: with SMTP id u3mr4568822vsn.3.1619768981686;
 Fri, 30 Apr 2021 00:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <20210419130106.6707-4-o.rempel@pengutronix.de> <CAMuHMdW+cX=vsZg2MyBOM+6Akp-nRQ0QrU=2XSiegFhHNA+jVg@mail.gmail.com>
 <20210430072609.GA6711@pengutronix.de>
In-Reply-To: <20210430072609.GA6711@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 30 Apr 2021 09:49:30 +0200
Message-ID: <CAMuHMdUjU1KEg1PTcDHJKJNXPeGsacHNjiCBy_obA7MNAWJ2QA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/6] net: add generic selftest support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Fri, Apr 30, 2021 at 9:26 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> On Fri, Apr 30, 2021 at 08:45:05AM +0200, Geert Uytterhoeven wrote:
> > On Mon, Apr 19, 2021 at 3:13 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > > Port some parts of the stmmac selftest and reuse it as basic generic selftest
> > > library. This patch was tested with following combinations:
> > > - iMX6DL FEC -> AT8035
> > > - iMX6DL FEC -> SJA1105Q switch -> KSZ8081
> > > - iMX6DL FEC -> SJA1105Q switch -> KSZ9031
> > > - AR9331 ag71xx -> AR9331 PHY
> > > - AR9331 ag71xx -> AR9331 switch -> AR9331 PHY
> > >
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >
> > Thanks for your patch, which is now commit 3e1e58d64c3d0a67 ("net: add
> > generic selftest support") upstream.
> >
> > > --- a/net/Kconfig
> > > +++ b/net/Kconfig
> > > @@ -429,6 +429,10 @@ config GRO_CELLS
> > >  config SOCK_VALIDATE_XMIT
> > >         bool
> > >
> > > +config NET_SELFTESTS
> > > +       def_tristate PHYLIB
> >
> > Why does this default to enabled if PHYLIB=y?
> > Usually we allow the user to make selftests modular, independent of the
> > feature under test, but I may misunderstand the purpose of this test.
> >
> > Thanks for your clarification!
>
> There is nothing against making optional. Should I do it?

Yes please. Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
