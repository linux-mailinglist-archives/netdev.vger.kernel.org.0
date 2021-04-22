Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D155368952
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbhDVX3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:29:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVX3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:29:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZikE-000YjU-Sh; Fri, 23 Apr 2021 01:28:26 +0200
Date:   Fri, 23 Apr 2021 01:28:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YIIGmpea6Mf0yzYS@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
 <20210422195921.utxdh5dn4ddltxkf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422195921.utxdh5dn4ddltxkf@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +
> > +		lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> > +
> > +		/* clear MII selection & set it based on interface later */
> > +		data8 &= ~PORT_MII_SEL_M;
> > +
> > +		/* configure MAC based on p->interface */
> > +		switch (p->interface) {
> > +		case PHY_INTERFACE_MODE_MII:
> > +			lan937x_set_gbit(dev, false, &data8);
> > +			data8 |= PORT_MII_SEL;
> > +			break;
> > +		case PHY_INTERFACE_MODE_RMII:
> > +			lan937x_set_gbit(dev, false, &data8);
> > +			data8 |= PORT_RMII_SEL;
> > +			break;
> > +		default:
> > +			lan937x_set_gbit(dev, true, &data8);
> > +			data8 |= PORT_RGMII_SEL;
> > +
> > +			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
> > +			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
> > +
> > +			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> > +				data8 |= PORT_RGMII_ID_IG_ENABLE;
> > +
> > +			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> > +				data8 |= PORT_RGMII_ID_EG_ENABLE;
> 
> This is interesting. If you have an RGMII port connected to an external
> PHY, how do you ensure that either the lan937x driver, or the PHY driver,
> but not both, enable RGMII delays?

What generally happens is the MAC adds no delays, and the PHY acts
upon the interface mode, inserting delays as requested.

There are a very small number of exceptions to this, for boards which
have a PHY which cannot do delays, and the MAC can. If i remember
correctly, this pretty much limited to one MAC vendor. In that case,
the MAC adds delays, if the interface mode requests it, and it always
passes PHY_INTERFACE_MODE_RGMII to the PHY so it does not add delays.

So what needs to be looked at here is what is passed to the phy
connect call? passing p->interface is definitely wrong if the MAC is
acting on it.

If even if the connect is correct, i would still prefer the MAC not do
the delays, let the PHY do it, like nearly every other setup.

	Andrew
