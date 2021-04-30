Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F03D36F5D8
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 08:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhD3GqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 02:46:25 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:33763 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhD3GqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 02:46:04 -0400
Received: by mail-vs1-f47.google.com with SMTP id k19so21969834vsg.0;
        Thu, 29 Apr 2021 23:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCyhrsMrcwz7eYUFY+u5FgUjdPWecvtS2RHoIzlp8Vk=;
        b=S1urxnSZaklf0vxqVuh3yMV5lwWri++HAoyiuiO/COiYn2pBJo5DwSycOc6AzYQ9ok
         4odD2fa6NW2bjnItV+JXTbi5dveBcsEAqLIjlT26aAy/AkfTCsf15ClUZC0WbdcwJemK
         KMEvEexg+sjOmMHtBH+av7tpvqqgHZA/5+KBY35GFEJ6DZjJ7Fu8/lMpSJ5+d+DHsEdb
         g+Vau88/gcQ4WYvScDc+3dhgJnFbluilluFA6doIzSaVdQ8Cj6vffmok76H+JGHbifDF
         EoRDIcAI5B/HfJuGs3hh9GDL7SQFKI3Zg0FMfP7N8c+rqhgfiBH0Ar/9cuvSNY6Vl7Hs
         OLYA==
X-Gm-Message-State: AOAM532EWLYYLGJY5Ea1HR6II7KMGTdjEz/4oRKhkc4AuYORkM9Jd05C
        nQ0zXzSnvTRlOr+KulNCyGWeuNRDMaA76MhGyVk=
X-Google-Smtp-Source: ABdhPJyQ2vJRLPZY9BejYHXQot77jg6kkfHycihR8vioRYxfblpPU0JLybpwJcYR2r/oGWKRadVn1IJWmR5wxTbZuZ8=
X-Received: by 2002:a67:f614:: with SMTP id k20mr4318456vso.42.1619765116419;
 Thu, 29 Apr 2021 23:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210419130106.6707-1-o.rempel@pengutronix.de> <20210419130106.6707-4-o.rempel@pengutronix.de>
In-Reply-To: <20210419130106.6707-4-o.rempel@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 30 Apr 2021 08:45:05 +0200
Message-ID: <CAMuHMdW+cX=vsZg2MyBOM+6Akp-nRQ0QrU=2XSiegFhHNA+jVg@mail.gmail.com>
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

On Mon, Apr 19, 2021 at 3:13 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> Port some parts of the stmmac selftest and reuse it as basic generic selftest
> library. This patch was tested with following combinations:
> - iMX6DL FEC -> AT8035
> - iMX6DL FEC -> SJA1105Q switch -> KSZ8081
> - iMX6DL FEC -> SJA1105Q switch -> KSZ9031
> - AR9331 ag71xx -> AR9331 PHY
> - AR9331 ag71xx -> AR9331 switch -> AR9331 PHY
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thanks for your patch, which is now commit 3e1e58d64c3d0a67 ("net: add
generic selftest support") upstream.

> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -429,6 +429,10 @@ config GRO_CELLS
>  config SOCK_VALIDATE_XMIT
>         bool
>
> +config NET_SELFTESTS
> +       def_tristate PHYLIB

Why does this default to enabled if PHYLIB=y?
Usually we allow the user to make selftests modular, independent of the
feature under test, but I may misunderstand the purpose of this test.

Thanks for your clarification!

> +       depends on PHYLIB
> +

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
