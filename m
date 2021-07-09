Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DFA3C2368
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 14:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhGIM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 08:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhGIM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 08:29:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205E9C0613DD;
        Fri,  9 Jul 2021 05:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YNYcekBKHKSeTsSsBYsi5hjnh5Bw7TL0AQNkB23wKdA=; b=EUwzOe//bY+37XTY2FfKmuLC6
        8NNEwRS4joIDAigu1iPATUjlvJTQCqQY8bkxbG6Fga5ElAhj3nvl99jjv186crkTBpsKVDmuBZgHU
        bQbQBs1hQdCIaukdP3X3ppf/a0W2sfx85jjq6cRh5ZoV0jPJZzU9fyYPZ8dPpif50XJGRbC6sYHA4
        pOC7/SliENk5Mx1wEA1cnEClv4AW/wOqeSjnfJmNVJhkcymd1azssbKYI7w50XjbPoZ5EXYs/4fQ7
        NQaYlGroWcic/0cFb9h/IupV8BuOhq/qwgDDQYGX6qL/jqAf/U0tcnCc7HIsjqedwsCcnOLdpg3+w
        zRz07z+Sw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45916)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m1paw-0001qK-Hk; Fri, 09 Jul 2021 13:27:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m1pas-0004xd-VJ; Fri, 09 Jul 2021 13:26:58 +0100
Date:   Fri, 9 Jul 2021 13:26:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: intel-xway: Add RGMII internal delay
 configuration
Message-ID: <20210709122658.GA22278@shell.armlinux.org.uk>
References: <20210709115726.11897-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709115726.11897-1-ms@dev.tdt.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 01:57:26PM +0200, Martin Schiller wrote:
> +static int xway_gphy_of_reg_init(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	int delay_size = ARRAY_SIZE(xway_internal_delay);
> +	s32 rx_int_delay;
> +	s32 tx_int_delay;
> +	int err = 0;
> +	int val;
> +
> +	if (phy_interface_is_rgmii(phydev)) {
> +		val = phy_read(phydev, XWAY_MDIO_MIICTRL);
> +		if (val < 0)
> +			return val;
> +	}
> +
> +	/* Existing behavior was to use default pin strapping delay in rgmii
> +	 * mode, but rgmii should have meant no delay.  Warn existing users.
> +	 */
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
> +		const u16 txskew = (val & XWAY_MDIO_MIICTRL_TXSKEW_MASK) >>
> +				   XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
> +		const u16 rxskew = (val & XWAY_MDIO_MIICTRL_RXSKEW_MASK) >>
> +				   XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
> +
> +		if (txskew > 0 || rxskew > 0)
> +			phydev_warn(phydev,
> +				    "PHY has delays (e.g. via pin strapping), but phy-mode = 'rgmii'\n"
> +				    "Should be 'rgmii-id' to use internal delays txskew:%x rxskew:%x\n",
> +				    txskew, rxskew);
> +	}
> +
> +	/* RX delay *must* be specified if internal delay of RX is used. */
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +		rx_int_delay = phy_get_internal_delay(phydev, dev,
> +						      &xway_internal_delay[0],
> +						      delay_size, true);
> +
> +		if (rx_int_delay < 0) {
> +			phydev_err(phydev, "rx-internal-delay-ps must be specified\n");
> +			return rx_int_delay;
> +		}
> +
> +		val &= ~XWAY_MDIO_MIICTRL_RXSKEW_MASK;
> +		val |= rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
> +	}
> +
> +	/* TX delay *must* be specified if internal delay of TX is used. */
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		tx_int_delay = phy_get_internal_delay(phydev, dev,
> +						      &xway_internal_delay[0],
> +						      delay_size, false);
> +
> +		if (tx_int_delay < 0) {
> +			phydev_err(phydev, "tx-internal-delay-ps must be specified\n");
> +			return tx_int_delay;
> +		}
> +
> +		val &= ~XWAY_MDIO_MIICTRL_TXSKEW_MASK;
> +		val |= tx_int_delay << XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +		err = phy_write(phydev, XWAY_MDIO_MIICTRL, val);
> +
> +	return err;
> +}

Please reconsider the above.  Maybe something like the following would
be better:

	u16 mask = 0;
	int val = 0;

	if (!phy_interface_is_rgmii(phydev))
		return;

	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
		u16 txskew, rxskew;

		val = phy_read(phydev, XWAY_MDIO_MIICTRL);
		if (val < 0)
			return val;

		txskew = (val & XWAY_MDIO_MIICTRL_TXSKEW_MASK) >>
			 XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
		rxskew = (val & XWAY_MDIO_MIICTRL_RXSKEW_MASK) >>
			 XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;

		if (txskew > 0 || rxskew > 0)
			phydev_warn(phydev,
				    "PHY has delays (e.g. via pin strapping), but phy-mode = 'rgmii'\n"
				    "Should be 'rgmii-id' to use internal delays txskew:%x rxskew:%x\n",
				    txskew, rxskew);
		return;
	}

	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
		...
		mask |= XWAY_MDIO_MIICTRL_RXSKEW_MASK;
		val |= rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
	}

	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
		...
		mask |= XWAY_MDIO_MIICTRL_TXSKEW_MASK;
		val |= rx_int_delay << XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
	}

	return phy_modify(phydev, XWAY_MDIO_MIICTRL, mask, val);

Using phy_modify() has the advantage that the read-modify-write is
done as a locked transaction on the bus, meaning that it is atomic.
There isn't a high cost to writing functions in a way that makes use
of that as can be seen from the above.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
