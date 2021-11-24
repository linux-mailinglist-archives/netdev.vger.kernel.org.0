Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F5A45C6B7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352178AbhKXOKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:10:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356052AbhKXOIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 09:08:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B124C6135F;
        Wed, 24 Nov 2021 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637762378;
        bh=qRP+clj8R/VdWhftZ8Y8X7gwjyLiR1Ndt0XMFQ1d99I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qwjskdleu3wFs5Bp+wvn7/HQgcncwjzNLbZJvm05oYaNrcYQTwWP5OPt4NA+r19ce
         xvpj4Ygu81mu+0T0HClP6KV/QWjpcF9snHTHoGaG5tUeLxnTTWkLES0g3C2OG9fyHP
         3gdMDDzRgjs1FxHFxipNVT3bu4+1WLgAMlUBkLt05N30IajW10WzN8g5y+5eK5i725
         UrYk6tfyltIEGHPLMkyi6LuRszHy8ZTAL81DcgYxpSc8FxYZIzgFUL244Ub8IMFPQK
         iyz4glX1RQI/lDwdXU9D49kB+bXi/+6kFMsXGuBY9Lzmn68zgSqocZJHLF6A/zwCj2
         E8n91Zb/v+PWQ==
Date:   Wed, 24 Nov 2021 05:59:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}()
 helpers
Message-ID: <20211124055935.416dc472@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <05d4673a0343bfd83824d307e9cf8bf92e3814a6.camel@sipsolutions.net>
References: <cover.1637592133.git.geert+renesas@glider.be>
        <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
        <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
        <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
        <637a4183861a1f2cdab52b7652bfa7ed33fbcdd2.camel@sipsolutions.net>
        <20211123154922.600fd3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <05d4673a0343bfd83824d307e9cf8bf92e3814a6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:03:24 +0100 Johannes Berg wrote:
> On Tue, 2021-11-23 at 15:49 -0800, Jakub Kicinski wrote:
> > > Indeed.
> > > 
> > > Also as I said in my other mail, the le32/be32/... variants are
> > > tremendously useful, and they fundamentally cannot be expressed with the
> > > FIELD_GET() or field_get() macros. IMHO this is a clear advantage to the  
> > 
> > Can you elaborate?  
> 
> Well, the way I see it, the only advantage of FIELD_GET() is that it
> will auto-determine the type (based on the mask type.) This cannot work
> if you need be/le conversions, because the be/le type annotations are
> invisible to the compiler.
> 
> So obviously you could write a BE32_FIELD_GET(), but then really that's
> equivalent to be32_get_bits() - note you you have to actually specify
> the type in the macro name. I guess in theory you could make macros
> where the type is an argument (like FIELD_GET_TYPE(be32, ...)), but I
> don't see how that gains anything.

Ah, that's what you meant! Thanks for spelling it out.

FWIW I never found the be/le versions useful. Most of the time the data
comes from bus accessors which swap or is unaligned so you have to do
be/le_get_unaligned, which swaps. Plus if you access/set multiple
fields you'd swap them one by one which seems wasteful.

> > > typed versions, and if you ask me we should get rid of the FIELD_GETand
> > > FIELD_PREP entirely - difficult now, but at least let's not propagate
> > > that?  
> > 
> > I don't see why.  
> 
> Just for being more regular, in the spirit of "there's exactly one
> correct way of doing it" :)

Right now it seems the uppercase macros are more prevalent.

Could just be because of the way the "swapping ones" are defined.
