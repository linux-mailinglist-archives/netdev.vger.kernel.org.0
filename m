Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3AA2E8D1E
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 17:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbhACQ0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 11:26:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbhACQ0X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 11:26:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kw6CK-00Fntl-8r; Sun, 03 Jan 2021 17:25:40 +0100
Date:   Sun, 3 Jan 2021 17:25:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 2/2] net: ks8851: Register MDIO bus and the internal PHY
Message-ID: <X/HwBOnJvlKd8xq0@lunn.ch>
References: <20201230125358.1023502-1-marex@denx.de>
 <20201230125358.1023502-2-marex@denx.de>
 <X+ykIqQhtjkuDQk9@lunn.ch>
 <4139341d-86b7-db39-6586-d61fd41d8be7@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4139341d-86b7-db39-6586-d61fd41d8be7@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 03, 2021 at 01:58:09PM +0100, Marek Vasut wrote:
> On 12/30/20 5:00 PM, Andrew Lunn wrote:
> > > +static int ks8851_mdio_read(struct mii_bus *bus, int phy_id, int reg)
> > > +{
> > > +	struct ks8851_net *ks = bus->priv;
> > > +
> > > +	if (phy_id != 0)
> > > +		return 0xffffffff;
> > > +
> > 
> > Please check for C45 and return -EOPNOTSUPP.
> 
> The ks8851_reg_read() does all the register checking already.

Not really.

static int ks8851_phy_read(struct net_device *dev, int phy_addr, int reg)
{
	struct ks8851_net *ks = netdev_priv(dev);
	unsigned long flags;
	int ksreg;
	int result;

	ksreg = ks8851_phy_reg(reg);
	if (!ksreg)
		return 0x0;	/* no error return allowed, so use zero */

	ks8851_lock(ks, &flags);
	result = ks8851_rdreg16(ks, ksreg);
	ks8851_unlock(ks, &flags);

	return result;
}

static int ks8851_phy_reg(int reg)
{
	switch (reg) {
	case MII_BMCR:
		return KS_P1MBCR;
	case MII_BMSR:
		return KS_P1MBSR;
	case MII_PHYSID1:
		return KS_PHY1ILR;
	case MII_PHYSID2:
		return KS_PHY1IHR;
	case MII_ADVERTISE:
		return KS_P1ANAR;
	case MII_LPA:
		return KS_P1ANLPR;
	}

	return 0x0;
}

So a C45 reg will cause 0 to be returned, not -EOPNOTSUPP.

   Andrew
