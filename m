Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470F248085B
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 11:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhL1KWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 05:22:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhL1KWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 05:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u0EkY1lnh76MYMJkuit0CKG2uWZXaSFk3KZr7b0LbNQ=; b=rW/VL1WXNy2Jlk87NDxhhvmxVi
        cLOAaGEwe/yMFO1bX4N/ZSFxCHead15+j/eWveTAj51mjFBkzXSRbLyerjnrCcTK31zSmDt1tVZnE
        YG+eO7QFwxHCgla0nS9sLspkWJFRwXZEPFB7JkH8JsVD70Ipf6dBebzetztsA06B2Eso=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n29d2-0001tc-Lx; Tue, 28 Dec 2021 11:22:48 +0100
Date:   Tue, 28 Dec 2021 11:22:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v9, 2/2] net: Add dm9051 driver
Message-ID: <YcrleBNQhHCHhmL5@lunn.ch>
References: <20211227100233.8037-1-josright123@gmail.com>
 <20211227100233.8037-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227100233.8037-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define	dm9051_inb(db, reg, prxb)	dm9051_xfer(db, DM_SPI_RD | (reg), NULL, prxb, 1)
> +#define	dm9051_outb(db, reg, ptxb)	dm9051_xfer(db, DM_SPI_WR | (reg), ptxb, NULL, 1)
> +#define	dm9051_inblk(db, buff, len)	dm9051_xfer(db, DM_SPI_RD | DM_SPI_MRCMD, NULL, buff, len)
> +#define	dm9051_outblk(db, buff, len)	dm9051_xfer(db, DM_SPI_WR | DM_SPI_MWCMD, buff, NULL, len)

How many times do i have to say it, no wrappers. This makes it a lot
less obvious you are throwing away the error code from dm9051_xfer().

> +/* spi low level code */
> +static int dm9051_xfer(struct board_info *db, u8 cmd, u8 *txb, u8 *rxb, unsigned int len)
> +{
> +	struct device *dev = &db->spidev->dev;
> +	int ret;
> +
> +	db->cmd[0] = cmd;
> +	db->spi_xfer2[0].tx_buf = &db->cmd[0];
> +	db->spi_xfer2[0].rx_buf = NULL;
> +	db->spi_xfer2[0].len = 1;
> +	db->spi_xfer2[1].tx_buf = txb;
> +	db->spi_xfer2[1].rx_buf = rxb;
> +	db->spi_xfer2[1].len = len;
> +	ret = spi_sync(db->spidev, &db->spi_msg);
> +	if (ret < 0)
> +		dev_err(dev, "spi burst cmd 0x%02x, ret=%d\n", cmd, ret);
> +	return ret;
> +}
> +
> +static u8 dm9051_getreg(struct board_info *db, unsigned int reg)
> +{
> +	int ret;
> +	u8 rxb[1];
> +
> +	ret = dm9051_inb(db, reg, rxb);
> +	if (ret < 0) {

If ret < 0 you probably have had an SPI error, -EIO, or maybe -ETIMEDOUT? 

> +		if (reg == DM9051_NSR)
> +			return NSR_TX2END | NSR_TX1END;
> +		if (reg == DM9051_EPCR)
> +			return (u8)(~EPCR_ERRE);

So please add a comment explaining why it is O.K. to return these
values when you probably cannot even talk to the device.

> +		return 0;

And here you should be returning the error code. And whatever called
dm9051_getreg() needs to deal with that error code, probably returning
it to its caller, etc.

> +	}
> +	return rxb[0];
> +}
> +

> +static int dm9051_phy_read(struct board_info *db, int reg, int *pvalue)
> +{
> +	int ret;
> +	u8 check_val;
> +	u8 eph, epl;
> +
> +	dm9051_iow(db, DM9051_EPAR, DM9051_PHY | reg);

dm9051_iow() returns an error code. You should check for an error, and
return it. dm9051_mdio_read() already does the correct thing, passing
the error code along. The MDIO core will then pass the error along to
phylib, and phylib will probably report the error to user space and
probably disable the PHY, since the PHY is no longer accessible. That
is how error handling should work.

Since you still do not have the trivial things correct, i've not done
a deep review yet. I would not expect this driver to be merged very
soon, and until somebody does make a deeper review, there could be
more serious things wrong with this driver, like locking.

     Andrew

