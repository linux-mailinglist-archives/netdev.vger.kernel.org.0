Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D8C281D01
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgJBUgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:36:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBUgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 16:36:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kORnF-00HJwv-Op; Fri, 02 Oct 2020 22:36:41 +0200
Date:   Fri, 2 Oct 2020 22:36:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201002203641.GI3996795@lunn.ch>
References: <20201002192210.19967-1-l.stelmach@samsung.com>
 <CGME20201002192216eucas1p16f54584cf50fff56edc278102a66509e@eucas1p1.samsung.com>
 <20201002192210.19967-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002192210.19967-3-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static u32 ax88796c_get_link(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +
> +	mutex_lock(&ax_local->spi_lock);
> +
> +	phy_read_status(ndev->phydev);
> +
> +	mutex_unlock(&ax_local->spi_lock);

Why do you take this mutux before calling phy_read_status()? The
phylib core will not be taking this mutex when it calls into the PHY
driver. This applies to all the calls you have with phy_

There should not be any need to call phy_read_status(). phylib will do
this once per second, or after any interrupt from the PHY. so just use

     phydev->link

> +static void
> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *_p)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	u16 *p = _p;
> +	int offset, i;
> +
> +	memset(p, 0, AX88796C_REGDUMP_LEN);
> +
> +	for (offset = 0; offset < AX88796C_REGDUMP_LEN; offset += 2) {
> +		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
> +			*p = AX_READ(&ax_local->ax_spi, offset);
> +		p++;
> +	}
> +
> +	for (i = 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
> +		*p = phy_read(ax_local->phydev, i);
> +		p++;

Depending on the PHY, that can be dangerous. phylib could be busy
doing things with the PHY. It could be looking at a different page for
example.

miitool(1) can give you the same functionally without the MAC driver
doing anything, other than forwarding the IOCTL call on.

> +int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc)
> +{
> +	struct ax88796c_device *ax_local = mdiobus->priv;
> +	int ret;
> +
> +	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
> +			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
> +
> +	ret = read_poll_timeout(AX_READ, ret,
> +				(ret != 0),
> +				0, jiffies_to_usecs(HZ / 100), false,
> +				&ax_local->ax_spi, P2_MDIOCR);
> +	if (ret)
> +		return -EBUSY;

Return whatever read_poll_timeout() returned. It is probably
-ETIMEDOUT, but it could also be -EIO for example.

> +ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 val)
> +{
> +	struct ax88796c_device *ax_local = mdiobus->priv;
> +	int ret;
> +
> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
> +
> +	AX_WRITE(&ax_local->ax_spi,
> +		 MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
> +		 | MDIOCR_WRITE, P2_MDIOCR);
> +
> +	ret = read_poll_timeout(AX_READ, ret,
> +				((ret & MDIOCR_VALID) != 0), 0,
> +				jiffies_to_usecs(HZ / 100), false,
> +				&ax_local->ax_spi, P2_MDIOCR);
> +	if (ret)
> +		return -EIO;
> +
> +	if (loc == MII_ADVERTISE) {
> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
> +			  P2_MDIOCR);
>

What is this doing?

> +		ret = read_poll_timeout(AX_READ, ret,
> +					((ret & MDIOCR_VALID) != 0), 0,
> +					jiffies_to_usecs(HZ / 100), false,
> +					&ax_local->ax_spi, P2_MDIOCR);
> +		if (ret)
> +			return -EIO;
> +	}
> +
> +	return 0;
> +}

> +static char *no_regs_list = "80018001,e1918001,8001a001,fc0d0000";
> +unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsigned long) * 8)];
> +
> +module_param(comp, int, 0444);
> +MODULE_PARM_DESC(comp, "0=Non-Compression Mode, 1=Compression Mode");
> +
> +module_param(msg_enable, int, 0444);
> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");

No module parameters allowed, not in netdev.

