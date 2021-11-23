Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C766945A7BE
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhKWQfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:35:30 -0500
Received: from mail-ua1-f42.google.com ([209.85.222.42]:42617 "EHLO
        mail-ua1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbhKWQf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:35:26 -0500
Received: by mail-ua1-f42.google.com with SMTP id t13so44868621uad.9;
        Tue, 23 Nov 2021 08:32:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9TIRszl8dgvuwgR6nhL0A0nOi/JDggQAeXQjF3xH3Y=;
        b=VKa3hFWLqY+/OtL0PTiZF4DLCLK07pPe0KVvYhyaCA70YwmGx2rlsI70rE5kr2wyQ+
         oIbnrtTqEn3FBcUYgddEGjtdeRfS//0v7fCaRwrQvT2ActbSi2gcXq/hd/LL+0YQFnlv
         cVq2oMvcUEb2tzi6V8NgsoxiSc4aclMTECIV+gDdZYzNvR/7k0FHiX3aS2EUQjphSsru
         rdlfwgpkaz9mzI+RNi1uORSHomLA4qn7ShemKnoi8eTbRQjZl+9+psihshJIKXEQq84N
         bzv+Z8xL+bVZUAMjha+7vlUTt7P/d+POvoiu2VsmPEHqE3sqm+FvGcTojwSuj0BFz0hf
         Xjsw==
X-Gm-Message-State: AOAM5313FUF1F/RX6je30Rlo79WJCEgrxKZ0MwyBJMBNwRLok/0rTEuM
        1TBqjYm04K+RU5Wg9G+IlXgFi0/2YwvTYwBM
X-Google-Smtp-Source: ABdhPJyszXvo4yp8uEtdldHH020MjHk7hIZxcaJ+iT/idyXQC9pfreWyP51D4YgUbH6wWFmlQL4rfA==
X-Received: by 2002:ab0:2508:: with SMTP id j8mr10526408uan.16.1637685137194;
        Tue, 23 Nov 2021 08:32:17 -0800 (PST)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id s2sm6600879uap.7.2021.11.23.08.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 08:32:16 -0800 (PST)
Received: by mail-ua1-f43.google.com with SMTP id t13so44868505uad.9;
        Tue, 23 Nov 2021 08:32:16 -0800 (PST)
X-Received: by 2002:a9f:3e01:: with SMTP id o1mr10338972uai.89.1637685125903;
 Tue, 23 Nov 2021 08:32:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637592133.git.geert+renesas@glider.be> <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
 <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
 <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com> <12825803045d1cec0df968f72a9ef2724a2548fb.camel@sipsolutions.net>
In-Reply-To: <12825803045d1cec0df968f72a9ef2724a2548fb.camel@sipsolutions.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Nov 2021 17:31:54 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXwhO30gy42tfGSsEgJAjDOAkQ_cUXMMiSBjMsUj0nqaA@mail.gmail.com>
Message-ID: <CAMuHMdXwhO30gy42tfGSsEgJAjDOAkQ_cUXMMiSBjMsUj0nqaA@mail.gmail.com>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}() helpers
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Tony Lindgren <tony@atomide.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
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
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On Tue, Nov 23, 2021 at 5:21 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2021-11-23 at 09:30 +0100, Geert Uytterhoeven wrote:
> > > We have the upper-case (constant) versions, and already
> > > {u32,...}_get_bits()/etc.
> >
> > These don't work for non-const masks.
>
> Obviously, I know that. Still, just saying.
>
> I'm actually in the opposite camp to you I guess - I much prefer the
> typed versions (u32_get_bits() and friends) over the FIELD_GET() macros
> that are more magic.
>
> Mostly though that's because the typed ones also have le32_/be32_/...
> variants, which are tremendously useful, and so I prefer to use them all
> across. In fact, I have considered in the past to just remove the upper-
> case macros entirely but ... no time I guess.

OK, I have to think a bit about this.
FTR, initially I didn't like the FIELD_{GET,PREP}() macros neither ;-)

> In fact, you have e.g. code in drivers/usb/chipidea/udc.c that does
> things like cpu_to_le32(mul << __ffs(...)) - though in those cases it's
> actually constant today, so you could already write it as
> le32_encode_bits(...).

Yeah, there are lots of opportunities for improvement for
drivers/usb/chipidea/.  I didn't include a conversion patch for that
driver, as it led me too deep into the rabbit hole, and I wanted to
get something posted rather sooner than later...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
