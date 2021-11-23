Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DEF45B075
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhKWXwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhKWXwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 18:52:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBAD760F41;
        Tue, 23 Nov 2021 23:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637711364;
        bh=IW4qN8u05oVacusnPMH1cuKnY7vyge2dygNZ0jyMnfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bMkLLetQudL1AnjDLBkGz2KJV65XFDNAI+qMERM3p2htB/mPltEFDc0SoR5SG7cTn
         yUvjgLX4fj3iycoMCeZbceNqv8VJp4xXmhJ5j4daJdQUx70dPPE1ZSDF3I8EJ3CrBl
         FL9EHxBPJYKnvkt5L2363w5f8MTJ/hI+N0EksRg4Tqq2ECyAP9r+yfiU6OtA4c1HNW
         sJDJxZC66+IkfqVqHU0aoaIJ7PQLiQE76d+ztRn4+dA/AYxJtUD+/ZrA56NgYcGb99
         3NhcCdyp7MdhPQ2MlzMSxitFt7xyg2kF02pUQFCNG1ojXEWE+DZkeLhKg7BQKKAgjZ
         pglhaeH4khWUA==
Date:   Tue, 23 Nov 2021 15:49:22 -0800
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
Message-ID: <20211123154922.600fd3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <637a4183861a1f2cdab52b7652bfa7ed33fbcdd2.camel@sipsolutions.net>
References: <cover.1637592133.git.geert+renesas@glider.be>
        <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
        <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
        <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
        <637a4183861a1f2cdab52b7652bfa7ed33fbcdd2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 17:24:15 +0100 Johannes Berg wrote:
> > (*_replace_bits() seems to be useful, though)  
> 
> Indeed.
> 
> Also as I said in my other mail, the le32/be32/... variants are
> tremendously useful, and they fundamentally cannot be expressed with the
> FIELD_GET() or field_get() macros. IMHO this is a clear advantage to the

Can you elaborate?

> typed versions, and if you ask me we should get rid of the FIELD_GETand
> FIELD_PREP entirely - difficult now, but at least let's not propagate
> that?

I don't see why.
