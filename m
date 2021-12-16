Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA33477FA5
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 22:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhLPV5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 16:57:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhLPV5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 16:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qQ2/GAJNApZFHJGvqhKZNxRu6RFm8epoh3iYjRz+zFM=; b=bhMhIuenPbSciuR7s8n23M6Fkf
        KBdRg8NcPF4gbdnHciY9noS3hS9Gp3NqxRUmSQmKSRUkLILm4/v77ayfperbkV0UooiBKuGfu8wQR
        wLpkfmaCaPZfzDgjWLbo29NolviolTVeeJWivGxV0yJJZYCpWYPgfhZ1d+oYanCWXYeo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxyk7-00GmM2-Nf; Thu, 16 Dec 2021 22:56:51 +0100
Date:   Thu, 16 Dec 2021 22:56:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6, 2/2] net: Add dm9051 driver
Message-ID: <Ybu2I1iaSejwuMpI@lunn.ch>
References: <20211216093246.23738-1-josright123@gmail.com>
 <20211216093246.23738-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216093246.23738-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 05:32:46PM +0800, Joseph CHAMG wrote:
> Add davicom dm9051 spi ethernet driver, The driver work with the
> device platform's spi master
> 
> remove the redundant code that phylib has support,
> adjust to be the reasonable sequence,
> fine tune comments, add comments for pause function support
> 
> Tested with raspberry pi 4. Test for netwroking function, CAT5
> cable unplug/plug and also ethtool detect for link state, and
> all are ok.

You have been asked two or three times now to include a list of what
you changed relative to the previous version. This is expected for
kernel patches, just look at other submissions.

