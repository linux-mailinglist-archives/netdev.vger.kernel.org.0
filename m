Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC86A5B8C
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjB1PTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjB1PTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:19:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED5D1BDD;
        Tue, 28 Feb 2023 07:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zwW+4gd3F5yXOYkip5ivoXoY6ESEwPmDr04pFhZyrTE=; b=eUirMW3JW9zpSl8j40PwfYf62f
        xxmgrkyy9pxbbOnk4wjJDrUNwlA3rJKbeYylIfIA6BB8QWnTimmRyDDUMg6SaK35cXTVK4DlhtcM5
        4WjaGfGJiN1JhgShFDU/B0BZaeWSzHFq+mm8OzcbViL+5hZ32hyeE7D+j+mgbiYLWEkw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pX1kx-006AXx-CN; Tue, 28 Feb 2023 16:19:07 +0100
Date:   Tue, 28 Feb 2023 16:19:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ken Sloat <ken.s@variscite.com>
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Message-ID: <Y/4ba4s37NayCIwW@lunn.ch>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <Y/4VV6MwM9xA/3KD@lunn.ch>
 <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 03:13:59PM +0000, Ken Sloat wrote:
> Hi Andrew,
> 
> Thanks for your quick reply!
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, February 28, 2023 9:53 AM
> > To: Ken Sloat <ken.s@variscite.com>
> > Cc: Michael Hennerich <michael.hennerich@analog.com>; Heiner Kallweit
> > <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S.
> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
> > detection
> > 
> > On Tue, Feb 28, 2023 at 09:40:56AM -0500, Ken Sloat wrote:
> > > Enhanced link detection is an ADI PHY feature that allows for earlier
> > > detection of link down if certain signal conditions are met. This
> > > feature is for the most part enabled by default on the PHY. This is
> > > not suitable for all applications and breaks the IEEE standard as
> > > explained in the ADI datasheet.
> > >
> > > To fix this, add override flags to disable enhanced link detection for
> > > 1000BASE-T and 100BASE-TX respectively by clearing any related feature
> > > enable bits.
> > >
> > > This new feature was tested on an ADIN1300 but according to the
> > > datasheet applies equally for 100BASE-TX on the ADIN1200.
> > >
> > > Signed-off-by: Ken Sloat <ken.s@variscite.com>
> > Hi Ken
> > 
> > > +static int adin_config_fld_en(struct phy_device *phydev)
> > 
> > Could we have a better name please. I guess it means Fast Link Down, but
> > the commit messages talks about Enhanced link detection. This function is
> > also not enabling fast link down, but disabling it, so _en seems wrong.
> > 
> "Enhanced Link Detection" is the ADI term, but the associated register for controlling this feature is called "FLD_EN." I considered "ELD" as that makes more sense language wise but it did not match the datasheet and did not want to invent a new term. I was not sure what the F was but perhaps you are right, as the link is brought down as part of this feature when conditions are met. I am guessing then that this FLD is a carryover from some initial name of the feature that was later re-branded.
> 
> I am happy to change fld -> eld or something else that might make more sense for users and am open to any suggestions.

The Marvell PHYs also support a fast link down mode, so i think using
fast link down everywhere, in the code and the commit message would be
good. How about adin_fast_down_disable().

> > You need to document these two properties in the device tree binding.
> > 
> 
> I already have a separate patch for this. I will send both patches
> when I re-submit and CC additional parties.

It is normal to submit them together as a patch set. What generally
happens is that the DT maintainers ACK the documentation patch, and
then it gets merged via the netdev tree.

   Andrew
