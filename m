Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AA922C82
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 09:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbfETHFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 03:05:32 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53849 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfETHFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 03:05:31 -0400
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1hScMT-0008TC-Lo; Mon, 20 May 2019 09:05:29 +0200
Subject: Re: [PATCH v4 3/3] net: ethernet: add ag71xx driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
References: <20190519080304.5811-1-o.rempel@pengutronix.de>
 <20190519080304.5811-4-o.rempel@pengutronix.de>
 <20190520003302.GA1695@lunn.ch>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <5e836144-44e5-d99c-716c-8af42486a6b0@pengutronix.de>
Date:   Mon, 20 May 2019 09:05:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520003302.GA1695@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.05.19 02:33, Andrew Lunn wrote:
> Hi Oleksij
> 
>> +static int ag71xx_mdio_mii_read(struct mii_bus *bus, int addr, int reg)
>> +{
>> +	struct ag71xx *ag = bus->priv;
>> +	struct net_device *ndev = ag->ndev;
>> +	int err;
>> +	int ret;
>> +
>> +	err = ag71xx_mdio_wait_busy(ag);
>> +	if (err)
>> +		return err;
>> +
>> +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_WRITE);
> 
> It looks like you have not removed this.

done.

> 
>> +	ag71xx_wr(ag, AG71XX_REG_MII_ADDR,
>> +			((addr & 0xff) << MII_ADDR_SHIFT) | (reg & 0xff));
>> +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_READ);
>> +
>> +	err = ag71xx_mdio_wait_busy(ag);
>> +	if (err)
>> +		return err;
>> +
>> +	ret = ag71xx_rr(ag, AG71XX_REG_MII_STATUS);
>> +	/*
>> +	 * ar9331 doc: bits 31:16 are reserved and must be must be written
>> +	 * with zero.
>> +	 */
>> +	ret &= 0xffff;
>> +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_WRITE);
> 
> Or this.

this one is needed. MII_CMD_WRITE is a wrong name, it is actually disabling MII_CMD_READ mode.

> 
>> +
>> +	netif_dbg(ag, link, ndev, "mii_read: addr=%04x, reg=%04x, value=%04x\n",
>> +		  addr, reg, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ag71xx_mdio_mii_write(struct mii_bus *bus, int addr, int reg,
>> +				 u16 val)
>> +{
>> +	struct ag71xx *ag = bus->priv;
>> +	struct net_device *ndev = ag->ndev;
>> +
>> +	netif_dbg(ag, link, ndev, "mii_write: addr=%04x, reg=%04x, value=%04x\n",
>> +		  addr, reg, val);
>> +
>> +	ag71xx_wr(ag, AG71XX_REG_MII_ADDR,
>> +			((addr & 0xff) << MII_ADDR_SHIFT) | (reg & 0xff));
> 
> addr have the vale 0-31. So a mask of 0xff is a couple of bits too
> big.

done

> 
>> +	ag71xx_wr(ag, AG71XX_REG_MII_CTRL, val);
>> +
>> +	return ag71xx_mdio_wait_busy(ag);
>> +}
> 
>> +static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>> +{
>> +	struct net_device *ndev = ag->ndev;
>> +	struct phy_device *phydev = ndev->phydev;
>> +	u32 cfg2;
>> +	u32 ifctl;
>> +	u32 fifo5;
>> +
>> +	if (!phydev->link && update) {
>> +		ag71xx_hw_stop(ag);
>> +		netif_carrier_off(ag->ndev);
> 
> phylib will take care of the carrier for you.

done

>         Andrew

thx!

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
