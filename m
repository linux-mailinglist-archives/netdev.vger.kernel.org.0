Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B90A46E0B9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhLICMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:12:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhLICMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 21:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=89Bsga30mqUmQHtyFwResRpT2A3Y4qkMq6qfAM5HF/c=; b=BamqbvpYqM/GncL6f1jyBaqfh2
        JVohNY9SLmG6P0uCkafB49oNX+OpF48Gp7fUHlN6MEiQl+8EjgrRjhS8T2C8mSUkOb8tp9wcSG19P
        EvQIoC7DFe5ZX2bNT0DRqKkBtjaiePksskf1yCGpwhS9m5e94ICLioaXp0bFj1R2Kxys=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv8rP-00FwFd-JJ; Thu, 09 Dec 2021 03:08:39 +0100
Date:   Thu, 9 Dec 2021 03:08:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Add DM9051 driver
Message-ID: <YbFlJ0SRqGfq4dDv@lunn.ch>
References: <20211202204656.4411-1-josright123@gmail.com>
 <20211202204656.4411-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202204656.4411-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int burst_xfer(struct board_info *db, u8 cmdphase, u8 *txb, u8 *rxb, unsigned int len)
> +static int dm_phy_read_func(struct board_info *db, int reg)
> +static int dm9051_phy_read_lock(struct net_device *dev, int phy_reg_unused, int reg)

Please be consistent with your namespace. Please use the dm9051_
prefix everywhere.

