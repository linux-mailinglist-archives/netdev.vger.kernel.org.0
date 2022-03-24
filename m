Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D210E4E5C6A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 01:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346847AbiCXAnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 20:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiCXAni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 20:43:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD708CD96;
        Wed, 23 Mar 2022 17:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D/B2Dpw6sNH43KsLqqa7Q5IzutLkOlwuynLpZFR8xV4=; b=V0SnKBe8ytYusLgGUltCrvcT6M
        gPwHBsGQ22DODlFg1ltoRRupPqaxIIV3X3pdleDY9kTvIjX16aAFhn34kzMTlX2ZlhmnUQAJhQxxi
        OBIijBEGqQkJTVFDqftyjtGvjqX1kQqI+GBo9cViOaFMPuyDymddLobOe0WP8b/b0YNE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXBXs-00CMfO-Q9; Thu, 24 Mar 2022 01:41:44 +0100
Date:   Thu, 24 Mar 2022 01:41:44 +0100
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
Message-ID: <Yju+SGuZ9aB52ARi@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
 <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8304fb3578ee38525a158af768691e75@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Thinking out loud...
> > 
> > 1) We have a C22 only bus. Easy, C45 over C22 should be used.
> > 
> > 2) We have a C45 only bus. Easy, C45 should be used, and it will of
> >    probed that way.
> > 
> > 3) We have a C22 and C45 bus, but MDIOBUS_NO_CAP. It will probe C22,
> >    but ideally we want to swap to C45.
> > 
> > 4) We have a C22 and C45 bus, MDIOBUS_C22_C45. It will probe C22, but
> >    ideally we want to swap to C45.
> 
> I presume you are speaking of
> https://elixir.bootlin.com/linux/v5.17/source/drivers/net/phy/mdio_bus.c#L700

Yes.

> Shouldn't that be the other way around then? How would you tell if
> you can do C45?

For a long time, only C22 was probed. To actually make use of a C45
only PHY, you had to have a compatible string in DT which indicated a
C45 device is present on the bus. But then none DT systems came along
which needed to find a C45 only PHY during probe without the hint it
is was actually there. That is when the probe capabilities we added,
and the scan extended to look for a C45 device if the capabilities
indicates the bus actually supported it. But to keep backwards
compatibility, C22 was scanned first and then C45 afterwards.

To some extent, we need to separate finding the device on the bus to
actually using the device. The device might respond to C22, give us
its ID, get the correct driver loaded based on that ID, and the driver
then uses the C45 address space to actually configure the PHY.

Then there is the Marvel 10G PHY. It responds to C22, but returns 0
for the ID! There is a special case for this in the code, it then
looks in the C45 space and uses the ID from there, if it finds
something useful.

So as i said in my reply to the cover letter, we have two different
state variables:

1) The PHY has the C45 register space.

2) We need to either use C45 transfers, or C45 over C22 transfers to
   access the C45 register space.

And we potentially have a chicken/egg problem. The PHY driver knows
1), but in order to know what driver to load we need the ID registers
from the PHY, or some external hint like DT. We are also currently
only probing C22, or C45, but not C45 over C22. And i'm not sure we
actually can probe C45 over C22 because there are C22 only PHYs which
use those two register for other things. So we are back to the driver
again which does know if C45 over C22 will work.

So phydev->has_c45 we can provisionally set if we probed the PHY by
C45. But the driver should also set it if it knows better, or even the
core can set it the first time the driver uses an _mmd API call.

phydev->c45_over_c22 we are currently in a bad shape for. We cannot
reliably say the bus master supports C45. If the bus capabilities say
C22 only, we can set phydev->c45_over_c22. If the bus capabilities
list C45, we can set it false. But that only covers a few busses, most
don't have any capabilities set. We can try a C45 access and see if we
get an -EOPNOTSUPP, in which case we can set phydev->c45_over_c22. But
the bus driver could also do the wrong thing, issue a C22 transfer and
give us back rubbish.

So i think we do need to review all the bus drivers and any which do
support C45 need their capabilities set to indicate that. We can then
set phydev->c45_over_c22.

    Andrew
