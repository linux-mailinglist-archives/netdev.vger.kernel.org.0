Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9D61D6FF6
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 06:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgEREtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 00:49:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:57592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgEREtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 00:49:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1B1D2AC68;
        Mon, 18 May 2020 04:49:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A03D460347; Mon, 18 May 2020 06:49:20 +0200 (CEST)
Date:   Mon, 18 May 2020 06:49:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Healy <cphealy@gmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 4/7] net: phy: marvell: Add support for
 amplitude graph
Message-ID: <20200518044920.GK21714@lion.mk-sys.cz>
References: <20200517195851.610435-1-andrew@lunn.ch>
 <20200517195851.610435-5-andrew@lunn.ch>
 <CAFXsbZohCG5OScjAszD5vpMacfUEUYK_74FU1tjz4Sm8nbegsg@mail.gmail.com>
 <20200517205150.GB610998@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517205150.GB610998@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 10:51:50PM +0200, Andrew Lunn wrote:
> > > +static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
> > > +                                          int meters)
> > > +{
> > > +       int mV_pair0, mV_pair1, mV_pair2, mV_pair3;
> > > +       int distance;
> > > +       u16 reg;
> > > +       int err;
> > > +
> > > +       distance = meters * 1000 / 805;
> > 
> > With this integer based meters representation, it seems to me that we
> > are artificially reducing the resolution of the distance sampling.
> > For a 100 meter cable, the Marvell implementation looks to support 124
> > sample points.  This could result in incorrect data reporting as two
> > adjacent meter numbers would resolve to the same disatance value
> > entered into the register.  (eg - 2 meters = 2 distance  3 meters = 2
> > distance)
> > 
> > Is there a better way of doing this which would allow for userspace to
> > use the full resolution of the hardware?
> 
> Hi Chris
> 
> I don't see a simple solution to this.
> 
> PHYs/vendors seem to disagree about the ratio. Atheros use
> 824. Marvell use 805. I've no idea what Broadcom, aQuantia uses. We
> would need to limit the choice of step to multiples of whatever the
> vendor picks as its ratio. If the user picks a step of 2m, the driver
> needs to return an error and say sorry, please try 2.488 meter steps
> for Marvell, 2.427 meter steps on Atheros, and who knows what for
> Broadcom. And when the user requests data just for 1-25 meters, the
> driver needs to say sorry, try again with 0.824-24.62, or maybe
> 0.805-24.955. That is not a nice user experience.

How about this?

- user would use meters as unit on ethtool command line but non-integer
  values like "2.4" would be allowed
- request message would use e.g. cm (for consistency with existing cable
  test results)
- driver would round requested values to closest supported (you actually
  already round them)
- optionally, actual values used could be returned in request reply or
  start notification

Michal
