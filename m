Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7966DF07
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjAQNkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjAQNkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:40:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBE912F3F;
        Tue, 17 Jan 2023 05:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xrKKSOUVv+ASQt80kkC00NPCfhX4yZY0bkCCioafhDo=; b=E5vu2qbO2KcNLImk/PiS3FEh6J
        xpMeJGl7nExRkdFy6cJyubOwiZzWioi2jRzWE0khHLUdxjmJc0/UReSvxmN9H2cMW2O6XpD44OMdX
        T2mUn8YKXhF1sqm4LIem76swhy+3l+pwxcYVIGyVoXTqSEpSF2MrHDfhDMAOM01oh4B4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHmCd-002KFX-Jd; Tue, 17 Jan 2023 14:40:39 +0100
Date:   Tue, 17 Jan 2023 14:40:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8alV6FUKsN2x2XZ@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch>
 <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So compatible "ethernet-phy-ieee802.3-c45" results in is_c45 being set
> > true. The if (is_c45 || is then true, so it does not need to call
> > fwnode_get_phy_id(child, &phy_id) so ignores whatever ID is in DT and
> > asks the PHY.
> > 
> > Try this, totally untested:
> > 
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > index b782c35c4ac1..13be23f8ac97 100644
> > --- a/drivers/net/mdio/fwnode_mdio.c
> > +++ b/drivers/net/mdio/fwnode_mdio.c
> > @@ -134,10 +134,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> >          if (rc >= 0)
> >                  is_c45 = true;
> > -       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> > +       if (fwnode_get_phy_id (child, &phy_id))
> >                  phy = get_phy_device(bus, addr, is_c45);
> >          else
> > -               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> > +               phy = phy_device_create(bus, addr, phy_id, is_c45, NULL);
> >          if (IS_ERR(phy)) {
> >                  rc = PTR_ERR(phy);
> >                  goto clean_mii_ts;
> > 
> I think part of the problem is that for C45 there are a few other fields
> that get populated by the ID detection, such as devices_in_package and
> mmds_present. Is this something we can do after running the PHY drivers
> probe function? Or is it too late at that point?

As i hinted, it needs somebody to actually debug this and figure out
why it does not work.

I think what i did above is part of the solution. You need to actually
read the ID from the DT, which if you never call fwnode_get_phy_id()
you never do.

You then need to look at phy_bus_match() and probably remove the

		return 0;
	} else {

so that C22 style ID matching is performed if matching via
c45_ids.device_ids fails.

	Andrew
