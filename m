Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37712459E46
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhKWIj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:39:56 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:38702 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhKWIjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:39:53 -0500
Received: by mail-pf1-f177.google.com with SMTP id g18so18742942pfk.5;
        Tue, 23 Nov 2021 00:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FgjXJ8P5x6753ZmnEdNgxnrYu2hwLrUsYessbs9ojVo=;
        b=6658mnYGNQwqQmEDjlPo3znLOQEfgOzHdSus6KWXFVKYwu7zWi9pNohT4fK0jmGEDk
         xiyuTgZB6oLHBbCpKiR1H5CzOH/DutGFi1hyiyMN9SFzzC61QVYqKLAI4d3RVSVr2os4
         q7MTwZoC/48vT1amJkfO0uXme5b6YG7wM2vloZ1LEZAasKImO+nvq7eEpwPdNR+YtR+k
         JieX/ILG8fH28X6hD+r1AfibuEZOqjEwub+dN1D6uRG+TAx9/VaGO4x1NVc+HXJ4QPA/
         Q3oK5wq+eXVgIBUeShDyql2p+YMUn6tELhLbNeCZlJi1Q/lYjIZyJERHzXNFg1aKSfQa
         0gyw==
X-Gm-Message-State: AOAM532Gl5wxq1rdQ5Kuc/vCkH93Ougbo1cKa//5t67D0kWMMusrpcc/
        b0Vlbq6Y4xeHUBc94H6QYAtrcmPHdVJAQg==
X-Google-Smtp-Source: ABdhPJyd8QfC7Cy+/mmwqXLYGCzoHQwwEYBlNYTKQXB3doAopRICuRz5DDsjJ39sv+kJay1iSc3btg==
X-Received: by 2002:a63:2245:: with SMTP id t5mr2589103pgm.436.1637656604742;
        Tue, 23 Nov 2021 00:36:44 -0800 (PST)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com. [209.85.210.171])
        by smtp.gmail.com with ESMTPSA id k14sm8347539pga.65.2021.11.23.00.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:36:44 -0800 (PST)
Received: by mail-pf1-f171.google.com with SMTP id o4so18720612pfp.13;
        Tue, 23 Nov 2021 00:36:44 -0800 (PST)
X-Received: by 2002:a67:c38f:: with SMTP id s15mr6604777vsj.50.1637656593105;
 Tue, 23 Nov 2021 00:36:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637592133.git.geert+renesas@glider.be> <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
 <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net> <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Nov 2021 09:36:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
Message-ID: <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}() helpers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Nov 23, 2021 at 2:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 22 Nov 2021 17:32:43 +0100 Johannes Berg wrote:
> > On Mon, 2021-11-22 at 16:53 +0100, Geert Uytterhoeven wrote:
> > > The existing FIELD_{GET,PREP}() macros are limited to compile-time
> > > constants.  However, it is very common to prepare or extract bitfield
> > > elements where the bitfield mask is not a compile-time constant.
> >
> > I'm not sure it's really a good idea to add a third API here?
>
> +1

Yeah, a smaller API is better.

> > We have the upper-case (constant) versions, and already
> > {u32,...}_get_bits()/etc.

TBH, I don't like the *_get_bits() API: in general, u32_get_bits() does
the same as FIELD_GET(), but the order of the parameters is different?
(*_replace_bits() seems to be useful, though)

That's why I picked field_{get,prep}().

> > Also, you're using __ffs(), which doesn't work for 64-bit on 32-bit
> > architectures (afaict), so that seems a bit awkward.
> >
> > Maybe we can make {u32,...}_get_bits() be doing compile-time only checks
> > if it is indeed a constant? The __field_overflow() usage is already only
> > done if __builtin_constant_p(v), so I guess we can do the same with
> > __bad_mask()?
>
> Either that or add decomposition macros. Are compilers still really bad
> at passing small structs by value?

Sorry, I don't get what you mean by adding decomposition macros.
Can you please elaborate?
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
