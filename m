Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B142F7DEE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbhAOOQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:16:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730027AbhAOOQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 09:16:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0PtT-000l2S-Io; Fri, 15 Jan 2021 15:16:03 +0100
Date:   Fri, 15 Jan 2021 15:16:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: do not allow inband AN for
 2500base-x mode
Message-ID: <YAGjo3RQUjmFb+m7@lunn.ch>
References: <20210114024055.17602-1-kabel@kernel.org>
 <YADNEWkiPQX34Tyo@lunn.ch>
 <20210115005516.03f0f772@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210115005516.03f0f772@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 12:55:16AM +0100, Marek Behún wrote:
> On Fri, 15 Jan 2021 00:00:33 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> > > index 3195936dc5be..b8241820679e 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> > > @@ -55,9 +55,20 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
> > >  {
> > >  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
> > >  		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> > > +
> > > +		if (state->interface == PHY_INTERFACE_MODE_2500BASEX) {
> > > +			if (state->link) {
> > > +				state->speed = SPEED_2500;
> > > +				state->duplex = DUPLEX_FULL;
> > > +			}
> > > +
> > > +			return 0;
> > > +		}
> > > +
> > > +		state->an_complete = 1;  
> > 
> > Should this be here? It seems like a logically different change, it is
> > not clear to me it is to do with PHY_INTERFACE_MODE_2500BASEX.
> 
> This function does not set an_complete at all, and as I understand it,
> it should. But maybe this should be in different commit, and more
> thought put into it. I will rethink it and send another version.

Thanks. A patch should do one thing, do it well, and have a good
commit message explaining why it is making the change. So yes, please
do put this into a patch of its own.

> 
> > >  		state->duplex = status &
> > >  				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
> > > -			                         DUPLEX_FULL : DUPLEX_HALF;
> > > +						DUPLEX_FULL : DUPLEX_HALF;  
> > 
> > This looks like an unintended white space change.
> 
> This change is intended. There were 17 space there istead of 2 tabs + 1
> space. And the last space is not needed, since it does not provide any
> other alignment. Should this be in separate commit?

Yes, white space changes should always be in a separate patch. They
distract from the actual change being made here.

> BTW Andrew, the code in serdes.c does many read and write calls, and it
> could be simplified a lot by implementing modify, setbits and clearbits
> methods, like phy.h implements. Or maybe we can use phy_mmd_* methods
> here instead of mv88e6390_serdes_read/write ?
> 
> I fear such change will make future backporting of new fix commits
> a pain. But I still think it should be done. What do you think?

As you say, it make backporting hard. Are the simplifications worth
it? And it is not limited to just SERDES code, the whole driver has
bits of code doing read/modify/write, so if you are going to make such
changes, it should be done everywhere.

	 Andrew