> +static int ax88796c_reload_eeprom(struct ax88796c_device *ax_local)
> +{
> +	int ret;
> +
> +	AX_WRITE(&ax_local->ax_spi, EECR_RELOAD, P3_EECR);
> +
> +	ret = read_poll_timeout(AX_READ, ret,
> +				(ret & PSR_DEV_READY),
> +				0, jiffies_to_usecs(2 * HZ / 1000), false,
> +				&ax_local->ax_spi, P0_PSR);
> +	if (ret) {
> +		dev_err(&ax_local->spi->dev,
> +			"timeout waiting for reload eeprom\n");
> +		return -1;

return ret not EINVAL which is -1

> +static int ax88796c_set_mac_address(struct net_device *ndev, void *p)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	struct sockaddr *addr = p;
> +
> +	if (!is_valid_ether_addr(addr->sa_data))
> +		return -EADDRNOTAVAIL;

It would be better to just use eth_mac_addr().

> +static int
> +ax88796c_check_free_pages(struct ax88796c_device *ax_local, u8 need_pages)
> +{
> +	u8 free_pages;
> +	u16 tmp;
> +
> +	free_pages = AX_READ(&ax_local->ax_spi, P0_TFBFCR) & TX_FREEBUF_MASK;
> +	if (free_pages < need_pages) {
> +		/* schedule free page interrupt */
> +		tmp = AX_READ(&ax_local->ax_spi, P0_TFBFCR)
> +				& TFBFCR_SCHE_FREE_PAGE;
> +		AX_WRITE(&ax_local->ax_spi, tmp | TFBFCR_TX_PAGE_SET |
> +				TFBFCR_SET_FREE_PAGE(need_pages),
> +				P0_TFBFCR);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct sk_buff *
> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
> +{
> +	if (netif_msg_pktdata(ax_local)) {
> +		char pfx[IFNAMSIZ + 7];
> +
> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
> +
> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
> +			    pkt_len, tx_skb->len, seq_num);
> +
> +		netdev_info(ndev, "  SPI Header:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       tx_skb->data, 4, 0);
> +
> +		netdev_info(ndev, "  TX SOP:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       tx_skb->data + 4, TX_OVERHEAD, 0);
> +
> +		netdev_info(ndev, "  TX packet:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       tx_skb->data + 4 + TX_OVERHEAD,
> +			       tx_skb->len - TX_EOP_SIZE - 4 - TX_OVERHEAD, 0);
> +
> +		netdev_info(ndev, "  TX EOP:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       tx_skb->data + tx_skb->len - 4, 4, 0);
> +	}

I expect others are going to ask you to remove this.

> +static void ax88796c_handle_link_change(struct net_device *ndev)
> +{
> +	if (net_ratelimit())
> +		phy_print_status(ndev->phydev);
> +}
> +
> +void ax88796c_phy_init(struct ax88796c_device *ax_local)
> +{
> +	/* Enable PHY auto-polling */
> +	AX_WRITE(&ax_local->ax_spi,
> +		 PCR_PHYID(0x10) | PCR_POLL_EN |
> +		 PCR_POLL_FLOWCTRL | PCR_POLL_BMCR, P2_PCR);

Auto-polling of the PHY is generally a bad idea. The hardware is not
going to respect the phydev->lock mutex, for example. Disable this,
and add a proper ax88796c_handle_link_change().

> +static int
> +ax88796c_open(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	int ret;
> +	unsigned long irq_flag = IRQF_SHARED;
> +
> +	mutex_lock(&ax_local->spi_lock);
> +
> +	ret = ax88796c_soft_reset(ax_local);
> +	if (ret < 0)
> +		return -ENODEV;
> +
> +	ret = request_irq(ndev->irq, ax88796c_interrupt,
> +			  irq_flag, ndev->name, ndev);

Maybe look at using request_threaded_irq(). You can then remove your
work queue, and do the work in the thread_fn.

> +	if (ret) {
> +		netdev_err(ndev, "unable to get IRQ %d (errno=%d).\n",
> +			   ndev->irq, ret);
> +		return -ENXIO;

return ret;

In general, never change a return code unless you have a really good
reason why. And if you do have a reason, document it.

> +static int
> +ax88796c_close(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +
> +	netif_stop_queue(ndev);
> +
> +	free_irq(ndev->irq, ndev);
> +
> +	phy_stop(ndev->phydev);
> +
> +	mutex_lock(&ax_local->spi_lock);
> +
> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
> +
> +	ax88796c_soft_reset(ax_local);
> +
> +	mutex_unlock(&ax_local->spi_lock);
> +	netif_carrier_off(ndev);

phy_stop() will do that for you.

> +static int ax88796c_probe(struct spi_device *spi)
> +{

> +	ax_local->mdiobus->priv = ax_local;
> +	ax_local->mdiobus->read = ax88796c_mdio_read;
> +	ax_local->mdiobus->write = ax88796c_mdio_write;
> +	ax_local->mdiobus->name = "ax88976c-mdiobus";
> +	ax_local->mdiobus->phy_mask = ~(1 << 0x10);

BIT(0x10);

> +
> +	ret = devm_register_netdev(&spi->dev, ndev);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to register a network device\n");
> +		destroy_workqueue(ax_local->ax_work_queue);
> +		goto err;
> +	}

The device is not live. If this is being used for NFS root, the kernel
will start using it. So what sort of mess will it get into, if there
is no PHY yet? Nothing important should happen after register_netdev().

> +
> +	ax_local->phydev = phy_find_first(ax_local->mdiobus);
> +	if (!ax_local->phydev) {
> +		dev_err(&spi->dev, "no PHY found\n");
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	ax_local->phydev->irq = PHY_IGNORE_INTERRUPT;
> +	phy_connect_direct(ax_local->ndev, ax_local->phydev,
> +			   ax88796c_handle_link_change,
> +			   PHY_INTERFACE_MODE_MII);
> +
> +	netif_info(ax_local, probe, ndev, "%s %s registered\n",
> +		   dev_driver_string(&spi->dev),
> +		   dev_name(&spi->dev));
> +	phy_attached_info(ax_local->phydev);
> +
> +	ret = 0;
> +err:
> +	return ret;
> +}
> +
> +static int ax88796c_remove(struct spi_device *spi)
> +{
> +	struct ax88796c_device *ax_local = dev_get_drvdata(&spi->dev);
> +	struct net_device *ndev = ax_local->ndev;

You might want to disconnect the PHY.

> +
> +	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
> +		   dev_driver_string(&spi->dev),
> +		   dev_name(&spi->dev));
> +
> +	destroy_workqueue(ax_local->ax_work_queue);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ax88796c_dt_ids[] = {
> +	{ .compatible = "asix,ax88796c" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ax88796c_dt_ids);
> +
> +static const struct spi_device_id asix_id[] = {
> +	{ "ax88796c", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(spi, asix_id);
> +
> +static struct spi_driver ax88796c_spi_driver = {
> +	.driver = {
> +		.name = DRV_NAME,
> +#ifdef CONFIG_USE_OF
> +		.of_match_table = of_match_ptr(ax88796c_dt_ids),
> +#endif

I don't think you need the #ifdef.

> +#ifndef _AX88796C_MAIN_H
> +#define _AX88796C_MAIN_H
> +
> +#include <linux/netdevice.h>
> +#include <linux/mii.h>
> +
> +#include "ax88796c_spi.h"
> +
> +/* These identify the driver base version and may not be removed. */
> +#define DRV_NAME	"ax88796c"
> +#define ADP_NAME	"ASIX AX88796C SPI Ethernet Adapter"
> +#define DRV_VERSION	"1.2.0"

DRV_VERSION are pretty pointless. Not sure you use it anyway. Please
remove.

> +	unsigned long		capabilities;
> +		#define AX_CAP_DMA		1
> +		#define AX_CAP_COMP		2
> +		#define AX_CAP_BIDIR		4

BIT(0), BIT(1), BIT(2)...

> +struct skb_data;
> +
> +struct skb_data {
> +	enum skb_state state;
> +	struct net_device *ndev;
> +	struct sk_buff *skb;
> +	size_t len;
> +	dma_addr_t phy_addr;
> +};

A forward definition, followed by the real definition?

> +	#define FER_IPALM		(1 << 0)
> +	#define FER_DCRC		(1 << 1)
> +	#define FER_RH3M		(1 << 2)
> +	#define FER_HEADERSWAP		(1 << 7)
> +	#define FER_WSWAP		(1 << 8)
> +	#define FER_BSWAP		(1 << 9)
> +	#define FER_INTHI		(1 << 10)
> +	#define FER_INTLO		(0 << 10)
> +	#define FER_IRQ_PULL		(1 << 11)
> +	#define FER_RXEN		(1 << 14)
> +	#define FER_TXEN		(1 << 15)

Isn't checkpatch giving warnings and suggesting BIT?

      Andrew
