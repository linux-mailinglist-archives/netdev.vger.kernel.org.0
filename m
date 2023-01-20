Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369A167553D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjATNIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjATNId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:08:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DA710A9C;
        Fri, 20 Jan 2023 05:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p+e/NvIB7bmxQDi/oo2C4pZKqRcCnYcGddLLRMbPNm0=; b=o3XvFdO198H87a5YtpwX4jhfou
        SZ9wJsRChLelf8MapxHfkTJFhY8SYUJnK29xE+5NodAKqAF083/aS5r2DBdJLuagJu4C/uS9y03a/
        ZcTvleA9q2wPL1CYknJKFfGN6nbKiw0UakETAMDohpKtedhzkKgwNhFii8VEoGmON0rc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pIr7w-002j4N-VV; Fri, 20 Jan 2023 14:08:16 +0100
Date:   Fri, 20 Jan 2023 14:08:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Arun.Ramadoss@microchip.com, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, f.fainelli@gmail.com,
        kuba@kernel.org, Woojung.Huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, pabeni@redhat.com, ore@pengutronix.de,
        edumazet@google.com
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Message-ID: <Y8qSQDU36opcXuBE@lunn.ch>
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
 <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
 <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 08:57:03AM +0100, Ahmad Fatoum wrote:
> Hello Arun,
> 
> On 20.01.23 08:01, Arun.Ramadoss@microchip.com wrote:
> > Hi Ahmad,
> > On Thu, 2023-01-19 at 14:10 +0100, Ahmad Fatoum wrote:
> >> [You don't often get email from a.fatoum@pengutronix.de. Learn why
> >> this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >>
> >> EXTERNAL EMAIL: Do not click links or open attachments unless you
> >> know the content is safe
> >>
> >> Starting with commit eee16b147121 ("net: dsa: microchip: perform the
> >> compatibility check for dev probed"), the KSZ switch driver now bails
> >> out if it thinks the DT compatible doesn't match the actual chip:
> >>
> >>   ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
> >>   KSZ8563, please fix it!
> >>
> >> Problem is that the "microchip,ksz8563" compatible is associated
> >> with ksz_switch_chips[KSZ9893]. Same issue also affected the SPI
> >> driver
> >> for the same switch chip and was fixed in commit b44908095612
> >> ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563
> >> chip").
> >>
> >> Reuse ksz_switch_chips[KSZ8563] introduced in aforementioned commit
> >> to get I2C-connected KSZ8563 probing again.
> >>
> >> Fixes: eee16b147121 ("net: dsa: microchip: perform the compatibility
> >> check for dev probed")
> > 
> > In this commit, there is no KSZ8563 member in struct ksz_switch_chips.
> > Whether the fixes should be to this commit "net: dsa: microchip: add
> > separate struct ksz_chip_data for KSZ8563" where the member is
> > introduced.
> 
> I disagree. eee16b147121 introduced the check that made my device
> not probe anymore, so that's what's referenced in Fixes:. Commit
> b44908095612 should have had a Fixes: pointing at eee16b147121
> as well, so users don't miss it. But if they miss it, they
> will notice this at build-time anyway.

So it sounds like two different fixes are needed? For recent kernels
this fix alone is sufficient. But for older kernels additional changes
are needed. Is it sufficient to backport existing patches, or are new
patches needed?

Please start fixing the current kernel. Once that is merged you can
post a fix for older kernels, referencing the merged fix.

     Andrew
