Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054654856E5
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbiAEQyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:54:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242052AbiAEQyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 11:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OGLmCVA9YeUOqhx/cnHK+DXaXavbXqNR5Epny/NqukM=; b=Umcx5XUxSmrgiMjf0njGLlNnE2
        f+uzBKr/Gx5VB9jEnMv2D7RZ8h+l2xLMrQUlb3oux1L//DZ8u6JFO77DlL5SScBmDrvefnHkdqbyh
        +Ei8fo9+vaKSmbh1wzL01K1U7Ho32yNl7MBqTqOGjr9qqWr6Wt6KXkurP5ojD6Fd8XBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n59YP-000Zu8-Jc; Wed, 05 Jan 2022 17:54:25 +0100
Date:   Wed, 5 Jan 2022 17:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v10, 2/2] net: Add dm9051 driver
Message-ID: <YdXNQY4YrcemElBK@lunn.ch>
References: <20220105081728.4289-1-josright123@gmail.com>
 <20220105081728.4289-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105081728.4289-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int regmap_dm9051_phy_reg_write(void *context, unsigned int reg, unsigned int val)
> +{
> +	struct board_info *db = context;
> +	int ret;
> +
> +	regmap_write(db->regmap, DM9051_EPAR, DM9051_PHY | reg);

regmap_write() can return an error code. You should check for it, and
return it. The driver is full of code like this. Always check the
return code.

> +	regmap_write(db->regmap, DM9051_EPDRL, val & 0xff);
> +	regmap_write(db->regmap, DM9051_EPDRH, (val >> 8) && 0xff);
> +	regmap_write(db->regmap, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
> +	ret = dm9051_map_poll(db);
> +	regmap_write(db->regmap, DM9051_EPCR, 0x0);
> +
> +	if (reg == MII_BMCR && !(val & 0x0800))

Use the available defines, BMCR_RESET. This then makes a lot more
sense.

> +		mdelay(1); /* need for if activate phyxcer */

However, the MAC driver should not be touching the PHY. The PHY driver
should be resetting the PHY. If the PHY driver uses
genphy_soft_reset(), phy_poll_reset() will poll until the BMCR_RESET
bit is cleared by the PHY indicating it is has completed reset. Or is
the PHY broken and needs longer?

> +static bool dm9051_phymap_writeable(struct device *dev, unsigned int reg)
> +{
> +	if (reg == MII_BMSR || reg == MII_PHYSID1 || reg == MII_PHYSID2)
> +		return false;
> +	return true;
> +}

Do bad things actually happen if you write to these registers?

> +static u8 dm9051_map_read(struct board_info *db, u8 reg)
> +{
> +	struct net_device *ndev = db->ndev;
> +	unsigned int val = 0;
> +	int ret;
> +
> +	ret = regmap_read(db->regmap, reg, &val); /* read only one byte */
> +	if (unlikely(ret))
> +		netif_err(db, drv, ndev, "%s: error %d reading reg %02x\n",
> +			  __func__, ret, reg);

Don't discard the error, return it to the caller.

> +	return val;
> +}
> +
> +static void dm9051_map_write(struct board_info *db, u8 reg, u16 val)
> +{
> +	struct net_device *ndev = db->ndev;
> +	int ret = regmap_write(db->regmap, reg, val);
> +
> +	if (unlikely(ret))
> +		netif_err(db, drv, ndev, "%s: error %d writing reg %02x=%04x\n",
> +			  __func__, ret, reg, val);

Return the error to the caller.

> +static int dm9051_dumpblk(struct board_info *db, unsigned int len)
> +{
> +	int ret;
> +	u8 rxb[1];
> +
> +	while (len--) {
> +		ret = hw_dm9051_spi_read(db, DM_SPI_MRCMD, rxb, 1);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return ret;
> +}

It would be good to have a comment why this function is needed. It
appears to be discarding whatever it reads. Why do you need to do
that?

> +static int dm9051_direct_phyread(struct board_info *db, int reg, int *pvalue)
> +{
> +	u8 eph, epl;
> +	int ret;
> +
> +	ret = dm9051_direct_write(db, DM9051_EPAR, DM9051_PHY | reg);
> +	if (ret < 0)
> +		return ret;
> +	ret = dm9051_direct_write(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = dm9051_direct_poll(db);
> +	if (ret)
> +		return ret;
> +
> +	ret = dm9051_direct_write(db, DM9051_EPCR, 0x0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = dm9051_direct_read(db, DM9051_EPDRH, &eph);
> +	if (ret < 0)
> +		return ret;
> +	ret = dm9051_direct_read(db, DM9051_EPDRL, &epl);
> +	if (ret < 0)
> +		return ret;
> +
> +	*pvalue = (eph << 8) | epl;
> +	return ret;
> +}
> +
> +static int dm9051_direct_phywrite(struct board_info *db, int reg, int value)
> +{

It is not clear why you need this. You already setup a regmap for
access to the PHY. Why are you not using it?

> +static int dm9051_mdio_read(struct mii_bus *mdiobus, int phy_id, int reg)
> +{
> +	struct board_info *db = mdiobus->priv;
> +	int val, ret;
> +
> +	if (phy_id == DM9051_PHY_ID) {
> +		mutex_lock(&db->addr_lock);
> +		ret = dm9051_direct_phyread(db, reg, &val);
> +		mutex_unlock(&db->addr_lock);

At some point, the locking needs a good looking at. The MDIO layer
provides a lock, so there will not be parallel MDIO operations. regmap
also has a lock. So i wonder if this lock is actually required?

> +static unsigned int dm9051_chipid(struct board_info *db)
> +{
> +	struct device *dev = &db->spidev->dev;
> +	unsigned int wpidh, wpidl;
> +	u16 id = 0;
> +
> +	regmap_read(db->regmap, DM9051_PIDH, &wpidh);
> +	regmap_read(db->regmap, DM9051_PIDL, &wpidl);

I'm guessing this is one of the first accesses made to the hardware?
You definitely should be looking at the error codes these return.

> +static int dm9051_direct_reset_code(struct board_info *db)
> +{
> +	int ret;
> +
> +	mdelay(2); /* need before NCR_RST */
> +	ret = dm9051_direct_write(db, DM9051_NCR, NCR_RST); /* NCR reset */
> +	if (ret < 0)
> +		return ret;

A pause before doing a reset? That is odd. What is actually happening
before dm9051_direct_reset_code() is called which means this pause is
required?

	Andrew