> +/* spi low level code */
> +static int
> +dm9051_xfer(struct board_info *db, u8 cmdphase, u8 *txb, u8 *rxb, unsigned int len)
> +{
> +	struct device *dev = &db->spidev->dev;
> +	int ret = 0;
> +
> +	db->cmd[0] = cmdphase;
> +	db->spi_xfer2[0].tx_buf = &db->cmd[0];
> +	db->spi_xfer2[0].rx_buf = NULL;
> +	db->spi_xfer2[0].len = 1;
> +	if (!rxb) {
> +		db->spi_xfer2[1].tx_buf = txb;
> +		db->spi_xfer2[1].rx_buf = NULL;
> +		db->spi_xfer2[1].len = len;
> +	} else {
> +		db->spi_xfer2[1].tx_buf = txb;
> +		db->spi_xfer2[1].rx_buf = rxb;
> +		db->spi_xfer2[1].len = len;
> +	}
> +	ret = spi_sync(db->spidev, &db->spi_msg2);
> +	if (ret < 0)
> +		dev_err(dev, "dm9Err spi burst cmd 0x%02x, ret=%d\n", cmdphase, ret);
> +	return ret;
> +}
> +
> +static u8 dm9051_ior(struct board_info *db, unsigned int reg)
> +{
> +	u8 rxb[1];
> +
> +	dm9051_xfer(db, DM_SPI_RD | reg, NULL, rxb, 1);

dm9051_xfer() returns an error code. You should pass it up the call
stack. We want to know about errors.

> +/* basic read/write to phy
> + */
> +static int dm_phy_read(struct board_info *db, int reg)

Does this comment have any value? From the function name i can see
this is a PHY read.

And you still don't have consistent prefix of dm9051_

> +{
> +	int ret;
> +	u8 check_val;
> +
> +	dm9051_iow(db, DM9051_EPAR, DM9051_PHY | reg);
> +	dm9051_iow(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
> +	ret = read_poll_timeout(dm9051_ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
> +				true, db, DM9051_EPCR);
> +	dm9051_iow(db, DM9051_EPCR, 0x0);
> +	if (ret) {
> +		netdev_err(db->ndev, "timeout read phy register\n");
> +		return DM9051_PHY_NULLVALUE;

No, return whatever read_poll_timeout() returned, probably
-ETIMEDOUT. You need to report the error all the way up the call
stack.

> +	}
> +	ret = (dm9051_ior(db, DM9051_EPDRH) << 8) | dm9051_ior(db, DM9051_EPDRL);
> +	return ret;
> +}
> +
> +static void dm_phy_write(struct board_info *db, int reg, int value)
> +{
> +	int ret;
> +	u8 check_val;
> +
> +	dm9051_iow(db, DM9051_EPAR, DM9051_PHY | reg);
> +	dm9051_iow(db, DM9051_EPDRL, value);
> +	dm9051_iow(db, DM9051_EPDRH, value >> 8);
> +	dm9051_iow(db, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
> +	ret = read_poll_timeout(dm9051_ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
> +				true, db, DM9051_EPCR);
> +	dm9051_iow(db, DM9051_EPCR, 0x0);
> +	if (ret)
> +		netdev_err(db->ndev, "timeout write phy register\n");

And you need to return ret to the caller.

> +static int dm9051_mdio_read(struct mii_bus *mdiobus, int phy_id, int reg)
> +{
> +	struct board_info *db = mdiobus->priv;
> +	int val;
> +
> +	if (phy_id == DM9051_PHY_ID) {
> +		mutex_lock(&db->addr_lock);
> +		val = dm_phy_read(db, reg);
> +		mutex_unlock(&db->addr_lock);
> +		return val;
> +	}
> +
> +	return DM9051_PHY_NULLVALUE;

Please just use 0xffff. Don't hide it.

The MDIO bus has a pull up on the data line. So if you try to read
from a device which does not exist, you get all 1s returned. Registers
are 16 bit wide, so you get 0xffff. When the MDIO is registered the
bus will be probed, and when the read returns 0xffff it knows there is
no device at that address. This is the only time you should use
0xffff. It is not an error, it simply indicates there is no device
there.

> +
> +/* read chip id
> + */
> +static unsigned int dm9051_chipid(struct board_info *db)

Don't you think we can work out this function reads the chip id from
the name of the function. Please only have comments if they are
actually useful.

Useful comments tend to explain why something is being done, not what
is being done.

> +static void dm9051_fifo_reset(struct board_info *db)
> +{
> +	db->bc.DO_FIFO_RST_counter++;
> +
> +	dm9051_iow(db, DM9051_FCR, FCR_FLOW_ENABLE); /* FlowCtrl */
> +	dm9051_iow(db, DM9051_PPCR, PPCR_PAUSE_COUNT); /* Pause Pkt Count */
> +	dm9051_iow(db, DM9051_LMCR, db->lcr_all); /* LEDMode1 */
> +	dm9051_iow(db, DM9051_INTCR, INTCR_POL_LOW); /* INTCR */
> +}

> +static void dm_handle_link_change(struct net_device *ndev)
> +{
> +	/* MAC and phy are integrated together, such as link state, speed,
> +	 * and Duplex are sync inside
> +	 */

What about Pause?

dm9051_fifo_reset() does:
	dm9051_iow(db, DM9051_FCR, FCR_FLOW_ENABLE); /* FlowCtrl */

Is this enabling Pause processing? Do you need to disable it if
autoneg decided it is not wanted?

> +static int dm9051_probe(struct spi_device *spi)
> +{
> +	struct device *dev = &spi->dev;
> +	struct net_device *ndev;
> +	struct board_info *db;
> +	unsigned int id;
> +	int ret = 0;
> +
> +	ndev = devm_alloc_etherdev(dev, sizeof(struct board_info));
> +	if (!ndev)
> +		return -ENOMEM;
> +
> +	SET_NETDEV_DEV(ndev, dev);
> +	dev_set_drvdata(dev, ndev);
> +	db = netdev_priv(ndev);
> +	memset(db, 0, sizeof(struct board_info));

No need to use memset. If you look at how

devm_alloc_etherdev() is implemented you end up here:

https://elixir.bootlin.com/linux/v5.16-rc5/source/net/core/dev.c#L10801

The z in kvzalloc() means zero.

    Andrew
