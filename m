Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A802A4A7CF0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348603AbiBCAgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:36:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235935AbiBCAgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 19:36:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ttsIhF/ph2eBwd0E85uNu2nSTC/noJxE0o8Desy50mU=; b=tqPk2kfziTJbUX6cUB8YgqjijY
        YLuHg5J6mY2hM9UTfTlr1jFrI6bnUXBVIohKe5j5DTLsaHigD5oUeZ6ajAoZBcMT3TwrZILPVbEVh
        MNgJwBC9rmaIPuWRf+i79gQKLuWbi/b2bf9qUxLv/7Rna7xdvPj/wKmfUbsFlrAEZX5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFQ6s-0042PT-S2; Thu, 03 Feb 2022 01:36:26 +0100
Date:   Thu, 3 Feb 2022 01:36:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        leon@kernel.org
Subject: Re: [PATCH v16, 2/2] net: Add dm9051 driver
Message-ID: <Yfsjigm19BtSfZcD@lunn.ch>
References: <20220129164346.5535-1-josright123@gmail.com>
 <20220129164346.5535-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220129164346.5535-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dm9051_update_fcr(struct board_info *db)
> +{
> +	u8 fcr = 0;
> +	int ret;
> +
> +	if (db->pause.rx_pause)
> +		fcr |= FCR_BKPM | FCR_FLCE;
> +	if (db->pause.tx_pause)
> +		fcr |= FCR_TXPEN;
> +
> +	ret = regmap_update_bits(db->regmap_dm, DM9051_FCR, 0xff, fcr);

Is 0xff correct here? You only seem interested in FCR_BKPM, FCR_FLCE,
FCR_TXPEN so i would of expected a value based around those.

> +	if (ret)
> +		netif_err(db, drv, db->ndev, "%s: error %d update bits reg %02x\n",
> +			  __func__, ret, DM9051_FCR);
> +	return ret;
> +}
> +
> +static int dm9051_set_fcr(struct board_info *db)
> +{
> +	u8 fcr = 0;
> +	int ret;
> +
> +	if (db->pause.rx_pause)
> +		fcr |= FCR_BKPM | FCR_FLCE;
> +	if (db->pause.tx_pause)
> +		fcr |= FCR_TXPEN;
> +
> +	ret = regmap_write(db->regmap_dm, DM9051_FCR, fcr);
> +	if (ret)
> +		netif_err(db, drv, db->ndev, "%s: error %d write reg %02x\n",
> +			  __func__, ret, DM9051_FCR);
> +	return ret;

I guess you can combine this code somehow, make one call the other?

> +static int dm9051_mdio_register(struct board_info *db)
> +{
> +	struct spi_device *spi = db->spidev;
> +	int ret;
> +
> +	db->mdiobus = devm_mdiobus_alloc(&spi->dev);
> +	if (!db->mdiobus)
> +		return -ENOMEM;
> +
> +	db->mdiobus->priv = db;
> +	db->mdiobus->read = dm9051_mdiobus_read;
> +	db->mdiobus->write = dm9051_mdiobus_write;
> +	db->mdiobus->name = "dm9051-mdiobus";
> +	db->mdiobus->phy_mask = (u32)~GENMASK(1, 1);
> +	db->mdiobus->parent = &spi->dev;
> +	snprintf(db->mdiobus->id, MII_BUS_ID_SIZE,
> +		 "dm9051-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +
> +	ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
> +	if (ret)
> +		dev_err(&spi->dev, "Could not register MDIO bus\n");
> +
> +	return 0;

You should return ret here, since an error might of occurred.

> +static void dm9051_handle_link_change(struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +	int lcl_adv, rmt_adv;
> +
> +	phy_print_status(db->phydev);
> +
> +	/* only write pause settings to mac. since mac and phy are integrated
> +	 * together, such as link state, speed and duplex are sync already
> +	 */
> +	if (db->phydev->link) {
> +		if (db->pause.autoneg == AUTONEG_ENABLE) {
> +			lcl_adv = linkmode_adv_to_mii_adv_t(db->phydev->advertising);
> +			rmt_adv = linkmode_adv_to_mii_adv_t(db->phydev->lp_advertising);
> +
> +			if (lcl_adv & rmt_adv & ADVERTISE_PAUSE_CAP) {
> +				db->pause.rx_pause = true;
> +				db->pause.tx_pause = true;
> +			}

Please look at phydev->pause. It gives you the resolved value, you
don't need to work it out for yourself.  phydev->asym_pause tells you
about asymmetric pause, but you hardware does not support that, so you
don't need it.


> +static int dm9051_set_pauseparam(struct net_device *ndev,
> +				 struct ethtool_pauseparam *pause)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +
> +	db->pause = *pause;
> +
> +	if (pause->autoneg == AUTONEG_DISABLE) {
> +		db->phydev->autoneg = AUTONEG_DISABLE;

As i said before, ksetting is used to change this, not pause. Please
don't set phydev->autoneg like this.

> +		return dm9051_update_fcr(db);
> +	}
> +
> +	db->phydev->autoneg = AUTONEG_ENABLE;

Nor here.

> +	phy_set_sym_pause(db->phydev, pause->rx_pause, pause->tx_pause,
> +			  pause->autoneg);
> +	phy_start_aneg(db->phydev);
> +	return 0;
> +}

> +static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
> +{
> +	struct board_info *db = pw;
> +	int result, result_tx;
> +
> +	mutex_lock(&db->spi_lockm);
> +	if (netif_carrier_ok(db->ndev)) {

Why is carrier relevant here? Maybe the device is trying to give you
the last packets before the carrier went down?

It is also interesting that you don't look at the interrupt service
register. Often you need to clear the interrupt by reading the
interrupt service register.

> +		result = regmap_write(db->regmap_dm, DM9051_IMR, IMR_PAR); /* disable int */
> +		if (result)
> +			goto spi_err;
> +
> +		do {
> +			result = dm9051_loop_rx(db); /* threaded irq rx */
> +			if (result < 0)
> +				goto spi_err;
> +			result_tx = dm9051_loop_tx(db); /* more tx better performance */
> +			if (result_tx < 0)
> +				goto spi_err;
> +		} while (result > 0);
> +
> +		result = regmap_write(db->regmap_dm, DM9051_IMR, db->imr_all); /* enable int */
> +		if (result)
> +			goto spi_err;
> +	}
> +spi_err:
> +	mutex_unlock(&db->spi_lockm);
> +
> +	return IRQ_HANDLED;
> +}
> +

  Andrew
