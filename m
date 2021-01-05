Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0892EB344
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbhAETE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:04:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730389AbhAETE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 14:04:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwrcN-00GDkH-Ci; Tue, 05 Jan 2021 20:03:43 +0100
Date:   Tue, 5 Jan 2021 20:03:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] [RFC] net: phy: smsc: Add magnetics VIO regulator support
Message-ID: <X/S4D5wWcON1UMzQ@lunn.ch>
References: <20210105161533.250865-1-marex@denx.de>
 <X/SkAOV6s9vbSYh1@lunn.ch>
 <75b9c711-54af-8d21-f7aa-dc4662ed2234@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b9c711-54af-8d21-f7aa-dc4662ed2234@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 06:53:48PM +0100, Marek Vasut wrote:
> On 1/5/21 6:38 PM, Andrew Lunn wrote:
> > > +static void smsc_link_change_notify(struct phy_device *phydev)
> > > +{
> > > +	struct smsc_phy_priv *priv = phydev->priv;
> > > +
> > > +	if (!priv->vddio)
> > > +		return;
> > > +
> > > +	if (phydev->state == PHY_HALTED)
> > > +		regulator_disable(priv->vddio);
> > > +
> > > +	if (phydev->state == PHY_NOLINK)
> > > +		regulator_enable(priv->vddio);
> > 
> > NOLINK is an interesting choice. Could you explain that please.
> 
> It's the first state after interface is up.

No, not really. phy_start() actually sets it to PHY_UP. When the state
machine runs, it kicks off auto-neg and immediately reads the link
state. If the link is down, it transitions to PHY_NOLINK, at which
point this code will enable the regulator.

> > I fear this is not going to be very robust to state machine
> > changes. And since it is hidden away in a driver, it is going to be
> > forgotten about. You might want to think about making it more robust.
> 
> I marked the patch as RFC because I would like input on how to implement
> this properly. Note that since the regulator supplies the magnetics, which
> might be shared between multiple ports with different PHYs, I don't think
> this code should even be in the PHY driver, but somewhere else -- but I
> don't know where.

Being shared should not be a problem. The regulator API does reference
counting. Any one driver turning the regulator on will enable it. But
it will not be turned off until all the drivers disable it after
enabling it. But that also means you need to balance the calls to
regulator_enable() and regulator_disable().

If for whatever reason this function is called for PHY_HALTED more
times than for PHY_NOLINK, the counter can go negative, and bad things
would happen. So i would actually had a bool to smsc_phy_priv
indicating if the regulator has been enabled. And for each
phydev->state, decide if the regulator should be enabled, check if it
is enabled according to the bool, and enable it is not. Same with
states which indicate it should be disabled. The code is then not
dependent on specific transitions, but on actual states. That should
be more robust to changes.

You also need to think about this regulator being shared. Say some
other PHY has enabled the regulator. phy_start() might be able to skip
PHY_NOLINK state and so this PHY never calls regulator_enable(). If
that other PHY is then configured down, it will disable the regulator,
and this PHY looses link. That probably is enough for this PHY to
re-enable the regulator, but it is not ideal.

	  Andrew

