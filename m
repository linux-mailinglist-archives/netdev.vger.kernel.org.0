Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19B735DD7A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 13:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhDMLLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 07:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhDMLLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 07:11:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF98C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 04:10:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1lWGwU-0005NZ-1e; Tue, 13 Apr 2021 13:10:50 +0200
Message-ID: <5277e89e497be121aa7d371a434a3f510fa00e4b.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date:   Tue, 13 Apr 2021 13:10:47 +0200
In-Reply-To: <20210413105144.GN1463@shell.armlinux.org.uk>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
         <c03053f59a89ef6ea4a4f2ce15aee4b4f4892745.camel@pengutronix.de>
         <20210413105144.GN1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

sorry for the noise of this arriving in your inbox twice. Apparently I
messed up and replied in private in my last mail.

Am Dienstag, dem 13.04.2021 um 11:51 +0100 schrieb Russell King - ARM Linux admin:
> On Tue, Apr 13, 2021 at 12:00:45PM +0200, Lucas Stach wrote:
> > I agree with the opinion that those PHY fixups introduce more harm than
> > good. Essentially they are pushing board specific configuration values
> > into the PHY, without any checks that the fixup is even running on the
> > specific board it was targeted at.
> 
> Yes and no. The problem is, that's an easy statement to make when one
> doesn't understand what they're all doing.
> 
> Some are "board specific" in that the normal setup for e.g. iMX6 would
> be to enable clock output from the AR8035 PHY and feed that into the
> iMX6 - as far as I'm aware, that's the only working configuration for
> that SoC and PHY. However, it's also true that this fixup should not
> be applied unconditionally.
> 
> Then there's SmartEEE - it has been found that the PHY defaults for
> this lead to link drops independent of the board and SoC that it is
> connected to. It seems that the PHY is essentially broken - it powers
> up with SmartEEE enabled, and when connected to another SmartEEE
> supporting device, it seems guaranteed that it will result in link
> drops in its default configuration.
> 
> Freescale's approach has apparently been to unconditionally disable
> SmartEEE for all their platforms because of this. With a bit of
> research however (as has been done by Jon and myself) we've found
> that increasing the Tw parameter for 1G connections results in a
> much more stable link.
> 
> So, just saying that these are bad without actually understanding what
> they are doing is _also_ bad.

I'm not saying the fixups are bad per se. What I'm saying is that they
are inherently board specific and the right way to apply them is either
via DT properties, or if absolutely necessary via a fixup that at least
checks that it is running on the specific board it was targeted at.

While SmartEEE disabling will cause no big harm, aside from a bit more
power consumption, a wrong clock configuration can cause major
confusion. Especially if the configuration in DT and values put into
the PHY via fixups differ from each other.

Regards,
Lucas


