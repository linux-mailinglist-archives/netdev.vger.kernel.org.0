Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F692198F0
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 09:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfEJHWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 03:22:48 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58585 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfEJHWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 03:22:47 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hOzrg-0005Gk-BT; Fri, 10 May 2019 09:22:44 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hOzrf-0002ZN-9S; Fri, 10 May 2019 09:22:43 +0200
Date:   Fri, 10 May 2019 09:22:43 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: net: micrel: confusion about phyids used in driver
Message-ID: <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190509210745.GD11588@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 11:07:45PM +0200, Andrew Lunn wrote:
> On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
> > On 09.05.2019 22:29, Uwe Kleine-König wrote:
> > > I have a board here that has a KSZ8051MLL (datasheet:
> > > http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
> > > 0x0022155x) assembled. The actual phyid is 0x00221556.
> >
> > I think the datasheets are the source of the confusion. If the
> > datasheets for different chips list 0x0022155x as PHYID each, and
> > authors of support for additional chips don't check the existing code,
> > then happens what happened.
> > 
> > However it's not a rare exception and not Microchip-specific that
> > sometimes vendors use the same PHYID for different chips.

From the vendor's POV it is even sensible to reuse the phy IDs iff the
chips are "compatible".

Assuming that the last nibble of the phy ID actually helps to
distinguish the different (not completely) compatible chips, we need
some more detailed information than available in the data sheets I have.
There is one person in the recipents of this mail with an @microchip.com
address (hint, hint!).

> > And it seems you even missed one: KSZ8795
> > It's a switch and the internal PHY's have id 0x00221550.
> > 
> > If the drivers for the respective chips are actually different then we
> > may change the driver to match the exact model number only.
> > However, if there should be a PHY with e.g. id 0x00221554 out there,
> > it wouldn't be supported any longer and the generic PHY driver would
> > be used (what may work or not).
> 
> We might also want to take a look at the code which matches a driver
> to a PHY ID. Ideally we want the most specific match when looking at
> the mask. We can then have device specific matches, and then a more
> general fallback match using a wider mask.
> 
> No idea how to actually implement that :-(

As this is not a detailed enough description to get a total order[1] we
either must tune the requirement or just rely on the order of
the drivers (as is). Then the more specific entries should be listed
first.

Alternatively if there is no way to distinguish different chips (where
the difference is important) the only possibility is to rely on
additional information that must be provided in a board-specific way.
(i2c is similar here. In the beginning they relied on the slave address,
but this wasn't good enough either.)

Best regards
Uwe

[1] Consider phyid = 0x12345678 and available mask/id pairs:
	0xffffff0f/0x12345608
	0xfffffff0/0x12345670

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