> +{
> +	int ret;
> +
> +	iow(db, DM9051_EPAR, DM9051_PHY | reg);
> +	iow(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
> +	while (ior(db, DM9051_EPCR) & EPCR_ERRE)
> +		;

include/linux/iopoll.h No potentially endless loops please.

> +static unsigned int dm9051_chipid(struct device *dev, struct board_info *db)
> +{
> +	unsigned int chipid;
> +
> +	chipid = iior(dev, db, DM9051_PIDL);
> +	chipid |= (unsigned int)iior(dev, db, DM9051_PIDH) << 8;
> +	if (chipid == (DM9051_ID >> 16))
> +		return chipid;
> +	chipid = iior(dev, db, DM9051_PIDL);
> +	chipid |= (unsigned int)iior(dev, db, DM9051_PIDH) << 8;
> +	if (chipid == (DM9051_ID >> 16))
> +		return chipid;
> +	dev_info(dev, "Read [DM9051_PID] = %04x\n", chipid);
> +	dev_info(dev, "Read [DM9051_PID] error!\n");
> +	return 0;

If this is an error case, returning 0 is not a good idea. -ENODEV?

> +static void dm9051_phy_advertise_pausecap_func(struct board_info *db)
> +{
> +	int phy4 = dm_phy_read_func(db, MII_ADVERTISE); //DBG_20140407
> +
> +	dm_phy_write_func(db, MII_ADVERTISE, phy4 | ADVERTISE_PAUSE_CAP); // dm95 flow-control RX!
> +}

Use seem to be using the deprecated mii code. Please replace it with
phylib. phylib will then do things like advertising.

> +static void dm9051_reset(struct board_info *db)
> +{
> +	mdelay(2); //delay 2 ms any need before NCR_RST (20170510)

Since this is a new driver, there is no history. Comments like
20170510 don't add anything useful.

> +static void IMR_DISABLE_LOCK_ESSENTIAL(struct board_info *db)

Don't use upper case for functions.

> +{
> +	ADDR_LOCK_HEAD_ESSENTIAL(db);
> +	imr_reg_stop(db);
> +	ADDR_LOCK_TAIL_ESSENTIAL(db);
> +}

> +static int dm9051_read_mac_to_dev(struct device *dev, struct net_device *ndev,
> +				  struct board_info *db)
> +{
> +	int i;
> +	u8 mac_fix[ETH_ALEN] = { 0x00, 0x60, 0x6e, 0x90, 0x51, 0xee };
> +
> +	for (i = 0; i < ETH_ALEN; i++)
> +		ndev->dev_addr[i] = ior(db, DM9051_PAR + i);
> +	if (!is_valid_ether_addr(ndev->dev_addr)) {

You should use a random MAC address. eth_hw_addr_random(ndev);


> +		for (i = 0; i < ETH_ALEN; i++)
> +			iow(db, DM9051_PAR + i, mac_fix[i]);
> +		for (i = 0; i < ETH_ALEN; i++)
> +			ndev->dev_addr[i] = ior(db, DM9051_PAR + i);
> +		dev_info(dev, "dm9 [reg_netdev][%s][chip MAC: %pM (%s)]\n",
> +			 ndev->name, ndev->dev_addr, "FIX-1");

dev_dbg() ?

> +		return 0;
> +	}
> +	return 1;

If this is an error, please use an error code.

> +static void dm_set_mac_lock(struct board_info *db)
> +{
> +	struct net_device *ndev = db->ndev;
> +
> +	if (db->enter_setmac) {
> +		int i, oft;
> +
> +		db->enter_setmac = 0;
> +		netdev_info(ndev, "set_mac_address %02x %02x %02x  %02x %02x %02x\n",
> +			    ndev->dev_addr[0], ndev->dev_addr[1], ndev->dev_addr[2],
> +			    ndev->dev_addr[3], ndev->dev_addr[4], ndev->dev_addr[5]);

netdev_dbg()

Also, %pM can be used here.

> +static
> +const struct net_device_ops dm9051_netdev_ops = {
> +	.ndo_open = dm9051_open,
> +	.ndo_stop = dm9051_stop,
> +	.ndo_start_xmit = DM9051_START_XMIT,
> +	.ndo_set_rx_mode = dm9051_set_multicast_list_schedule,

_schedule? This is called in a context you can make blocking calls. So
i don't see why you need the work queue.

> +static void dm9051_get_drvinfo(struct net_device *dev,
> +			       struct ethtool_drvinfo *info)
> +{
> +	struct board_info *dm = to_dm9051_board(dev);
> +
> +	strscpy(info->driver, DRVNAME_9051, sizeof(info->driver));
> +	strscpy(info->version, dm->DRV_VERSION, sizeof(info->version));

version is meaningless. Please leave it empty, and the core will fill
it in with the kernel version.

> +	strscpy(info->bus_info, dev_name(dev->dev.parent), sizeof(info->bus_info));
> +}
> +
> +/* LNX_KERNEL_v58 */

58? We are only at version 5 at the moment?

> +/* Tips: reset and increase the RST counter
> + */

Tips? 

> +static void dm9051_fifo_reset(u8 state, u8 *hstr, struct board_info *db)
> +{
> +	db->bc.DO_FIFO_RST_counter++;
> +	dm9051_reset(db);
> +}
> +
> +static void dm9051_reset_dm9051(struct board_info *db, int rxlen)
> +{
> +	struct net_device *ndev = db->ndev;
> +	char *sbuff = (char *)db->prxhdr;
> +	char hstr[72];
> +
> +	netdev_info(ndev, "dm9-pkt-Wrong RxLen over-range (%x= %d > %x= %d)\n",
> +		    rxlen, rxlen, DM9051_PKT_MAX, DM9051_PKT_MAX);
> +
> +	db->bc.large_err_counter++;
> +	db->bc.mac_ovrsft_counter++; //increase the MAC over_shift counter
> +	dm9051_fifo_reset(11, hstr, db);
> +	sprintf(hstr, "dmfifo_reset( 11 RxLenErr ) rxhdr %02x %02x %02x %02x (quick)",
> +		sbuff[0], sbuff[1], sbuff[2], sbuff[3]);
> +	netdev_info(ndev, "%s\n", hstr);
> +	netdev_info(ndev, "dm9 reset-done: of LargeRxLen\n");
> +	netdev_info(ndev, " RxLenErr&MacOvrSft_Er %d, RST_c %d\n",
> +		    db->bc.mac_ovrsft_counter,
> +		    db->bc.DO_FIFO_RST_counter);

There is a lot of kernel log spamming going on here. Please either
remove this, of use netdev_dbg(). Please look throught all the uses of
_info() and see if they are actually useful, or should be removed.

> +#define dm_msg_open_done(nd, maddr, irqn) \
> +	netdev_info(nd, "[dm_open] %pM irq_no %d ACTIVE_LOW\n", maddr, irqn)

Please don't use macros like this.

> +#define init_sched_phy(db) schedule_delayed_work(&(db)->phy_poll, HZ * 1)

No, no, no.

This code feels like it is a vendor crap driver, with an abstraction
over the OS. That is not how Linux drivers should work. If you need to
lock a mutux, call the mutex_lock(), not a wrapper around
mutex_lock. Please remove all these wrapper.

	    Andrew
