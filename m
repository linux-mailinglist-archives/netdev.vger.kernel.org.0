Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355BD4E65D2
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351214AbiCXPLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242453AbiCXPLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:11:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2654BD1;
        Thu, 24 Mar 2022 08:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=f5oOspRh6b6xUiXhiR6MzWaDr0tDAiwTUoZFSaMVZnY=; b=w9CvSAtf/kpb9Pu/HHyjEICpxE
        zVRVDCUr6YzuaxbNZb8ZQHcu8506AHjM308BqLbF9cwK/DQUwZCBZ0kFJzRgllhp/EgNnZCdnQ5O+
        ZzwLn9txDJrX36POo7o0qNVThGdM86xfaz051rfUqAY2W1kO0SxR18w81tsgCbSrPOIw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXP5v-00CSpN-2B; Thu, 24 Mar 2022 16:09:47 +0100
Date:   Thu, 24 Mar 2022 16:09:47 +0100
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
Subject: Re: [PATCH RFC net-next 2/5] net: phy: support indirect c45 access
 in get_phy_c45_ids()
Message-ID: <YjyJu6AlC/0fRIGE@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-3-michael@walle.cc>
 <Yjt3hHWt0mW6er8/@lunn.ch>
 <7503a496e1456fa65e4317bbe7590d9d@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7503a496e1456fa65e4317bbe7590d9d@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 03:28:43PM +0100, Michael Walle wrote:
> Am 2022-03-23 20:39, schrieb Andrew Lunn:
> > > +static int mdiobus_probe_mmd_read(struct mii_bus *bus, int prtad,
> > > int devad,
> > > +				  u16 regnum)
> > > +{
> > > +	int ret;
> > > +
> > > +	/* For backwards compatibility, treat MDIOBUS_NO_CAP as c45
> > > capable */
> > > +	if (bus->probe_capabilities == MDIOBUS_NO_CAP ||
> > > +	    bus->probe_capabilities >= MDIOBUS_C45)
> > 
> > Maybe we should do the work and mark up those that are C45 capable. At
> > a quick count, see 16 of them.
> 
> I guess you grepped for MII_ADDR_C45 and had a look who
> actually handled it correctly. Correct?

Yes.

> Let's say we mark these as either MDIOBUS_C45 or MDIOBUS_C45_C22,
> can we then drop MDIOBUS_NO_CAP and make MDIOBUS_C22 the default
> value (i.e. value 0) or do we have to go through all the mdio drivers
> and add bus->probe_capabilities = MDIOBUS_C22 ? Grepping for
> {of_,}mdiobus_register lists quite a few of them.

The minimum is marking those that support C45 with MDIOBUS_C45 or
MDIOBUS_C45_C22. We can then really trust it does C45. Those that
don't set probe_capabilities we assume are C22 only. That should be
enough for this problem.

FYI: Yesterday i started actually adding probe_capabilities values to
drivers. I did everything in driver/net/mdio. I will work on the rest
over the next few days and then post an RFC patchset.

     Andrew
