Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5098F3C2414
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGINRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:17:51 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:57099 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhGINRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 09:17:50 -0400
X-Greylist: delayed 780 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2021 09:17:50 EDT
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m1q8g-0007AX-Il; Fri, 09 Jul 2021 15:01:54 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m1q8d-0002Wf-0i; Fri, 09 Jul 2021 15:01:51 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 42704240041;
        Fri,  9 Jul 2021 15:01:50 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 96504240040;
        Fri,  9 Jul 2021 15:01:49 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 35DF220196;
        Fri,  9 Jul 2021 15:01:49 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 09 Jul 2021 15:01:49 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: intel-xway: Add RGMII internal delay
 configuration
Organization: TDT AG
In-Reply-To: <20210709122658.GA22278@shell.armlinux.org.uk>
References: <20210709115726.11897-1-ms@dev.tdt.de>
 <20210709122658.GA22278@shell.armlinux.org.uk>
Message-ID: <2811b4b95827a8b2988e31afd47a6514@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1625835711-00007B90-695157FA/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-09 14:26, Russell King (Oracle) wrote:
> On Fri, Jul 09, 2021 at 01:57:26PM +0200, Martin Schiller wrote:
>> +static int xway_gphy_of_reg_init(struct phy_device *phydev)
>> +{
>> +	struct device *dev = &phydev->mdio.dev;
>> +	int delay_size = ARRAY_SIZE(xway_internal_delay);
>> +	s32 rx_int_delay;
>> +	s32 tx_int_delay;
>> +	int err = 0;
>> +	int val;
>> +
>> +	if (phy_interface_is_rgmii(phydev)) {
>> +		val = phy_read(phydev, XWAY_MDIO_MIICTRL);
>> +		if (val < 0)
>> +			return val;
>> +	}
>> +
>> +	/* Existing behavior was to use default pin strapping delay in rgmii
>> +	 * mode, but rgmii should have meant no delay.  Warn existing users.
>> +	 */
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
>> +		const u16 txskew = (val & XWAY_MDIO_MIICTRL_TXSKEW_MASK) >>
>> +				   XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
>> +		const u16 rxskew = (val & XWAY_MDIO_MIICTRL_RXSKEW_MASK) >>
>> +				   XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
>> +
>> +		if (txskew > 0 || rxskew > 0)
>> +			phydev_warn(phydev,
>> +				    "PHY has delays (e.g. via pin strapping), but phy-mode = 
>> 'rgmii'\n"
>> +				    "Should be 'rgmii-id' to use internal delays txskew:%x 
>> rxskew:%x\n",
>> +				    txskew, rxskew);
>> +	}
>> +
>> +	/* RX delay *must* be specified if internal delay of RX is used. */
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
>> +		rx_int_delay = phy_get_internal_delay(phydev, dev,
>> +						      &xway_internal_delay[0],
>> +						      delay_size, true);
>> +
>> +		if (rx_int_delay < 0) {
>> +			phydev_err(phydev, "rx-internal-delay-ps must be specified\n");
>> +			return rx_int_delay;
>> +		}
>> +
>> +		val &= ~XWAY_MDIO_MIICTRL_RXSKEW_MASK;
>> +		val |= rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
>> +	}
>> +
>> +	/* TX delay *must* be specified if internal delay of TX is used. */
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
>> +		tx_int_delay = phy_get_internal_delay(phydev, dev,
>> +						      &xway_internal_delay[0],
>> +						      delay_size, false);
>> +
>> +		if (tx_int_delay < 0) {
>> +			phydev_err(phydev, "tx-internal-delay-ps must be specified\n");
>> +			return tx_int_delay;
>> +		}
>> +
>> +		val &= ~XWAY_MDIO_MIICTRL_TXSKEW_MASK;
>> +		val |= tx_int_delay << XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
>> +	}
>> +
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
>> +		err = phy_write(phydev, XWAY_MDIO_MIICTRL, val);
>> +
>> +	return err;
>> +}
> 
> Please reconsider the above.  Maybe something like the following would
> be better:
> 
> 	u16 mask = 0;
> 	int val = 0;
> 
> 	if (!phy_interface_is_rgmii(phydev))
> 		return;
> 
> 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
> 		u16 txskew, rxskew;
> 
> 		val = phy_read(phydev, XWAY_MDIO_MIICTRL);
> 		if (val < 0)
> 			return val;
> 
> 		txskew = (val & XWAY_MDIO_MIICTRL_TXSKEW_MASK) >>
> 			 XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
> 		rxskew = (val & XWAY_MDIO_MIICTRL_RXSKEW_MASK) >>
> 			 XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
> 
> 		if (txskew > 0 || rxskew > 0)
> 			phydev_warn(phydev,
> 				    "PHY has delays (e.g. via pin strapping), but phy-mode = 
> 'rgmii'\n"
> 				    "Should be 'rgmii-id' to use internal delays txskew:%x 
> rxskew:%x\n",
> 				    txskew, rxskew);
> 		return;
> 	}
> 
> 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> 		...
> 		mask |= XWAY_MDIO_MIICTRL_RXSKEW_MASK;
> 		val |= rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
> 	}
> 
> 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> 		...
> 		mask |= XWAY_MDIO_MIICTRL_TXSKEW_MASK;
> 		val |= rx_int_delay << XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
> 	}
> 
> 	return phy_modify(phydev, XWAY_MDIO_MIICTRL, mask, val);
> 
> Using phy_modify() has the advantage that the read-modify-write is
> done as a locked transaction on the bus, meaning that it is atomic.
> There isn't a high cost to writing functions in a way that makes use
> of that as can be seen from the above.
> 

Thanks for the hint. I'll update my patch.
