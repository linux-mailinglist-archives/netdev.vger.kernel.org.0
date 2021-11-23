Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F0745999A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 02:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhKWBUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 20:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbhKWBUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 20:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D9BC60FE7;
        Tue, 23 Nov 2021 01:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637630262;
        bh=aoZBtBydzk0bAevU49rnDfe9zlt/fW7CJBCoU7dRxYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DP4A1u9wNAGb4TisYL/xclxXLCsu2eYg5z5kmYiYSKFhn68ml1u5EecsH0UtRKHqf
         6WSeXmftsKJnT0cJoC45C1J/DRKEkyY8ZtRnMG5HUdipvmpB5FFIlmEIJvncTHRUsl
         ZJL0QNbzVlJaWzKiVHfmtZTk38Yn3TlLB2z6CLXnGmgwi//WUT0SYP6cVTF8nOAJxN
         15rOBhxuQkabwtldmp65OfJNj5TeFJmkuLPCAwUI0Dna0FEvAJIm2JVOaykJdOmzdN
         ItdPFw828/65BBT1WXG3h6a2jxgAjBQ+Bbe/D392jq/wYgwXj4sze1/1CQib/FK9DM
         tH9oaaLRu5SxA==
Date:   Mon, 22 Nov 2021 17:17:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
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
Message-ID: <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
References: <cover.1637592133.git.geert+renesas@glider.be>
        <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
        <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 17:32:43 +0100 Johannes Berg wrote:
> On Mon, 2021-11-22 at 16:53 +0100, Geert Uytterhoeven wrote:
> > The existing FIELD_{GET,PREP}() macros are limited to compile-time
> > constants.  However, it is very common to prepare or extract bitfield
> > elements where the bitfield mask is not a compile-time constant.
> 
> I'm not sure it's really a good idea to add a third API here?

+1

> We have the upper-case (constant) versions, and already
> {u32,...}_get_bits()/etc.
> 
> Also, you're using __ffs(), which doesn't work for 64-bit on 32-bit
> architectures (afaict), so that seems a bit awkward.
> 
> Maybe we can make {u32,...}_get_bits() be doing compile-time only checks
> if it is indeed a constant? The __field_overflow() usage is already only
> done if __builtin_constant_p(v), so I guess we can do the same with
> __bad_mask()?

Either that or add decomposition macros. Are compilers still really bad
at passing small structs by value?
