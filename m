Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD99476336
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhLOU0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:26:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhLOU0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 15:26:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=O9kFh7ehOUk1/MEm6VfiaQHDfhj5jsuM6K5g6awA2xs=; b=Zd
        CIt8cleD+O5Pc6obgPlwJ/74fstU+a7274Ya/lCRwbGVVnJmLz7Xwyfvj9ZHwxuklqnnwCkvxPOZD
        9Ep4R/XPH6rZz1M5Lue+JQb8iaJLkcY4Oo5xpoeBMf++Up5vJaMuRdsCCwBpw0Ati39dyr/eCFP9b
        JBKGuYPW8NV9SUI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxaqq-00GgKQ-1P; Wed, 15 Dec 2021 21:26:12 +0100
Date:   Wed, 15 Dec 2021 21:26:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     JosephCHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5, 2/2] net: Add dm9051 driver
Message-ID: <YbpPZMYfBu2RVvQ5@lunn.ch>
References: <20211215073507.16776-1-josright123@gmail.com>
 <20211215073507.16776-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211215073507.16776-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static u8 ior(struct board_info *db, unsigned int reg)

Can we have some meaningful names please.  And don't forget namespace
prefix, ideally dm9051_

> +{
> +	u8 rxb[1];
> +
> +	dm9051_xfer(db, DM_SPI_RD | reg, NULL, rxb, 1);
> +	return rxb[0];
> +}
> +
> +/* chip ID display */
> +static u8 iior(struct device *dev, struct board_info *db, unsigned int r=
eg)

What does the extra i mean?=20

> +{
> +	u8 rxdata;
> +
> +	rxdata =3D ior(db, reg);
> +	if (reg =3D=3D DM9051_PIDL || reg =3D=3D DM9051_PIDH)
> +		dev_dbg(dev, "dm905.MOSI [%02x][..]\n", reg);
> +	if (reg =3D=3D DM9051_PIDL || reg =3D=3D DM9051_PIDH)
> +		dev_info(dev, "dm905.MISO [..][%02x]\n", rxdata);

At appears to be the same condition for both? Is that wrong, or can
they be combined?

> +	return rxdata;
> +}
> +
> +static void iow(struct board_info *db, unsigned int reg, unsigned int va=
l)
> +{
> +	u8 txb[1];
> +
> +	txb[0] =3D val;
> +	dm9051_xfer(db, DM_SPI_WR | reg, txb, NULL, 1);
> +}
> +
> +static void dm9inblk(struct board_info *db, u8 *buff, unsigned int len)

Please make your namespace prefix uniform. I would suggest dm9051_.

