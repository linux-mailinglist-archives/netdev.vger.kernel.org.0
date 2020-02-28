Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5CC173CE6
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1Q3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:29:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1Q3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 11:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+BarUbHa0DIMdCJ4YdKKTqxazU9JIOJIattKcJIKp40=; b=xQOEV1dMosp6MpKKNHyWKgNUG2
        drkXV8/kyPRJNcKRNN+ZWdGEhmFcYDfwQb7u4dq0oxKOKP6+I6eDOI/GMhBJLHpWuMqOJTEWBD7Uh
        brZHUK3ZPjY1RN1IL9FzKiaWbLdBqqsKR+ODLgaMZAVhzpChNR3GQlZR16Jq6E5RvL4I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7iWE-00056A-L7; Fri, 28 Feb 2020 17:29:42 +0100
Date:   Fri, 28 Feb 2020 17:29:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: RGMII skew delay
 configuration
Message-ID: <20200228162942.GF29979@lunn.ch>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
 <20200228155702.2062570-4-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228155702.2062570-4-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
> +{
> +	u32 skew_rx, skew_tx;
> +	struct device *dev = &phydev->mdio.dev;
> +
> +	/* We first set the Rx and Tx skews to their default value in h/w
> +	 * (0.2 ns).
> +	 */
> +	skew_rx = VSC8584_RGMII_SKEW_0_2;
> +	skew_tx = VSC8584_RGMII_SKEW_0_2;
> +
> +	/* Based on the interface mode, we then retrieve (if available) Rx
> +	 * and/or Tx skews from the device tree. We do not fail if the
> +	 * properties do not exist, the default skew configuration is a valid
> +	 * one.
> +	 */
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-rx",
> +				     &skew_rx);
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-tx",
> +				     &skew_tx);

Hi Antoine

That is not the correct meaning of PHY_INTERFACE_MODE_RGMII_ID etc.
PHY_INTERFACE_MODE_RGMII_ID means add a 2ns delay on both RX and TX.
PHY_INTERFACE_MODE_RGMII_RXID means add a 2ns delay on the RX.
PHY_INTERFACE_MODE_RGMII means 0 delay, with the assumption that
either the MAC is adding the delay, or the PCB is designed with extra
copper tracks to add the delay.

You only need "vsc8584,rgmii-skew-rx" when 2ns is not correct for you
board, and you need more fine grain control.

What is not clearly defined, is how you combine
PHY_INTERFACE_MODE_RGMII* with DT properties. I guess i would enforce
that phydev->interface is PHY_INTERFACE_MODE_RGMII and then the delays
in DT are absolute values.

There is also some discussion about what should go in DT. #defines
like you have, or time in pS, and the driver converts to register
values. I generally push towards pS.

	 Andrew
