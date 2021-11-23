Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFED45A789
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbhKWQZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhKWQZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:25:48 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF565C061574;
        Tue, 23 Nov 2021 08:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=T+McMKyDOKDOU+PBL1nHadWch3B4nQMaS2x2M/9vBbU=;
        t=1637684559; x=1638894159; b=FZEKOi6ePb4qAW001XGN4ny0EAoQKUvK8czoKry60NRVFzj
        GV9whpuel/QM1aCcfKZHf0A+Qnd2klugIEob4O0iWYkeUez0tj7rv2BGMitJ9SLYmaUOeOerRPq2i
        y3OfSeSD+T1VyLS+k7/oNlrZAyccxgdW3InWGzLn6OoEKkmkb09Mnh4iEBR0k5Cj00ivPbiOWqQ/r
        HFQne/h8c/BMzABbNFIJgbGZZ1nTbcG/DieqFxLMJ2AhwFiflqenOx4vLewVH9IPtS9Li056PYE6R
        dTlYnezaO43hV8/3veGAgX2ehkv5fUZSFFWRRMPnnb9FQb5h58WdHgHdnyiz097g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mpYYB-001ofh-UH;
        Tue, 23 Nov 2021 17:21:44 +0100
Message-ID: <12825803045d1cec0df968f72a9ef2724a2548fb.camel@sipsolutions.net>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}()
 helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Date:   Tue, 23 Nov 2021 17:21:41 +0100
In-Reply-To: <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com>
References: <cover.1637592133.git.geert+renesas@glider.be>
         <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
         <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
         <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-23 at 09:30 +0100, Geert Uytterhoeven wrote:
> > We have the upper-case (constant) versions, and already
> > {u32,...}_get_bits()/etc.
> 
> These don't work for non-const masks.

Obviously, I know that. Still, just saying.

I'm actually in the opposite camp to you I guess - I much prefer the
typed versions (u32_get_bits() and friends) over the FIELD_GET() macros
that are more magic.

Mostly though that's because the typed ones also have le32_/be32_/...
variants, which are tremendously useful, and so I prefer to use them all
across. In fact, I have considered in the past to just remove the upper-
case macros entirely but ... no time I guess.

> > Also, you're using __ffs(), which doesn't work for 64-bit on 32-bit
> > architectures (afaict), so that seems a bit awkward.
> 
> That's a valid comment. Can be fixed by using a wrapper macro
> that checks if typeof(mask) == u64, and uses an __ffs64() version when
> needed.

You can't really do a typeof()==something, but you can check the size,
so yeah, that could be done.

> > Maybe we can make {u32,...}_get_bits() be doing compile-time only checks
> > if it is indeed a constant? The __field_overflow() usage is already only
> > done if __builtin_constant_p(v), so I guess we can do the same with
> > __bad_mask()?
> 
> Are all compilers smart enough to replace the division by
> field_multiplier(field) by a shift?

In the constant case they are, but you'd have to replace
field_multiplier() with the __ffs(), including the size check discussed
above. Then it's no longer a constant, and then I'm not so sure it would
actually be able to translate it, even if it's "1<<__ffs64(...)". I
guess you can check, or just change it to not use the division and
multiplication, but shifts/masks instead manually?

IOW - I would much prefer to make the type_get_bits() and friends work
for non-constant masks.

In fact, you have e.g. code in drivers/usb/chipidea/udc.c that does
things like cpu_to_le32(mul << __ffs(...)) - though in those cases it's
actually constant today, so you could already write it as
le32_encode_bits(...).

johannes
