Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B32D49630F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378569AbiAUQnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:43:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48000 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345050AbiAUQna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 11:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=71LLfUhyDwMweskzZKXdE3f5ZkhuGFWfdviiAGRKnfg=; b=a5bJO3lG3XVMDyrs7pqXaXGfQk
        fqWy8Mxk/L2Al9gf2dSC9mGG0vRL8FKKTrWulBelSBto0Ov6MkGCRpDuBEdVOtRTeHgeQRzwn7ZDI
        uwemEENyAI84kSe3FfI79T0tUSVnSr3tpbOATjDVuuhCasETAeKsr0ZLH7GCwhTYDIOY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAx0P-00274K-8N; Fri, 21 Jan 2022 17:43:17 +0100
Date:   Fri, 21 Jan 2022 17:43:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v12, 2/2] net: Add dm9051 driver
Message-ID: <YeripbSOeq1s2U3u@lunn.ch>
References: <20220121041428.6437-1-josright123@gmail.com>
 <20220121041428.6437-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121041428.6437-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ctrl_dm9051_phywrite(void *context, unsigned int reg, unsigned int val)
> +{
> +	/* chip internal operation need wait 1 ms for if power-up phy
> +	 */

> +	if (reg == MII_BMCR && !(val & BMCR_PDOWN))
> +		mdelay(1);

What PHY driver are you using? It would be much better to have this in
the PHY driver. The MAC driver should not be touching the PHY.

> +static int dm9051_phy_connect(struct board_info *db)
> +{
> +	char phy_id[MII_BUS_ID_SIZE + 3];
> +
> +	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> +		 db->mdiobus->id, DM9051_PHY_ID);
> +
> +	db->phydev = phy_connect(db->ndev, phy_id, dm9051_handle_link_change,
> +				 PHY_INTERFACE_MODE_MII);
> +	if (IS_ERR(db->phydev))
> +		return PTR_ERR_OR_ZERO(db->phydev);

Why PTR_ERR_OR_ZERO()

> +static int dm9051_direct_fifo_reset(struct board_info *db)
> +{
> +	struct net_device *ndev = db->ndev;
> +	int rxlen = le16_to_cpu(db->eth_rxhdr.rxlen);

reverse christmas tree. There are a few more cases. Please review the
whole driver.

> +/* transmit a packet,
> + * return value,
> + *   0 - succeed
> + *  -ETIMEDOUT - timeout error
> + */
> +static int dm9051_single_tx(struct board_info *db, u8 *buff, unsigned int len)
> +{
> +	int ret;
> +
> +	ret = dm9051_map_xmitpoll(db);
> +	if (ret)
> +		return -ETIMEDOUT;
> +

If dm9051_map_xmitpoll() returns an error code, use it. There needs to
be a good reason to change the error code, and if you have such a good
reason, please add a comment about it.

> +static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
> +{
> +	struct board_info *db = pw;
> +	int result, resul_tx;
> +
> +	mutex_lock(&db->spi_lockm); /* mutex essential */

When are mutex's not essential? This commit seems to be
meaningless. It gives the impression you don't understand mutex's and
locking in general. You have just added mutex until it seems to work,
not that you have a locking design.

> +	if (netif_carrier_ok(db->ndev)) {
> +		result = regmap_write(db->regmap_dm, DM9051_IMR, IMR_PAR); /* disable imr */
> +		if (unlikely(result))
> +			goto spi_err;
> +
> +		do {
> +			result = dm9051_loop_rx(db); /* threaded irq rx */
> +			if (result < 0)
> +				goto spi_err;
> +			resul_tx = dm9051_loop_tx(db); /* more tx better performance */
> +			if (resul_tx < 0)

result_tx
     ^
> +				goto spi_err;
> +		} while (result > 0);
> +
> +		result = regmap_write(db->regmap_dm, DM9051_IMR, db->imr_all); /* enable imr */
> +		if (unlikely(result))
> +			goto spi_err;
> +	}
> +spi_err:
> +	mutex_unlock(&db->spi_lockm); /* mutex essential */
> +	return IRQ_HANDLED;
> +}


> +static int dm9051_map_phyup(struct board_info *db)
> +{
> +	int ret;
> +
> +	/* ~BMCR_PDOWN to power-up phyxcer
> +	 */
> +	ret = mdiobus_modify(db->mdiobus, DM9051_PHY_ID, MII_BMCR, BMCR_PDOWN, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* chip internal operation need wait 1 ms for if GPR power-up phy
> +	 */
> +	ret = regmap_write(db->regmap_dm, DM9051_GPR, 0);
> +	if (unlikely(ret))
> +		return ret;
> +	mdelay(1);

The phy driver should do this. Again, what PHY driver are you using?

> +static int dm9051_map_phydown(struct board_info *db)
> +{
> +	int ret;
> +
> +	ret = regmap_write(db->regmap_dm, DM9051_GPR, GPR_PHY_ON); /* Power-Down PHY */
> +	if (unlikely(ret))
> +		return ret;
> +	return ret;
> +}

Cam you still access the PHY after this? Does it loose its
configuration?

> +	/* We may have start with auto negotiation */
> +	db->phydev->autoneg = AUTONEG_ENABLE;
> +	db->phydev->speed = 0;
> +	db->phydev->duplex = 0;

If you have to touch these, something is wrong. Please explain.

   Andrew
