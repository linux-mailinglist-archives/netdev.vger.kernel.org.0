Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E90345A7A0
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhKWQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhKWQ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:28:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4713AC061574;
        Tue, 23 Nov 2021 08:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=YDWHeWKgv4r/9Wehkw2ZJglZ0nE6CAjALsQ8jZXrdcM=;
        t=1637684692; x=1638894292; b=QuKynbq9kdH8NbuNaJiTsHXovNX8mUYubfwZlvWWk/x1mUE
        ZRX9xyo0wdm9lnd6xshW0lGP+hFW8Iey28NjmNJv9IOAtLYLt0S1V7U2nKBaDNI8jbEznDDDsMd4h
        qitZNKMu/Jx92KYNQNqwVeXigGzf/hexUOwEIVA4PifclIHOnvR8MEzQA0H29KNgA5EYPnkzBT2I3
        b4r9RgmbiWoG8qOgAywUd5eqLUQ9TcpEe0xBkw57fyIidqhlV79WBSPPUrCl4LPAsbyyVVIjcswtk
        CekrQQ7tsD8bfRxIfBRUEZ+4/Gl5VPxU43t0ba0JsWoh2yACk+ETopzUqeRPTHtw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mpYaf-001olr-5U;
        Tue, 23 Nov 2021 17:24:17 +0100
Message-ID: <637a4183861a1f2cdab52b7652bfa7ed33fbcdd2.camel@sipsolutions.net>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}()
 helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>
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
Date:   Tue, 23 Nov 2021 17:24:15 +0100
In-Reply-To: <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
References: <cover.1637592133.git.geert+renesas@glider.be>
         <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
         <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
         <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-23 at 09:36 +0100, Geert Uytterhoeven wrote:


Ah, here's your comment wrt. which one is nicer :)

> > > We have the upper-case (constant) versions, and already
> > > {u32,...}_get_bits()/etc.
> 
> TBH, I don't like the *_get_bits() API: in general, u32_get_bits() does
> the same as FIELD_GET(), but the order of the parameters is different?

I don't really see how "the order of parameters is different" is a
downside? Yeah it means if you're used to FIELD_GET() then you'll
retrain, but ...?

> (*_replace_bits() seems to be useful, though)

Indeed.

Also as I said in my other mail, the le32/be32/... variants are
tremendously useful, and they fundamentally cannot be expressed with the
FIELD_GET() or field_get() macros. IMHO this is a clear advantage to the
typed versions, and if you ask me we should get rid of the FIELD_GETand
FIELD_PREP entirely - difficult now, but at least let's not propagate
that?

johannes
