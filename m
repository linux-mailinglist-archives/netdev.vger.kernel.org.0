Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08437577307
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 03:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiGQB1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 21:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiGQB1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 21:27:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB9718355;
        Sat, 16 Jul 2022 18:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qd9d0TWrYfbH/1upWcwyDbOCOCV8wK8IsG0AeW32CH0=; b=nH90wlz8CH75ouGFLhmOgVtAx8
        yM/jx0Pc5149RDkbarhuy+WaV9m8tgb9ULd/wW8Y+IV2cTCvduXrvV1Yyvsdxb+T6h+bpiVak1cCx
        3WGJOH5gCDQLc14d3+0XLkExJh1fqPXDVWeg8uiS/qi3V2f7fiISq8JpJQ8eIlziLoG0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCt3c-00Aaif-8B; Sun, 17 Jul 2022 03:26:52 +0200
Date:   Sun, 17 Jul 2022 03:26:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
Message-ID: <YtNlXA4lBeG+gRXH@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com>
 <YtMaKWZyC/lgAQ0i@lunn.ch>
 <984fec49-4c08-9d5a-d62f-c59f106f8fe5@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <984fec49-4c08-9d5a-d62f-c59f106f8fe5@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This seem error prone when new PHY_INTERFACE_MODES are added. I would
> > prefer a WARN_ON_ONCE() in the default: so we get to know about such
> > problems.
> 
> Actually, this is the reason I did not add a default: clause to the
> switch (and instead listed everything out). If a new interface mode is
> added, there will be a warning (as I discovered when preparing this
> patch).

Ah, the compiler produces a warning. O.K. that is good. Better than an
WARN_ON_ONCE at runtime.

> > Bike shedding a bit, but would it be better to use host_side_speed and
> > line_side_speed? When you say link_speed, which link are your
> > referring to? Since we are talking about the different sides of the
> > PHY doing different speeds, the naming does need to be clear.
> When I say "link" I mean the thing that the PMD speaks. That is, one of
> the ethtool link mode bits. I am thinking of a topology like
> 
> 
> MAC (+PCS) <-- phy interface mode (MII) --> phy <-- link mode --> far-end phy
> 
> The way it has been done up to now, the phy interface mode and the link
> mode have the same speed. For some MIIs, (such as MII or GMII) this is
> actually the case, since the data clock changes depending on the data
> speed. For others (SGMII/USXGMII) the data is repeated, but the clock
> rate stays the same. In particular, the MAC doesn't care what the actual
> link speed is, just what configuration it has to use (so it selects the
> right clock etc).
> 
> The exception to the above is when you have no phy (such as for
> 1000BASE-X):
> 
> MAC (+PCS) <-- MDI --> PMD <-- link mode --> far-end PMD
> 
> All of the phy interface modes which can be used this way are
> "non-adaptive." That is, in the above case they have a fixed speed.
> 
> That said, I would like to keep the "phy interface mode speed" named
> "speed" so I don't have to write up a semantic patch to rename it in all
> the drivers.

So you want phydev->speed to be the host side speed. That leaves the
line side speed as a new variable, so it can be called line_side_speed?

I just find link_speed ambiguous, and line_side_speed less so.

The documentation for phydev->speed needs updating to make it clear it
is the host side speed.

   Andrew
