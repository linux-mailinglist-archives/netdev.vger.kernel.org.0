Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756F7437D87
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhJVTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:07:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234078AbhJVTHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ll1Nu1RCmFwYH8jr48ZnmRsMiS+QQxZ5kYtuRp+3W78=; b=bB3z48t6LUCQ3WqC2VoQTeZk+t
        2qkjhu6rRQCJqLz8dvr3k/Bp9M3s/CC867QxiVT6P9Q3gApX+v0yhCqp1Xxm8H62VoMQzkBunlxts
        UV5ZQuPVl/j462lij22SLYHGoBc3N6skGTaws/tSGKANaLYuEW77SN5FXhZk2OAzVx/8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdzqR-00BQ6C-FH; Fri, 22 Oct 2021 21:04:47 +0200
Date:   Fri, 22 Oct 2021 21:04:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH v3 net-next 3/9] net: mscc: ocelot: serialize access to
 the MAC table
Message-ID: <YXMLT4McTTuCb098@lunn.ch>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-4-vladimir.oltean@nxp.com>
 <9628072d-612a-ec6f-ce18-03c7f95ad5dd@gmail.com>
 <20211022180052.5dqafsdv7sa2bckw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022180052.5dqafsdv7sa2bckw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:00:52PM +0300, Vladimir Oltean wrote:
> On Fri, Oct 22, 2021 at 10:34:04AM -0700, Florian Fainelli wrote:
> > On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> > > DSA would like to remove the rtnl_lock from its
> > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
> > > the same MAC table functions as ocelot.
> > > 
> > > This means that the MAC table functions will no longer be implicitly
> > > serialized with respect to each other by the rtnl_mutex, we need to add
> > > a dedicated lock in ocelot for the non-atomic operations of selecting a
> > > MAC table row, reading/writing what we want and polling for completion.
> > > 
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
> > >  include/soc/mscc/ocelot.h          |  3 ++
> > >  2 files changed, 44 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > > index 4e5ae687d2e2..72925529b27c 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > > @@ -20,11 +20,13 @@ struct ocelot_mact_entry {
> > >  	enum macaccess_entry_type type;
> > >  };
> > >  
> > > +/* Must be called with &ocelot->mact_lock held */
> > 
> > I don't know if the sparse annotations: __must_hold() would work here,
> > but if they do, they serve as both comment and static verification,
> > might as well use them?
> 
> I've never come across that annotation before, thanks.
> I'll fix this and the other issue and resend once the build tests for
> this series finish.

If sparse cannot figure it out, mv88e6xxx has:

static void assert_reg_lock(struct mv88e6xxx_chip *chip)
{
        if (unlikely(!mutex_is_locked(&chip->reg_lock))) {
                dev_err(chip->dev, "Switch registers lock not held!\n");
                dump_stack();
        }
}

which is a bit heavier in weight, but the MDIO bus transaction will
dominate the time for such operations, not checking a mutex.

	 Andrew
