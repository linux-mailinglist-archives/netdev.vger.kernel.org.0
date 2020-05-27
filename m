Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA9B1E42FD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgE0NMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:12:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbgE0NMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 09:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EtYek3xh0NCAHtiuyFEgblF7PX4bt3OdqY2DFTWaqaw=; b=mOe4zXFPx8EdQqXNyqy+g+J1+2
        HzV/gm6ROLE4vJxTi3s/U8LkSpVRQjjCJZ5b1Oizrqn/syhiECKi+ejysDz+pD/dcmjnxyO6aII1g
        xJ39C1oNaiF2iXShOWsia4784lr08/fW1bNYSgKN/PWKhD9Aww8D7UKkbIKof4chBKwo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdvqm-003PCu-Dt; Wed, 27 May 2020 15:12:04 +0200
Date:   Wed, 27 May 2020 15:12:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: dp83869: Add RGMII internal delay
 configuration
Message-ID: <20200527131204.GB793752@lunn.ch>
References: <20200526174716.14116-1-dmurphy@ti.com>
 <20200526174716.14116-5-dmurphy@ti.com>
 <20200527005224.GF782807@lunn.ch>
 <c0867d48-6f04-104b-8192-d61d4464a65f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0867d48-6f04-104b-8192-d61d4464a65f@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If the dt defines rgmii-rx/tx-id then these values are required not
> optional.  That was the discussion on the binding.

How many times do i need to say it. They are optional. If not
specified, default to 2ns.

> > > +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
> > > +				   &dp83869->tx_id_delay);
> > > +	if (ret) {
> > > +		dp83869->tx_id_delay = ret;
> > > +		ret = 0;
> > > +	}
> > > +
> > >   	return ret;
> > >   }
> > >   #else
> > > @@ -367,10 +388,45 @@ static int dp83869_configure_mode(struct phy_device *phydev,
> > >   	return ret;
> > >   }
> > > +static int dp83869_get_delay(struct phy_device *phydev)
> > > +{
> > > +	struct dp83869_private *dp83869 = phydev->priv;
> > > +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
> > > +	int tx_delay = 0;
> > > +	int rx_delay = 0;
> > > +
> > > +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> > > +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
> > > +		tx_delay = phy_get_delay_index(phydev,
> > > +					       &dp83869_internal_delay[0],
> > > +					       delay_size, dp83869->tx_id_delay,
> > > +					       false);
> > > +		if (tx_delay < 0) {
> > > +			phydev_err(phydev, "Tx internal delay is invalid\n");
> > > +			return tx_delay;
> > > +		}
> > > +	}
> > > +
> > > +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> > > +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
> > > +		rx_delay = phy_get_delay_index(phydev,
> > > +					       &dp83869_internal_delay[0],
> > > +					       delay_size, dp83869->rx_id_delay,
> > > +					       false);
> > > +		if (rx_delay < 0) {
> > > +			phydev_err(phydev, "Rx internal delay is invalid\n");
> > > +			return rx_delay;
> > > +		}
> > > +	}
> > So any PHY using these properties is going to pretty much reproduce
> > this code. Meaning is should all be in a helper.
> 
> The issue here is that the phy_mode may only be rgmii-txid so you only want
> to find the tx_delay and return.
> 
> Same with the RXID.  How is the helper supposed to know what delay to return
> and look for?

How does this code do it? It looks at the value of interface.

    Andrew
