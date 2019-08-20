Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A5296A50
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbfHTUZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:25:08 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40139 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731107AbfHTUZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:25:05 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1i0Agi-00065h-EK; Tue, 20 Aug 2019 22:25:04 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1i0Agh-0008Lg-7K; Tue, 20 Aug 2019 22:25:03 +0200
Date:   Tue, 20 Aug 2019 22:25:03 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        kernel@pengutronix.de, hkallweit1@gmail.com,
        Ravi.Hegde@microchip.com, Tristram.Ha@microchip.com,
        Yuiko.Oshino@microchip.com
Subject: Re: net: micrel: confusion about phyids used in driver
Message-ID: <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808083637.g77loqpgkzi63u55@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nicolas,

there are some open questions regarding details about some PHYs
supported in the drivers/net/phy/micrel.c driver.

On Thu, Aug 08, 2019 at 10:36:37AM +0200, Uwe Kleine-König wrote:
> On Tue, Jul 02, 2019 at 08:55:07PM +0000, Yuiko.Oshino@microchip.com wrote:
> > >On Fri, May 10, 2019 at 09:22:43AM +0200, Uwe Kleine-König wrote:
> > >> On Thu, May 09, 2019 at 11:07:45PM +0200, Andrew Lunn wrote:
> > >> > On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
> > >> > > On 09.05.2019 22:29, Uwe Kleine-König wrote:
> > >> > > > I have a board here that has a KSZ8051MLL (datasheet:
> > >> > > > http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
> > >> > > > 0x0022155x) assembled. The actual phyid is 0x00221556.

The short version is that a phy with ID 0x00221556 matches two
phy_driver entries in the driver:

	{ .phy_id = PHY_ID_KSZ8031, .phy_id_mask = 0x00ffffff, ... },
	{ .phy_id = PHY_ID_KSZ8051, .phy_id_mask = MICREL_PHY_ID_MASK, ... }

The driver doesn't behave optimal for "my" KSZ8051MLL with both entries
... It seems to work, but not all features of the phy are used and the
bootlog claims this was a KSZ8031 because that's the first match in the
list.

So we're in need of someone who can get their hands on some more
detailed documentation than publicly available to allow to make the
driver handle the KSZ8051MLL correctly without breaking other stuff.

I assume you are in a different department of Microchip than the people
caring for PHYs, but maybe you can still help finding someone who cares?

> > >> > > I think the datasheets are the source of the confusion. If the
> > >> > > datasheets for different chips list 0x0022155x as PHYID each, and
> > >> > > authors of support for additional chips don't check the existing
> > >> > > code, then happens what happened.
> > >> > >
> > >> > > However it's not a rare exception and not Microchip-specific that
> > >> > > sometimes vendors use the same PHYID for different chips.
> > >>
> > >> From the vendor's POV it is even sensible to reuse the phy IDs iff the
> > >> chips are "compatible".
> > >>
> > >> Assuming that the last nibble of the phy ID actually helps to
> > >> distinguish the different (not completely) compatible chips, we need
> > >> some more detailed information than available in the data sheets I have.
> > >> There is one person in the recipents of this mail with an
> > >> @microchip.com address (hint, hint!).
> > >
> > >can you give some input here or forward to a person who can?
> >
> > I forward this to the team.
> 
> This thread still sits in my inbox waiting for some feedback. Did
> something happen on your side?

This is still true, didn't hear back from Yuiko Oshino for some time
now.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
