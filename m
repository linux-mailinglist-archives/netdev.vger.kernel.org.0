Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1DC173D73
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgB1Qsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:48:43 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:48717 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgB1Qsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 11:48:43 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id B75C8FF802;
        Fri, 28 Feb 2020 16:48:40 +0000 (UTC)
Date:   Fri, 28 Feb 2020 17:48:39 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, foss@0leil.net
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: RGMII skew delay
 configuration
Message-ID: <20200228164839.GH1686232@kwain>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
 <20200228155702.2062570-4-antoine.tenart@bootlin.com>
 <20200228162942.GF29979@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200228162942.GF29979@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Feb 28, 2020 at 05:29:42PM +0100, Andrew Lunn wrote:
> > +static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
> > +{
> > +	u32 skew_rx, skew_tx;
> > +	struct device *dev = &phydev->mdio.dev;
> > +
> > +	/* We first set the Rx and Tx skews to their default value in h/w
> > +	 * (0.2 ns).
> > +	 */
> > +	skew_rx = VSC8584_RGMII_SKEW_0_2;
> > +	skew_tx = VSC8584_RGMII_SKEW_0_2;
> > +
> > +	/* Based on the interface mode, we then retrieve (if available) Rx
> > +	 * and/or Tx skews from the device tree. We do not fail if the
> > +	 * properties do not exist, the default skew configuration is a valid
> > +	 * one.
> > +	 */
> > +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> > +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-rx",
> > +				     &skew_rx);
> > +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> > +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-tx",
> > +				     &skew_tx);
> 
> That is not the correct meaning of PHY_INTERFACE_MODE_RGMII_ID etc.
> PHY_INTERFACE_MODE_RGMII_ID means add a 2ns delay on both RX and TX.
> PHY_INTERFACE_MODE_RGMII_RXID means add a 2ns delay on the RX.
> PHY_INTERFACE_MODE_RGMII means 0 delay, with the assumption that
> either the MAC is adding the delay, or the PCB is designed with extra
> copper tracks to add the delay.
> 
> You only need "vsc8584,rgmii-skew-rx" when 2ns is not correct for you
> board, and you need more fine grain control.

I did not know that, thanks for the explanation! So if ID/TXID/RXID is
used, I should configure the Rx and/or Tx skew with
VSC8584_RGMII_SKEW_2_0, except if the dt says otherwise.

> What is not clearly defined, is how you combine
> PHY_INTERFACE_MODE_RGMII* with DT properties. I guess i would enforce
> that phydev->interface is PHY_INTERFACE_MODE_RGMII and then the delays
> in DT are absolute values.

So, if there's a value in the device tree, and the mode corresponds
(RXID for Rx skew), we do use the dt value. That should look like what's
in the patch (except for the default value used when no configuration is
provided in the dt).

> There is also some discussion about what should go in DT. #defines
> like you have, or time in pS, and the driver converts to register
> values. I generally push towards pS.

That would allow a more generic dt binding, and could be used by other
PHY drivers. The difficulty would be to map the pS to allowed values in
the h/w. Should we round them to the upper or lower bound?

I also saw the micrel-ksz90x1 dt documentation describes many skews, not
only one for Rx and one for Tx. How would the generic dt binding would
look like then?

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
