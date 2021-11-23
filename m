Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58B9459E5C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhKWIm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:42:26 -0500
Received: from mail-qv1-f54.google.com ([209.85.219.54]:36844 "EHLO
        mail-qv1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhKWImX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:42:23 -0500
Received: by mail-qv1-f54.google.com with SMTP id kl8so14459173qvb.3;
        Tue, 23 Nov 2021 00:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YD9+CLUS5Xv902/pEfqOtiLcZyXas3B/t1a2ZRr+mI0=;
        b=LXrwxGGnxkX/NVnYsoGww5CRIG6ielkxAfwhqDd0GSTVJi7ckk7pa3rKM7PsENPkVA
         k4+iq7HYlG9sdCCaR04ghEfkWPlmkN5H9HySFaYFsxBEW4eL38N/cfMD6kwc55ItO4ko
         9XCw3J5iQjw21mqVrRUaNFeGg9IP+YJFSfSUbldlFnWO8t+34o1ALrrmMKhAOrEqQLst
         2dut2eYLwS72gN2yTeH/YjkCEeue0s2VC/rJL3DURZnAXItZvvbzAG4bTm1jUgC5leaG
         xUpUpRyTSX9gbyutV9lYuvEhF1XWI++odrR6CIr3ZIm+J7YxbwtMuZ06L5WB+HK/B76Z
         dISQ==
X-Gm-Message-State: AOAM530rTVPAKtpxl0Biidy8BxnFVsxfY/0kqiHOm8RFWV9cOaY9Z+m0
        pREjiWhsxGSNRSA19w3q7qlJeiNsOjNP6w==
X-Google-Smtp-Source: ABdhPJwl7IFfqBvyxvzsIGDvXIqCpOyDF+gdOezzZQWSahoV7nupzS7YLtInPshC/NmOzg9BnWp5fA==
X-Received: by 2002:a05:6214:cac:: with SMTP id s12mr4269630qvs.60.1637656754206;
        Tue, 23 Nov 2021 00:39:14 -0800 (PST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id w10sm5807946qtj.37.2021.11.23.00.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:39:14 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id f9so23788959ybq.10;
        Tue, 23 Nov 2021 00:39:13 -0800 (PST)
X-Received: by 2002:a9f:2431:: with SMTP id 46mr6012282uaq.114.1637656742896;
 Tue, 23 Nov 2021 00:39:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637592133.git.geert+renesas@glider.be> <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
 <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net> <5936f811-fa48-33e9-2a1a-66c68f74aa5e@ieee.org>
In-Reply-To: <5936f811-fa48-33e9-2a1a-66c68f74aa5e@ieee.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Nov 2021 09:38:51 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4C0EgkGXR=MwSuBOFoj7O9xx8xwH5dP8rWzN1ckejQA@mail.gmail.com>
Message-ID: <CAMuHMdX4C0EgkGXR=MwSuBOFoj7O9xx8xwH5dP8rWzN1ckejQA@mail.gmail.com>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}() helpers
To:     Alex Elder <elder@ieee.org>
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

Hi Alex,

On Tue, Nov 23, 2021 at 2:52 AM Alex Elder <elder@ieee.org> wrote:
> On 11/22/21 10:32 AM, Johannes Berg wrote:
> > On Mon, 2021-11-22 at 16:53 +0100, Geert Uytterhoeven wrote:
> >> The existing FIELD_{GET,PREP}() macros are limited to compile-time
> >> constants.  However, it is very common to prepare or extract bitfield
> >> elements where the bitfield mask is not a compile-time constant.
> >
> > I'm not sure it's really a good idea to add a third API here?
> >
> > We have the upper-case (constant) versions, and already
> > {u32,...}_get_bits()/etc.
>
> I've used these a lot (and personally prefer the lower-case ones).
>
> Your new macros don't do anything to ensure the field mask is
> of the right form, which is basically:  (2 ^ width - 1) << shift

> I really like the property that the field mask must be constant.

That's correct. How to enforce that in the non-const case?
BUG()/WARN() is not an option ;-)

> That being said, I've had to use some strange coding patterns
> in order to adhere to the "const only" rule in a few cases.
> So if you can come up with a satisfactory naming scheme I'm
> all for it.

There are plenty of drivers that handle masks stored in a data
structure, so it would be good if they can use a suitable helper,
as open-coding is prone to errors.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