> +static int dm_phy_read_func(struct board_info *db, int reg)
> +{
> +	int ret;
> +	u8 check_val;
> +
> +	iow(db, DM9051_EPAR, DM9051_PHY | reg);
> +	iow(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
> +	read_poll_timeout(ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
> +			  true, db, DM9051_EPCR);

read_poll_timeout() return an error code. Don't ignore it.

> +	iow(db, DM9051_EPCR, 0x0);
> +	ret =3D (ior(db, DM9051_EPDRH) << 8) | ior(db, DM9051_EPDRL);
> +	return ret;
> +}
> +
> +static void dm_phy_write_func(struct board_info *db, int reg, int value)

The _func does not add anything useful. Please remove them all.

> +{
> +	u8 check_val;
> +
> +	iow(db, DM9051_EPAR, DM9051_PHY | reg);
> +	iow(db, DM9051_EPDRL, value);
> +	iow(db, DM9051_EPDRH, value >> 8);
> +	iow(db, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
> +	read_poll_timeout(ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
> +			  true, db, DM9051_EPCR);
> +	iow(db, DM9051_EPCR, 0x0);
> +}

> +
> +static int dm9051_mdio_read(struct mii_bus *mdiobus, int phy_id_unused, =
int reg)
> +{
> +	struct board_info *db =3D mdiobus->priv;
> +	int val;
> +
> +	mutex_lock(&db->addr_lock);
> +	val =3D dm_phy_read_func(db, reg);
> +	mutex_unlock(&db->addr_lock);

When you register the mdiobus, the MDIO core will probe all 32
addresses on the bus. It looks like you PHY is on address 1. You
should return 0xffff for all addresses other than 1.

> +
> +	return val;
> +}
> +
> +static int dm9051_mdio_write(struct mii_bus *mdiobus, int phy_id_unused,=
 int reg, u16 val)
> +{
> +	struct board_info *db =3D mdiobus->priv;
> +
> +	mutex_lock(&db->addr_lock);
> +	dm_phy_write_func(db, reg, val);
> +	mutex_unlock(&db->addr_lock);

And here you should return -ENODEV for any address other than 1.

> +static void dm9051_fifo_reset(struct board_info *db)
> +{
> +	db->bc.DO_FIFO_RST_counter++;
> +	dm_phy_write_func(db, MII_ADVERTISE, ADVERTISE_PAUSE_CAP |
> +			  ADVERTISE_ALL | ADVERTISE_CSMA); /* for fcr, essential */

The MAC driver should not be accessing the PHY registers. That is the
PHY drivers job.

> +	iow(db, DM9051_FCR, FCR_FLOW_ENABLE); /* FlowCtrl */
> +	iow(db, DM9051_PPCR, PPCR_PAUSE_COUNT); /* Pause Pkt Count */
> +	iow(db, DM9051_LMCR, db->lcr_all); /* LEDMode1 */
> +	iow(db, DM9051_INTCR, INTCR_POL_LOW); /* INTCR */
> +}
> +

=00> +/* loop rx
> + */
> +static int dm9051_lrx(struct board_info *db)

Why not just call the function dm9051_loop_rx() so you don't need the
comment?

> +/* single tx
> + */
> +static int dm9051_stx(struct board_info *db, u8 *buff, unsigned int len)

dm9051_single_tx() ?

The fact you have a comment suggests the function name is not good.

> +{
> +	int ret;
> +	u8 check_val;
> +
> +	/* shorter waiting time with tx-end check */
> +	ret =3D read_poll_timeout(ior, check_val, check_val & (NSR_TX2END | NSR=
_TX1END),
> +				1, 20, false, db, DM9051_NSR);
> +	dm9outblk(db, buff, len);
> +	iow(db, DM9051_TXPLL, len);
> +	iow(db, DM9051_TXPLH, len >> 8);
> +	iow(db, DM9051_TCR, TCR_TXREQ);

Does it make sense to perform these writes if the timeout failed?

> +	return ret;
> +}
> +
> +static int dm9051_send(struct board_info *db)
> +{
> +	struct net_device *ndev =3D db->ndev;
> +	int ntx =3D 0;
> +
> +	while (!skb_queue_empty(&db->txq)) {
> +		struct sk_buff *skb;
> +
> +		skb =3D skb_dequeue(&db->txq);
> +		if (skb) {
> +			ntx++;
> +			if (dm9051_stx(db, skb->data, skb->len))
> +				netdev_dbg(ndev, "timeout %d--- WARNING---do-ntx\n", ntx);

You should be returning the error up the call stack.

> +			ndev->stats.tx_bytes +=3D skb->len;
> +			ndev->stats.tx_packets++;
> +			dev_kfree_skb(skb);
> +		}
> +	}
> +	return ntx;
> +}
> +
> +/* end with enable the interrupt mask
> + */
> +static irqreturn_t dm9051_rx_threaded_irq(int irq, void *pw)
> +{
> +	struct board_info *db =3D pw;
> +	int nrx;
> +
> +	mutex_lock(&db->spi_lock); /* dlywork essential */

dlywork?

> +	dm_imr_disable_lock_essential(db); /* set imr disable */
> +	if (netif_carrier_ok(db->ndev)) {
> +		mutex_lock(&db->addr_lock);
> +		do {
> +			nrx =3D dm9051_lrx(db);
> +			dm9051_send(db); /* for more performance */
> +		} while (nrx);
> +		mutex_unlock(&db->addr_lock);
> +	}
> +	dm_imr_enable_lock_essential(db); /* set imr enable */
> +	mutex_unlock(&db->spi_lock); /* dlywork essential */
> +	return IRQ_HANDLED;
> +}
> +
> +/* end with enable the interrupt mask
> + */
> +static void dm_stopcode_lock(struct board_info *db)
> +{
> +	mutex_lock(&db->addr_lock);
> +
> +	dm_phy_write_func(db, MII_BMCR, BMCR_RESET); /* PHY RESET */

The PHY driver should do this.

> +	iow(db, DM9051_GPR, 0x01); /* Power-Down PHY */
> +	iow(db, DM9051_RCR, RCR_RX_DISABLE);	/* Disable RX */
> +
> +	mutex_unlock(&db->addr_lock);
> +}
> +
> +/* handle link change
> + */
> +static void dm_handle_link_change(struct net_device *ndev)
> +{
> +	struct phy_device *phydev =3D ndev->phydev;
> +	struct board_info *db =3D netdev_priv(ndev);

Don't you need to tell the MAC about the link speed? Duplex?

> +
> +	phy_print_status(phydev);
> +
> +	if (db->link !=3D phydev->link) {
> +		db->link =3D phydev->link;
> +		netdev_dbg(ndev, "dm_handle_link link=3D %d\n", phydev->link);
> +
> +		if (phydev->link)
> +			netif_carrier_on(ndev);
> +		else
> +			netif_carrier_off(ndev);

phylib will handle the carrier for you.

> +static int dm_phy_connect(struct board_info *db)
> +{
> +	char phy_id[MII_BUS_ID_SIZE + 3];
> +
> +	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> +		 db->mdiobus->id, DM9051_PHY_ID);
> +	db->phydev =3D phy_connect(db->ndev, phy_id, dm_handle_link_change,
> +				 PHY_INTERFACE_MODE_MII);
> +
> +	if (IS_ERR(db->phydev))
> +		return PTR_ERR(db->phydev);
> +
> +	db->phydev->irq =3D PHY_POLL;

Polling is the default, there is no need to set this.

> +	return 0;
> +}
> +
> +static void dm_phy_start(struct board_info *db)
> +{
> +	db->link =3D 0;

db->link does not appear to be useless.

> +	phy_start(db->phydev);
> +	phy_set_asym_pause(db->phydev, true, true);

You should do this before calling start.

But i don't see any code using the results of the autoneg. Does the
MAC really support pause?

> +static int dm9051_open(struct net_device *ndev)
> +{
> +	struct board_info *db =3D netdev_priv(ndev);
> +	int ret;
> +
> +	dm_opencode_lock(ndev, db);
> +
> +	skb_queue_head_init(&db->txq);
> +	netif_start_queue(ndev);
> +	netif_wake_queue(ndev);
> +
> +	ret =3D dm_opencode_receiving(ndev, db);
> +	if (ret < 0) {
> +		netdev_err(ndev, "failed to get irq\n");

It makes more sense to put that error inside dm_opencode_receiving()
where you actually failed to get the interrupt.

> +		return ret;
> +	}
> +
> +	dm_phy_start(db);
> +	netdev_dbg(ndev, "[dm_open] %pM irq_no %d ACTIVE_LOW\n", ndev->dev_addr=
, ndev->irq);
> +	return 0;
> +}
> +
> +static int dm9051_probe(struct spi_device *spi)
> +{
> +	struct device *dev =3D &spi->dev;
> +	struct net_device *ndev;
> +	struct board_info *db;
> +	int ret =3D 0;

=2E..

> +
> +	ret =3D devm_register_netdev(dev, ndev);
> +	if (ret) {
> +		dev_err(dev, "failed to register network device\n");
> +		goto err_netdev;
> +	}
> +
> +	dm_operation_clear(db);

This should probably be before devm_register_netdev() since the device
can be opened while still inside devm_register_netdev()..


> +	return 0;
> +
> +err_netdev:
> +	phy_disconnect(db->phydev);
> +err_phycnnt:
> +err_mdiobus:
> +err_chipid:
> +	return ret;
> +}

  Andrew
