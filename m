Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81E4E66EA
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351642AbiCXQZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351639AbiCXQZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:25:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1D63D4A8;
        Thu, 24 Mar 2022 09:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Mpi6o7xeN/Ty9X1JVI6zzFbTtsWQQmcFLPuvEEzpv28=; b=5MDxCKDl5ahia3QE0xFnOqhof3
        xWkDmQm1KTUQo3bK/ac0g4lDScq9s+idUmSQyKHIM0TbXzSt+q3yQp+atePfuO8JVAIbmGgRzBpSp
        ayUMw3/ehGCG82LzA1108dkosaZh7gJgc65WHvjUgR2n7qk5g8uKtnOnQq1+wG7kXbow=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXQFL-00CTiC-TQ; Thu, 24 Mar 2022 17:23:35 +0100
Date:   Thu, 24 Mar 2022 17:23:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Message-ID: <YjybB/fseibDU4dT@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
 <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc>
 <Yju+SGuZ9aB52ARi@lunn.ch>
 <30012bd8256be3be9977bd15d1486c84@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30012bd8256be3be9977bd15d1486c84@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > To some extent, we need to separate finding the device on the bus to
> > actually using the device. The device might respond to C22, give us
> > its ID, get the correct driver loaded based on that ID, and the driver
> > then uses the C45 address space to actually configure the PHY.
> > 
> > Then there is the Marvel 10G PHY. It responds to C22, but returns 0
> > for the ID! There is a special case for this in the code, it then
> > looks in the C45 space and uses the ID from there, if it finds
> > something useful.
> > 
> > So as i said in my reply to the cover letter, we have two different
> > state variables:
> > 
> > 1) The PHY has the C45 register space.
> > 
> > 2) We need to either use C45 transfers, or C45 over C22 transfers to
> >    access the C45 register space.
> > 
> > And we potentially have a chicken/egg problem. The PHY driver knows
> > 1), but in order to know what driver to load we need the ID registers
> > from the PHY, or some external hint like DT. We are also currently
> > only probing C22, or C45, but not C45 over C22. And i'm not sure we
> > actually can probe C45 over C22 because there are C22 only PHYs which
> > use those two register for other things. So we are back to the driver
> > again which does know if C45 over C22 will work.
> 
> Isn't it safe to assume that if a PHY implements the indirect
> registers for c45 in its c22 space that it will also have a valid
> PHY ID and then the it's driver will be probed?

See: https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L895

No valid ID in C22 space.

> So if a PHY is
> probed as c22 its driver might tell us "wait, it's actually a c45
> phy and hey for your convenience it also have the indirect registers
> in c22". We can then set has_c45 and maybe c45_over_c22 (also depending
> on the bus capabilities).

In general, if the core can do something, it is better than the driver
doing it. If the core cannot reliably figure it out, then we have to
leave it to the drivers. It could well be we need the drivers to set
has_c45. I would prefer that drivers don't touch c45_over_c22 because
they don't have the knowledge of what the bus is capable of doing. The
only valid case i can think of is for a very oddball PHY which has C45
register space, but cannot actually do C45 transfers, and so C45 over
C22 is the only option.

> > So phydev->has_c45 we can provisionally set if we probed the PHY by
> > C45. But the driver should also set it if it knows better, or even the
> > core can set it the first time the driver uses an _mmd API call.
> 
> I'm not sure about the _mmd calls, there are PHYs which have MMDs
> (I guess EEE is an example?) but are not capable of C45 accesses.

Ah, yes, i forgot about EEE. That was a bad idea.

> > phydev->c45_over_c22 we are currently in a bad shape for. We cannot
> > reliably say the bus master supports C45. If the bus capabilities say
> > C22 only, we can set phydev->c45_over_c22. If the bus capabilities
> > list C45, we can set it false. But that only covers a few busses, most
> > don't have any capabilities set. We can try a C45 access and see if we
> > get an -EOPNOTSUPP, in which case we can set phydev->c45_over_c22. But
> > the bus driver could also do the wrong thing, issue a C22 transfer and
> > give us back rubbish.
> 
> First question, what do you think about keeping the is_c45 property but
> with a different meaning and add use_c45_over_c22. That way it will be
> less code churn:
> 
>  * @is_c45:  Set to true if this PHY has clause 45 address space.
>  * @use_c45_over_c22:  Set to true if c45-over-c22 addressing is used.

I prefer to change is_c45. We then get the compiler to help us with
code review. The build bots will tell us about any code we fail to
check and change. It will also help anybody with out of tree code
making use of is_c45.

       Andrew
